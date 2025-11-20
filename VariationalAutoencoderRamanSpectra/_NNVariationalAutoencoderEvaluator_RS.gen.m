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
for i = 1:num_dp
    target_classes = char(d.get('DP_DICT').get('IT', i).get('TARGET_CLASS'));
    targets{i} = categorical(cellstr(strtrim(target_classes)));
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
DPROC (data, item) row-index in TARGET_CLASS for stress.
%%%% ¡settings!
'NNDatasetProcess_RamanSpectra'

%%% ¡prop!
IDX_LABEL_STRESS (parameter, scalar) row-index in TARGET_CLASS for stress.
%%%% ¡default!
2

%%% ¡prop!
STRESS_ORDER (result, stringlist) canonical order for output.
%%%% ¡calculate!
idx = nne.get('IDX_LABEL_STRESS');
latent_rep = nne.get('LATENT_REP');
YLatent = latent_rep{2};
value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));

%%% ¡prop!
STRESS_SEQ (parameter, stringlist) canonical order for output.
%%%% ¡default!
{'WL', 'HL', 'LL', 'SH'}

%%% ¡prop!
IDX_LABEL_SPECIES (parameter, scalar) row-index in TARGET_CLASS for species.
%%%% ¡default!
1

%%% ¡prop!
SPECIES_ORDER (result, stringlist) canonical order for output.
%%%% ¡calculate!
idx = nne.get('IDX_LABEL_SPECIES');
latent_rep = nne.get('LATENT_REP');
YLatent = latent_rep{2};
value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));

%%% ¡prop!
IDX_LABEL_LOCATION (parameter, scalar) row-index in TARGET_CLASS for species.
%%%% ¡default!
3

%%% ¡prop!
LOCATION_ORDER (result, stringlist) canonical order for output.
%%%% ¡calculate!
idx = nne.get('IDX_LABEL_SPECIES');
latent_rep = nne.get('LATENT_REP');
YLatent = latent_rep{2};
value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));

%%% ¡prop!
LATENT_REP (result, cell) stores the latent representations for further processing.
%%%% ¡calculate!
nnvae = nne.get('NN');
netE = nnvae.get('ENCODER');
d = nne.get('D');
mbq = nnvae.get('MBQ', d);

value = nne.get('PREDICT_ENCODER', netE, mbq);

%%% ¡prop!
PREDICT_DECODER (query, empty) indentifies the index when crossing from negative to positive.
%%%% ¡calculate!
latent_rep = nne.get('LATENT_REP');
ZLatent = latent_rep{1};
YLatent = latent_rep{2};

if isempty(varargin)
    idx = 1:1:size(ZLatent, 2);
    reprentation_select = 'one-to-one';
    denormalization = true;
    detranformation = false;
else
    idx = varargin{1};
    reprentation_select = varargin{2};
    denormalization = varargin{3};
    detranformation = varargin{4};
end
% get reconstructed spectrum for the cluster of this single lable
switch reprentation_select
    case 'one-to-one'
        ZSelected = ZLatent(:, idx);
    case 'median'
        ZSelected = median(ZLatent(:, idx), 2);
    case 'mean'
        ZSelected = mean(ZLatent(:, idx), 2);
end

ZSelected = dlarray(ZSelected, 'CB'); % convert to deep learning array

% get recontructed data
nnvae = nne.get('NN');
netD = nnvae.get('DECODER');
decoded_inputs = extractdata(predict(netD, ZSelected));

dproc = nne.get('DPROC');
if denormalization
    decoded_inputs = dproc.get('INV_NORMALIZE_DATA', decoded_inputs);
end
if detranformation
    decoded_inputs = dproc.get('INV_TRANSFORM_DATA', decoded_inputs);
end

for i = 1:size(decoded_inputs, 2)
    value{i} = decoded_inputs(:, i);
end

%%% ¡prop!
CROSSING (query, cell) returns indices/times of level crossings.
%%%% ¡calculate!
% VALUE = nne.get('CROSSING', S)
% VALUE = nne.get('CROSSING', S, t)
% VALUE = nne.get('CROSSING', S, t, level)
% VALUE = nne.get('CROSSING', S, t, level, imeth)
% VALUE = nne.get('CROSSING', S, t, level, imeth, direction)
%
% Inputs:
%   S         : signal (vector)                                  [req]
%   t         : time/wavenumber vector (same length as S)        [opt]
%   level     : crossing level (default 0)                       [opt]
%   imeth     : 'linear' (default) or 'none'                     [opt]
%   direction : 'np' (neg→pos), 'pn' (pos→neg), 'both' (default) [opt]
%
% Output VALUE (cell):
%   {1} ind   : indices i where a crossing occurs (between i and i+1)
%   {2} t0    : crossing positions (interpolated if 'linear')
%   {3} s0    : values of S-level at the crossing samples (zeros if interp)

if isempty(varargin)
    value = {};
    return
end

S = varargin{1};
t = 1:numel(S);
if numel(varargin) >= 2 && ~isempty(varargin{2}), t = varargin{2}; end
level = 0;
if numel(varargin) >= 3 && ~isempty(varargin{3}), level = varargin{3}; end
imeth = 'linear';
if numel(varargin) >= 4 && ~isempty(varargin{4}), imeth = varargin{4}; end
direction = 'both';
if numel(varargin) >= 5 && ~isempty(varargin{5}), direction = varargin{5}; end

if numel(t) ~= numel(S)
    value = {[], [], []};
    return
end

S = S(:).'; t = t(:).';
Slev = S - level;

ind0 = find(Slev == 0);
ind1 = find(Slev(1:end-1) .* Slev(2:end) < 0);
ind  = sort([ind0, ind1]);
if isempty(ind)
    value = {[], [], []}; return
end

switch lower(direction)
    case 'np',   ind = ind(Slev(ind) < 0);
    case 'pn',   ind = ind(Slev(ind) > 0);
    case 'both', % keep all
    otherwise,   value = {[], [], []}; return
end
if isempty(ind)
    value = {[], [], []}; return
end

t0 = t(ind);
s0 = Slev(ind);

if strcmpi(imeth, 'linear')
    m  = Slev(ind) ~= 0;
    ii = ind(m);
    if ~isempty(ii)
        dt = t(ii+1) - t(ii);
        dS = Slev(ii+1) - Slev(ii);
        t0(m) = t(ii) - Slev(ii) .* (dt ./ dS);
        s0(m) = 0;
    end
end

value = {ind, t0, s0};

%%% ¡prop!
DERIV_PEAKS (query, cell) finds p→n zero-crossing peaks in f′(x) and lobe areas.
%%%% ¡calculate!
% VALUE = nne.get('DERIV_PEAKS', y, x)
% VALUE = nne.get('DERIV_PEAKS', y, x, imeth)
%
% Inputs:
%   y     : 1xL or Lx1 derivative spectrum f′(x)      [req]
%   x     : 1xL or Lx1 wavenumbers (cm^-1)            [req]
%   imeth : 'linear' (default) | 'none'               [opt]
%
% Output VALUE (cell):
%   {1} PEAKS_TABLE          : [wav_real, wav_int, area]
%   {2} PEAKS_RANKED_BY_AREA : same, sorted by area desc
%   {3} ind_p2n              : indices of p→n crossings (column)
%   {4} ind_all              : indices of all crossings (column)
%   {5} area                 : area per peak (column)
%   {6} peak_wavs            : wavenumbers at p→n indices (column)

if isempty(varargin)
    value = {};
    return
end

y = varargin{1}; x = varargin{2};
imeth = 'linear';
if numel(varargin) >= 3 && ~isempty(varargin{3}), imeth = varargin{3}; end

y = y(:).'; x = x(:).';

out_pn   = nne.get('CROSSING', y, x, 0, imeth, 'pn');    ind_p2n  = out_pn{1};
out_both = nne.get('CROSSING', y, x, 0, imeth, 'both');  ind_all  = out_both{1};

area = zeros(numel(ind_p2n), 1);
for ii = 1:numel(ind_p2n)
    k = find(ind_all == ind_p2n(ii), 1);
    if isempty(k), continue; end
    if k == 1
        a = ind_all(k);   b = ind_all(k+1);
    elseif k == numel(ind_all)
        a = ind_all(k-1); b = ind_all(k);
    else
        a = ind_all(k-1); b = ind_all(k+1);
    end
    area(ii) = sum(abs(y(a:b)));
end

peak_wavs = x(ind_p2n(:));
PEAKS_TABLE = [peak_wavs(:), ceil(peak_wavs(:)), area(:)];

[area_s, I] = sort(area, 'descend');
PEAKS_RANKED_BY_AREA = [peak_wavs(I)', ceil(peak_wavs(I)'), area_s];

value = {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ind_p2n(:), ind_all(:), area(:), peak_wavs(:)};

%%% ¡prop!
PEAKS_COMPARE (query, cell) compares per-peak areas between two conditions.
%%%% ¡calculate!
% VALUE = nne.get('PEAKS_COMPARE', peaks_A, peaks_B, nameA, nameB)
% VALUE = nne.get('PEAKS_COMPARE', peaks_A, peaks_B, nameA, nameB, tolInt)
%
% Inputs:
%   peaks_A : [wav_real, wav_int, area] (from DERIV_PEAKS)   [req]
%   peaks_B : [wav_real, wav_int, area] (from DERIV_PEAKS)   [req]
%   nameA   : label for A                                    [req]
%   nameB   : label for B                                    [req]
%   tolInt  : integer tolerance for matching (±), default 1  [opt]
%
% Output VALUE (cell):
%   {1} LABEL            : 'A_B'
%   {2} RANKED_ABS_DIFF  : [wav_int, |Δarea|] sorted desc
%   {3} W                : matched integer wavenumbers (col)
%   {4} DIFF             : Δarea = area_A - area_B (col)
%   {5} DIFF_PERC        : 100*Δarea/area_B (col)
%   {6} DIFF_ABS         : |Δarea| (col)
%   {7} DIFF_ABS_PERC    : 100*|Δarea|/area_B (col)

if isempty(varargin)
    value = {};
    return
end

A = varargin{1}; B = varargin{2}; nameA = varargin{3}; nameB = varargin{4};
tolInt = 1;
if numel(varargin) >= 5 && ~isempty(varargin{5}), tolInt = varargin{5}; end

wA = A(:,2); aA = A(:,3);
wB = B(:,2); aB = B(:,3);

W = []; DIFF = []; DIFF_PERC = []; DIFF_ABS = []; DIFF_ABS_PERC = [];

for k = 1:numel(wA)
    wa = wA(k);
    J = find(abs(wB - wa) <= tolInt);
    if isempty(J), continue; end
    [~, m] = min(abs(wB(J) - wa));
    j = J(m);
    if aB(j) == 0, continue; end

    d = aA(k) - aB(j);
    W(end+1,1)             = wa;        %#ok<AGROW>
    DIFF(end+1,1)          = d;         %#ok<AGROW>
    DIFF_PERC(end+1,1)     = 100 * d / aB(j);
    DIFF_ABS(end+1,1)      = abs(d);
    DIFF_ABS_PERC(end+1,1) = 100 * abs(d) / aB(j);
end

[~, I] = sort(DIFF_ABS, 'descend');
RANKED_ABS_DIFF = [W(I), DIFF_ABS(I)];
LABEL = [char(string(nameA)) '_' char(string(nameB))];

value = {LABEL, RANKED_ABS_DIFF, W, DIFF, DIFF_PERC, DIFF_ABS, DIFF_ABS_PERC};

%%% ¡prop!
DERIV_PEAKS_RUN (query, cell) runs DERIV_PEAKS for all conditions and compares all pairs.
%%%% ¡calculate!
% VALUE = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels)
% VALUE = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels, imeth, tolInt)
%
% Inputs:
%   data_cell   : 1xC cell of spectra (each 1xL or Lx1)       [req]
%   x           : 1xL or Lx1 wavenumbers                      [req]
%   cond_labels : 1xC cellstr of condition names              [req]
%   imeth       : 'linear' (default) | 'none'                 [opt]
%   tolInt      : integer matching tolerance (default 1)      [opt]
%
% Output VALUE (cell):
%   {1} COND : 1xC cell, each COND{c} = {name, peaks_table, peaks_ranked_by_area}
%   {2} COMP : 1xP cell (P = nchoosek(C,2)),
%              each COMP{p} = {label, ranked_abs_diff, w, diff, diff_perc, diff_abs, diff_abs_perc}

if isempty(varargin)
    value = {};
    return
end

data_cell   = varargin{1};
x           = varargin{2};
cond_labels = varargin{3};
imeth  = 'linear';
if numel(varargin) >= 4 && ~isempty(varargin{4}), imeth  = varargin{4}; end
tolInt = 1;
if numel(varargin) >= 5 && ~isempty(varargin{5}), tolInt = varargin{5}; end

C = numel(cond_labels);

% per-condition
COND = cell(1, C);
for c = 1:C
    y = data_cell{c};
    out = nne.get('DERIV_PEAKS', y, x, imeth); % {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ...}
    name = cond_labels{c};
    peaks_table = out{1};
    peaks_ranked = out{2};
    COND{c} = {name, peaks_table, peaks_ranked};
end

% pairwise comparisons
pairs = nchoosek(1:C, 2);
COMP = cell(1, size(pairs,1));
for p = 1:size(pairs,1)
    i = pairs(p,1); j = pairs(p,2);
    Ai = COND{i}{2};  Bj = COND{j}{2};   % peaks_table for i and j
    out = nne.get('PEAKS_COMPARE', Ai, Bj, COND{i}{1}, COND{j}{1}, tolInt);
    COMP{p} = out; % already in desired cell schema
end

value = {COND, COMP};

%%% ¡prop!
DERIV_PEAKS_SAVE (query, cell) saves ranked tables (legacy-compatible filenames).
%%%% ¡calculate!
% nne.get('DERIV_PEAKS_SAVE', COND, COMP, state)
%
% Inputs:
%   COND  : from DERIV_PEAKS_RUN (1xC cell; each {name, peaks_table, peaks_ranked_by_area}) [req]
%   COMP  : from DERIV_PEAKS_RUN (1xP cell; each {label, ranked_abs_diff, ...})              [req]
%   state : string appended to filenames                                                      [req]
%
% Side-effect: writes .mat files:
%   'ranked_sig_pks_<COND> <state>.mat'                    (variable: ranked_sig_pks_<COND>)
%   'ranked_sig_pks_<COND1>_<COND2>_mod <state>.mat'       (variable: ranked_sig_pks_<COND1>_<COND2>_mod)

if isempty(varargin)
    value = {};
    return
end

COND  = varargin{1};
COMP  = varargin{2};
state = char(string(varargin{3}));
save_dir = nne.get('DIRECTORY_ANALYSIS');

% ensure analysis directory exists
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% --- per-condition files: ranked_sig_pks_<COND> <state>.mat ---
for c = 1:numel(COND)
    name = COND{c}{1};          % e.g. 'HL'
    ranked_sig_pks = COND{c}{3}; %#ok<NASGU>

    varname  = sprintf('ranked_sig_pks_%s', name);  % e.g. 'ranked_sig_pks_HL'
    fname    = sprintf('ranked_sig_pks_%s %s.mat', name, state);
    filepath = fullfile(save_dir, fname);

    S = struct();                       % ensure only this variable is stored
    S.(varname) = ranked_sig_pks;
    save(filepath, '-struct', 'S');
end

% --- pairwise comparison files: ranked_sig_pks_<COND1>_<COND2>_mod <state>.mat ---
for p = 1:numel(COMP)
    label = COMP{p}{1};            % e.g. 'HL_LL'
    ranked_sig_pks_mod = COMP{p}{2}; %#ok<NASGU>

    varname  = sprintf('ranked_sig_pks_%s_mod', label);  % e.g. 'ranked_sig_pks_HL_LL_mod'
    fname    = sprintf('ranked_sig_pks_%s_mod %s.mat', label, state);
    filepath = fullfile(save_dir, fname);

    S = struct();
    S.(varname) = ranked_sig_pks_mod;
    save(filepath, '-struct', 'S');
end

value = {};

%%% ¡prop!
LATENT_IDENTIFICATION (query, empty) runs latent-space export per species × location.
%%%% ¡calculate!
% Usage:
%   nne.get('LATENT_IDENTIFICATION')
%
% Side-effect:
%   In <DIRECTORY>/crnr_transformed/ it creates, for each species × location:
%     latent_AB_loc1.mat
%     latent_CS_loc1.mat
%     latent_KL_loc1.mat
%   Each .mat contains:
%     z1       : 1xK cell, one numeric column vector per stress in STRESS_SEQ
%     z2       : 1xK cell, one numeric column vector per stress in STRESS_SEQ
%     z1_range : [min_z1 max_z1] over all datapoints (global)
%     z2_range : [min_z2 max_z2] over all datapoints (global)
%
% These are the inputs expected by plot_ls_qnorm_med.R and fig_palette_p1.R.

d = nne.get('D');
num_dp = d.get('DP_DICT').get('LENGTH');
if num_dp == 0
    value = {};
    return
end

% --- indices for labels ---
i_species   = nne.get('IDX_LABEL_SPECIES');
i_stress    = nne.get('IDX_LABEL_STRESS');
i_location  = nne.get('IDX_LABEL_LOCATION');
stress_order = nne.get('STRESS_ORDER');   % e.g. {'WL','HL','LL','SH'}
stress_seq   = nne.get('STRESS_SEQ');     % sequence/order used in z1/z2 cells

% --- latent representation ---
latent_rep = nne.get('LATENT_REP');
ZLatent    = latent_rep{1};  % latent_dim x N
YLatent    = latent_rep{2};  % 1xN cell, each cell = label vector

if size(ZLatent, 1) < 2
    warning('LATENT_IDENTIFICATION: latent dimension < 2, cannot build z1/z2.');
    value = {};
    return
end

% --- build global z1/z2 and ranges ---
z1_all = ZLatent(1, :);
z2_all = ZLatent(2, :);

z1_range = [min(z1_all), max(z1_all)];  %#ok<NASGU>
z2_range = [min(z2_all), max(z2_all)];  %#ok<NASGU>

% --- labels from LATENT_REP (must match Z order) ---
species_all  = string(cellfun(@(lbl) string(lbl(i_species)),  YLatent, 'UniformOutput', false));
stress_all   = string(cellfun(@(lbl) string(lbl(i_stress)),   YLatent, 'UniformOutput', false));
location_all = string(cellfun(@(lbl) string(lbl(i_location)), YLatent, 'UniformOutput', false));

% --- unique species and locations ---
species_list  = unique(species_all,  'stable');
location_list = unique(location_all, 'stable');

% If you ONLY want loc1 (matching the current R scripts), uncomment:
% location_list = "loc1";

% --- resolve stress sequence used for saving ---
if isempty(stress_seq)
    % fallback: use STRESS_ORDER as-is
    stress_seq_labels = string(stress_order);
else
    if isnumeric(stress_seq)
        % treat as indices into STRESS_ORDER
        stress_seq_labels = string(stress_order(stress_seq));
    else
        % treat as explicit labels
        stress_seq_labels = string(stress_seq);
    end
end

K = numel(stress_seq_labels);

% --- output folder ---
root_dir = nne.get('DIRECTORY_ANALYSIS');
out_dir  = fullfile(root_dir, 'crnr_transformed');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% --- loop over species × location and save one .mat per pair ---
for s = 1:numel(species_list)
    sp = species_list(s);

    for l = 1:numel(location_list)
        loc = location_list(l);

        z1 = cell(1, K); %#ok<NASGU>
        z2 = cell(1, K); %#ok<NASGU>
        all_present = true;

        for k = 1:K
            st = stress_seq_labels(k);    % stress label for this slot in z1/z2

            idx = (species_all == sp) & (location_all == loc) & (stress_all == st);
            if ~any(idx)
                % one stress level missing → skip this species × location combo
                all_present = false;
                break
            end

            z1{k} = z1_all(idx).';  % column vectors for R
            z2{k} = z2_all(idx).';
        end

        if ~all_present
            % optional: emit a warning
            % warning('LATENT_IDENTIFICATION: skipping %s @ %s (missing stress level).', sp, loc);
            continue
        end

        % filename pattern expected by the R scripts:
        %   latent_AB_loc1.mat, latent_CS_loc1.mat, latent_KL_loc1.mat, ...
        fname     = sprintf('latent_%s_%s.mat', char(sp), char(loc));
        save_path = fullfile(out_dir, fname);

        % save variables: z1, z2, z1_range, z2_range
        save(save_path, 'z1', 'z2', 'z1_range', 'z2_range');
    end
end

value = {};

%%% ¡prop!
DATA_RECONSTRUCTION (query, empty) runs decoding → saves per species × location.
%%%% ¡calculate!
d = nne.get('D');
num_dp = d.get('DP_DICT').get('LENGTH');
if num_dp == 0
    value = {};
    return
end

% --- wavenumbers and label row indices ---
x = d.get('DP_DICT').get('IT', 1).get('WL_OF_INTEREST');  % numeric vector, wavenumber axis
i_species   = nne.get('IDX_LABEL_SPECIES');
i_stress    = nne.get('IDX_LABEL_STRESS');
i_location  = nne.get('IDX_LABEL_LOCATION');
stress_order = nne.get('STRESS_ORDER');                   % e.g. {'WL','HL','LL','SH'}
stress_seq   = nne.get('STRESS_SEQ');                     % desired sequence for saving  (NEW)

% --- labels from LATENT_REP (must match Z order) ---
latent_rep = nne.get('LATENT_REP');
YLatent    = latent_rep{2};                               % cell array of label vectors

% YLatent is assumed: each cell = vector of labels (species, stress, location, ...)
species_all  = string(cellfun(@(ind_labels) string(ind_labels(i_species)),  YLatent, 'UniformOutput', false));
stress_all   = string(cellfun(@(ind_labels) string(ind_labels(i_stress)),   YLatent, 'UniformOutput', false));
location_all = string(cellfun(@(ind_labels) string(ind_labels(i_location)), YLatent, 'UniformOutput', false));

% --- unique species and locations ---
species_list  = unique(species_all,  'stable');
location_list = unique(location_all, 'stable');

% If you ONLY want loc1 (matching current R scripts), uncomment:
% location_list = "loc1";

% --- resolve stress sequence actually used for saving (NEW BLOCK) ---
if isempty(stress_seq)
    % fallback: use STRESS_ORDER as-is
    stress_seq_labels = string(stress_order);
else
    if isnumeric(stress_seq)
        % treat as indices into STRESS_ORDER
        stress_seq_labels = string(stress_order(stress_seq));
    else
        % treat as explicit labels
        stress_seq_labels = string(stress_seq);
    end
end

% --- output folder for transformed spectra ---
root_dir = nne.get('DIRECTORY_ANALYSIS');
out_dir  = fullfile(root_dir, 'crnr_transformed');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% --- loop over species × location ---
for s = 1:numel(species_list)
    sp = species_list(s);

    for l = 1:numel(location_list)
        loc = location_list(l);

        % collect decoded spectra per stress, following STRESS_SEQ (NEW)
        num_stress   = numel(stress_seq_labels);          % was: numel(stress_order)
        spectra_cell = cell(1, num_stress);
        all_present  = true;

        for si = 1:num_stress
            st = stress_seq_labels(si);                   % was: string(stress_order{si})
            idx = (species_all == sp) & (location_all == loc) & (stress_all == st);

            if ~any(idx)
                % one stress missing → skip this species × location combo
                all_present = false;
                break
            end

            % median-decoded spectrum for this group
            dec = nne.get('PREDICT_DECODER', idx, 'median', true, false);  % 1x1 cell, column vector
            spectra_cell{si} = dec{1};
        end

        if ~all_present
            % optional: warn
            % warning('Skipping %s @ %s: not all stresses present.', sp, loc);
            continue
        end

        % R expects: data$data[[1..K]] in the order defined by STRESS_SEQ / fallback STRESS_ORDER
        data    = spectra_cell; %#ok<NASGU>
        x_local = x(:);        %#ok<NASGU>  % ensure column

        % filename exactly as fig_palette_p1.R / plot_ls_qnorm_med.R expect:
        % "(Tr) Diff Spectrum (WL-HL-LL-SH) with AB and loc1.mat"
        fname = sprintf('(Tr) Diff Spectrum (WL-HL-LL-SH) with %s and %s.mat', ...
                        char(sp), char(loc));
        save_path = fullfile(out_dir, fname);

        % R code uses "data" and "x"
        x = x_local; %#ok<NASGU>
        save(save_path, 'data', 'x');
    end
end

value = {};

%%% ¡prop!
PEAK_IDENTIFICATION (query, empty) runs decoding → peaks → save per species.
%%%% ¡calculate!
d = nne.get('D');
num_dp = d.get('DP_DICT').get('LENGTH');
if num_dp == 0
    value = {};
    return
end

% pull wavenumbers and label row indices ---
x = d.get('DP_DICT').get('IT', 1).get('WL_OF_INTEREST');  % your x
i_species   = nne.get('IDX_LABEL_SPECIES');
i_stress    = nne.get('IDX_LABEL_STRESS');
stress_order = nne.get('STRESS_ORDER');
stress_seq   = nne.get('STRESS_SEQ');   % %% NEW: desired sequence of stresses

% --- collect labels for ALL DPs in dataset order (to align with Z) ---
latent_rep = nne.get('LATENT_REP');
YLatent    = latent_rep{2};
species_all = string(cellfun(@(ind_labels) string(ind_labels(i_species)), YLatent, 'UniformOutput', false));
stress_all  = string(cellfun(@(ind_labels) string(ind_labels(i_stress)),  YLatent, 'UniformOutput', false));

% --- latent representation from encoder (keeps ordering) ---
lat = nne.get('LATENT_REP');  %#ok<NASGU> % ensures it's computed

% --- unique species in dataset (stable order) ---
species_order = nne.get('SPECIES_ORDER');

% %% NEW: resolve the stress labels sequence we actually want to use
if isempty(stress_seq)
    % fallback: use STRESS_ORDER as-is
    stress_seq_labels = string(stress_order);
else
    if isnumeric(stress_seq)
        % treat as indices into STRESS_ORDER
        stress_seq_labels = string(stress_order(stress_seq));
    else
        % treat as explicit labels (e.g. {'WL','HL','LL','SH'})
        stress_seq_labels = string(stress_seq);
    end
end

for s = 1:numel(species_order)
    sp = species_order(s);

    % build decoded spectra per stress, following STRESS_SEQ (or STRESS_ORDER fallback)
    data_cell   = {};
    cond_labels = {};
    ci = 0;

    for so = 1:numel(stress_seq_labels)      % %% MODIFIED: loop over stress_seq_labels
        st = stress_seq_labels(so);          % %% MODIFIED: label from sequence
        idx = (species_all == sp) & (stress_all == st);

        if any(idx)
            ci = ci + 1;
            dec = nne.get('PREDICT_DECODER', idx, 'median', true, false);  % returns 1 cell
            data_cell{ci}   = dec{1};                         % numeric column
            cond_labels{ci} = char(st);                       % keeps same order
        end
    end

    % if this species has < 1 stress level present, skip
    if numel(data_cell) == 0
        continue
    end

    % run peaks + pairwise comparisons for THIS species only
    out  = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels, 'linear', 1);
    COND = out{1};
    COMP = out{2};

    % save with species tag as the "state" (e.g., KL / CS / AB)
    nne.get('DERIV_PEAKS_SAVE', COND, COMP, char(sp));
end

value = {};

%%% ¡prop!
DIRECTORY_ANALYSIS (data, string) is the directory saving the exporting figure.
%%%% ¡default!
fileparts(which('test_braph2'))

%%% ¡prop!
DIRECTORY_FIG (data, string) is the directory saving the exporting figure.
%%%% ¡default!
fileparts(which('test_braph2'))

%%% ¡prop!
DIRECTORY_UTIL_R (data, string) is the directory saving the exporting figure.
%%%% ¡default!
fileparts(which('test_braph2'))

%%% ¡prop!
CREATE_R_CONTAINER (query, cell) ensures the Docker image for the R plots exists.
%%%% ¡calculate!
% VALUE = nne.get('CREATE_R_CONTAINER')
% VALUE = nne.get('CREATE_R_CONTAINER', docker_dir)
% VALUE = nne.get('CREATE_R_CONTAINER', docker_dir, image_tag)

% --- inputs & defaults ---
docker_dir = nne.get('DIRECTORY_UTIL_R');
image_tag  = 'rls-plot:latest';
if ~isempty(varargin)
    docker_dir = varargin{1};
end
if numel(varargin) >= 2 && ~isempty(varargin{2})
    image_tag = varargin{2};
end

% --- make sure Docker is on PATH (typical macOS locations, harmless elsewhere) ---
if ismac
    setenv('PATH', [getenv('PATH') ':/opt/homebrew/bin:/usr/local/bin']);
end

% --- 1) docker available? ---
[st,~] = system('docker --version');
if st ~= 0
    msg = [ ...
        'Docker command not found from within MATLAB.' newline ...
        'If Docker works in your Terminal but not in MATLAB, check the PATH:' newline ...
        '  1) In Terminal, run:  which docker' newline ...
        '     (for example it may return /usr/local/bin/docker)' newline ...
        '  2) In MATLAB, run:    setenv(''PATH'', [getenv(''PATH'') '':/usr/local/bin'']);' newline ...
        '     replacing /usr/local/bin with the directory reported by "which docker".' ];
    warning(msg);
    value = {};
    return
end

% --- 2) Dockerfile present? ---
dkfile = fullfile(docker_dir, 'Dockerfile');
if ~exist(dkfile, 'file')
    warning('No Dockerfile at: %s', dkfile);
    value = {};
    return
end

% --- 3) image exists? if not, build it ---
if ispc
    nullsink = 'NUL';
else
    nullsink = '/dev/null';
end

% first check via `docker image inspect`
cmd_check = sprintf('docker image inspect %s > %s 2>&1', image_tag, nullsink);
st = system(cmd_check);

% >>> NEW: second check via `docker image ls` if inspect failed <<<
if st ~= 0
    cmd_ls = sprintf('docker image ls "%s" --format "{{.Repository}}:{{.Tag}}"', image_tag);
    [st_ls, out_ls] = system(cmd_ls);
    out_ls = strtrim(out_ls);

    % if ls says it exists, trust ls and skip the build
    if st_ls == 0 && ~isempty(out_ls)
        st = 0;  % treat as "image exists"
    end
end
% <<< end of new block >>>

if st ~= 0
    % image really not found → build it
    fprintf('Building image %s from %s ...%s', image_tag, docker_dir, newline);
    cmd_build = sprintf('docker build --no-cache -t %s "%s"', image_tag, docker_dir);
    st_b = system(cmd_build);
    if st_b ~= 0
        warning('Docker build failed for image: %s', image_tag);
        value = {};
        return
    end
end

value = {image_tag};

%%% ¡prop!
PLOT_R_PALETTE (query, empty) generates the palette figure via Docker+R.
%%%% ¡calculate!
% Ensures container image, computes latent/peaks (so inputs for R exist),
% then runs: Rscript fig_palette_p1.R  inside the mounted workdir.

% ensure prerequisites
nne.memorize('LATENT_REP');
nne.get('PEAK_IDENTIFICATION');
nne.get('DATA_RECONSTRUCTION');
nne.get('LATENT_IDENTIFICATION');

wd_analysis = nne.get('DIRECTORY_ANALYSIS'); % where .mat + fig_palette_p1.R live
wd_fig    = nne.get('DIRECTORY_FIG');    % where you want the figures
wd_rfile = nne.get('DIRECTORY_UTIL_R');

% ensure container image exists
out = nne.get('CREATE_R_CONTAINER');
if isempty(out)
    value = {};
    return
end
image_tag = out{1};

% run the R script inside the container
cmd = sprintf([ ...
    'docker run --rm ' ...
    '-v "%s":/rfiles ' ...   % R scripts dir -> /rfiles
    '-v "%s":/work '   ...   % analysis/results dir (.mat) -> /work
    '-v "%s":/fig '    ...   % figure output dir           -> /fig
    '-w /work %s Rscript /rfiles/fig_palette_p1.R /fig'], ...
    wd_rfile, wd_analysis, wd_fig, image_tag);

fprintf('>> %s%s', cmd, newline);
[st, outstr] = system(cmd);
disp(outstr);
assert(st == 0, 'Docker run failed (fig_palette_p1.R).');

fprintf('Palette figures generated and saved in: %s%s', wd_fig, newline);

value = {};

%%% ¡prop!
PLOT_R_LS_QNORM_MED (query, empty) plots latent-space qnorm (median) via Docker+R.
%%%% ¡calculate!
% Ensures container image, computes latent/peaks, then runs:
% Rscript plot_ls_qnorm_med.R  inside the mounted workdir.

% ensure prerequisites
nne.memorize('LATENT_REP');
nne.get('PEAK_IDENTIFICATION');
nne.get('DATA_RECONSTRUCTION');
nne.get('LATENT_IDENTIFICATION');

% container ready?
out = nne.get('CREATE_R_CONTAINER'); 
if isempty(out)
    value = {};
    return
end
image_tag = out{1};

% run script
wd = nne.get('DIRECTORY_FIG');
cmd = sprintf('docker run --rm -v "%s":/work -w /work %s Rscript plot_ls_qnorm_med.R', wd, image_tag);
fprintf('>> %s%s', cmd, newline);
[st,outstr] = system(cmd);
disp(outstr);
assert(st == 0, 'Docker run failed (plot_ls_qnorm_med.R).');

% success message
fprintf('Ls qnorm figures produced successfully and saved in: %s%s', wd_fig, newline);

value = {};

%% ¡tests!

%%% ¡excluded_props!
[NNVariationalAutoencoderEvaluator_RS.PLOT_LATENT_REPRESENTATIONS NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER]
