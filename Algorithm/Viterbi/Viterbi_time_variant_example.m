T = 200;
p00 = 0.8;
p11 = 0.9;
sigma_epsilon = 0.5;
[y, At_true] = simulate_data(T, p00, p11, sigma_epsilon);

% 转移概率
P = [p00, 1-p00; 1-p11, p11];

% Viterbi算法
num_states = 2;
V = zeros(T, num_states);
ptr = zeros(T, num_states);

% 初始化
for i = 1:num_states
    if i == 1
        V(1, i) = normpdf(y(1), sin(1/10), sigma_epsilon);
    else
        V(1, i) = normpdf(y(1), cos(1/10), sigma_epsilon);
    end
end

% 递归计算
for t = 2:T
    for j = 1:num_states
        if j == 1
            obs_prob = normpdf(y(t), sin(t/10), sigma_epsilon);
        else
            obs_prob = normpdf(y(t), cos(t/10), sigma_epsilon);
        end
        [max_prob, argmax_state] = max(V(t-1, :) .* P(:, j)' * obs_prob);
        
        V(t, j) = max_prob;
        ptr(t, j) = argmax_state;
    end
end

% 回溯
A_T = backtrack(V, ptr);
A_T = A_T'-ones(T,1);

% 计算误差
error = sum(abs(A_T - At_true));
disp(['Estimated error: ', num2str(error)]);

%%
function states = backtrack(V, ptr)
    T = size(V, 1);
    [~, states(T)] = max(V(T, :));
    for t = T-1:-1:1
        states(t) = ptr(t+1, states(t+1));
    end
end

function [y, At_true] = simulate_data(T, p00, p11, sigma_epsilon)
    % 初始化At_true
    At_true = zeros(T, 1);
    At_true(1) = rand < 0.5;
    for t = 2:T
        if At_true(t-1) == 0
            At_true(t) = rand >= p00;
        else
            At_true(t) = rand < p11;
        end
    end

    % 根据状态生成y
    y = nan(T, 1);
    for t = 1:T
        if At_true(t) == 0
            y(t) = sin(t/10) + sigma_epsilon * randn;
        else
            y(t) = cos(t/10) + sigma_epsilon * randn;
        end
    end
end
