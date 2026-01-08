classdef NNVariationalAutoencoderEvaluator_RS < NNVariationalAutoencoderEvaluator
	%NNVariationalAutoencoderEvaluator_RS evaluates a trained variational autoencoder with a dataset.
	% It is a subclass of <a href="matlab:help NNVariationalAutoencoderEvaluator">NNVariationalAutoencoderEvaluator</a>.
	%
	% A variational-autoencoder evaluator (NNVariationalAutoencoderEvaluator_RS) evaluates a trained varitional autoencoder on a specific dataset, 
	%  producing latent representations, decoded spectra, peak analyses, and Docker-backed R figures for Raman-spectra workflows.
	%
	% The list of NNVariationalAutoencoderEvaluator_RS properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are specific notes of the variational-autoencoder evaluator for Raman spectra.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network model.
	%  <strong>10</strong> <strong>D</strong> 	D (data, item) is the dataset to evaluate the neural network model.
	%  <strong>11</strong> <strong>PLOT_LATENT_REPRESENTATIONS</strong> 	PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.
	%  <strong>12</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns {Z, Y} where Z are latent means (one column per data point) and Y are corresponding label vectors from D via the minibatch queue.
	%  <strong>13</strong> <strong>DPROC</strong> 	DPROC (data, item) is the Raman-spectra dataset process used for inverse normalisation/transform during decoding.
	%  <strong>14</strong> <strong>IDX_LABEL_STRESS</strong> 	IDX_LABEL_STRESS (parameter, scalar) is the row index in TARGET_CLASS corresponding to stress.
	%  <strong>15</strong> <strong>STRESS_ORDER</strong> 	STRESS_ORDER (query, stringlist) returns the unique stress tokens present in LATENT_REP in stable order.
	%  <strong>16</strong> <strong>STRESS_SEQ</strong> 	STRESS_SEQ (parameter, stringlist) is the canonical plotting order of stresses used for export and R figures.
	%  <strong>17</strong> <strong>STRESS_LABEL</strong> 	STRESS_LABEL (parameter, stringlist) are human-readable stress labels aligned with STRESS_SEQ.
	%  <strong>18</strong> <strong>STRESS_COLOUR</strong> 	STRESS_COLOUR (parameter, stringlist) are hex colours aligned with STRESS_SEQ.
	%  <strong>19</strong> <strong>STRESS_SHAPE</strong> 	STRESS_SHAPE (parameter, stringlist) are point shapes aligned with STRESS_SEQ.
	%  <strong>20</strong> <strong>IDX_LABEL_KIND</strong> 	IDX_LABEL_KIND (parameter, scalar) is the row index in TARGET_CLASS corresponding to species/kind.
	%  <strong>21</strong> <strong>KIND_ORDER</strong> 	KIND_ORDER (query, stringlist) returns the unique species/kind tokens present in LATENT_REP in stable order.
	%  <strong>22</strong> <strong>IDX_LABEL_LOCATION</strong> 	IDX_LABEL_LOCATION (parameter, scalar) is the row index in TARGET_CLASS corresponding to location.
	%  <strong>23</strong> <strong>LOCATION_ORDER</strong> 	LOCATION_ORDER (query, stringlist) returns the unique location tokens present in LATENT_REP in stable order.
	%  <strong>24</strong> <strong>LOCATION_ALIAS_FROM</strong> 	LOCATION_ALIAS_FROM (parameter, stringlist) lists source location labels to be replaced during export.
	%  <strong>25</strong> <strong>LOCATION_ALIAS_TO</strong> 	LOCATION_ALIAS_TO (parameter, stringlist) lists target location labels used to replace LOCATION_ALIAS_FROM; it must have the same length as LOCATION_ALIAS_FROM.
	%  <strong>26</strong> <strong>LATENT_REP</strong> 	LATENT_REP (result, cell) stores {Z, Y} where Z are latent representations and Y are label vectors aligned to Z for downstream analyses.
	%  <strong>27</strong> <strong>PREDICT_DECODER</strong> 	PREDICT_DECODER (query, empty) decodes selected latent vectors to spectra and returns a 1xN cell of column vectors (options: one-to-one/median/mean; inverse normalisation/transform toggles).
	%  <strong>28</strong> <strong>CROSSING</strong> 	CROSSING (query, cell) returns {ind, t0, s0} for level crossings of S at level with interpolation method and direction.
	%  <strong>29</strong> <strong>RESOLUTION_CM</strong> 	RESOLUTION_CM (parameter, scalar) is the instrument resolution in cm^-1 used to merge nearby peaks.
	%  <strong>30</strong> <strong>MERGE_CLOSE_PEAKS</strong> 	MERGE_CLOSE_PEAKS (query, matrix) merges ranked peaks closer than the instrument resolution in cm^-1.
	%  <strong>31</strong> <strong>DERIV_PEAKS</strong> 	DERIV_PEAKS (query, cell) returns {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ind_p2n, ind_all, area, peak_wavs} from p→n zero-crossings of the derivative spectrum.
	%  <strong>32</strong> <strong>PEAKS_COMPARE</strong> 	PEAKS_COMPARE (query, cell) returns pairwise peak-area differences between two conditions with integer-wavenumber matching tolerance.
	%  <strong>33</strong> <strong>DERIV_PEAKS_RUN</strong> 	DERIV_PEAKS_RUN (query, cell) returns {COND, COMP} by running DERIV_PEAKS per condition and all pairwise comparisons.
	%  <strong>34</strong> <strong>DERIV_PEAKS_SAVE</strong> 	DERIV_PEAKS_SAVE (query, cell) saves per-condition ranked tables and pairwise ranked differences using legacy-compatible filenames.
	%  <strong>35</strong> <strong>LATENT_IDENTIFICATION</strong> 	LATENT_IDENTIFICATION (query, empty) exports per-species×location latent cells z1/z2 and ranges aligned with STRESS_SEQ for the R plotting pipeline.
	%  <strong>36</strong> <strong>DATA_RECONSTRUCTION</strong> 	DATA_RECONSTRUCTION (query, empty) decodes median spectra per stress for each species×location and saves R-ready .mat files.
	%  <strong>37</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (query, empty) decodes per species, detects derivative peaks per stress, runs all pairwise comparisons, and saves ranked tables.
	%  <strong>38</strong> <strong>DIRECTORY_ANALYSIS</strong> 	DIRECTORY_ANALYSIS (data, string) is the directory where intermediate .mat files and analysis outputs are saved.
	%  <strong>39</strong> <strong>DIRECTORY_FIG</strong> 	DIRECTORY_FIG (data, string) is the directory where figures are exported.
	%  <strong>40</strong> <strong>DIRECTORY_UTIL_R</strong> 	DIRECTORY_UTIL_R (data, string) is the directory containing the R scripts and Dockerfile used for plotting.
	%  <strong>41</strong> <strong>CREATE_R_CONTAINER</strong> 	CREATE_R_CONTAINER (query, cell) ensures the plotting Docker image exists and returns {image_tag}.
	%  <strong>42</strong> <strong>PLOT_R_PALETTE</strong> 	PLOT_R_PALETTE (query, empty) generates palette figures via Docker+R (generic_fig_palette_p1.R) after preparing latent, reconstruction, and identification outputs.
	%  <strong>43</strong> <strong>PLOT_R_LS_QNORM_MED</strong> 	PLOT_R_LS_QNORM_MED (query, empty) plots latent-space qnorm (median) via Docker+R (generic_plot_ls_qnorm_med.R) after preparing required .mat inputs.
	%
	% NNVariationalAutoencoderEvaluator_RS methods (constructor):
	%  NNVariationalAutoencoderEvaluator_RS - constructor
	%
	% NNVariationalAutoencoderEvaluator_RS methods:
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
	% NNVariationalAutoencoderEvaluator_RS methods (display):
	%  tostring - string with information about the variational-autoencoder evaluator for Raman spectra
	%  disp - displays information about the variational-autoencoder evaluator for Raman spectra
	%  tree - displays the tree of the variational-autoencoder evaluator for Raman spectra
	%
	% NNVariationalAutoencoderEvaluator_RS methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two variational-autoencoder evaluator for Raman spectra are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the variational-autoencoder evaluator for Raman spectra
	%
	% NNVariationalAutoencoderEvaluator_RS methods (save/load, Static):
	%  save - saves BRAPH2 variational-autoencoder evaluator for Raman spectra as b2 file
	%  load - loads a BRAPH2 variational-autoencoder evaluator for Raman spectra from a b2 file
	%
	% NNVariationalAutoencoderEvaluator_RS method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the variational-autoencoder evaluator for Raman spectra
	%
	% NNVariationalAutoencoderEvaluator_RS method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the variational-autoencoder evaluator for Raman spectra
	%
	% NNVariationalAutoencoderEvaluator_RS methods (inspection, Static):
	%  getClass - returns the class of the variational-autoencoder evaluator for Raman spectra
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoderEvaluator_RS
	%  getProps - returns the property list of the variational-autoencoder evaluator for Raman spectra
	%  getPropNumber - returns the property number of the variational-autoencoder evaluator for Raman spectra
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
	% NNVariationalAutoencoderEvaluator_RS methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoderEvaluator_RS methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoderEvaluator_RS methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoderEvaluator_RS methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoderEvaluator_RS; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoderEvaluator_RS constants</a>.
	%
	%
	% See also NNDataPoint, NNDataset, NNBase, NNDatasetProcess_RamanSpectra.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		DPROC = 13; %CET: Computational Efficiency Trick
		DPROC_TAG = 'DPROC';
		DPROC_CATEGORY = 4;
		DPROC_FORMAT = 8;
		
		IDX_LABEL_STRESS = 14; %CET: Computational Efficiency Trick
		IDX_LABEL_STRESS_TAG = 'IDX_LABEL_STRESS';
		IDX_LABEL_STRESS_CATEGORY = 3;
		IDX_LABEL_STRESS_FORMAT = 11;
		
		STRESS_ORDER = 15; %CET: Computational Efficiency Trick
		STRESS_ORDER_TAG = 'STRESS_ORDER';
		STRESS_ORDER_CATEGORY = 6;
		STRESS_ORDER_FORMAT = 3;
		
		STRESS_SEQ = 16; %CET: Computational Efficiency Trick
		STRESS_SEQ_TAG = 'STRESS_SEQ';
		STRESS_SEQ_CATEGORY = 3;
		STRESS_SEQ_FORMAT = 3;
		
		STRESS_LABEL = 17; %CET: Computational Efficiency Trick
		STRESS_LABEL_TAG = 'STRESS_LABEL';
		STRESS_LABEL_CATEGORY = 3;
		STRESS_LABEL_FORMAT = 3;
		
		STRESS_COLOUR = 18; %CET: Computational Efficiency Trick
		STRESS_COLOUR_TAG = 'STRESS_COLOUR';
		STRESS_COLOUR_CATEGORY = 3;
		STRESS_COLOUR_FORMAT = 3;
		
		STRESS_SHAPE = 19; %CET: Computational Efficiency Trick
		STRESS_SHAPE_TAG = 'STRESS_SHAPE';
		STRESS_SHAPE_CATEGORY = 3;
		STRESS_SHAPE_FORMAT = 3;
		
		IDX_LABEL_KIND = 20; %CET: Computational Efficiency Trick
		IDX_LABEL_KIND_TAG = 'IDX_LABEL_KIND';
		IDX_LABEL_KIND_CATEGORY = 3;
		IDX_LABEL_KIND_FORMAT = 11;
		
		KIND_ORDER = 21; %CET: Computational Efficiency Trick
		KIND_ORDER_TAG = 'KIND_ORDER';
		KIND_ORDER_CATEGORY = 6;
		KIND_ORDER_FORMAT = 3;
		
		IDX_LABEL_LOCATION = 22; %CET: Computational Efficiency Trick
		IDX_LABEL_LOCATION_TAG = 'IDX_LABEL_LOCATION';
		IDX_LABEL_LOCATION_CATEGORY = 3;
		IDX_LABEL_LOCATION_FORMAT = 11;
		
		LOCATION_ORDER = 23; %CET: Computational Efficiency Trick
		LOCATION_ORDER_TAG = 'LOCATION_ORDER';
		LOCATION_ORDER_CATEGORY = 6;
		LOCATION_ORDER_FORMAT = 3;
		
		LOCATION_ALIAS_FROM = 24; %CET: Computational Efficiency Trick
		LOCATION_ALIAS_FROM_TAG = 'LOCATION_ALIAS_FROM';
		LOCATION_ALIAS_FROM_CATEGORY = 3;
		LOCATION_ALIAS_FROM_FORMAT = 3;
		
		LOCATION_ALIAS_TO = 25; %CET: Computational Efficiency Trick
		LOCATION_ALIAS_TO_TAG = 'LOCATION_ALIAS_TO';
		LOCATION_ALIAS_TO_CATEGORY = 3;
		LOCATION_ALIAS_TO_FORMAT = 3;
		
		LATENT_REP = 26; %CET: Computational Efficiency Trick
		LATENT_REP_TAG = 'LATENT_REP';
		LATENT_REP_CATEGORY = 5;
		LATENT_REP_FORMAT = 16;
		
		PREDICT_DECODER = 27; %CET: Computational Efficiency Trick
		PREDICT_DECODER_TAG = 'PREDICT_DECODER';
		PREDICT_DECODER_CATEGORY = 6;
		PREDICT_DECODER_FORMAT = 1;
		
		CROSSING = 28; %CET: Computational Efficiency Trick
		CROSSING_TAG = 'CROSSING';
		CROSSING_CATEGORY = 6;
		CROSSING_FORMAT = 16;
		
		RESOLUTION_CM = 29; %CET: Computational Efficiency Trick
		RESOLUTION_CM_TAG = 'RESOLUTION_CM';
		RESOLUTION_CM_CATEGORY = 3;
		RESOLUTION_CM_FORMAT = 11;
		
		MERGE_CLOSE_PEAKS = 30; %CET: Computational Efficiency Trick
		MERGE_CLOSE_PEAKS_TAG = 'MERGE_CLOSE_PEAKS';
		MERGE_CLOSE_PEAKS_CATEGORY = 6;
		MERGE_CLOSE_PEAKS_FORMAT = 14;
		
		DERIV_PEAKS = 31; %CET: Computational Efficiency Trick
		DERIV_PEAKS_TAG = 'DERIV_PEAKS';
		DERIV_PEAKS_CATEGORY = 6;
		DERIV_PEAKS_FORMAT = 16;
		
		PEAKS_COMPARE = 32; %CET: Computational Efficiency Trick
		PEAKS_COMPARE_TAG = 'PEAKS_COMPARE';
		PEAKS_COMPARE_CATEGORY = 6;
		PEAKS_COMPARE_FORMAT = 16;
		
		DERIV_PEAKS_RUN = 33; %CET: Computational Efficiency Trick
		DERIV_PEAKS_RUN_TAG = 'DERIV_PEAKS_RUN';
		DERIV_PEAKS_RUN_CATEGORY = 6;
		DERIV_PEAKS_RUN_FORMAT = 16;
		
		DERIV_PEAKS_SAVE = 34; %CET: Computational Efficiency Trick
		DERIV_PEAKS_SAVE_TAG = 'DERIV_PEAKS_SAVE';
		DERIV_PEAKS_SAVE_CATEGORY = 6;
		DERIV_PEAKS_SAVE_FORMAT = 16;
		
		LATENT_IDENTIFICATION = 35; %CET: Computational Efficiency Trick
		LATENT_IDENTIFICATION_TAG = 'LATENT_IDENTIFICATION';
		LATENT_IDENTIFICATION_CATEGORY = 6;
		LATENT_IDENTIFICATION_FORMAT = 1;
		
		DATA_RECONSTRUCTION = 36; %CET: Computational Efficiency Trick
		DATA_RECONSTRUCTION_TAG = 'DATA_RECONSTRUCTION';
		DATA_RECONSTRUCTION_CATEGORY = 6;
		DATA_RECONSTRUCTION_FORMAT = 1;
		
		PEAK_IDENTIFICATION = 37; %CET: Computational Efficiency Trick
		PEAK_IDENTIFICATION_TAG = 'PEAK_IDENTIFICATION';
		PEAK_IDENTIFICATION_CATEGORY = 6;
		PEAK_IDENTIFICATION_FORMAT = 1;
		
		DIRECTORY_ANALYSIS = 38; %CET: Computational Efficiency Trick
		DIRECTORY_ANALYSIS_TAG = 'DIRECTORY_ANALYSIS';
		DIRECTORY_ANALYSIS_CATEGORY = 4;
		DIRECTORY_ANALYSIS_FORMAT = 2;
		
		DIRECTORY_FIG = 39; %CET: Computational Efficiency Trick
		DIRECTORY_FIG_TAG = 'DIRECTORY_FIG';
		DIRECTORY_FIG_CATEGORY = 4;
		DIRECTORY_FIG_FORMAT = 2;
		
		DIRECTORY_UTIL_R = 40; %CET: Computational Efficiency Trick
		DIRECTORY_UTIL_R_TAG = 'DIRECTORY_UTIL_R';
		DIRECTORY_UTIL_R_CATEGORY = 4;
		DIRECTORY_UTIL_R_FORMAT = 2;
		
		CREATE_R_CONTAINER = 41; %CET: Computational Efficiency Trick
		CREATE_R_CONTAINER_TAG = 'CREATE_R_CONTAINER';
		CREATE_R_CONTAINER_CATEGORY = 6;
		CREATE_R_CONTAINER_FORMAT = 16;
		
		PLOT_R_PALETTE = 42; %CET: Computational Efficiency Trick
		PLOT_R_PALETTE_TAG = 'PLOT_R_PALETTE';
		PLOT_R_PALETTE_CATEGORY = 6;
		PLOT_R_PALETTE_FORMAT = 1;
		
		PLOT_R_LS_QNORM_MED = 43; %CET: Computational Efficiency Trick
		PLOT_R_LS_QNORM_MED_TAG = 'PLOT_R_LS_QNORM_MED';
		PLOT_R_LS_QNORM_MED_CATEGORY = 6;
		PLOT_R_LS_QNORM_MED_FORMAT = 1;
	end
	methods % constructor
		function nne = NNVariationalAutoencoderEvaluator_RS(varargin)
			%NNVariationalAutoencoderEvaluator_RS() creates a variational-autoencoder evaluator for Raman spectra.
			%
			% NNVariationalAutoencoderEvaluator_RS(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoderEvaluator_RS(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoderEvaluator_RS properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are specific notes of the variational-autoencoder evaluator for Raman spectra.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network model.
			%  <strong>10</strong> <strong>D</strong> 	D (data, item) is the dataset to evaluate the neural network model.
			%  <strong>11</strong> <strong>PLOT_LATENT_REPRESENTATIONS</strong> 	PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.
			%  <strong>12</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns {Z, Y} where Z are latent means (one column per data point) and Y are corresponding label vectors from D via the minibatch queue.
			%  <strong>13</strong> <strong>DPROC</strong> 	DPROC (data, item) is the Raman-spectra dataset process used for inverse normalisation/transform during decoding.
			%  <strong>14</strong> <strong>IDX_LABEL_STRESS</strong> 	IDX_LABEL_STRESS (parameter, scalar) is the row index in TARGET_CLASS corresponding to stress.
			%  <strong>15</strong> <strong>STRESS_ORDER</strong> 	STRESS_ORDER (query, stringlist) returns the unique stress tokens present in LATENT_REP in stable order.
			%  <strong>16</strong> <strong>STRESS_SEQ</strong> 	STRESS_SEQ (parameter, stringlist) is the canonical plotting order of stresses used for export and R figures.
			%  <strong>17</strong> <strong>STRESS_LABEL</strong> 	STRESS_LABEL (parameter, stringlist) are human-readable stress labels aligned with STRESS_SEQ.
			%  <strong>18</strong> <strong>STRESS_COLOUR</strong> 	STRESS_COLOUR (parameter, stringlist) are hex colours aligned with STRESS_SEQ.
			%  <strong>19</strong> <strong>STRESS_SHAPE</strong> 	STRESS_SHAPE (parameter, stringlist) are point shapes aligned with STRESS_SEQ.
			%  <strong>20</strong> <strong>IDX_LABEL_KIND</strong> 	IDX_LABEL_KIND (parameter, scalar) is the row index in TARGET_CLASS corresponding to species/kind.
			%  <strong>21</strong> <strong>KIND_ORDER</strong> 	KIND_ORDER (query, stringlist) returns the unique species/kind tokens present in LATENT_REP in stable order.
			%  <strong>22</strong> <strong>IDX_LABEL_LOCATION</strong> 	IDX_LABEL_LOCATION (parameter, scalar) is the row index in TARGET_CLASS corresponding to location.
			%  <strong>23</strong> <strong>LOCATION_ORDER</strong> 	LOCATION_ORDER (query, stringlist) returns the unique location tokens present in LATENT_REP in stable order.
			%  <strong>24</strong> <strong>LOCATION_ALIAS_FROM</strong> 	LOCATION_ALIAS_FROM (parameter, stringlist) lists source location labels to be replaced during export.
			%  <strong>25</strong> <strong>LOCATION_ALIAS_TO</strong> 	LOCATION_ALIAS_TO (parameter, stringlist) lists target location labels used to replace LOCATION_ALIAS_FROM; it must have the same length as LOCATION_ALIAS_FROM.
			%  <strong>26</strong> <strong>LATENT_REP</strong> 	LATENT_REP (result, cell) stores {Z, Y} where Z are latent representations and Y are label vectors aligned to Z for downstream analyses.
			%  <strong>27</strong> <strong>PREDICT_DECODER</strong> 	PREDICT_DECODER (query, empty) decodes selected latent vectors to spectra and returns a 1xN cell of column vectors (options: one-to-one/median/mean; inverse normalisation/transform toggles).
			%  <strong>28</strong> <strong>CROSSING</strong> 	CROSSING (query, cell) returns {ind, t0, s0} for level crossings of S at level with interpolation method and direction.
			%  <strong>29</strong> <strong>RESOLUTION_CM</strong> 	RESOLUTION_CM (parameter, scalar) is the instrument resolution in cm^-1 used to merge nearby peaks.
			%  <strong>30</strong> <strong>MERGE_CLOSE_PEAKS</strong> 	MERGE_CLOSE_PEAKS (query, matrix) merges ranked peaks closer than the instrument resolution in cm^-1.
			%  <strong>31</strong> <strong>DERIV_PEAKS</strong> 	DERIV_PEAKS (query, cell) returns {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ind_p2n, ind_all, area, peak_wavs} from p→n zero-crossings of the derivative spectrum.
			%  <strong>32</strong> <strong>PEAKS_COMPARE</strong> 	PEAKS_COMPARE (query, cell) returns pairwise peak-area differences between two conditions with integer-wavenumber matching tolerance.
			%  <strong>33</strong> <strong>DERIV_PEAKS_RUN</strong> 	DERIV_PEAKS_RUN (query, cell) returns {COND, COMP} by running DERIV_PEAKS per condition and all pairwise comparisons.
			%  <strong>34</strong> <strong>DERIV_PEAKS_SAVE</strong> 	DERIV_PEAKS_SAVE (query, cell) saves per-condition ranked tables and pairwise ranked differences using legacy-compatible filenames.
			%  <strong>35</strong> <strong>LATENT_IDENTIFICATION</strong> 	LATENT_IDENTIFICATION (query, empty) exports per-species×location latent cells z1/z2 and ranges aligned with STRESS_SEQ for the R plotting pipeline.
			%  <strong>36</strong> <strong>DATA_RECONSTRUCTION</strong> 	DATA_RECONSTRUCTION (query, empty) decodes median spectra per stress for each species×location and saves R-ready .mat files.
			%  <strong>37</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (query, empty) decodes per species, detects derivative peaks per stress, runs all pairwise comparisons, and saves ranked tables.
			%  <strong>38</strong> <strong>DIRECTORY_ANALYSIS</strong> 	DIRECTORY_ANALYSIS (data, string) is the directory where intermediate .mat files and analysis outputs are saved.
			%  <strong>39</strong> <strong>DIRECTORY_FIG</strong> 	DIRECTORY_FIG (data, string) is the directory where figures are exported.
			%  <strong>40</strong> <strong>DIRECTORY_UTIL_R</strong> 	DIRECTORY_UTIL_R (data, string) is the directory containing the R scripts and Dockerfile used for plotting.
			%  <strong>41</strong> <strong>CREATE_R_CONTAINER</strong> 	CREATE_R_CONTAINER (query, cell) ensures the plotting Docker image exists and returns {image_tag}.
			%  <strong>42</strong> <strong>PLOT_R_PALETTE</strong> 	PLOT_R_PALETTE (query, empty) generates palette figures via Docker+R (generic_fig_palette_p1.R) after preparing latent, reconstruction, and identification outputs.
			%  <strong>43</strong> <strong>PLOT_R_LS_QNORM_MED</strong> 	PLOT_R_LS_QNORM_MED (query, empty) plots latent-space qnorm (median) via Docker+R (generic_plot_ls_qnorm_med.R) after preparing required .mat inputs.
			%
			% See also Category, Format.
			
			nne = nne@NNVariationalAutoencoderEvaluator(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the variational-autoencoder evaluator for Raman spectra.
			%
			% BUILD = NNVariationalAutoencoderEvaluator_RS.GETBUILD() returns the build of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNE.GETBUILD() returns the build of the variational-autoencoder evaluator for Raman spectra NNE.
			%  BUILD = Element.GETBUILD(NNE) returns the build of 'NNE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoderEvaluator_RS') returns the build of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETBUILD(NNE) and Element.GETBUILD('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nne_class = getClass()
			%GETCLASS returns the class of the variational-autoencoder evaluator for Raman spectra.
			%
			% CLASS = NNVariationalAutoencoderEvaluator_RS.GETCLASS() returns the class 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNE.GETCLASS() returns the class of the variational-autoencoder evaluator for Raman spectra NNE.
			%  CLASS = Element.GETCLASS(NNE) returns the class of 'NNE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoderEvaluator_RS') returns 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETCLASS(NNE) and Element.GETCLASS('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			
			nne_class = 'NNVariationalAutoencoderEvaluator_RS';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the variational-autoencoder evaluator for Raman spectra.
			%
			% LIST = NNVariationalAutoencoderEvaluator_RS.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNE.GETSUBCLASSES() returns all subclasses of the variational-autoencoder evaluator for Raman spectra NNE.
			%  LIST = Element.GETSUBCLASSES(NNE) returns all subclasses of 'NNE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoderEvaluator_RS') returns all subclasses of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETSUBCLASSES(NNE) and Element.GETSUBCLASSES('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoderEvaluator_RS' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of variational-autoencoder evaluator for Raman spectra.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RS.GETPROPS() returns the property list of variational-autoencoder evaluator for Raman spectra
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RS.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNE.GETPROPS([CATEGORY]) returns the property list of the variational-autoencoder evaluator for Raman spectra NNE.
			%  PROPS = Element.GETPROPS(NNE[, CATEGORY]) returns the property list of 'NNE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoderEvaluator_RS'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETPROPS(NNE) and Element.GETPROPS('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = [4 14 16 17 18 19 20 22 24 25 29];
				case 4 % Category.DATA
					prop_list = [5 9 10 13 38 39 40];
				case 5 % Category.RESULT
					prop_list = 26;
				case 6 % Category.QUERY
					prop_list = [8 11 12 15 21 23 27 28 30 31 32 33 34 35 36 37 41 42 43];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of variational-autoencoder evaluator for Raman spectra.
			%
			% N = NNVariationalAutoencoderEvaluator_RS.GETPROPNUMBER() returns the property number of variational-autoencoder evaluator for Raman spectra.
			%
			% N = NNVariationalAutoencoderEvaluator_RS.GETPROPNUMBER(CATEGORY) returns the property number of variational-autoencoder evaluator for Raman spectra
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNE.GETPROPNUMBER([CATEGORY]) returns the property number of the variational-autoencoder evaluator for Raman spectra NNE.
			%  N = Element.GETPROPNUMBER(NNE) returns the property number of 'NNE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RS') returns the property number of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETPROPNUMBER(NNE) and Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 43;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 11;
				case 4 % Category.DATA
					prop_number = 7;
				case 5 % Category.RESULT
					prop_number = 1;
				case 6 % Category.QUERY
					prop_number = 19;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in variational-autoencoder evaluator for Raman spectra/error.
			%
			% CHECK = NNVariationalAutoencoderEvaluator_RS.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSPROP(PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNE, PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoderEvaluator_RS, PROP) checks whether PROP exists for NNVariationalAutoencoderEvaluator_RS.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%  Element.EXISTSPROP(NNE, PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoderEvaluator_RS, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoderEvaluator_RS.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNE) and Element.EXISTSPROP('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 43 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoderEvaluator_RS.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in variational-autoencoder evaluator for Raman spectra/error.
			%
			% CHECK = NNVariationalAutoencoderEvaluator_RS.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSTAG(TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNE, TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoderEvaluator_RS, TAG) checks whether TAG exists for NNVariationalAutoencoderEvaluator_RS.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%  Element.EXISTSTAG(NNE, TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoderEvaluator_RS, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoderEvaluator_RS.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNE) and Element.EXISTSTAG('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'DPROC'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'STRESS_SEQ'  'STRESS_LABEL'  'STRESS_COLOUR'  'STRESS_SHAPE'  'IDX_LABEL_KIND'  'KIND_ORDER'  'IDX_LABEL_LOCATION'  'LOCATION_ORDER'  'LOCATION_ALIAS_FROM'  'LOCATION_ALIAS_TO'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'RESOLUTION_CM'  'MERGE_CLOSE_PEAKS'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'LATENT_IDENTIFICATION'  'DATA_RECONSTRUCTION'  'PEAK_IDENTIFICATION'  'DIRECTORY_ANALYSIS'  'DIRECTORY_FIG'  'DIRECTORY_UTIL_R'  'CREATE_R_CONTAINER'  'PLOT_R_PALETTE'  'PLOT_R_LS_QNORM_MED' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoderEvaluator_RS.'] ...
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
			%  PROPERTY = NNE.GETPROPPROP(POINTER) returns property number of POINTER of NNE.
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoderEvaluator_RS, POINTER) returns property number of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  PROPERTY = NNE.GETPROPPROP(NNVariationalAutoencoderEvaluator_RS, POINTER) returns property number of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPPROP(NNE) and Element.GETPROPPROP('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'DPROC'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'STRESS_SEQ'  'STRESS_LABEL'  'STRESS_COLOUR'  'STRESS_SHAPE'  'IDX_LABEL_KIND'  'KIND_ORDER'  'IDX_LABEL_LOCATION'  'LOCATION_ORDER'  'LOCATION_ALIAS_FROM'  'LOCATION_ALIAS_TO'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'RESOLUTION_CM'  'MERGE_CLOSE_PEAKS'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'LATENT_IDENTIFICATION'  'DATA_RECONSTRUCTION'  'PEAK_IDENTIFICATION'  'DIRECTORY_ANALYSIS'  'DIRECTORY_FIG'  'DIRECTORY_UTIL_R'  'CREATE_R_CONTAINER'  'PLOT_R_PALETTE'  'PLOT_R_LS_QNORM_MED' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = NNE.GETPROPTAG(POINTER) returns tag of POINTER of NNE.
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoderEvaluator_RS, POINTER) returns tag of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  TAG = NNE.GETPROPTAG(NNVariationalAutoencoderEvaluator_RS, POINTER) returns tag of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPTAG(NNE) and Element.GETPROPTAG('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoderevaluator_rs_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'DPROC'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'STRESS_SEQ'  'STRESS_LABEL'  'STRESS_COLOUR'  'STRESS_SHAPE'  'IDX_LABEL_KIND'  'KIND_ORDER'  'IDX_LABEL_LOCATION'  'LOCATION_ORDER'  'LOCATION_ALIAS_FROM'  'LOCATION_ALIAS_TO'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'RESOLUTION_CM'  'MERGE_CLOSE_PEAKS'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'LATENT_IDENTIFICATION'  'DATA_RECONSTRUCTION'  'PEAK_IDENTIFICATION'  'DIRECTORY_ANALYSIS'  'DIRECTORY_FIG'  'DIRECTORY_UTIL_R'  'CREATE_R_CONTAINER'  'PLOT_R_PALETTE'  'PLOT_R_LS_QNORM_MED' };
				tag = nnvariationalautoencoderevaluator_rs_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = NNE.GETPROPCATEGORY(POINTER) returns category of POINTER of NNE.
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoderEvaluator_RS, POINTER) returns category of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  CATEGORY = NNE.GETPROPCATEGORY(NNVariationalAutoencoderEvaluator_RS, POINTER) returns category of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPCATEGORY(NNE) and Element.GETPROPCATEGORY('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_rs_category_list = { 1  1  1  3  4  2  2  6  4  4  6  6  4  3  6  3  3  3  3  3  6  3  6  3  3  5  6  6  3  6  6  6  6  6  6  6  6  4  4  4  6  6  6 };
			prop_category = nnvariationalautoencoderevaluator_rs_category_list{prop};
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
			%  FORMAT = NNE.GETPROPFORMAT(POINTER) returns format of POINTER of NNE.
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoderEvaluator_RS, POINTER) returns format of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  FORMAT = NNE.GETPROPFORMAT(NNVariationalAutoencoderEvaluator_RS, POINTER) returns format of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPFORMAT(NNE) and Element.GETPROPFORMAT('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_rs_format_list = { 2  2  2  8  2  2  2  2  8  8  1  16  8  11  3  3  3  3  3  11  3  11  3  3  3  16  1  16  11  14  16  16  16  16  1  1  1  2  2  2  16  1  1 };
			prop_format = nnvariationalautoencoderevaluator_rs_format_list{prop};
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
			%  DESCRIPTION = NNE.GETPROPDESCRIPTION(POINTER) returns description of POINTER of NNE.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoderEvaluator_RS, POINTER) returns description of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  DESCRIPTION = NNE.GETPROPDESCRIPTION(NNVariationalAutoencoderEvaluator_RS, POINTER) returns description of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_rs_description_list = { 'ELCLASS (constant, string) is the class of the variational-autoencoder evaluator for Raman spectra.'  'NAME (constant, string) is the name of the variational-autoencoder evaluator for Raman spectra.'  'DESCRIPTION (constant, string) is the description of the variational-autoencoder evaluator for Raman spectra.'  'TEMPLATE (parameter, item) is the template of the variational-autoencoder evaluator for Raman spectra.'  'ID (data, string) is a few-letter code of the variational-autoencoder evaluator for Raman spectra.'  'LABEL (metadata, string) is an extended label of the variational-autoencoder evaluator for Raman spectra.'  'NOTES (metadata, string) are specific notes of the variational-autoencoder evaluator for Raman spectra.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'NN (data, item) contains a trained neural network model.'  'D (data, item) is the dataset to evaluate the neural network model.'  'PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.'  'PREDICT_ENCODER (query, cell) returns {Z, Y} where Z are latent means (one column per data point) and Y are corresponding label vectors from D via the minibatch queue.'  'DPROC (data, item) is the Raman-spectra dataset process used for inverse normalisation/transform during decoding.'  'IDX_LABEL_STRESS (parameter, scalar) is the row index in TARGET_CLASS corresponding to stress.'  'STRESS_ORDER (query, stringlist) returns the unique stress tokens present in LATENT_REP in stable order.'  'STRESS_SEQ (parameter, stringlist) is the canonical plotting order of stresses used for export and R figures.'  'STRESS_LABEL (parameter, stringlist) are human-readable stress labels aligned with STRESS_SEQ.'  'STRESS_COLOUR (parameter, stringlist) are hex colours aligned with STRESS_SEQ.'  'STRESS_SHAPE (parameter, stringlist) are point shapes aligned with STRESS_SEQ.'  'IDX_LABEL_KIND (parameter, scalar) is the row index in TARGET_CLASS corresponding to species/kind.'  'KIND_ORDER (query, stringlist) returns the unique species/kind tokens present in LATENT_REP in stable order.'  'IDX_LABEL_LOCATION (parameter, scalar) is the row index in TARGET_CLASS corresponding to location.'  'LOCATION_ORDER (query, stringlist) returns the unique location tokens present in LATENT_REP in stable order.'  'LOCATION_ALIAS_FROM (parameter, stringlist) lists source location labels to be replaced during export.'  'LOCATION_ALIAS_TO (parameter, stringlist) lists target location labels used to replace LOCATION_ALIAS_FROM; it must have the same length as LOCATION_ALIAS_FROM.'  'LATENT_REP (result, cell) stores {Z, Y} where Z are latent representations and Y are label vectors aligned to Z for downstream analyses.'  'PREDICT_DECODER (query, empty) decodes selected latent vectors to spectra and returns a 1xN cell of column vectors (options: one-to-one/median/mean; inverse normalisation/transform toggles).'  'CROSSING (query, cell) returns {ind, t0, s0} for level crossings of S at level with interpolation method and direction.'  'RESOLUTION_CM (parameter, scalar) is the instrument resolution in cm^-1 used to merge nearby peaks.'  'MERGE_CLOSE_PEAKS (query, matrix) merges ranked peaks closer than the instrument resolution in cm^-1.'  'DERIV_PEAKS (query, cell) returns {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ind_p2n, ind_all, area, peak_wavs} from p→n zero-crossings of the derivative spectrum.'  'PEAKS_COMPARE (query, cell) returns pairwise peak-area differences between two conditions with integer-wavenumber matching tolerance.'  'DERIV_PEAKS_RUN (query, cell) returns {COND, COMP} by running DERIV_PEAKS per condition and all pairwise comparisons.'  'DERIV_PEAKS_SAVE (query, cell) saves per-condition ranked tables and pairwise ranked differences using legacy-compatible filenames.'  'LATENT_IDENTIFICATION (query, empty) exports per-species×location latent cells z1/z2 and ranges aligned with STRESS_SEQ for the R plotting pipeline.'  'DATA_RECONSTRUCTION (query, empty) decodes median spectra per stress for each species×location and saves R-ready .mat files.'  'PEAK_IDENTIFICATION (query, empty) decodes per species, detects derivative peaks per stress, runs all pairwise comparisons, and saves ranked tables.'  'DIRECTORY_ANALYSIS (data, string) is the directory where intermediate .mat files and analysis outputs are saved.'  'DIRECTORY_FIG (data, string) is the directory where figures are exported.'  'DIRECTORY_UTIL_R (data, string) is the directory containing the R scripts and Dockerfile used for plotting.'  'CREATE_R_CONTAINER (query, cell) ensures the plotting Docker image exists and returns {image_tag}.'  'PLOT_R_PALETTE (query, empty) generates palette figures via Docker+R (generic_fig_palette_p1.R) after preparing latent, reconstruction, and identification outputs.'  'PLOT_R_LS_QNORM_MED (query, empty) plots latent-space qnorm (median) via Docker+R (generic_plot_ls_qnorm_med.R) after preparing required .mat inputs.' };
			prop_description = nnvariationalautoencoderevaluator_rs_description_list{prop};
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
			%  SETTINGS = NNE.GETPROPSETTINGS(POINTER) returns settings of POINTER of NNE.
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoderEvaluator_RS, POINTER) returns settings of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  SETTINGS = NNE.GETPROPSETTINGS(NNVariationalAutoencoderEvaluator_RS, POINTER) returns settings of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPSETTINGS(NNE) and Element.GETPROPSETTINGS('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 13 % NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_settings = 'NNDatasetProcess_RamanSpectra';
				case 14 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_settings = Format.getFormatSettings(11);
				case 15 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_settings = Format.getFormatSettings(3);
				case 16 % NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_settings = Format.getFormatSettings(3);
				case 17 % NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_settings = Format.getFormatSettings(3);
				case 18 % NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_settings = Format.getFormatSettings(3);
				case 19 % NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_settings = Format.getFormatSettings(3);
				case 20 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_settings = Format.getFormatSettings(11);
				case 21 % NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_settings = Format.getFormatSettings(3);
				case 22 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_settings = Format.getFormatSettings(11);
				case 23 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_settings = Format.getFormatSettings(3);
				case 24 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_settings = Format.getFormatSettings(3);
				case 25 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_settings = Format.getFormatSettings(3);
				case 26 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_settings = Format.getFormatSettings(16);
				case 27 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_settings = Format.getFormatSettings(1);
				case 28 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_settings = Format.getFormatSettings(16);
				case 29 % NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_settings = Format.getFormatSettings(11);
				case 30 % NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_settings = Format.getFormatSettings(14);
				case 31 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_settings = Format.getFormatSettings(16);
				case 32 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_settings = Format.getFormatSettings(16);
				case 33 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_settings = Format.getFormatSettings(16);
				case 34 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_settings = Format.getFormatSettings(16);
				case 35 % NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_settings = Format.getFormatSettings(1);
				case 36 % NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_settings = Format.getFormatSettings(1);
				case 37 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_settings = Format.getFormatSettings(1);
				case 38 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_settings = Format.getFormatSettings(2);
				case 39 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_settings = Format.getFormatSettings(2);
				case 40 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_settings = Format.getFormatSettings(2);
				case 41 % NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_settings = Format.getFormatSettings(16);
				case 42 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_settings = Format.getFormatSettings(1);
				case 43 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_settings = Format.getFormatSettings(1);
				case 4 % NNVariationalAutoencoderEvaluator_RS.TEMPLATE
					prop_settings = 'NNVariationalAutoencoderEvaluator_RS';
				otherwise
					prop_settings = getPropSettings@NNVariationalAutoencoderEvaluator(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RS.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RS.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoderEvaluator_RS, POINTER) returns the default value of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  DEFAULT = NNE.GETPROPDEFAULT(NNVariationalAutoencoderEvaluator_RS, POINTER) returns the default value of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPDEFAULT(NNE) and Element.GETPROPDEFAULT('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 13 % NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 14 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_default = 2;
				case 15 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_default = Format.getFormatDefault(3, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 16 % NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_default = {'HL', 'WL', 'LL', 'SH'};
				case 17 % NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_default = {'High light', 'White light', 'Low light', 'Shade'};
				case 18 % NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_default = {'#E64B35FF', '#7E6148FF', '#4DBBD5FF', '#3C5488FF'};
				case 19 % NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_default = {'square', 'circle', 'triangle', 'diamond'};
				case 20 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_default = 1;
				case 21 % NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_default = Format.getFormatDefault(3, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 22 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_default = 3;
				case 23 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_default = Format.getFormatDefault(3, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 24 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_default = {};
				case 25 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_default = {};
				case 26 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 27 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 28 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 29 % NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_default = 6;
				case 30 % NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_default = Format.getFormatDefault(14, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 31 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 32 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 33 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 34 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 35 % NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 36 % NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 37 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 38 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_default = fileparts(which('test_braph2'));
				case 39 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_default = fileparts(which('test_braph2'));
				case 40 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_default = fileparts(which('test_braph2'));
				case 41 % NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 42 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 43 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 1 % NNVariationalAutoencoderEvaluator_RS.ELCLASS
					prop_default = 'NNVariationalAutoencoderEvaluator_RS';
				case 2 % NNVariationalAutoencoderEvaluator_RS.NAME
					prop_default = 'Neural Network Evaluator';
				case 3 % NNVariationalAutoencoderEvaluator_RS.DESCRIPTION
					prop_default = 'A variational-autoencoder evaluator (NNVariationalAutoencoderEvaluator_RS) evaluates a trained model on a specific dataset, producing latent representations, decoded spectra, peak analyses, and Docker-backed R figures for Raman-spectra workflows. Instances of this class should not be created directly—use one of its subclasses.';
				case 4 % NNVariationalAutoencoderEvaluator_RS.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 5 % NNVariationalAutoencoderEvaluator_RS.ID
					prop_default = 'NNEvaluator ID';
				case 6 % NNVariationalAutoencoderEvaluator_RS.LABEL
					prop_default = 'NNEvaluator label';
				case 7 % NNVariationalAutoencoderEvaluator_RS.NOTES
					prop_default = 'NNEvaluator notes';
				otherwise
					prop_default = getPropDefault@NNVariationalAutoencoderEvaluator(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RS.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RS.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderEvaluator_RS, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderEvaluator_RS, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderEvaluator_RS.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoderEvaluator_RS.conditioning(prop, NNVariationalAutoencoderEvaluator_RS.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = NNE.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = NNE.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of NNE.
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderEvaluator_RS.
			%  CHECK = NNE.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderEvaluator_RS.
			% 
			% NNE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNE.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RS.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput
			%  NNE.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RS.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RS:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNE) and Element.CHECKPROP('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			switch prop
				case 13 % NNVariationalAutoencoderEvaluator_RS.DPROC
					check = Format.checkFormat(8, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 14 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 15 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 16 % NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 17 % NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 18 % NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 19 % NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 20 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 21 % NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 22 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 23 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 24 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 25 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 26 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 27 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 28 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 29 % NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 30 % NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					check = Format.checkFormat(14, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 31 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 32 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 33 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 34 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 35 % NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 36 % NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 37 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 38 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					check = Format.checkFormat(2, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 39 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					check = Format.checkFormat(2, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 40 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					check = Format.checkFormat(2, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 41 % NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 42 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 43 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 4 % NNVariationalAutoencoderEvaluator_RS.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				otherwise
					if prop <= 12
						check = checkProp@NNVariationalAutoencoderEvaluator(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RS:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoderEvaluator_RS.getPropTag(prop) ' (' NNVariationalAutoencoderEvaluator_RS.getFormatTag(NNVariationalAutoencoderEvaluator_RS.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
	methods (Access=protected) % calculate value
		function value = calculateValue(nne, prop, varargin)
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
				case 15 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					idx = nne.get('IDX_LABEL_STRESS');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case 21 % NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					idx = nne.get('IDX_LABEL_KIND');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case 23 % NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					idx = nne.get('IDX_LABEL_LOCATION');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case 26 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					rng_settings_ = rng(); rng(nne.getPropSeed(26), 'twister')
					
					nnvae = nne.get('NN');
					if strcmp(class(nnvae), 'NNBase')
					    value = {};
					    return
					end
					netE = nnvae.get('ENCODER');
					d = nne.get('D');
					mbq = nnvae.get('MBQ', d, 1);
					
					value = nne.get('PREDICT_ENCODER', netE, mbq);
					
					rng(rng_settings_)
					
				case 27 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					latent_rep = nne.get('LATENT_REP');
					ZLatent = latent_rep{1};
					YLatent = latent_rep{2};
					raw_data = nne.get('DPROC').get('RAW_DATA');
					raw_data = cat(2, raw_data{:});
					
					if isempty(varargin)
					    idx = 1:1:size(ZLatent, 2);
					    representation_select = 'one-to-one';
					    denormalization = true;
					    detranformation = false;
					else
					    idx = varargin{1};
					    representation_select = varargin{2};
					    denormalization = varargin{3};
					    detranformation = varargin{4};
					end
					switch representation_select
					    case 'one-to-one'
					        ZSelected = ZLatent(:, idx);
					        reference_data = raw_data(1, idx);
					    case 'median'
					        ZSelected = median(ZLatent(:, idx), 2);
					        reference_data = median(raw_data(1, idx), 2);
					    case 'mean'
					        ZSelected = mean(ZLatent(:, idx), 2);
					        reference_data = mean(raw_data(1, idx), 2);
					end
					
					ZSelected = dlarray(ZSelected, 'CB');
					
					nnvae = nne.get('NN');
					netD = nnvae.get('DECODER');
					decoded_inputs = extractdata(predict(netD, ZSelected));
					
					dproc = nne.get('DPROC');
					if denormalization
					    decoded_inputs = dproc.get('INV_NORMALIZE_DATA', decoded_inputs);
					end
					if detranformation
					    decoded_inputs = dproc.get('INV_TRANSFORM_DATA', decoded_inputs, reference_data);
					end
					
					for i = 1:size(decoded_inputs, 2)
					    value{i} = decoded_inputs(:, i);
					end
					
				case 28 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					% VALUE = nne.get('CROSSING', S)
					% VALUE = nne.get('CROSSING', S, t)
					% VALUE = nne.get('CROSSING', S, t, level)
					% VALUE = nne.get('CROSSING', S, t, level, imeth)
					% VALUE = nne.get('CROSSING', S, t, level, imeth, direction)
					
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
					    case 'both'
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
					
				case 30 % NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					% VALUE = nne.get('MERGE_CLOSE_PEAKS', ranked_sig_pks)
					% VALUE = nne.get('MERGE_CLOSE_PEAKS', ranked_sig_pks, resolution_cm)
					
					if isempty(varargin)
					    value = [];
					    return
					end
					
					ranked_sig_pks = varargin{1};
					if numel(varargin) >= 2 && ~isempty(varargin{2})
					    resolution_cm = varargin{2};
					else
					    resolution_cm = nne.get('RESOLUTION_CM');
					end
					
					if isempty(ranked_sig_pks)
					    value = ranked_sig_pks;
					    return
					end
					
					w_int = ranked_sig_pks(:, 2);  % integer/ceil wavenumber
					aug   = ranked_sig_pks(:, 3);  % AUG / area
					
					% Sort by integer wavenumber so neighbours are adjacent
					[w_int_sorted, idx_sort] = sort(w_int);
					aug_sorted = aug(idx_sort);
					
					merged_list = [];
					
					% Start first cluster
					cluster_w_int = w_int_sorted(1);
					cluster_aug   = aug_sorted(1);
					
					for i = 2:length(w_int_sorted)
					    % Cluster decision uses col 2 (integer wavenumber)
					    if abs(w_int_sorted(i) - w_int_sorted(i-1)) < resolution_cm
					        % same cluster
					        cluster_w_int = [cluster_w_int; w_int_sorted(i)];
					        cluster_aug   = [cluster_aug;   aug_sorted(i)];
					    else
					        % flush current cluster
					        [~, idx_max_local] = max(cluster_aug);
					        w_rep   = cluster_w_int(idx_max_local);  % representative wavenumber
					        aug_rep = sum(cluster_aug);              % sum of AUGs
					
					        merged_list = [merged_list; w_rep, w_rep, aug_rep];
					
					        % start new cluster
					        cluster_w_int = w_int_sorted(i);
					        cluster_aug   = aug_sorted(i);
					    end
					end
					
					% flush last cluster
					[~, idx_max_local] = max(cluster_aug);
					w_rep   = cluster_w_int(idx_max_local);
					aug_rep = sum(cluster_aug);
					merged_list = [merged_list; w_rep, w_rep, aug_rep];
					
					% Re-sort by AUG (desc) to preserve "ranked" semantics
					[~, idx_rank] = sort(merged_list(:, 3), 'descend');
					merged_sig_pks = merged_list(idx_rank, :);
					
					value = merged_sig_pks;
					
				case 31 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					% VALUE = nne.get('DERIV_PEAKS', y, x)
					% VALUE = nne.get('DERIV_PEAKS', y, x, imeth)
					
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
					
				case 32 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					% VALUE = nne.get('PEAKS_COMPARE', peaks_A, peaks_B, nameA, nameB)
					% VALUE = nne.get('PEAKS_COMPARE', peaks_A, peaks_B, nameA, nameB, tolInt)
					
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
					
				case 33 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					% VALUE = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels)
					% VALUE = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels, imeth, tolInt)
					
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
					
					COND = cell(1, C);
					for c = 1:C
					    y = data_cell{c};
					    out = nne.get('DERIV_PEAKS', y, x, imeth);
					    name = cond_labels{c};
					    peaks_table = out{1};
					    peaks_ranked = out{2};
					    COND{c} = {name, peaks_table, peaks_ranked};
					end
					
					pairs = nchoosek(1:C, 2);
					COMP = cell(1, size(pairs,1));
					for p = 1:size(pairs,1)
					    i = pairs(p,1); j = pairs(p,2);
					    Ai = COND{i}{2};  Bj = COND{j}{2};
					    out = nne.get('PEAKS_COMPARE', Ai, Bj, COND{i}{1}, COND{j}{1}, tolInt);
					    COMP{p} = out;
					end
					
					value = {COND, COMP};
					
				case 34 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					% nne.get('DERIV_PEAKS_SAVE', COND, COMP, state)
					
					if isempty(varargin)
					    value = {};
					    return
					end
					
					COND  = varargin{1};
					COMP  = varargin{2};
					state = char(string(varargin{3}));
					save_dir = nne.get('DIRECTORY_ANALYSIS');
					
					if ~exist(save_dir, 'dir')
					    mkdir(save_dir);
					end
					
					for c = 1:numel(COND)
					    name = COND{c}{1};
					    ranked_sig_pks_raw = COND{c}{3}; %#ok<NASGU>
					
					    % Merge close peaks according to resolution
					    ranked_sig_pks = nne.get('MERGE_CLOSE_PEAKS', ranked_sig_pks_raw);
					
					    varname  = sprintf('ranked_sig_pks_%s', name);
					    fname    = sprintf('ranked_sig_pks_%s %s.mat', name, state);
					    filepath = fullfile(save_dir, fname);
					
					    S = struct();
					    S.(varname) = ranked_sig_pks;
					    save(filepath, '-struct', 'S');
					end
					
					for p = 1:numel(COMP)
					    label = COMP{p}{1};
					    ranked_sig_pks_mod = COMP{p}{2}; %#ok<NASGU>
					
					    varname  = sprintf('ranked_sig_pks_%s_mod', label);
					    fname    = sprintf('ranked_sig_pks_%s_mod %s.mat', label, state);
					    filepath = fullfile(save_dir, fname);
					
					    S = struct();
					    S.(varname) = ranked_sig_pks_mod;
					    save(filepath, '-struct', 'S');
					end
					
					value = {};
					
				case 35 % NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					% Side-effect: writes latent_<species>_<location>.mat with z1, z2, z1_range, z2_range and stress metadata.
					
					d = nne.get('D');
					num_dp = d.get('DP_DICT').get('LENGTH');
					if num_dp == 0
					    value = {};
					    return
					end
					
					i_species   = nne.get('IDX_LABEL_KIND');
					i_stress    = nne.get('IDX_LABEL_STRESS');
					i_location  = nne.get('IDX_LABEL_LOCATION');
					stress_order = nne.get('STRESS_ORDER');
					stress_seq   = nne.get('STRESS_SEQ');
					
					latent_rep = nne.get('LATENT_REP');
					ZLatent    = latent_rep{1};
					YLatent    = latent_rep{2};
					
					if size(ZLatent, 1) < 2
					    warning('LATENT_IDENTIFICATION: latent dimension < 2, cannot build z1/z2.');
					    value = {};
					    return
					end
					
					z1_all = ZLatent(1, :);
					z2_all = ZLatent(2, :);
					
					z1_range = [min(z1_all), max(z1_all)];  %#ok<NASGU>
					z2_range = [min(z2_all), max(z2_all)];  %#ok<NASGU>
					
					species_all  = string(cellfun(@(lbl) string(lbl(i_species)),  YLatent, 'UniformOutput', false));
					stress_all   = string(cellfun(@(lbl) string(lbl(i_stress)),   YLatent, 'UniformOutput', false));
					location_all = string(cellfun(@(lbl) string(lbl(i_location)), YLatent, 'UniformOutput', false));
					
					% --- apply explicit alias mapping BEFORE building the location list ---
					alias_from = string(nne.get('LOCATION_ALIAS_FROM'));
					alias_to   = string(nne.get('LOCATION_ALIAS_TO'));
					location_all_resolved = location_all;
					
					if ~isempty(alias_from) && ~isempty(alias_to)
					    nmap = min(numel(alias_from), numel(alias_to));
					    for kk = 1:nmap
					        m = location_all_resolved == strtrim(alias_from(kk));
					        if any(m)
					            location_all_resolved(m) = strtrim(alias_to(kk));
					        end
					    end
					end
					
					location_all = location_all_resolved;
					
					species_list  = unique(species_all, 'stable');
					location_list = unique(location_all, 'stable');
					
					if isempty(stress_seq)
					    stress_seq_labels = string(stress_order);
					else
					    if isnumeric(stress_seq)
					        stress_seq_labels = string(stress_order(stress_seq));
					    else
					        stress_seq_labels = string(stress_seq);
					    end
					end
					
					canon_seq    = string(nne.get('STRESS_SEQ'));
					canon_label  = string(nne.get('STRESS_LABEL'));
					canon_colour = string(nne.get('STRESS_COLOUR'));
					canon_shape  = string(nne.get('STRESS_SHAPE'));
					
					[~, idx_map] = ismember(stress_seq_labels, canon_seq);
					
					if any(idx_map == 0)
					    warning('LATENT_IDENTIFICATION: some stresses not found in STRESS_SEQ; using tokens as labels, default colour/shape.');
					    stress_label_run  = cellstr(stress_seq_labels);
					    stress_colour_run = repmat({'#000000FF'}, size(stress_label_run));
					    stress_shape_run  = repmat({'circle'},    size(stress_label_run));
					else
					    stress_label_run  = cellstr(canon_label(idx_map));
					    stress_colour_run = cellstr(canon_colour(idx_map));
					    stress_shape_run  = cellstr(canon_shape(idx_map));
					end
					
					stress_seq_run = cellstr(stress_seq_labels(:));
					
					root_dir = nne.get('DIRECTORY_ANALYSIS');
					out_dir  = fullfile(root_dir, 'crnr_transformed');
					if ~exist(out_dir, 'dir')
					    mkdir(out_dir);
					end
					
					for s = 1:numel(species_list)
					    sp = species_list(s);
					
					    for l = 1:numel(location_list)
					        loc = location_list(l);
					
					        z1 = cell(1, numel(stress_seq_labels)); %#ok<NASGU>
					        z2 = cell(1, numel(stress_seq_labels)); %#ok<NASGU>
					        all_present = true;
					
					        for k = 1:numel(stress_seq_labels)
					            st = stress_seq_labels(k);
					
					            idx = (species_all == sp) & (location_all == loc) & (stress_all == st);
					            if ~any(idx)
					                all_present = false;
					                break
					            end
					
					            z1{k} = z1_all(idx).';
					            z2{k} = z2_all(idx).';
					        end
					
					        if ~all_present
					            continue
					        end
					
					        fname     = sprintf('latent_%s_%s.mat', char(sp), char(loc));
					        save_path = fullfile(out_dir, fname);
					
					        stress_seq    = stress_seq_run;    %#ok<NASGU>
					        stress_label  = stress_label_run;  %#ok<NASGU>
					        stress_colour = stress_colour_run; %#ok<NASGU>
					        stress_shape  = stress_shape_run;  %#ok<NASGU>
					
					        save(save_path, ...
					            'z1', 'z2', 'z1_range', 'z2_range', ...
					            'stress_seq', 'stress_label', 'stress_colour', 'stress_shape');
					    end
					end
					
					value = {};
					
				case 36 % NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					d = nne.get('D');
					num_dp = d.get('DP_DICT').get('LENGTH');
					if num_dp == 0
					    value = {};
					    return
					end
					
					if isempty(varargin)
					    output_file_prefix = 'crnr_transformed';
					    representation_select = 'median';
					    denormalization = true;
					    detransformation = false;
					else
					    output_file_prefix = varargin{1};
					    representation_select = varargin{2};
					    denormalization = varargin{3};
					    detransformation = varargin{4};
					end
					
					x = d.get('DP_DICT').get('IT', 1).get('WL_OF_INTEREST');
					i_species   = nne.get('IDX_LABEL_KIND');
					i_stress    = nne.get('IDX_LABEL_STRESS');
					i_location  = nne.get('IDX_LABEL_LOCATION');
					stress_order = nne.get('STRESS_ORDER');
					stress_seq   = nne.get('STRESS_SEQ');
					
					latent_rep = nne.get('LATENT_REP');
					YLatent    = latent_rep{2};
					
					species_all  = string(cellfun(@(ind_labels) string(ind_labels(i_species)),  YLatent, 'UniformOutput', false));
					stress_all   = string(cellfun(@(ind_labels) string(ind_labels(i_stress)),   YLatent, 'UniformOutput', false));
					location_all = string(cellfun(@(ind_labels) string(ind_labels(i_location)), YLatent, 'UniformOutput', false));
					
					% --- apply explicit alias mapping BEFORE building the location list ---
					alias_from = string(nne.get('LOCATION_ALIAS_FROM'));
					alias_to   = string(nne.get('LOCATION_ALIAS_TO'));
					location_all_resolved = location_all;
					
					if ~isempty(alias_from) && ~isempty(alias_to)
					    nmap = min(numel(alias_from), numel(alias_to));
					    for kk = 1:nmap
					        m = location_all_resolved == strtrim(alias_from(kk));
					        if any(m)
					            location_all_resolved(m) = strtrim(alias_to(kk));
					        end
					    end
					end
					
					location_all = location_all_resolved;
					
					species_list  = unique(species_all, 'stable');
					location_list = unique(location_all, 'stable');
					
					if isempty(stress_seq)
					    stress_seq_labels = string(stress_order);
					else
					    if isnumeric(stress_seq)
					        stress_seq_labels = string(stress_order(stress_seq));
					    else
					        stress_seq_labels = string(stress_seq);
					    end
					end
					
					canon_seq    = string(nne.get('STRESS_SEQ'));
					canon_label  = string(nne.get('STRESS_LABEL'));
					canon_colour = string(nne.get('STRESS_COLOUR'));
					canon_shape  = string(nne.get('STRESS_SHAPE'));
					
					[~, idx_map] = ismember(stress_seq_labels, canon_seq);
					
					if any(idx_map == 0)
					    warning('Some stresses in stress_seq_labels are not found in STRESS_SEQ; using labels=token, default colour/shape.');
					    stress_label_run  = cellstr(stress_seq_labels);
					    stress_colour_run = repmat({'#000000FF'}, size(stress_label_run));
					    stress_shape_run  = repmat({'circle'},    size(stress_label_run));
					else
					    stress_label_run  = cellstr(canon_label(idx_map));
					    stress_colour_run = cellstr(canon_colour(idx_map));
					    stress_shape_run  = cellstr(canon_shape(idx_map));
					end
					
					stress_seq_run = cellstr(stress_seq_labels(:));
					
					root_dir = nne.get('DIRECTORY_ANALYSIS');
					out_dir  = fullfile(root_dir, output_file_prefix);
					if ~exist(out_dir, 'dir')
					    mkdir(out_dir);
					end
					
					for s = 1:numel(species_list)
					    sp = species_list(s);
					
					    for l = 1:numel(location_list)
					        loc = location_list(l);
					
					        num_stress   = numel(stress_seq_labels);
					        spectra_cell = cell(1, num_stress);
					        all_present  = true;
					
					        for si = 1:num_stress
					            st = stress_seq_labels(si);
					            idx = (species_all == sp) & (location_all == loc) & (stress_all == st);
					
					            if ~any(idx)
					                all_present = false;
					                break
					            end
					
					            dec = nne.get('PREDICT_DECODER', idx, representation_select, denormalization, detransformation);
					            spectra_cell{si} = dec{1};
					        end
					
					        if ~all_present
					            continue
					        end
					
					        data    = spectra_cell; %#ok<NASGU>
					        x_local = x(:);        %#ok<NASGU>
					
					        stress_label_block = strjoin(cellstr(stress_seq_labels(:)), '-');
					        fname = sprintf('(Tr) Diff Spectrum (%s) with %s and %s.mat', ...
					            stress_label_block, char(sp), char(loc));
					        save_path = fullfile(out_dir, fname);
					
					        stress_seq    = stress_seq_run;    %#ok<NASGU>
					        stress_label  = stress_label_run;  %#ok<NASGU>
					        stress_colour = stress_colour_run; %#ok<NASGU>
					        stress_shape  = stress_shape_run;  %#ok<NASGU>
					
					        x = x_local; %#ok<NASGU>
					
					        save(save_path, ...
					            'data', 'x', ...
					            'stress_seq', 'stress_label', 'stress_colour', 'stress_shape');
					    end
					end
					
					value = {};
					
				case 37 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					d = nne.get('D');
					num_dp = d.get('DP_DICT').get('LENGTH');
					if num_dp == 0
					    value = {};
					    return
					end
					
					x = d.get('DP_DICT').get('IT', 1).get('WL_OF_INTEREST');
					i_species   = nne.get('IDX_LABEL_KIND');
					i_stress    = nne.get('IDX_LABEL_STRESS');
					stress_order = nne.get('STRESS_ORDER');
					stress_seq   = nne.get('STRESS_SEQ');
					
					latent_rep = nne.get('LATENT_REP');
					YLatent    = latent_rep{2};
					species_all = string(cellfun(@(ind_labels) string(ind_labels(i_species)), YLatent, 'UniformOutput', false));
					stress_all  = string(cellfun(@(ind_labels) string(ind_labels(i_stress)),  YLatent, 'UniformOutput', false));
					
					lat = nne.get('LATENT_REP'); %#ok<NASGU>
					
					kind_order = nne.get('KIND_ORDER');
					
					if isempty(stress_seq)
					    stress_seq_labels = string(stress_order);
					else
					    if isnumeric(stress_seq)
					        stress_seq_labels = string(stress_order(stress_seq));
					    else
					        stress_seq_labels = string(stress_seq);
					    end
					end
					
					for s = 1:numel(kind_order)
					    sp = kind_order(s);
					
					    data_cell   = {};
					    cond_labels = {};
					    ci = 0;
					
					    for so = 1:numel(stress_seq_labels)
					        st = stress_seq_labels(so);
					        idx = (species_all == sp) & (stress_all == st);
					
					        if any(idx)
					            ci = ci + 1;
					            dec = nne.get('PREDICT_DECODER', idx, 'median', true, false);
					            data_cell{ci}   = dec{1};
					            cond_labels{ci} = char(st); %#ok<AGROW>
					        end
					    end
					
					    if numel(data_cell) == 0
					        continue
					    end
					
					    out  = nne.get('DERIV_PEAKS_RUN', data_cell, x, cond_labels, 'linear', 1);
					    COND = out{1};
					    COMP = out{2};
					
					    nne.get('DERIV_PEAKS_SAVE', COND, COMP, char(sp));
					end
					
					value = {};
					
				case 41 % NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					% VALUE = nne.get('CREATE_R_CONTAINER')
					% VALUE = nne.get('CREATE_R_CONTAINER', docker_dir)
					% VALUE = nne.get('CREATE_R_CONTAINER', docker_dir, image_tag)
					
					docker_dir = nne.get('DIRECTORY_UTIL_R');
					image_tag  = 'rls-plot:latest';
					if ~isempty(varargin)
					    docker_dir = varargin{1};
					end
					if numel(varargin) >= 2 && ~isempty(varargin{2})
					    image_tag = varargin{2};
					end
					
					if ismac
					    setenv('PATH', [getenv('PATH') ':/opt/homebrew/bin:/usr/local/bin']);
					end
					
					[st,~] = system('docker --version');
					if st ~= 0
					    msg = [ ...
					        'Docker command not found from within MATLAB.' newline ...
					        'If Docker works in your Terminal but not in MATLAB, check the PATH:' newline ...
					        '  1) In Terminal, run:  which docker' newline ...
					        '  2) In MATLAB, run:    setenv(''PATH'', [getenv(''PATH'') '':/usr/local/bin'']);' ];
					    warning(msg);
					    value = {};
					    return
					end
					
					dkfile = fullfile(docker_dir, 'Dockerfile');
					if ~exist(dkfile, 'file') && ~BRAPH2TEST.RANDOM
					    warning('No Dockerfile at: %s', dkfile);
					    value = {};
					    return
					end
					
					if ispc
					    nullsink = 'NUL';
					else
					    nullsink = '/dev/null';
					end
					
					cmd_check = sprintf('docker image inspect %s > %s 2>&1', image_tag, nullsink);
					st = system(cmd_check);
					
					if st ~= 0
					    cmd_ls = sprintf('docker image ls "%s" --format "{{.Repository}}:{{.Tag}}"', image_tag);
					    [st_ls, out_ls] = system(cmd_ls);
					    out_ls = strtrim(out_ls);
					    if st_ls == 0 && ~isempty(out_ls)
					        st = 0;
					    end
					end
					
					if st ~= 0
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
					
				case 42 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					nne.memorize('LATENT_REP');
					nne.get('PEAK_IDENTIFICATION');
					nne.get('DATA_RECONSTRUCTION');
					nne.get('LATENT_IDENTIFICATION');
					
					wd_analysis = nne.get('DIRECTORY_ANALYSIS');
					wd_fig    = nne.get('DIRECTORY_FIG');
					wd_rfile = nne.get('DIRECTORY_UTIL_R');
					
					out = nne.get('CREATE_R_CONTAINER');
					if isempty(out)
					    value = {};
					    return
					end
					image_tag = out{1};
					
					cmd = sprintf([ ...
					    'docker run --rm ' ...
					    '-v "%s":/rfiles ' ...
					    '-v "%s":/work ' ...
					    '-v "%s":/fig ' ...
					    '-w /work %s Rscript /rfiles/generic_fig_palette_p1.R /fig'], ...
					    wd_rfile, wd_analysis, wd_fig, image_tag);
					
					fprintf('>> %s%s', cmd, newline);
					[st, outstr] = system(cmd);
					disp(outstr);
					assert(st == 0, 'Docker run failed (generic_fig_palette_p1.R).');
					
					fprintf('Palette figures generated and saved in: %s%s', wd_fig, newline);
					
					title = ['Palette Figure Generated'];
					message = {''
					    ['{\bf\color{orange}' 'BRAPH2' '}'] % note to use double slashes to avoid genesis problem
					    ['{\color{gray}version ' '2.0.1' '}']
					    ['{\color{gray}build ' int2str(7) '}']
					    ''
					    'The figures are generated and exported using the R script.'
					    'Please, check the exported figures in the output directory.'
					    ''
					    ''};
					braph2msgbox(title, message)
					
					value = {};
					
				case 43 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					nne.memorize('LATENT_REP');
					nne.get('PEAK_IDENTIFICATION');
					nne.get('DATA_RECONSTRUCTION');
					nne.get('LATENT_IDENTIFICATION');
					
					out = nne.get('CREATE_R_CONTAINER'); 
					if isempty(out)
					    value = {};
					    return
					end
					image_tag = out{1};
					
					wd_analysis = nne.get('DIRECTORY_ANALYSIS');
					wd_fig    = nne.get('DIRECTORY_FIG');
					wd_rfile = nne.get('DIRECTORY_UTIL_R');
					
					cmd = sprintf([ ...
					    'docker run --rm ' ...
					    '-v "%s":/rfiles ' ...
					    '-v "%s":/work ' ...
					    '-v "%s":/fig ' ...
					    '-w /work %s Rscript /rfiles/generic_plot_ls_qnorm_med.R /fig'], ...
					    wd_rfile, wd_analysis, wd_fig, image_tag);
					fprintf('>> %s%s', cmd, newline);
					[st,outstr] = system(cmd);
					disp(outstr);
					assert(st == 0, 'Docker run failed (generic_plot_ls_qnorm_med.R).');
					
					fprintf('Ls qnorm figures produced successfully and saved in: %s%s', wd_fig, newline);
					
					title = ['Latent Space Qnorm Figure Generated'];
					message = {''
					    ['{\bf\color{orange}' 'BRAPH2' '}'] % note to use double slashes to avoid genesis problem
					    ['{\color{gray}version ' '2.0.1' '}']
					    ['{\color{gray}build ' int2str(7) '}']
					    ''
					    'The figures are generated and exported using the R script.'
					    'Please, check the exported figures in the output directory.'
					    ''
					    ''};
					braph2msgbox(title, message)
					
					value = {};
					
				case 12 % NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER
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
					
					    % Forward through encoder (mu used as Z).
					    [~, mu, ~] = predict(netE, X_individual);
					    Z = cat(2, Z, extractdata(mu));
					
					    Y_individual = extractdata(gather(Y_individual));
					    Y_number = targets(Y_individual);
					    Y = cat(2, Y, Y_number);
					end
					
					value = [{Z}, {Y}];
					
				otherwise
					if prop <= 12
						value = calculateValue@NNVariationalAutoencoderEvaluator(nne, prop, varargin{:});
					else
						value = calculateValue@Element(nne, prop, varargin{:});
					end
			end
			
		end
	end
end
