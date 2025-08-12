%% ¡header!
NNVariationalAutoencodersMLP < NNVariationalAutoencoders (nnvae, normalizer of a neural network data) transfroms neural network datasets.

%%% ¡description!
A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
The resulting combined dataset contains all the unique datapoints from the input datasets, 
and any overlapping datapoints are excluded to ensure data consistency.

%%% ¡seealso!
NNDataset, NNDatasetSplit

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
%%%% ¡default!
'NNVariationalAutoencoders_Structured'

%%% ¡prop!
NAME (constant, string) is the name of the combiner of neural networks datasets.
%%%% ¡default!
'Neural Network Variational Autoencoders'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
%%%% ¡default!
'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
%%%% ¡settings!
'NNVariationalAutoencoders_Structured'

%%% ¡prop!
ID (data, string) is a few-letter code of the combiner of neural networks datasets.
%%%% ¡default!
'NNDatasetCombine ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
%%%% ¡default!
'NNDatasetCombine label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
%%%% ¡default!
'NNDatasetCombine notes'

%%% ¡prop!
D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.
%%%% ¡settings!
'NNDataset'
%%%% ¡default!
NNDataset('DP_CLASS', 'NNDataPoint')
%%%% ¡check_value!
check = ismember(value.get('DP_CLASS'), nnvae.get('DP_CLASSES'));
%%%% ¡postset!
if ~isequal(nnvae.get('D').get('DP_DICT').get('LENGTH'), 0)
    input_data = cell2mat(nnvae.get('D').get('DP_DICT').get('IT', 1).get('INPUT'));
    size_input = size(input_data);
    nnvae.set('SIZE_INPUT', size_input);
end
if isa(nnvae.getr('ENCODER'), 'NoValue')
    numLatentChannels = nnvae.get('NUM_LATENT_REP');
    inputSize = nnvae.get('SIZE_INPUT');
    numFeature = prod(inputSize);

    layersE = [
        featureInputLayer(numFeature, Normalization="none")
        fullyConnectedLayer(64)
        reluLayer
        fullyConnectedLayer(2*numLatentChannels, 'Name', 'latentOuput')
        samplingLayer];

    nnvae.set('ENCODER', dlnetwork(layersE));
end
if isa(nnvae.getr('DECODER'), 'NoValue')
    % Calculate projection size
    inputSize = nnvae.get('SIZE_INPUT');
    numFeature = prod(inputSize);
    numLatentChannels = nnvae.get('NUM_LATENT_REP');

    layersD = [
        featureInputLayer(numLatentChannels, Normalization="none")
        fullyConnectedLayer(64)
        reluLayer
        fullyConnectedLayer(numFeature)
        leakyReluLayer(1)];

    nnvae.set('DECODER', dlnetwork(layersD));
end

%%% ¡prop!
DP_CLASSES (parameter, classlist) is the list of compatible data points.
%%%% ¡default!
{'NNDataPoint' 'NNDataPoint_SpectrumSignal'}

%%% ¡prop!
INPUTS (query, cell) constructs the cell array of the data.
%%%% ¡calculate!
% inputs = nn.get('inputs', D) returns a cell array with the
%  inputs for all data points in dataset D.
if isempty(varargin)
    value = {};
    return
end
d = varargin{1};
inputs_group = d.get('INPUTS');
if isempty(inputs_group)
    value = {};
else
    [s1, s2] = size(cell2mat(inputs_group{1}));
    % Extract the 28x28 arrays from the inner cells
    flat_cells = cellfun(@(c) c{1}, inputs_group, 'UniformOutput', false);
    value = reshape(cat(1, flat_cells{:}), s1, []);
end

%%% ¡prop!
TARGETS (query, stringlist) constructs the cell array of the targets.
%%%% ¡calculate!
% targets = nn.get('PREDICT', D) returns a cell array with the
%  targets for all data points in dataset D.
if isempty(varargin)
    value = {};
    return
end
d = varargin{1};
targets = cellfun(@(dp) dp.get('TARGET_CLASS'), d.get('DP_DICT').get('IT_LIST'), 'UniformOutput', false)
if isempty(targets)
    value = {};
else
    flat_cells = cellfun(@(c) c{:}, targets, 'UniformOutput', false);
    value = cat(1, flat_cells{:}); % check
end

%%% ¡prop!
TRAIN (query, empty) trains the neural network model with the given dataset.
%%%% ¡calculate!
numEpochs = nnvae.get('EPOCHS');
miniBatchSize = nnvae.get('BATCH');
learnRate = nnvae.get('LEARN_RATE');

d = nnvae.get('D');
if isequal(d.get('DP_DICT').get('LENGTH'), 0)
    value = [];
    return
end

XTrain = nnvae.get('INPUTS', d);
YTrain = 1:1:size(XTrain, 2);
YTrain = YTrain';

dsXTrain = arrayDatastore(XTrain, IterationDimension=2); % need to be a property the iterationdimension
dsYTrain = arrayDatastore(YTrain);
dsTrain = combine(dsXTrain, dsYTrain);

numOutputs = 2; % need to be a property

% need to be a query
mbq = minibatchqueue(dsTrain,numOutputs, ...
    MiniBatchSize = miniBatchSize, ...
    MiniBatchFcn=@preprocessMiniBatch, ...
    MiniBatchFormat=["CB", ""], ...
    PartialMiniBatch="discard");

netD = nnvae.get('DECODER');
netE = nnvae.get('ENCODER');

trailingAvgE = [];
trailingAvgSqE = [];
trailingAvgD = [];
trailingAvgSqD = [];

numObservationsTrain = d.get('DP_DICT').get('LENGTH');
numIterationsPerEpoch = ceil(numObservationsTrain / miniBatchSize);
numIterations = numEpochs * numIterationsPerEpoch;

monitor = trainingProgressMonitor( ...
    Metrics = "Loss", ...
    Info = "Epoch", ...
    XLabel = "Iteration");

epoch = 0;
iteration = 0;

% Loop over epochs.
while epoch < numEpochs && ~monitor.Stop
    epoch = epoch + 1;

    % Shuffle data.
    shuffle(mbq);

    % Loop over mini-batches.
    while hasdata(mbq) && ~monitor.Stop
        iteration = iteration + 1;

        % Read mini-batch of data.
        [X, Y] = next(mbq);

        % Evaluate loss and gradients.
        [loss,gradientsE,gradientsD] = dlfeval(@modelLoss, netE, netD, X);

        % Update learnable parameters.
        [netE,trailingAvgE,trailingAvgSqE] = adamupdate(netE, ...
            gradientsE,trailingAvgE,trailingAvgSqE,iteration, learnRate);

        [netD, trailingAvgD, trailingAvgSqD] = adamupdate(netD, ...
            gradientsD,trailingAvgD,trailingAvgSqD,iteration, learnRate);

        % Update the training progress monitor. 
        recordMetrics(monitor,iteration,Loss=loss);
        updateInfo(monitor,Epoch=epoch + " of " + numEpochs);
        monitor.Progress = 100*iteration/numIterations;
    end
end
nnvae.set('ENCODER', netE);
nnvae.set('DECODER', netD);

value = [];

%%%% ¡calculate_callbacks!
function [loss, gradientsE, gradientsD] = modelLoss(netE, netD, X) % need to be a property   
    % Forward through encoder.
    [Z,mu,logSigmaSq] = forward(netE,X);
    
    % Forward through decoder.
    Y = forward(netD,Z);
    
    % Calculate loss and gradients.
    loss = nnvae.get('ELBO_LOSS', Y, X, mu, logSigmaSq);
    [gradientsE,gradientsD] = dlgradient(loss,netE.Learnables,netD.Learnables);
end
function [X, Y] = preprocessMiniBatch(XCell, YCell)    % need to be a property
    % Concatenate.
    X = cat(2, XCell{:});
    
    % Extract label data from cell and concatenate.
    Y = cat(2, YCell{:});

% Extract label data from cell and concatenate.
Y = cat(2,YCell{:});
end

%% ¡props!

%%% ¡prop!
SIZE_INPUT (parameter, rvector) is the size of the input data.
%%%% ¡default!
[1000 1]

%% ¡tests!
