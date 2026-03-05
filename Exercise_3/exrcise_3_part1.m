%% Exercise 3 - Part 1: Unconstrained Convex Optimization
% NAME: PATRIKAKI ARISTEA
% AM: 2023030078

clear; 
close all; 
clc;

%==========================================
% 1. Create quantities A, b, and c randomly

% Set sizes (n, m) = (2, 20)
n = 2;
m = 20;

% Generate random data
A = randn(m, n); 
c = randn(n, 1) + 1.; % ensure strictly positive margin so x=0 is feasible
b = 1 + rand(m, 1); 

% Define the function and its gradient for fminunc
f = @(x) c'*x - sum( log( b - A*x ) );

% Gradient of f
gradf = @(x) c + A' * ( 1 ./ (b - A*x) );

%==========================================
%2. Minimize f using the cvx.

% fminunc gives us "p_star" like CVX would

options = optimoptions('fminunc','Algorithm','trust-region', ...
    'SpecifyObjectiveGradient',true,'Display','off');

% Provide function and gradient to fminunc
fun = @(x) deal( f(x), gradf(x) );

x0 = zeros(n,1);     % initial point (feasible)
[x_ref, p_star] = fminunc(fun, x0, options);

disp("Reference optimal point x* = ");
disp(x_ref);
disp("Reference optimal value p* = ");
disp(p_star);

%==========================================
%3.If n = 2, then plot f and its level sets in the 
% neighborhood of the optimum point.
%% ===================== BEAUTIFIED SMOOTH PLOTS (STEP 3) =====================

if n == 2
    % Finer grid for smoother plots
    x1 = linspace(-1,1,300);
    x2 = linspace(-1,1,300);
    [X1, X2] = meshgrid(x1, x2);
    F = NaN(size(X1));

    % Compute f(x) only where domain is valid
    for i = 1:numel(X1)
        x_temp = [X1(i); X2(i)];
        if all(b - A*x_temp > 0)
            F(i) = f(x_temp);
        end
    end

    figure;

    subplot(1,2,1)
    surf(X1, X2, F, 'EdgeColor','none');
    colormap(jet);
    colorbar;
    title("Surface plot of f(x)");
    xlabel("x1"); ylabel("x2"); zlabel("f(x)");

    subplot(1,2,2)
    contour(X1,X2,F,40); hold on;
    plot(x_ref(1), x_ref(2), 'rx','LineWidth',2);
    title('Level sets of f(x)');
end


%==========================================
%4.

alpha = 0.25;   % sufficient decrease parameter
beta = 0.5;     % backtracking reduction
max_iters = 50;

xk = zeros(n,1); 
f_grad = zeros(max_iters,1);

for k = 1:max_iters

    g = gradf(xk);      % gradient
    t = 1;              % initial step

    % ---- (a) Ensure domain feasibility: b - A(x - t*g) > 0 ----
    while ~all(b - A*(xk - t*g) > 0)
        t = beta * t;   % reduce t
    end

    % ---- (b) Backtracking line search ----
    while true
        x_new = xk - t*g;
        if f(x_new) <= f(xk) - alpha*t*(norm(g)^2)
            break;
        end
        t = beta * t;
    end

    xk = x_new;
    f_grad(k) = f(xk);
end


%==========================================
%5.

xk = zeros(n,1);
f_newt = zeros(max_iters,1);

for k = 1:max_iters
    % Gradient
    g = gradf(xk);

    % Hessian of f
    D = (1 ./ (b - A*xk)).^2;
    H = A' * diag(D) * A;

    % Newton step
    delta = - H \ g;

    t = 1;

    % ---- (a) Ensure domain feasibility ----
    while ~all(b - A*(xk + t*delta) > 0)
        t = beta * t;
    end

    % ---- (b) Backtracking ----
    while true
        x_new = xk + t*delta;
        if f(x_new) <= f(xk) + alpha*t*(g'*delta)
            break;
        end
        t = beta*t;
    end

    xk = x_new
    f_newt(k) = f(xk)
end

%==========================================
%6.

figure; hold on;
semilogy(abs(f_grad - p_star), 'LineWidth',1.5);
semilogy(abs(f_newt - p_star), 'LineWidth',1.5);
legend('Gradient Descent','Newton Method');
xlabel('Iteration k');
ylabel('|f(x_k) - p^*|');
title('Convergence comparison');
grid on;