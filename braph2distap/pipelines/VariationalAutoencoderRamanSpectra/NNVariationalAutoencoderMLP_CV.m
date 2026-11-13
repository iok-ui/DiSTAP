classdef NNVariationalAutoencoderMLP_CV < NNCrossValidation
	%NNVariationalAutoencoderMLP_CV uses k-fold cross-validation to choose the number of training epochs of a multilayer-perceptron variational autoencoder.
	% It is a subclass of <a href="matlab:help NNCrossValidation">NNCrossValidation</a>.
	%
	% A cross-validation for multilayer-perceptron variational autoencoders (NNVariationalAutoencoderMLP_CV) decides how many epochs a variational autoencoder (NNVariationalAutoencoderMLP) should be trained for.
	%  The dataset is split into KFOLDS folds. By default, all spectra from the same plant replicate (the same label in TARGET_CLASS, see GROUP_ROWS) are put in the same fold,
	%  so a fold is never validated on spectra from a leaf that was also used for training (no replicate leakage).
	%  For each fold, a variational autoencoder is trained on the other folds for EPOCHS epochs, and its training and validation losses (negative ELBO) are recorded at every epoch (LOSS_CV).
	%  The fold curves are averaged into one pooled curve, and the epoch is selected on that pooled curve (SELECTED_EPOCH) with the early-stopping rule EARLY_STOP_RULE:
	%  - the plateau onset is the first epoch after which the smoothed validation loss improves by less than RATE_THRESHOLD per epoch for PATIENCE consecutive epochs;
	%  - the overfitting onset is the first epoch after which the gap between validation and training loss grows by more than GAP_THRESHOLD (as a fraction of the training loss) above its lowest value so far, for PATIENCE consecutive epochs.
	%  The per-fold plateau and overfitting onsets (PLATEAU_EPOCH_FOLDS, OVERFIT_EPOCH_FOLDS) are reported as a consistency check, but they do not decide SELECTED_EPOCH.
	%  The fold models are only used to choose the epoch number; the final model is then trained on the whole dataset for SELECTED_EPOCH epochs.
	%  To check that the selected epoch is a good choice, at every epoch each fold model also encodes all spectra and the separation of the labels in its latent space is scored with the silhouette (SILHOUETTE_CHECK),
	%  separately for each group (by default, the stresses of each species, see SILHOUETTE_GROUP_ROW and SILHOUETTE_LABEL_ROW).
	%  PLOT_EPOCH_SELECTION shows, around the selected epoch, the plateau of the loss, the overfitting check and the silhouette,
	%  and EXPORT_RESULTS writes the same tables as train_vae.m (epoch selection, overfitting check, patience sensitivity, separability) and the figures to a folder.
	% 
	% To run the cross-validation, use: nncv.get('TRAIN')
	% To get the selected number of epochs, use: nncv.get('SELECTED_EPOCH')
	% To export the tables and figures, use: nncv.get('EXPORT_RESULTS', DIRECTORY, PREFIX)
	%
	% The list of NNVariationalAutoencoderMLP_CV properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the cross-validation for MLP variational autoencoders.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the cross-validation for MLP variational autoencoders.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the cross-validation for MLP variational autoencoders.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the cross-validation for MLP variational autoencoders.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code for the cross-validation for MLP variational autoencoders.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the cross-validation for MLP variational autoencoders.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the cross-validation for MLP variational autoencoders.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>WAITBAR</strong> 	WAITBAR (gui, logical) detemines whether to show the waitbar.
	%  <strong>10</strong> <strong>KFOLDS</strong> 	KFOLDS (data, scalar) is the number of folds (at least 2).
	%  <strong>11</strong> <strong>SPLIT</strong> 	SPLIT (data, cell) is a cell (one row per dataset in D, one column per fold) with the indices of the data points in each fold. If empty, it is filled in with FOLD_ASSIGNMENT when D is set.
	%  <strong>12</strong> <strong>D</strong> 	D (data, itemlist) is the datasets from groups to be cross-validated.
	%  <strong>13</strong> <strong>NN_TEMPLATE</strong> 	NN_TEMPLATE (parameter, item) is an optional variational autoencoder template; if set, its NEURONS_PER_LAYER, NUM_LATENT_REP and LEARN_RATE are used instead of those of the cross-validation.
	%  <strong>14</strong> <strong>NNEVALUATOR_TEMPLATE</strong> 	NNEVALUATOR_TEMPLATE (parameter, item) is the neural network evaluator template to set all evalutor parameters.
	%  <strong>15</strong> <strong>DSP</strong> 	DSP (result, itemlist) is a list of dataset splitter that splits the dataset per group.
	%  <strong>16</strong> <strong>DCO</strong> 	DCO (result, itemlist) is a list of dataset combiners that combines the datasets per fold.
	%  <strong>17</strong> <strong>D_LIST</strong> 	D_LIST (result, itemlist) contains the validation dataset of each of the k folds (the data points of that fold from all datasets in D).
	%  <strong>18</strong> <strong>D_LIST_IT</strong> 	D_LIST_IT (query, item) returns a dataset at a specified index in the itemlist of splitted neural network datasets.
	%  <strong>19</strong> <strong>NN_LIST</strong> 	NN_LIST (result, itemlist) contains the variational autoencoders of the k folds, each trained (by TRAIN) on all folds except its own.
	%  <strong>20</strong> <strong>NN_LIST_IT</strong> 	NN_LIST_IT (query, item) returns a neural networks model at a specified index in the itemlist of splitted neural network datasets.
	%  <strong>21</strong> <strong>EVALUATOR_LIST</strong> 	EVALUATOR_LIST (result, itemlist) contains the evaluators corresponding to the k folds.
	%  <strong>22</strong> <strong>EVALUATOR_LIST_IT</strong> 	EVALUATOR_LIST_IT (query, item) returns a neural networks evaluator at a specified index in the itemlist of splitted neural network datasets.
	%  <strong>23</strong> <strong>EPOCHS</strong> 	EPOCHS (parameter, scalar) is the maximum number of epochs each fold is trained for (the budget within which the epoch is selected).
	%  <strong>24</strong> <strong>BATCH</strong> 	BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.
	%  <strong>25</strong> <strong>SHUFFLE</strong> 	SHUFFLE (parameter, option) is an option for data shuffling.
	%  <strong>26</strong> <strong>SOLVER</strong> 	SOLVER (parameter, option) is an option for the solver.
	%  <strong>27</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display training progress information.
	%  <strong>28</strong> <strong>PLOT_TRAINING</strong> 	PLOT_TRAINING (metadata, option) determines whether to show the training and validation loss of each fold while training (the fold being trained is always printed in the command window).
	%  <strong>29</strong> <strong>TRAIN</strong> 	TRAIN (query, empty) runs the cross-validation: trains all fold models, records their losses (LOSS_CV) and selects the number of epochs (SELECTED_EPOCH).
	%  <strong>30</strong> <strong>NEURONS_PER_LAYER</strong> 	NEURONS_PER_LAYER (parameter, rvector) are the hidden-layer widths of the MLP encoder (mirrored in the decoder), used when NN_TEMPLATE is not set.
	%  <strong>31</strong> <strong>NUM_LATENT_REP</strong> 	NUM_LATENT_REP (parameter, scalar) is the number of latent dimensions, used when NN_TEMPLATE is not set.
	%  <strong>32</strong> <strong>LEARN_RATE</strong> 	LEARN_RATE (parameter, scalar) is the learning rate of the Adam optimiser, used when NN_TEMPLATE is not set.
	%  <strong>33</strong> <strong>FOLD_RULE</strong> 	FOLD_RULE (parameter, option) is how data points are assigned to folds: all spectra of the same plant replicate in the same fold (no leakage), or each spectrum independently at random.
	%  <strong>34</strong> <strong>GROUP_ROWS</strong> 	GROUP_ROWS (parameter, rvector) are the rows of TARGET_CLASS joined to identify a plant replicate (for Raman spectra: 1 species, 2 stress, 3 location, 4 plant ID); rows that a data point does not have are ignored.
	%  <strong>35</strong> <strong>FOLD_ASSIGNMENT</strong> 	FOLD_ASSIGNMENT (query, cell) returns, for a dataset, a 1 x KFOLDS cell with the (sorted) indices of the data points in each fold, following FOLD_RULE.
	%  <strong>36</strong> <strong>EARLY_STOP_RULE</strong> 	EARLY_STOP_RULE (parameter, option) is the rule used to select the number of epochs on the pooled (fold-averaged) loss curves.
	%  <strong>37</strong> <strong>RATE_THRESHOLD</strong> 	RATE_THRESHOLD (parameter, scalar) is the plateau criterion: the validation loss is considered flat when its smoothed relative improvement per epoch stays below this value (0.001 = 0.1% per epoch).
	%  <strong>38</strong> <strong>GAP_THRESHOLD</strong> 	GAP_THRESHOLD (parameter, scalar) is the overfitting criterion: overfitting starts when the validation-minus-training gap grows above its lowest value so far by more than this fraction of the (median) training loss (0.02 = 2%).
	%  <strong>39</strong> <strong>PATIENCE</strong> 	PATIENCE (parameter, scalar) is the number of consecutive epochs a criterion must hold before it fires (10 in the manuscript); 0 means automatic, max(10, round(0.02 * EPOCHS)).
	%  <strong>40</strong> <strong>SMOOTH_WINDOW</strong> 	SMOOTH_WINDOW (parameter, scalar) is the moving-average window (in epochs) applied to the loss curves before detection (15 in the manuscript); it is also the warm-up before the overfitting check starts. 0 means automatic, max(10, round(0.03 * EPOCHS)).
	%  <strong>41</strong> <strong>EARLY_STOP_PARAMS</strong> 	EARLY_STOP_PARAMS (query, rvector) returns the early-stopping parameters actually used: [SMOOTH_WINDOW RATE_THRESHOLD PATIENCE GAP_THRESHOLD WARMUP], with the automatic values resolved.
	%  <strong>42</strong> <strong>DETECT_PLATEAU</strong> 	DETECT_PLATEAU (query, scalar) returns the plateau-onset epoch of a loss curve, or the last epoch if the curve never plateaus.
	%  <strong>43</strong> <strong>DETECT_OVERFITTING</strong> 	DETECT_OVERFITTING (query, scalar) returns the overfitting-onset epoch from a training and a validation loss curve, or 0 if no overfitting is detected.
	%  <strong>44</strong> <strong>SILHOUETTE_CHECK</strong> 	SILHOUETTE_CHECK (parameter, logical) determines whether, at every epoch, the separation of the labels in the latent space of each fold model is scored with the silhouette.
	%  <strong>45</strong> <strong>SILHOUETTE_GROUP_ROW</strong> 	SILHOUETTE_GROUP_ROW (parameter, scalar) is the row of TARGET_CLASS whose groups are scored separately (for Raman spectra: 1 species); 0 scores all spectra together.
	%  <strong>46</strong> <strong>SILHOUETTE_LABEL_ROW</strong> 	SILHOUETTE_LABEL_ROW (parameter, scalar) is the row of TARGET_CLASS with the labels whose separation is scored (for Raman spectra: 2 stress).
	%  <strong>47</strong> <strong>SILHOUETTE_DISTANCE</strong> 	SILHOUETTE_DISTANCE (parameter, option) is the distance used by the silhouette (sqEuclidean is the default of MATLAB silhouette, used in train_vae.m).
	%  <strong>48</strong> <strong>SILHOUETTE_CHECKPOINTS</strong> 	SILHOUETTE_CHECKPOINTS (parameter, rvector) are the epochs reported in the separability table of EXPORT_RESULTS, together with SELECTED_EPOCH (epochs beyond EPOCHS are ignored).
	%  <strong>49</strong> <strong>DIRECTORY_FIG</strong> 	DIRECTORY_FIG (metadata, string) is the directory where the figures (PLOT_LOSS, PLOT_EPOCH_SELECTION) and the tables (EXPORT_RESULTS) are saved; if empty, the figures are only shown.
	%  <strong>50</strong> <strong>FILE_PREFIX</strong> 	FILE_PREFIX (metadata, string) is the beginning of the names of the saved figures and tables.
	%  <strong>51</strong> <strong>SILHOUETTE</strong> 	SILHOUETTE (query, scalar) returns the mean silhouette of points with given labels, from -1 (mixed) to 1 (well-separated clusters).
	%  <strong>52</strong> <strong>BUILD_NETWORKS</strong> 	BUILD_NETWORKS (query, cell) returns {ENCODER, DECODER}, freshly initialised dlnetworks with the same MLP architecture as NNVariationalAutoencoderMLP for a given variational autoencoder.
	%  <strong>53</strong> <strong>LOSS_CV</strong> 	LOSS_CV (result, cell) trains the variational autoencoder of each fold and returns {TRAIN_LOSS, VAL_LOSS, SILHOUETTE, GROUPS}: two EPOCHS x KFOLDS matrices with the mean loss (negative ELBO) per epoch, an EPOCHS x KFOLDS x number-of-groups array with the silhouette of the labels of each group in the latent space of each fold model (all spectra encoded), and the names of the groups.
	%  <strong>54</strong> <strong>PLATEAU_EPOCH_FOLDS</strong> 	PLATEAU_EPOCH_FOLDS (result, rvector) is the plateau-onset epoch of the validation loss of each fold (a consistency check; it does not decide SELECTED_EPOCH).
	%  <strong>55</strong> <strong>OVERFIT_EPOCH_FOLDS</strong> 	OVERFIT_EPOCH_FOLDS (result, rvector) is the overfitting-onset epoch of each fold, 0 where no overfitting is detected (a consistency check; it does not decide SELECTED_EPOCH).
	%  <strong>56</strong> <strong>PLATEAU_EPOCH</strong> 	PLATEAU_EPOCH (result, scalar) is the plateau-onset epoch of the pooled (fold-averaged) validation loss, 0 before the cross-validation is run.
	%  <strong>57</strong> <strong>OVERFIT_EPOCH</strong> 	OVERFIT_EPOCH (result, scalar) is the overfitting-onset epoch of the pooled (fold-averaged) curves, 0 if no overfitting is detected.
	%  <strong>58</strong> <strong>SELECTED_EPOCH</strong> 	SELECTED_EPOCH (result, scalar) is the number of epochs selected by EARLY_STOP_RULE on the pooled curves, to be used to train the final model on the whole dataset (0 if there is no data).
	%  <strong>59</strong> <strong>SILHOUETTE_BEST_EPOCH</strong> 	SILHOUETTE_BEST_EPOCH (result, scalar) is the epoch with the best latent separation: the maximum of the smoothed silhouette, averaged over groups and folds (0 if the silhouette is not scored).
	%  <strong>60</strong> <strong>PLOT_LOSS</strong> 	PLOT_LOSS (query, empty) plots the training and validation losses of all folds and of the pooled curve, with the plateau, overfitting and selected epochs; an optional file name exports the figure.
	%  <strong>61</strong> <strong>PLOT_EPOCH_SELECTION</strong> 	PLOT_EPOCH_SELECTION (query, empty) plots why SELECTED_EPOCH was chosen: the validation loss has plateaued, the overfitting has not started, and how the latent separation (silhouette) evolves; an optional file name exports the figure.
	%  <strong>62</strong> <strong>EXPORT_RESULTS</strong> 	EXPORT_RESULTS (query, empty) writes the cross-validation tables (the same CSV files as train_vae.m) and figures to a directory.
	%
	% NNVariationalAutoencoderMLP_CV methods (constructor):
	%  NNVariationalAutoencoderMLP_CV - constructor
	%
	% NNVariationalAutoencoderMLP_CV methods:
	%  set - sets values of a property
	%  check - checks the values of all properties
	%  getr - returns the raw value of a property
	%  get - returns the value of a property
	%  memorize - returns the value of a property and memorizes it
	%             (for RESULT, QUERY, and EVANESCENT properties)
	%  getPropSeed - returns the seed of a property
	%  isLocked - returns whether a property is locked
	%  lock - locks unreversibly a property
	%  isChecked - returns whether a property is checked
	%  checked - sets a property to checked
	%  unchecked - sets a property to NOT checked
	%
	% NNVariationalAutoencoderMLP_CV methods (display):
	%  tostring - string with information about the cross-validation for MLP variational autoencoders
	%  disp - displays information about the cross-validation for MLP variational autoencoders
	%  tree - displays the tree of the cross-validation for MLP variational autoencoders
	%
	% NNVariationalAutoencoderMLP_CV methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two cross-validation for MLP variational autoencoders are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the cross-validation for MLP variational autoencoders
	%
	% NNVariationalAutoencoderMLP_CV methods (save/load, Static):
	%  save - saves BRAPH2 cross-validation for MLP variational autoencoders as b2 file
	%  load - loads a BRAPH2 cross-validation for MLP variational autoencoders from a b2 file
	%
	% NNVariationalAutoencoderMLP_CV method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the cross-validation for MLP variational autoencoders
	%
	% NNVariationalAutoencoderMLP_CV method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the cross-validation for MLP variational autoencoders
	%
	% NNVariationalAutoencoderMLP_CV methods (inspection, Static):
	%  getClass - returns the class of the cross-validation for MLP variational autoencoders
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoderMLP_CV
	%  getProps - returns the property list of the cross-validation for MLP variational autoencoders
	%  getPropNumber - returns the property number of the cross-validation for MLP variational autoencoders
	%  existsProp - checks whether property exists/error
	%  existsTag - checks whether tag exists/error
	%  getPropProp - returns the property number of a property
	%  getPropTag - returns the tag of a property
	%  getPropCategory - returns the category of a property
	%  getPropFormat - returns the format of a property
	%  getPropDescription - returns the description of a property
	%  getPropSettings - returns the settings of a property
	%  getPropDefault - returns the default value of a property
	%  getPropDefaultConditioned - returns the conditioned default value of a property
	%  checkProp - checks whether a value has the correct format/error
	%
	% NNVariationalAutoencoderMLP_CV methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoderMLP_CV methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoderMLP_CV methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoderMLP_CV methods (format, Static):
	%  getFormats - returns the list of formats
	%  getFormatNumber - returns the number of formats
	%  existsFormat - returns whether a format exists/error
	%  getFormatTag - returns the tag of a format
	%  getFormatName - returns the name of a format
	%  getFormatDescription - returns the description of a format
	%  getFormatSettings - returns the settings for a format
	%  getFormatDefault - returns the default value for a format
	%  checkFormat - returns whether a value format is correct/error
	%
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoderMLP_CV; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoderMLP_CV constants</a>.
	%
	%
	% See also NNVariationalAutoencoderMLP, NNCrossValidation, NNDataPoint_RamanSpectra, NNDatasetProcess_RamanSpectra.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		NEURONS_PER_LAYER = 30; %CET: Computational Efficiency Trick
		NEURONS_PER_LAYER_TAG = 'NEURONS_PER_LAYER';
		NEURONS_PER_LAYER_CATEGORY = 3;
		NEURONS_PER_LAYER_FORMAT = 12;
		
		NUM_LATENT_REP = 31; %CET: Computational Efficiency Trick
		NUM_LATENT_REP_TAG = 'NUM_LATENT_REP';
		NUM_LATENT_REP_CATEGORY = 3;
		NUM_LATENT_REP_FORMAT = 11;
		
		LEARN_RATE = 32; %CET: Computational Efficiency Trick
		LEARN_RATE_TAG = 'LEARN_RATE';
		LEARN_RATE_CATEGORY = 3;
		LEARN_RATE_FORMAT = 11;
		
		FOLD_RULE = 33; %CET: Computational Efficiency Trick
		FOLD_RULE_TAG = 'FOLD_RULE';
		FOLD_RULE_CATEGORY = 3;
		FOLD_RULE_FORMAT = 5;
		
		GROUP_ROWS = 34; %CET: Computational Efficiency Trick
		GROUP_ROWS_TAG = 'GROUP_ROWS';
		GROUP_ROWS_CATEGORY = 3;
		GROUP_ROWS_FORMAT = 12;
		
		FOLD_ASSIGNMENT = 35; %CET: Computational Efficiency Trick
		FOLD_ASSIGNMENT_TAG = 'FOLD_ASSIGNMENT';
		FOLD_ASSIGNMENT_CATEGORY = 6;
		FOLD_ASSIGNMENT_FORMAT = 16;
		
		EARLY_STOP_RULE = 36; %CET: Computational Efficiency Trick
		EARLY_STOP_RULE_TAG = 'EARLY_STOP_RULE';
		EARLY_STOP_RULE_CATEGORY = 3;
		EARLY_STOP_RULE_FORMAT = 5;
		
		RATE_THRESHOLD = 37; %CET: Computational Efficiency Trick
		RATE_THRESHOLD_TAG = 'RATE_THRESHOLD';
		RATE_THRESHOLD_CATEGORY = 3;
		RATE_THRESHOLD_FORMAT = 11;
		
		GAP_THRESHOLD = 38; %CET: Computational Efficiency Trick
		GAP_THRESHOLD_TAG = 'GAP_THRESHOLD';
		GAP_THRESHOLD_CATEGORY = 3;
		GAP_THRESHOLD_FORMAT = 11;
		
		PATIENCE = 39; %CET: Computational Efficiency Trick
		PATIENCE_TAG = 'PATIENCE';
		PATIENCE_CATEGORY = 3;
		PATIENCE_FORMAT = 11;
		
		SMOOTH_WINDOW = 40; %CET: Computational Efficiency Trick
		SMOOTH_WINDOW_TAG = 'SMOOTH_WINDOW';
		SMOOTH_WINDOW_CATEGORY = 3;
		SMOOTH_WINDOW_FORMAT = 11;
		
		EARLY_STOP_PARAMS = 41; %CET: Computational Efficiency Trick
		EARLY_STOP_PARAMS_TAG = 'EARLY_STOP_PARAMS';
		EARLY_STOP_PARAMS_CATEGORY = 6;
		EARLY_STOP_PARAMS_FORMAT = 12;
		
		DETECT_PLATEAU = 42; %CET: Computational Efficiency Trick
		DETECT_PLATEAU_TAG = 'DETECT_PLATEAU';
		DETECT_PLATEAU_CATEGORY = 6;
		DETECT_PLATEAU_FORMAT = 11;
		
		DETECT_OVERFITTING = 43; %CET: Computational Efficiency Trick
		DETECT_OVERFITTING_TAG = 'DETECT_OVERFITTING';
		DETECT_OVERFITTING_CATEGORY = 6;
		DETECT_OVERFITTING_FORMAT = 11;
		
		SILHOUETTE_CHECK = 44; %CET: Computational Efficiency Trick
		SILHOUETTE_CHECK_TAG = 'SILHOUETTE_CHECK';
		SILHOUETTE_CHECK_CATEGORY = 3;
		SILHOUETTE_CHECK_FORMAT = 4;
		
		SILHOUETTE_GROUP_ROW = 45; %CET: Computational Efficiency Trick
		SILHOUETTE_GROUP_ROW_TAG = 'SILHOUETTE_GROUP_ROW';
		SILHOUETTE_GROUP_ROW_CATEGORY = 3;
		SILHOUETTE_GROUP_ROW_FORMAT = 11;
		
		SILHOUETTE_LABEL_ROW = 46; %CET: Computational Efficiency Trick
		SILHOUETTE_LABEL_ROW_TAG = 'SILHOUETTE_LABEL_ROW';
		SILHOUETTE_LABEL_ROW_CATEGORY = 3;
		SILHOUETTE_LABEL_ROW_FORMAT = 11;
		
		SILHOUETTE_DISTANCE = 47; %CET: Computational Efficiency Trick
		SILHOUETTE_DISTANCE_TAG = 'SILHOUETTE_DISTANCE';
		SILHOUETTE_DISTANCE_CATEGORY = 3;
		SILHOUETTE_DISTANCE_FORMAT = 5;
		
		SILHOUETTE_CHECKPOINTS = 48; %CET: Computational Efficiency Trick
		SILHOUETTE_CHECKPOINTS_TAG = 'SILHOUETTE_CHECKPOINTS';
		SILHOUETTE_CHECKPOINTS_CATEGORY = 3;
		SILHOUETTE_CHECKPOINTS_FORMAT = 12;
		
		DIRECTORY_FIG = 49; %CET: Computational Efficiency Trick
		DIRECTORY_FIG_TAG = 'DIRECTORY_FIG';
		DIRECTORY_FIG_CATEGORY = 2;
		DIRECTORY_FIG_FORMAT = 2;
		
		FILE_PREFIX = 50; %CET: Computational Efficiency Trick
		FILE_PREFIX_TAG = 'FILE_PREFIX';
		FILE_PREFIX_CATEGORY = 2;
		FILE_PREFIX_FORMAT = 2;
		
		SILHOUETTE = 51; %CET: Computational Efficiency Trick
		SILHOUETTE_TAG = 'SILHOUETTE';
		SILHOUETTE_CATEGORY = 6;
		SILHOUETTE_FORMAT = 11;
		
		BUILD_NETWORKS = 52; %CET: Computational Efficiency Trick
		BUILD_NETWORKS_TAG = 'BUILD_NETWORKS';
		BUILD_NETWORKS_CATEGORY = 6;
		BUILD_NETWORKS_FORMAT = 16;
		
		LOSS_CV = 53; %CET: Computational Efficiency Trick
		LOSS_CV_TAG = 'LOSS_CV';
		LOSS_CV_CATEGORY = 5;
		LOSS_CV_FORMAT = 16;
		
		PLATEAU_EPOCH_FOLDS = 54; %CET: Computational Efficiency Trick
		PLATEAU_EPOCH_FOLDS_TAG = 'PLATEAU_EPOCH_FOLDS';
		PLATEAU_EPOCH_FOLDS_CATEGORY = 5;
		PLATEAU_EPOCH_FOLDS_FORMAT = 12;
		
		OVERFIT_EPOCH_FOLDS = 55; %CET: Computational Efficiency Trick
		OVERFIT_EPOCH_FOLDS_TAG = 'OVERFIT_EPOCH_FOLDS';
		OVERFIT_EPOCH_FOLDS_CATEGORY = 5;
		OVERFIT_EPOCH_FOLDS_FORMAT = 12;
		
		PLATEAU_EPOCH = 56; %CET: Computational Efficiency Trick
		PLATEAU_EPOCH_TAG = 'PLATEAU_EPOCH';
		PLATEAU_EPOCH_CATEGORY = 5;
		PLATEAU_EPOCH_FORMAT = 11;
		
		OVERFIT_EPOCH = 57; %CET: Computational Efficiency Trick
		OVERFIT_EPOCH_TAG = 'OVERFIT_EPOCH';
		OVERFIT_EPOCH_CATEGORY = 5;
		OVERFIT_EPOCH_FORMAT = 11;
		
		SELECTED_EPOCH = 58; %CET: Computational Efficiency Trick
		SELECTED_EPOCH_TAG = 'SELECTED_EPOCH';
		SELECTED_EPOCH_CATEGORY = 5;
		SELECTED_EPOCH_FORMAT = 11;
		
		SILHOUETTE_BEST_EPOCH = 59; %CET: Computational Efficiency Trick
		SILHOUETTE_BEST_EPOCH_TAG = 'SILHOUETTE_BEST_EPOCH';
		SILHOUETTE_BEST_EPOCH_CATEGORY = 5;
		SILHOUETTE_BEST_EPOCH_FORMAT = 11;
		
		PLOT_LOSS = 60; %CET: Computational Efficiency Trick
		PLOT_LOSS_TAG = 'PLOT_LOSS';
		PLOT_LOSS_CATEGORY = 6;
		PLOT_LOSS_FORMAT = 1;
		
		PLOT_EPOCH_SELECTION = 61; %CET: Computational Efficiency Trick
		PLOT_EPOCH_SELECTION_TAG = 'PLOT_EPOCH_SELECTION';
		PLOT_EPOCH_SELECTION_CATEGORY = 6;
		PLOT_EPOCH_SELECTION_FORMAT = 1;
		
		EXPORT_RESULTS = 62; %CET: Computational Efficiency Trick
		EXPORT_RESULTS_TAG = 'EXPORT_RESULTS';
		EXPORT_RESULTS_CATEGORY = 6;
		EXPORT_RESULTS_FORMAT = 1;
	end
	methods % constructor
		function nncv = NNVariationalAutoencoderMLP_CV(varargin)
			%NNVariationalAutoencoderMLP_CV() creates a cross-validation for MLP variational autoencoders.
			%
			% NNVariationalAutoencoderMLP_CV(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoderMLP_CV(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoderMLP_CV properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the cross-validation for MLP variational autoencoders.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the cross-validation for MLP variational autoencoders.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the cross-validation for MLP variational autoencoders.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the cross-validation for MLP variational autoencoders.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code for the cross-validation for MLP variational autoencoders.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the cross-validation for MLP variational autoencoders.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the cross-validation for MLP variational autoencoders.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>WAITBAR</strong> 	WAITBAR (gui, logical) detemines whether to show the waitbar.
			%  <strong>10</strong> <strong>KFOLDS</strong> 	KFOLDS (data, scalar) is the number of folds (at least 2).
			%  <strong>11</strong> <strong>SPLIT</strong> 	SPLIT (data, cell) is a cell (one row per dataset in D, one column per fold) with the indices of the data points in each fold. If empty, it is filled in with FOLD_ASSIGNMENT when D is set.
			%  <strong>12</strong> <strong>D</strong> 	D (data, itemlist) is the datasets from groups to be cross-validated.
			%  <strong>13</strong> <strong>NN_TEMPLATE</strong> 	NN_TEMPLATE (parameter, item) is an optional variational autoencoder template; if set, its NEURONS_PER_LAYER, NUM_LATENT_REP and LEARN_RATE are used instead of those of the cross-validation.
			%  <strong>14</strong> <strong>NNEVALUATOR_TEMPLATE</strong> 	NNEVALUATOR_TEMPLATE (parameter, item) is the neural network evaluator template to set all evalutor parameters.
			%  <strong>15</strong> <strong>DSP</strong> 	DSP (result, itemlist) is a list of dataset splitter that splits the dataset per group.
			%  <strong>16</strong> <strong>DCO</strong> 	DCO (result, itemlist) is a list of dataset combiners that combines the datasets per fold.
			%  <strong>17</strong> <strong>D_LIST</strong> 	D_LIST (result, itemlist) contains the validation dataset of each of the k folds (the data points of that fold from all datasets in D).
			%  <strong>18</strong> <strong>D_LIST_IT</strong> 	D_LIST_IT (query, item) returns a dataset at a specified index in the itemlist of splitted neural network datasets.
			%  <strong>19</strong> <strong>NN_LIST</strong> 	NN_LIST (result, itemlist) contains the variational autoencoders of the k folds, each trained (by TRAIN) on all folds except its own.
			%  <strong>20</strong> <strong>NN_LIST_IT</strong> 	NN_LIST_IT (query, item) returns a neural networks model at a specified index in the itemlist of splitted neural network datasets.
			%  <strong>21</strong> <strong>EVALUATOR_LIST</strong> 	EVALUATOR_LIST (result, itemlist) contains the evaluators corresponding to the k folds.
			%  <strong>22</strong> <strong>EVALUATOR_LIST_IT</strong> 	EVALUATOR_LIST_IT (query, item) returns a neural networks evaluator at a specified index in the itemlist of splitted neural network datasets.
			%  <strong>23</strong> <strong>EPOCHS</strong> 	EPOCHS (parameter, scalar) is the maximum number of epochs each fold is trained for (the budget within which the epoch is selected).
			%  <strong>24</strong> <strong>BATCH</strong> 	BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.
			%  <strong>25</strong> <strong>SHUFFLE</strong> 	SHUFFLE (parameter, option) is an option for data shuffling.
			%  <strong>26</strong> <strong>SOLVER</strong> 	SOLVER (parameter, option) is an option for the solver.
			%  <strong>27</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display training progress information.
			%  <strong>28</strong> <strong>PLOT_TRAINING</strong> 	PLOT_TRAINING (metadata, option) determines whether to show the training and validation loss of each fold while training (the fold being trained is always printed in the command window).
			%  <strong>29</strong> <strong>TRAIN</strong> 	TRAIN (query, empty) runs the cross-validation: trains all fold models, records their losses (LOSS_CV) and selects the number of epochs (SELECTED_EPOCH).
			%  <strong>30</strong> <strong>NEURONS_PER_LAYER</strong> 	NEURONS_PER_LAYER (parameter, rvector) are the hidden-layer widths of the MLP encoder (mirrored in the decoder), used when NN_TEMPLATE is not set.
			%  <strong>31</strong> <strong>NUM_LATENT_REP</strong> 	NUM_LATENT_REP (parameter, scalar) is the number of latent dimensions, used when NN_TEMPLATE is not set.
			%  <strong>32</strong> <strong>LEARN_RATE</strong> 	LEARN_RATE (parameter, scalar) is the learning rate of the Adam optimiser, used when NN_TEMPLATE is not set.
			%  <strong>33</strong> <strong>FOLD_RULE</strong> 	FOLD_RULE (parameter, option) is how data points are assigned to folds: all spectra of the same plant replicate in the same fold (no leakage), or each spectrum independently at random.
			%  <strong>34</strong> <strong>GROUP_ROWS</strong> 	GROUP_ROWS (parameter, rvector) are the rows of TARGET_CLASS joined to identify a plant replicate (for Raman spectra: 1 species, 2 stress, 3 location, 4 plant ID); rows that a data point does not have are ignored.
			%  <strong>35</strong> <strong>FOLD_ASSIGNMENT</strong> 	FOLD_ASSIGNMENT (query, cell) returns, for a dataset, a 1 x KFOLDS cell with the (sorted) indices of the data points in each fold, following FOLD_RULE.
			%  <strong>36</strong> <strong>EARLY_STOP_RULE</strong> 	EARLY_STOP_RULE (parameter, option) is the rule used to select the number of epochs on the pooled (fold-averaged) loss curves.
			%  <strong>37</strong> <strong>RATE_THRESHOLD</strong> 	RATE_THRESHOLD (parameter, scalar) is the plateau criterion: the validation loss is considered flat when its smoothed relative improvement per epoch stays below this value (0.001 = 0.1% per epoch).
			%  <strong>38</strong> <strong>GAP_THRESHOLD</strong> 	GAP_THRESHOLD (parameter, scalar) is the overfitting criterion: overfitting starts when the validation-minus-training gap grows above its lowest value so far by more than this fraction of the (median) training loss (0.02 = 2%).
			%  <strong>39</strong> <strong>PATIENCE</strong> 	PATIENCE (parameter, scalar) is the number of consecutive epochs a criterion must hold before it fires (10 in the manuscript); 0 means automatic, max(10, round(0.02 * EPOCHS)).
			%  <strong>40</strong> <strong>SMOOTH_WINDOW</strong> 	SMOOTH_WINDOW (parameter, scalar) is the moving-average window (in epochs) applied to the loss curves before detection (15 in the manuscript); it is also the warm-up before the overfitting check starts. 0 means automatic, max(10, round(0.03 * EPOCHS)).
			%  <strong>41</strong> <strong>EARLY_STOP_PARAMS</strong> 	EARLY_STOP_PARAMS (query, rvector) returns the early-stopping parameters actually used: [SMOOTH_WINDOW RATE_THRESHOLD PATIENCE GAP_THRESHOLD WARMUP], with the automatic values resolved.
			%  <strong>42</strong> <strong>DETECT_PLATEAU</strong> 	DETECT_PLATEAU (query, scalar) returns the plateau-onset epoch of a loss curve, or the last epoch if the curve never plateaus.
			%  <strong>43</strong> <strong>DETECT_OVERFITTING</strong> 	DETECT_OVERFITTING (query, scalar) returns the overfitting-onset epoch from a training and a validation loss curve, or 0 if no overfitting is detected.
			%  <strong>44</strong> <strong>SILHOUETTE_CHECK</strong> 	SILHOUETTE_CHECK (parameter, logical) determines whether, at every epoch, the separation of the labels in the latent space of each fold model is scored with the silhouette.
			%  <strong>45</strong> <strong>SILHOUETTE_GROUP_ROW</strong> 	SILHOUETTE_GROUP_ROW (parameter, scalar) is the row of TARGET_CLASS whose groups are scored separately (for Raman spectra: 1 species); 0 scores all spectra together.
			%  <strong>46</strong> <strong>SILHOUETTE_LABEL_ROW</strong> 	SILHOUETTE_LABEL_ROW (parameter, scalar) is the row of TARGET_CLASS with the labels whose separation is scored (for Raman spectra: 2 stress).
			%  <strong>47</strong> <strong>SILHOUETTE_DISTANCE</strong> 	SILHOUETTE_DISTANCE (parameter, option) is the distance used by the silhouette (sqEuclidean is the default of MATLAB silhouette, used in train_vae.m).
			%  <strong>48</strong> <strong>SILHOUETTE_CHECKPOINTS</strong> 	SILHOUETTE_CHECKPOINTS (parameter, rvector) are the epochs reported in the separability table of EXPORT_RESULTS, together with SELECTED_EPOCH (epochs beyond EPOCHS are ignored).
			%  <strong>49</strong> <strong>DIRECTORY_FIG</strong> 	DIRECTORY_FIG (metadata, string) is the directory where the figures (PLOT_LOSS, PLOT_EPOCH_SELECTION) and the tables (EXPORT_RESULTS) are saved; if empty, the figures are only shown.
			%  <strong>50</strong> <strong>FILE_PREFIX</strong> 	FILE_PREFIX (metadata, string) is the beginning of the names of the saved figures and tables.
			%  <strong>51</strong> <strong>SILHOUETTE</strong> 	SILHOUETTE (query, scalar) returns the mean silhouette of points with given labels, from -1 (mixed) to 1 (well-separated clusters).
			%  <strong>52</strong> <strong>BUILD_NETWORKS</strong> 	BUILD_NETWORKS (query, cell) returns {ENCODER, DECODER}, freshly initialised dlnetworks with the same MLP architecture as NNVariationalAutoencoderMLP for a given variational autoencoder.
			%  <strong>53</strong> <strong>LOSS_CV</strong> 	LOSS_CV (result, cell) trains the variational autoencoder of each fold and returns {TRAIN_LOSS, VAL_LOSS, SILHOUETTE, GROUPS}: two EPOCHS x KFOLDS matrices with the mean loss (negative ELBO) per epoch, an EPOCHS x KFOLDS x number-of-groups array with the silhouette of the labels of each group in the latent space of each fold model (all spectra encoded), and the names of the groups.
			%  <strong>54</strong> <strong>PLATEAU_EPOCH_FOLDS</strong> 	PLATEAU_EPOCH_FOLDS (result, rvector) is the plateau-onset epoch of the validation loss of each fold (a consistency check; it does not decide SELECTED_EPOCH).
			%  <strong>55</strong> <strong>OVERFIT_EPOCH_FOLDS</strong> 	OVERFIT_EPOCH_FOLDS (result, rvector) is the overfitting-onset epoch of each fold, 0 where no overfitting is detected (a consistency check; it does not decide SELECTED_EPOCH).
			%  <strong>56</strong> <strong>PLATEAU_EPOCH</strong> 	PLATEAU_EPOCH (result, scalar) is the plateau-onset epoch of the pooled (fold-averaged) validation loss, 0 before the cross-validation is run.
			%  <strong>57</strong> <strong>OVERFIT_EPOCH</strong> 	OVERFIT_EPOCH (result, scalar) is the overfitting-onset epoch of the pooled (fold-averaged) curves, 0 if no overfitting is detected.
			%  <strong>58</strong> <strong>SELECTED_EPOCH</strong> 	SELECTED_EPOCH (result, scalar) is the number of epochs selected by EARLY_STOP_RULE on the pooled curves, to be used to train the final model on the whole dataset (0 if there is no data).
			%  <strong>59</strong> <strong>SILHOUETTE_BEST_EPOCH</strong> 	SILHOUETTE_BEST_EPOCH (result, scalar) is the epoch with the best latent separation: the maximum of the smoothed silhouette, averaged over groups and folds (0 if the silhouette is not scored).
			%  <strong>60</strong> <strong>PLOT_LOSS</strong> 	PLOT_LOSS (query, empty) plots the training and validation losses of all folds and of the pooled curve, with the plateau, overfitting and selected epochs; an optional file name exports the figure.
			%  <strong>61</strong> <strong>PLOT_EPOCH_SELECTION</strong> 	PLOT_EPOCH_SELECTION (query, empty) plots why SELECTED_EPOCH was chosen: the validation loss has plateaued, the overfitting has not started, and how the latent separation (silhouette) evolves; an optional file name exports the figure.
			%  <strong>62</strong> <strong>EXPORT_RESULTS</strong> 	EXPORT_RESULTS (query, empty) writes the cross-validation tables (the same CSV files as train_vae.m) and figures to a directory.
			%
			% See also Category, Format.
			
			nncv = nncv@NNCrossValidation(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the cross-validation for MLP variational autoencoders.
			%
			% BUILD = NNVariationalAutoencoderMLP_CV.GETBUILD() returns the build of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNCV.GETBUILD() returns the build of the cross-validation for MLP variational autoencoders NNCV.
			%  BUILD = Element.GETBUILD(NNCV) returns the build of 'NNCV'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoderMLP_CV') returns the build of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Note that the Element.GETBUILD(NNCV) and Element.GETBUILD('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nncv_class = getClass()
			%GETCLASS returns the class of the cross-validation for MLP variational autoencoders.
			%
			% CLASS = NNVariationalAutoencoderMLP_CV.GETCLASS() returns the class 'NNVariationalAutoencoderMLP_CV'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNCV.GETCLASS() returns the class of the cross-validation for MLP variational autoencoders NNCV.
			%  CLASS = Element.GETCLASS(NNCV) returns the class of 'NNCV'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoderMLP_CV') returns 'NNVariationalAutoencoderMLP_CV'.
			%
			% Note that the Element.GETCLASS(NNCV) and Element.GETCLASS('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			
			nncv_class = 'NNVariationalAutoencoderMLP_CV';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the cross-validation for MLP variational autoencoders.
			%
			% LIST = NNVariationalAutoencoderMLP_CV.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNCV.GETSUBCLASSES() returns all subclasses of the cross-validation for MLP variational autoencoders NNCV.
			%  LIST = Element.GETSUBCLASSES(NNCV) returns all subclasses of 'NNCV'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoderMLP_CV') returns all subclasses of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Note that the Element.GETSUBCLASSES(NNCV) and Element.GETSUBCLASSES('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoderMLP_CV' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of cross-validation for MLP variational autoencoders.
			%
			% PROPS = NNVariationalAutoencoderMLP_CV.GETPROPS() returns the property list of cross-validation for MLP variational autoencoders
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoderMLP_CV.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNCV.GETPROPS([CATEGORY]) returns the property list of the cross-validation for MLP variational autoencoders NNCV.
			%  PROPS = Element.GETPROPS(NNCV[, CATEGORY]) returns the property list of 'NNCV'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoderMLP_CV'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Note that the Element.GETPROPS(NNCV) and Element.GETPROPS('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7 28 49 50];
				case 3 % Category.PARAMETER
					prop_list = [4 13 14 23 24 25 26 30 31 32 33 34 36 37 38 39 40 44 45 46 47 48];
				case 4 % Category.DATA
					prop_list = [5 10 11 12];
				case 5 % Category.RESULT
					prop_list = [15 16 17 19 21 53 54 55 56 57 58 59];
				case 6 % Category.QUERY
					prop_list = [8 18 20 22 29 35 41 42 43 51 52 60 61 62];
				case 9 % Category.GUI
					prop_list = [9 27];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of cross-validation for MLP variational autoencoders.
			%
			% N = NNVariationalAutoencoderMLP_CV.GETPROPNUMBER() returns the property number of cross-validation for MLP variational autoencoders.
			%
			% N = NNVariationalAutoencoderMLP_CV.GETPROPNUMBER(CATEGORY) returns the property number of cross-validation for MLP variational autoencoders
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNCV.GETPROPNUMBER([CATEGORY]) returns the property number of the cross-validation for MLP variational autoencoders NNCV.
			%  N = Element.GETPROPNUMBER(NNCV) returns the property number of 'NNCV'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoderMLP_CV') returns the property number of 'NNVariationalAutoencoderMLP_CV'.
			%
			% Note that the Element.GETPROPNUMBER(NNCV) and Element.GETPROPNUMBER('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 62;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 5;
				case 3 % Category.PARAMETER
					prop_number = 22;
				case 4 % Category.DATA
					prop_number = 4;
				case 5 % Category.RESULT
					prop_number = 12;
				case 6 % Category.QUERY
					prop_number = 14;
				case 9 % Category.GUI
					prop_number = 2;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in cross-validation for MLP variational autoencoders/error.
			%
			% CHECK = NNVariationalAutoencoderMLP_CV.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNCV.EXISTSPROP(PROP) checks whether PROP exists for NNCV.
			%  CHECK = Element.EXISTSPROP(NNCV, PROP) checks whether PROP exists for NNCV.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoderMLP_CV, PROP) checks whether PROP exists for NNVariationalAutoencoderMLP_CV.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNCV.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNCV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%  Element.EXISTSPROP(NNCV, PROP) throws error if PROP does NOT exist for NNCV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoderMLP_CV, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoderMLP_CV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNCV) and Element.EXISTSPROP('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 62 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoderMLP_CV.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in cross-validation for MLP variational autoencoders/error.
			%
			% CHECK = NNVariationalAutoencoderMLP_CV.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNCV.EXISTSTAG(TAG) checks whether TAG exists for NNCV.
			%  CHECK = Element.EXISTSTAG(NNCV, TAG) checks whether TAG exists for NNCV.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoderMLP_CV, TAG) checks whether TAG exists for NNVariationalAutoencoderMLP_CV.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNCV.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNCV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%  Element.EXISTSTAG(NNCV, TAG) throws error if TAG does NOT exist for NNCV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoderMLP_CV, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoderMLP_CV.
			%   Error id: [BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNCV) and Element.EXISTSTAG('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'WAITBAR'  'KFOLDS'  'SPLIT'  'D'  'NN_TEMPLATE'  'NNEVALUATOR_TEMPLATE'  'DSP'  'DCO'  'D_LIST'  'D_LIST_IT'  'NN_LIST'  'NN_LIST_IT'  'EVALUATOR_LIST'  'EVALUATOR_LIST_IT'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'VERBOSE'  'PLOT_TRAINING'  'TRAIN'  'NEURONS_PER_LAYER'  'NUM_LATENT_REP'  'LEARN_RATE'  'FOLD_RULE'  'GROUP_ROWS'  'FOLD_ASSIGNMENT'  'EARLY_STOP_RULE'  'RATE_THRESHOLD'  'GAP_THRESHOLD'  'PATIENCE'  'SMOOTH_WINDOW'  'EARLY_STOP_PARAMS'  'DETECT_PLATEAU'  'DETECT_OVERFITTING'  'SILHOUETTE_CHECK'  'SILHOUETTE_GROUP_ROW'  'SILHOUETTE_LABEL_ROW'  'SILHOUETTE_DISTANCE'  'SILHOUETTE_CHECKPOINTS'  'DIRECTORY_FIG'  'FILE_PREFIX'  'SILHOUETTE'  'BUILD_NETWORKS'  'LOSS_CV'  'PLATEAU_EPOCH_FOLDS'  'OVERFIT_EPOCH_FOLDS'  'PLATEAU_EPOCH'  'OVERFIT_EPOCH'  'SELECTED_EPOCH'  'SILHOUETTE_BEST_EPOCH'  'PLOT_LOSS'  'PLOT_EPOCH_SELECTION'  'EXPORT_RESULTS' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoderMLP_CV.'] ...
					)
			end
		end
		function prop = getPropProp(pointer)
			%GETPROPPROP returns the property number of a property.
			%
			% PROP = Element.GETPROPPROP(PROP) returns PROP, i.e., the 
			%  property number of the property PROP.
			%
			% PROP = Element.GETPROPPROP(TAG) returns the property number 
			%  of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  PROPERTY = NNCV.GETPROPPROP(POINTER) returns property number of POINTER of NNCV.
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoderMLP_CV, POINTER) returns property number of POINTER of NNVariationalAutoencoderMLP_CV.
			%  PROPERTY = NNCV.GETPROPPROP(NNVariationalAutoencoderMLP_CV, POINTER) returns property number of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPPROP(NNCV) and Element.GETPROPPROP('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'WAITBAR'  'KFOLDS'  'SPLIT'  'D'  'NN_TEMPLATE'  'NNEVALUATOR_TEMPLATE'  'DSP'  'DCO'  'D_LIST'  'D_LIST_IT'  'NN_LIST'  'NN_LIST_IT'  'EVALUATOR_LIST'  'EVALUATOR_LIST_IT'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'VERBOSE'  'PLOT_TRAINING'  'TRAIN'  'NEURONS_PER_LAYER'  'NUM_LATENT_REP'  'LEARN_RATE'  'FOLD_RULE'  'GROUP_ROWS'  'FOLD_ASSIGNMENT'  'EARLY_STOP_RULE'  'RATE_THRESHOLD'  'GAP_THRESHOLD'  'PATIENCE'  'SMOOTH_WINDOW'  'EARLY_STOP_PARAMS'  'DETECT_PLATEAU'  'DETECT_OVERFITTING'  'SILHOUETTE_CHECK'  'SILHOUETTE_GROUP_ROW'  'SILHOUETTE_LABEL_ROW'  'SILHOUETTE_DISTANCE'  'SILHOUETTE_CHECKPOINTS'  'DIRECTORY_FIG'  'FILE_PREFIX'  'SILHOUETTE'  'BUILD_NETWORKS'  'LOSS_CV'  'PLATEAU_EPOCH_FOLDS'  'OVERFIT_EPOCH_FOLDS'  'PLATEAU_EPOCH'  'OVERFIT_EPOCH'  'SELECTED_EPOCH'  'SILHOUETTE_BEST_EPOCH'  'PLOT_LOSS'  'PLOT_EPOCH_SELECTION'  'EXPORT_RESULTS' })); % tag = pointer %CET: Computational Efficiency Trick
			else % numeric
				prop = pointer;
			end
		end
		function tag = getPropTag(pointer)
			%GETPROPTAG returns the tag of a property.
			%
			% TAG = Element.GETPROPTAG(PROP) returns the tag TAG of the 
			%  property PROP.
			%
			% TAG = Element.GETPROPTAG(TAG) returns TAG, i.e. the tag of 
			%  the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  TAG = NNCV.GETPROPTAG(POINTER) returns tag of POINTER of NNCV.
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoderMLP_CV, POINTER) returns tag of POINTER of NNVariationalAutoencoderMLP_CV.
			%  TAG = NNCV.GETPROPTAG(NNVariationalAutoencoderMLP_CV, POINTER) returns tag of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPTAG(NNCV) and Element.GETPROPTAG('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencodermlp_cv_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'WAITBAR'  'KFOLDS'  'SPLIT'  'D'  'NN_TEMPLATE'  'NNEVALUATOR_TEMPLATE'  'DSP'  'DCO'  'D_LIST'  'D_LIST_IT'  'NN_LIST'  'NN_LIST_IT'  'EVALUATOR_LIST'  'EVALUATOR_LIST_IT'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'VERBOSE'  'PLOT_TRAINING'  'TRAIN'  'NEURONS_PER_LAYER'  'NUM_LATENT_REP'  'LEARN_RATE'  'FOLD_RULE'  'GROUP_ROWS'  'FOLD_ASSIGNMENT'  'EARLY_STOP_RULE'  'RATE_THRESHOLD'  'GAP_THRESHOLD'  'PATIENCE'  'SMOOTH_WINDOW'  'EARLY_STOP_PARAMS'  'DETECT_PLATEAU'  'DETECT_OVERFITTING'  'SILHOUETTE_CHECK'  'SILHOUETTE_GROUP_ROW'  'SILHOUETTE_LABEL_ROW'  'SILHOUETTE_DISTANCE'  'SILHOUETTE_CHECKPOINTS'  'DIRECTORY_FIG'  'FILE_PREFIX'  'SILHOUETTE'  'BUILD_NETWORKS'  'LOSS_CV'  'PLATEAU_EPOCH_FOLDS'  'OVERFIT_EPOCH_FOLDS'  'PLATEAU_EPOCH'  'OVERFIT_EPOCH'  'SELECTED_EPOCH'  'SILHOUETTE_BEST_EPOCH'  'PLOT_LOSS'  'PLOT_EPOCH_SELECTION'  'EXPORT_RESULTS' };
				tag = nnvariationalautoencodermlp_cv_tag_list{pointer}; % prop = pointer
			end
		end
		function prop_category = getPropCategory(pointer)
			%GETPROPCATEGORY returns the category of a property.
			%
			% CATEGORY = Element.GETPROPCATEGORY(PROP) returns the category of the
			%  property PROP.
			%
			% CATEGORY = Element.GETPROPCATEGORY(TAG) returns the category of the
			%  property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CATEGORY = NNCV.GETPROPCATEGORY(POINTER) returns category of POINTER of NNCV.
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoderMLP_CV, POINTER) returns category of POINTER of NNVariationalAutoencoderMLP_CV.
			%  CATEGORY = NNCV.GETPROPCATEGORY(NNVariationalAutoencoderMLP_CV, POINTER) returns category of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPCATEGORY(NNCV) and Element.GETPROPCATEGORY('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencodermlp_cv_category_list = { 1  1  1  3  4  2  2  6  9  4  4  4  3  3  5  5  5  6  5  6  5  6  3  3  3  3  9  2  6  3  3  3  3  3  6  3  3  3  3  3  6  6  6  3  3  3  3  3  2  2  6  6  5  5  5  5  5  5  5  6  6  6 };
			prop_category = nnvariationalautoencodermlp_cv_category_list{prop};
		end
		function prop_format = getPropFormat(pointer)
			%GETPROPFORMAT returns the format of a property.
			%
			% FORMAT = Element.GETPROPFORMAT(PROP) returns the
			%  format of the property PROP.
			%
			% FORMAT = Element.GETPROPFORMAT(TAG) returns the
			%  format of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  FORMAT = NNCV.GETPROPFORMAT(POINTER) returns format of POINTER of NNCV.
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoderMLP_CV, POINTER) returns format of POINTER of NNVariationalAutoencoderMLP_CV.
			%  FORMAT = NNCV.GETPROPFORMAT(NNVariationalAutoencoderMLP_CV, POINTER) returns format of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPFORMAT(NNCV) and Element.GETPROPFORMAT('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencodermlp_cv_format_list = { 2  2  2  8  2  2  2  2  4  11  16  9  8  8  9  9  9  8  9  8  9  8  11  11  5  5  4  5  1  12  11  11  5  12  16  5  11  11  11  11  12  11  11  4  11  11  5  12  2  2  11  16  16  12  12  11  11  11  11  1  1  1 };
			prop_format = nnvariationalautoencodermlp_cv_format_list{prop};
		end
		function prop_description = getPropDescription(pointer)
			%GETPROPDESCRIPTION returns the description of a property.
			%
			% DESCRIPTION = Element.GETPROPDESCRIPTION(PROP) returns the
			%  description of the property PROP.
			%
			% DESCRIPTION = Element.GETPROPDESCRIPTION(TAG) returns the
			%  description of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DESCRIPTION = NNCV.GETPROPDESCRIPTION(POINTER) returns description of POINTER of NNCV.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoderMLP_CV, POINTER) returns description of POINTER of NNVariationalAutoencoderMLP_CV.
			%  DESCRIPTION = NNCV.GETPROPDESCRIPTION(NNVariationalAutoencoderMLP_CV, POINTER) returns description of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNCV) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencodermlp_cv_description_list = { 'ELCLASS (constant, string) is the class of the cross-validation for MLP variational autoencoders.'  'NAME (constant, string) is the name of the cross-validation for MLP variational autoencoders.'  'DESCRIPTION (constant, string) is the description of the cross-validation for MLP variational autoencoders.'  'TEMPLATE (parameter, item) is the template of the cross-validation for MLP variational autoencoders.'  'ID (data, string) is a few-letter code for the cross-validation for MLP variational autoencoders.'  'LABEL (metadata, string) is an extended label of the cross-validation for MLP variational autoencoders.'  'NOTES (metadata, string) are some specific notes about the cross-validation for MLP variational autoencoders.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'WAITBAR (gui, logical) detemines whether to show the waitbar.'  'KFOLDS (data, scalar) is the number of folds (at least 2).'  'SPLIT (data, cell) is a cell (one row per dataset in D, one column per fold) with the indices of the data points in each fold. If empty, it is filled in with FOLD_ASSIGNMENT when D is set.'  'D (data, itemlist) is the datasets from groups to be cross-validated.'  'NN_TEMPLATE (parameter, item) is an optional variational autoencoder template; if set, its NEURONS_PER_LAYER, NUM_LATENT_REP and LEARN_RATE are used instead of those of the cross-validation.'  'NNEVALUATOR_TEMPLATE (parameter, item) is the neural network evaluator template to set all evalutor parameters.'  'DSP (result, itemlist) is a list of dataset splitter that splits the dataset per group.'  'DCO (result, itemlist) is a list of dataset combiners that combines the datasets per fold.'  'D_LIST (result, itemlist) contains the validation dataset of each of the k folds (the data points of that fold from all datasets in D).'  'D_LIST_IT (query, item) returns a dataset at a specified index in the itemlist of splitted neural network datasets.'  'NN_LIST (result, itemlist) contains the variational autoencoders of the k folds, each trained (by TRAIN) on all folds except its own.'  'NN_LIST_IT (query, item) returns a neural networks model at a specified index in the itemlist of splitted neural network datasets.'  'EVALUATOR_LIST (result, itemlist) contains the evaluators corresponding to the k folds.'  'EVALUATOR_LIST_IT (query, item) returns a neural networks evaluator at a specified index in the itemlist of splitted neural network datasets.'  'EPOCHS (parameter, scalar) is the maximum number of epochs each fold is trained for (the budget within which the epoch is selected).'  'BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SHUFFLE (parameter, option) is an option for data shuffling.'  'SOLVER (parameter, option) is an option for the solver.'  'VERBOSE (gui, logical) is an indicator to display training progress information.'  'PLOT_TRAINING (metadata, option) determines whether to show the training and validation loss of each fold while training (the fold being trained is always printed in the command window).'  'TRAIN (query, empty) runs the cross-validation: trains all fold models, records their losses (LOSS_CV) and selects the number of epochs (SELECTED_EPOCH).'  'NEURONS_PER_LAYER (parameter, rvector) are the hidden-layer widths of the MLP encoder (mirrored in the decoder), used when NN_TEMPLATE is not set.'  'NUM_LATENT_REP (parameter, scalar) is the number of latent dimensions, used when NN_TEMPLATE is not set.'  'LEARN_RATE (parameter, scalar) is the learning rate of the Adam optimiser, used when NN_TEMPLATE is not set.'  'FOLD_RULE (parameter, option) is how data points are assigned to folds: all spectra of the same plant replicate in the same fold (no leakage), or each spectrum independently at random.'  'GROUP_ROWS (parameter, rvector) are the rows of TARGET_CLASS joined to identify a plant replicate (for Raman spectra: 1 species, 2 stress, 3 location, 4 plant ID); rows that a data point does not have are ignored.'  'FOLD_ASSIGNMENT (query, cell) returns, for a dataset, a 1 x KFOLDS cell with the (sorted) indices of the data points in each fold, following FOLD_RULE.'  'EARLY_STOP_RULE (parameter, option) is the rule used to select the number of epochs on the pooled (fold-averaged) loss curves.'  'RATE_THRESHOLD (parameter, scalar) is the plateau criterion: the validation loss is considered flat when its smoothed relative improvement per epoch stays below this value (0.001 = 0.1% per epoch).'  'GAP_THRESHOLD (parameter, scalar) is the overfitting criterion: overfitting starts when the validation-minus-training gap grows above its lowest value so far by more than this fraction of the (median) training loss (0.02 = 2%).'  'PATIENCE (parameter, scalar) is the number of consecutive epochs a criterion must hold before it fires (10 in the manuscript); 0 means automatic, max(10, round(0.02 * EPOCHS)).'  'SMOOTH_WINDOW (parameter, scalar) is the moving-average window (in epochs) applied to the loss curves before detection (15 in the manuscript); it is also the warm-up before the overfitting check starts. 0 means automatic, max(10, round(0.03 * EPOCHS)).'  'EARLY_STOP_PARAMS (query, rvector) returns the early-stopping parameters actually used: [SMOOTH_WINDOW RATE_THRESHOLD PATIENCE GAP_THRESHOLD WARMUP], with the automatic values resolved.'  'DETECT_PLATEAU (query, scalar) returns the plateau-onset epoch of a loss curve, or the last epoch if the curve never plateaus.'  'DETECT_OVERFITTING (query, scalar) returns the overfitting-onset epoch from a training and a validation loss curve, or 0 if no overfitting is detected.'  'SILHOUETTE_CHECK (parameter, logical) determines whether, at every epoch, the separation of the labels in the latent space of each fold model is scored with the silhouette.'  'SILHOUETTE_GROUP_ROW (parameter, scalar) is the row of TARGET_CLASS whose groups are scored separately (for Raman spectra: 1 species); 0 scores all spectra together.'  'SILHOUETTE_LABEL_ROW (parameter, scalar) is the row of TARGET_CLASS with the labels whose separation is scored (for Raman spectra: 2 stress).'  'SILHOUETTE_DISTANCE (parameter, option) is the distance used by the silhouette (sqEuclidean is the default of MATLAB silhouette, used in train_vae.m).'  'SILHOUETTE_CHECKPOINTS (parameter, rvector) are the epochs reported in the separability table of EXPORT_RESULTS, together with SELECTED_EPOCH (epochs beyond EPOCHS are ignored).'  'DIRECTORY_FIG (metadata, string) is the directory where the figures (PLOT_LOSS, PLOT_EPOCH_SELECTION) and the tables (EXPORT_RESULTS) are saved; if empty, the figures are only shown.'  'FILE_PREFIX (metadata, string) is the beginning of the names of the saved figures and tables.'  'SILHOUETTE (query, scalar) returns the mean silhouette of points with given labels, from -1 (mixed) to 1 (well-separated clusters).'  'BUILD_NETWORKS (query, cell) returns {ENCODER, DECODER}, freshly initialised dlnetworks with the same MLP architecture as NNVariationalAutoencoderMLP for a given variational autoencoder.'  'LOSS_CV (result, cell) trains the variational autoencoder of each fold and returns {TRAIN_LOSS, VAL_LOSS, SILHOUETTE, GROUPS}: two EPOCHS x KFOLDS matrices with the mean loss (negative ELBO) per epoch, an EPOCHS x KFOLDS x number-of-groups array with the silhouette of the labels of each group in the latent space of each fold model (all spectra encoded), and the names of the groups.'  'PLATEAU_EPOCH_FOLDS (result, rvector) is the plateau-onset epoch of the validation loss of each fold (a consistency check; it does not decide SELECTED_EPOCH).'  'OVERFIT_EPOCH_FOLDS (result, rvector) is the overfitting-onset epoch of each fold, 0 where no overfitting is detected (a consistency check; it does not decide SELECTED_EPOCH).'  'PLATEAU_EPOCH (result, scalar) is the plateau-onset epoch of the pooled (fold-averaged) validation loss, 0 before the cross-validation is run.'  'OVERFIT_EPOCH (result, scalar) is the overfitting-onset epoch of the pooled (fold-averaged) curves, 0 if no overfitting is detected.'  'SELECTED_EPOCH (result, scalar) is the number of epochs selected by EARLY_STOP_RULE on the pooled curves, to be used to train the final model on the whole dataset (0 if there is no data).'  'SILHOUETTE_BEST_EPOCH (result, scalar) is the epoch with the best latent separation: the maximum of the smoothed silhouette, averaged over groups and folds (0 if the silhouette is not scored).'  'PLOT_LOSS (query, empty) plots the training and validation losses of all folds and of the pooled curve, with the plateau, overfitting and selected epochs; an optional file name exports the figure.'  'PLOT_EPOCH_SELECTION (query, empty) plots why SELECTED_EPOCH was chosen: the validation loss has plateaued, the overfitting has not started, and how the latent separation (silhouette) evolves; an optional file name exports the figure.'  'EXPORT_RESULTS (query, empty) writes the cross-validation tables (the same CSV files as train_vae.m) and figures to a directory.' };
			prop_description = nnvariationalautoencodermlp_cv_description_list{prop};
		end
		function prop_settings = getPropSettings(pointer)
			%GETPROPSETTINGS returns the settings of a property.
			%
			% SETTINGS = Element.GETPROPSETTINGS(PROP) returns the
			%  settings of the property PROP.
			%
			% SETTINGS = Element.GETPROPSETTINGS(TAG) returns the
			%  settings of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  SETTINGS = NNCV.GETPROPSETTINGS(POINTER) returns settings of POINTER of NNCV.
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoderMLP_CV, POINTER) returns settings of POINTER of NNVariationalAutoencoderMLP_CV.
			%  SETTINGS = NNCV.GETPROPSETTINGS(NNVariationalAutoencoderMLP_CV, POINTER) returns settings of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPSETTINGS(NNCV) and Element.GETPROPSETTINGS('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 30 % NNVariationalAutoencoderMLP_CV.NEURONS_PER_LAYER
					prop_settings = Format.getFormatSettings(12);
				case 31 % NNVariationalAutoencoderMLP_CV.NUM_LATENT_REP
					prop_settings = Format.getFormatSettings(11);
				case 32 % NNVariationalAutoencoderMLP_CV.LEARN_RATE
					prop_settings = Format.getFormatSettings(11);
				case 33 % NNVariationalAutoencoderMLP_CV.FOLD_RULE
					prop_settings = {'Grouped by replicate' 'Random per spectrum'};
				case 34 % NNVariationalAutoencoderMLP_CV.GROUP_ROWS
					prop_settings = Format.getFormatSettings(12);
				case 35 % NNVariationalAutoencoderMLP_CV.FOLD_ASSIGNMENT
					prop_settings = Format.getFormatSettings(16);
				case 36 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_RULE
					prop_settings = {'Plateau or overfitting onset (first to occur)' 'Plateau onset only' 'Overfitting onset only' 'No early stopping'};
				case 37 % NNVariationalAutoencoderMLP_CV.RATE_THRESHOLD
					prop_settings = Format.getFormatSettings(11);
				case 38 % NNVariationalAutoencoderMLP_CV.GAP_THRESHOLD
					prop_settings = Format.getFormatSettings(11);
				case 39 % NNVariationalAutoencoderMLP_CV.PATIENCE
					prop_settings = Format.getFormatSettings(11);
				case 40 % NNVariationalAutoencoderMLP_CV.SMOOTH_WINDOW
					prop_settings = Format.getFormatSettings(11);
				case 41 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_PARAMS
					prop_settings = Format.getFormatSettings(12);
				case 42 % NNVariationalAutoencoderMLP_CV.DETECT_PLATEAU
					prop_settings = Format.getFormatSettings(11);
				case 43 % NNVariationalAutoencoderMLP_CV.DETECT_OVERFITTING
					prop_settings = Format.getFormatSettings(11);
				case 44 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECK
					prop_settings = Format.getFormatSettings(4);
				case 45 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_GROUP_ROW
					prop_settings = Format.getFormatSettings(11);
				case 46 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_LABEL_ROW
					prop_settings = Format.getFormatSettings(11);
				case 47 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_DISTANCE
					prop_settings = {'sqEuclidean' 'Euclidean'};
				case 48 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECKPOINTS
					prop_settings = Format.getFormatSettings(12);
				case 49 % NNVariationalAutoencoderMLP_CV.DIRECTORY_FIG
					prop_settings = Format.getFormatSettings(2);
				case 50 % NNVariationalAutoencoderMLP_CV.FILE_PREFIX
					prop_settings = Format.getFormatSettings(2);
				case 51 % NNVariationalAutoencoderMLP_CV.SILHOUETTE
					prop_settings = Format.getFormatSettings(11);
				case 52 % NNVariationalAutoencoderMLP_CV.BUILD_NETWORKS
					prop_settings = Format.getFormatSettings(16);
				case 53 % NNVariationalAutoencoderMLP_CV.LOSS_CV
					prop_settings = Format.getFormatSettings(16);
				case 54 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH_FOLDS
					prop_settings = Format.getFormatSettings(12);
				case 55 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH_FOLDS
					prop_settings = Format.getFormatSettings(12);
				case 56 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH
					prop_settings = Format.getFormatSettings(11);
				case 57 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH
					prop_settings = Format.getFormatSettings(11);
				case 58 % NNVariationalAutoencoderMLP_CV.SELECTED_EPOCH
					prop_settings = Format.getFormatSettings(11);
				case 59 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_BEST_EPOCH
					prop_settings = Format.getFormatSettings(11);
				case 60 % NNVariationalAutoencoderMLP_CV.PLOT_LOSS
					prop_settings = Format.getFormatSettings(1);
				case 61 % NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION
					prop_settings = Format.getFormatSettings(1);
				case 62 % NNVariationalAutoencoderMLP_CV.EXPORT_RESULTS
					prop_settings = Format.getFormatSettings(1);
				case 4 % NNVariationalAutoencoderMLP_CV.TEMPLATE
					prop_settings = 'NNVariationalAutoencoderMLP_CV';
				case 13 % NNVariationalAutoencoderMLP_CV.NN_TEMPLATE
					prop_settings = 'NNVariationalAutoencoderMLP';
				case 28 % NNVariationalAutoencoderMLP_CV.PLOT_TRAINING
					prop_settings = {'none' 'training-progress'};
				otherwise
					prop_settings = getPropSettings@NNCrossValidation(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderMLP_CV.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderMLP_CV.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNCV.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNCV.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoderMLP_CV, POINTER) returns the default value of POINTER of NNVariationalAutoencoderMLP_CV.
			%  DEFAULT = NNCV.GETPROPDEFAULT(NNVariationalAutoencoderMLP_CV, POINTER) returns the default value of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPDEFAULT(NNCV) and Element.GETPROPDEFAULT('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 30 % NNVariationalAutoencoderMLP_CV.NEURONS_PER_LAYER
					prop_default = [64];
				case 31 % NNVariationalAutoencoderMLP_CV.NUM_LATENT_REP
					prop_default = 2;
				case 32 % NNVariationalAutoencoderMLP_CV.LEARN_RATE
					prop_default = 1e-3;
				case 33 % NNVariationalAutoencoderMLP_CV.FOLD_RULE
					prop_default = 'Grouped by replicate';
				case 34 % NNVariationalAutoencoderMLP_CV.GROUP_ROWS
					prop_default = [1 2 3 4];
				case 35 % NNVariationalAutoencoderMLP_CV.FOLD_ASSIGNMENT
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 36 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_RULE
					prop_default = 'Plateau or overfitting onset (first to occur)';
				case 37 % NNVariationalAutoencoderMLP_CV.RATE_THRESHOLD
					prop_default = 0.001;
				case 38 % NNVariationalAutoencoderMLP_CV.GAP_THRESHOLD
					prop_default = 0.02;
				case 39 % NNVariationalAutoencoderMLP_CV.PATIENCE
					prop_default = 10;
				case 40 % NNVariationalAutoencoderMLP_CV.SMOOTH_WINDOW
					prop_default = 15;
				case 41 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_PARAMS
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 42 % NNVariationalAutoencoderMLP_CV.DETECT_PLATEAU
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 43 % NNVariationalAutoencoderMLP_CV.DETECT_OVERFITTING
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 44 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECK
					prop_default = true;
				case 45 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_GROUP_ROW
					prop_default = 1;
				case 46 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_LABEL_ROW
					prop_default = 2;
				case 47 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_DISTANCE
					prop_default = 'sqEuclidean';
				case 48 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECKPOINTS
					prop_default = [50 100 250 500];
				case 49 % NNVariationalAutoencoderMLP_CV.DIRECTORY_FIG
					prop_default = '';
				case 50 % NNVariationalAutoencoderMLP_CV.FILE_PREFIX
					prop_default = 'vae_cv';
				case 51 % NNVariationalAutoencoderMLP_CV.SILHOUETTE
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 52 % NNVariationalAutoencoderMLP_CV.BUILD_NETWORKS
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 53 % NNVariationalAutoencoderMLP_CV.LOSS_CV
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 54 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH_FOLDS
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 55 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH_FOLDS
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 56 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 57 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 58 % NNVariationalAutoencoderMLP_CV.SELECTED_EPOCH
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 59 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_BEST_EPOCH
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 60 % NNVariationalAutoencoderMLP_CV.PLOT_LOSS
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 61 % NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 62 % NNVariationalAutoencoderMLP_CV.EXPORT_RESULTS
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 1 % NNVariationalAutoencoderMLP_CV.ELCLASS
					prop_default = 'NNVariationalAutoencoderMLP_CV';
				case 2 % NNVariationalAutoencoderMLP_CV.NAME
					prop_default = 'Neural Network Cross-Validation for Multilayer-Perceptron Variational Autoencoders';
				case 3 % NNVariationalAutoencoderMLP_CV.DESCRIPTION
					prop_default = 'A cross-validation for multilayer-perceptron variational autoencoders (NNVariationalAutoencoderMLP_CV) decides how many epochs a variational autoencoder (NNVariationalAutoencoderMLP) should be trained for. The dataset is split into KFOLDS folds; by default all spectra from the same plant replicate are put in the same fold, so no fold is validated on a leaf that was also used for training. For each fold, a variational autoencoder is trained on the other folds and its training and validation losses are recorded at every epoch. The fold curves are averaged and the epoch is selected on the pooled curve with the early-stopping rule EARLY_STOP_RULE (plateau onset of the validation loss and/or onset of overfitting, i.e., a sustained growth of the gap between validation and training loss). The final model is then trained on the whole dataset for SELECTED_EPOCH epochs.';
				case 4 % NNVariationalAutoencoderMLP_CV.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 5 % NNVariationalAutoencoderMLP_CV.ID
					prop_default = 'NNVariationalAutoencoderMLP_CV ID';
				case 6 % NNVariationalAutoencoderMLP_CV.LABEL
					prop_default = 'NNVariationalAutoencoderMLP_CV label';
				case 7 % NNVariationalAutoencoderMLP_CV.NOTES
					prop_default = 'NNVariationalAutoencoderMLP_CV notes';
				case 10 % NNVariationalAutoencoderMLP_CV.KFOLDS
					prop_default = 5;
				case 13 % NNVariationalAutoencoderMLP_CV.NN_TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 23 % NNVariationalAutoencoderMLP_CV.EPOCHS
					prop_default = 500;
				case 24 % NNVariationalAutoencoderMLP_CV.BATCH
					prop_default = 40;
				case 28 % NNVariationalAutoencoderMLP_CV.PLOT_TRAINING
					prop_default = 'none';
				otherwise
					prop_default = getPropDefault@NNCrossValidation(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderMLP_CV.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderMLP_CV.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNCV.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNCV.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderMLP_CV, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderMLP_CV.
			%  DEFAULT = NNCV.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderMLP_CV, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderMLP_CV.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNCV) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoderMLP_CV.conditioning(prop, NNVariationalAutoencoderMLP_CV.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = NNCV.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = NNCV.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of NNCV.
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoderMLP_CV, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderMLP_CV.
			%  CHECK = NNCV.CHECKPROP(NNVariationalAutoencoderMLP_CV, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderMLP_CV.
			% 
			% NNCV.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNCV.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNCV.
			%   Error id: BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoderMLP_CV, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderMLP_CV.
			%   Error id: BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput
			%  NNCV.CHECKPROP(NNVariationalAutoencoderMLP_CV, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderMLP_CV.
			%   Error id: BRAPH2:NNVariationalAutoencoderMLP_CV:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNCV) and Element.CHECKPROP('NNVariationalAutoencoderMLP_CV')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoderMLP_CV.getPropProp(pointer);
			
			switch prop
				case 30 % NNVariationalAutoencoderMLP_CV.NEURONS_PER_LAYER
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 31 % NNVariationalAutoencoderMLP_CV.NUM_LATENT_REP
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 32 % NNVariationalAutoencoderMLP_CV.LEARN_RATE
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 33 % NNVariationalAutoencoderMLP_CV.FOLD_RULE
					check = Format.checkFormat(5, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 34 % NNVariationalAutoencoderMLP_CV.GROUP_ROWS
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 35 % NNVariationalAutoencoderMLP_CV.FOLD_ASSIGNMENT
					check = Format.checkFormat(16, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 36 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_RULE
					check = Format.checkFormat(5, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 37 % NNVariationalAutoencoderMLP_CV.RATE_THRESHOLD
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 38 % NNVariationalAutoencoderMLP_CV.GAP_THRESHOLD
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 39 % NNVariationalAutoencoderMLP_CV.PATIENCE
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 40 % NNVariationalAutoencoderMLP_CV.SMOOTH_WINDOW
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 41 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_PARAMS
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 42 % NNVariationalAutoencoderMLP_CV.DETECT_PLATEAU
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 43 % NNVariationalAutoencoderMLP_CV.DETECT_OVERFITTING
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 44 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECK
					check = Format.checkFormat(4, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 45 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_GROUP_ROW
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 46 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_LABEL_ROW
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 47 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_DISTANCE
					check = Format.checkFormat(5, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 48 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECKPOINTS
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 49 % NNVariationalAutoencoderMLP_CV.DIRECTORY_FIG
					check = Format.checkFormat(2, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 50 % NNVariationalAutoencoderMLP_CV.FILE_PREFIX
					check = Format.checkFormat(2, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 51 % NNVariationalAutoencoderMLP_CV.SILHOUETTE
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 52 % NNVariationalAutoencoderMLP_CV.BUILD_NETWORKS
					check = Format.checkFormat(16, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 53 % NNVariationalAutoencoderMLP_CV.LOSS_CV
					check = Format.checkFormat(16, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 54 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH_FOLDS
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 55 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH_FOLDS
					check = Format.checkFormat(12, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 56 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 57 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 58 % NNVariationalAutoencoderMLP_CV.SELECTED_EPOCH
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 59 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_BEST_EPOCH
					check = Format.checkFormat(11, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 60 % NNVariationalAutoencoderMLP_CV.PLOT_LOSS
					check = Format.checkFormat(1, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 61 % NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION
					check = Format.checkFormat(1, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 62 % NNVariationalAutoencoderMLP_CV.EXPORT_RESULTS
					check = Format.checkFormat(1, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 4 % NNVariationalAutoencoderMLP_CV.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 13 % NNVariationalAutoencoderMLP_CV.NN_TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				case 28 % NNVariationalAutoencoderMLP_CV.PLOT_TRAINING
					check = Format.checkFormat(5, value, NNVariationalAutoencoderMLP_CV.getPropSettings(prop));
				otherwise
					if prop <= 29
						check = checkProp@NNCrossValidation(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoderMLP_CV.getPropTag(prop) ' (' NNVariationalAutoencoderMLP_CV.getFormatTag(NNVariationalAutoencoderMLP_CV.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
	methods (Access=protected) % postprocessing
		function postprocessing(nncv, prop)
			%POSTPROCESSING postprocessesing after setting.
			%
			% POSTPROCESSING(EL, PROP) postprocessesing of PROP after setting. By
			%  default, this function does not do anything, so it should be implemented
			%  in the subclasses of Element when needed.
			%
			% The postprocessing of all properties occurs each time set is called.
			%
			% See also conditioning, preset, checkProp, postset, calculateValue,
			%  checkValue.
			
			switch prop
				case 11 % NNVariationalAutoencoderMLP_CV.SPLIT
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
					
				otherwise
					if prop <= 29
						postprocessing@NNCrossValidation(nncv, prop);
					end
			end
		end
	end
	methods (Access=protected) % calculate value
		function value = calculateValue(nncv, prop, varargin)
			%CALCULATEVALUE calculates the value of a property.
			%
			% VALUE = CALCULATEVALUE(EL, PROP) calculates the value of the property
			%  PROP. It works only with properties with 5,
			%  6, and 7. By default this function
			%  returns the default value for the prop and should be implemented in the
			%  subclasses of Element when needed.
			%
			% VALUE = CALCULATEVALUE(EL, PROP, VARARGIN) works with properties with
			%  6.
			%
			% See also getPropDefaultConditioned, conditioning, preset, checkProp,
			%  postset, postprocessing, checkValue.
			
			switch prop
				case 35 % NNVariationalAutoencoderMLP_CV.FOLD_ASSIGNMENT
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
					                ['BRAPH2' ':NNVariationalAutoencoderMLP_CV'], ...
					                ['BRAPH2' ':NNVariationalAutoencoderMLP_CV\n' ...
					                'There are only ' int2str(num_groups) ' replicate groups for ' int2str(kfolds) ' folds, so some folds will be empty.\n' ...
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
					
				case 41 % NNVariationalAutoencoderMLP_CV.EARLY_STOP_PARAMS
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
					
				case 42 % NNVariationalAutoencoderMLP_CV.DETECT_PLATEAU
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
					
				case 43 % NNVariationalAutoencoderMLP_CV.DETECT_OVERFITTING
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
					
				case 51 % NNVariationalAutoencoderMLP_CV.SILHOUETTE
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
					
				case 52 % NNVariationalAutoencoderMLP_CV.BUILD_NETWORKS
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
					
				case 53 % NNVariationalAutoencoderMLP_CV.LOSS_CV
					rng_settings_ = rng(); rng(nncv.getPropSeed(53), 'twister')
					
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
					        ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
					        ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
					        'At least one fold is empty (data points per fold: ' mat2str(fold_sizes) ').\n' ...
					        'Use fewer folds (KFOLDS): there must be at least as many replicate groups as folds.'] ...
					        )
					end
					if any(sum(fold_sizes) - fold_sizes < batch)
					    error( ...
					        ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
					        ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
					        'At least one training set is smaller than the batch size (' int2str(batch) ').\n' ...
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
					
					rng(rng_settings_)
					
				case 54 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH_FOLDS
					rng_settings_ = rng(); rng(nncv.getPropSeed(54), 'twister')
					
					loss_cv = nncv.memorize('LOSS_CV');
					if isempty(loss_cv)
					    value = [];
					    return
					end
					p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
					val_loss = loss_cv{2};
					value = arrayfun(@(k) nncv.get('DETECT_PLATEAU', val_loss(:, k), p(1), p(2), p(3)), 1:size(val_loss, 2));
					
					rng(rng_settings_)
					
				case 55 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH_FOLDS
					rng_settings_ = rng(); rng(nncv.getPropSeed(55), 'twister')
					
					loss_cv = nncv.memorize('LOSS_CV');
					if isempty(loss_cv)
					    value = [];
					    return
					end
					p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
					train_loss = loss_cv{1};
					val_loss = loss_cv{2};
					value = arrayfun(@(k) nncv.get('DETECT_OVERFITTING', train_loss(:, k), val_loss(:, k), p(5), p(1), p(4), p(3)), 1:size(val_loss, 2));
					
					rng(rng_settings_)
					
				case 56 % NNVariationalAutoencoderMLP_CV.PLATEAU_EPOCH
					rng_settings_ = rng(); rng(nncv.getPropSeed(56), 'twister')
					
					loss_cv = nncv.memorize('LOSS_CV');
					if isempty(loss_cv)
					    value = 0;
					    return
					end
					p = nncv.get('EARLY_STOP_PARAMS');
					value = nncv.get('DETECT_PLATEAU', mean(loss_cv{2}, 2), p(1), p(2), p(3));
					
					rng(rng_settings_)
					
				case 57 % NNVariationalAutoencoderMLP_CV.OVERFIT_EPOCH
					rng_settings_ = rng(); rng(nncv.getPropSeed(57), 'twister')
					
					loss_cv = nncv.memorize('LOSS_CV');
					if isempty(loss_cv)
					    value = 0;
					    return
					end
					p = nncv.get('EARLY_STOP_PARAMS');
					value = nncv.get('DETECT_OVERFITTING', mean(loss_cv{1}, 2), mean(loss_cv{2}, 2), p(5), p(1), p(4), p(3));
					
					rng(rng_settings_)
					
				case 58 % NNVariationalAutoencoderMLP_CV.SELECTED_EPOCH
					rng_settings_ = rng(); rng(nncv.getPropSeed(58), 'twister')
					
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
					
					rng(rng_settings_)
					
				case 59 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_BEST_EPOCH
					rng_settings_ = rng(); rng(nncv.getPropSeed(59), 'twister')
					
					loss_cv = nncv.memorize('LOSS_CV');
					if numel(loss_cv) < 4 || isempty(loss_cv{4})
					    value = 0;
					    return
					end
					p = nncv.get('EARLY_STOP_PARAMS'); % [smooth_window rate_threshold patience gap_threshold warmup]
					sil_curve = mean(mean(loss_cv{3}, 3), 2); % mean over groups, then over folds
					[~, value] = max(movmean(sil_curve, p(1)));
					
					rng(rng_settings_)
					
				case 60 % NNVariationalAutoencoderMLP_CV.PLOT_LOSS
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
					
				case 61 % NNVariationalAutoencoderMLP_CV.PLOT_EPOCH_SELECTION
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
					
				case 62 % NNVariationalAutoencoderMLP_CV.EXPORT_RESULTS
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
					
				case 17 % NNVariationalAutoencoderMLP_CV.D_LIST
					rng_settings_ = rng(); rng(nncv.getPropSeed(17), 'twister')
					
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
					
					rng(rng_settings_)
					
				case 19 % NNVariationalAutoencoderMLP_CV.NN_LIST
					rng_settings_ = rng(); rng(nncv.getPropSeed(19), 'twister')
					
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
					
					rng(rng_settings_)
					
				case 29 % NNVariationalAutoencoderMLP_CV.TRAIN
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
					
				otherwise
					if prop <= 29
						value = calculateValue@NNCrossValidation(nncv, prop, varargin{:});
					else
						value = calculateValue@Element(nncv, prop, varargin{:});
					end
			end
			
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
			                    ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput'], ...
			                    ['BRAPH2' ':NNVariationalAutoencoderMLP_CV:' 'WrongInput' '\n' ...
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
		end
	end
	methods (Access=protected) % check value
		function [check, msg] = checkValue(nncv, prop, value)
			%CHECKVALUE checks the value of a property after it is set/calculated.
			%
			% [CHECK, MSG] = CHECKVALUE(EL, PROP, VALUE) checks the value
			%  of the property PROP after it is set/calculated. This function by
			%  default returns a CHECK = true and MSG = '. It should be implemented in
			%  the subclasses of Element when needed.
			%
			% See also conditioning, preset, checkProp, postset, postprocessing,
			%  calculateValue.
			
			check = true;
			msg = ['Error while checking ' tostring(nncv) ' ' nncv.getPropTag(prop) '.'];
			
			switch prop
				case 34 % NNVariationalAutoencoderMLP_CV.GROUP_ROWS
					check = all(value >= 1) && all(round(value) == value);
					
				case 37 % NNVariationalAutoencoderMLP_CV.RATE_THRESHOLD
					check = isscalar(value) && value >= 0;
					
				case 38 % NNVariationalAutoencoderMLP_CV.GAP_THRESHOLD
					check = isscalar(value) && value >= 0;
					
				case 39 % NNVariationalAutoencoderMLP_CV.PATIENCE
					check = isscalar(value) && value >= 0 && round(value) == value;
					
				case 40 % NNVariationalAutoencoderMLP_CV.SMOOTH_WINDOW
					check = isscalar(value) && value >= 0 && round(value) == value;
					
				case 45 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_GROUP_ROW
					check = isscalar(value) && value >= 0 && round(value) == value;
					
				case 46 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_LABEL_ROW
					check = isscalar(value) && value >= 1 && round(value) == value;
					
				case 48 % NNVariationalAutoencoderMLP_CV.SILHOUETTE_CHECKPOINTS
					check = all(value >= 1) && all(round(value) == value);
					
				case 10 % NNVariationalAutoencoderMLP_CV.KFOLDS
					check = isscalar(value) && value >= 2 && round(value) == value;
					
				otherwise
					if prop <= 29
						[check, msg] = checkValue@NNCrossValidation(nncv, prop, value);
					end
			end
		end
	end
end
