%% ¡header!
NNAutoencoder < NNBase (nnae, a neural-network autoencoder) is a neural-network autoencoder.

%%% ¡description!
A neural-network autoencoder (NNAutoencoder) comprises an encoder and a decoder and is trained with a loss function that compares the reconstruction to the input in an unsupervised manner.
 This element trains on a neural-network dataset (NNDataset).

Instances of this class are not meant to be created directly—use one of its subclasses.

%%% ¡seealso!
NNDataset, NNDatasetSplit, NNVariationalAutoencoder

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the neural-network autoencoder.
%%%% ¡default!
'NNAutoencoder'

%%% ¡prop!
NAME (constant, string) is the name of the neural-network autoencoder.
%%%% ¡default!
'Neural-Network Autoencoder'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the neural-network autoencoder.
%%%% ¡default!
'A neural-network autoencoder (NNAutoencoder) comprises an encoder and a decoder and is trained with a loss function that compares the reconstruction to the input in an unsupervised manner. This element trains on a neural-network dataset (NNDataset). Instances of this class are not meant to be created directly—use one of its subclasses.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the neural-network autoencoder.
%%%% ¡settings!
'NNAutoencoder'

%%% ¡prop!
ID (data, string) is a few-letter code of the nneural-network autoencoder.
%%%% ¡default!
'NNAutoencoder ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the neural-network autoencoder.
%%%% ¡default!
'NNAutoencoder label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes of the neural-network autoencoder.
%%%% ¡default!
'NNAutoencoder notes'

%%% ¡prop!
D (data, item) is the dataset used to train the autoencoder. Its data-point class DP_CLASS must belong to the compatible set DP_CLASSES.
%%%% ¡settings!
'NNDataset'
%%%% ¡default!
NNDataset('DP_CLASS', 'NNDataPoint')
%%%% ¡check_value!
check = ismember(value.get('DP_CLASS'), nnae.get('DP_CLASSES'));

%%% ¡prop!
DP_CLASSES (parameter, classlist) is the list of compatible data-point classes for this autoencoder.
%%%% ¡default!
{'NNDataPoint'}

%%% ¡prop!
INPUTS (query, cell) constructs and returns the cell array of inputs from dataset D (format depends on the specific subclass/data point).

%%% ¡prop!
TARGETS (query, cell) constructs and returns the cell array of targets from dataset D (if applicable).

%%% ¡prop!
TRAIN (query, empty) trains the autoencoder by updating ENCODER and DECODER to minimise LOSS_FN using a mini-batch loop.
%%%% ¡calculate!
numEpochs = nnae.get('EPOCHS');
miniBatchSize = nnae.get('BATCH');
learnRate = nnae.get('LEARN_RATE');

d = nnae.get('D');
if isequal(d.get('DP_DICT').get('LENGTH'), 0)
    value = [];
    return
end

mbq = nnae.get('MBQ', d);
netE = nnae.get('ENCODER');
netD = nnae.get('DECODER');

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
        [loss, gradientsE, gradientsD] = dlfeval(@model_loss, netE, netD, X);

        % Update learnable parameters.
        [netE, trailingAvgE, trailingAvgSqE] = adamupdate(netE, ...
            gradientsE, trailingAvgE, trailingAvgSqE, iteration, learnRate);

        [netD, trailingAvgD, trailingAvgSqD] = adamupdate(netD, ...
            gradientsD, trailingAvgD, trailingAvgSqD, iteration, learnRate);

        % Update the training progress monitor. 
        recordMetrics(monitor, iteration, Loss=loss);
        updateInfo(monitor, Epoch=epoch + " of " + numEpochs);
        monitor.Progress = 100 * iteration/numIterations;
    end
end

nnae.set('ENCODER', netE);
nnae.set('DECODER', netD);
nnae.get('MODEL'); % to lock this element

value = {};
%%%% ¡calculate_callbacks!
function [loss, gradientsE, gradientsD] = model_loss(~, ~)
% It calculates the reconstruction loss and its gradients w.r.t. ENCODER and DECODER.
    netE = varargin{1};
    netD = varargin{2};
    X = varargin{3};
    
    % Forward through encoder.
    Z = forward(netE, X);
    
    % Forward through decoder.
    Y = forward(netD, Z);
    
    % Calculate loss and gradients.
    loss = nnae.get('LOSS_FN', Y, X);
    [gradientsE, gradientsD] = dlgradient(loss, netE.Learnables, netD.Learnables);
end

%% ¡props!

%%% ¡prop!
LEARN_RATE (parameter, scalar) is the learning rate for optimisation.
%%%% ¡default!
1e-3

%%% ¡prop!
NUM_LATENT_REP (parameter, scalar) is the number of latent representations (latent dimensions).
%%%% ¡default!
2

%%% ¡prop!
SIZE_INPUT (parameter, rvector) is the size of the input data (e.g., [H W C] for images, or feature vector length).

%%% ¡prop!
ITERATION_DIM (parameter, scalar) is used by minibatchqueue (MBQ) when batching inputs (see MATLAB arrayDatastore/minibatchqueue).

%%% ¡prop!
NUM_MBQ_OUTPUT (parameter, scalar) is the number of outputs produced by the minibatchqueue (MBQ).
%%%% ¡default!
2

%%% ¡prop!
MINIBATCH_FORMAT_INPUT (query, string) is a deep learning array (dlarray) label string for input mini-batches (e.g., "SSCB" or "BC"), used by minibatchqueue (MBQ).

%%% ¡prop!
MINIBATCH_FORMAT_TARGET (query, string) is the format of the target for a minibatchqueue (MBQ) object.

%%% ¡prop!
ENCODER (data, net) is a learnable encoder network (e.g., a dlnetwork).

%%% ¡prop!
DECODER (data, net) is a learnable decoder network (e.g., a dlnetwork).

%%% ¡prop!
MBQ (query, empty) returns a configured minibatchqueue (MBQ) for training on dataset D.
%%%% ¡calculate!
% targets = nn.get('PREDICT', D) returns a cell array with the
%  targets for all data points in dataset D.
if isempty(varargin)
    value = {};
    return
end
d = varargin{1};

num_outputs = nnae.get('NUM_MBQ_OUTPUT');
itr = nnae.get('ITERATION_DIM');
format_input = string(nnae.get('MINIBATCH_FORMAT_INPUT'));
format_target = string(nnae.get('MINIBATCH_FORMAT_TARGET'));
miniBatchSize = nnae.get('BATCH');

XTrain = nnae.get('INPUTS', d);
%YTrain = categorical(nnvae.get('TARGETS', d));
YTrain = 1:1:size(XTrain, 2);

dsXTrain = arrayDatastore(XTrain, IterationDimension=itr);
dsYTrain = arrayDatastore(YTrain);
dsTrain = combine(dsXTrain, dsYTrain);

value = minibatchqueue(dsTrain, num_outputs, ...
    MiniBatchSize = miniBatchSize, ...
    MiniBatchFcn = @preprocess_minibatch, ...
    MiniBatchFormat = [format_input, format_target], ...
    PartialMiniBatch = "discard");

%%%% ¡calculate_callbacks!
function [X, Y] = preprocess_minibatch(~, ~) 
    XCell = varargin{1};
    YCell = varargin{2};
    
    % Concatenate.
    X = cat(4, XCell{:});
    
    % Extract label data from cell and concatenate.
    Y = cat(2, YCell{:});
    
    % One-hot encode labels.
    Y = onehotencode(Y, 1);
end

%%% ¡prop!
LOSS_FN (query, scalar) returns the scalar training loss. By default, the reconstruction loss is the mean-squared error between the decoder output y and the input t.
%%%% ¡calculate!
if length(varargin) < 2
    value = 0;
    return
end
y = varargin{1};
t = varargin{2};

% Reconstruction loss
reconstructionLoss = mse(y, t);

% Combined loss
value = reconstructionLoss;

%% ¡tests!
