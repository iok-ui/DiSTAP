classdef NNVariationalAutoencoders < NNBase
	%NNVariationalAutoencoders transfroms neural network datasets.
	% It is a subclass of <a href="matlab:help NNBase">NNBase</a>.
	%
	% A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
	% The resulting combined dataset contains all the unique datapoints from the input datasets, 
	% and any overlapping datapoints are excluded to ensure data consistency.
	%
	% The list of NNVariationalAutoencoders properties is:
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
	%  <strong>17</strong> <strong>TARGETS</strong> 	TARGETS (query, cell) constructs the cell array of the targets.
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
	%
	% NNVariationalAutoencoders methods (constructor):
	%  NNVariationalAutoencoders - constructor
	%
	% NNVariationalAutoencoders methods:
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
	% NNVariationalAutoencoders methods (display):
	%  tostring - string with information about the normalizer of a neural network data
	%  disp - displays information about the normalizer of a neural network data
	%  tree - displays the tree of the normalizer of a neural network data
	%
	% NNVariationalAutoencoders methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two normalizer of a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the normalizer of a neural network data
	%
	% NNVariationalAutoencoders methods (save/load, Static):
	%  save - saves BRAPH2 normalizer of a neural network data as b2 file
	%  load - loads a BRAPH2 normalizer of a neural network data from a b2 file
	%
	% NNVariationalAutoencoders method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoders method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoders methods (inspection, Static):
	%  getClass - returns the class of the normalizer of a neural network data
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoders
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
	% NNVariationalAutoencoders methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoders methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoders methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoders methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoders; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoders constants</a>.
	%
	%
	% See also NNDataset, NNDatasetSplit.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		LEARN_RATE = 22; %CET: Computational Efficiency Trick
		LEARN_RATE_TAG = 'LEARN_RATE';
		LEARN_RATE_CATEGORY = 3;
		LEARN_RATE_FORMAT = 11;
		
		NUM_LATENT_REP = 23; %CET: Computational Efficiency Trick
		NUM_LATENT_REP_TAG = 'NUM_LATENT_REP';
		NUM_LATENT_REP_CATEGORY = 3;
		NUM_LATENT_REP_FORMAT = 11;
		
		SIZE_IMG = 24; %CET: Computational Efficiency Trick
		SIZE_IMG_TAG = 'SIZE_IMG';
		SIZE_IMG_CATEGORY = 3;
		SIZE_IMG_FORMAT = 12;
		
		ENCODER = 25; %CET: Computational Efficiency Trick
		ENCODER_TAG = 'ENCODER';
		ENCODER_CATEGORY = 4;
		ENCODER_FORMAT = 17;
		
		DECODER = 26; %CET: Computational Efficiency Trick
		DECODER_TAG = 'DECODER';
		DECODER_CATEGORY = 4;
		DECODER_FORMAT = 17;
		
		ELBO_LOSS = 27; %CET: Computational Efficiency Trick
		ELBO_LOSS_TAG = 'ELBO_LOSS';
		ELBO_LOSS_CATEGORY = 6;
		ELBO_LOSS_FORMAT = 11;
	end
	methods % constructor
		function nnvae = NNVariationalAutoencoders(varargin)
			%NNVariationalAutoencoders() creates a normalizer of a neural network data.
			%
			% NNVariationalAutoencoders(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoders(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoders properties is:
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
			%  <strong>17</strong> <strong>TARGETS</strong> 	TARGETS (query, cell) constructs the cell array of the targets.
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
			%
			% See also Category, Format.
			
			nnvae = nnvae@NNBase(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the normalizer of a neural network data.
			%
			% BUILD = NNVariationalAutoencoders.GETBUILD() returns the build of 'NNVariationalAutoencoders'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNVAE.GETBUILD() returns the build of the normalizer of a neural network data NNVAE.
			%  BUILD = Element.GETBUILD(NNVAE) returns the build of 'NNVAE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoders') returns the build of 'NNVariationalAutoencoders'.
			%
			% Note that the Element.GETBUILD(NNVAE) and Element.GETBUILD('NNVariationalAutoencoders')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nnvae_class = getClass()
			%GETCLASS returns the class of the normalizer of a neural network data.
			%
			% CLASS = NNVariationalAutoencoders.GETCLASS() returns the class 'NNVariationalAutoencoders'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNVAE.GETCLASS() returns the class of the normalizer of a neural network data NNVAE.
			%  CLASS = Element.GETCLASS(NNVAE) returns the class of 'NNVAE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoders') returns 'NNVariationalAutoencoders'.
			%
			% Note that the Element.GETCLASS(NNVAE) and Element.GETCLASS('NNVariationalAutoencoders')
			%  are less computationally efficient.
			
			nnvae_class = 'NNVariationalAutoencoders';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the normalizer of a neural network data.
			%
			% LIST = NNVariationalAutoencoders.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoders'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNVAE.GETSUBCLASSES() returns all subclasses of the normalizer of a neural network data NNVAE.
			%  LIST = Element.GETSUBCLASSES(NNVAE) returns all subclasses of 'NNVAE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoders') returns all subclasses of 'NNVariationalAutoencoders'.
			%
			% Note that the Element.GETSUBCLASSES(NNVAE) and Element.GETSUBCLASSES('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoders' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of normalizer of a neural network data.
			%
			% PROPS = NNVariationalAutoencoders.GETPROPS() returns the property list of normalizer of a neural network data
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoders.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNVAE.GETPROPS([CATEGORY]) returns the property list of the normalizer of a neural network data NNVAE.
			%  PROPS = Element.GETPROPS(NNVAE[, CATEGORY]) returns the property list of 'NNVAE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoders'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoders'.
			%
			% Note that the Element.GETPROPS(NNVAE) and Element.GETPROPS('NNVariationalAutoencoders')
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
					prop_list = [6 7 20];
				case 3 % Category.PARAMETER
					prop_list = [4 10 11 12 13 14 22 23 24];
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
			% N = NNVariationalAutoencoders.GETPROPNUMBER() returns the property number of normalizer of a neural network data.
			%
			% N = NNVariationalAutoencoders.GETPROPNUMBER(CATEGORY) returns the property number of normalizer of a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNVAE.GETPROPNUMBER([CATEGORY]) returns the property number of the normalizer of a neural network data NNVAE.
			%  N = Element.GETPROPNUMBER(NNVAE) returns the property number of 'NNVAE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoders') returns the property number of 'NNVariationalAutoencoders'.
			%
			% Note that the Element.GETPROPNUMBER(NNVAE) and Element.GETPROPNUMBER('NNVariationalAutoencoders')
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
					prop_number = 3;
				case 3 % Category.PARAMETER
					prop_number = 9;
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
			% CHECK = NNVariationalAutoencoders.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSPROP(PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVAE, PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoders, PROP) checks whether PROP exists for NNVariationalAutoencoders.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%  Element.EXISTSPROP(NNVAE, PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoders, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoders.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNVAE) and Element.EXISTSPROP('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 27 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoders.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in normalizer of a neural network data/error.
			%
			% CHECK = NNVariationalAutoencoders.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSTAG(TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVAE, TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoders, TAG) checks whether TAG exists for NNVariationalAutoencoders.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%  Element.EXISTSTAG(NNVAE, TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoders, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoders.
			%   Error id: [BRAPH2:NNVariationalAutoencoders:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNVAE) and Element.EXISTSTAG('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoders.'] ...
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
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoders, POINTER) returns property number of POINTER of NNVariationalAutoencoders.
			%  PROPERTY = NNVAE.GETPROPPROP(NNVariationalAutoencoders, POINTER) returns property number of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPPROP(NNVAE) and Element.GETPROPPROP('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoders, POINTER) returns tag of POINTER of NNVariationalAutoencoders.
			%  TAG = NNVAE.GETPROPTAG(NNVariationalAutoencoders, POINTER) returns tag of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPTAG(NNVAE) and Element.GETPROPTAG('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoders_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT'  'LEARN_RATE'  'NUM_LATENT_REP'  'SIZE_IMG'  'ENCODER'  'DECODER'  'ELBO_LOSS' };
				tag = nnvariationalautoencoders_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoders, POINTER) returns category of POINTER of NNVariationalAutoencoders.
			%  CATEGORY = NNVAE.GETPROPCATEGORY(NNVariationalAutoencoders, POINTER) returns category of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPCATEGORY(NNVAE) and Element.GETPROPCATEGORY('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_category_list = { 1  1  1  3  4  2  2  6  4  3  3  3  3  3  5  6  6  6  9  2  6  3  3  3  4  4  6 };
			prop_category = nnvariationalautoencoders_category_list{prop};
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
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoders, POINTER) returns format of POINTER of NNVariationalAutoencoders.
			%  FORMAT = NNVAE.GETPROPFORMAT(NNVariationalAutoencoders, POINTER) returns format of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPFORMAT(NNVAE) and Element.GETPROPFORMAT('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_format_list = { 2  2  2  8  2  2  2  2  8  7  11  11  5  5  17  16  16  1  4  5  16  11  11  12  17  17  11 };
			prop_format = nnvariationalautoencoders_format_list{prop};
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
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoders, POINTER) returns description of POINTER of NNVariationalAutoencoders.
			%  DESCRIPTION = NNVAE.GETPROPDESCRIPTION(NNVariationalAutoencoders, POINTER) returns description of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNVAE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_description_list = { 'ELCLASS (constant, string) is the class of the combiner of neural networks datasets.'  'NAME (constant, string) is the name of the combiner of neural networks datasets.'  'DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.'  'TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.'  'ID (data, string) is a few-letter code of the combiner of neural networks datasets.'  'LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.'  'NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.'  'DP_CLASSES (parameter, classlist) is the list of compatible data points.'  'EPOCHS (parameter, scalar) is the maximum number of epochs.'  'BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SHUFFLE (parameter, option) is an option for data shuffling.'  'SOLVER (parameter, option) is an option for the solver.'  'MODEL (result, net) is a trained neural network model with the given dataset.'  'INPUTS (query, cell) constructs the cell array of the data.'  'TARGETS (query, cell) constructs the cell array of the targets.'  'TRAIN (query, empty) trains the neural network model with the given dataset.'  'VERBOSE (gui, logical) is an indicator to display training progress information.'  'PLOT_TRAINING (metadata, option) determines whether to plot the training progress.'  'PREDICT (query, cell) returns the predictions of the trained neural network for a dataset.'  'LEARN_RATE (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'NUM_LATENT_REP (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SIZE_IMG (parameter, rvector) is the size of the input image.'  'ENCODER (data, net) is a trained neural network encoder with the given dataset.'  'DECODER (data, net) is a trained neural network decoder with the given dataset.'  'ELBO_LOSS (query, scalar) returns the elbo loss.' };
			prop_description = nnvariationalautoencoders_description_list{prop};
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
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoders, POINTER) returns settings of POINTER of NNVariationalAutoencoders.
			%  SETTINGS = NNVAE.GETPROPSETTINGS(NNVariationalAutoencoders, POINTER) returns settings of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPSETTINGS(NNVAE) and Element.GETPROPSETTINGS('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 22 % NNVariationalAutoencoders.LEARN_RATE
					prop_settings = Format.getFormatSettings(11);
				case 23 % NNVariationalAutoencoders.NUM_LATENT_REP
					prop_settings = Format.getFormatSettings(11);
				case 24 % NNVariationalAutoencoders.SIZE_IMG
					prop_settings = Format.getFormatSettings(12);
				case 25 % NNVariationalAutoencoders.ENCODER
					prop_settings = Format.getFormatSettings(17);
				case 26 % NNVariationalAutoencoders.DECODER
					prop_settings = Format.getFormatSettings(17);
				case 27 % NNVariationalAutoencoders.ELBO_LOSS
					prop_settings = Format.getFormatSettings(11);
				case 4 % NNVariationalAutoencoders.TEMPLATE
					prop_settings = 'NNVariationalAutoencoders';
				case 9 % NNVariationalAutoencoders.D
					prop_settings = 'NNDataset';
				otherwise
					prop_settings = getPropSettings@NNBase(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoders, POINTER) returns the default value of POINTER of NNVariationalAutoencoders.
			%  DEFAULT = NNVAE.GETPROPDEFAULT(NNVariationalAutoencoders, POINTER) returns the default value of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPDEFAULT(NNVAE) and Element.GETPROPDEFAULT('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 22 % NNVariationalAutoencoders.LEARN_RATE
					prop_default = 1e-3;
				case 23 % NNVariationalAutoencoders.NUM_LATENT_REP
					prop_default = 2;
				case 24 % NNVariationalAutoencoders.SIZE_IMG
					prop_default = [28 28 1];
				case 25 % NNVariationalAutoencoders.ENCODER
					prop_default = Format.getFormatDefault(17, NNVariationalAutoencoders.getPropSettings(prop));
				case 26 % NNVariationalAutoencoders.DECODER
					prop_default = Format.getFormatDefault(17, NNVariationalAutoencoders.getPropSettings(prop));
				case 27 % NNVariationalAutoencoders.ELBO_LOSS
					prop_default = Format.getFormatDefault(11, NNVariationalAutoencoders.getPropSettings(prop));
				case 1 % NNVariationalAutoencoders.ELCLASS
					prop_default = 'NNVariationalAutoencoders';
				case 2 % NNVariationalAutoencoders.NAME
					prop_default = 'Neural Network Variational Autoencoders';
				case 3 % NNVariationalAutoencoders.DESCRIPTION
					prop_default = 'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.';
				case 4 % NNVariationalAutoencoders.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoders.getPropSettings(prop));
				case 5 % NNVariationalAutoencoders.ID
					prop_default = 'NNDatasetCombine ID';
				case 6 % NNVariationalAutoencoders.LABEL
					prop_default = 'NNDatasetCombine label';
				case 7 % NNVariationalAutoencoders.NOTES
					prop_default = 'NNDatasetCombine notes';
				case 9 % NNVariationalAutoencoders.D
					prop_default = NNDataset('DP_CLASS', 'NNDataPoint');
				case 10 % NNVariationalAutoencoders.DP_CLASSES
					prop_default = {'NNDataPoint' 'NNDataPoint_Image'};
				otherwise
					prop_default = getPropDefault@NNBase(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders.
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNVAE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoders.conditioning(prop, NNVariationalAutoencoders.getPropDefault(prop));
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
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoders, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders.
			%  CHECK = NNVAE.CHECKPROP(NNVariationalAutoencoders, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders.
			% 
			% NNVAE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoders:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNVAE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNVAE.
			%   Error id: BRAPH2:NNVariationalAutoencoders:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoders, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders.
			%   Error id: BRAPH2:NNVariationalAutoencoders:WrongInput
			%  NNVAE.CHECKPROP(NNVariationalAutoencoders, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders.
			%   Error id: BRAPH2:NNVariationalAutoencoders:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNVAE) and Element.CHECKPROP('NNVariationalAutoencoders')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoders.getPropProp(pointer);
			
			switch prop
				case 22 % NNVariationalAutoencoders.LEARN_RATE
					check = Format.checkFormat(11, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 23 % NNVariationalAutoencoders.NUM_LATENT_REP
					check = Format.checkFormat(11, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 24 % NNVariationalAutoencoders.SIZE_IMG
					check = Format.checkFormat(12, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 25 % NNVariationalAutoencoders.ENCODER
					check = Format.checkFormat(17, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 26 % NNVariationalAutoencoders.DECODER
					check = Format.checkFormat(17, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 27 % NNVariationalAutoencoders.ELBO_LOSS
					check = Format.checkFormat(11, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 4 % NNVariationalAutoencoders.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoders.getPropSettings(prop));
				case 9 % NNVariationalAutoencoders.D
					check = Format.checkFormat(8, value, NNVariationalAutoencoders.getPropSettings(prop));
				otherwise
					if prop <= 21
						check = checkProp@NNBase(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoders.getPropTag(prop) ' (' NNVariationalAutoencoders.getFormatTag(NNVariationalAutoencoders.getPropFormat(prop)) ').'] ...
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
				case 9 % NNVariationalAutoencoders.D
					if ~isequal(nnvae.get('D').get('DP_DICT').get('LENGTH'), 0)
					    input_data = cell2mat(nnvae.get('D').get('DP_DICT').get('IT', 1).get('INPUT'));
					    if isequal(length(size(input_data)), 2) % only 1 channel
					        size_img = [size(input_data) 1]; % force it to be length, width, channel
					    else
					        size_img = size(input_data);
					    end
					    nnvae.set('SIZE_IMG', size_img);
					end
					if isa(nnvae.getr('ENCODER'), 'NoValue')
					    numLatentChannels = nnvae.get('NUM_LATENT_REP');
					    imageSize = nnvae.get('SIZE_IMG');
					
					    layersE = [
					        imageInputLayer(imageSize, Normalization="none")
					        convolution2dLayer(3, 32, Padding="same", Stride=2)
					        leakyReluLayer(0.2)
					        convolution2dLayer(3, 64, Padding="same", Stride=2)
					        leakyReluLayer(0.2)
					        fullyConnectedLayer(16)
					        leakyReluLayer(0.2)
					        fullyConnectedLayer(2*numLatentChannels, 'Name', 'latentOuput')
					        samplingLayer];
					
					    nnvae.set('ENCODER', dlnetwork(layersE));
					end
					if isa(nnvae.getr('DECODER'), 'NoValue')
					    % Calculate projection size
					    projectChannels = 64; % comes from encoder, the last convolutional layer
					    stride = 2; % comes from encoder, the last convolutional layer
					    num_layer_with_stride = 2; % come from encoder, there are two convolutional layers with strides
					    projSize = imageSize(1:2);
					    for i = 1:2 % two stride-2 layers
					        projSize = ceil(projSize / stride);
					    end
					    projectionSize = [projSize projectChannels];
					
					    numInputChannels = imageSize(3);
					    numLatentChannels = nnvae.get('NUM_LATENT_REP');
					
					    layersD = [
					        featureInputLayer(numLatentChannels)
					        fullyConnectedLayer(prod(projectionSize))
					        leakyReluLayer(0.2)
					        projectAndReshapeLayer(projectionSize)
					        transposedConv2dLayer(3, 64, Cropping="same", Stride=2)
					        leakyReluLayer(0.2)
					        transposedConv2dLayer(3, 32, Cropping="same", Stride=2)
					        leakyReluLayer(0.2)
					        transposedConv2dLayer(3, numInputChannels, Cropping="same")
					        sigmoidLayer];
					
					    nnvae.set('DECODER', dlnetwork(layersD));
					end
					
				otherwise
					if prop <= 21
						postset@NNBase(nnvae, prop);
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
				case 27 % NNVariationalAutoencoders.ELBO_LOSS
					if length(varargin) < 4
					    value = 0;
					    return
					end
					y = varargin{1};
					t = varargin{2};
					mu = varargin{3};
					logSigmaSq = varargin{4};
					
					% Reconstruction loss
					reconstructionLoss = mse(y, t);
					
					% KL divergence
					KL = -1/2 * sum(1 + logSigmaSq - mu.^2 - exp(logSigmaSq),1);
					KL = mean(KL);
					
					% Combined loss
					value = reconstructionLoss + KL;
					
				case 16 % NNVariationalAutoencoders.INPUTS
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
					    value = reshape(cat(3, flat_cells{:}), s1, s2, 1, []);
					end
					
				case 17 % NNVariationalAutoencoders.TARGETS
					% targets = nn.get('PREDICT', D) returns a cell array with the
					%  targets for all data points in dataset D.
					if isempty(varargin)
					    value = {};
					    return
					end
					d = varargin{1};
					targets_group = d.get('TARGETS');
					if isempty(targets_group)
					    value = {};
					else
					    flat_cells = cellfun(@(c) c{1}, targets_group, 'UniformOutput', false);
					    value = cat(1, flat_cells{:});
					end
					
				case 18 % NNVariationalAutoencoders.TRAIN
					numEpochs = nnvae.get('EPOCHS');
					miniBatchSize = nnvae.get('BATCH');
					learnRate = nnvae.get('LEARN_RATE');
					
					d = nnvae.get('D');
					if isequal(d.get('DP_DICT').get('LENGTH'), 0)
					    value = [];
					    return
					end
					
					XTrain = nnvae.get('INPUTS', d);
					YTrain = categorical(nnvae.get('TARGETS', d));
					
					dsXTrain = arrayDatastore(XTrain, IterationDimension=4);
					dsYTrain = arrayDatastore(YTrain);
					dsTrain = combine(dsXTrain, dsYTrain);
					
					numOutputs = nnvae.get('NUM_LATENT_REP');;
					
					mbq = minibatchqueue(dsTrain, numOutputs, ...
					    MiniBatchSize = miniBatchSize, ...
					    MiniBatchFcn = @preprocessMiniBatch, ...
					    MiniBatchFormat = ["SSCB", ""], ...
					    PartialMiniBatch = "discard");
					
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
					if prop <= 21
						value = calculateValue@NNBase(nnvae, prop, varargin{:});
					else
						value = calculateValue@Element(nnvae, prop, varargin{:});
					end
			end
			
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
				case 9 % NNVariationalAutoencoders.D
					check = ismember(value.get('DP_CLASS'), nnvae.get('DP_CLASSES'));
					
				otherwise
					if prop <= 21
						[check, msg] = checkValue@NNBase(nnvae, prop, value);
					end
			end
		end
	end
end
