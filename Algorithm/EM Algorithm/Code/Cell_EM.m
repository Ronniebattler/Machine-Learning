% 示例调用
n = [176, 182, 60, 17]; % 示例数据
maxIter = 100; % 最大迭代次数
tol = 1e-6; % 收敛容忍度
Iter = 0;

% 初始化
p = 0.2; % 初始估计值
q = 0.1; % 初始估计值
N = sum(n); % 总频率

for k = 1:maxIter
    % E-step
    r = 1 - p - q;
    n_AA_est = n(2) * (p^2) / (p^2 + 2 * p * r);
    n_AO_est = n(2) * (2 * p * r) / (p^2 + 2 * p * r);
    n_BB_est = n(3) * (q^2) / (q^2 + 2 * q * r);
    n_BO_est = n(3) * (2 * q * r) / (q^2 + 2 * q * r);

    % M-step
    p_new = (n_AA_est + 0.5 * n_AO_est + 0.5 * n(4)) / N;
    q_new = (n_BB_est + 0.5 * n_BO_est + 0.5 * n(4)) / N;

    % 计算对数似然
    logL = 2 * n(1) * log(r) + n(2) * log(p^2 + 2*p*r) + ...
           n(3) * log(q^2 + 2*q*r) + n(4) * log(2*p*q);
    % 检查收敛
    if abs(p - p_new) < tol && abs(q - q_new) < tol
        break;
    end
    
    Iter = Iter + 1;
    % 更新估计值
    p = p_new;
    q = q_new;
    fprintf('Loglike: %f\n', logL);
end

% 返回最终估计值
p_est = p;
q_est = q;
r_est = 1 - p - q;
% 输出结果
fprintf('Estimated p: %f\n', p_est);
fprintf('Estimated q: %f\n', q_est);
fprintf('Estimated q: %f\n', r_est);
fprintf('Loglike: %f\n', logL);
disp(Iter)


