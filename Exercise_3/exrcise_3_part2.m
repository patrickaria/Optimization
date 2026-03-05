%% Exercise 3 - Part 2: KKT-Based Optimization Problems
% NAME: PATRIKAKI ARISTEA
% AM: 2023030078

clear; clc;

%==========================================
% 1. Projection onto L2 ball B(0, r)
x0 = [3; 4];   % example point
r  = 5;        % ball radius

disp('=== 1) Projection onto the ball B(0,r) ===');
x0_ball = [3; 4];   % example in 2D for drawing
r       = 5;

x_proj_ball = proj_ball(x0_ball, r);
disp('x0 = ');
disp(x0_ball);
disp('Projection x* = ');
disp(x_proj_ball);

% Drawing in 2D
draw_ball_projection(x0_ball, r, x_proj_ball);


%==========================================
% 2. Projection onto set S = {x | x >= a}
x0 = [-1; 3; 0];
a  = [0; 1; -2];

x_proj_box = proj_box(x0, a);
disp("2. Projection onto x >= a:");
disp(x_proj_box);


%==========================================
% 3. Projection onto affine set Ax = b
A = [1 2; 3 4];
b = [1; 0];
x0 = [5; -2];

x_proj_affine = proj_affine(x0, A, b);
disp("3. Projection onto Ax = b:");
disp(x_proj_affine);


%% =============================================================
% 4. 2D Optimization on region S (two cases)
%% =============================================================

disp("=== Part 4: Solving 2D constrained optimization ===");

x_sol_a = solve_2d_problem("a");
x_sol_b = solve_2d_problem("b");

disp("Solution for objective (a): (x1 - 2)^2 + (x2 - 2)^2");
disp(x_sol_a);

disp("Solution for objective (b): (x1 + 2)^2 + (x2 + 2)^2");
disp(x_sol_b);

function x_proj = proj_ball(x0, r)
% PROJ_BALL
% Projection onto the Euclidean L2 ball B(0,r)
% Solves:
%   minimize 1/2 ||x - x0||^2 , subject to ||x|| <= r
%
% KKT closed form:
%   If ||x0|| <= r then x* = x0
%   Else x* = r * x0 / ||x0||

    if norm(x0) <= r
        x_proj = x0;
    else
        x_proj = r * x0 / norm(x0);
    end
end

% --------------------------------------------------------------

function draw_ball_projection(x0, r, x_proj)
% DRAW_BALL_PROJECTION
% 2D drawing of ball B(0,r), point x0, and its projection x_proj.

    theta = linspace(0, 2*pi, 300);
    circle = r * [cos(theta); sin(theta)];

    figure; hold on; grid on;
    plot(circle(1,:), circle(2,:), 'b', 'LineWidth', 2); % ball boundary
    plot(0, 0, 'k+', 'MarkerSize', 8, 'LineWidth', 2);   % origin
    plot(x0(1), x0(2), 'ro', 'MarkerSize', 8, 'LineWidth', 2); % original point
    plot(x_proj(1), x_proj(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2); % projected point

    legend('Ball B(0,r)', 'Origin', 'x0', 'Projection x*');
    xlabel('x_1'); ylabel('x_2');
    title('Projection onto the L2 ball B(0,r)');
    axis equal;
end

% --------------------------------------------------------------

function x_proj = proj_box(x0, a)
% PROJ_BOX
% Projection onto the set S = {x | x >= a} (elementwise).
% KKT closed form:
%   x*_i = max(x0_i, a_i)

    x_proj = max(x0, a);   % elementwise max
end

% --------------------------------------------------------------

function draw_box_projection(x0, a, x_proj)
% DRAW_BOX_PROJECTION
% 2D illustration for projection onto x >= a.
% We draw vertical and horizontal lines at a1 and a2,
% and show x0 and x*.

    figure; hold on; grid on;

    % Draw constraints x1 >= a1 and x2 >= a2 as lines
    xline(a(1), '--r', 'LineWidth', 1.5);
    yline(a(2), '--r', 'LineWidth', 1.5);

    plot(x0(1), x0(2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    plot(x_proj(1), x_proj(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2);

    legend('x_1 = a_1', 'x_2 = a_2', 'x_0', 'Projection x*', 'Location', 'best');
    xlabel('x_1'); ylabel('x_2');
    title('Projection onto S = {x | x >= a} (2D view)');
    axis equal;
end

% --------------------------------------------------------------

function x_proj = proj_affine(x0, A, b)
% PROJ_AFFINE
% Projection onto the affine set Ax = b.
% Solves:
%   minimize 1/2 ||x - x0||^2 , subject to Ax = b
%
% KKT closed form:
%   x* = x0 - A' (A A')^{-1} (A x0 - b)
%
% Here A is m x n. In our 2D drawing example we use m=1,n=2.

    x_proj = x0 - A' * ((A * A') \ (A * x0 - b));
end

% --------------------------------------------------------------

function draw_affine_projection_2d(x0, A, b, x_proj)
% DRAW_AFFINE_PROJECTION_2D
% Draws a 2D line Ax = b (for A 1x2) and shows x0 and x*.

    if size(A,1) ~= 1 || size(A,2) ~= 2
        warning('draw_affine_projection_2d assumes A is 1x2 for 2D line.');
    end

    figure; hold on; grid on;

    % Create range for x1 and solve for x2 from A(1)*x1 + A(2)*x2 = b
    x1_vals = linspace(-1, 4, 200);
    if abs(A(2)) > 1e-12
        x2_vals = (b - A(1)*x1_vals)/A(2);
        plot(x1_vals, x2_vals, 'b', 'LineWidth', 2);
    else
        % Vertical line case
        xline(b / A(1), 'b', 'LineWidth', 2);
    end

    plot(x0(1), x0(2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    plot(x_proj(1), x_proj(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2);

    legend('Ax = b', 'x_0', 'Projection x*', 'Location', 'best');
    xlabel('x_1'); ylabel('x_2');
    title('Projection onto affine set Ax = b');
    axis equal;
end

% --------------------------------------------------------------

function x_sol = solve_2d_problem(part)
% SOLVE_2D_PROBLEM
% Solves the 2D constrained optimization:
%   minimize f0(x) over S
%   S = { x in R^2 | ||x|| <= 1, x1 >= 0, x2 >= 0, x1 + x2 <= 1 }
%
% part = "a":
%   f0(x) = (x1 - 2)^2 + (x2 - 2)^2
% part = "b":
%   f0(x) = (x1 + 2)^2 + (x2 + 2)^2
%
% Approach:
%   - Enumerate candidate points on the boundary of S:
%       * Corners: (0,0), (1,0), (0,1)
%       * Line segment x1 + x2 = 1, x1,x2 >= 0
%       * Quarter-circle x1^2 + x2^2 = 1, x1,x2 >= 0
%   - Filter those that lie in S
%   - Evaluate f0 on all candidates, choose minimal

    if part == "a"
        f = @(x) (x(1)-2)^2 + (x(2)-2)^2;
    else
        f = @(x) (x(1)+2)^2 + (x(2)+2)^2;
    end

    % Container for candidate points
    cand = [];

    % 1) Corners of the polygonal constraints
    cand = [cand, [0;0], [1;0], [0;1]];

    % 2) Line segment x1 + x2 = 1
    t = linspace(0,1,300);
    cand = [cand, [t; 1-t]];

    % 3) Quarter of the unit circle (x1^2 + x2^2 = 1, x1,x2 >=0)
    theta = linspace(0, pi/2, 300);
    cand = [cand, [cos(theta); sin(theta)]];

    % Filter feasible points in S
    feats = [];
    for i = 1:size(cand,2)
        x = cand(:,i);
        if norm(x) <= 1 + 1e-9 && x(1) >= -1e-9 && x(2) >= -1e-9 && x(1) + x(2) <= 1 + 1e-9
            feats = [feats, x];
        end
    end

    % Evaluate objective on all feasible points
    values = arrayfun(@(i) f(feats(:,i)), 1:size(feats,2));

    % Take minimizer
    [~, idx] = min(values);
    x_sol = feats(:,idx);
end

% --------------------------------------------------------------

function draw_region_S_with_points(x_a, x_b)
% DRAW_REGION_S_WITH_POINTS
% Draws the feasible region S in R^2:
%   S = { x | ||x|| <= 1, x1 >= 0, x2 >= 0, x1 + x2 <= 1 }
% and marks the solution points for problems (a) and (b).

    figure; hold on; grid on;
    title('Region S and solutions for (a) and (b)');
    xlabel('x_1'); ylabel('x_2');
    axis equal;

    % Draw quarter of the unit circle
    theta = linspace(0, pi/2, 300);
    x_circ = cos(theta);
    y_circ = sin(theta);
    plot(x_circ, y_circ, 'b', 'LineWidth', 2);

    % Draw lines x1=0, x2=0, x1+x2=1
    plot([0 1], [0 0], 'r', 'LineWidth', 1.5);   % x2=0
    plot([0 0], [0 1], 'r', 'LineWidth', 1.5);   % x1=0
    plot([0 1], [1 0], 'r', 'LineWidth', 1.5);   % x1 + x2 = 1

    % (Optional) Fill approximate feasible region via a patch
    % Just for visualization, not exact curved boundary
    fill([0 1 0], [0 0 1], [0.9 0.9 1], 'FaceAlpha',0.3, 'EdgeColor','none');

    % Plot solution points
    plot(x_a(1), x_a(2), 'ko', 'MarkerSize', 8, 'LineWidth', 2);
    text(x_a(1)+0.02, x_a(2), 'x^*_a');

    plot(x_b(1), x_b(2), 'kx', 'MarkerSize', 8, 'LineWidth', 2);
    text(x_b(1)+0.02, x_b(2), 'x^*_b');

    legend('||x||=1 (boundary)', 'x2=0', 'x1=0', 'x1+x2=1', ...
           'Approx. polygonal area', 'Solution (a)', 'Solution (b)', ...
           'Location', 'bestoutside');
end