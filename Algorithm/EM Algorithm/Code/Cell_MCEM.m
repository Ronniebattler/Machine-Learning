% 示例调用
n = [176, 182, 60, 17]; % 示例数据
m = 1000; % 蒙特卡罗样本数
maxIter = 100; % 最大迭代次数
tol = 1e-6; % 收敛容忍度
Iter = 0;

% 初始化
p = 0.5; % 初始估计值
q = 0.5; % 初始估计值
N = sum(n); % 总频率

for k = 1:maxIter
    r = 1 - p - q;

    % 使用蒙特卡罗方法模拟缺失数据
    z1_samples = binornd(n(2), p^2 / (p^2 + 2*p*r), [m, 1]);
    z2_samples = binornd(n(3), q^2 / (q^2 + 2*q*r), [m, 1]);

    % 计算模拟数据的平均值
    n_AA_est = mean(z1_samples);
    n_BB_est = mean(z2_samples);

    % M-step
    p_new = (n_AA_est + 0.5 * (n(2) - n_AA_est) + 0.5 * n(4)) / N;
    q_new = (n_BB_est + 0.5 * (n(3) - n_BB_est) + 0.5 * n(4)) / N;

    % 检查收敛
    if abs(p - p_new) < tol && abs(q - q_new) < tol
        break;
    end
    Iter = Iter + 1;

    % 更新估计值
    p = p_new;
    q = q_new;
end

% 返回最终估计值
p_est = p;
q_est = q;
r_est = 1-p-q;
% 输出结果
fprintf('Estimated p: %f\n', p_est);
fprintf('Estimated q: %f\n', q_est);
fprintf('Estimated q: %f\n', r_est);
disp(Iter)

