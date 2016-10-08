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

[rippleI, ...
    ripple_index, ...
    position_time_stamps, ...
    position_time_stamps_binned, ...
    vecLF, ...
    traj_Ind, ...
    time, ...
    stateV, ...
    stateV_delta, ...
    stateM_I1_normalized_gaussian, ...
    stateM_Indicator0_normalized_gaussian, ...
    Lint_Indicator_outbound, ...
    Lint_Indicator_inbound, ...
    tet_ind, ...
    tet_sum, ...
    markAll_t1, ...
    markAll_t2, ...
    markAll_t4, ...
    markAll_t5, ...
    markAll_t7, ...
    markAll_t10, ...
    markAll_t11, ...
    markAll_t12, ...
    markAll_t13, ...
    markAll_t14, ...
    markAll_t17, ...
    markAll_t18, ...
    markAll_t19, ...
    markAll_t20, ...
    markAll_t22, ...
    markAll_t23, ...
    markAll_t27, ...
    markAll_t29, ...
    procInd1_t1_Ia_out, ...
    procInd1_t2_Ia_out, ...
    procInd1_t4_Ia_out, ...
    procInd1_t5_Ia_out, ...
    procInd1_t7_Ia_out, ...
    procInd1_t10_Ia_out, ...
    procInd1_t11_Ia_out, ...
    procInd1_t12_Ia_out, ...
    procInd1_t13_Ia_out, ...
    procInd1_t14_Ia_out, ...
    procInd1_t17_Ia_out, ...
    procInd1_t18_Ia_out, ...
    procInd1_t19_Ia_out, ...
    procInd1_t20_Ia_out, ...
    procInd1_t22_Ia_out, ...
    procInd1_t23_Ia_out, ...
    procInd1_t27_Ia_out, ...
    procInd1_t29_Ia_out, ...
    procInd1_t1_I_out, ...
    procInd1_t2_I_out, ...
    procInd1_t4_I_out, ...
    procInd1_t5_I_out, ...
    procInd1_t7_I_out, ...
    procInd1_t10_I_out, ...
    procInd1_t11_I_out, ...
    procInd1_t12_I_out, ...
    procInd1_t13_I_out, ...
    procInd1_t14_I_out, ...
    procInd1_t17_I_out, ...
    procInd1_t18_I_out, ...
    procInd1_t19_I_out, ...
    procInd1_t20_I_out, ...
    procInd1_t22_I_out, ...
    procInd1_t23_I_out, ...
    procInd1_t27_I_out, ...
    procInd1_t29_I_out, ...
    smker, ...
    Xnum_t1_I_out, ...
    Xnum_t2_I_out, ...
    Xnum_t4_I_out, ...
    Xnum_t5_I_out, ...
    Xnum_t7_I_out, ...
    Xnum_t10_I_out, ...
    Xnum_t11_I_out, ...
    Xnum_t12_I_out, ...
    Xnum_t13_I_out, ...
    Xnum_t14_I_out, ...
    Xnum_t17_I_out, ...
    Xnum_t18_I_out, ...
    Xnum_t19_I_out, ...
    Xnum_t20_I_out, ...
    Xnum_t22_I_out, ...
    Xnum_t23_I_out, ...
    Xnum_t27_I_out, ...
    Xnum_t29_I_out, ...
    occ_Indicator_outbound, ...
    Lint_t1_I_out, ...
    Lint_t2_I_out, ...
    Lint_t4_I_out, ...
    Lint_t5_I_out, ...
    Lint_t7_I_out, ...
    Lint_t10_I_out, ...
    Lint_t11_I_out, ...
    Lint_t12_I_out, ...
    Lint_t13_I_out, ...
    Lint_t14_I_out, ...
    Lint_t17_I_out, ...
    Lint_t18_I_out, ...
    Lint_t19_I_out, ...
    Lint_t20_I_out, ...
    Lint_t22_I_out, ...
    Lint_t23_I_out, ...
    Lint_t27_I_out, ...
    Lint_t29_I_out, ...
    procInd1_t1_Ia_in, ...
    procInd1_t2_Ia_in, ...
    procInd1_t4_Ia_in, ...
    procInd1_t5_Ia_in, ...
    procInd1_t7_Ia_in, ...
    procInd1_t10_Ia_in, ...
    procInd1_t11_Ia_in, ...
    procInd1_t12_Ia_in, ...
    procInd1_t13_Ia_in, ...
    procInd1_t14_Ia_in, ...
    procInd1_t17_Ia_in, ...
    procInd1_t18_Ia_in, ...
    procInd1_t19_Ia_in, ...
    procInd1_t20_Ia_in, ...
    procInd1_t22_Ia_in, ...
    procInd1_t23_Ia_in, ...
    procInd1_t27_Ia_in, ...
    procInd1_t29_Ia_in, ...
    procInd1_t1_I_in, ...
    procInd1_t2_I_in, ...
    procInd1_t4_I_in, ...
    procInd1_t5_I_in, ...
    procInd1_t7_I_in, ...
    procInd1_t10_I_in, ...
    procInd1_t11_I_in, ...
    procInd1_t12_I_in, ...
    procInd1_t13_I_in, ...
    procInd1_t14_I_in, ...
    procInd1_t17_I_in, ...
    procInd1_t18_I_in, ...
    procInd1_t19_I_in, ...
    procInd1_t20_I_in, ...
    procInd1_t22_I_in, ...
    procInd1_t23_I_in, ...
    procInd1_t27_I_in, ...
    procInd1_t29_I_in, ...
    Xnum_t1_I_in, ...
    Xnum_t2_I_in, ...
    Xnum_t4_I_in, ...
    Xnum_t5_I_in, ...
    Xnum_t7_I_in, ...
    Xnum_t10_I_in, ...
    Xnum_t11_I_in, ...
    Xnum_t12_I_in, ...
    Xnum_t13_I_in, ...
    Xnum_t14_I_in, ...
    Xnum_t17_I_in, ...
    Xnum_t18_I_in, ...
    Xnum_t19_I_in, ...
    Xnum_t20_I_in, ...
    Xnum_t22_I_in, ...
    Xnum_t23_I_in, ...
    Xnum_t27_I_in, ...
    Xnum_t29_I_in, ...
    occ_Indicator_inbound, ...
    Lint_t1_I_in, ...
    Lint_t2_I_in, ...
    Lint_t4_I_in, ...
    Lint_t5_I_in, ...
    Lint_t7_I_in, ...
    Lint_t10_I_in, ...
    Lint_t11_I_in, ...
    Lint_t12_I_in, ...
    Lint_t13_I_in, ...
    Lint_t14_I_in, ...
    Lint_t17_I_in, ...
    Lint_t18_I_in, ...
    Lint_t19_I_in, ...
    Lint_t20_I_in, ...
    Lint_t22_I_in, ...
    Lint_t23_I_in, ...
    Lint_t27_I_in, ...
    Lint_t29_I_in ...
    ] = ...
    encode_state(...
    linear_position_file.linpos{day}{epoch}, ...
    position_file.pos{day}{epoch}, ...
    trajectory_encode_file.trajencode{day}{epoch}, ...
    ripples_file.ripplescons{day}{epoch}, ...
    spikes_file.spikes{day}{epoch}, ...
    tetrode_index, ...
    neuron_index);

sumStat = decode_state(...
    position_file.pos{day}{epoch}, ...
    rippleI, ...
    ripple_index, ...
    position_time_stamps, ...
    position_time_stamps_binned, ...
    vecLF, ...
    traj_Ind, ...
    time, ...
    stateV, ...
    stateV_delta, ...
    stateM_I1_normalized_gaussian, ...
    stateM_Indicator0_normalized_gaussian, ...
    Lint_Indicator_outbound, ...
    Lint_Indicator_inbound, ...
    tet_ind, ...
    tet_sum, ...
    markAll_t1, ...
    markAll_t2, ...
    markAll_t4, ...
    markAll_t5, ...
    markAll_t7, ...
    markAll_t10, ...
    markAll_t11, ...
    markAll_t12, ...
    markAll_t13, ...
    markAll_t14, ...
    markAll_t17, ...
    markAll_t18, ...
    markAll_t19, ...
    markAll_t20, ...
    markAll_t22, ...
    markAll_t23, ...
    markAll_t27, ...
    markAll_t29, ...
    procInd1_t1_Ia_out, ...
    procInd1_t2_Ia_out, ...
    procInd1_t4_Ia_out, ...
    procInd1_t5_Ia_out, ...
    procInd1_t7_Ia_out, ...
    procInd1_t10_Ia_out, ...
    procInd1_t11_Ia_out, ...
    procInd1_t12_Ia_out, ...
    procInd1_t13_Ia_out, ...
    procInd1_t14_Ia_out, ...
    procInd1_t17_Ia_out, ...
    procInd1_t18_Ia_out, ...
    procInd1_t19_Ia_out, ...
    procInd1_t20_Ia_out, ...
    procInd1_t22_Ia_out, ...
    procInd1_t23_Ia_out, ...
    procInd1_t27_Ia_out, ...
    procInd1_t29_Ia_out, ...
    procInd1_t1_I_out, ...
    procInd1_t2_I_out, ...
    procInd1_t4_I_out, ...
    procInd1_t5_I_out, ...
    procInd1_t7_I_out, ...
    procInd1_t10_I_out, ...
    procInd1_t11_I_out, ...
    procInd1_t12_I_out, ...
    procInd1_t13_I_out, ...
    procInd1_t14_I_out, ...
    procInd1_t17_I_out, ...
    procInd1_t18_I_out, ...
    procInd1_t19_I_out, ...
    procInd1_t20_I_out, ...
    procInd1_t22_I_out, ...
    procInd1_t23_I_out, ...
    procInd1_t27_I_out, ...
    procInd1_t29_I_out, ...
    smker, ...
    Xnum_t1_I_out, ...
    Xnum_t2_I_out, ...
    Xnum_t4_I_out, ...
    Xnum_t5_I_out, ...
    Xnum_t7_I_out, ...
    Xnum_t10_I_out, ...
    Xnum_t11_I_out, ...
    Xnum_t12_I_out, ...
    Xnum_t13_I_out, ...
    Xnum_t14_I_out, ...
    Xnum_t17_I_out, ...
    Xnum_t18_I_out, ...
    Xnum_t19_I_out, ...
    Xnum_t20_I_out, ...
    Xnum_t22_I_out, ...
    Xnum_t23_I_out, ...
    Xnum_t27_I_out, ...
    Xnum_t29_I_out, ...
    occ_Indicator_outbound, ...
    Lint_t1_I_out, ...
    Lint_t2_I_out, ...
    Lint_t4_I_out, ...
    Lint_t5_I_out, ...
    Lint_t7_I_out, ...
    Lint_t10_I_out, ...
    Lint_t11_I_out, ...
    Lint_t12_I_out, ...
    Lint_t13_I_out, ...
    Lint_t14_I_out, ...
    Lint_t17_I_out, ...
    Lint_t18_I_out, ...
    Lint_t19_I_out, ...
    Lint_t20_I_out, ...
    Lint_t22_I_out, ...
    Lint_t23_I_out, ...
    Lint_t27_I_out, ...
    Lint_t29_I_out, ...
    procInd1_t1_Ia_in, ...
    procInd1_t2_Ia_in, ...
    procInd1_t4_Ia_in, ...
    procInd1_t5_Ia_in, ...
    procInd1_t7_Ia_in, ...
    procInd1_t10_Ia_in, ...
    procInd1_t11_Ia_in, ...
    procInd1_t12_Ia_in, ...
    procInd1_t13_Ia_in, ...
    procInd1_t14_Ia_in, ...
    procInd1_t17_Ia_in, ...
    procInd1_t18_Ia_in, ...
    procInd1_t19_Ia_in, ...
    procInd1_t20_Ia_in, ...
    procInd1_t22_Ia_in, ...
    procInd1_t23_Ia_in, ...
    procInd1_t27_Ia_in, ...
    procInd1_t29_Ia_in, ...
    procInd1_t1_I_in, ...
    procInd1_t2_I_in, ...
    procInd1_t4_I_in, ...
    procInd1_t5_I_in, ...
    procInd1_t7_I_in, ...
    procInd1_t10_I_in, ...
    procInd1_t11_I_in, ...
    procInd1_t12_I_in, ...
    procInd1_t13_I_in, ...
    procInd1_t14_I_in, ...
    procInd1_t17_I_in, ...
    procInd1_t18_I_in, ...
    procInd1_t19_I_in, ...
    procInd1_t20_I_in, ...
    procInd1_t22_I_in, ...
    procInd1_t23_I_in, ...
    procInd1_t27_I_in, ...
    procInd1_t29_I_in, ...
    Xnum_t1_I_in, ...
    Xnum_t2_I_in, ...
    Xnum_t4_I_in, ...
    Xnum_t5_I_in, ...
    Xnum_t7_I_in, ...
    Xnum_t10_I_in, ...
    Xnum_t11_I_in, ...
    Xnum_t12_I_in, ...
    Xnum_t13_I_in, ...
    Xnum_t14_I_in, ...
    Xnum_t17_I_in, ...
    Xnum_t18_I_in, ...
    Xnum_t19_I_in, ...
    Xnum_t20_I_in, ...
    Xnum_t22_I_in, ...
    Xnum_t23_I_in, ...
    Xnum_t27_I_in, ...
    Xnum_t29_I_in, ...
    occ_Indicator_inbound, ...
    Lint_t1_I_in, ...
    Lint_t2_I_in, ...
    Lint_t4_I_in, ...
    Lint_t5_I_in, ...
    Lint_t7_I_in, ...
    Lint_t10_I_in, ...
    Lint_t11_I_in, ...
    Lint_t12_I_in, ...
    Lint_t13_I_in, ...
    Lint_t14_I_in, ...
    Lint_t17_I_in, ...
    Lint_t18_I_in, ...
    Lint_t19_I_in, ...
    Lint_t20_I_in, ...
    Lint_t22_I_in, ...
    Lint_t23_I_in, ...
    Lint_t27_I_in, ...
    Lint_t29_I_in ...
    );




