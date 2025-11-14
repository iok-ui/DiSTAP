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

else
    idx = varargin{1};
    reprentation_select = varargin{2};
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
%   'ranked_sig_pks_<COND> <state>.mat'           (variable: ranked_sig_pks)
%   'ranked_sig_pks_<COND1>_<COND2>_mod <state>.mat' (variable: ranked_sig_pks_mod)

if isempty(varargin)
    value = {};
    return
end

COND  = varargin{1};
COMP  = varargin{2};
state = char(string(varargin{3}));
save_dir = nne.get('DIRECTORY');

for c = 1:numel(COND)
    name = COND{c}{1};
    ranked_sig_pks = COND{c}{3}; %#ok<NASGU>
    save(sprintf([save_dir filesep 'ranked_sig_pks_%s %s.mat'], name, state), 'ranked_sig_pks');
end

for p = 1:numel(COMP)
    label = COMP{p}{1};
    ranked_sig_pks_mod = COMP{p}{2}; %#ok<NASGU>
    save(sprintf([save_dir filesep 'ranked_sig_pks_%s_mod %s.mat'], label, state), 'ranked_sig_pks_mod');
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
i_species = nne.get('IDX_LABEL_SPECIES');
i_stress  = nne.get('IDX_LABEL_STRESS');
stress_order = nne.get('STRESS_ORDER');

% --- collect labels for ALL DPs in dataset order (to align with Z) ---
latent_rep = nne.get('LATENT_REP');
YLatent = latent_rep{2};
species_all = string(cellfun(@(ind_labels) string(ind_labels(i_species)), YLatent, 'UniformOutput', false));
stress_all = string(cellfun(@(ind_labels) string(ind_labels(i_stress)), YLatent, 'UniformOutput', false));

% --- latent representation from encoder (keeps ordering) ---
lat = nne.get('LATENT_REP');  %#ok<NASGU> % ensures it's computed
% we only need Z indices; PREDICT_DECODER will use logical index
% built from species_all & stress_all

% --- unique species in dataset (stable order) ---
species_order = nne.get('SPECIES_ORDER');

for s = 1:numel(species_order)
    sp = species_order(s);
    % build decoded spectra per stress, in the canonical order
    data_cell = {};
    cond_labels = {};
    ci = 0;
    for so = 1:numel(stress_order)
        st = string(stress_order{so});
        idx = (species_all == sp) & (stress_all == st);

        if any(idx)
            ci = ci + 1;
            dec = nne.get('PREDICT_DECODER', idx, 'median');  % returns 1 cell
            data_cell{ci} = dec{1};                           % numeric column
            cond_labels{ci} = char(st);
        end
    end

    % if this species has < 2 stress levels present, skip comparisons
    if numel(data_cell) == 0
        continue
    end

    % run peaks + pairwise comparisons for THIS species only
    out = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels, 'linear', 1);
    COND = out{1};
    COMP = out{2};

    % save with species tag as the "state" (e.g., KL / CS / AB)
    nne.get('DERIV_PEAKS_SAVE', COND, COMP, char(sp));
end

value = {};

%%% ¡prop!
DIRECTORY (data, string) is the directory saving the exporting figure.
%%%% ¡default!
fileparts(which('test_braph2'))

%%% ¡prop!
PLOT_R_LATENT_REPRESENTATIONS (query, empty) indentifies the index when crossing from negative to positive.

%%% ¡prop!
PLOT_R_PEAK_IDENTIFICATIONS (query, empty) indentifies the index when crossing from negative to positive.

%% ¡tests!

%%% ¡excluded_props!
[NNVariationalAutoencoderEvaluator_RS.PLOT_LATENT_REPRESENTATIONS NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER]
