%% A simulated annealing algorithm to improve the synchronizability
%% of networks through minimal link rewiring
%%                      by Yuanzhao Zhang (yuanzhao@u.northwestern.edu)

%% adjacency matrix of the original network
vtg = dlmread('Network1.txt');

%% M is the number of directional links in the original network
idx = find(vtg == 1);
M = size(idx,1);
%% construct Laplacian matrix
rowsum = sum(vtg,2);
lap = diag(rowsum) - vtg;
%% find eigen-ratio of the original network
eigv = sort(eig(lap));
r_original = eigv(end)/eigv(2)
%% target value of the eigen-ratio
r_target = r_original/2 + .5

%% number of independent simulated annealings to be performed
N = 5*1e4;
%% m records the number of links rewired before the target eigen-ratio is reached at each run
m = zeros(1,N);
% inverse temperature used in simulated annealings (different for each run)
Beta = linspace(50,500,N);

%% do N independent simulated annealings
for i = 1:N
    adj = vtg;
    r_new = r_original;
    r_current = r_original;
    beta = Beta(i);
    %% start of simulated annealing
    while r_new > r_target
        aij = adj;
        %% at each iteration between 1 to 4 links will be randomly rewired
        num_rewire = randi(4);
        idx = find(adj == 1);
        del_link = idx(randperm(size(idx,1),num_rewire));
        aij(del_link) = 0;
        ind = find(adj == 0);
        add_link = ind(randperm(size(ind,1),num_rewire));
        aij(add_link) = 1;
        %% find the eigen-ratio of the rewired network
        rowsum = sum(aij,2);
        lap = diag(rowsum) - aij;
        %% next line requires newer version of MATLAB
        eigv = sort(eig(lap),'ComparisonMethod','real');
        r_new = real(eigv(end))/real(eigv(2));
        %% energy is negative if the eigen-ratio is improved by rewiring
        energy = r_new/min(r_original,r_current)-1;

        %% Metropolis criterion
        if rand < exp(-beta*energy)
            adj = aij;
            r_current = r_new;
            m(i) = m(i)+num_rewire;
            %% if more than M rewirings have been performed, abort this run
            if m(i) > M
                break
            end
        end
    end
    %% if the target eigen-ratio is reached
    if r_current <= r_target
        m(i) = size(find(vtg-adj==1),1);
        %% if this successful run needs the smallest number of rewirings so far
        if m(i) == min(m(1:i))
            %% print the number of links rewired
            minimal_num = m(i)
            %% print the percentage of links rewired
            rewire_ratio = minimal_num/M
            %% write the optimized newtork to file
            dlmwrite('Network1_opt.txt',adj)
        end
    end
end
