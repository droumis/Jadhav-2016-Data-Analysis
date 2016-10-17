function [decision_state_probability] = decode_decision_state(ripple_time, ...
    position_time_milliseconds, ...
    mark_spike_times, ...
    initial_conditions, ...
    state_transition_model, ...
    estimated_rate_all, ...
    mark_spike_by_tetrode, ...
    mark_spike_number_by_tetrode, ...
    marks, ...
    mark_spikes_to_linear_position_time_bins_index, ...
    mark_smoothing_standard_deviation, ...
    gaussian_kernel_position_estimator, ....
    position_occupancy, ...
    estimated_rate_by_tetrode, ...
    dt, ...
    num_linear_distance_bins ...
    )

num_time_steps = length(ripple_time);
posterior_density = initial_conditions;
[posterior_length, num_decision_states] = size(posterior_density);
decision_state_probability = zeros(num_time_steps, num_decision_states);
one_step_prediction_density = zeros(posterior_length, num_decision_states);

for time_step_ind = 1:num_time_steps
    
    % Update one step prediction density
    for decision_state_ind = 1:num_decision_states,
        one_step_prediction_density(:, decision_state_ind) = state_transition_model{decision_state_ind} * posterior_density(:, decision_state_ind);
    end
    
    likelihood = get_likelihood(mark_spike_times, position_time_milliseconds, ...
        estimated_rate_all, ripple_time, time_step_ind, dt, ...
        num_linear_distance_bins, mark_spike_by_tetrode, mark_spike_number_by_tetrode, ...
        marks, mark_spikes_to_linear_position_time_bins_index, gaussian_kernel_position_estimator, ...
        position_occupancy, estimated_rate_by_tetrode, mark_smoothing_standard_deviation);
    
    % Update posterior density
    total_norm = sum(one_step_prediction_density(:) .* likelihood(:));
    posterior_density = one_step_prediction_density .* likelihood / total_norm;
    
    % Record decision state probability
    decision_state_probability(time_step_ind, :) = sum(posterior_density);
    
end

end