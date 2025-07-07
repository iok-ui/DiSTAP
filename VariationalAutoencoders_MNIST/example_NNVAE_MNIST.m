%% EXAMPLE_NNCV_CON_BUD_M_CLA
% Script example pipeline for NN regression cross-validation with input of GraphBUD measures derived from SubjectCON 

clear variables %#ok<*NASGU>

%% Load MNIST Dataset
dproc = NNDatasetProcess_MNIST( ...
    'MNIST_FILE', [fileparts(which('NNDatasetProcess_MNIST')) filesep 'mnist_data' filesep 'train-images-idx3-ubyte.gz'], ...
    'LABEL_FILE', [fileparts(which('NNDatasetProcess_MNIST')) filesep 'mnist_data' filesep 'train-labels-idx1-ubyte.gz']...
    );
d_mnist = dproc.get('D');

%% Split for Training/Test
d_split = NNDatasetSplit('D', d_mnist, 'SPLIT', {0.7, 0.3});
d_training = d_split.get('D_LIST_IT', 1);
d_test = d_split.get('D_LIST_IT', 2);

%% Train a Variational Autoencoder
nn = NNRegressorMLP('D', d_training, 'LAYERS', [20 20]);
nn.get('TRAIN');

%% Evaluate and visualize Latent Space
