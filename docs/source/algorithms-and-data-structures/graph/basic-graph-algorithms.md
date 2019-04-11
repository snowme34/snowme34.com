# Basic Graph Algorithms

Basic

## Bipartite

No adjacent same color

No odd-number-edge cycles

## Search

* DFS: Stack
* BFS: Queue

| Problem                                             | Algorithm |
| --------------------------------------------------- | --------- |
| DFS/BFS Tree                                        | DFS/BFS   |
| DFS/BFS Tree (disconnected)                         | DFS/BFS   |
| Connectivity                                        | DFS/BFS   |
| Cycle in Undirected Graph                           | DFS/BFS   |
| Cycle in Directed Graph                             | DFS       |
| Reachability of vertices                            | DFS/BFS   |
| Shortest Distance of vertices                       | BFS       |
| Diameter                                            | BFS       |
| Eulerian Tour                                       | DFS       |
| Topological Sort                                    | DFS       |
| Biconnected component, Strongly Connected Component | DFS       |

## Shortest Path

### Bellman-Ford

Bellman is the inventor of DP

Works if no negative cycles but can detect

Run (n-1) rounds to update shortest path from source node

```cpp
vector<int> dist = vector<int>(n+1,INF);
dist[s] = 0;
for(int i = 1; i <= n-1; ++i) {
  for(auto e:edges) {
    // a: start node, b: end node, w: weight
    int a = e->a, b = e->b, w = e->w;
    dist[b] = min(dist[b], dist[a] + w);
  }
}
```

### Dijkstra's

Graph Search using priority queue.

Multiple by `-1` to make the min_heap of c++ a max_heap.

```cpp
x->dist = 0;

pq.push(make_pair(-x->dist,x));

while (!pq.empty()) {
  auto t = pq.top(); pq.pop();
  Node* n = t.second;
  int d = -t.first;
  if (!n->done) {
    n->done = 1;
    for (auto ne : n->neighbors) {
      if (n->dist + d < ne->dist) {
        ne->prev = n;
        ne->dist = n->dist + d;
        pq.push(make_pair(-ne->dist, ne));
      }
    }
  }
}
```

### Floyd-Warshall

Find shortest path from anywhere to anywhere.

Use an adjacency matrix. Store results in a distance matrix.

Select a node and try to reduce dist using this node.

Initialize distance matrix:

```cpp
for(int i = 1; i <= n; ++i) {
  for(int j = 1; j <= n; ++j) {
    if(i == j) dist[i][j] = 0;
    else if(adj[i][j]) dist[i][j] = adj[i][j];
    else dist[i][j] = INF;
  }
}
```

Find:

```cpp
for (int k = 1; k <= n; ++k) {
  for (int i = 1; i <=n; ++i) {
    for (int j = 1; j <=n; ++j) {
      dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
    }
  }
}
```

## Spanning Tree

### Kruskal's

Add edges from min until connected.

Use Union-Find to test connectivity.

```cpp
sort(edges.begin(), edges.end());
for(auto e:edges) {
  auto s = e->s, t = e->t;
  if(!connected(s,t)) union(s,t);
}
```

Will include sample union-find code in the future.

### Prim's

First choose a random node

Use priority queue to find the next edge that adds a new node

*Bad* implementation below (not tested or even compiled):

```cpp
int n_nodes = graph.n_nodes(); // total number of nodes

x->done = 1; n_nodes -= 1;

for (auto ne : x->edges) {
  pq.push(make_pair(-ne->dist, ne->node));
}

while (n_nodes && !pq.empty()) {
  auto t = pq.top(); pq.pop();
  Node* n = t.second;
  if (!n->done) {
    n->done = 1; n_nodes -= 1;
    for (auto ne : n->edges) {
      if (ne->node->done) continue;
      pq.push(make_pair(-ne->dist, ne->node));
    }
  }
}
```

Ideally we should update the priority somehow, i.e. no duplicated edges in queue.

## Topological Sort

No cycle allowed

3 states:

* 0: not discovered
* 1: processing
* 2: processed

Run DFS, add to ans when a node is 2.

Order of answer is "reversed".

```cpp
vector<int> adj[N];
vector<bool> visited(N, false);
vector<int> order;
void t_sort(int u) {
  if (visited[u]) { return; }

  visited[u] = true;

  for (int i = 0; i < adj[u].size(); ++i) {
    t_sort(adj[u][i]);
  }

  order.push_back(u);
}

for (int u = 0; u < n; u++) {
  t_sort(u);
}
```

## Reference

* [DS](https://dsa.cs.tsinghua.edu.cn/~deng/ds/index.htm)
* [Competitive programming books](https://cses.fi/book/index.html)
* [Graph - Unweighted Graphs](https://algo.is/aflv16/aflv_07_graphs_1.pdf)