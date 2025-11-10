%% BUG NAMING
% It cannot name NNDataPoint_Spectrum as the getPropDefault will give you case
%  NNDataPoint_1 for ELCLASS etc.
%  "NNDataPoint_Spectrum" gives you "case NNDataPoint_1" 
%  "NNDataPoint_RamanSpectrum" gives you "case NNDataPoint_Raman1" 
%  This problem arises when it executed hard-coded constants.
%  My guess is that there is one element called "Spectrum", and this
%  interven any other elements "ending" with "Spectrum". This also explains
%  why "NNDataPoint_Graph_CLA" is ok.
%  Change to NNDataPoint_SpectrumSignal solved the
%  problem.

%% reset
close all; delete(findall(0, 'type', 'figure')); clear all

%% copy folders
el_to_edit = ['VariationalAutoencoderRamanSpectra']
%el_to_edit = ['VariationalAutoencoders_MNIST']
%el_to_edit = ['VariationalAutoencoderMLP']
el_to_compile = ['braph2genesis' filesep 'pipelines' filesep el_to_edit]
copyfile(el_to_edit, el_to_compile);

%% first compilation
el_path = [filesep 'pipelines' filesep el_to_edit];
%el_class_list = {'NNDatasetProcess_MNIST' 'NNVariationalAutoencoder'};
%el_class_list = {'NNDataPoint_Image'};
%el_class_list = {'NNDataPoint_Spectrum' 'NNDatasetProcess_Spectrum'}; 

%el_class_list = {'NNDataPoint_RamanSpectra' 'NNDatasetProcess_RamanSpectra' 'NNVariationalAutoencoderEvaluator_RS'};
el_class_list = {'NNDatasetProcess_RamanSpectra'};
regenerate(el_path, el_class_list, 'DoubleCompilation', false)

%% dependent class compiletion
el_path = [filesep 'src' filesep 'nn'];
el_class_list = {'NNDataPoint' 'NNDataset' 'NNBase' }
regenerate(el_path, el_class_list, 'DoubleCompilation', true)

%% second compiletion
el_path = [filesep 'pipelines' filesep el_to_edit];
%el_class_list = {'NNDatasetProcess_MNIST' 'NNVariationalAutoencoder'};
%el_class_list = {'NNDataPoint_Image'};
%el_class_list = {'NNDataPoint_Spectrum' 'NNDatasetProcess_Spectrum'};
%el_class_list = {'NNVariationalAutoencoder' 'NNVariationalAutoencoder2DCNN' 'NNVariationalAutoencoderEvaluator'};
%el_class_list = {'NNDataPoint_RamanSpectra' 'NNDatasetProcess_RamanSpectra' 'NNVariationalAutoencoderEvaluator_RS'};
el_class_list = {'NNDatasetProcess_RamanSpectra'};
regenerate(el_path, el_class_list, 'DoubleCompilation', true)

%%
scale_factor = 10;
dproc = NNDatasetProcess_RamanSpectra( ...
    'NORMALIZATION_RULE', 'Scale', ...
    'SCALE_FACTOR', scale_factor);

raw_data = cumsum(randn(5, 100), 2); % 5 features each datapoint, overall 100 datapoints
known_normed_data = raw_data / scale_factor;
calc_normed_data = dproc.get('NORMALIZE_DATA', raw_data);

tol = 1e-9;  % tweak as needed
assert(max(abs(calc_normed_data(:) - known_normed_data(:))) <= tol, ...
    [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
    'NNDatasetProcess_RamanSpectra does not normalize the data correctly..' ...
    )

calc_inv_normed_data = dproc.get('INV_NORMALIZE_DATA', calc_normed_data);

assert(max(abs(calc_inv_normed_data(:) - raw_data(:))) <= tol, ...
    [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
    'NNDatasetProcess_RamanSpectra does not inverse-normalize the data correctly..' ...
    )

%%
dproc = NNDatasetProcess_RamanSpectra('TRANSFORMATION_RULE', 'First derivative');

% Random MxL data (M rows = features, L columns = datapoints)
raw_data = cumsum(randn(5, 100), 2);
known_transformed = raw_data;
known_transformed(1:end-1, :) = raw_data(2:end, :) - raw_data(1:end-1, :);
known_transformed(end, :)= 0;
calc_transformed = dproc.get('TRANSFORM_DATA', raw_data);

tol = 1e-9;  % tweak as needed
assert(max(abs(calc_transformed(:) - known_transformed(:))) <= tol, ...
    [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
    'NNDatasetProcess_RamanSpectra does not transform (1st derivative) correctly.')

calc_inv_transformed = dproc.get('INV_TRANSFORM_DATA', calc_transformed, raw_data(1, :));

assert(max(abs(calc_inv_transformed(:) - raw_data(:))) <= tol, ...
    [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
    'NNDatasetProcess_RamanSpectra does not inverse-transform (1st derivative) correctly.')


%% 
dproc = NNDatasetProcess_RamanSpectra( ...
    'RAW_DATA_DIR', [fileparts(which('NNDatasetProcess_RamanSpectra')) filesep 'b2_files']);
%d_sp = dproc.get('D');


%%
dproc = NNDatasetProcess_SpectrumSignal( ...
    'RAW_DATA_DIR', [fileparts(which('NNDatasetProcess_SpectrumSignal')) filesep 'b2_files']);
d_sp = dproc.get('D');

%%
nnvae = NNVariationalAutoencoders_Structured('D', d_sp, 'EPOCHS', 2, 'BATCH', 8);
%nnvae.get('TARGETS', d_sp)
nnvae.get('TRAIN')

%%
nne = NNVariationalAutoencoders_Evaluator('NN', nnvae, 'D', d_mnist);
nne.get('PLOT_LATENT_REPRESENTATIONS')
nne.get('PLOT_LATENT_CONTINUITY')


%%
dproc = NNDatasetProcess_MNIST( ...
    'MNIST_IMAGE_FILE', [fileparts(which('NNDatasetProcess_MNIST')) filesep 'mnist_data' filesep 'train-images-idx3-ubyte.gz'], ...
    'MNIST_LABEL_FILE', [fileparts(which('NNDatasetProcess_MNIST')) filesep 'mnist_data' filesep 'train-labels-idx1-ubyte.gz'] ...
    );
d_mnist = dproc.get('D');

%%
inputs = NNVariationalAutoencoders().get('INPUTS', d_mnist);

trainImagesFile = "train-images-idx3-ubyte.gz";
XTrain = processImagesMNIST(trainImagesFile);


%%
nnvae = NNVariationalAutoencoders('D', d_mnist, 'EPOCHS', 2, 'BATCH', 128);
nnvae.get('TRAIN')

%%
nne = NNVariationalAutoencoders_Evaluator('NN', nnvae, 'D', d_mnist);
nne.get('PLOT_LATENT_REPRESENTATIONS')
nne.get('PLOT_LATENT_CONTINUITY')
