%% Load data and extract data
clear variables; clc;
% bond04, epoch 2
animal = 'bon';
day = 4;
epoch = 2;
tetrode_number = [1 2 4 5 7 10 11 12 13 14 17 18 19 20 22 23 27 29]; %tetrode index
get_file_name = @(file_type) sprintf('bond_data/%s%s%02d.mat', animal, file_type, day);

task_file = load(get_file_name('task'));
position_file = load(get_file_name('pos'));
spikes_file = load(get_file_name('spikes')); %sorted spikes
linear_position_file = load(get_file_name('linpos'));
ripples_file = load(get_file_name('ripplescons'));
trajectory_encode_file = load(get_file_name('trajencode'));
well_visitions_file = load(get_file_name('wellvisits'));

[tetrode_index, neuron_index] = get_tetrodes_with_spikes(spikes_file.spikes, day, epoch, tetrode_number);
[state_index] = get_state_index(trajectory_encode_file.trajencode{day}{epoch});
linear_distance = linear_position_file.linpos{day}{epoch}.statematrix.lindist;
linear_position_time = linear_position_file.linpos{day}{epoch}.statematrix.time;
%% Encode (Initial Conditions, State Transition Model, Observation Model)
[mark_spike_times, ...
    linear_distance_bins, ...
    linear_distance_bin_size, ...
    estimated_rate_all, ...
    mark_spike_by_tetrode, ...
    mark_spike_number_by_tetrode, ......
    marks, ...
    mark_spikes_to_linear_position_time_bins_index, ...
    mark_smoothing_standard_deviation, ...
    gaussian_kernel_position_estimator, ....
    position_occupancy, ...
    estimated_rate_by_tetrode ...
    ] = encode_observation_model(animal, day, linear_distance, linear_position_time, ...
    state_index, tetrode_number);

initial_conditions = get_initial_conditions(linear_distance_bins);

state_transition_model = get_state_transition_model(state_index, linear_distance_bins, linear_distance);
%% Decode ripples
[ripple_index, position_time_stamps_binned] = get_ripple_index(...
    position_file.pos{day}{epoch}, ripples_file.ripplescons{day}{epoch}, ...
    spikes_file.spikes{day}{epoch}, tetrode_index, neuron_index);

mark_spike_times = round(mark_spike_times / 10);
dt = 1 / 33.4;
num_linear_distance_bins = length(linear_distance_bins);

num_ripples = length(ripple_index);
summary_statistic = cell(num_ripples, 1);

for ripple_number = 1:num_ripples,
    
    cur_ripple_time = ripple_index(ripple_number, 1):ripple_index(ripple_number, 2);
    
    decision_state_probability = decode_state(...
        cur_ripple_time, ...
        position_time_stamps_binned, ...
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
        );
    
    summary_statistic{ripple_number} = decision_state_probability;
end
%% Test if code matches Xinyi's original code
expected = load('expected_sumStat.mat');
for ripple_number = 1:num_ripples,
    is_same(ripple_number) = all(all(abs(summary_statistic{ripple_number} - expected.sumStat{ripple_number}) < 1E6));
end

all(is_same)