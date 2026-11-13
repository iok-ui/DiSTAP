%% ¡header!
NNVariationalAutoencoderMLP_CV < NNCrossValidation (nncv, cross-validation for MLP variational autoencoders) uses k-fold cross-validation to choose the number of training epochs of a multilayer-perceptron variational autoencoder.

%%% ¡description!
A cross-validation for multilayer-perceptron variational autoencoders (NNVariationalAutoencoderMLP_CV) decides how many epochs a variational autoencoder (NNVariationalAutoencoderMLP) should be trained for.
 The dataset is split into KFOLDS folds. By default, all spectra from the same plant replicate (the same label in TARGET_CLASS, see GROUP_ROWS) are put in the same fold,
 so a fold is never validated on spectra from a leaf that was also used for training (no replicate leakage).
 For each fold, a variational autoencoder is trained on the other folds for EPOCHS epochs, and its training and validation losses (negative ELBO) are recorded at every epoch (LOSS_CV).
 The fold curves are averaged into one pooled curve, and the epoch is selected on that pooled curve (SELECTED_EPOCH) with the early-stopping rule EARLY_STOP_RULE:
 - the plateau onset is the first epoch after which the smoothed validation loss improves by less than RATE_THRESHOLD per epoch for PATIENCE consecutive epochs;
 - the overfitting onset is the first epoch after which the gap between validation and training loss grows by more than GAP_THRESHOLD (as a fraction of the training loss) above its lowest value so far, for PATIENCE consecutive epochs.
 The per-fold plateau and overfitting onsets (PLATEAU_EPOCH_FOLDS, OVERFIT_EPOCH_FOLDS) are reported as a consistency check, but they do not decide SELECTED_EPOCH.
 The fold models are only used to choose the epoch number; the final model is then trained on the whole dataset for SELECTED_EPOCH epochs.
 To check that the selected epoch is a good choice, at every epoch each fold model also encodes all spectra and the separation of the labels in its latent space is scored with the silhouette (SILHOUETTE_CHECK),
 separately for each group (by default, the stresses of each species, see SILHOUETTE_GROUP_ROW and SILHOUETTE_LABEL_ROW).
 PLOT_EPOCH_SELECTION shows, around the selected epoch, the plateau of the loss, the overfitting check and the silhouette,
 and EXPORT_RESULTS writes the same tables as train_vae.m (epoch selection, overfitting check, patience sensitivity, separability) and the figures to a folder.

To run the cross-validation, use: nncv.get('TRAIN')
To get the selected number of epochs, use: nncv.get('SELECTED_EPOCH')
To export the tables and figures, use: nncv.get('EXPORT_RESULTS', DIRECTORY, PREFIX)

%%% ¡seealso!
NNVariationalAutoencoderMLP, NNCrossValidation, NNDataPoint_RamanSpectra, NNDatasetProcess_RamanSpectra

%%% ¡build!
1

%% ¡layout!

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.ID
%%%% ¡title!
Cross-Validation ID

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.LABEL
%%%% ¡title!
Cross-Validation Label

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.KFOLDS
%%%% ¡title!
Number of Folds

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.EPOCHS
%%%% ¡title!
Epochs per Fold

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.EARLY_STOP_RULE
%%%% ¡title!
Early-Stopping Rule

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.SMOOTH_WINDOW
%%%% ¡title!
Moving-Average Window (epochs)

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.RATE_THRESHOLD
%%%% ¡title!
Plateau Threshold (0.001 = 0.1 percent improvement per epoch)

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.PATIENCE
%%%% ¡title!
Patience (consecutive epochs)

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.GAP_THRESHOLD
%%%% ¡title!
Overfitting Threshold (0.02 = 2 percent of the training loss)

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.NEURONS_PER_LAYER
%%%% ¡title!
Neuron Number per Layer

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.NUM_LATENT_REP
%%%% ¡title!
Latent Space Number

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.LEARN_RATE
%%%% ¡title!
Learning Rate

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.BATCH
%%%% ¡title!
Batch Size

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.TRAIN
%%%% ¡title!
Run Cross-Validation

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.SELECTED_EPOCH
%%%% ¡title!
Selected Number of Epochs

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.DIRECTORY_FIG
%%%% ¡title!
Figure Directory

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION
%%%% ¡title!
Plot Epoch Selection

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.PLOT_LOSS
%%%% ¡title!
Plot Cross-Validation Loss

%%% ¡prop!
%%%% ¡id!
NNVariationalAutoencoderMLP_CV.NOTES
%%%% ¡title!
Cross-Validation Notes

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'NNVariationalAutoencoderMLP_CV'

%%% ¡prop!
NAME (constant, string) is the name of the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'Neural Network Cross-Validation for Multilayer-Perceptron Variational Autoencoders'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'A cross-validation for multilayer-perceptron variational autoencoders (NNVariationalAutoencoderMLP_CV) decides how many epochs a variational autoencoder (NNVariationalAutoencoderMLP) should be trained for. The dataset is split into KFOLDS folds; by default all spectra from the same plant replicate are put in the same fold, so no fold is validated on a leaf that was also used for training. For each fold, a variational autoencoder is trained on the other folds and its training and validation losses are recorded at every epoch. The fold curves are averaged and the epoch is selected on the pooled curve with the early-stopping rule EARLY_STOP_RULE (plateau onset of the validation loss and/or onset of overfitting, i.e., a sustained growth of the gap between validation and training loss). The final model is then trained on the whole dataset for SELECTED_EPOCH epochs.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the cross-validation for MLP variational autoencoders.
%%%% ¡settings!
'NNVariationalAutoencoderMLP_CV'

%%% ¡prop!
ID (data, string) is a few-letter code for the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'NNVariationalAutoencoderMLP_CV ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'NNVariationalAutoencoderMLP_CV label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the cross-validation for MLP variational autoencoders.
%%%% ¡default!
'NNVariationalAutoencoderMLP_CV notes'

%%% ¡prop!
KFOLDS (data, scalar) is the number of folds (at least 2).
%%%% ¡default!
5
%%%% ¡check_value!
check = isscalar(value) && value >= 2 && round(value) == value;

%%% ¡prop!
SPLIT (data, cell) is a cell (one row per dataset in D, one column per fold) with the indices of the data points in each fold. If empty, it is filled in with FOLD_ASSIGNMENT when D is set.
%%%% ¡postprocessing!
kfolds = nncv.get('KFOLDS');
split = nncv.get('SPLIT');
d = nncv.get('D');
if (isempty(split) || size(split, 2) ~= kfolds) ...
        && ~nncv.isLocked('SPLIT') ...
        && length(d) > 0 ...
        && all(cellfun(@(x) x.get('DP_DICT').get('LENGTH'), d) >= kfolds)
    split = cell(length(d), kfolds);
    for i = 1:1:length(d)
        split(i, :) = nncv.get('FOLD_ASSIGNMENT', d{i});
    end
    nncv.set('SPLIT', split);
end

%%% ¡prop!
D_LIST (result, itemlist) contains the validation dataset of each of the k folds (the data points of that fold from all datasets in D).
%%%% ¡calculate!
% Built directly from the dataset splitters (DSP) instead of NNDatasetCombine,
%  because NNDatasetCombine drops data points that share the same ID.
if isempty(nncv.get('SPLIT'))
    value = {};
    return
end
dsp_list = nncv.get('DSP');
if isempty(dsp_list)
    value = {};
    return
end
kfolds = nncv.get('KFOLDS');
d = nncv.get('D');
dp_class = d{1}.get('DP_CLASS');
d_split_list = cellfun(@(dsp) dsp.get('D_LIST'), dsp_list, 'UniformOutput', false); % per dataset, its k folds
value = cell(kfolds, 1);
for k = 1:1:kfolds
    dp_list = {};
    for j = 1:1:length(d_split_list)
        dp_list_j = d_split_list{j}{k}.get('DP_DICT').get('IT_LIST');
        dp_list = [dp_list, reshape(dp_list_j, 1, [])]; %#ok<AGROW>
    end
    value{k} = NNDataset( ...
        'DP_CLASS', dp_class, ...
        'DP_DICT', IndexedDictionary('IT_CLASS', dp_class, 'IT_LIST', dp_list) ...
        );
end

%%% ¡prop!
NN_TEMPLATE (parameter, item) is an optional variational autoencoder template; if set, its NEURONS_PER_LAYER, NUM_LATENT_REP and LEARN_RATE are used instead of those of the cross-validation.
%%%% ¡settings!
'NNVariationalAutoencoderMLP'

%%% ¡prop!
NN_LIST (result, itemlist) contains the variational autoencoders of the k folds, each trained (by TRAIN) on all folds except its own.
%%%% ¡calculate!
d_list = nncv.get('D_LIST');
if isempty(d_list)
    value = {};
    return
end

if ~isa(nncv.getr('NN_TEMPLATE'), 'NoValue')
    nn_template = nncv.get('NN_TEMPLATE');
    neurons = nn_template.get('NEURONS_PER_LAYER');
    num_latent = nn_template.get('NUM_LATENT_REP');
    learn_rate = nn_template.get('LEARN_RATE');
else
    neurons = nncv.get('NEURONS_PER_LAYER');
    num_latent = nncv.get('NUM_LATENT_REP');
    learn_rate = nncv.get('LEARN_RATE');
end

kfolds = length(d_list);
value = cell(kfolds, 1);
for k = 1:1:kfolds
    % training set = all folds except fold k (concatenated directly, see D_LIST)
    dp_list = {};
    for j = setdiff(1:kfolds, k)
        dp_list = [dp_list, reshape(d_list{j}.get('DP_DICT').get('IT_LIST'), 1, [])]; %#ok<AGROW>
    end
    dp_class = d_list{k}.get('DP_CLASS');
    d_train = NNDataset( ...
        'DP_CLASS', dp_class, ...
        'DP_DICT', IndexedDictionary('IT_CLASS', dp_class, 'IT_LIST', dp_list) ...
        );

    value{k} = NNVariationalAutoencoderMLP( ...
        'ID', ['Fold ' int2str(k) ' of ' int2str(kfolds)], ...
        'D', d_train, ...
        'NEURONS_PER_LAYER', neurons, ...
        'NUM_LATENT_REP', num_latent, ...
        'LEARN_RATE', learn_rate, ...
        'EPOCHS', nncv.get('EPOCHS'), ...
        'BATCH', nncv.get('BATCH'), ...
        'VERBOSE', nncv.get('VERBOSE'), ...
        'PLOT_TRAINING', nncv.get('PLOT_TRAINING') ...
        );
end

%%% ¡prop!
EPOCHS (parameter, scalar) is the maximum number of epochs each fold is trained for (the budget within which the epoch is selected).
%%%% ¡default!
500

%%% ¡prop!
BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.
%%%% ¡default!
40

%%% ¡prop!
PLOT_TRAINING (metadata, option) determines whether to show the training and validation loss of each fold while training (the fold being trained is always printed in the command window).
%%%% ¡settings!
{'none' 'training-progress'}
%%%% ¡default!
'none'

%%% ¡prop!
TRAIN (query, empty) runs the cross-validation: trains all fold models, records their losses (LOSS_CV) and selects the number of epochs (SELECTED_EPOCH).
%%%% ¡calculate!
% nothing to train without folds (also keeps the results below unmemorized,
%  since TRAIN comes before them in the property order)
if isempty(nncv.get('D_LIST'))
    value = [];
    return
end
nncv.memorize('LOSS_CV');
nncv.memorize('PLATEAU_EPOCH_FOLDS');
nncv.memorize('OVERFIT_EPOCH_FOLDS');
nncv.memorize('SELECTED_EPOCH');
nncv.memorize('SILHOUETTE_BEST_EPOCH');
value = [];

%% ¡props!

%%% ¡prop!
NEURONS_PER_LAYER (parameter, rvector) are the hidden-layer widths of the MLP encoder (mirrored in the decoder), used when NN_TEMPLATE is not set.
%%%% ¡default!
[64]

%%% ¡prop!
NUM_LATENT_REP (parameter, scalar) is the number of latent dimensions, used when NN_TEMPLATE is not set.
%%%% ¡default!
2

%%% ¡prop!
LEARN_RATE (parameter, scalar) is the learning rate of the Adam optimiser, used when NN_TEMPLATE is not set.
%%%% ¡default!
1e-3

%%% ¡prop!
FOLD_RULE (parameter, option) is how data points are assigned to folds: all spectra of the same plant replicate in the same fold (no leakage), or each spectrum independently at random.
%%%% ¡settings!
{'Grouped by replicate' 'Random per spectrum'}
%%%% ¡default!
'Grouped by replicate'

%%% ¡prop!
GROUP_ROWS (parameter, rvector) are the rows of TARGET_CLASS joined to identify a plant replicate (for Raman spectra: 1 species, 2 stress, 3 location, 4 plant ID); rows that a data point does not have are ignored.
%%%% ¡default!
[1 2 3 4]
%%%% ¡check_value!
check = all(value >= 1) && all(round(value) == value);

%%% ¡prop!
FOLD_ASSIGNMENT (query, cell) returns, for a dataset, a 1 x KFOLDS cell with the (sorted) indices of the data points in each fold, following FOLD_RULE.
%%%% ¡calculate!
% split = nncv.get('FOLD_ASSIGNMENT', D) assigns the data points of dataset D
%  to KFOLDS folds. With 'Grouped by replicate', the replicate groups are
%  shuffled and dealt to the folds in turn (as in train_vae.m), so every
%  spectrum of a replicate ends up in the same fold.
if isempty(varargin)
    value = {};
    return
end
d = varargin{1};
kfolds = nncv.get('KFOLDS');
num_dp = d.get('DP_DICT').get('LENGTH');
if num_dp == 0
    value = repmat({[]}, 1, kfolds);
    return
end

switch nncv.get('FOLD_RULE')
    case 'Grouped by replicate'
        group_rows = nncv.get('GROUP_ROWS');
        keys = cell(num_dp, 1);
        for i = 1:1:num_dp
            labels = reshape(strtrim(cellstr(char(d.get('DP_DICT').get('IT', i).get('TARGET_CLASS')))), 1, []);
            keys{i} = strjoin(labels(group_rows(group_rows <= numel(labels))), '|');
        end
        [unique_keys, ~, key_idx] = unique(keys);
        num_groups = numel(unique_keys);
        if num_groups < kfolds
            warning( ...
                [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV'], ...
                [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV\\n' ...
                'There are only ' int2str(num_groups) ' replicate groups for ' int2str(kfolds) ' folds, so some folds will be empty.\\n' ...
                'Use fewer folds (KFOLDS) or change GROUP_ROWS.'] ...
                )
        end
        group_fold = zeros(num_groups, 1);
        group_fold(randperm(num_groups)) = mod(0:num_groups-1, kfolds) + 1;
        dp_fold = group_fold(key_idx);
    case 'Random per spectrum'
        dp_fold = mod(randperm(num_dp), kfolds) + 1;
end

value = arrayfun(@(k) reshape(find(dp_fold == k), 1, []), 1:kfolds, 'UniformOutput', false);

%%% ¡prop!
EARLY_STOP_RULE (parameter, option) is the rule used to select the number of epochs on the pooled (fold-averaged) loss curves.
%%%% ¡settings!
{'Plateau or overfitting onset (first to occur)' 'Plateau onset only' 'Overfitting onset only' 'No early stopping'}
%%%% ¡default!
'Plateau or overfitting onset (first to occur)'

%%% ¡prop!
RATE_THRESHOLD (parameter, scalar) is the plateau criterion: the validation loss is considered flat when its smoothed relative improvement per epoch stays below this value (0.001 = 0.1% per epoch).
%%%% ¡default!
0.001
%%%% ¡check_value!
check = isscalar(value) && value >= 0;

%%% ¡prop!
GAP_THRESHOLD (parameter, scalar) is the overfitting criterion: overfitting starts when the validation-minus-training gap grows above its lowest value so far by more than this fraction of the (median) training loss (0.02 = 2%).
%%%% ¡default!
0.02
%%%% ¡check_value!
check = isscalar(value) && value >= 0;

%%% ¡prop!
PATIENCE (parameter, scalar) is the number of consecutive epochs a criterion must hold before it fires (10 in the manuscript); 0 means automatic, max(10, round(0.02 * EPOCHS)).
%%%% ¡default!
10
%%%% ¡check_value!
check = isscalar(value) && value >= 0 && round(value) == value;

%%% ¡prop!
SMOOTH_WINDOW (parameter, scalar) is the moving-average window (in epochs) applied to the loss curves before detection (15 in the manuscript); it is also the warm-up before the overfitting check starts. 0 means automatic, max(10, round(0.03 * EPOCHS)).
%%%% ¡default!
15
%%%% ¡check_value!
check = isscalar(value) && value >= 0 && round(value) == value;

%%% ¡prop!
EARLY_STOP_PARAMS (query, rvector) returns the early-stopping parameters actually used: [SMOOTH_WINDOW RATE_THRESHOLD PATIENCE GAP_THRESHOLD WARMUP], with the automatic values resolved.
%%%% ¡calculate!
epochs = nncv.get('EPOCHS');
smooth_window = nncv.get('SMOOTH_WINDOW');
if smooth_window == 0
    smooth_window = max(10, round(0.03 * epochs));
end
patience = nncv.get('PATIENCE');
if patience == 0
    patience = max(10, round(0.02 * epochs));
end
warmup = smooth_window; % enough epochs for the smoothing window to be fully populated
value = [smooth_window, nncv.get('RATE_THRESHOLD'), patience, nncv.get('GAP_THRESHOLD'), warmup];

%%% ¡prop!
DETECT_PLATEAU (query, scalar) returns the plateau-onset epoch of a loss curve, or the last epoch if the curve never plateaus.
%%%% ¡calculate!
% epoch = nncv.get('DETECT_PLATEAU', LOSS, SMOOTH_WINDOW, RATE_THRESHOLD, PATIENCE)
%  smooths LOSS with a moving average and returns the first epoch after which
%  the relative improvement per epoch stays below RATE_THRESHOLD for PATIENCE
%  consecutive epochs (back-dated to where the plateau began).
%  This is detectEarlyStopEpoch in train_vae.m.
if length(varargin) < 4
    value = 0;
    return
end
loss = varargin{1}(:);
smooth_window = varargin{2};
rate_threshold = varargin{3};
patience = varargin{4};

num_epochs = numel(loss);
if num_epochs == 0
    value = 0;
    return
end

smoothed = movmean(loss, smooth_window);
relative_improvement = zeros(num_epochs, 1);
relative_improvement(2:end) = (smoothed(1:end-1) - smoothed(2:end)) ./ abs(smoothed(1:end-1));
below_threshold = relative_improvement < rate_threshold;

value = num_epochs; % never converges within the budget: use the full budget
consecutive_below = 0;
for e = 2:1:num_epochs
    if below_threshold(e)
        consecutive_below = consecutive_below + 1;
    else
        consecutive_below = 0;
    end
    if consecutive_below >= patience
        value = e - patience + 1;
        break
    end
end

%%% ¡prop!
DETECT_OVERFITTING (query, scalar) returns the overfitting-onset epoch from a training and a validation loss curve, or 0 if no overfitting is detected.
%%%% ¡calculate!
% epoch = nncv.get('DETECT_OVERFITTING', TRAIN_LOSS, VAL_LOSS, WARMUP, SMOOTH_WINDOW, GAP_THRESHOLD, PATIENCE)
%  smooths both curves, computes gap = val - train, and returns the first
%  epoch (from WARMUP on) after which the gap stays more than
%  GAP_THRESHOLD * median(train) above its running minimum for PATIENCE
%  consecutive epochs. This is detectOverfittingOnset in train_vae.m.
if length(varargin) < 6
    value = 0;
    return
end
train_loss = varargin{1}(:);
val_loss = varargin{2}(:);
warmup = max(1, varargin{3});
smooth_window = varargin{4};
gap_threshold = varargin{5};
patience = varargin{6};

num_epochs = numel(val_loss);
if num_epochs < warmup || numel(train_loss) ~= num_epochs
    value = 0;
    return
end

smoothed_train = movmean(train_loss, smooth_window);
smoothed_val = movmean(val_loss, smooth_window);
gap = smoothed_val - smoothed_train;
threshold_abs = gap_threshold * abs(median(smoothed_train));

value = 0;
running_min_gap = gap(warmup);
consecutive_above = 0;
for e = warmup:1:num_epochs
    running_min_gap = min(running_min_gap, gap(e));
    if gap(e) - running_min_gap > threshold_abs
        consecutive_above = consecutive_above + 1;
    else
        consecutive_above = 0;
    end
    if consecutive_above >= patience
        value = e - patience + 1;
        break
    end
end

%%% ¡prop!
SILHOUETTE_CHECK (parameter, logical) determines whether, at every epoch, the separation of the labels in the latent space of each fold model is scored with the silhouette.
%%%% ¡default!
true

%%% ¡prop!
SILHOUETTE_GROUP_ROW (parameter, scalar) is the row of TARGET_CLASS whose groups are scored separately (for Raman spectra: 1 species); 0 scores all spectra together.
%%%% ¡default!
1
%%%% ¡check_value!
check = isscalar(value) && value >= 0 && round(value) == value;

%%% ¡prop!
SILHOUETTE_LABEL_ROW (parameter, scalar) is the row of TARGET_CLASS with the labels whose separation is scored (for Raman spectra: 2 stress).
%%%% ¡default!
2
%%%% ¡check_value!
check = isscalar(value) && value >= 1 && round(value) == value;

%%% ¡prop!
SILHOUETTE_DISTANCE (parameter, option) is the distance used by the silhouette (sqEuclidean is the default of MATLAB silhouette, used in train_vae.m).
%%%% ¡settings!
{'sqEuclidean' 'Euclidean'}
%%%% ¡default!
'sqEuclidean'

%%% ¡prop!
SILHOUETTE_CHECKPOINTS (parameter, rvector) are the epochs reported in the separability table of EXPORT_RESULTS, together with SELECTED_EPOCH (epochs beyond EPOCHS are ignored).
%%%% ¡default!
[50 100 250 500]
%%%% ¡check_value!
check = all(value >= 1) && all(round(value) == value);

%%% ¡prop!
DIRECTORY_FIG (metadata, string) is the directory where the figures (PLOT_LOSS, PLOT_EPOCH_SELECTION) and the tables (EXPORT_RESULTS) are saved; if empty, the figures are only shown.
%%%% ¡default!
''

%%% ¡prop!
FILE_PREFIX (metadata, string) is the beginning of the names of the saved figures and tables.
%%%% ¡default!
'vae_cv'

%%% ¡prop!
SILHOUETTE (query, scalar) returns the mean silhouette of points with given labels, from -1 (mixed) to 1 (well-separated clusters).
%%%% ¡calculate!
% s = nncv.get('SILHOUETTE', Z, LABELS) returns the mean silhouette of the
%  points Z (one row per point) with labels LABELS, using SILHOUETTE_DISTANCE.
%  It is the same as mean(silhouette(Z, LABELS)) of the Statistics and Machine
%  Learning Toolbox; a point that is alone in its label scores 0.
%  It returns 0 if there are fewer than two points or two labels.
if length(varargin) < 2
    value = 0;
    return
end
z = double(varargin{1});
[~, ~, labels] = unique(varargin{2}(:));
num_points = size(z, 1);
num_labels = max([labels; 0]);
if num_points < 2 || num_labels < 2 || numel(labels) ~= num_points
    value = 0;
    return
end

sq_norm = sum(z.^2, 2);
dist = max(0, sq_norm + sq_norm' - 2 * (z * z'));
if strcmp(nncv.get('SILHOUETTE_DISTANCE'), 'Euclidean')
    dist = sqrt(dist);
end

counts = accumarray(labels, 1, [num_labels 1]);
sum_dist = zeros(num_points, num_labels);
for j = 1:1:num_labels
    sum_dist(:, j) = sum(dist(:, labels == j), 2);
end
own = sub2ind([num_points num_labels], (1:num_points)', labels);
a = sum_dist(own) ./ max(counts(labels) - 1, 1); % mean distance to the other points with the same label
mean_dist = sum_dist ./ counts';
mean_dist(own) = Inf;
b = min(mean_dist, [], 2); % mean distance to the closest other label
s = (b - a) ./ max(a, b);
s(counts(labels) == 1 | max(a, b) == 0) = 0;
value = mean(s);

%%% ¡prop!
BUILD_NETWORKS (query, cell) returns {ENCODER, DECODER}, freshly initialised dlnetworks with the same MLP architecture as NNVariationalAutoencoderMLP for a given variational autoencoder.
%%%% ¡calculate!
% nets = nncv.get('BUILD_NETWORKS', NN) builds the encoder and decoder of
%  the NNVariationalAutoencoderMLP NN (same layers as its TRAIN).
if isempty(varargin)
    value = {};
    return
end
nn = varargin{1};
neurons = nn.get('NEURONS_PER_LAYER');
num_latent = nn.get('NUM_LATENT_REP');
num_feature = prod(nn.get('SIZE_INPUT'));

layers_e = featureInputLayer(num_feature, Normalization="none");
for n = neurons
    layers_e = [
        layers_e
        fullyConnectedLayer(n)
        reluLayer
        ]; %#ok<AGROW>
end
layers_e = [
    layers_e
    fullyConnectedLayer(2 * num_latent, Name="latentOutput")
    samplingLayer
    ];

layers_d = featureInputLayer(num_latent, Normalization="none");
for n = fliplr(neurons)
    layers_d = [
        layers_d
        fullyConnectedLayer(n)
        reluLayer
        ]; %#ok<AGROW>
end
layers_d = [
    layers_d
    fullyConnectedLayer(num_feature)
    leakyReluLayer(1)
    ];

value = {dlnetwork(layers_e), dlnetwork(layers_d)};

%%% ¡prop!
LOSS_CV (result, cell) trains the variational autoencoder of each fold and returns {TRAIN_LOSS, VAL_LOSS, SILHOUETTE, GROUPS}: two EPOCHS x KFOLDS matrices with the mean loss (negative ELBO) per epoch, an EPOCHS x KFOLDS x number-of-groups array with the silhouette of the labels of each group in the latent space of each fold model (all spectra encoded), and the names of the groups.
%%%% ¡calculate!
d_list = nncv.get('D_LIST');
if isempty(d_list)
    value = {};
    return
end

kfolds = length(d_list);
num_epochs = nncv.get('EPOCHS');
batch = nncv.get('BATCH');

fold_sizes = cellfun(@(d) d.get('DP_DICT').get('LENGTH'), d_list);
fold_sizes = reshape(fold_sizes, 1, []);
if any(fold_sizes == 0)
    error( ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT], ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT '\\n' ...
        'At least one fold is empty (data points per fold: ' mat2str(fold_sizes) ').\\n' ...
        'Use fewer folds (KFOLDS): there must be at least as many replicate groups as folds.'] ...
        )
end
if any(sum(fold_sizes) - fold_sizes < batch)
    error( ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT], ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT '\\n' ...
        'At least one training set is smaller than the batch size (' int2str(batch) ').\\n' ...
        'Use a smaller BATCH.'] ...
        )
end

% announce the start and show the waitbar before the (slow) preparation of the folds
disp(['Cross-validation: starting (' int2str(kfolds) ' folds, ' int2str(num_epochs) ' epochs per fold) ...'])
cv_start = tic;
wb = braph2waitbar(nncv.get('WAITBAR'), 0, 'Starting the cross-validation ...');
drawnow % braph2waitbar makes the waitbar visible without redrawing

braph2waitbar(wb, 0, ['Preparing the models of the ' int2str(kfolds) ' folds ...'])
nn_list = nncv.memorize('NN_LIST');
show_monitor = strcmp(nncv.get('PLOT_TRAINING'), 'training-progress');

% spectra and labels for the silhouette: all spectra in D (as in train_vae.m),
%  scored separately for each group with at least two labels
sil_groups = {};
sil_x = [];
sil_group_idx = [];
sil_label_idx = [];
if nncv.get('SILHOUETTE_CHECK')
    dp_all = {};
    for k = 1:1:kfolds
        dp_all = [dp_all, reshape(d_list{k}.get('DP_DICT').get('IT_LIST'), 1, [])]; %#ok<AGROW>
    end
    group_row = nncv.get('SILHOUETTE_GROUP_ROW');
    label_row = nncv.get('SILHOUETTE_LABEL_ROW');
    num_dp = numel(dp_all);
    group_keys = repmat({''}, num_dp, 1);
    label_keys = repmat({''}, num_dp, 1);
    for i = 1:1:num_dp
        dp_labels = strtrim(cellstr(char(dp_all{i}.get('TARGET_CLASS'))));
        if group_row == 0
            group_keys{i} = 'All';
        elseif group_row <= numel(dp_labels)
            group_keys{i} = dp_labels{group_row};
        end
        if label_row <= numel(dp_labels)
            label_keys{i} = dp_labels{label_row};
        end
    end
    has_labels = ~cellfun(@isempty, group_keys) & ~cellfun(@isempty, label_keys);
    candidate_groups = unique(group_keys(has_labels));
    sil_group_idx = zeros(num_dp, 1);
    for g = 1:1:numel(candidate_groups)
        in_group = has_labels & strcmp(group_keys, candidate_groups{g});
        if numel(unique(label_keys(in_group))) >= 2 % a separation needs at least two labels
            sil_groups{end + 1} = candidate_groups{g}; %#ok<AGROW>
            sil_group_idx(in_group) = numel(sil_groups);
        end
    end
    [~, ~, sil_label_idx] = unique(label_keys);
    if ~isempty(sil_groups)
        braph2waitbar(wb, 0, 'Preparing the spectra for the latent separation (silhouette) ...')
        dp_class = d_list{1}.get('DP_CLASS');
        d_all = NNDataset( ...
            'DP_CLASS', dp_class, ...
            'DP_DICT', IndexedDictionary('IT_CLASS', dp_class, 'IT_LIST', dp_all) ...
            );
        sil_x = nn_list{1}.get('INPUTS', d_all);
    end
end
num_groups = numel(sil_groups);

train_loss = zeros(num_epochs, kfolds);
val_loss = zeros(num_epochs, kfolds);
sil = zeros(num_epochs, kfolds, num_groups);

for k = 1:1:kfolds
    disp(['Cross-validation: training fold ' int2str(k) ' of ' int2str(kfolds) ' (' int2str(num_epochs) ' epochs) ...'])
    braph2waitbar(wb, (k - 1) / kfolds, ['Fold ' int2str(k) ' of ' int2str(kfolds) ' - preparing ...'])
    fold_start = tic;
    [train_loss(:, k), val_loss(:, k), sil(:, k, :), net_e, net_d] = vaecv_train_fold(nn_list{k}, d_list{k}, k, kfolds, num_epochs, show_monitor, wb, sil_x, sil_group_idx, sil_label_idx, num_groups);
    disp(['Cross-validation: fold ' int2str(k) ' of ' int2str(kfolds) ' done in ' int2str(round(toc(fold_start))) ' s'])

    % store the trained fold networks and lock them,
    %  so that a later nn.get('TRAIN') does not retrain them
    nn_list{k}.set('ENCODER', net_e);
    nn_list{k}.set('DECODER', net_d);
    nn_list{k}.lock();
end
braph2waitbar(wb, 'close')
disp(['Cross-validation: finished in ' int2str(round(toc(cv_start))) ' s'])

value = {train_loss, val_loss, sil, sil_groups};
%%%% ¡calculate_callbacks!
function [cvf_train_loss, cvf_val_loss, cvf_sil, cvf_net_e, cvf_net_d] = vaecv_train_fold(cvf_nn, cvf_d_val, cvf_fold, cvf_kfolds, cvf_num_epochs, cvf_show_monitor, cvf_wb, cvf_sil_x, cvf_sil_group_idx, cvf_sil_label_idx, cvf_num_groups)
    % Trains the fold model CVF_NN on its training set (its D) and records,
    %  at every epoch, the mean training loss, the validation loss on CVF_D_VAL
    %  and the silhouette of each group of the spectra CVF_SIL_X in the latent space (the means).
    %  Same loop as NNVariationalAutoencoder TRAIN (and runVaeTraining in train_vae.m).

    cvf_nets = nncv.get('BUILD_NETWORKS', cvf_nn);
    cvf_net_e = cvf_nets{1};
    cvf_net_d = cvf_nets{2};

    cvf_learn_rate = cvf_nn.get('LEARN_RATE');
    cvf_batch = cvf_nn.get('BATCH');

    % training mini-batches (last partial batch discarded, as in TRAIN)
    cvf_mbq = cvf_nn.get('MBQ', cvf_nn.get('D'));

    % validation mini-batches (last partial batch kept, so every validation spectrum counts)
    cvf_itr = cvf_nn.get('ITERATION_DIM');
    cvf_x_val = cvf_nn.get('INPUTS', cvf_d_val);
    cvf_mbq_val = minibatchqueue(arrayDatastore(cvf_x_val, IterationDimension=cvf_itr), 1, ...
        MiniBatchSize = cvf_batch, ...
        MiniBatchFcn = @(cvf_x_cell) cat(cvf_itr, cvf_x_cell{:}), ...
        MiniBatchFormat = string(cvf_nn.get('MINIBATCH_FORMAT_INPUT')), ...
        PartialMiniBatch = "return");

    cvf_avg_e = [];
    cvf_avg_sq_e = [];
    cvf_avg_d = [];
    cvf_avg_sq_d = [];

    cvf_train_loss = zeros(cvf_num_epochs, 1);
    cvf_val_loss = zeros(cvf_num_epochs, 1);
    cvf_sil = zeros(cvf_num_epochs, cvf_num_groups);
    if cvf_num_groups > 0
        cvf_x_sil = dlarray(cvf_sil_x, string(cvf_nn.get('MINIBATCH_FORMAT_INPUT')));
        if canUseGPU()
            cvf_x_sil = gpuArray(cvf_x_sil); % same device as the mini-batches
        end
    end

    if cvf_show_monitor
        cvf_monitor = trainingProgressMonitor( ...
            Metrics = ["TrainingLoss", "ValidationLoss"], ...
            Info = ["Fold", "Epoch"], ...
            XLabel = "Epoch");
        groupSubPlot(cvf_monitor, "Loss", ["TrainingLoss", "ValidationLoss"]);
        updateInfo(cvf_monitor, Fold = cvf_fold + " of " + cvf_kfolds);
    end
    cvf_wb_step = max(1, round(cvf_num_epochs / 100));

    cvf_iteration = 0;
    for cvf_epoch = 1:1:cvf_num_epochs
        % training
        shuffle(cvf_mbq);
        cvf_loss_sum = 0;
        cvf_loss_count = 0;
        while hasdata(cvf_mbq)
            cvf_iteration = cvf_iteration + 1;
            [cvf_x, ~] = next(cvf_mbq);

            [cvf_loss, cvf_grad_e, cvf_grad_d] = dlfeval(@vaecv_model_loss, cvf_nn, cvf_net_e, cvf_net_d, cvf_x);

            [cvf_net_e, cvf_avg_e, cvf_avg_sq_e] = adamupdate(cvf_net_e, ...
                cvf_grad_e, cvf_avg_e, cvf_avg_sq_e, cvf_iteration, cvf_learn_rate);
            [cvf_net_d, cvf_avg_d, cvf_avg_sq_d] = adamupdate(cvf_net_d, ...
                cvf_grad_d, cvf_avg_d, cvf_avg_sq_d, cvf_iteration, cvf_learn_rate);

            cvf_loss_sum = cvf_loss_sum + double(gather(extractdata(cvf_loss)));
            cvf_loss_count = cvf_loss_count + 1;
        end
        cvf_train_loss(cvf_epoch) = cvf_loss_sum / cvf_loss_count;

        % validation (no parameter updates)
        cvf_val_loss(cvf_epoch) = vaecv_validation_loss(cvf_nn, cvf_net_e, cvf_net_d, cvf_mbq_val);

        % latent separation (silhouette of the latent means of all spectra)
        if cvf_num_groups > 0
            [~, cvf_mu] = predict(cvf_net_e, cvf_x_sil);
            cvf_z = double(gather(extractdata(cvf_mu)))'; % spectra x latent dimensions
            for cvf_g = 1:1:cvf_num_groups
                cvf_in_group = cvf_sil_group_idx == cvf_g;
                cvf_sil(cvf_epoch, cvf_g) = nncv.get('SILHOUETTE', cvf_z(cvf_in_group, :), cvf_sil_label_idx(cvf_in_group));
            end
        end

        if cvf_show_monitor
            recordMetrics(cvf_monitor, cvf_epoch, ...
                TrainingLoss = cvf_train_loss(cvf_epoch), ...
                ValidationLoss = cvf_val_loss(cvf_epoch));
            updateInfo(cvf_monitor, Epoch = cvf_epoch + " of " + cvf_num_epochs);
            cvf_monitor.Progress = 100 * cvf_epoch / cvf_num_epochs;
            if cvf_monitor.Stop
                error( ...
                    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT], ...
                    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.WRONG_INPUT '\\n' ...
                    'The cross-validation was stopped by the user, so no number of epochs was selected.'] ...
                    )
            end
        end
        if mod(cvf_epoch, cvf_wb_step) == 0 || cvf_epoch == cvf_num_epochs
            braph2waitbar(cvf_wb, ((cvf_fold - 1) + cvf_epoch / cvf_num_epochs) / cvf_kfolds, ...
                ['Fold ' int2str(cvf_fold) ' of ' int2str(cvf_kfolds) ' - epoch ' int2str(cvf_epoch) ' of ' int2str(cvf_num_epochs) ' ...'])
        end
    end
end
function [mlf_loss, mlf_grad_e, mlf_grad_d] = vaecv_model_loss(mlf_nn, mlf_net_e, mlf_net_d, mlf_x)
    % Negative ELBO and its gradients (same as model_loss in NNVariationalAutoencoder).
    [mlf_z, mlf_mu, mlf_log_sigma_sq] = forward(mlf_net_e, mlf_x);
    mlf_y = forward(mlf_net_d, mlf_z);
    mlf_loss = mlf_nn.get('LOSS_FN', mlf_y, mlf_x, mlf_mu, mlf_log_sigma_sq);
    [mlf_grad_e, mlf_grad_d] = dlgradient(mlf_loss, mlf_net_e.Learnables, mlf_net_d.Learnables);
end
function vlf_loss = vaecv_validation_loss(vlf_nn, vlf_net_e, vlf_net_d, vlf_mbq)
    % Mean negative ELBO over the validation mini-batches.
    reset(vlf_mbq);
    vlf_loss_sum = 0;
    vlf_loss_count = 0;
    while hasdata(vlf_mbq)
        vlf_x = next(vlf_mbq);
        [vlf_z, vlf_mu, vlf_log_sigma_sq] = predict(vlf_net_e, vlf_x);
        vlf_y = predict(vlf_net_d, vlf_z);
        vlf_batch_loss = vlf_nn.get('LOSS_FN', vlf_y, vlf_x, vlf_mu, vlf_log_sigma_sq);
        vlf_loss_sum = vlf_loss_sum + double(gather(extractdata(vlf_batch_loss)));
        vlf_loss_count = vlf_loss_count + 1;
    end
    vlf_loss = vlf_loss_sum / vlf_loss_count;
end

%%% ¡prop!
PLATEAU_EPOCH_FOLDS (result, rvector) is the plateau-onset epoch of the validation loss of each fold (a consistency check; it does not decide SELECTED_EPOCH).
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    value = [];
    return
end
p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
val_loss = loss_cv{2};
value = arrayfun(@(k) nncv.get('DETECT_PLATEAU', val_loss(:, k), p(1), p(2), p(3)), 1:size(val_loss, 2));

%%% ¡prop!
OVERFIT_EPOCH_FOLDS (result, rvector) is the overfitting-onset epoch of each fold, 0 where no overfitting is detected (a consistency check; it does not decide SELECTED_EPOCH).
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    value = [];
    return
end
p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
train_loss = loss_cv{1};
val_loss = loss_cv{2};
value = arrayfun(@(k) nncv.get('DETECT_OVERFITTING', train_loss(:, k), val_loss(:, k), p(5), p(1), p(4), p(3)), 1:size(val_loss, 2));

%%% ¡prop!
PLATEAU_EPOCH (result, scalar) is the plateau-onset epoch of the pooled (fold-averaged) validation loss, 0 before the cross-validation is run.
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    value = 0;
    return
end
p = nncv.get('EARLY_STOP_PARAMS');
value = nncv.get('DETECT_PLATEAU', mean(loss_cv{2}, 2), p(1), p(2), p(3));

%%% ¡prop!
OVERFIT_EPOCH (result, scalar) is the overfitting-onset epoch of the pooled (fold-averaged) curves, 0 if no overfitting is detected.
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    value = 0;
    return
end
p = nncv.get('EARLY_STOP_PARAMS');
value = nncv.get('DETECT_OVERFITTING', mean(loss_cv{1}, 2), mean(loss_cv{2}, 2), p(5), p(1), p(4), p(3));

%%% ¡prop!
SELECTED_EPOCH (result, scalar) is the number of epochs selected by EARLY_STOP_RULE on the pooled curves, to be used to train the final model on the whole dataset (0 if there is no data).
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    value = 0;
    return
end
max_epochs = size(loss_cv{1}, 1);
plateau_epoch = nncv.memorize('PLATEAU_EPOCH');
overfit_epoch = nncv.memorize('OVERFIT_EPOCH');

switch nncv.get('EARLY_STOP_RULE')
    case 'Plateau or overfitting onset (first to occur)'
        value = plateau_epoch;
        if overfit_epoch > 0 % 0 = overfitting not detected
            value = min(plateau_epoch, overfit_epoch);
        end
    case 'Plateau onset only'
        value = plateau_epoch;
    case 'Overfitting onset only'
        if overfit_epoch == 0
            value = max_epochs;
        else
            value = overfit_epoch;
        end
    case 'No early stopping'
        value = max_epochs;
end

%%% ¡prop!
SILHOUETTE_BEST_EPOCH (result, scalar) is the epoch with the best latent separation: the maximum of the smoothed silhouette, averaged over groups and folds (0 if the silhouette is not scored).
%%%% ¡calculate!
loss_cv = nncv.memorize('LOSS_CV');
if numel(loss_cv) < 4 || isempty(loss_cv{4})
    value = 0;
    return
end
p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
sil_curve = mean(mean(loss_cv{3}, 3), 2); % mean over groups, then over folds
[~, value] = max(movmean(sil_curve, p(1)));

%%% ¡prop!
PLOT_LOSS (query, empty) plots the training and validation losses of all folds and of the pooled curve, with the plateau, overfitting and selected epochs; an optional file name exports the figure.
%%%% ¡calculate!
% nncv.get('PLOT_LOSS') plots the cross-validation loss curves.
% nncv.get('PLOT_LOSS', FILENAME) also exports the figure (e.g., a .png file).
% nncv.get('PLOT_LOSS', FILENAME, false) only exports it, without showing a window.
% Without FILENAME, the figure is saved in DIRECTORY_FIG (if set) as FILE_PREFIX_loss_curve_cv.png.
value = [];
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    return
end
train_loss = loss_cv{1};
val_loss = loss_cv{2};
[num_epochs, kfolds] = size(val_loss);
epochs = (1:num_epochs)';
plateau_epoch = nncv.memorize('PLATEAU_EPOCH');
overfit_epoch = nncv.memorize('OVERFIT_EPOCH');
selected_epoch = nncv.memorize('SELECTED_EPOCH');

show_figure = length(varargin) < 2 || varargin{2};
if show_figure
    figure_visible = 'on';
else
    figure_visible = 'off';
end
fig = figure('Name', 'Variational autoencoder cross-validation', 'Color', 'w', 'Units', 'inches', 'Position', [1 1 13 4.8], 'Visible', figure_visible);
try
    theme(fig, 'light'); % white background also when MATLAB uses the dark theme (R2025a+)
catch
end

ax1 = subplot(1, 2, 1, 'Parent', fig);
hold(ax1, 'on')
colors = lines(kfolds);
for k = 1:1:kfolds
    plot(ax1, epochs, val_loss(:, k), '-', 'Color', colors(k, :), 'LineWidth', 1, 'DisplayName', ['Fold ' int2str(k)]);
end
plot(ax1, epochs, mean(val_loss, 2), 'k-', 'LineWidth', 2.5, 'DisplayName', 'Mean of folds');
hold(ax1, 'off')
xlabel(ax1, 'Epoch')
ylabel(ax1, 'Validation loss (negative ELBO)')
title(ax1, 'Validation loss per fold')
legend(ax1, 'Location', 'best', 'Box', 'off')
grid(ax1, 'on')

ax2 = subplot(1, 2, 2, 'Parent', fig);
hold(ax2, 'on')
plot(ax2, epochs, mean(train_loss, 2), '-', 'Color', [0.30 0.45 0.69], 'LineWidth', 2, 'DisplayName', 'Training loss (mean of folds)');
plot(ax2, epochs, mean(val_loss, 2), '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 2, 'DisplayName', 'Validation loss (mean of folds)');
if plateau_epoch > 0
    xline(ax2, plateau_epoch, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2, 'DisplayName', ['Plateau onset = ' int2str(plateau_epoch)]);
end
if overfit_epoch > 0
    xline(ax2, overfit_epoch, ':', 'Color', [0.55 0 0], 'LineWidth', 1.5, 'DisplayName', ['Overfitting onset = ' int2str(overfit_epoch)]);
end
xline(ax2, selected_epoch, '-', 'Color', [0.85 0.10 0.10], 'LineWidth', 2, 'DisplayName', ['Selected = ' int2str(selected_epoch)]);
hold(ax2, 'off')
xlabel(ax2, 'Epoch')
ylabel(ax2, 'Loss (negative ELBO)')
title(ax2, [int2str(kfolds) '-fold cross-validated loss'])
legend(ax2, 'Location', 'best', 'Box', 'off')
grid(ax2, 'on')

if ~isempty(varargin) && (ischar(varargin{1}) || isstring(varargin{1})) && strlength(varargin{1}) > 0
    fig_file = char(varargin{1});
elseif ~isempty(nncv.get('DIRECTORY_FIG'))
    fig_file = fullfile(nncv.get('DIRECTORY_FIG'), [nncv.get('FILE_PREFIX') '_loss_curve_cv.png']);
else
    fig_file = '';
end
if ~isempty(fig_file)
    fig_dir = fileparts(fig_file);
    if ~isempty(fig_dir) && ~isfolder(fig_dir)
        mkdir(fig_dir);
    end
    exportgraphics(fig, fig_file, 'Resolution', 300);
    if show_figure
        disp(['Figure saved to ' fig_file])
    end
end
if ~show_figure
    close(fig)
end

%%% ¡prop!
PLOT_EPOCH_SELECTION (query, empty) plots why SELECTED_EPOCH was chosen: the validation loss has plateaued, the overfitting has not started, and how the latent separation (silhouette) evolves; an optional file name exports the figure.
%%%% ¡calculate!
% nncv.get('PLOT_EPOCH_SELECTION') plots, on the pooled (fold-averaged) curves and
%  with the epoch axis in log scale: (a) the training and validation losses with
%  the plateau onset, (b) the gap between validation and training loss with the
%  overfitting threshold, and (c) the silhouette of each group (mean +/- SD of
%  the folds), each with the selected epoch.
% nncv.get('PLOT_EPOCH_SELECTION', FILENAME) also exports the figure (e.g., a .png file).
% nncv.get('PLOT_EPOCH_SELECTION', FILENAME, false) only exports it, without showing a window.
% Without FILENAME, the figure is saved in DIRECTORY_FIG (if set) as FILE_PREFIX_epoch_justification.png.
value = [];
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    return
end
train_loss = mean(loss_cv{1}, 2);
val_loss = mean(loss_cv{2}, 2);
num_epochs = numel(val_loss);
epochs = (1:num_epochs)';
p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
plateau_epoch = nncv.memorize('PLATEAU_EPOCH');
overfit_epoch = nncv.memorize('OVERFIT_EPOCH');
selected_epoch = nncv.memorize('SELECTED_EPOCH');

% the same smoothed gap and threshold as DETECT_OVERFITTING
smoothed_train = movmean(train_loss, p(1));
smoothed_val = movmean(val_loss, p(1));
gap = smoothed_val - smoothed_train;
threshold_abs = p(4) * abs(median(smoothed_train));
warmup = max(1, p(5));
threshold_line = NaN(num_epochs, 1);
if num_epochs >= warmup
    threshold_line(warmup:end) = cummin(gap(warmup:end)) + threshold_abs;
end

has_sil = numel(loss_cv) >= 4 && ~isempty(loss_cv{4});
num_panels = 2 + has_sil;
selected_color = [0.85 0.10 0.10];
selected_label = ['Selected = ' int2str(selected_epoch)];

show_figure = length(varargin) < 2 || varargin{2};
if show_figure
    figure_visible = 'on';
else
    figure_visible = 'off';
end
fig = figure('Name', 'Selection of the number of epochs', 'Color', 'w', 'Units', 'inches', 'Position', [1 1 5 * num_panels 4.6], 'Visible', figure_visible);
try
    theme(fig, 'light'); % white background also when MATLAB uses the dark theme (R2025a+)
catch
end

% (a) the validation loss has plateaued
ax1 = subplot(1, num_panels, 1, 'Parent', fig);
hold(ax1, 'on')
plot(ax1, epochs, train_loss, '-', 'Color', [0.72 0.80 0.91], 'LineWidth', 0.8, 'HandleVisibility', 'off');
plot(ax1, epochs, val_loss, '-', 'Color', [0.96 0.78 0.68], 'LineWidth', 0.8, 'HandleVisibility', 'off');
plot(ax1, epochs, smoothed_train, '-', 'Color', [0.30 0.45 0.69], 'LineWidth', 2, 'DisplayName', 'Training loss');
plot(ax1, epochs, smoothed_val, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 2, 'DisplayName', 'Validation loss');
if plateau_epoch > 0
    xline(ax1, plateau_epoch, '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2, 'DisplayName', ['Plateau onset = ' int2str(plateau_epoch)]);
end
xline(ax1, selected_epoch, '-', 'Color', selected_color, 'LineWidth', 2, 'DisplayName', selected_label);
hold(ax1, 'off')
xlabel(ax1, 'Epoch')
ylabel(ax1, 'Loss (negative ELBO, mean of folds)')
title(ax1, 'a  Plateau of the validation loss')
legend(ax1, 'Location', 'best', 'Box', 'off')

% (b) the overfitting has not started
ax2 = subplot(1, num_panels, 2, 'Parent', fig);
hold(ax2, 'on')
plot(ax2, epochs, gap, '-', 'Color', [0.33 0.66 0.41], 'LineWidth', 2, 'DisplayName', 'Validation - training loss');
plot(ax2, epochs, threshold_line, '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2, 'DisplayName', ['Overfitting threshold (lowest gap + ' num2str(100 * p(4)) '%)']);
if overfit_epoch > 0
    xline(ax2, overfit_epoch, ':', 'Color', [0.55 0 0], 'LineWidth', 1.5, 'DisplayName', ['Overfitting onset = ' int2str(overfit_epoch)]);
else
    plot(ax2, NaN, NaN, 'w', 'DisplayName', 'No overfitting detected');
end
xline(ax2, selected_epoch, '-', 'Color', selected_color, 'LineWidth', 2, 'DisplayName', selected_label);
hold(ax2, 'off')
xlabel(ax2, 'Epoch')
ylabel(ax2, 'Gap (smoothed, mean of folds)')
title(ax2, 'b  Overfitting check')
legend(ax2, 'Location', 'best', 'Box', 'off')

axes_list = [ax1 ax2];

% (c) the latent separation
if has_sil
    sil = loss_cv{3};
    groups = loss_cv{4};
    best_epoch = nncv.memorize('SILHOUETTE_BEST_EPOCH');
    ax3 = subplot(1, num_panels, 3, 'Parent', fig);
    hold(ax3, 'on')
    colors = lines(numel(groups));
    for g = 1:1:numel(groups)
        sil_mean = mean(sil(:, :, g), 2);
        sil_sd = std(sil(:, :, g), 0, 2);
        fill(ax3, [epochs; flipud(epochs)], [sil_mean - sil_sd; flipud(sil_mean + sil_sd)], colors(g, :), ...
            'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        plot(ax3, epochs, sil_mean, '-', 'Color', colors(g, :), 'LineWidth', 1.8, 'DisplayName', groups{g});
    end
    if best_epoch > 0
        xline(ax3, best_epoch, '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2, 'DisplayName', ['Best separation = ' int2str(best_epoch)]);
    end
    xline(ax3, selected_epoch, '-', 'Color', selected_color, 'LineWidth', 2, 'DisplayName', selected_label);
    hold(ax3, 'off')
    xlabel(ax3, 'Epoch')
    ylabel(ax3, 'Silhouette score (mean +/- SD of folds)')
    title(ax3, 'c  Latent separation')
    legend(ax3, 'Location', 'best', 'Box', 'off')
    axes_list = [axes_list ax3];
end

for ax = axes_list
    grid(ax, 'on')
    if num_epochs > 1
        set(ax, 'XScale', 'log')
        xlim(ax, [1 num_epochs])
    end
end
sgtitle(fig, ['Number of epochs selected by ' int2str(size(loss_cv{2}, 2)) '-fold cross-validation: ' int2str(selected_epoch)])

if ~isempty(varargin) && (ischar(varargin{1}) || isstring(varargin{1})) && strlength(varargin{1}) > 0
    fig_file = char(varargin{1});
elseif ~isempty(nncv.get('DIRECTORY_FIG'))
    fig_file = fullfile(nncv.get('DIRECTORY_FIG'), [nncv.get('FILE_PREFIX') '_epoch_justification.png']);
else
    fig_file = '';
end
if ~isempty(fig_file)
    fig_dir = fileparts(fig_file);
    if ~isempty(fig_dir) && ~isfolder(fig_dir)
        mkdir(fig_dir);
    end
    exportgraphics(fig, fig_file, 'Resolution', 300);
    if show_figure
        disp(['Figure saved to ' fig_file])
    end
end
if ~show_figure
    close(fig)
end

%%% ¡prop!
EXPORT_RESULTS (query, empty) writes the cross-validation tables (the same CSV files as train_vae.m) and figures to a directory.
%%%% ¡calculate!
% nncv.get('EXPORT_RESULTS', DIRECTORY) writes to DIRECTORY (created if needed):
%  PREFIX_epoch_selection.csv          plateau-onset epoch of each fold and their minimum
%  PREFIX_overfitting_check.csv        per fold: plateau and overfitting onsets, combined stop, gap and validation-loss drift
%  PREFIX_patience_sensitivity.csv     plateau onset of each fold with the patience and with a doubled patience
%  PREFIX_separability_vs_epoch.csv    silhouette (mean and SD of the folds) of each group at the selected and checkpoint epochs
%  PREFIX_separability_significance.csv  paired tests (by fold) of the silhouette, first vs last of those epochs
%  PREFIX_loss_curve_cv.png            PLOT_LOSS
%  PREFIX_epoch_justification.png      PLOT_EPOCH_SELECTION
% nncv.get('EXPORT_RESULTS', DIRECTORY, PREFIX) sets PREFIX (default FILE_PREFIX).
% nncv.get('EXPORT_RESULTS') uses DIRECTORY_FIG (nothing is written if it is empty).
% The separability tables need the silhouette (SILHOUETTE_CHECK); the p-values
%  need the Statistics and Machine Learning Toolbox (NaN otherwise).
value = [];
if isempty(varargin)
    directory = nncv.get('DIRECTORY_FIG');
else
    directory = varargin{1};
end
if isempty(directory)
    return
end
loss_cv = nncv.memorize('LOSS_CV');
if isempty(loss_cv)
    return
end
if length(varargin) > 1
    prefix = varargin{2};
else
    prefix = nncv.get('FILE_PREFIX');
end
if ~isfolder(directory)
    mkdir(directory);
end
file_name = @(name) fullfile(directory, [prefix '_' name]);

train_loss = loss_cv{1};
val_loss = loss_cv{2};
[num_epochs, kfolds] = size(val_loss);
p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
plateau_folds = reshape(nncv.memorize('PLATEAU_EPOCH_FOLDS'), [], 1);
overfit_folds = reshape(nncv.memorize('OVERFIT_EPOCH_FOLDS'), [], 1);
selected_epoch = nncv.memorize('SELECTED_EPOCH');
fold_ids = (1:kfolds)';

% epoch selection (validation-loss check of each fold, as in train_vae.m)
writetable(table([string(fold_ids); "Plateau-only minimum"], [plateau_folds; min(plateau_folds)], ...
    'VariableNames', {'Fold', 'BestEpoch_PlateauOnset'}), file_name('epoch_selection.csv'));

% overfitting check of each fold
gap = movmean(val_loss, p(1), 1) - movmean(train_loss, p(1), 1);
smoothed_val = movmean(val_loss, p(1), 1);
at_plateau = sub2ind([num_epochs kfolds], plateau_folds, fold_ids);
overfit_str = cell(kfolds, 1);
combined_folds = plateau_folds;
for k = 1:1:kfolds
    if overfit_folds(k) == 0
        overfit_str{k} = 'not detected';
    else
        overfit_str{k} = int2str(overfit_folds(k));
        combined_folds(k) = min(plateau_folds(k), overfit_folds(k));
    end
end
drift_pct = 100 * (reshape(smoothed_val(end, :), [], 1) - smoothed_val(at_plateau)) ./ smoothed_val(at_plateau);
writetable(table(fold_ids, plateau_folds, overfit_str, combined_folds, gap(at_plateau), reshape(gap(end, :), [], 1), drift_pct, ...
    'VariableNames', {'Fold', 'PlateauOnsetEpoch', 'OverfittingOnsetEpoch', 'CombinedEarlyStopEpoch', 'GapAtPlateauOnset', 'GapAtEnd', 'ValLossDrift_pct'}), ...
    file_name('overfitting_check.csv'));

% patience sensitivity (doubled patience, as in train_vae.m)
patience = p(3);
if nncv.get('PATIENCE') == 0
    patience_double = max(10, round(0.04 * num_epochs));
else
    patience_double = 2 * patience;
end
if patience_double == patience
    patience_double = 2 * patience;
end
plateau_double = arrayfun(@(k) nncv.get('DETECT_PLATEAU', val_loss(:, k), p(1), p(2), patience_double), fold_ids);
writetable(table(fold_ids, plateau_folds, plateau_double, ...
    'VariableNames', {'Fold', ['PlateauOnset_patience' int2str(patience)], ['PlateauOnset_patience' int2str(patience_double)]}), ...
    file_name('patience_sensitivity.csv'));

% separability (silhouette) at the selected and checkpoint epochs
if numel(loss_cv) >= 4 && ~isempty(loss_cv{4})
    sil = loss_cv{3};
    groups = loss_cv{4};
    checkpoints = nncv.get('SILHOUETTE_CHECKPOINTS');
    checkpoints = unique([selected_epoch, checkpoints(checkpoints <= num_epochs)]);
    checkpoints = checkpoints(checkpoints >= 1 & checkpoints <= num_epochs);

    sep_rows = {};
    for c = 1:1:numel(checkpoints)
        for g = 1:1:numel(groups)
            sil_values = reshape(sil(checkpoints(c), :, g), [], 1);
            sep_rows(end + 1, :) = {checkpoints(c), groups{g}, mean(sil_values), std(sil_values), numel(sil_values)}; %#ok<AGROW>
        end
    end
    writetable(cell2table(sep_rows, 'VariableNames', {'CheckpointEpoch', 'Species', 'SilhouetteMean', 'SilhouetteSD', 'NFolds'}), ...
        file_name('separability_vs_epoch.csv'));

    % first vs last checkpoint, paired by fold (the two epochs of a fold share one training run)
    if numel(checkpoints) >= 2 && kfolds >= 3
        sig_rows = {};
        for g = 1:1:numel(groups)
            sil_first = reshape(sil(checkpoints(1), :, g), [], 1);
            sil_last = reshape(sil(checkpoints(end), :, g), [], 1);
            p_ttest = NaN;
            p_wilcoxon = NaN;
            if exist('ttest', 'file') == 2
                [~, p_ttest] = ttest(sil_last, sil_first);
            end
            if exist('signrank', 'file') == 2
                p_wilcoxon = signrank(sil_last, sil_first);
            end
            sig_rows(end + 1, :) = {groups{g}, checkpoints(1), checkpoints(end), mean(sil_last - sil_first), kfolds, p_ttest, p_wilcoxon}; %#ok<AGROW>
        end
        writetable(cell2table(sig_rows, 'VariableNames', {'Species', 'EpochFirst', 'EpochLast', 'PairedDiffMean', 'NPairs', 'PairedTTest_p', 'Wilcoxon_p'}), ...
            file_name('separability_significance.csv'));
    end
end

% figures
nncv.get('PLOT_LOSS', file_name('loss_curve_cv.png'), false);
nncv.get('PLOT_EPOCH_SELECTION', file_name('epoch_justification.png'), false);
disp(['Cross-validation tables and figures saved to ' directory])

%% ¡tests!

%%% ¡excluded_props!
[NNVariationalAutoencoderMLP_CV.PLOT_LOSS NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION NNVariationalAutoencoderMLP_CV.EXPORT_RESULTS]

%%% ¡test!
%%%% ¡name!
Early-stopping detectors on synthetic loss curves
%%%% ¡code!
nncv = NNVariationalAutoencoderMLP_CV();

% a curve that drops fast and is flat from about epoch 100
epochs = (1:1000)';
val_loss = 1 + exp(-epochs / 15);
plateau_epoch = nncv.get('DETECT_PLATEAU', val_loss, 10, 0.001, 20);
assert(plateau_epoch > 50 && plateau_epoch < 150, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not detect the plateau onset correctly.')

% a curve that keeps improving fast never plateaus: full budget
steep_loss = 1000 * exp(-epochs / 50);
assert(nncv.get('DETECT_PLATEAU', steep_loss(1:100), 10, 0.001, 20) == 100, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV should use the full budget when the loss never plateaus.')

% train and validation decrease together: no overfitting
train_loss = val_loss - 0.01;
assert(nncv.get('DETECT_OVERFITTING', train_loss, val_loss, 10, 10, 0.02, 20) == 0, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV detects overfitting where there is none.')

% the validation loss rises again from epoch 400: overfitting
val_loss_of = val_loss + 0.001 * max(0, epochs - 400);
overfit_epoch = nncv.get('DETECT_OVERFITTING', train_loss, val_loss_of, 10, 10, 0.02, 20);
assert(overfit_epoch > 400 && overfit_epoch < 500, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not detect the overfitting onset correctly.')

%%% ¡test!
%%%% ¡name!
Silhouette of latent clusters
%%%% ¡code!
nncv = NNVariationalAutoencoderMLP_CV();

% two well-separated clusters
z = [0.1 * randn(20, 2); 0.1 * randn(20, 2) + 5];
labels = [ones(20, 1); 2 * ones(20, 1)];
assert(nncv.get('SILHOUETTE', z, labels) > 0.9, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not score separated clusters close to 1.')

% labels that mix both clusters
mixed_labels = repmat([1; 2], 20, 1);
assert(abs(nncv.get('SILHOUETTE', z, mixed_labels)) < 0.2, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not score mixed labels close to 0.')

% a single label cannot be separated
assert(nncv.get('SILHOUETTE', z, ones(40, 1)) == 0, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV should score a single label as 0.')

% same as the Statistics and Machine Learning Toolbox, for both distances
if exist('silhouette', 'file') == 2
    z_overlap = [randn(15, 2); randn(15, 2) + 1.5; randn(10, 2) + [3 0]];
    labels_overlap = [ones(15, 1); 2 * ones(15, 1); 3 * ones(10, 1)];
    assert(abs(nncv.get('SILHOUETTE', z_overlap, labels_overlap) - mean(silhouette(z_overlap, labels_overlap))) < 1e-10, ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
        'NNVariationalAutoencoderMLP_CV silhouette differs from MATLAB silhouette (sqEuclidean).')
    nncv.set('SILHOUETTE_DISTANCE', 'Euclidean');
    assert(abs(nncv.get('SILHOUETTE', z_overlap, labels_overlap) - mean(silhouette(z_overlap, labels_overlap, 'Euclidean'))) < 1e-10, ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
        'NNVariationalAutoencoderMLP_CV silhouette differs from MATLAB silhouette (Euclidean).')
end

%%% ¡test!
%%%% ¡name!
Grouped folds keep each replicate in a single fold
%%%% ¡code!
% 2 species x 2 stresses x 3 replicates = 12 replicates, 4 spectra each
num_wl = 30;
species = {'AB' 'CS'};
stresses = {'HL' 'LL'};
it_list = {};
for s = 1:1:numel(species)
    for t = 1:1:numel(stresses)
        for r = 1:1:3
            plant_id = [stresses{t} int2str(r) 'loc1'];
            for n = 1:1:4
                it_list{end + 1} = NNDataPoint_RamanSpectra( ...
                    'SP_DATA', rand(num_wl, 1), ...
                    'WL', (1:num_wl)', ...
                    'WL_START', 1, ...
                    'WL_END', num_wl, ...
                    'TARGET_CLASS', {char({species{s}; stresses{t}; 'loc1'; plant_id})}); %#ok<SAGROW>
            end
        end
    end
end
d = NNDataset( ...
    'DP_CLASS', 'NNDataPoint_RamanSpectra', ...
    'DP_DICT', IndexedDictionary('IT_CLASS', 'NNDataPoint_RamanSpectra', 'IT_LIST', it_list) ...
    );

kfolds = 4;
nncv = NNVariationalAutoencoderMLP_CV('D', {d}, 'KFOLDS', kfolds, 'WAITBAR', false);

d_list = nncv.get('D_LIST');
assert(length(d_list) == kfolds, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not create the right number of folds.')

% no data point is lost or duplicated (NNDatasetCombine would merge them, as they share the same ID)
num_dp_folds = sum(cellfun(@(x) x.get('DP_DICT').get('LENGTH'), d_list));
assert(num_dp_folds == numel(it_list), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV loses or duplicates data points when splitting into folds.')

% every replicate is in exactly one fold
fold_keys = cell(1, kfolds);
for k = 1:1:kfolds
    dp_list = d_list{k}.get('DP_DICT').get('IT_LIST');
    fold_keys{k} = unique(cellfun(@(dp) strjoin(reshape(strtrim(cellstr(char(dp.get('TARGET_CLASS')))), 1, []), '|'), dp_list, 'UniformOutput', false));
end
for k1 = 1:1:kfolds
    for k2 = k1 + 1:1:kfolds
        assert(isempty(intersect(fold_keys{k1}, fold_keys{k2})), ...
            [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
            'NNVariationalAutoencoderMLP_CV puts spectra of the same replicate in different folds (leakage).')
    end
end

% each fold model is trained on all the other folds
nn_list = nncv.get('NN_LIST');
for k = 1:1:kfolds
    assert(nn_list{k}.get('D').get('DP_DICT').get('LENGTH') == numel(it_list) - d_list{k}.get('DP_DICT').get('LENGTH'), ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
        'NNVariationalAutoencoderMLP_CV does not build the training set of each fold correctly.')
end

%%% ¡test!
%%%% ¡name!
Short cross-validation run selects an epoch within the budget
%%%% ¡code!
% one species, two stresses, 6 replicates of 4 spectra
num_wl = 30;
stresses = {'HL' 'LL'};
it_list = {};
for r = 1:1:6
    stress = stresses{mod(r, 2) + 1};
    for n = 1:1:4
        it_list{end + 1} = NNDataPoint_RamanSpectra( ...
            'SP_DATA', rand(num_wl, 1), ...
            'WL', (1:num_wl)', ...
            'WL_START', 1, ...
            'WL_END', num_wl, ...
            'TARGET_CLASS', {char({'AB'; stress; 'loc1'; [stress int2str(r) 'loc1']})}); %#ok<SAGROW>
    end
end
d = NNDataset( ...
    'DP_CLASS', 'NNDataPoint_RamanSpectra', ...
    'DP_DICT', IndexedDictionary('IT_CLASS', 'NNDataPoint_RamanSpectra', 'IT_LIST', it_list) ...
    );

num_epochs = 4;
kfolds = 3;
nncv = NNVariationalAutoencoderMLP_CV( ...
    'D', {d}, ...
    'KFOLDS', kfolds, ...
    'EPOCHS', num_epochs, ...
    'BATCH', 4, ...
    'NEURONS_PER_LAYER', [8], ...
    'SILHOUETTE_CHECKPOINTS', [2 4], ...
    'WAITBAR', false, ...
    'PLOT_TRAINING', 'none');
nncv.get('TRAIN');

loss_cv = nncv.get('LOSS_CV');
assert(isequal(size(loss_cv{1}), [num_epochs kfolds]) && isequal(size(loss_cv{2}), [num_epochs kfolds]), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not record the loss of every epoch and fold.')
assert(all(isfinite(loss_cv{1}(:))) && all(isfinite(loss_cv{2}(:))), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV produces non-finite losses.')

selected_epoch = nncv.get('SELECTED_EPOCH');
assert(selected_epoch >= 1 && selected_epoch <= num_epochs, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV selects an epoch outside the budget.')

nn_list = nncv.get('NN_LIST');
assert(all(cellfun(@(nn) nn.isLocked('ENCODER'), nn_list)), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not store the trained fold networks.')

% silhouette of the two stresses of the species, at every epoch and fold
assert(isequal(loss_cv{4}, {'AB'}) && isequal(size(loss_cv{3}), [num_epochs kfolds]), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not score the latent separation of every epoch and fold.')
assert(all(loss_cv{3}(:) >= -1 & loss_cv{3}(:) <= 1), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV produces silhouette scores outside [-1, 1].')
best_epoch = nncv.get('SILHOUETTE_BEST_EPOCH');
assert(best_epoch >= 1 && best_epoch <= num_epochs, ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV finds a best-separation epoch outside the budget.')

% export of the tables and figures
directory = [tempname '_nncv_export'];
nncv.get('EXPORT_RESULTS', directory, 'test');
exported = {'epoch_selection.csv' 'overfitting_check.csv' 'patience_sensitivity.csv' ...
    'separability_vs_epoch.csv' 'separability_significance.csv' 'loss_curve_cv.png' 'epoch_justification.png'};
for i = 1:1:numel(exported)
    assert(isfile(fullfile(directory, ['test_' exported{i}])), ...
        [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
        ['NNVariationalAutoencoderMLP_CV does not export ' exported{i} '.'])
end
separability = readtable(fullfile(directory, 'test_separability_vs_epoch.csv'));
assert(height(separability) == numel(unique([selected_epoch 2 4])), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not report the silhouette at the selected and checkpoint epochs.')
rmdir(directory, 's')

% the same export through DIRECTORY_FIG and FILE_PREFIX (as from the GUI)
directory = [tempname '_nncv_export_fig'];
nncv.set('DIRECTORY_FIG', directory, 'FILE_PREFIX', 'gui');
nncv.get('EXPORT_RESULTS');
assert(isfile(fullfile(directory, 'gui_epoch_justification.png')) && isfile(fullfile(directory, 'gui_loss_curve_cv.png')), ...
    [BRAPH2.STR ':NNVariationalAutoencoderMLP_CV:' BRAPH2.FAIL_TEST], ...
    'NNVariationalAutoencoderMLP_CV does not save the figures in DIRECTORY_FIG.')
rmdir(directory, 's')
