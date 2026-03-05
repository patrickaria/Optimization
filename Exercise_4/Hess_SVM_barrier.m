function Hess = Hess_SVM_barrier(w, X_augm, y, t)
% Computes the Hessian of the barrier objective

    % Ensure y is a column vector
    y = y(:);                                    % N x 1

    % Dimension of w (including bias term)
    [d, N] = size(X_augm);                       % d = n+1

    % Compute w^T * x_i for all data points
    wx = X_augm.' * w;                           % N x 1

    % Compute signed margins y_i * w^T * x_i
    margins = y .* wx;                           % N x 1

    % Compute weights: 1 / (y_i*w^T*x_i - 1)^2
    weights = 1 ./ (margins - 1).^2;             % N x 1

    % Hess = tI + sum_i weights(i) * x_i x_i^T
    % Implement as X * diag(weights) * X'
    Hess = t * eye(d) + X_augm * (diag(weights) * X_augm.');

end

