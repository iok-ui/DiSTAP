%% ¡header!
NNVariationalAutoencoderEvaluator_RS < NNVariationalAutoencoderEvaluator (nne, neural network evaluator) evaluates the performance of a trained neural network model with a dataset.

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
'NNVariationalAutoencoderEvaluator_RS'

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
'NNVariationalAutoencoderEvaluator_RS'

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

%%% ¡prop!
PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
%%%% ¡calculate!
if isempty(varargin)
    value = {};
    return
end

netE = varargin{1};
mbq = varargin{2};
d = nne.get('D');
num_dp = d.get('DP_DICT').get('LENGTH');
label_of_interest = nne.get('IDX_LABEL_OF_INTEREST')
for i = 1:num_dp
    target_classes = char(d.get('DP_DICT').get('IT', i).get('TARGET_CLASS'));
    targets(i) = categorical(cellstr(strtrim(target_classes(label_of_interest, :))));
end
Z = [];
Y = [];

% Loop over mini-batches.
while hasdata(mbq)
    [X_individual, Y_individual] = next(mbq);

    % Forward through encoder.
    %Z_individual = predict(netE,X_individual,Outputs='latentOuput');
    [Z_individual, mu, logSigmaSq] = predict(netE, X_individual);
    
    % Extract and concatenate predictions.
    %Z = cat(2,Z,extractdata(Z_individual));
    Z = cat(2, Z, extractdata(mu));

    Y_individual = extractdata(gather(Y_individual));
    Y_number = targets(Y_individual);
    Y = cat(2, Y, Y_number);
end

value = [{Z}, {Y}];

%% ¡props!
%%% ¡prop!
IDX_LABEL_OF_INTEREST (parameter, scalar) indentifies importance peaks.
%%%% ¡default!
2

%%% ¡prop!
PEAK_IDENTIFICATION (result, rvector) indentifies importance peaks.

%%% ¡prop!
ZERO_CROSSING_P2N (query, rvector) indentifies the index when crossing from positve to negative.

%%% ¡prop!
ZERO_CROSSING_N2P (query, rvector) indentifies the index when crossing from negative to positive.

%%% ¡prop!
DIRECTORY (data, string) is the directory saving the exporting figure.
%%%% ¡default!
fileparts(which('test_braph2'))

%%% ¡prop!
PLOT_R_SCRIPT (metadata, logical) indentifies the index when crossing from negative to positive.


%% ¡tests!

%%% ¡excluded_props!
[NNVariationalAutoencoderEvaluator_RS.PLOT_LATENT_REPRESENTATIONS NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER]
