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
el_class_list = {'NNVariationalAutoencoderEvaluator_RS'};
regenerate(el_path, el_class_list, 'DoubleCompilation', false)

%% dependent class compiletion
el_path = [filesep 'src' filesep 'nn'];
el_class_list = {'NNDataPoint' 'NNBase' 'NNDataset'}
regenerate(el_path, el_class_list, 'DoubleCompilation', true)

%% second compiletion
el_path = [filesep 'pipelines' filesep el_to_edit];
%el_class_list = {'NNDatasetProcess_MNIST' 'NNVariationalAutoencoder'};
%el_class_list = {'NNDataPoint_Image'};
%el_class_list = {'NNDataPoint_Spectrum' 'NNDatasetProcess_Spectrum'};
%el_class_list = {'NNVariationalAutoencoder' 'NNVariationalAutoencoder2DCNN' 'NNVariationalAutoencoderEvaluator'};
%el_class_list = {'NNDataPoint_RamanSpectra' 'NNDatasetProcess_RamanSpectra' 'NNVariationalAutoencoderEvaluator_RS'};
el_class_list = {'NNVariationalAutoencoderEvaluator_RS'};
regenerate(el_path, el_class_list, 'DoubleCompilation', true)

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
