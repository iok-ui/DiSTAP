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
el_class_list = {'NNDatasetProcess_RamanSpectra' 'NNVariationalAutoencoderEvaluator_RS'};
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