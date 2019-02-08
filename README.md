This is a simulated annealing algorithm to improve network synchronizability through minimal link rewiring, removal, or addition.

The algorithm was developed for the paper listed below:

J. D. Hart, Y. Zhang, R. Roy and A. E. Motter, Topological Control of Synchronization Patterns: Trading Symmetry for Stability, Phys. Rev. Lett. 122, 058301 (2019)
https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.122.058301

It includes:

1. optimize_eigratio_rewire.m

  Matlab implementation of a simulated annealing algorithm that optimizes network synchronizability through minimal link rewiring.
  
2. optimize_eigratio_remove.m

  Matlab implementation of a simulated annealing algorithm that optimizes network synchronizability through minimal link removal.
  
3. optimize_eigratio_add.m

  Matlab implementation of a simulated annealing algorithm that optimizes network synchronizability through minimal link addition.
  
4. Network1.txt

  Adjacency matrix of the 16-node network used as an example in the three implementations.
  
  
All three programs can be run directly in Matlab. One can customize the initial network by supplying the adjacency matrix of the network in a text file. 
