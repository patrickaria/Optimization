function flag = point_is_feasible(w, X_augm, y)
% Checks whether the point w is strictly feasible for the barrier method

    % Ensure y is a column vector
    y = y(:);                                  % N x 1

    % Compute w^T * x_i for all data points
    wx = X_augm.' * w;                         % N x 1

    % Compute signed margins y_i * w^T * x_i
    margins = y .* wx;                         % N x 1

    % Check the smallest margin:
    % If the smallest margin is larger than 1,
    % then all inequality constraints are strictly satisfied
    if min(margins) > 1
        flag = 1;                              % feasible point
    else
        flag = 0;                              % infeasible point
    end

end
