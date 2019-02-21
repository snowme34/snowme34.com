# Binary Tree Traversal

A binary tree is a tree in which no degree of nodes is larger than 2.

Each non-null node has one left child and one right child
(imagine that the leaf node has 2 NULL children).

## Ways to Traverse

X is the current node

| Traversal  | Order |
| ---------- | ----- |
| Pre-order  | X L R |
| In-order   | L X R |
| Post-order | L R X |

The recursive way is extremely obvious and easy but not always stack-friendly.

Note this is a "good" example to refute "To iterate is human, to recurse divine"
(i.e. to iterate the recursive is programmer).

The following ones are just some ways to achieve traversal. There are plenty of
alternatives.

## Successor

The direct successor of a node.

```c++
Node* successorOf(Node* n){
  if(!n) return nullptr;
  if(n->rc) { // leftmost child of rc
    n = n->rc; while(n->lc) n = n->lc;
  } else { // parent of the ancestor that has n in its right sub tree
    while(n->parent && n->parent->rc && n->parent->rc==n) n = n->parent;
    n = n->parent;
  }
  return n;
}
```

## Pre-Order Traversal

Obvious recursive way:

```c++
template<typename F>
void preOrderTraverse(Node* x, F& visit) {
  if(!x) return;
  visit(x);
  preOrderTraverse(x->lc, visit);
  preOrderTraverse(x->rc, visit);
}
```

Easy to convert since it looks like 2 tail recursions.

Iterative way using the "left branch first" strategy:

```c++
template<typename F>
void preOrderTraverseIterative(Node* root, F& visit) {
  stack<Node*> st;
  if(root) st.push(root);
  while (!st.empty()) {
    auto *x = st.top();
    st.pop();
    while (x) {
      visit(x);
      if(x->rc) st.push(x->rc);
      x = x->lc;
    }
  }
}
```

Since for a tree that has a normal size, the number of NULL nodes are far
less than the number of the other nodes, it is not worth it to check
NULL each time.

Remove null check (is it good?):

```c++
template<typename F>
void preOrderTraverseIterative(Node* root, F& visit) {
  stack<Node*> st;
  st.push(root);
  while (!st.empty()) {
    auto *x = st.top();
    st.pop();
    while (x) {
      visit(x);
      st.push(x->rc);
      x = x->lc;
    }
  }
}
```

## In-Order Traversal

Obvious recursive way:

```c++
template<typename F>
void inOrderTraverse(Node* x, F& visit) {
  if(!x) return;
  preOrderTraverse(x->lc, visit);
  visit(x);
  preOrderTraverse(x->rc, visit);
}
```

Traversal for right subtree is tail recursive but the left one is not.

But we can apply the similar strategy.

```c++
template<typename F>
void inOrderTraverseIterative(Node* x, F& visit) {
  stack<Node*> st;
  while(x || !st.empty()) {
    if (x) {
      st.push(x);
      x = x->lc;
    } else { // x is null and stack is non-empty
      x = st.top();
      st.pop();
      visit(x);
      x = x->rc;
    }
  }
}
```

Another way

```c++
template<typename F>
void inOrderTraverseIterative(Node* x, F& visit) {
  while(1) {
    if(x->lc) {
      x=x->lc;
    } else {
      visit(x);
      while(!x->rc) {
        if(!successorOf(x)) return;
        visit(x);
      }
      x=x->rc;
    }
  }
}
```

## Post-Order Traversal

Obvious recursive way:

```c++
template<typename F>
void postOrderTraverse(Node* x, F& visit) {
  if(!x) return;
  preTraverse(x->lc, visit);
  preTraverse(x->rc, visit);
  visit(x);
}
```

Hard to convert directly since both are not tail recursions.

Here is one iterative way using the "highest reachable left leaf" strategy.

```c++
template<typename F>
void postOrderTraverseIterative(Node* x, F& visit) {
  stack<Node*> st;
  if(x) st.push(x);
  while(!st.empty()) {
    if(x->parent != st.top()) {
      while(auto y = st.top()) {
        if(y->lc) {
          if(y->rc) st.push(y->rc);
          st.push(y->lc);
        } else {
          st.push(y->rc);
        }
      }
      st.pop();
    }
    x = st.top();
    st.pop();
    visit(x);
  }
}
```

## Read More

[Post order traversal of binary tree without recursion - Stack Overflow](https://stackoverflow.com/questions/1294701/post-order-traversal-of-binary-tree-without-recursion)