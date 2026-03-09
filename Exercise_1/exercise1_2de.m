clear;
close all;

x_star = 5;

a = 1;
b = 1;

x1 = linspace(0, x_star, 150);
x2 = linspace(0, x_star, 150);
[X1, X2] = meshgrid(x1, x2);

f = @(x1,x2) 1 ./ (1 + x1 + x2);

% μερικές παράγωγοι
fx1  = @(x1,x2) -1 ./ (1 + x1 + x2).^2;
fx2  = @(x1,x2) -1 ./ (1 + x1 + x2).^2;

fxx11 = @(x1,x2) 2 ./ (1 + x1 + x2).^3;
fxx22 = @(x1,x2) 2 ./ (1 + x1 + x2).^3;
fxx12 = @(x1,x2) 2 ./ (1 + x1 + x2).^3;

% πραγματική συνάρτηση
F = f(X1, X2);

% τιμές στο σημείο ανάπτυξης
f0    = f(a,b);
fx10  = fx1(a,b);
fx20  = fx2(a,b);
fxx110 = fxx11(a,b);
fxx220 = fxx22(a,b);
fxx120 = fxx12(a,b);

% Taylor 1ης τάξης
f1 = f0 + fx10.*(X1 - a) + fx20.*(X2 - b);

figure;
mesh(X1, X2, F,'EdgeColor', 'b');
hold on;
mesh(X1, X2, f1, 'EdgeColor', 'r');

xlabel('x_1');
ylabel('x_2');
zlabel('z');
title('f and first-order Taylor approximation');
legend('f(x_1,x_2)', 'f_{(1)}(x_1,x_2)');
grid on;

% Taylor 2ης τάξης
f2 = f0 ...
    + fx10.*(X1 - a) ...
    + fx20.*(X2 - b) ...
    + 0.5*( ...
        fxx110.*(X1 - a).^2 ...
      + 2*fxx120.*(X1 - a).*(X2 - b) ...
      + fxx220.*(X2 - b).^2 );

figure;
mesh(X1, X2, F, 'EdgeColor', 'b');
hold on;
mesh(X1, X2, f2, 'EdgeColor', 'g');

xlabel('x_1');
ylabel('x_2');
zlabel('z');
title('f and second-order Taylor approximation');
legend('f(x_1,x_2)', 'f_{(2)}(x_1,x_2)');
grid on;