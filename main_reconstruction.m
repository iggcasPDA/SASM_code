%% South Asian Summer Monsoon Index Reconstruction - Main Script
% Run all steps in sequence

clear; clc; close all;

% Set random seed
rng(3407);

% Run all steps
fprintf('Starting SASM reconstruction...\n\n');

step0_extract_inst
fprintf('Step 0 completed\n');

step1_select_data
fprintf('Step 1 completed\n');

step2_divide_into_group
fprintf('Step 2 completed\n');

step3_PLS_PCR
fprintf('Step 3 completed\n');

step4_oie
fprintf('Step 4 completed\n');

step5_get_results
fprintf('\nReconstruction completed!\n');
fprintf('Results saved to: SASMI_oie_recon_1850_2010_*.csv\n');