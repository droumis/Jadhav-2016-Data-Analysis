function [mark_spike_times, ...
    stateV, ...
    stateV_delta, ...
    stateM_I_normalized_gaussian_outbound, ...
    stateM_I_normalized_gaussian_inbound, ...
    Lint_I_Lambda_outbound, ...
    Lint_I_Lambda_inbound, ...
    tet_ind, ...
    tet_sum, ...
    markAll, ...
    procInd1_Ia_out, ...
    procInd1_I_out, ...
    smker, ...
    Xnum_I_out, ....
    occ_I_Lambda_outbound, ...
    Lint_I_out, ...
    procInd1_Ia_in, ...
    procInd1_I_in, ...
    Xnum_I_in, ...
    occ_I_Lambda_inbound, ...
    Lint_I_in ...
    ] = encode_state(animal, day, linear_distance, linear_position_time, state_index, tetrode_number)
%% use Loren's linearization
num_linear_distance_bins = 61;
stateV = linspace(min(linear_distance), max(linear_distance), num_linear_distance_bins);
stateV_delta = stateV(2) - stateV(1);
%% empirical movement transition matrix conditioned on I=1(outbound) and I=0 (inbound)
[stateM_I_normalized_gaussian_outbound] = condition_empirical_movement_transition_matrix_on_state(stateV, linear_distance, state_index{1});
[stateM_I_normalized_gaussian_inbound] = condition_empirical_movement_transition_matrix_on_state(stateV, linear_distance, state_index{2});

%% prepare kernel density model
linear_distance_bins = min(linear_distance):stateV_delta:max(linear_distance);
dt = linear_position_time(2) - linear_position_time(1);
xtrain = linear_distance';

sxker = stateV_delta;
mdel = 20;
smker = mdel;
%% encode the kernel density model per tetrode
num_tetrodes = length(tetrode_number);

markAll = cell(num_tetrodes, 1);
mark_spike_time0 = cell(num_tetrodes, 1);
mark0 = cell(num_tetrodes, 1);
procInd1_tet = cell(num_tetrodes, 1);

for tetrode_ind = 1:num_tetrodes,
    [markAll{tetrode_ind}, mark_spike_time0{tetrode_ind}, mark0{tetrode_ind}, ...
        procInd1_tet{tetrode_ind}] = kernel_density_model(animal, day, tetrode_number(tetrode_ind), ...
        linear_position_time);
end

mark0 = cat(1, mark0{:});
procInd1 = cat(1, procInd1_tet{:});
%% bookkeeping code: which spike comes which tetrode
group_labels = cellfun(@(t, group) group * ones(size(t)), mark_spike_time0, num2cell(1:num_tetrodes)', 'uniformOutput', false);
group_labels = cat(1, group_labels{:});
[mark_spike_times, timeInd] = sort(cat(1, mark_spike_time0{:}));
mark0 = mark0(timeInd, :);
procInd1 = procInd1(timeInd, :);

tet_ind = false(length(mark_spike_times), num_tetrodes);

for tetrode_ind = 1:num_tetrodes,
    tet_ind(:, tetrode_ind) = (group_labels(timeInd) == tetrode_ind);
end

tet_sum = tet_ind .* cumsum(tet_ind,1); %row: time point; column: index of spike per tetrode

%% captial LAMBDA (joint mark intensity function) conditioned on I=1 and I=0
mark_bins = min(mark0(:)):mdel:max(mark0(:));
[Lint_I_Lambda_outbound, occ_I_Lambda_outbound] = condition_joint_mark_intensity_on_discrete_state(xtrain, procInd1, state_index{1}, sxker, mark_bins, linear_distance_bins, dt);
[Lint_I_Lambda_inbound, occ_I_Lambda_inbound] = condition_joint_mark_intensity_on_discrete_state(xtrain, procInd1, state_index{2}, sxker, mark_bins, linear_distance_bins, dt);

%% encode per tetrode, conditioning on I=1 and I=0
procInd1_Ia_out = cell(num_tetrodes, 1);
procInd1_Ia_in = cell(num_tetrodes, 1);
procInd1_I_out = cell(num_tetrodes, 1);
procInd1_I_in = cell(num_tetrodes, 1);
Xnum_I_out = cell(num_tetrodes, 1);
Xnum_I_in = cell(num_tetrodes, 1);
Lint_I_out = cell(num_tetrodes, 1);
Lint_I_in = cell(num_tetrodes, 1);

for tetrode_ind = 1:num_tetrodes,
    [procInd1_Ia_out{tetrode_ind}, procInd1_I_out{tetrode_ind}, Xnum_I_out{tetrode_ind}, Lint_I_out{tetrode_ind}] = encode_per_tetrode( ...
    procInd1_tet{tetrode_ind}, state_index{1},  occ_I_Lambda_outbound, dt, linear_distance_bins, xtrain, sxker);
    [procInd1_Ia_in{tetrode_ind}, procInd1_I_in{tetrode_ind}, Xnum_I_in{tetrode_ind}, Lint_I_in{tetrode_ind}] = encode_per_tetrode( ...
    procInd1_tet{tetrode_ind}, state_index{2},  occ_I_Lambda_inbound, dt, linear_distance_bins, xtrain, sxker);
end

save('computed_var.mat');
end