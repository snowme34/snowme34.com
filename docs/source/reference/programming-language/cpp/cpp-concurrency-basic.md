# C++ Concurrency Basic

## Multiprocessing and Multithreading

Multiprocessing happens when there are multiple processes running
and they inter-process communicate.

Multithreading happens when multiple threads are running and
they use shared memory.

Since creating another process takes time and more system resources,
multithreading is faster to start and costs less.

But multithreading is harder to implement and it cannot be run on
distributed computing.

## Thread

[thread - C++ Reference](http://www.cplusplus.com/reference/thread/thread/)

```cpp
void sleep(int s) {
  std::this_thread::sleep_for (std::chrono::seconds(n));
  std::cout << "slept for " << s << "seconds" << std::endl;
}

void func() {

}

void funcStr(string& s) {

}

struct Functor {
  Functor(int v) : v(v) {}
  int operator()(int x) { return v = v + x; }
private:
  int v;
};

int main() {
  std::thread t1(func); // thread t1 starts running
  // t1.join();         // main thread (calling thread) will wait for t1 to finish
  t1.detach();          // t1 is detached, executed independently

  std::thread (sleep,10).detach(); // if main thread exit before 10 seconds
                                   // will not show the print statement

  //t1.join();        // trying to join a detached thread, will crash
  if(t1.joinable()) { // check
    t1.join();
  }

  /*
   * thread can also be created using any callable objects
   * such as functors and lambda functions
   */

  Functor f1(0);
  std::thread t2(f1,1); // note f1 is a "closure"
  //std::thread t3(Functor()); // not work, this is a function declaration
  std::thread t3((Functor()));

  /*
   * more efficient parameter
   */

  // pass by reference
  // constructors of thread take *decay copies*
  string s = "";
  std::thread ts(funcStr, std::ref(s)); // we can use either ref or ptr (ptr way not shown)
                                        // but 2 threads share the same memory, potential data race
  
  // if we don't want to pass by value and we don't need to access s in calling thread later
  // we can move s to child thread
  std::thread ts(funcStr, std::move(s)); // both efficient and safe

  /*
   * thread is not copy-able
   */
  std::thread t1_move = std::move(t1); // t1 now is "empty", its thread is now owned by t1_move

  /*
   * thread id
   */
  std::cout << std::this_thread::get_id() << std::endl();

  /*
   * oversubscription
   * it happens when number of threads goes beyond the number supported
   * by the hardware, leading to too much context switching, resulting
   * in bad performance
   */
  std::cout << std::thread::hardware_concurrency() << std::endl;
}
```

A thread can be joined or detached only once.

If a thread is neither joined nor detached before it goes out of scope,
it will be destroyed (terminate() will be called)
and potentially will not do what the caller expects.

[Why .join is still necessary when all other thread have finished before the main thread?](https://stackoverflow.com/questions/22905207/why-join-is-still-necessary-when-all-other-thread-have-finished-before-the-main)

```cpp
void func() {

}

void demo_join() {
  // we always want to join the thread here

  // method 1: try catch

  std::thread t1(func); // thread t1 starts running
  // join right away makes no sense for multithreading
  // do some work before join
  
  try {
    //...
  } catch (...) { // bad catch design, for demo only
    t1.join();
    throw;
  }

  t1.join();

  // method 2: RAII
  // create a wrapper class whose destructor calls t1.join()
  // https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization
}

int main() {
  demo_join();
}
```
