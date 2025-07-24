classdef NNVariationalAutoencoders_Structured < NNVariationalAutoencoders
	%NNVariationalAutoencoders_Structured transfroms neural network datasets.
	% It is a subclass of <a href="matlab:help NNVariationalAutoencoders">NNVariationalAutoencoders</a>.
	%
	% A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
	% The resulting combined dataset contains all the unique datapoints from the input datasets, 
	% and any overlapping datapoints are excluded to ensure data consistency.
	%
	% The list of NNVariationalAutoencoders_Structured properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.
	%  <strong>10</strong> <strong>DP_CLASSES</strong> 	DP_CLASSES (parameter, classlist) is the list of compatible data points.
	%  <strong>11</strong> <strong>EPOCHS</strong> 	EPOCHS (parameter, scalar) is the maximum number of epochs.
	%  <strong>12</strong> <strong>BATCH</strong> 	BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.
	%  <strong>13</strong> <strong>SHUFFLE</strong> 	SHUFFLE (parameter, option) is an option for data shuffling.
	%  <strong>14</strong> <strong>SOLVER</strong> 	SOLVER (parameter, option) is an option for the solver.
	%  <strong>15</strong> <strong>MODEL</strong> 	MODEL (result, net) is a trained neural network model with the given dataset.
	%  <strong>16</strong> <strong>INPUTS</strong> 	INPUTS (query, cell) constructs the cell array of the data.
	%  <strong>17</strong> <strong>TARGETS</strong> 	TARGETS (query, stringlist) constructs the cell array of the targets.
	%  <strong>18</strong> <strong>TRAIN</strong> 	TRAIN (query, empty) trains the neural network model with the given dataset.
	%  <strong>19</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display training progress information.
	%  <strong>20</strong> <strong>PLOT_TRAINING</strong> 	PLOT_TRAINING (metadata, option) determines whether to plot the training progress.
	%  <strong>21</strong> <strong>PREDICT</strong> 	PREDICT (query, cell) returns the predictions of the trained neural network for a dataset.
	%  <strong>22</strong> <strong>LEARN_RATE</strong> 	LEARN_RATE (parameter, scalar) is the size of the mini-batch used for each training iteration.
	%  <strong>23</strong> <strong>NUM_LATENT_REP</strong> 	NUM_LATENT_REP (parameter, scalar) is the size of the mini-batch used for each training iteration.
	%  <strong>24</strong> <strong>SIZE_IMG</strong> 	SIZE_IMG (parameter, rvector) is the size of the input image.
	%  <strong>25</strong> <strong>ENCODER</strong> 	ENCODER (data, net) is a trained neural network encoder with the given dataset.
	%  <strong>26</strong> <strong>DECODER</strong> 	DECODER (data, net) is a trained neural network decoder with the given dataset.
	%  <strong>27</strong> <strong>ELBO_LOSS</strong> 	ELBO_LOSS (query, scalar) returns the elbo loss.
	%  <strong>28</strong> <strong>SIZE_INPUT</strong> 	SIZE_INPUT (parameter, rvector) is the size of the input data.
	%
	% NNVariationalAutoencoders_Structured methods (constructor):
	%  NNVariationalAutoencoders_Structured - constructor
	%
	% NNVariationalAutoencoders_Structured methods:
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
	% NNVariationalAutoencoders_Structured methods (display):
	%  tostring - string with information about the normalizer of a neural network data
	%  disp - displays information about the normalizer of a neural network data
	%  tree - displays the tree of the normalizer of a neural network data
	%
	% NNVariationalAutoencoders_Structured methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two normalizer of a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the normalizer of a neural network data
	%
	% NNVariationalAutoencoders_Structured methods (save/load, Static):
	%  save - saves BRAPH2 normalizer of a neural network data as b2 file
	%  load - loads a BRAPH2 normalizer of a neural network data from a b2 file
	%
	% NNVariationalAutoencoders_Structured method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoders_Structured method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoders_Structured methods (inspection, Static):
	%  getClass - returns the class of the normalizer of a neural network data
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoders_Structured
	%  getProps - returns the property list of the normalizer of a neural network data
	%  getPropNumber - returns the property number of the normalizer of a neural network data
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
	% NNVariationalAutoencoders_Structured methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoders_Structured methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoders_Structured methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoders_Structured methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoders_Structured; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoders_Structured constants</a>.
	%
	%
	% See also NNDataset, NNDatasetSplit.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		SIZE_INPUT = 28; %CET: Computational Efficiency Trick
		SIZE_INPUT_TAG = 'SIZE_INPUT';
		SIZE_INPUT_CATEGORY = 3;
		SIZE_INPUT_FORMAT = 12;
	end
	methods % constructor
		function nnvae = NNVariationalAutoencoders_Structured(varargin)
			%NNVariationalAutoencoders_Structured() creates a normalizer of a neural network data.
			%
			% NNVariationalAutoencoders_Structured(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoders_Structured(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoders_Structured properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.
			%  <strong>10</strong> <strong>DP_CLASSES</strong> 	DP_CLASSES (parameter, classlist) is the list of compatible data points.
			%  <strong>11</strong> <strong>EPOCHS</strong> 	EPOCHS (parameter, scalar) is the maximum number of epochs.
			%  <strong>12</strong> <strong>BATCH</strong> 	BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.
			%  <strong>13</strong> <strong>SHUFFLE</strong> 	SHUFFLE (parameter, option) is an option for data shuffling.
			%  <strong>14</strong> <strong>SOLVER</strong> 	SOLVER (parameter, option) is an option for the solver.
			%  <strong>15</strong> <strong>MODEL</strong> 	MODEL (result, net) is a trained neural network model with the given dataset.
			%  <strong>16</strong> <strong>INPUTS</strong> 	INPUTS (query, cell) constructs the cell array of the data.
			%  <strong>17</strong> <strong>TARGETS</strong> 	TARGETS (query, stringlist) constructs the cell array of the targets.
			%  <strong>18</strong> <strong>TRAIN</strong> 	TRAIN (query, empty) trains the neural network model with the given dataset.
			%  <strong>19</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display training progress information.
			%  <strong>20</strong> <strong>PLOT_TRAINING</strong> 	PLOT_TRAINING (metadata, option) determines whether to plot the training progress.
			%  <strong>21</strong> <strong>PREDICT</strong> 	PREDICT (query, cell) returns the predictions of the trained neural network for a dataset.
			%  <strong>22</strong> <strong>LEARN_RATE</strong> 	LEARN_RATE (parameter, scalar) is the size of the mini-batch used for each training iteration.
			%  <strong>23</strong> <strong>NUM_LATENT_REP</strong> 	NUM_LATENT_REP (parameter, scalar) is the size of the mini-batch used for each training iteration.
			%  <strong>24</strong> <strong>SIZE_IMG</strong> 	SIZE_IMG (parameter, rvector) is the size of the input image.
			%  <strong>25</strong> <strong>ENCODER</strong> 	ENCODER (data, net) is a trained neural network encoder with the given dataset.
			%  <strong>26</strong> <strong>DECODER</strong> 	DECODER (data, net) is a trained neural network decoder with the given dataset.
			%  <strong>27</strong> <strong>ELBO_LOSS</strong> 	ELBO_LOSS (query, scalar) returns the elbo loss.
			%  <strong>28</strong> <strong>SIZE_INPUT</strong> 	SIZE_INPUT (parameter, rvector) is the size of the input data.
			%
			% See also Category, Format.
			
			nnvae = nnvae@NNVariationalAutoencoders(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the normalizer of a neural network data.
			%
			% BUILD = NNVariationalAutoencoders_Structured.GETBUILD() returns the build of 'NNVariationalAutoencoders_Structured'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNVAE.GETBUILD() returns the build of the normalizer of a neural network data NNVAE.
			%  BUILD = Element.GETBUILD(NNVAE) returns the build of 'NNVAE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoders_Structured') returns the build of 'NNVariationalAutoencoders_Structured'.
			%
			% Note that the Element.GETBUILD(NNVAE) and Element.GETBUILD('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nnvae_class = getClass()
			%GETCLASS returns the class of the normalizer of a neural network data.
			%
			% CLASS = NNVariationalAutoencoders_Structured.GETCLASS() returns the class 'NNVariationalAutoencoders_Structured'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNVAE.GETCLASS() returns the class of the normalizer of a neural network data NNVAE.
			%  CLASS = Element.GETCLASS(NNVAE) returns the class of 'NNVAE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoders_Structured') returns 'NNVariationalAutoencoders_Structured'.
			%
			% Note that the Element.GETCLASS(NNVAE) and Element.GETCLASS('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			
			nnvae_class = 'NNVariationalAutoencoders_Structured';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the normalizer of a neural network data.
			%
			% LIST = NNVariationalAutoencoders_Structured.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoders_Structured'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNVAE.GETSUBCLASSES() returns all subclasses of the normalizer of a neural network data NNVAE.
			%  LIST = Element.GETSUBCLASSES(NNVAE) returns all subclasses of 'NNVAE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoders_Structured') returns all subclasses of 'NNVariationalAutoencoders_Structured'.
			%
			% Note that the Element.GETSUBCLASSES(NNVAE) and Element.GETSUBCLASSES('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoders_Structured' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of normalizer of a neural network data.
			%
			% PROPS = NNVariationalAutoencoders_Structured.GETPROPS() returns the property list of normalizer of a neural network data
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoders_Structured.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNVAE.GETPROPS([CATEGORY]) returns the property list of the normalizer of a neural network data NNVAE.
			%  PROPS = Element.GETPROPS(NNVAE[, CATEGORY]) returns the property list of 'NNVAE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoders_Structured'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoders_Structured'.
			%
			% Note that the Element.GETPROPS(NNVAE) and Element.GETPROPS('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7 20];
				case 3 % Category.PARAMETER
					prop_list = [4 10 11 12 13 14 22 23 24 28];
				case 4 % Category.DATA
					prop_list = [5 9 25 26];
				case 5 % Category.RESULT
					prop_list = 15;
				case 6 % Category.QUERY
					prop_list = [8 16 17 18 21 27];
				case 9 % Category.GUI
					prop_list = 19;
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of normalizer of a neural network data.
			%
			% N = NNVariationalAutoencoders_Structured.GETPROPNUMBER() returns the property number of normalizer of a neural network data.
			%
			% N = NNVariationalAutoencoders_Structured.GETPROPNUMBER(CATEGORY) returns the property number of normalizer of a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNVAE.GETPROPNUMBER([CATEGORY]) returns the property number of the normalizer of a neural network data NNVAE.
			%  N = Element.GETPROPNUMBER(NNVAE) returns the property number of 'NNVAE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoders_Structured') returns the property number of 'NNVariationalAutoencoders_Structured'.
			%
			% Note that the Element.GETPROPNUMBER(NNVAE) and Element.GETPROPNUMBER('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 28;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 3;
				case 3 % Category.PARAMETER
					prop_number = 10;
				case 4 % Category.DATA
					prop_number = 4;
				case 5 % Category.RESULT
					prop_number = 1;
				case 6 % Category.QUERY
					prop_number = 6;
				case 9 % Category.GUI
					prop_number = 1;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in normalizer of a neural network data/error.
			%
			% CHECK = NNVariationalAutoencoders_Structured.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSPROP(PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVAE, PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoders_Structured, PROP) checks whether PROP exists for NNVariationalAutoencoders_Structured.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%  Element.EXISTSPROP(NNVAE, PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoders_Structured, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoders_Structured.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNVAE) and Element.EXISTSPROP('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 28 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoders_Structured.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in normalizer of a neural network data/error.
			%
			% CHECK = NNVariationalAutoencoders_Structured.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSTAG(TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVAE, TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoders_Structured, TAG) checks whether TAG exists for NNVariationalAutoencoders_Structured.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%  Element.EXISTSTAG(NNVAE, TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoders_Structured, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoders_Structured.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNVAE) and Element.EXISTSTAG('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS'  'SIZE_INPUT' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoders_Structured.'] ...
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
			%  PROPERTY = NNVAE.GETPROPPROP(POINTER) returns property number of POINTER of NNVAE.
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoders_Structured, POINTER) returns property number of POINTER of NNVariationalAutoencoders_Structured.
			%  PROPERTY = NNVAE.GETPROPPROP(NNVariationalAutoencoders_Structured, POINTER) returns property number of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPPROP(NNVAE) and Element.GETPROPPROP('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS'  'SIZE_INPUT' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = NNVAE.GETPROPTAG(POINTER) returns tag of POINTER of NNVAE.
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoders_Structured, POINTER) returns tag of POINTER of NNVariationalAutoencoders_Structured.
			%  TAG = NNVAE.GETPROPTAG(NNVariationalAutoencoders_Structured, POINTER) returns tag of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPTAG(NNVAE) and Element.GETPROPTAG('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoders_structured_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS'  'SIZE_INPUT' };
				tag = nnvariationalautoencoders_structured_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = NNVAE.GETPROPCATEGORY(POINTER) returns category of POINTER of NNVAE.
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoders_Structured, POINTER) returns category of POINTER of NNVariationalAutoencoders_Structured.
			%  CATEGORY = NNVAE.GETPROPCATEGORY(NNVariationalAutoencoders_Structured, POINTER) returns category of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPCATEGORY(NNVAE) and Element.GETPROPCATEGORY('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_structured_category_list = { 1  1  1  3  4  2  2  6  4  3  3  3  3  3  5  6  6  6  9  2  6  3  3  3  4  4  6  3 };
			prop_category = nnvariationalautoencoders_structured_category_list{prop};
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
			%  FORMAT = NNVAE.GETPROPFORMAT(POINTER) returns format of POINTER of NNVAE.
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoders_Structured, POINTER) returns format of POINTER of NNVariationalAutoencoders_Structured.
			%  FORMAT = NNVAE.GETPROPFORMAT(NNVariationalAutoencoders_Structured, POINTER) returns format of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPFORMAT(NNVAE) and Element.GETPROPFORMAT('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_structured_format_list = { 2  2  2  8  2  2  2  2  8  7  11  11  5  5  17  16  16  1  4  5  16  11  11  12  17  17  11  12 };
			prop_format = nnvariationalautoencoders_structured_format_list{prop};
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
			%  DESCRIPTION = NNVAE.GETPROPDESCRIPTION(POINTER) returns description of POINTER of NNVAE.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoders_Structured, POINTER) returns description of POINTER of NNVariationalAutoencoders_Structured.
			%  DESCRIPTION = NNVAE.GETPROPDESCRIPTION(NNVariationalAutoencoders_Structured, POINTER) returns description of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNVAE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_structured_description_list = { 'ELCLASS (constant, string) is the class of the combiner of neural networks datasets.'  'NAME (constant, string) is the name of the combiner of neural networks datasets.'  'DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.'  'TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.'  'ID (data, string) is a few-letter code of the combiner of neural networks datasets.'  'LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.'  'NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.'  'DP_CLASSES (parameter, classlist) is the list of compatible data points.'  'EPOCHS (parameter, scalar) is the maximum number of epochs.'  'BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SHUFFLE (parameter, option) is an option for data shuffling.'  'SOLVER (parameter, option) is an option for the solver.'  'MODEL (result, net) is a trained neural network model with the given dataset.'  'INPUTS (query, cell) constructs the cell array of the data.'  'TARGETS (query, stringlist) constructs the cell array of the targets.'  'TRAIN (query, empty) trains the neural network model with the given dataset.'  'VERBOSE (gui, logical) is an indicator to display training progress information.'  'PLOT_TRAINING (metadata, option) determines whether to plot the training progress.'  'PREDICT (query, cell) returns the predictions of the trained neural network for a dataset.'  'LEARN_RATE (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'NUM_LATENT_REP (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SIZE_IMG (parameter, rvector) is the size of the input image.'  'ENCODER (data, net) is a trained neural network encoder with the given dataset.'  'DECODER (data, net) is a trained neural network decoder with the given dataset.'  'ELBO_LOSS (query, scalar) returns the elbo loss.'  'SIZE_INPUT (parameter, rvector) is the size of the input data.' };
			prop_description = nnvariationalautoencoders_structured_description_list{prop};
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
			%  SETTINGS = NNVAE.GETPROPSETTINGS(POINTER) returns settings of POINTER of NNVAE.
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoders_Structured, POINTER) returns settings of POINTER of NNVariationalAutoencoders_Structured.
			%  SETTINGS = NNVAE.GETPROPSETTINGS(NNVariationalAutoencoders_Structured, POINTER) returns settings of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPSETTINGS(NNVAE) and Element.GETPROPSETTINGS('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 28 % NNVariationalAutoencoders_Structured.SIZE_INPUT
					prop_settings = Format.getFormatSettings(12);
				case 4 % NNVariationalAutoencoders_Structured.TEMPLATE
					prop_settings = 'NNVariationalAutoencoders_Structured';
				case 9 % NNVariationalAutoencoders_Structured.D
					prop_settings = 'NNDataset';
				otherwise
					prop_settings = getPropSettings@NNVariationalAutoencoders(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders_Structured.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders_Structured.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoders_Structured, POINTER) returns the default value of POINTER of NNVariationalAutoencoders_Structured.
			%  DEFAULT = NNVAE.GETPROPDEFAULT(NNVariationalAutoencoders_Structured, POINTER) returns the default value of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPDEFAULT(NNVAE) and Element.GETPROPDEFAULT('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 28 % NNVariationalAutoencoders_Structured.SIZE_INPUT
					prop_default = [1000 1];
				case 1 % NNVariationalAutoencoders_Structured.ELCLASS
					prop_default = 'NNVariationalAutoencoders_Structured';
				case 2 % NNVariationalAutoencoders_Structured.NAME
					prop_default = 'Neural Network Variational Autoencoders';
				case 3 % NNVariationalAutoencoders_Structured.DESCRIPTION
					prop_default = 'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.';
				case 4 % NNVariationalAutoencoders_Structured.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoders_Structured.getPropSettings(prop));
				case 5 % NNVariationalAutoencoders_Structured.ID
					prop_default = 'NNDatasetCombine ID';
				case 6 % NNVariationalAutoencoders_Structured.LABEL
					prop_default = 'NNDatasetCombine label';
				case 7 % NNVariationalAutoencoders_Structured.NOTES
					prop_default = 'NNDatasetCombine notes';
				case 9 % NNVariationalAutoencoders_Structured.D
					prop_default = NNDataset('DP_CLASS', 'NNDataPoint');
				case 10 % NNVariationalAutoencoders_Structured.DP_CLASSES
					prop_default = {'NNDataPoint' 'NNDataPoint_SpectrumSignal'};
				otherwise
					prop_default = getPropDefault@NNVariationalAutoencoders(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders_Structured.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders_Structured.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders_Structured, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders_Structured.
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders_Structured, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders_Structured.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNVAE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoders_Structured.conditioning(prop, NNVariationalAutoencoders_Structured.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = NNVAE.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = NNVAE.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of NNVAE.
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoders_Structured, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders_Structured.
			%  CHECK = NNVAE.CHECKPROP(NNVariationalAutoencoders_Structured, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders_Structured.
			% 
			% NNVAE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoders_Structured:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNVAE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNVAE.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Structured:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoders_Structured, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders_Structured.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Structured:WrongInput
			%  NNVAE.CHECKPROP(NNVariationalAutoencoders_Structured, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders_Structured.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Structured:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNVAE) and Element.CHECKPROP('NNVariationalAutoencoders_Structured')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoders_Structured.getPropProp(pointer);
			
			switch prop
				case 28 % NNVariationalAutoencoders_Structured.SIZE_INPUT
					check = Format.checkFormat(12, value, NNVariationalAutoencoders_Structured.getPropSettings(prop));
				case 4 % NNVariationalAutoencoders_Structured.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoders_Structured.getPropSettings(prop));
				case 9 % NNVariationalAutoencoders_Structured.D
					check = Format.checkFormat(8, value, NNVariationalAutoencoders_Structured.getPropSettings(prop));
				otherwise
					if prop <= 27
						check = checkProp@NNVariationalAutoencoders(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Structured:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoders_Structured.getPropTag(prop) ' (' NNVariationalAutoencoders_Structured.getFormatTag(NNVariationalAutoencoders_Structured.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
	methods (Access=protected) % postset
		function postset(nnvae, prop)
			%POSTSET postprocessing after a prop has been set.
			%
			% POSTPROCESSING(EL, PROP) postprocessesing after PROP has been set. By
			%  default, this function does not do anything, so it should be implemented
			%  in the subclasses of Element when needed.
			%
			% This postprocessing occurs only when PROP is set.
			%
			% See also conditioning, preset, checkProp, postprocessing, calculateValue,
			%  checkValue.
			
			switch prop
				case 9 % NNVariationalAutoencoders_Structured.D
					if ~isequal(nnvae.get('D').get('DP_DICT').get('LENGTH'), 0)
					    input_data = cell2mat(nnvae.get('D').get('DP_DICT').get('IT', 1).get('INPUT'));
					    % % % if isequal(length(size(input_data)), 2) % only 1 channel
					    % % %     size_img = [size(input_data) 1]; % force it to be length, width, channel
					    % % % else
					    % % %     size_img = size(input_data);
					    % % % end
					    size_input = size(input_data);
					    nnvae.set('SIZE_INPUT', size_input);
					end
					if isa(nnvae.getr('ENCODER'), 'NoValue')
					    numLatentChannels = nnvae.get('NUM_LATENT_REP');
					    inputSize = nnvae.get('SIZE_INPUT');
					    numFeature = prod(inputSize);
					
					    layersE = [
					        featureInputLayer(numFeature, Normalization="none")
					        fullyConnectedLayer(64)
					        reluLayer
					        fullyConnectedLayer(2*numLatentChannels, 'Name', 'latentOuput')
					        samplingLayer];
					
					    nnvae.set('ENCODER', dlnetwork(layersE));
					end
					if isa(nnvae.getr('DECODER'), 'NoValue')
					    % Calculate projection size
					    inputSize = nnvae.get('SIZE_INPUT');
					    numFeature = prod(inputSize);
					    numLatentChannels = nnvae.get('NUM_LATENT_REP');
					
					    layersD = [
					        featureInputLayer(numLatentChannels, Normalization="none")
					        fullyConnectedLayer(64)
					        reluLayer
					        fullyConnectedLayer(numFeature)
					        leakyReluLayer(1)];
					
					    nnvae.set('DECODER', dlnetwork(layersD));
					end
					
				otherwise
					if prop <= 27
						postset@NNVariationalAutoencoders(nnvae, prop);
					end
			end
		end
	end
	methods (Access=protected) % calculate value
		function value = calculateValue(nnvae, prop, varargin)
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
				case 16 % NNVariationalAutoencoders_Structured.INPUTS
					% inputs = nn.get('inputs', D) returns a cell array with the
					%  inputs for all data points in dataset D.
					if isempty(varargin)
					    value = {};
					    return
					end
					d = varargin{1};
					inputs_group = d.get('INPUTS');
					if isempty(inputs_group)
					    value = {};
					else
					    [s1, s2] = size(cell2mat(inputs_group{1}));
					    % Extract the 28x28 arrays from the inner cells
					    flat_cells = cellfun(@(c) c{1}, inputs_group, 'UniformOutput', false);
					    value = reshape(cat(1, flat_cells{:}), s1, []);
					end
					
				case 17 % NNVariationalAutoencoders_Structured.TARGETS
					% targets = nn.get('PREDICT', D) returns a cell array with the
					%  targets for all data points in dataset D.
					if isempty(varargin)
					    value = {};
					    return
					end
					d = varargin{1};
					targets = cellfun(@(dp) dp.get('TARGET_CLASS'), d.get('DP_DICT').get('IT_LIST'), 'UniformOutput', false)
					if isempty(targets)
					    value = {};
					else
					    flat_cells = cellfun(@(c) c{:}, targets, 'UniformOutput', false);
					    value = cat(1, flat_cells{:}); % check
					end
					
				case 18 % NNVariationalAutoencoders_Structured.TRAIN
					numEpochs = nnvae.get('EPOCHS');
					miniBatchSize = nnvae.get('BATCH');
					learnRate = nnvae.get('LEARN_RATE');
					
					d = nnvae.get('D');
					if isequal(d.get('DP_DICT').get('LENGTH'), 0)
					    value = [];
					    return
					end
					
					XTrain = nnvae.get('INPUTS', d);
					YTrain = 1:1:size(XTrain, 2);
					YTrain = YTrain';
					
					dsXTrain = arrayDatastore(XTrain, IterationDimension=2); % need to be a property the iterationdimension
					dsYTrain = arrayDatastore(YTrain);
					dsTrain = combine(dsXTrain, dsYTrain);
					
					numOutputs = 2; % need to be a property
					
					% need to be a query
					mbq = minibatchqueue(dsTrain,numOutputs, ...
					    MiniBatchSize = miniBatchSize, ...
					    MiniBatchFcn=@preprocessMiniBatch, ...
					    MiniBatchFormat=["CB", ""], ...
					    PartialMiniBatch="discard");
					
					netD = nnvae.get('DECODER');
					netE = nnvae.get('ENCODER');
					
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
					        [loss,gradientsE,gradientsD] = dlfeval(@modelLoss, netE, netD,X);
					
					        % Update learnable parameters.
					        [netE,trailingAvgE,trailingAvgSqE] = adamupdate(netE, ...
					            gradientsE,trailingAvgE,trailingAvgSqE,iteration, learnRate);
					
					        [netD, trailingAvgD, trailingAvgSqD] = adamupdate(netD, ...
					            gradientsD,trailingAvgD,trailingAvgSqD,iteration, learnRate);
					
					        % Update the training progress monitor. 
					        recordMetrics(monitor,iteration,Loss=loss);
					        updateInfo(monitor,Epoch=epoch + " of " + numEpochs);
					        monitor.Progress = 100*iteration/numIterations;
					    end
					end
					nnvae.set('ENCODER', netE);
					nnvae.set('DECODER', netD);
					
					value = [];
					
				otherwise
					if prop <= 27
						value = calculateValue@NNVariationalAutoencoders(nnvae, prop, varargin{:});
					else
						value = calculateValue@Element(nnvae, prop, varargin{:});
					end
			end
			
			function [loss, gradientsE, gradientsD] = modelLoss(netE, netD, X) % need to be a property   
			    % Forward through encoder.
			    [Z,mu,logSigmaSq] = forward(netE,X);
			    
			    % Forward through decoder.
			    Y = forward(netD,Z);
			    
			    % Calculate loss and gradients.
			    loss = nnvae.get('ELBO_LOSS', Y, X, mu, logSigmaSq);
			    [gradientsE,gradientsD] = dlgradient(loss,netE.Learnables,netD.Learnables);
			end
			function [X, Y] = preprocessMiniBatch(XCell, YCell)    % need to be a property
			    % Concatenate.
			    X = cat(2, XCell{:});
			    
			    % Extract label data from cell and concatenate.
			    Y = cat(2, YCell{:});
			
			% Extract label data from cell and concatenate.
			Y = cat(2,YCell{:});
			end
		end
	end
	methods (Access=protected) % check value
		function [check, msg] = checkValue(nnvae, prop, value)
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
			msg = ['Error while checking ' tostring(nnvae) ' ' nnvae.getPropTag(prop) '.'];
			
			switch prop
				case 9 % NNVariationalAutoencoders_Structured.D
					check = ismember(value.get('DP_CLASS'), nnvae.get('DP_CLASSES'));
					
				otherwise
					if prop <= 27
						[check, msg] = checkValue@NNVariationalAutoencoders(nnvae, prop, value);
					end
			end
		end
	end
end
