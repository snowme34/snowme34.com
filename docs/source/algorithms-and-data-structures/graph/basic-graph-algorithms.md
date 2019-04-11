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