clear;
close all;

x_star = 5;

x1 = linspace(0,x_star,200);
x2 = linspace(0,x_star,200);

[X1,X2] = meshgrid(x1,x2);

f = 1 ./ (1 + X1 + X2);

%(a) Mesh plot
figure
mesh(X1,X2,f)

xlabel('x_1')
ylabel('x_2')
zlabel('f(x_1,x_2)')
title('Mesh plot of f(x_1,x_2)=1/(1+x_1+x_2)')
grid on

% (b) Contour plot
figure
contour(X1,X2,f,20)

xlabel('x_1')
ylabel('x_2')
title('Level sets of f(x_1,x_2)')
grid on
colorbar