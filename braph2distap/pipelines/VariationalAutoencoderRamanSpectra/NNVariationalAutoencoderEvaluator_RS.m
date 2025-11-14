classdef NNVariationalAutoencoderEvaluator_RS < NNVariationalAutoencoderEvaluator
	%NNVariationalAutoencoderEvaluator_RS evaluates the performance of a trained neural network model with a dataset.
	% It is a subclass of <a href="matlab:help NNVariationalAutoencoderEvaluator">NNVariationalAutoencoderEvaluator</a>.
	%
	% A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset.
	% Instances of this class should not be created. Use one of its subclasses instead.
	% Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.
	%
	% The list of NNVariationalAutoencoderEvaluator_RS properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the evaluator for the neural network analysis.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code for the evaluator for the neural network analysis.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network model.
	%  <strong>10</strong> <strong>D</strong> 	D (data, item) is the dataset to evaluate the neural network model.
	%  <strong>11</strong> <strong>PLOT_LATENT_REPRESENTATIONS</strong> 	PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.
	%  <strong>12</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
	%  <strong>13</strong> <strong>IDX_LABEL_STRESS</strong> 	IDX_LABEL_STRESS (parameter, scalar) row-index in TARGET_CLASS for stress.
	%  <strong>14</strong> <strong>STRESS_ORDER</strong> 	STRESS_ORDER (result, stringlist) canonical order for output.
	%  <strong>15</strong> <strong>IDX_LABEL_SPECIES</strong> 	IDX_LABEL_SPECIES (parameter, scalar) row-index in TARGET_CLASS for species.
	%  <strong>16</strong> <strong>SPECIES_ORDER</strong> 	SPECIES_ORDER (result, stringlist) canonical order for output.
	%  <strong>17</strong> <strong>LATENT_REP</strong> 	LATENT_REP (result, cell) stores the latent representations for further processing.
	%  <strong>18</strong> <strong>PREDICT_DECODER</strong> 	PREDICT_DECODER (query, empty) indentifies the index when crossing from negative to positive.
	%  <strong>19</strong> <strong>CROSSING</strong> 	CROSSING (query, cell) returns indices/times of level crossings.
	%  <strong>20</strong> <strong>DERIV_PEAKS</strong> 	DERIV_PEAKS (query, cell) finds p→n zero-crossing peaks in f′(x) and lobe areas.
	%  <strong>21</strong> <strong>PEAKS_COMPARE</strong> 	PEAKS_COMPARE (query, cell) compares per-peak areas between two conditions.
	%  <strong>22</strong> <strong>DERIV_PEAKS_RUN</strong> 	DERIV_PEAKS_RUN (query, cell) runs DERIV_PEAKS for all conditions and compares all pairs.
	%  <strong>23</strong> <strong>DERIV_PEAKS_SAVE</strong> 	DERIV_PEAKS_SAVE (query, cell) saves ranked tables (legacy-compatible filenames).
	%  <strong>24</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (query, empty) runs decoding → peaks → save per species.
	%  <strong>25</strong> <strong>DIRECTORY</strong> 	DIRECTORY (data, string) is the directory saving the exporting figure.
	%  <strong>26</strong> <strong>PLOT_R_LATENT_REPRESENTATIONS</strong> 	PLOT_R_LATENT_REPRESENTATIONS (query, empty) indentifies the index when crossing from negative to positive.
	%  <strong>27</strong> <strong>PLOT_R_PEAK_IDENTIFICATIONS</strong> 	PLOT_R_PEAK_IDENTIFICATIONS (query, empty) indentifies the index when crossing from negative to positive.
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
	%  tostring - string with information about the neural network evaluator
	%  disp - displays information about the neural network evaluator
	%  tree - displays the tree of the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RS methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two neural network evaluator are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RS methods (save/load, Static):
	%  save - saves BRAPH2 neural network evaluator as b2 file
	%  load - loads a BRAPH2 neural network evaluator from a b2 file
	%
	% NNVariationalAutoencoderEvaluator_RS method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RS method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RS methods (inspection, Static):
	%  getClass - returns the class of the neural network evaluator
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoderEvaluator_RS
	%  getProps - returns the property list of the neural network evaluator
	%  getPropNumber - returns the property number of the neural network evaluator
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
	% See also NNDataPoint, NNDataset, NNBase.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		IDX_LABEL_STRESS = 13; %CET: Computational Efficiency Trick
		IDX_LABEL_STRESS_TAG = 'IDX_LABEL_STRESS';
		IDX_LABEL_STRESS_CATEGORY = 3;
		IDX_LABEL_STRESS_FORMAT = 11;
		
		STRESS_ORDER = 14; %CET: Computational Efficiency Trick
		STRESS_ORDER_TAG = 'STRESS_ORDER';
		STRESS_ORDER_CATEGORY = 5;
		STRESS_ORDER_FORMAT = 3;
		
		IDX_LABEL_SPECIES = 15; %CET: Computational Efficiency Trick
		IDX_LABEL_SPECIES_TAG = 'IDX_LABEL_SPECIES';
		IDX_LABEL_SPECIES_CATEGORY = 3;
		IDX_LABEL_SPECIES_FORMAT = 11;
		
		SPECIES_ORDER = 16; %CET: Computational Efficiency Trick
		SPECIES_ORDER_TAG = 'SPECIES_ORDER';
		SPECIES_ORDER_CATEGORY = 5;
		SPECIES_ORDER_FORMAT = 3;
		
		LATENT_REP = 17; %CET: Computational Efficiency Trick
		LATENT_REP_TAG = 'LATENT_REP';
		LATENT_REP_CATEGORY = 5;
		LATENT_REP_FORMAT = 16;
		
		PREDICT_DECODER = 18; %CET: Computational Efficiency Trick
		PREDICT_DECODER_TAG = 'PREDICT_DECODER';
		PREDICT_DECODER_CATEGORY = 6;
		PREDICT_DECODER_FORMAT = 1;
		
		CROSSING = 19; %CET: Computational Efficiency Trick
		CROSSING_TAG = 'CROSSING';
		CROSSING_CATEGORY = 6;
		CROSSING_FORMAT = 16;
		
		DERIV_PEAKS = 20; %CET: Computational Efficiency Trick
		DERIV_PEAKS_TAG = 'DERIV_PEAKS';
		DERIV_PEAKS_CATEGORY = 6;
		DERIV_PEAKS_FORMAT = 16;
		
		PEAKS_COMPARE = 21; %CET: Computational Efficiency Trick
		PEAKS_COMPARE_TAG = 'PEAKS_COMPARE';
		PEAKS_COMPARE_CATEGORY = 6;
		PEAKS_COMPARE_FORMAT = 16;
		
		DERIV_PEAKS_RUN = 22; %CET: Computational Efficiency Trick
		DERIV_PEAKS_RUN_TAG = 'DERIV_PEAKS_RUN';
		DERIV_PEAKS_RUN_CATEGORY = 6;
		DERIV_PEAKS_RUN_FORMAT = 16;
		
		DERIV_PEAKS_SAVE = 23; %CET: Computational Efficiency Trick
		DERIV_PEAKS_SAVE_TAG = 'DERIV_PEAKS_SAVE';
		DERIV_PEAKS_SAVE_CATEGORY = 6;
		DERIV_PEAKS_SAVE_FORMAT = 16;
		
		PEAK_IDENTIFICATION = 24; %CET: Computational Efficiency Trick
		PEAK_IDENTIFICATION_TAG = 'PEAK_IDENTIFICATION';
		PEAK_IDENTIFICATION_CATEGORY = 6;
		PEAK_IDENTIFICATION_FORMAT = 1;
		
		DIRECTORY = 25; %CET: Computational Efficiency Trick
		DIRECTORY_TAG = 'DIRECTORY';
		DIRECTORY_CATEGORY = 4;
		DIRECTORY_FORMAT = 2;
		
		PLOT_R_LATENT_REPRESENTATIONS = 26; %CET: Computational Efficiency Trick
		PLOT_R_LATENT_REPRESENTATIONS_TAG = 'PLOT_R_LATENT_REPRESENTATIONS';
		PLOT_R_LATENT_REPRESENTATIONS_CATEGORY = 6;
		PLOT_R_LATENT_REPRESENTATIONS_FORMAT = 1;
		
		PLOT_R_PEAK_IDENTIFICATIONS = 27; %CET: Computational Efficiency Trick
		PLOT_R_PEAK_IDENTIFICATIONS_TAG = 'PLOT_R_PEAK_IDENTIFICATIONS';
		PLOT_R_PEAK_IDENTIFICATIONS_CATEGORY = 6;
		PLOT_R_PEAK_IDENTIFICATIONS_FORMAT = 1;
	end
	methods % constructor
		function nne = NNVariationalAutoencoderEvaluator_RS(varargin)
			%NNVariationalAutoencoderEvaluator_RS() creates a neural network evaluator.
			%
			% NNVariationalAutoencoderEvaluator_RS(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoderEvaluator_RS(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoderEvaluator_RS properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the evaluator for the neural network analysis.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code for the evaluator for the neural network analysis.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network model.
			%  <strong>10</strong> <strong>D</strong> 	D (data, item) is the dataset to evaluate the neural network model.
			%  <strong>11</strong> <strong>PLOT_LATENT_REPRESENTATIONS</strong> 	PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.
			%  <strong>12</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
			%  <strong>13</strong> <strong>IDX_LABEL_STRESS</strong> 	IDX_LABEL_STRESS (parameter, scalar) row-index in TARGET_CLASS for stress.
			%  <strong>14</strong> <strong>STRESS_ORDER</strong> 	STRESS_ORDER (result, stringlist) canonical order for output.
			%  <strong>15</strong> <strong>IDX_LABEL_SPECIES</strong> 	IDX_LABEL_SPECIES (parameter, scalar) row-index in TARGET_CLASS for species.
			%  <strong>16</strong> <strong>SPECIES_ORDER</strong> 	SPECIES_ORDER (result, stringlist) canonical order for output.
			%  <strong>17</strong> <strong>LATENT_REP</strong> 	LATENT_REP (result, cell) stores the latent representations for further processing.
			%  <strong>18</strong> <strong>PREDICT_DECODER</strong> 	PREDICT_DECODER (query, empty) indentifies the index when crossing from negative to positive.
			%  <strong>19</strong> <strong>CROSSING</strong> 	CROSSING (query, cell) returns indices/times of level crossings.
			%  <strong>20</strong> <strong>DERIV_PEAKS</strong> 	DERIV_PEAKS (query, cell) finds p→n zero-crossing peaks in f′(x) and lobe areas.
			%  <strong>21</strong> <strong>PEAKS_COMPARE</strong> 	PEAKS_COMPARE (query, cell) compares per-peak areas between two conditions.
			%  <strong>22</strong> <strong>DERIV_PEAKS_RUN</strong> 	DERIV_PEAKS_RUN (query, cell) runs DERIV_PEAKS for all conditions and compares all pairs.
			%  <strong>23</strong> <strong>DERIV_PEAKS_SAVE</strong> 	DERIV_PEAKS_SAVE (query, cell) saves ranked tables (legacy-compatible filenames).
			%  <strong>24</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (query, empty) runs decoding → peaks → save per species.
			%  <strong>25</strong> <strong>DIRECTORY</strong> 	DIRECTORY (data, string) is the directory saving the exporting figure.
			%  <strong>26</strong> <strong>PLOT_R_LATENT_REPRESENTATIONS</strong> 	PLOT_R_LATENT_REPRESENTATIONS (query, empty) indentifies the index when crossing from negative to positive.
			%  <strong>27</strong> <strong>PLOT_R_PEAK_IDENTIFICATIONS</strong> 	PLOT_R_PEAK_IDENTIFICATIONS (query, empty) indentifies the index when crossing from negative to positive.
			%
			% See also Category, Format.
			
			nne = nne@NNVariationalAutoencoderEvaluator(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the neural network evaluator.
			%
			% BUILD = NNVariationalAutoencoderEvaluator_RS.GETBUILD() returns the build of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNE.GETBUILD() returns the build of the neural network evaluator NNE.
			%  BUILD = Element.GETBUILD(NNE) returns the build of 'NNE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoderEvaluator_RS') returns the build of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETBUILD(NNE) and Element.GETBUILD('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nne_class = getClass()
			%GETCLASS returns the class of the neural network evaluator.
			%
			% CLASS = NNVariationalAutoencoderEvaluator_RS.GETCLASS() returns the class 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNE.GETCLASS() returns the class of the neural network evaluator NNE.
			%  CLASS = Element.GETCLASS(NNE) returns the class of 'NNE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoderEvaluator_RS') returns 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETCLASS(NNE) and Element.GETCLASS('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			
			nne_class = 'NNVariationalAutoencoderEvaluator_RS';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the neural network evaluator.
			%
			% LIST = NNVariationalAutoencoderEvaluator_RS.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNE.GETSUBCLASSES() returns all subclasses of the neural network evaluator NNE.
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
			%GETPROPS returns the property list of neural network evaluator.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RS.GETPROPS() returns the property list of neural network evaluator
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RS.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNE.GETPROPS([CATEGORY]) returns the property list of the neural network evaluator NNE.
			%  PROPS = Element.GETPROPS(NNE[, CATEGORY]) returns the property list of 'NNE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoderEvaluator_RS'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETPROPS(NNE) and Element.GETPROPS('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = [4 13 15];
				case 4 % Category.DATA
					prop_list = [5 9 10 25];
				case 5 % Category.RESULT
					prop_list = [14 16 17];
				case 6 % Category.QUERY
					prop_list = [8 11 12 18 19 20 21 22 23 24 26 27];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoderEvaluator_RS.GETPROPNUMBER() returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoderEvaluator_RS.GETPROPNUMBER(CATEGORY) returns the property number of neural network evaluator
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNE.GETPROPNUMBER([CATEGORY]) returns the property number of the neural network evaluator NNE.
			%  N = Element.GETPROPNUMBER(NNE) returns the property number of 'NNE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RS') returns the property number of 'NNVariationalAutoencoderEvaluator_RS'.
			%
			% Note that the Element.GETPROPNUMBER(NNE) and Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RS')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 27;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 3;
				case 4 % Category.DATA
					prop_number = 4;
				case 5 % Category.RESULT
					prop_number = 3;
				case 6 % Category.QUERY
					prop_number = 12;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in neural network evaluator/error.
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
			
			check = prop >= 1 && prop <= 27 && round(prop) == prop; %CET: Computational Efficiency Trick
			
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
			%EXISTSTAG checks whether tag exists in neural network evaluator/error.
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
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'IDX_LABEL_SPECIES'  'SPECIES_ORDER'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'PEAK_IDENTIFICATION'  'DIRECTORY'  'PLOT_R_LATENT_REPRESENTATIONS'  'PLOT_R_PEAK_IDENTIFICATIONS' })); %CET: Computational Efficiency Trick
			
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
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'IDX_LABEL_SPECIES'  'SPECIES_ORDER'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'PEAK_IDENTIFICATION'  'DIRECTORY'  'PLOT_R_LATENT_REPRESENTATIONS'  'PLOT_R_PEAK_IDENTIFICATIONS' })); % tag = pointer %CET: Computational Efficiency Trick
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
				nnvariationalautoencoderevaluator_rs_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'IDX_LABEL_STRESS'  'STRESS_ORDER'  'IDX_LABEL_SPECIES'  'SPECIES_ORDER'  'LATENT_REP'  'PREDICT_DECODER'  'CROSSING'  'DERIV_PEAKS'  'PEAKS_COMPARE'  'DERIV_PEAKS_RUN'  'DERIV_PEAKS_SAVE'  'PEAK_IDENTIFICATION'  'DIRECTORY'  'PLOT_R_LATENT_REPRESENTATIONS'  'PLOT_R_PEAK_IDENTIFICATIONS' };
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
			nnvariationalautoencoderevaluator_rs_category_list = { 1  1  1  3  4  2  2  6  4  4  6  6  3  5  3  5  5  6  6  6  6  6  6  6  4  6  6 };
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
			nnvariationalautoencoderevaluator_rs_format_list = { 2  2  2  8  2  2  2  2  8  8  1  16  11  3  11  3  16  1  16  16  16  16  16  1  2  1  1 };
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
			nnvariationalautoencoderevaluator_rs_description_list = { 'ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.'  'NAME (constant, string) is the name of the evaluator for the neural network analysis.'  'DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.'  'TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.'  'ID (data, string) is a few-letter code for the evaluator for the neural network analysis.'  'LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.'  'NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'NN (data, item) contains a trained neural network model.'  'D (data, item) is the dataset to evaluate the neural network model.'  'PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.'  'PREDICT_ENCODER (query, cell) returns the predictions of an encoder.'  'IDX_LABEL_STRESS (parameter, scalar) row-index in TARGET_CLASS for stress.'  'STRESS_ORDER (result, stringlist) canonical order for output.'  'IDX_LABEL_SPECIES (parameter, scalar) row-index in TARGET_CLASS for species.'  'SPECIES_ORDER (result, stringlist) canonical order for output.'  'LATENT_REP (result, cell) stores the latent representations for further processing.'  'PREDICT_DECODER (query, empty) indentifies the index when crossing from negative to positive.'  'CROSSING (query, cell) returns indices/times of level crossings.'  'DERIV_PEAKS (query, cell) finds p→n zero-crossing peaks in f′(x) and lobe areas.'  'PEAKS_COMPARE (query, cell) compares per-peak areas between two conditions.'  'DERIV_PEAKS_RUN (query, cell) runs DERIV_PEAKS for all conditions and compares all pairs.'  'DERIV_PEAKS_SAVE (query, cell) saves ranked tables (legacy-compatible filenames).'  'PEAK_IDENTIFICATION (query, empty) runs decoding → peaks → save per species.'  'DIRECTORY (data, string) is the directory saving the exporting figure.'  'PLOT_R_LATENT_REPRESENTATIONS (query, empty) indentifies the index when crossing from negative to positive.'  'PLOT_R_PEAK_IDENTIFICATIONS (query, empty) indentifies the index when crossing from negative to positive.' };
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
				case 13 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_settings = Format.getFormatSettings(11);
				case 14 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_settings = Format.getFormatSettings(3);
				case 15 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_SPECIES
					prop_settings = Format.getFormatSettings(11);
				case 16 % NNVariationalAutoencoderEvaluator_RS.SPECIES_ORDER
					prop_settings = Format.getFormatSettings(3);
				case 17 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_settings = Format.getFormatSettings(16);
				case 18 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_settings = Format.getFormatSettings(1);
				case 19 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_settings = Format.getFormatSettings(16);
				case 20 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_settings = Format.getFormatSettings(16);
				case 21 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_settings = Format.getFormatSettings(16);
				case 22 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_settings = Format.getFormatSettings(16);
				case 23 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_settings = Format.getFormatSettings(16);
				case 24 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_settings = Format.getFormatSettings(1);
				case 25 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY
					prop_settings = Format.getFormatSettings(2);
				case 26 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LATENT_REPRESENTATIONS
					prop_settings = Format.getFormatSettings(1);
				case 27 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PEAK_IDENTIFICATIONS
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
				case 13 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					prop_default = 2;
				case 14 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					prop_default = Format.getFormatDefault(3, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 15 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_SPECIES
					prop_default = 1;
				case 16 % NNVariationalAutoencoderEvaluator_RS.SPECIES_ORDER
					prop_default = Format.getFormatDefault(3, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 17 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 18 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 19 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 20 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 21 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 22 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 23 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 24 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 25 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY
					prop_default = fileparts(which('test_braph2'));
				case 26 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LATENT_REPRESENTATIONS
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 27 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PEAK_IDENTIFICATIONS
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 1 % NNVariationalAutoencoderEvaluator_RS.ELCLASS
					prop_default = 'NNVariationalAutoencoderEvaluator_RS';
				case 2 % NNVariationalAutoencoderEvaluator_RS.NAME
					prop_default = 'Neural Network Evaluator';
				case 3 % NNVariationalAutoencoderEvaluator_RS.DESCRIPTION
					prop_default = 'A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset. Instances of this class should not be created. Use one of its subclasses instead. Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.';
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
				case 13 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_STRESS
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 14 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 15 % NNVariationalAutoencoderEvaluator_RS.IDX_LABEL_SPECIES
					check = Format.checkFormat(11, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 16 % NNVariationalAutoencoderEvaluator_RS.SPECIES_ORDER
					check = Format.checkFormat(3, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 17 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 18 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 19 % NNVariationalAutoencoderEvaluator_RS.CROSSING
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 20 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 21 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 22 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 23 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
					check = Format.checkFormat(16, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 24 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 25 % NNVariationalAutoencoderEvaluator_RS.DIRECTORY
					check = Format.checkFormat(2, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 26 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_LATENT_REPRESENTATIONS
					check = Format.checkFormat(1, value, NNVariationalAutoencoderEvaluator_RS.getPropSettings(prop));
				case 27 % NNVariationalAutoencoderEvaluator_RS.PLOT_R_PEAK_IDENTIFICATIONS
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
				case 14 % NNVariationalAutoencoderEvaluator_RS.STRESS_ORDER
					rng_settings_ = rng(); rng(nne.getPropSeed(14), 'twister')
					
					idx = nne.get('IDX_LABEL_STRESS');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
					rng(rng_settings_)
					
				case 16 % NNVariationalAutoencoderEvaluator_RS.SPECIES_ORDER
					rng_settings_ = rng(); rng(nne.getPropSeed(16), 'twister')
					
					idx = nne.get('IDX_LABEL_SPECIES');
					latent_rep = nne.get('LATENT_REP');
					YLatent = latent_rep{2};
					value = unique(string(cellfun(@(ind_labels) string(ind_labels(idx)), YLatent, 'UniformOutput', false)));
					
					rng(rng_settings_)
					
				case 17 % NNVariationalAutoencoderEvaluator_RS.LATENT_REP
					rng_settings_ = rng(); rng(nne.getPropSeed(17), 'twister')
					
					nnvae = nne.get('NN');
					netE = nnvae.get('ENCODER');
					d = nne.get('D');
					mbq = nnvae.get('MBQ', d);
					
					value = nne.get('PREDICT_ENCODER', netE, mbq);
					
					rng(rng_settings_)
					
				case 18 % NNVariationalAutoencoderEvaluator_RS.PREDICT_DECODER
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
					
				case 19 % NNVariationalAutoencoderEvaluator_RS.CROSSING
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
					
				case 20 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS
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
					
				case 21 % NNVariationalAutoencoderEvaluator_RS.PEAKS_COMPARE
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
					
				case 22 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_RUN
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
					
				case 23 % NNVariationalAutoencoderEvaluator_RS.DERIV_PEAKS_SAVE
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
					
				case 24 % NNVariationalAutoencoderEvaluator_RS.PEAK_IDENTIFICATION
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
