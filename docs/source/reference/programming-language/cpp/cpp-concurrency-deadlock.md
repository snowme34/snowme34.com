# C++ Concurrency Deadlock

A deadlock happens when 2 or more threads wait for each other (including themselves)
to take actions for resources, such as releasing a lock.

* process p1 locks resource r1 and needs access to resource r2
* process p2 locks resource r2 and needs access to resource r1

```cpp
class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_0() {
    std::lock_guard<std::mutex> locker_0(mtx_0);
    std::lock_guard<std::mutex> locker_1(mtx_1);
    // do something
    std::cout << "do_0" << std::endl;
  }
  void do_1() {
    std::lock_guard<std::mutex> locker_1(mtx_1);
    std::lock_guard<std::mutex> locker_0(mtx_0);
    // do something
    std::cout << "do_1" << std::endl;
  }
};

void f_0(A_Class& o) {
  for(int i = 0; i < 100; ++i) {
    o.do_0();
  }
}

void f_1(A_Class& o) {
  for(int i = 0; i < 100; ++i) {
    o.do_1();
  }
}

int main() {
  A_Class o;
  std::thread t1(f_0, std::ref(o));
  std::thread t2(f_1, std::ref(o));
  t2.join(); t1.join();
  return 0;
}
```

## Conditions

There are 4 required conditions for deadlock to happen:

* Mutual Exclusion
  * At least one resource is non-sharable. It can only be used by one process at one time
* Hold and Wait
  * At least one process is "holding" one resource and "waiting" for another process to release another resource
* No Preemption
  * Only the process "holding" one resource can release it voluntarily
* Circular Wait
  * There exists a set of processes such that p_i is waiting for the resource hold by p_i+1 (p_n is waiting for the resource hold by p_0)

## Handling

1. prevention
2. detection and recovery
3. ignore ([Ostrich algorithm - Wikipedia](https://en.wikipedia.org/wiki/Ostrich_algorithm))

This page is not going to cover those details (yet)

## Avoidance When Programming in C++

Try to avoid logic that requires multiple locks.

* lock one lock at a time

```cpp
class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_2() {
    {
      std::lock_guard<std::mutex> locker_0(mtx_0);
      ;
      std::cout << "do_2" << std::endl;
    }
    {
      std::lock_guard<std::mutex> locker_1(mtx_1);
      ;
      std::cout << "do_2" << std::endl;
    }
  }
};
```

Don't call a function from argument after locking.

```cpp
typedef void (* ArgFunc)(int a);

class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_f(ArgFunc f) {
    std::scoped_lock lock(mtx_0, mtx_1);
    f(1); // don't do this call
  }
};
```

Use algorithm (library function).

* [std::lock](https://en.cppreference.com/w/cpp/thread/lock)
  * c++ 11
* [std::scoped_lock](https://en.cppreference.com/w/cpp/thread/scoped_lock)
  * c++ 17

```cpp
class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_0() {
    std::lock(mtx_0, mtx_1)
    std::lock_guard<std::mutex> locker_0(mtx_0, std::adopt_lock);
    std::lock_guard<std::mutex> locker_1(mtx_1 , std::adopt_lock);
    // do something
    std::cout << "do_0" << std::endl;
  }
  void do_1() {
    std::lock(mtx_0, mtx_1)
    std::lock_guard<std::mutex> locker_1(mtx_1, std::adopt_lock);
    std::lock_guard<std::mutex> locker_0(mtx_0, std::adopt_lock);
    // do something
    std::cout << "do_1" << std::endl;
  }
};
```

```cpp
class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_0() {
    std::scoped_lock lock(mtx_0, mtx_1);
    // do something
    std::cout << "do_0" << std::endl;
  }
  void do_1() {
    std::scoped_lock lock(mtx_0, mtx_1);
    // do something
    std::cout << "do_1" << std::endl;
  }
};
```

Use same lock order.

* Multiple level mutex
  * if a thread locks a low-level mutex, it cannot lock a high-level one

```cpp
class A_Class {
  std::mutex mtx_0;
  std::mutex mtx_1;
public:
  void do_0() {
    std::lock_guard<std::mutex> locker_0(mtx_0);
    std::lock_guard<std::mutex> locker_1(mtx_1);
    // do something
    std::cout << "do_0" << std::endl;
  }
  void do_1() {
    std::lock_guard<std::mutex> locker_0(mtx_0);
    std::lock_guard<std::mutex> locker_1(mtx_1);
    // do something
    std::cout << "do_1" << std::endl;
  }
};
```

## Starvation and Livelock

Two problems that are less common than deadlocks

Starvation happens when a process never gains access to one necessary resource.

It may be a result of bad scheduling algorithm which never schedules some resources to
some processes.

Livelock happens when thread A takes actions in response of thread B and B also takes
actions in response of A. Like 2 people walk on the street towards each other, person A
takes left turn, person B takes right turn. Same things happens again and again.
They both responses (not waiting) but still cannot proceed.

It may be a result of deadlock recovery. Both threads takes actions and the same
recovery algorithm is repeatedly triggered.

## Granularity

Think about what resources are to be protected when designing locks.

Based on [herlihy4-5-presentation](http://fileadmin.cs.lth.se/cs/education/eda015f/2013/herlihy4-5-presentation.pdf):

* Coarse-grained locking
  * One lock
  * Large number of resources
* Fine-grained locking
  * More than one lock
  * Small number of resources

More coarse-grained locks lead to higher possibility for one process to
wait for another one, resulting in more waiting time, which is bad for parallelism.

More fine-grained locks lead to more trouble managing them and increase the possibility
of dead locks.

## Reference/Read More

* [Operating Systems: Deadlocks](https://www.cs.uic.edu/~jbell/CourseNotes/OperatingSystems/7_Deadlocks.html)
* [Deadlock - Wikipedia](https://en.wikipedia.org/wiki/Deadlock)
* [Deadlock prevention algorithms - Wikipedia](https://en.wikipedia.org/wiki/Deadlock_prevention_algorithms)
* [Deadlock (The Java™ Tutorials > Essential Classes > Concurrency)](https://docs.oracle.com/javase/tutorial/essential/concurrency/deadlock.html)
* [Starvation and Livelock (The Java™ Tutorials > Essential Classes > Concurrency)](https://docs.oracle.com/javase/tutorial/essential/concurrency/starvelive.html)
* [C++ Threading #4: Deadlock](https://www.youtube.com/watch?v=_N0B5ua7oN8&list=PL5jc9xFGsL8E12so1wlMS0r0hTQoJL74M&index=4)
* [Coarse-grained and fine-grained locking](http://fileadmin.cs.lth.se/cs/education/eda015f/2013/herlihy4-5-presentation.pdf):
* [terminology - Distributed vs parallel computing - Computer Science Stack Exchange](https://cs.stackexchange.com/questions/1580/distributed-vs-parallel-computing)