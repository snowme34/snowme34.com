# C++ Concurrency Data Race

## Data Race

Data race happens when

* at least 2 threads in a single process access the same memory concurrently
* at least one of the accesses is write
* no exclusive locks control the access

```cpp
void f() {
  for(int i = 0; i < 100; ++i) {
    std::cout << i << std::endl;
  }
}

int main() {
  std::thread t1(f);
  std::thread t2(f);
  t2.join(); t1.join();
  return 0;
}
```

The access to cout is not synced so the order of output is not fixed.
(by order of output it means the newline characters etc. are messed together,
not the exact order of execution)

## Mutex

Naive usage:

```cpp
std::mutex mtx;

void print(std::string s) {
  mtx.lock();
  std::cout << s << std::endl;
  mtx.unlock();
}

void f() {
  for(int i = 0; i < 100; ++i) {
    print(std::to_string(i));
  }
}
```

This looks good but will lock forever in some cases. For instance, if cout statement
throws an exception then the unlock() will never be executed.

Using lock() and unlock() directly is discouraged. Should use lock guard.

Better usage:

```cpp
void print(std::string s) {
  std::lock_guard<std::mutex> locker(mtx);
  std::cout << s << std::endl;
}
```

Since cout is shared globally so our naive locker still fails to protect the shared resource here.

Normal usage:

```cpp
class TheOutput {
  std::mutex mtx;
  std::ofstream f; // f is completely protected by mutex if and only if there is no
                   // outside access, i.e. no user access to f (return f or pass f to an outside function)
public:
  explicit TheOutput(std::string outFile) {
    f.open(outFile);
  }
  ~TheOutput() {
    f.close();
  }
  void print(std::string s) {
    std::lock_guard<std::mutex> locker(mtx);
    f << s << std::endl;
  }
};

void f(TheOutput& o) {
  for(int i = 0; i < 100; ++i) {
    o.print(std::to_string(i));
  }
}

int main() {
  TheOutput o("out.txt");
  std::thread t1(f, std::ref(o));
  std::thread t2(f, std::ref(o));
  t2.join(); t1.join();
  return 0;
}
```

Looks safe, but what if we have multiple operations?

```cpp
/* a naive and bad implementation of stack */
class stack {
  std::vector<int> _data;
  int _sz;
  std::mutex _mtx;
public:
  stack() {
    this->_sz = 0;
    this->_data = std::vector<int>();
  }
  void pop() { // bad design
    std::lock_guard<std::mutex> locker(_mtx);
    _sz -= _sz > 0 ? 1 : 0;
  }
  int top() { // bad design
    std::lock_guard<std::mutex> locker(_mtx);
    return _sz > 0 ? _data[_sz-1] : -1;
  }
  void push(int i) { // bad design
    std::lock_guard<std::mutex> locker(_mtx);
    if(_data.size() == _sz) {
      _data.push_back(i);
    } else { // size() > _sz
      _data[_sz] = i;
    }
    _sz += 1;
  }
};

void func(stack& st) {
  int t = st.top();
  st.pop();
}
```

In func, it takes the top value from the stack then pop it.

Looks like everything is fine. But if there is a different thread which
changes the stack after the top() statement of func, then func is popping
a different value from t, a problem.

One solution is to return the value directly from pop(). But the resulting
function will not be exception safe.

```cpp
//...
int pop();
//...
```

In brief, to avoid data race:

1. use mutex to sync access
2. no direct access to resources from user
3. be careful with multiple-step operations