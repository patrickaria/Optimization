function val = barrier_SVM_cost_function(w_new, X_augm, y, t)
% Computes the value of the barrier objective function

    % Ensure y is a column vector
    y = y(:);                                          % N x 1

    % Compute w^T * x_i for all data points
    wx = X_augm.' * w_new;                             % N x 1

    % Compute signed margins y_i * w^T * x_i
    margins = y .* wx;                                 % N x 1

    % Compute the regularization term (t/2)*||w||^2
    regularization = (t/2) * (w_new.' * w_new);        

    % Compute the barrier term
    barrier = -sum(log(margins - 1));                

    % Total objective value
    val = regularization + barrier;

end
