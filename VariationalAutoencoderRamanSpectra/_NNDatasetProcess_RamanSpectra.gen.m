%% ¡header!
NNDatasetProcess_RamanSpectra < NNDatasetProcess (dproc, processing for a neural network data) processes raw MNIST data into a neural network datasets.

%%% ¡description!
The Raman sepctrum processing for a neural network dataset (NNDatasetProcess_Spectrum) processes the raw raman spectrum data into a neural network dataset. 
 The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.

%%% ¡seealso!
NNDatasetProcess, NNDataPoint

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of processing MNIST data for a neural networks datasets.
%%%% ¡default!
'NNDatasetProcess_RamanSpectra'

%%% ¡prop!
NAME (constant, string) is the name of processing MNIST data for a neural networks datasets.
%%%% ¡default!
'Processing Raman Spectrum Data for a Neural Network Dataset'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of processing data for a neural networks datasets.
%%%% ¡default!
'The MNIST processing for a neural network dataset (NNDatasetProcess_MNIST) processes the raw MNIST data into a neural network dataset. The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of processing data for a neural networks datasets.
%%%% ¡settings!
'NNDatasetProcess_RamanSpectra'

%%% ¡prop!
ID (data, string) is a few-letter code of processing data for a neural networks datasets.
%%%% ¡default!
'NNDatasetProcess_RamanSpectra ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of processing data for a neural networks datasets.
%%%% ¡default!
'NNDatasetProcess_RamanSpectra label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes of processing data for a neural networks datasets.
%%%% ¡default!
'NNDatasetProcess_RamanSpectra notes'

%%% ¡prop!
D (result, item) is the neural network dataset containing the datapoint processed from the raw data.
%%%% ¡settings!
'NNDataset'
%%%% ¡calculate!
processed_spectrum_list = dproc.get('PROCESS_DATA');
raw_label_list = dproc.get('EXTRACT_LABELS');

targets_to_remove = dproc.get('TARGETS_TO_REMOVE');
idx_to_remove = [];
if ~isempty(targets_to_remove)
    for t = 1:length(targets_to_remove)
        target_to_remove = targets_to_remove{t};
        for i = 1:length(raw_label_list)
            if any(contains(cellstr(raw_label_list{i}), target_to_remove))
                idx_to_remove = [idx_to_remove i];
            end
        end
    end
end

processed_spectrum_list(idx_to_remove) = [];
raw_label_list(idx_to_remove) = [];

it_list = cellfun(@(data, label) NNDataPoint_RamanSpectra( ...
    'SP_DATA', data, ...
    'WL', dproc.getCallback('WAVELENGTH'), ...
    'WL_START', dproc.getCallback('WAVELENGTH_START'), ...
    'WL_END', dproc.getCallback('WAVELENGTH_END'), ...
    'TARGET_CLASS', {label}), ...
    processed_spectrum_list, raw_label_list,...
    'UniformOutput', false);

dp_list = IndexedDictionary(...
        'IT_CLASS', 'NNDataPoint_RamanSpectra', ...
        'IT_LIST', it_list ...
        );

value = NNDataset( ...
    'DP_CLASS', 'NNDataPoint_RamanSpectra', ...
    'DP_DICT', dp_list ...
    );

%% ¡props!

%%% ¡prop!
TARGETS_TO_REMOVE (data, stringlist) contains the directory of the b2 file for spectrum data.
%%%% ¡default!
{'ps'}

%%% ¡prop!
RAW_DATA_DIR (data, string) contains the directory of the b2 file for spectrum data.

%%% ¡prop!
WAVELENGTH_START (parameter, scalar) is the starting wavelength.
%%%% ¡default!
600

%%% ¡prop!
WAVELENGTH_END (parameter, scalar) is the ending  wavelength.
%%%% ¡default!
1750

%%% ¡prop!
TRANSFORMATION_RULE (parameter, option) is the transformation methods.
%%%% ¡settings!
{'First derivative'}
%%%% ¡default!
'First derivative'

%%% ¡prop!
NORMALIZATION_RULE (parameter, option) is the normalization methods.
%%%% ¡settings!
{'Scale'}
%%%% ¡default!
'Scale'

%%% ¡prop!
SCALE_FACTOR (parameter, scalar) is the normalization methods.
%%%% ¡default!
1
%%%% ¡postset!
if ~isequal(dproc.get('NORMALIZATION_RULE'), 'Scale')
    dproc.set('SCALE_FACTOR', 1)
end

%%% ¡prop!
WAVELENGTH (result, cvector) is the wavelength.
%%%% ¡calculate!
dir_name = dproc.get('RAW_DATA_DIR');
if isempty(dir_name)
    value = [];
    return
end
file_list = dir([dir_name filesep '*b2']);
if isequal(length(file_list), 0)
    value = [];
    return
end
for i = 1:length(file_list)
    file_names(i) = string(file_list(i).name);
end
file_names = file_names';

b2_el = load([dir_name filesep char(file_names(1))], '-mat');

% simplify this part
if strcmp(b2_el.el.get('ELCLASS'), 'Pipeline')
    sp_dict = b2_el.el.get('PS_DICT').get('IT', 7).get('PC_DICT').get('IT', 1).get('EL').get('RE_OUT').get('SP_DICT');
elseif strcmp(b2_el.el.get('ELCLASS'), 'RamanExperiment')
    sp_dict = b2_el.el.get('SP_DICT');
elseif strcmp(b2_el.el.get('ELCLASS'), 'BaselineRemover')
    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
elseif strcmp(b2_el.el.get('ELCLASS'), 'CosmicRayNoiseRemover')
    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
end
value = sp_dict.get('IT', 1).get('WAVELENGTH');

%%% ¡prop!
TRANSFORM_DATA (query, cell) normalizes the images from the specified IDX files.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end
data = varargin{1};
if isempty(data)
    value = {};
    return
end
transformation = dproc.get('TRANSFORMATION_RULE');
switch transformation
    case 'First derivative' % first derivative
        data_tmp = data;
        data_tmp = data_tmp(2:end, :) - data_tmp(1:end-1, :);
        data(1:end-1, :) = data_tmp;
        data(end, :) = 0;
end
value = data;

%%% ¡prop!
INV_TRANSFORM_DATA (query, cell) inverse-tranforms the images from the specified IDX files.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end
deriv = varargin{1};
if isempty(deriv)
    value = {};
    return
end
transformation = dproc.get('TRANSFORMATION_RULE');
switch transformation
    case 'First derivative' % first derivative
        base_row = varargin{2}; % should be raw_data(1, :)
        detransformed_x = base_row + cumsum([zeros(1, size(deriv, 2)); deriv(1:end-1,:)], 1);;
end
value = detransformed_x;

%%% ¡prop!
NORMALIZE_DATA (query, cell) normalizes the images from the specified IDX files.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end
data = varargin{1};
if isempty(data)
    value = {};
    return
end
normalization = dproc.get('NORMALIZATION_RULE');
switch normalization
    case 'Scale' 
        scale_factor = dproc.get('SCALE_FACTOR');
        data = data ./ scale_factor;
end
value = data;

%%% ¡prop!
INV_NORMALIZE_DATA (query, cell) inverse-normalizes the images from the specified IDX files.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end
data = varargin{1};
if isempty(data)
    value = {};
    return
end
normalization = dproc.get('NORMALIZATION_RULE');
switch normalization
    case 'Scale' 
        scale_factor = dproc.get('SCALE_FACTOR');
        data = data .* scale_factor;
end
value = data;

%%% ¡prop!
RAW_DATA (result, cell) processes the data with normalization and transformation.
%%%% ¡calculate!
value = dproc.get('EXTRACT_DATA');

%%% ¡prop!
PROCESS_DATA (query, cell) processes the data with normalization and transformation.
%%%% ¡calculate!
X_raw = dproc.get('RAW_DATA');
if isempty(X_raw)
    value = {};
    return
end
X = cat(2, X_raw{:});
X_tr = dproc.get('TRANSFORM_DATA', X);
X_tr_nor = dproc.get('NORMALIZE_DATA', X_tr);

for i = 1:size(X_tr_nor, 2)
    value{i} = X_tr_nor(:, i);
end

%%% ¡prop!
REV_PROCESS_DATA (query, cell) reverse the process step the data with normalization and transformation.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end
data = varargin{1};
selected_idx = varargin{2};
inv_norm_data = dproc.get('INV_NORMALIZE_DATA', data);
inv_tran_inv_norm_data = dproc.get('INV_TRANSFORM_DATA', inv_norm_data, selected_idx);

for i = 1:size(inv_tran_inv_norm_data, 2)
    value{i} = inv_tran_inv_norm_data(:, i);
end

%%% ¡prop!
EXTRACT_DATA (query, cell) extracts the sepctral data with dimension of wavelength x datapoints.
%%%% ¡calculate!
dir_name = dproc.get('RAW_DATA_DIR');
if isempty(dir_name)
    value = {};
    return
end
file_list = dir([dir_name filesep '*b2']);
for i = 1:length(file_list)
    file_names(i) = string(file_list(i).name);
end
file_names = file_names';

X = [];
for file_idx = 1:length(file_names)
    file_name = file_names(file_idx);
    b2_el = load([dir_name filesep char(file_name)], '-mat');

    num_spectrum_file = b2_el.el.get('RE_OUT').get('SP_DICT').get('LENGTH');
    ids = cellfun(@(spectrum) spectrum.get('ID'), b2_el.el.get('RE_OUT').get('SP_DICT').get('IT_LIST') ,'UniformOutput', false);

    num_previous_col = size(X, 2);
    
    for i = 1:num_spectrum_file
        intensities = b2_el.el.get('RE_OUT').get('SP_DICT').get('IT', i).get('INTENSITIES');
        num_col = size(intensities, 2);
        if file_idx == 1
            counter1 = (i-1)*num_col + 1;
            counter2 = num_col*i;
        else
            counter1 = (i-1)*num_col + 1 + num_previous_col;
            counter2 = num_col*i + num_previous_col;
        end

        % get X
        X(:, counter1:counter2)= intensities;
    end
end

for i = 1:size(X, 2)
    value{i} = X(:, i);
end

%%% ¡prop!
EXTRACT_LABELS (query, stringlist) extracts the labels from the specified IDX files.
%%%% ¡calculate!
dir_name = dproc.get('RAW_DATA_DIR');
if isempty(dir_name)
    value = {};
    return
end
file_list = dir([dir_name filesep '*b2']);
for i = 1:length(file_list)
    file_names(i) = string(file_list(i).name);
end
file_names = file_names';

Y = "";
for file_idx = 1:length(file_names)
    file_name = file_names(file_idx);
    b2_el = load([dir_name filesep char(file_name)], '-mat');

    num_spectrum_file = b2_el.el.get('RE_OUT').get('SP_DICT').get('LENGTH');
    ids = cellfun(@(spectrum) spectrum.get('ID'), b2_el.el.get('RE_OUT').get('SP_DICT').get('IT_LIST') ,'UniformOutput', false);

    num_previous_col = size(Y, 2);
    
    for i = 1:num_spectrum_file
        intensities = b2_el.el.get('RE_OUT').get('SP_DICT').get('IT', i).get('INTENSITIES');
        num_col = size(intensities, 2);
        if file_idx == 1
            counter1 = (i-1)*num_col + 1;
            counter2 = num_col*i;
        else
            counter1 = (i-1)*num_col + 1 + num_previous_col;
            counter2 = num_col*i + num_previous_col;
        end

        id = ids{i};
        Y(1, counter1:counter2) = extractBetween(file_name, '_', '_'); % type
        if Y(1, counter1:counter2) == "AB2"
            Y(1, counter1:counter2) = "AB";
        end 

        if contains(id, 'WL')
            Y(2, counter1:counter2) = "WL"; % shade
        elseif contains(id, 'HL')
            Y(2, counter1:counter2) = "HL"; % shade
        elseif contains(id, 'LL')
            Y(2, counter1:counter2) = "LL"; % shade
        elseif contains(id, 'SH')
            Y(2, counter1:counter2) = "SH"; % shade
        elseif contains(id, 'ps')
            Y(2, counter1:counter2) = "ps"; % shade
        end
        if contains(id, 'loc1')
            Y(3, counter1:counter2) = "loc1"; % location
        elseif contains(id, 'loc2')
            Y(3, counter1:counter2) = "loc2"; % location
        elseif contains(id, 'ps')
            Y(3, counter1:counter2) = "ps"; % location
        end
        Y(4, counter1:counter2) = id; % id of the plant
    end
end

for i = 1:size(Y, 2)
    value{i} = char(Y(:, i));
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Construction of an Empty Spectrum Dataset
%%%% ¡code!
dproc = NNDatasetProcess_RamanSpectra();
d_sp = dproc.get('D');

assert(isequal(d_sp.get('DP_DICT').get('LENGTH'), 0), ...
    [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
    'NNDatasetProcess_RamanSpectra does not construct the dataset correctly. The input value is not derived correctly.' ...
    )

%%% ¡test!
%%%% ¡name!
Test normalization and inverse normalization
%%%% ¡code!
scale_factor = 10;
dproc = NNDatasetProcess_RamanSpectra( ...
    'NORMALIZATION_RULE', 'Scale', ...
    'SCALE_FACTOR', scale_factor);

raw_data = cumsum(randn(5, 100), 2); % 5 features each datapoint, overall 100 datapoints
known_normed_data = raw_data / scale_factor;
% % % calc_normed_data = dproc.get('NORMALIZE_DATA', raw_data);
% % % 
% % % assert(isequal(calc_normed_data, known_normed_data), ...
% % %     [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
% % %     'NNDatasetProcess_RamanSpectra does not normalize the data correctly..' ...
% % %     )
% % % 
% % % calc_inv_normed_data = dproc.get('INV_NORMALIZE_DATA', calc_normed_data);
% % % 
% % % assert(isequal(calc_inv_normed_data, raw_data), ...
% % %     [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
% % %     'NNDatasetProcess_RamanSpectra does not inverse-normalize the data correctly..' ...
% % %     )

%%% ¡test!
%%%% ¡name!
Test tranformation and inverse tranformation
%%%% ¡code!
dproc = NNDatasetProcess_RamanSpectra('TRANSFORMATION_RULE', 'First derivative');

% Random MxL data (M rows = features, L columns = datapoints)
raw_data = cumsum(randn(5, 100), 2);
known_transformed = raw_data;
known_transformed(1:end-1, :) = raw_data(2:end, :) - raw_data(1:end-1, :);
known_transformed(end, :)= 0;
calc_transformed = dproc.get('TRANSFORM_DATA', raw_data);

% % % assert(isequal(calc_transformed, known_transformed), ...
% % %     [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
% % %     'NNDatasetProcess_RamanSpectra does not transform (1st derivative) correctly.')
% % % 
% % % calc_inv_transformed = dproc.get('INV_TRANSFORM_DATA', calc_transformed);
% % % 
% % % assert(isequal(calc_inv_transformed, raw_data), ...
% % %     [BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.FAIL_TEST], ...
% % %     'NNDatasetProcess_RamanSpectra does not inverse-transform (1st derivative) correctly.')
% % % 
