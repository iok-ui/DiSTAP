%% ¡header!
NNVariationalAutoencoders < NNBase (nnvae, normalizer of a neural network data) transfroms neural network datasets.

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
'NNVariationalAutoencoders'

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
'NNVariationalAutoencoders'

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
    if isequal(length(size(input_data)), 2) % only 1 channel
        size_img = [size(input_data) 1]; % force it to be length, width, channel
    else
        size_img = size(input_data);
    end
    nnvae.set('SIZE_IMG', size_img);
end
if isa(nnvae.getr('ENCODER'), 'NoValue')
    numLatentChannels = nnvae.get('NUM_LATENT_REP');
    imageSize = nnvae.get('SIZE_IMG');

    layersE = [
        imageInputLayer(imageSize, Normalization="none")
        convolution2dLayer(3, 32, Padding="same", Stride=2)
        leakyReluLayer(0.2)
        convolution2dLayer(3, 64, Padding="same", Stride=2)
        leakyReluLayer(0.2)
        fullyConnectedLayer(16)
        leakyReluLayer(0.2)
        fullyConnectedLayer(2*numLatentChannels, 'Name', 'latentOuput')
        samplingLayer];

    nnvae.set('ENCODER', dlnetwork(layersE));
end
if isa(nnvae.getr('DECODER'), 'NoValue')
    % Calculate projection size
    projectChannels = 64; % comes from encoder, the last convolutional layer
    stride = 2; % comes from encoder, the last convolutional layer
    num_layer_with_stride = 2; % come from encoder, there are two convolutional layers with strides
    projSize = imageSize(1:2);
    for i = 1:2 % two stride-2 layers
        projSize = ceil(projSize / stride);
    end
    projectionSize = [projSize projectChannels];

    numInputChannels = imageSize(3);
    numLatentChannels = nnvae.get('NUM_LATENT_REP');

    layersD = [
        featureInputLayer(numLatentChannels)
        fullyConnectedLayer(prod(projectionSize))
        leakyReluLayer(0.2)
        projectAndReshapeLayer(projectionSize)
        transposedConv2dLayer(3, 64, Cropping="same", Stride=2)
        leakyReluLayer(0.2)
        transposedConv2dLayer(3, 32, Cropping="same", Stride=2)
        leakyReluLayer(0.2)
        transposedConv2dLayer(3, numInputChannels, Cropping="same")
        sigmoidLayer];

    nnvae.set('DECODER', dlnetwork(layersD));
end

%%% ¡prop!
DP_CLASSES (parameter, classlist) is the list of compatible data points.
%%%% ¡default!
{'NNDataPoint' 'NNDataPoint_Image'}

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
    value = reshape(cat(3, flat_cells{:}), s1, s2, 1, []);
end

%%% ¡prop!
TARGETS (query, cell) constructs the cell array of the targets.
%%%% ¡calculate!
% targets = nn.get('PREDICT', D) returns a cell array with the
%  targets for all data points in dataset D.
if isempty(varargin)
    value = {};
    return
end
d = varargin{1};
targets_group = d.get('TARGETS');
if isempty(targets_group)
    value = {};
else
    flat_cells = cellfun(@(c) c{1}, targets_group, 'UniformOutput', false);
    value = cat(1, flat_cells{:});
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
YTrain = categorical(nnvae.get('TARGETS', d));

dsXTrain = arrayDatastore(XTrain, IterationDimension=4);
dsYTrain = arrayDatastore(YTrain);
dsTrain = combine(dsXTrain, dsYTrain);

numOutputs = nnvae.get('NUM_LATENT_REP');;

mbq = minibatchqueue(dsTrain, numOutputs, ...
    MiniBatchSize = miniBatchSize, ...
    MiniBatchFcn = @preprocessMiniBatch, ...
    MiniBatchFormat = ["SSCB", ""], ...
    PartialMiniBatch = "discard");

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
        [loss,gradientsE,gradientsD] = dlfeval(@modelLoss, netE, netD,X);

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
function [loss, gradientsE, gradientsD] = modelLoss(netE, netD, X)    
    % Forward through encoder.
    [Z,mu,logSigmaSq] = forward(netE,X);
    
    % Forward through decoder.
    Y = forward(netD,Z);
    
    % Calculate loss and gradients.
    loss = nnvae.get('ELBO_LOSS', Y, X, mu, logSigmaSq);
    [gradientsE,gradientsD] = dlgradient(loss,netE.Learnables,netD.Learnables);
end
function [X, Y] = preprocessMiniBatch(XCell, YCell)    
    % Concatenate.
    X = cat(4, XCell{:});
    
    % Extract label data from cell and concatenate.
    Y = cat(2, YCell{:});
    
    % One-hot encode labels.
    Y = onehotencode(Y, 1);
end

%% ¡props!

%%% ¡prop!
LEARN_RATE (parameter, scalar) is the size of the mini-batch used for each training iteration.
%%%% ¡default!
1e-3

%%% ¡prop!
NUM_LATENT_REP (parameter, scalar) is the size of the mini-batch used for each training iteration.
%%%% ¡default!
2

%%% ¡prop!
SIZE_IMG (parameter, rvector) is the size of the input image.
%%%% ¡default!
[28 28 1]

%%% ¡prop!
ENCODER (data, net) is a trained neural network encoder with the given dataset.

%%% ¡prop!
DECODER (data, net) is a trained neural network decoder with the given dataset.

%%% ¡prop!
ELBO_LOSS (query, scalar) returns the elbo loss.
%%%% ¡calculate!
if length(varargin) < 4
    value = 0;
    return
end
y = varargin{1};
t = varargin{2};
mu = varargin{3};
logSigmaSq = varargin{4};

% Reconstruction loss
reconstructionLoss = mse(y, t);

% KL divergence
KL = -1/2 * sum(1 + logSigmaSq - mu.^2 - exp(logSigmaSq),1);
KL = mean(KL);

% Combined loss
value = reconstructionLoss + KL;

%% ¡tests!
