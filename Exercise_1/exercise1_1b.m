clear;
close all;
clc;

x = linspace(0, 10, 1000);

f  = @(x) 1./(1 + x);
fp = @(x) -1./(1 + x).^2;
fpp = @(x) 2./(1 + x).^3;

x0_values = [0, 1, 2, 4];

for i = 1:length(x0_values)
    x0 = x0_values(i);

    f1 = f(x0) + fp(x0).*(x - x0);
    f2 = f(x0) + fp(x0).*(x - x0) + 0.5*fpp(x0).*(x - x0).^2;

    figure;
    plot(x, f(x), 'b', 'LineWidth', 2);
    hold on;
    plot(x, f1, 'g', 'LineWidth', 2);
    plot(x, f2, 'r', 'LineWidth', 2);

    grid on;
    title(['Plot f(x), f_1(x) and f_2(x) for x_0 = ', num2str(x0)]);
    legend('f(x)', '1st-order Taylor', '2nd-order Taylor', 'Location', 'best');
    xlabel('x');
    ylabel('y');
end