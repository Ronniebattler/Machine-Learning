% Define the state transition probability matrix and observation matrices
P = [0.8, 0.2; 0.3, 0.7];
mean_vals = [2, 5];  % means for states 1 and 2 respectively
std_devs = [1, 1];  % standard deviations for states 1 and 2

% Define the observed sequence
O = [2.1, 5.2, 5.0, 2.3, 2.0, 5.1];
T = length(O);
num_states = 2;

% Initialization
V = zeros(T, num_states);
ptr = zeros(T, num_states);

for i = 1:num_states
    V(1, i) = normpdf(O(1), mean_vals(i), std_devs(i));
end

% Recursive computation
for t = 2:T
    for j = 1:num_states
        % Calculate the maximum probability and the state that resulted in this max probability
        [max_prob, argmax_state] = max(V(t-1, :) .* P(:, j)' .* normpdf(O(t), mean_vals(j), std_devs(j)));
        
        V(t, j) = max_prob;
        ptr(t, j) = argmax_state;
    end
end

% Backtracking the most probable path
states = backtrack(V, ptr);

% Backtrack function
function states = backtrack(V, ptr)
    T = size(V, 1);
    [~, states(T)] = max(V(T, :));

    for t = T-1:-1:1
        states(t) = ptr(t+1, states(t+1));
    end
end
