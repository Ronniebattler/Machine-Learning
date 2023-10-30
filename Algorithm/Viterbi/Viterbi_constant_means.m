% Simulate data
T = 200;
state = zeros(T,1);
mu = [-2, 2]; % Mean values for two states
p00 = 0.95;
p11 = 0.95;
sigma = 1;

y = zeros(T,1);
for t = 2:T
    if state(t-1) == 1
        state(t) = rand < p11;
    else
        state(t) = rand >= p00;
    end
    y(t) = mu(state(t)+1) + sigma*randn;
end

% Viterbi Algorithm
P = [p00, 1-p00; 1-p11, p11];
estimated_state = zeros(T,1);
V = zeros(T,2); % Probability matrix
ptr = zeros(T,2); % Pointer matrix

% Initialization
for i = 1:2
    V(1,i) = normpdf(y(1), mu(i), sigma);
end

% Recursion
for t = 2:T
    for j = 1:2
        [prob, argmax] = max(V(t-1, :) .* P(:, j)');
        V(t,j) = prob * normpdf(y(t), mu(j), sigma);
        ptr(t,j) = argmax;
    end
end

% Backtrack
[~, estimated_state(T)] = max(V(T, :));
for t = T-1:-1:1
    estimated_state(t) = ptr(t+1, estimated_state(t+1));
end

% Calculate error
error = sum(abs(estimated_state-ones(T,1) - state));

% Display error
disp(['Error in estimated states: ', num2str(error)]);
