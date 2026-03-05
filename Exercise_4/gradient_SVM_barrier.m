function grad = gradient_SVM_barrier(w, X_augm, y, t)
% Computes the gradient of the barrier objective

    % Ensure y is a column vector
    y = y(:);                                      % N x 1

    % Compute w^T * x_i for all data points
    wx = X_augm.' * w;                             % N x 1

    % Compute signed margins y_i * w^T * x_i
    margins = y .* wx;                             % N x 1

    % Compute denominators: 1 - y_i * w^T * x_i
    denom = 1 - margins;                           % N x 1

    % Compute coefficients y_i / (1 - y_i * w^T * x_i)
    coeff = y ./ denom;                            % N x 1

    % Gradient of (t/2)||w||^2 is t*w
    grad_regularizer = t * w;                      % (n+1)x1

    % Gradient of the barrier term
    grad_barrier = X_augm * coeff;                 % (n+1)x1

    % Total gradient
    grad = grad_regularizer + grad_barrier;

end
