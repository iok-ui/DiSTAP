%% ¡header!
NNVariationalAutoencoders_Evaluator < NNEvaluator (nne, neural network evaluator) evaluates the performance of a trained neural network model with a dataset.

%%% ¡description!
A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset.
Instances of this class should not be created. Use one of its subclasses instead.
Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.

%%% ¡seealso!
NNDataPoint, NNDataset, NNBase

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.
%%%% ¡default!
'NNVariationalAutoencoders_Evaluator'

%%% ¡prop!
NAME (constant, string) is the name of the evaluator for the neural network analysis.
%%%% ¡default!
'Neural Network Evaluator'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.
%%%% ¡default!
'A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset. Instances of this class should not be created. Use one of its subclasses instead. Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.
%%%% ¡settings!
'NNEvaluator'

%%% ¡prop!
ID (data, string) is a few-letter code for the evaluator for the neural network analysis.
%%%% ¡default!
'NNEvaluator ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.
%%%% ¡default!
'NNEvaluator label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.
%%%% ¡default!
'NNEvaluator notes'

%% ¡props!
%%% ¡prop!
PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.
%%%% ¡calculate!
nnvae = nne.get('NN');
netE = nnvae.get('ENCODER');
d = nne.get('D');

XTrain = nnvae.get('INPUTS', d);
YTrain = categorical(nnvae.get('TARGETS', d));

dsXTrain = arrayDatastore(XTrain, IterationDimension=4);
dsYTrain = arrayDatastore(YTrain);
dsTrain = combine(dsXTrain, dsYTrain);

numOutputs = nnvae.get('NUM_LATENT_REP');;

miniBatchSize = nnvae.get('BATCH');
mbqTrain = minibatchqueue(dsTrain, numOutputs, ...
    MiniBatchSize = miniBatchSize, ...
    MiniBatchFcn=@preprocessMiniBatch, ...
    MiniBatchFormat=["SSCB",""], ...
    PartialMiniBatch="discard");

latentInfo = nne.get('PREDICT_ENCODER', netE, mbqTrain);
ZLatent = latentInfo{1};
YLatent = latentInfo{2};
%index_selected = (YLatent == 2) | (YLatent == 1) | (YLatent == 10) | (YLatent == 8) | (YLatent == 3);

%figure;
%h = scatter(ZLatent(1, index_selected), ZLatent(2, index_selected), 30, YLatent(index_selected), 'filled');
h = scatter(ZLatent(1, :), ZLatent(2, :), 30, YLatent(:), 'filled');

title('Scatter Plot with Color-Coded Categories');
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

%%% ¡prop!
PLOT_LATENT_CONTINUITY (query, empty) is to plot latetn representations.
%%%% ¡calculate!
netD = nne.get('NN').get('DECODER');
n = 20;
figsize = 15;

% Display an n x n 2D manifold of data points
digit_size = 28;
scale = 1.0;

% Initialize the figure
figure = zeros(digit_size * n, digit_size * n);

% Linearly spaced coordinates corresponding to the 2D plot
% of data points in the latent space
grid_x = linspace(-scale, scale, n);
grid_y = linspace(-scale, scale, n);

% Reverse grid_y to match the original Python code
grid_y = flip(grid_y);

for i = 1:n
    for j = 1:n
        z_sample = [grid_x(j); grid_y(i)];
        z_sample = dlarray(z_sample,"CB");
        x_decoded = predict(netD, z_sample);
        digit = reshape(x_decoded, digit_size, digit_size);
        figure(1 + (i - 1) * digit_size:i * digit_size, 1 + (j - 1) * digit_size:j * digit_size) = digit;
    end
end

% Create the figure

start_range = digit_size / 2;
end_range = n * digit_size + start_range;
pixel_range = start_range:digit_size:end_range;
sample_range_x = round(grid_x, 1);
sample_range_y = round(grid_y, 1);

xticks(pixel_range);
xticklabels(sample_range_x);
yticks(pixel_range);
yticklabels(sample_range_y);
xlabel('z[0]');
ylabel('z[1]');
imagesc(figure);
colormap('gray');

% Display the plot
axis equal;
axis tight;
axis off;

% Show the figure
set(gcf, 'Color', 'w');
drawnow;
value = [];

%%% ¡prop!
PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end

netE = varargin{1};
mbq = varargin{2};

Z = [];
Y = [];

% Loop over mini-batches.
while hasdata(mbq)
    [X_individual, Y_individual] = next(mbq);

    % Forward through encoder.
    %Z_individual = predict(netE,X_individual,Outputs='latentOuput');
    [Z_individual, mu, logSigmaSq] = predict(netE,X_individual);
    
    % Extract and concatenate predictions.
    %Z = cat(2,Z,extractdata(Z_individual));
    Z = cat(2, Z, extractdata(mu));

    Y_individual = extractdata(gather(Y_individual));
    
    Y_number = [];
    for col = 1:size(Y_individual, 2)
        Y_number(col) = find(Y_individual(:, col) == 1);
    end
    Y = cat(2,Y,Y_number);

    if size(Y, 2) ~= size(Z, 2)
        szie(Y, 2)
    end
end

value = [{Z}, {Y}];

%% ¡tests!

%%% ¡excluded_props!
[NNVariationalAutoencoders_Evaluator.PLOT_LATENT_REPRESENTATIONS NNVariationalAutoencoders_Evaluator.PLOT_LATENT_CONTINUITY NNVariationalAutoencoders_Evaluator.PREDICT_ENCODER]
