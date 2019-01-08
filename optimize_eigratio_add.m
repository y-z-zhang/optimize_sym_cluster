% A simulated annealing algorithm to improve the synchronizability 
% of networks through minimal link addition 
%                      by Yuanzhao Zhang (yuanzhao@u.northwestern.edu)

% adjacency matrix of the original network
vtg = dlmread('Network1.txt');
% n is the size of the network
n = size(vtg,1);

% M is the number of directional links in the original network
idx = find(vtg == 1);
M = size(idx,1);
% construct Laplacian matrix
rowsum = sum(vtg,2);
lap = diag(rowsum) - vtg;
% find eigen-ratio of the original network
eigv = sort(eig(lap));
r_original = eigv(end)/eigv(2)
% target value of the eigen-ratio
r_target = r_original/2 + .5

% number of independent simulated annealings to be performed
N = 5*1e4;
% m records the number of links added before the target eigen-ratio is reached at each run
m = zeros(1,N);
% inverse temperature used in simulated annealings (different for each run)
Beta = linspace(50,500,N);

% do N independent simulated annealings
for i = 1:N
    adj = vtg;
    r_new = r_original;
    r_current = r_original;
    beta = Beta(i);
    % start of simulated annealing
    while r_new > r_target
        aij = adj;
        % at each iteration between 1 to 4 links will be randomly added
        num_add = randi(4);
        ind = find(adj == 0);
        add_link = ind(randperm(size(ind,1),num_add));
        aij(add_link) = 1;
        % find the eigen-ratio of the modified network
        rowsum = sum(aij,2);
        lap = diag(rowsum) - aij;
        % next line requires newer version of MATLAB
        eigv = sort(eig(lap),'ComparisonMethod','real');
        r_new = real(eigv(end))/real(eigv(2));
        % energy is negative if the eigen-ratio is improved by link addition
        energy = r_new/min(r_original,r_current)-1;

        % Metropolis criterion
        if rand < exp(-beta*energy)
            adj = aij;
            r_current = r_new;
            m(i) = m(i)+num_add;
            % if too many additions have been performed, abort this run
            if m(i) > n*(n-1) - 5 - M
                m(i) = Inf;
                break
            end
        end
    end
    % if the target eigen-ratio is reached
    if r_current <= r_target
        m(i) = size(find(adj-vtg==1),1);
        % if this successful run needs the smallest number of additions so far
        if m(i) == min(m(1:i))
            % print the number of links added
            minimal_num = m(i)
            % print the percentage of links added
            add_ratio = minimal_num/M
            % write the optimized newtork to file
            dlmwrite('Network1_opt.txt',adj)
        end
    end
end
