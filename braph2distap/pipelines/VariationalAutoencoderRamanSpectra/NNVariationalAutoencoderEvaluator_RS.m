classdef NNVariationalAutoencoderEvaluator_RS < NNVariationalAutoencoderEvaluator
	%NNVariationalAutoencoderEvaluator_RS evaluates a trained variational autoencoder with a dataset.
	% It is a subclass of <a href="matlab:help NNVariationalAutoencoderEvaluator">NNVariationalAutoencoderEvaluator</a>.
	%
	% A variational-autoencoder evaluator (NNVariationalAutoencoderEvaluator_RS) evaluates a trained varitional autoencoder on a specific dataset, 
	%  producing latent representations, decoded spectra, peak analyses, and Docker-backed R figures for Raman-spectra workflows.
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
	% BUILD BRAPH2 BRAPH2.BUILD class_name 1
	
	properties (Constant) % properties
		DPROC = NNVariationalAutoencoderEvaluator.getPropNumber() + 1;
		DPROC_TAG = 'DPROC';
		DPROC_CATEGORY = Category.DATA;
		DPROC_FORMAT = Format.ITEM;
		
		IDX_LABEL_STRESS = NNVariationalAutoencoderEvaluator.getPropNumber() + 2;
		IDX_LABEL_STRESS_TAG = 'IDX_LABEL_STRESS';
		IDX_LABEL_STRESS_CATEGORY = Category.PARAMETER;
		IDX_LABEL_STRESS_FORMAT = Format.SCALAR;
		
		STRESS_ORDER = NNVariationalAutoencoderEvaluator.getPropNumber() + 3;
		STRESS_ORDER_TAG = 'STRESS_ORDER';
		STRESS_ORDER_CATEGORY = Category.QUERY;
		STRESS_ORDER_FORMAT = Format.STRINGLIST;
		
		STRESS_SEQ = NNVariationalAutoencoderEvaluator.getPropNumber() + 4;
		STRESS_SEQ_TAG = 'STRESS_SEQ';
		STRESS_SEQ_CATEGORY = Category.PARAMETER;
		STRESS_SEQ_FORMAT = Format.STRINGLIST;
		
		STRESS_LABEL = NNVariationalAutoencoderEvaluator.getPropNumber() + 5;
		STRESS_LABEL_TAG = 'STRESS_LABEL';
		STRESS_LABEL_CATEGORY = Category.PARAMETER;
		STRESS_LABEL_FORMAT = Format.STRINGLIST;
		
		STRESS_COLOUR = NNVariationalAutoencoderEvaluator.getPropNumber() + 6;
		STRESS_COLOUR_TAG = 'STRESS_COLOUR';
		STRESS_COLOUR_CATEGORY = Category.PARAMETER;
		STRESS_COLOUR_FORMAT = Format.STRINGLIST;
		
		STRESS_SHAPE = NNVariationalAutoencoderEvaluator.getPropNumber() + 7;
		STRESS_SHAPE_TAG = 'STRESS_SHAPE';
		STRESS_SHAPE_CATEGORY = Category.PARAMETER;
		STRESS_SHAPE_FORMAT = Format.STRINGLIST;
		
		IDX_LABEL_KIND = NNVariationalAutoencoderEvaluator.getPropNumber() + 8;
		IDX_LABEL_KIND_TAG = 'IDX_LABEL_KIND';
		IDX_LABEL_KIND_CATEGORY = Category.PARAMETER;
		IDX_LABEL_KIND_FORMAT = Format.SCALAR;
		
		KIND_ORDER = NNVariationalAutoencoderEvaluator.getPropNumber() + 9;
		KIND_ORDER_TAG = 'KIND_ORDER';
		KIND_ORDER_CATEGORY = Category.QUERY;
		KIND_ORDER_FORMAT = Format.STRINGLIST;
		
		IDX_LABEL_LOCATION = NNVariationalAutoencoderEvaluator.getPropNumber() + 10;
		IDX_LABEL_LOCATION_TAG = 'IDX_LABEL_LOCATION';
		IDX_LABEL_LOCATION_CATEGORY = Category.PARAMETER;
		IDX_LABEL_LOCATION_FORMAT = Format.SCALAR;
		
		LOCATION_ORDER = NNVariationalAutoencoderEvaluator.getPropNumber() + 11;
		LOCATION_ORDER_TAG = 'LOCATION_ORDER';
		LOCATION_ORDER_CATEGORY = Category.QUERY;
		LOCATION_ORDER_FORMAT = Format.STRINGLIST;
		
		LOCATION_ALIAS_FROM = NNVariationalAutoencoderEvaluator.getPropNumber() + 12;
		LOCATION_ALIAS_FROM_TAG = 'LOCATION_ALIAS_FROM';
		LOCATION_ALIAS_FROM_CATEGORY = Category.PARAMETER;
		LOCATION_ALIAS_FROM_FORMAT = Format.STRINGLIST;
		
		LOCATION_ALIAS_TO = NNVariationalAutoencoderEvaluator.getPropNumber() + 13;
		LOCATION_ALIAS_TO_TAG = 'LOCATION_ALIAS_TO';
		LOCATION_ALIAS_TO_CATEGORY = Category.PARAMETER;
		LOCATION_ALIAS_TO_FORMAT = Format.STRINGLIST;
		
		LATENT_REP = NNVariationalAutoencoderEvaluator.getPropNumber() + 14;
		LATENT_REP_TAG = 'LATENT_REP';
		LATENT_REP_CATEGORY = Category.RESULT;
		LATENT_REP_FORMAT = Format.CELL;
		
		PREDICT_DECODER = NNVariationalAutoencoderEvaluator.getPropNumber() + 15;
		PREDICT_DECODER_TAG = 'PREDICT_DECODER';
		PREDICT_DECODER_CATEGORY = Category.QUERY;
		PREDICT_DECODER_FORMAT = Format.EMPTY;
		
		CROSSING = NNVariationalAutoencoderEvaluator.getPropNumber() + 16;
		CROSSING_TAG = 'CROSSING';
		CROSSING_CATEGORY = Category.QUERY;
		CROSSING_FORMAT = Format.CELL;
		
		RESOLUTION_CM = NNVariationalAutoencoderEvaluator.getPropNumber() + 17;
		RESOLUTION_CM_TAG = 'RESOLUTION_CM';
		RESOLUTION_CM_CATEGORY = Category.PARAMETER;
		RESOLUTION_CM_FORMAT = Format.SCALAR;
		
		MERGE_CLOSE_PEAKS = NNVariationalAutoencoderEvaluator.getPropNumber() + 18;
		MERGE_CLOSE_PEAKS_TAG = 'MERGE_CLOSE_PEAKS';
		MERGE_CLOSE_PEAKS_CATEGORY = Category.QUERY;
		MERGE_CLOSE_PEAKS_FORMAT = Format.MATRIX;
		
		DERIV_PEAKS = NNVariationalAutoencoderEvaluator.getPropNumber() + 19;
		DERIV_PEAKS_TAG = 'DERIV_PEAKS';
		DERIV_PEAKS_CATEGORY = Category.QUERY;
		DERIV_PEAKS_FORMAT = Format.CELL;
		
		PEAKS_COMPARE = NNVariationalAutoencoderEvaluator.getPropNumber() + 20;
		PEAKS_COMPARE_TAG = 'PEAKS_COMPARE';
		PEAKS_COMPARE_CATEGORY = Category.QUERY;
		PEAKS_COMPARE_FORMAT = Format.CELL;
		
		DERIV_PEAKS_RUN = NNVariationalAutoencoderEvaluator.getPropNumber() + 21;
		DERIV_PEAKS_RUN_TAG = 'DERIV_PEAKS_RUN';
		DERIV_PEAKS_RUN_CATEGORY = Category.QUERY;
		DERIV_PEAKS_RUN_FORMAT = Format.CELL;
		
		DERIV_PEAKS_SAVE = NNVariationalAutoencoderEvaluator.getPropNumber() + 22;
		DERIV_PEAKS_SAVE_TAG = 'DERIV_PEAKS_SAVE';
		DERIV_PEAKS_SAVE_CATEGORY = Category.QUERY;
		DERIV_PEAKS_SAVE_FORMAT = Format.CELL;
		
		LATENT_IDENTIFICATION = NNVariationalAutoencoderEvaluator.getPropNumber() + 23;
		LATENT_IDENTIFICATION_TAG = 'LATENT_IDENTIFICATION';
		LATENT_IDENTIFICATION_CATEGORY = Category.QUERY;
		LATENT_IDENTIFICATION_FORMAT = Format.EMPTY;
		
		DATA_RECONSTRUCTION = NNVariationalAutoencoderEvaluator.getPropNumber() + 24;
		DATA_RECONSTRUCTION_TAG = 'DATA_RECONSTRUCTION';
		DATA_RECONSTRUCTION_CATEGORY = Category.QUERY;
		DATA_RECONSTRUCTION_FORMAT = Format.EMPTY;
		
		PEAK_IDENTIFICATION = NNVariationalAutoencoderEvaluator.getPropNumber() + 25;
		PEAK_IDENTIFICATION_TAG = 'PEAK_IDENTIFICATION';
		PEAK_IDENTIFICATION_CATEGORY = Category.QUERY;
		PEAK_IDENTIFICATION_FORMAT = Format.EMPTY;
		
		DIRECTORY_ANALYSIS = NNVariationalAutoencoderEvaluator.getPropNumber() + 26;
		DIRECTORY_ANALYSIS_TAG = 'DIRECTORY_ANALYSIS';
		DIRECTORY_ANALYSIS_CATEGORY = Category.DATA;
		DIRECTORY_ANALYSIS_FORMAT = Format.STRING;
		
		DIRECTORY_FIG = NNVariationalAutoencoderEvaluator.getPropNumber() + 27;
		DIRECTORY_FIG_TAG = 'DIRECTORY_FIG';
		DIRECTORY_FIG_CATEGORY = Category.DATA;
		DIRECTORY_FIG_FORMAT = Format.STRING;
		
		DIRECTORY_UTIL_R = NNVariationalAutoencoderEvaluator.getPropNumber() + 28;
		DIRECTORY_UTIL_R_TAG = 'DIRECTORY_UTIL_R';
		DIRECTORY_UTIL_R_CATEGORY = Category.DATA;
		DIRECTORY_UTIL_R_FORMAT = Format.STRING;
		
		CREATE_R_CONTAINER = NNVariationalAutoencoderEvaluator.getPropNumber() + 29;
		CREATE_R_CONTAINER_TAG = 'CREATE_R_CONTAINER';
		CREATE_R_CONTAINER_CATEGORY = Category.QUERY;
		CREATE_R_CONTAINER_FORMAT = Format.CELL;
		
		PLOT_R_PALETTE = NNVariationalAutoencoderEvaluator.getPropNumber() + 30;
		PLOT_R_PALETTE_TAG = 'PLOT_R_PALETTE';
		PLOT_R_PALETTE_CATEGORY = Category.QUERY;
		PLOT_R_PALETTE_FORMAT = Format.EMPTY;
		
		PLOT_R_LS_QNORM_MED = NNVariationalAutoencoderEvaluator.getPropNumber() + 31;
		PLOT_R_LS_QNORM_MED_TAG = 'PLOT_R_LS_QNORM_MED';
		PLOT_R_LS_QNORM_MED_CATEGORY = Category.QUERY;
		PLOT_R_LS_QNORM_MED_FORMAT = Format.EMPTY;
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
			
			subclass_list = subclasses('NNVariationalAutoencoderEvaluator_RS', [], [], true);
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
			
			if nargin == 0
				prop_list = [ ...
					NNVariationalAutoencoderEvaluator.getProps() ...
						NNVariationalAutoencoderEvaluator_RS.DPROC ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND ...
						NNVariationalAutoencoderEvaluator_RS.KIND_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO ...
						NNVariationalAutoencoderEvaluator_RS.LATENT_REP ...
						NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER ...
						NNVariationalAutoencoderEvaluator_RS.CROSSING ...
						NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM ...
						NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS ...
						NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE ...
						NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION ...
						NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION ...
						NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R ...
						NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER ...
						NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE ...
						NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED ...
						];
				return
			end
			
			switch category
				case Category.CONSTANT
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.CONSTANT) ...
						];
				case Category.METADATA
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.METADATA) ...
						];
				case Category.PARAMETER
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.PARAMETER) ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND ...
						NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO ...
						NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM ...
						];
				case Category.DATA
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.DATA) ...
						NNVariationalAutoencoderEvaluator_RS.DPROC ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG ...
						NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R ...
						];
				case Category.RESULT
					prop_list = [
						NNVariationalAutoencoderEvaluator.getProps(Category.RESULT) ...
						NNVariationalAutoencoderEvaluator_RS.LATENT_REP ...
						];
				case Category.QUERY
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.QUERY) ...
						NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.KIND_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER ...
						NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER ...
						NNVariationalAutoencoderEvaluator_RS.CROSSING ...
						NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS ...
						NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN ...
						NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE ...
						NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION ...
						NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION ...
						NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION ...
						NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER ...
						NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE ...
						NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED ...
						];
				case Category.EVANESCENT
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.EVANESCENT) ...
						];
				case Category.FIGURE
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.FIGURE) ...
						];
				case Category.GUI
					prop_list = [ ...
						NNVariationalAutoencoderEvaluator.getProps(Category.GUI) ...
						];
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
			
			prop_number = numel(NNVariationalAutoencoderEvaluator_RS.getProps(varargin{:}));
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
			
			check = any(prop == NNVariationalAutoencoderEvaluator_RS.getProps());
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT '\n' ...
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
			
			nnvariationalautoencoderevaluator_rs_tag_list = cellfun(@(x) NNVariationalAutoencoderEvaluator_RS.getPropTag(x), num2cell(NNVariationalAutoencoderEvaluator_RS.getProps()), 'UniformOutput', false);
			check = any(strcmp(tag, nnvariationalautoencoderevaluator_rs_tag_list));
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT '\n' ...
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
				nnvariationalautoencoderevaluator_rs_tag_list = cellfun(@(x) NNVariationalAutoencoderEvaluator_RS.getPropTag(x), num2cell(NNVariationalAutoencoderEvaluator_RS.getProps()), 'UniformOutput', false);
				prop = find(strcmp(pointer, nnvariationalautoencoderevaluator_rs_tag_list)); % tag = pointer
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
				prop = pointer;
				
				switch prop
					case NNVariationalAutoencoderEvaluator_RS.DPROC
						tag = NNVariationalAutoencoderEvaluator_RS.DPROC_TAG;
					case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
						tag = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS_TAG;
					case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
						tag = NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER_TAG;
					case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
						tag = NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ_TAG;
					case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
						tag = NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL_TAG;
					case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
						tag = NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR_TAG;
					case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
						tag = NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE_TAG;
					case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
						tag = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND_TAG;
					case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
						tag = NNVariationalAutoencoderEvaluator_RS.KIND_ORDER_TAG;
					case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
						tag = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION_TAG;
					case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
						tag = NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER_TAG;
					case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
						tag = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM_TAG;
					case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
						tag = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO_TAG;
					case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
						tag = NNVariationalAutoencoderEvaluator_RS.LATENT_REP_TAG;
					case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
						tag = NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER_TAG;
					case NNVariationalAutoencoderEvaluator_RS.CROSSING
						tag = NNVariationalAutoencoderEvaluator_RS.CROSSING_TAG;
					case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
						tag = NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM_TAG;
					case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
						tag = NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
						tag = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_TAG;
					case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
						tag = NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
						tag = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
						tag = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE_TAG;
					case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
						tag = NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
						tag = NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION_TAG;
					case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
						tag = NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
						tag = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
						tag = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG_TAG;
					case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
						tag = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R_TAG;
					case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
						tag = NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER_TAG;
					case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
						tag = NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE_TAG;
					case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
						tag = NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED_TAG;
					otherwise
						tag = getPropTag@NNVariationalAutoencoderEvaluator(prop);
				end
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
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_category = NNVariationalAutoencoderEvaluator_RS.DPROC_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_category = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_category = NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_category = NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_category = NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_category = NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_category = NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_category = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_category = NNVariationalAutoencoderEvaluator_RS.KIND_ORDER_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_category = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_category = NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_category = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_category = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_category = NNVariationalAutoencoderEvaluator_RS.LATENT_REP_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_category = NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_category = NNVariationalAutoencoderEvaluator_RS.CROSSING_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_category = NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_category = NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_category = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_category = NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_category = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_category = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_category = NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_category = NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_category = NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_category = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_category = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_category = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_category = NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_category = NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE_CATEGORY;
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_category = NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED_CATEGORY;
				otherwise
					prop_category = getPropCategory@NNVariationalAutoencoderEvaluator(prop);
			end
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
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_format = NNVariationalAutoencoderEvaluator_RS.DPROC_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_format = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_format = NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_format = NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_format = NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_format = NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_format = NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_format = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_format = NNVariationalAutoencoderEvaluator_RS.KIND_ORDER_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_format = NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_format = NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_format = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_format = NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_format = NNVariationalAutoencoderEvaluator_RS.LATENT_REP_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_format = NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_format = NNVariationalAutoencoderEvaluator_RS.CROSSING_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_format = NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_format = NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_format = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_format = NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_format = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_format = NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_format = NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_format = NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_format = NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_format = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_format = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_format = NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_format = NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_format = NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE_FORMAT;
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_format = NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED_FORMAT;
				otherwise
					prop_format = getPropFormat@NNVariationalAutoencoderEvaluator(prop);
			end
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
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_description = 'DPROC (data, item) is the Raman-spectra dataset process used for inverse normalisation/transform during decoding.';
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_description = 'IDX_LABEL_STRESS (parameter, scalar) is the row index in TARGET_CLASS corresponding to stress.';
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_description = 'STRESS_ORDER (query, stringlist) returns the unique stress tokens present in LATENT_REP in stable order.';
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_description = 'STRESS_SEQ (parameter, stringlist) is the canonical plotting order of stresses used for export and R figures.';
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_description = 'STRESS_LABEL (parameter, stringlist) are human-readable stress labels aligned with STRESS_SEQ.';
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_description = 'STRESS_COLOUR (parameter, stringlist) are hex colours aligned with STRESS_SEQ.';
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_description = 'STRESS_SHAPE (parameter, stringlist) are point shapes aligned with STRESS_SEQ.';
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_description = 'IDX_LABEL_KIND (parameter, scalar) is the row index in TARGET_CLASS corresponding to species/kind.';
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_description = 'KIND_ORDER (query, stringlist) returns the unique species/kind tokens present in LATENT_REP in stable order.';
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_description = 'IDX_LABEL_LOCATION (parameter, scalar) is the row index in TARGET_CLASS corresponding to location.';
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_description = 'LOCATION_ORDER (query, stringlist) returns the unique location tokens present in LATENT_REP in stable order.';
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_description = 'LOCATION_ALIAS_FROM (parameter, stringlist) lists source location labels to be replaced during export.';
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_description = 'LOCATION_ALIAS_TO (parameter, stringlist) lists target location labels used to replace LOCATION_ALIAS_FROM; it must have the same length as LOCATION_ALIAS_FROM.';
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_description = 'LATENT_REP (result, cell) stores {Z, Y} where Z are latent representations and Y are label vectors aligned to Z for downstream analyses.';
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_description = 'PREDICT_DECODER (query, empty) decodes selected latent vectors to spectra and returns a 1xN cell of column vectors (options: one-to-one/median/mean; inverse normalisation/transform toggles).';
				case NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_description = 'CROSSING (query, cell) returns {ind, t0, s0} for level crossings of S at level with interpolation method and direction.';
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_description = 'RESOLUTION_CM (parameter, scalar) is the instrument resolution in cm^-1 used to merge nearby peaks.';
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_description = 'MERGE_CLOSE_PEAKS (query, matrix) merges ranked peaks closer than the instrument resolution in cm^-1.';
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_description = 'DERIV_PEAKS (query, cell) returns {PEAKS_TABLE, PEAKS_RANKED_BY_AREA, ind_p2n, ind_all, area, peak_wavs} from p→n zero-crossings of the derivative spectrum.';
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_description = 'PEAKS_COMPARE (query, cell) returns pairwise peak-area differences between two conditions with integer-wavenumber matching tolerance.';
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_description = 'DERIV_PEAKS_RUN (query, cell) returns {COND, COMP} by running DERIV_PEAKS per condition and all pairwise comparisons.';
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_description = 'DERIV_PEAKS_SAVE (query, cell) saves per-condition ranked tables and pairwise ranked differences using legacy-compatible filenames.';
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_description = 'LATENT_IDENTIFICATION (query, empty) exports per-species×location latent cells z1/z2 and ranges aligned with STRESS_SEQ for the R plotting pipeline.';
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_description = 'DATA_RECONSTRUCTION (query, empty) decodes median spectra per stress for each species×location and saves R-ready .mat files.';
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_description = 'PEAK_IDENTIFICATION (query, empty) decodes per species, detects derivative peaks per stress, runs all pairwise comparisons, and saves ranked tables.';
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_description = 'DIRECTORY_ANALYSIS (data, string) is the directory where intermediate .mat files and analysis outputs are saved.';
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_description = 'DIRECTORY_FIG (data, string) is the directory where figures are exported.';
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_description = 'DIRECTORY_UTIL_R (data, string) is the directory containing the R scripts and Dockerfile used for plotting.';
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_description = 'CREATE_R_CONTAINER (query, cell) ensures the plotting Docker image exists and returns {image_tag}.';
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_description = 'PLOT_R_PALETTE (query, empty) generates palette figures via Docker+R (generic_fig_palette_p1.R) after preparing latent, reconstruction, and identification outputs.';
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_description = 'PLOT_R_LS_QNORM_MED (query, empty) plots latent-space qnorm (median) via Docker+R (generic_plot_ls_qnorm_med.R) after preparing required .mat inputs.';
				case NNVariationalAutoencoderEvaluator_RS.ELCLASS
					prop_description = 'ELCLASS (constant, string) is the class of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.NAME
					prop_description = 'NAME (constant, string) is the name of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.DESCRIPTION
					prop_description = 'DESCRIPTION (constant, string) is the description of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.TEMPLATE
					prop_description = 'TEMPLATE (parameter, item) is the template of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.ID
					prop_description = 'ID (data, string) is a few-letter code of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.LABEL
					prop_description = 'LABEL (metadata, string) is an extended label of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.NOTES
					prop_description = 'NOTES (metadata, string) are specific notes of the variational-autoencoder evaluator for Raman spectra.';
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER
					prop_description = 'PREDICT_ENCODER (query, cell) returns {Z, Y} where Z are latent means (one column per data point) and Y are corresponding label vectors from D via the minibatch queue.';
				otherwise
					prop_description = getPropDescription@NNVariationalAutoencoderEvaluator(prop);
			end
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
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_settings = 'NNDatasetProcess_RamanSpectra';
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_settings = Format.getFormatSettings(Format.MATRIX);
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_settings = Format.getFormatSettings(Format.STRING);
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_settings = Format.getFormatSettings(Format.STRING);
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_settings = Format.getFormatSettings(Format.STRING);
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_settings = Format.getFormatSettings(Format.EMPTY);
				case NNVariationalAutoencoderEvaluator_RS.TEMPLATE
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
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC
					prop_default = Format.getFormatDefault(Format.ITEM, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_default = 2;
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_default = Format.getFormatDefault(Format.STRINGLIST, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ
					prop_default = {'HL', 'WL', 'LL', 'SH'};
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL
					prop_default = {'High light', 'White light', 'Low light', 'Shade'};
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR
					prop_default = {'#E64B35FF', '#7E6148FF', '#4DBBD5FF', '#3C5488FF'};
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE
					prop_default = {'square', 'circle', 'triangle', 'diamond'};
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND
					prop_default = 1;
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER
					prop_default = Format.getFormatDefault(Format.STRINGLIST, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION
					prop_default = 3;
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER
					prop_default = Format.getFormatDefault(Format.STRINGLIST, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM
					prop_default = {};
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO
					prop_default = {};
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM
					prop_default = 6;
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS
					prop_default = Format.getFormatDefault(Format.MATRIX, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS
					prop_default = fileparts(which('test_braph2'));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG
					prop_default = fileparts(which('test_braph2'));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R
					prop_default = fileparts(which('test_braph2'));
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER
					prop_default = Format.getFormatDefault(Format.CELL, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED
					prop_default = Format.getFormatDefault(Format.EMPTY, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.ELCLASS
					prop_default = 'NNVariationalAutoencoderEvaluator_RS';
				case NNVariationalAutoencoderEvaluator_RS.NAME
					prop_default = 'Neural Network Evaluator';
				case NNVariationalAutoencoderEvaluator_RS.DESCRIPTION
					prop_default = 'A variational-autoencoder evaluator (NNVariationalAutoencoderEvaluator_RS) evaluates a trained model on a specific dataset, producing latent representations, decoded spectra, peak analyses, and Docker-backed R figures for Raman-spectra workflows. Instances of this class should not be created directly—use one of its subclasses.';
				case NNVariationalAutoencoderEvaluator_RS.TEMPLATE
					prop_default = Format.getFormatDefault(Format.ITEM, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.ID
					prop_default = 'NNEvaluator ID';
				case NNVariationalAutoencoderEvaluator_RS.LABEL
					prop_default = 'NNEvaluator label';
				case NNVariationalAutoencoderEvaluator_RS.NOTES
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
			%  Error id: €BRAPH2.STR€:NNVariationalAutoencoderEvaluator_RS:€BRAPH2.WRONG_INPUT€
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNE.
			%   Error id: €BRAPH2.STR€:NNVariationalAutoencoderEvaluator_RS:€BRAPH2.WRONG_INPUT€
			%  Element.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RS.
			%   Error id: €BRAPH2.STR€:NNVariationalAutoencoderEvaluator_RS:€BRAPH2.WRONG_INPUT€
			%  NNE.CHECKPROP(NNVariationalAutoencoderEvaluator_RS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RS.
			%   Error id: €BRAPH2.STR€:NNVariationalAutoencoderEvaluator_RS:€BRAPH2.WRONG_INPUT€]
			% 
			% Note that the Element.CHECKPROP(NNE) and Element.CHECKPROP('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoderEvaluator_RS.getPropProp(pointer);
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.DPROC % __NNVariationalAutoencoderEvaluator_RS.DPROC__
					check = Format.checkFormat(Format.ITEM, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS % __NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS__
					check = Format.checkFormat(Format.SCALAR, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER % __NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ % __NNVariationalAutoencoderEvaluator_RS.STRESS_SEQ__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL % __NNVariationalAutoencoderEvaluator_RS.STRESS_LABEL__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR % __NNVariationalAutoencoderEvaluator_RS.STRESS_COLOUR__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE % __NNVariationalAutoencoderEvaluator_RS.STRESS_SHAPE__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND % __NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_KIND__
					check = Format.checkFormat(Format.SCALAR, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER % __NNVariationalAutoencoderEvaluator_RS.KIND_ORDER__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION % __NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_LOCATION__
					check = Format.checkFormat(Format.SCALAR, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER % __NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM % __NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_FROM__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO % __NNVariationalAutoencoderEvaluator_RS.LOCATION_ALIAS_TO__
					check = Format.checkFormat(Format.STRINGLIST, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP % __NNVariationalAutoencoderEvaluator_RS.LATENT_REP__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER % __NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.CROSSING % __NNVariationalAutoencoderEvaluator_RS.CROSSING__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM % __NNVariationalAutoencoderEvaluator_RS.RESOLUTION_CM__
					check = Format.checkFormat(Format.SCALAR, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS % __NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS__
					check = Format.checkFormat(Format.MATRIX, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE % __NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION % __NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION % __NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION % __NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS % __NNVariationalAutoencoderEvaluator_RS.DIRECTORY_ANALYSIS__
					check = Format.checkFormat(Format.STRING, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG % __NNVariationalAutoencoderEvaluator_RS.DIRECTORY_FIG__
					check = Format.checkFormat(Format.STRING, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R % __NNVariationalAutoencoderEvaluator_RS.DIRECTORY_UTIL_R__
					check = Format.checkFormat(Format.STRING, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER % __NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER__
					check = Format.checkFormat(Format.CELL, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE % __NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED % __NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED__
					check = Format.checkFormat(Format.EMPTY, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case NNVariationalAutoencoderEvaluator_RS.TEMPLATE % __NNVariationalAutoencoderEvaluator_RS.TEMPLATE__
					check = Format.checkFormat(Format.ITEM, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				otherwise
					if prop <= NNVariationalAutoencoderEvaluator.getPropNumber()
						check = checkProp@NNVariationalAutoencoderEvaluator(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNVariationalAutoencoderEvaluator_RS:' BRAPH2.WRONG_INPUT '\n' ...
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
			%  PROP. It works only with properties with Category.RESULT,
			%  Category.QUERY, and Category.EVANESCENT. By default this function
			%  returns the default value for the prop and should be implemented in the
			%  subclasses of Element when needed.
			%
			% VALUE = CALCULATEVALUE(EL, PROP, VARARGIN) works with properties with
			%  Category.QUERY.
			%
			% See also getPropDefaultConditioned, conditioning, preset, checkProp,
			%  postset, postprocessing, checkValue.
			
			switch prop
				case NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER % __NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER__
					idx = nne.get('IDX_LABEL_STRESS');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case NNVariationalAutoencoderEvaluator_RS.KIND_ORDER % __NNVariationalAutoencoderEvaluator_RS.KIND_ORDER__
					idx = nne.get('IDX_LABEL_KIND');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER % __NNVariationalAutoencoderEvaluator_RS.LOCATION_ORDER__
					idx = nne.get('IDX_LABEL_LOCATION');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
				case NNVariationalAutoencoderEvaluator_RS.LATENT_REP % __NNVariationalAutoencoderEvaluator_RS.LATENT_REP__
					rng_settings_ = rng(); rng(nne.getPropSeed(NNVariationalAutoencoderEvaluator_RS.LATENT_REP), 'twister')
					
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
					
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER % __NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER__
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
					
				case NNVariationalAutoencoderEvaluator_RS.CROSSING % __NNVariationalAutoencoderEvaluator_RS.CROSSING__
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
					
				case NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS % __NNVariationalAutoencoderEvaluator_RS.MERGE_CLOSE_PEAKS__
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
					
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS__
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
					
				case NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE % __NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE__
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
					
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN__
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
					
				case NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE % __NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE__
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
					
				case NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION % __NNVariationalAutoencoderEvaluator_RS.LATENT_IDENTIFICATION__
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
					
				case NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION % __NNVariationalAutoencoderEvaluator_RS.DATA_RECONSTRUCTION__
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
					
				case NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION % __NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION__
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
					
				case NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER % __NNVariationalAutoencoderEvaluator_RS.CREATE_R_CONTAINER__
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
					
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE % __NNVariationalAutoencoderEvaluator_RS.PLOT_R_PALETTE__
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
					    ['{\bf\color{orange}' BRAPH2.STR '}'] % note to use double slashes to avoid genesis problem
					    ['{\color{gray}version ' BRAPH2.VERSION '}']
					    ['{\color{gray}build ' int2str(BRAPH2.BUILD) '}']
					    ''
					    'The figures are generated and exported using the R script.'
					    'Please, check the exported figures in the output directory.'
					    ''
					    ''};
					braph2msgbox(title, message)
					
					value = {};
					
				case NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED % __NNVariationalAutoencoderEvaluator_RS.PLOT_R_LS_QNORM_MED__
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
					    ['{\bf\color{orange}' BRAPH2.STR '}'] % note to use double slashes to avoid genesis problem
					    ['{\color{gray}version ' BRAPH2.VERSION '}']
					    ['{\color{gray}build ' int2str(BRAPH2.BUILD) '}']
					    ''
					    'The figures are generated and exported using the R script.'
					    'Please, check the exported figures in the output directory.'
					    ''
					    ''};
					braph2msgbox(title, message)
					
					value = {};
					
				case NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER % __NNVariationalAutoencoderEvaluator_RS.PREDICT_ENCODER__
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
					if prop <= NNVariationalAutoencoderEvaluator.getPropNumber()
						value = calculateValue@NNVariationalAutoencoderEvaluator(nne, prop, varargin{:});
					else
						value = calculateValue@Element(nne, prop, varargin{:});
					end
			end
			
		end
	end
end
