# Red Black Tree

"Oh, how I wish that I had a daughter that had skin as white as snow, lips as **red** as blood, and hair as **black** as ebony." - [The Story of Snow White and the Seven Dwarves](https://www.cs.cmu.edu/~spok/grimmtmp/042.txt)

Feel free to use online visualization tools if pure text is confusing, like [this one](https://www.cs.usfca.edu/~galles/visualization/RedBlack.html) and please draw the trees on your own while reading.

For practice, try to draw the resulting tree in each step while inserting nodes from 1 to 12.

## Motivation

Persistent structure

## Rules for a Legal Red Black Tree

Add null nodes as external nodes to make the tree a "full binary tree".

Black height is the number of black nodes from an external node to a specific node.
Namely, it's the height of a node when we don't consider red nodes.

Here we [define](https://xlinux.nist.gov/dads/HTML/height.html) height of empty tree to be -1
and tree with only one node with height 0.

Rules:

1. Root is black
2. External nodes are black
3. Red node can only have black children
4. There are same number of black nodes in all paths from external nodes to the root (Black height)

Therefore, RBTree is just a 2-3-4 tree where the black and its red children
(if any) form a node in 2-3-4 tree. A legal node is just RBR or RB or BR or B.

## Basic Definition

Suppose we are doing operations on node x, whether it's insertion or deletion.

* Parent(p): the parent node of x
* Grandparent(g): the parent of parent
* Sibling(s): another child of the parent
* Uncle(u): sibling of parent
* Replacement(r): replacement of a node that was deleted (using remove() from bst)

```c++
p = x->parent;
g = p->parent;
s = (x == p->lc) ? p->rc : p->lc;
u = (p == g->lc) ? g->rc : g->lc;
r = bst_remove(x) // the remove function from bst
```

## Crash Course on Remove of BST (optional)

children = {lc, rc}

To remove node x, there are only 2 cases:

1. One of children is empty ( isEmpty(lc) or isEmpty(rc) )
    * replace the x with the non-empty one if exists
2. None of children is empty !( isEmpty(lc) or isEmpty(rc) )
    * find its successor, note this successor has no lc
    * exchange x and this successor (also exchange color for rbtree node)
    * go to 1
3. Return r, the replacement

And we say the new node in the original position is the replacement of the node removed.

Note that x and r means the x and r in the last step.
We can only remove x when any least one of its children is null.

And r is the replacement (one of x's child) at the last step. Not the successor that
replace the node x at the step 2.

## Node

The following implementation assumes the node has the following member variables and functions

* lc: left child
* rc: right child
* parent: parent
* height: black height
* color: color
* update_height(): update the black height using the heights and colors of children
* is_black(): return true if color is black or is null node
* ...

## 3+4 Reconstruction (Optional)

Note for balanced binary search trees, all rotations are identical in one aspect: there are
always 3 nodes and 4 sub-trees where the imbalance happens among the 3 nodes.

The following 2 pictures cover 2 rotation scenarios, the other 2 cases are symmetric.

![Imgur](https://i.imgur.com/0NUK9Cr.png)

![Imgur](https://i.imgur.com/Q4VTGzT.png)

The rotation is just manipulation of pointers. We just reassign the parent pointers,
left and right children pointers etc.

![Imgur](https://i.imgur.com/QRqzWpu.png)

As shown above, this is a balanced structure, i.e. the resulting structure of any rotations
that attempted to fix imbalance.

For all rotations, we can use one identical sub-procedure where we remember the pointers
to the sub-trees and pointers of a,b,c to each other. And we simply reconstruct this local
structure by reassigning the pointers. So that we don't need to write a procedure for each
case and debug each one separately and thus "**don't repeat yourself**".

## Insertion

### Double Red Problem

All new nodes are colored red upon insertion.

Rule #1, #2, #4 is easy to satisfy, but #3 is not.

Therefore, we need to solve double-red problem if a red node has a red parent.

We will either rotate or re-color based on the color of uncle.

If the uncle is black, we do 3+4 reconstruction, color parent black, color x or g red.
And the double red problem is solved since no "red" is propagated upwards.

This is same as we have RRB or BRR in 2-3-4 b-tree.

If the uncle is red, color p and u black, color g red. Since g is colored red, a "red"
if propagated upwards, we recursively solve double red problem at g.

This is same as we have a overflow in 2-3-4 b-tree.

### Pseudocode for Insertion

Pseudocode for inserting:

```pseudocode
// depends on the implementation, may or may not be able to insert duplicates
function rb-insert(data e)
  create node x from e

  Insert node x using insertion of binary search tree
  
  if p not exists
    set root to x
    increase root's black height by 1
    color x black
    return
  
  color x red
  
  check and solve double-red problem
```

Pseudocode for solving double-red problem:

```pseudocode
function solve-double-red(node x)
  if x is root
    color x black
    increase root's black height by 1
    return
  
  if p is black
    // no more double-red
    return

  // check color of uncle
  if u is black
    color g red

    if x and p is same side of g
      rotate left or right
      color p black
      link the nodes properly

    if x and p not same side of g
      rotate leftRight or rightLeft
      color x black
      link the nodes properly

  else
    color parent and uncle black
    color grandparent red if not root
    solve-double-red(g)
```

### Complexity for insertion

rotation = 2 means we do a double rotation (or a "3+4" reconstruction)

| uncle color | rotations | recoloring | result                           |
| ----------- | --------- | ---------- | -------------------------------- |
| black       | 1 or 2    | 2          | done                             |
| red         | 0         | 3          | propagate upwards to grandparent |

## Deletion

Note I'm not using the same deletion algorithm as the
[visualization](https://www.cs.usfca.edu/~galles/visualization/RedBlack.html) does.

This visualization also uses a strange implementation of removal for BST.

The algorithm here has same result as [Geeks for Geeks](https://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/) does.

### Double Black Problem

Denote the node to remove as x,
the replacement (r will be a direct children of x) of x as r,
the sibling of r as s.

When removing a node, using the removal algorithm from binary search tree,
we will have a replacement node (can be null) for x.

It's easy to satisfy #1 and #2.

If any one of x and r is red, then it's easy to satisfy #3 and #4.

If x or r is red (cannot be red in the same time since x is direct parent of r),
simply put r at x's place and color r black. In this way, the black height will
not change. Same as we are removing a red node and red node does not affect the
black height in the whole tree.

If x and r are both red, we are removing a black height in the whole tree.
This is very complicated.

We have 4 cases baed on the colors of p (parent of x, and parent of r as well)
and s (sibling of r) and t (red child of s if any).

Since it's less clear than pseudocode, the text description of the algorithm is omitted here,
and become "comments" in the pseudocode.

### Pseudocode for Deletion

Pseudocode for remove

```pseudocode
function is-balanced(node x)
  // height here is black height
  // simply excluding red nodes when calculating height as normal
  // black x's height should be 1 + (any one of) its child's height
  // red x's height should be (any one of) its child' height
  if height of lc is same as height of rc and height of x is correct
    return true
  return false

function remove-rb(data e)
  search e in tree

  if x not in tree
    return false
  
  remove x using remove of binary search tree and let r be the replacement

  if empty
    return true

  if root was removed
    color new root, assigned by bst's remove, black
    update black height
    return true

  if the parent's black height is balanced
    // then all the ancestors are balanced
    return true

  if r is red
    color r black
    r->height += 1
    return true

  // now the black height is not balanced
  
  solve-double-black(p, r) // r can be null
```

Pseudocode for solving double-black problem:

```pseudocode
function solve-double-black(node p, node r)  // p and r are black
  let p be parent of r if not properly set already
  
  if p is null // root
    return

  let s be r's sibling

  if s is black
    if s has red child // black s with at least one red child, "DB-BSRC"
      let t be red child of s

      do 3+4 reconstruction or rotation for t, s, x // s will be parent of t and p
      assign the pointers properly

      // keep r black
      color s the color of p
      color t and p black
      update heights for t, s, x

      return // we are done since the lost one black height is back
      // this is the same as using rotation to solve underflow in 2-3-4 b-tree

    else // s has no red children
      // keep r black
      color s red
      decrement black height of s

      if p is red // black s with no red child and red p, "DB_BSRP"
        color p black
        return // we are done since the black height is again balanced
        // this is the same as merge underflow node with its sibling

      else // black s with no red child and black p, "DB_BSBP"
        // now we must decrease the black height
        // there is no way to make up for the lost one "black"
        decrement black height of p
        // this is only a local fix
        // the double black problem is propagated up
        // may propagate up to root
        solve-double-black(p->parent, p)
        // this is the same as merge underflow super node with its sibling
        // but the parent super node has only one node

  else // s is red, both of its children are black, "DB_RS"
    color s black
    color p red
    rotate so that s becomes parent of p
    // or do 3+4 reconstruction at r where r is the child of s on the same side of s

    // continue to solve double black problem on r
    solve-double-black(p, r)
    // now we have a red p, the next call can never be "DB_BSBP"
    // therefore will not propagate upwards
```

### Complexity of solve-double-black

| case    | sibling color | sibling has red child | parent color | rotations | recoloring | result                             |
| ------- | ------------- | --------------------- | ------------ | --------- | ---------- | ---------------------------------- |
| DB_BSRC | black         | 1                     | N/A          | 1 or 2    | 3          | done                               |
| DB_BSRP | black         | 0                     | red          | 0         | 2          | done                               |
| DB_BSBP | black         | 0                     | black        | 0         | 2          | propagate upwards one level        |
| DB_RS   | red           | N/A                   | N/A          | 1         | 2          | become DB_BSRC or DB_BSRP and done |

At most recoloring O(log n) times, 1 or 2 rotation (1 "3+4 reconstruction")