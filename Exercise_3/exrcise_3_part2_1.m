clear
close all
clc

%% Exercise 2.1 - Projection onto B(0,r)
x0 = [-1.5; 1];
r = 1;

% Projection onto L2 ball centered at (0,0)
x = r * x0 / norm(x0);

figure
quiver(0, 0, x0(1), x0(2), 'r', 'LineWidth', 1, 'MaxHeadSize', 0.2)
hold on 
quiver(0, 0, x(1), x(2), 'g-', 'LineWidth', 1, 'MaxHeadSize', 0.2)

% Draw circle centered at (0,0)
theta = linspace(0, 2*pi, 100);
x_circle = r*cos(theta);
y_circle = r*sin(theta);
plot(x_circle, y_circle, 'b', 'LineWidth', 1.2)

axis([-2 2.5 -.5 2.5])
axis equal
xlabel('$x_1$', 'Interpreter', 'latex')
ylabel('$x_2$', 'Interpreter', 'latex')
legend('$\mathbf{x}_0$', '$\mathbf{x}$', 'Interpreter', 'latex')
