%% EXAMPLE_NNVAE_SPECTRUM
% Script example pipeline for NN Variational Autoencoders with Raman
% Spectrum Data

clear variables %#ok<*NASGU>

%% Load Spectra Dataset
dproc = NNDatasetProcess_SpectrumSignal( ...
    'RAW_DATA_DIR', [fileparts(which('NNDatasetProcess_SpectrumSignal')) filesep 'b2_files'], ...
    'TRANSFORMATION_RULE', 'First derivative', ...
    'NORMALIZATION_RULE', 'Scale', ...
    'SCALE_FACTOR', 100);
d_sp = dproc.get('D');

%% Train a Variational Autoencoder
nnvae = NNVariationalAutoencoders_Structured('D', d_sp, 'EPOCHS', 10, 'BATCH', 32);
nnvae.get('TRAIN')

%% Evaluate and Visualize Latent Space
nne = NNVariationalAutoencoders_Evaluator('NN', nnvae, 'D', d_sp);

% latent space
figure
nne.get('PLOT_LATENT_REPRESENTATIONS')

% Peak identification
% % % figure
% % % nne.get('PLOT_PEAK_IDENTIFICATIONS')
