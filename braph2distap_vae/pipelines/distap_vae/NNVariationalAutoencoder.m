classdef NNVariationalAutoencoder < NNBase
	%NNVariationalAutoencoder transfroms neural network datasets.
	% It is a subclass of <a href="matlab:help NNBase">NNBase</a>.
	%
	% A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
	% The resulting combined dataset contains all the unique datapoints from the input datasets, 
	% and any overlapping datapoints are excluded to ensure data consistency.
	%
	% The list of NNVariationalAutoencoder properties is:
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
	%
	% NNVariationalAutoencoder methods (constructor):
	%  NNVariationalAutoencoder - constructor
	%
	% NNVariationalAutoencoder methods:
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
	% NNVariationalAutoencoder methods (display):
	%  tostring - string with information about the normalizer of a neural network data
	%  disp - displays information about the normalizer of a neural network data
	%  tree - displays the tree of the normalizer of a neural network data
	%
	% NNVariationalAutoencoder methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two normalizer of a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the normalizer of a neural network data
	%
	% NNVariationalAutoencoder methods (save/load, Static):
	%  save - saves BRAPH2 normalizer of a neural network data as b2 file
	%  load - loads a BRAPH2 normalizer of a neural network data from a b2 file
	%
	% NNVariationalAutoencoder method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoder method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNVariationalAutoencoder methods (inspection, Static):
	%  getClass - returns the class of the normalizer of a neural network data
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoder
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
	% NNVariationalAutoencoder methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoder methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoder methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoder methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoder; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoder constants</a>.
	%
	%
	% See also NNDataset, NNDatasetSplit.
	%
	% BUILD BRAPH2 7 class_name 1
	
	methods % constructor
		function nnvae = NNVariationalAutoencoder(varargin)
			%NNVariationalAutoencoder() creates a normalizer of a neural network data.
			%
			% NNVariationalAutoencoder(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoder(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoder properties is:
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
			%
			% See also Category, Format.
			
			nnvae = nnvae@NNBase(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the normalizer of a neural network data.
			%
			% BUILD = NNVariationalAutoencoder.GETBUILD() returns the build of 'NNVariationalAutoencoder'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNVAE.GETBUILD() returns the build of the normalizer of a neural network data NNVAE.
			%  BUILD = Element.GETBUILD(NNVAE) returns the build of 'NNVAE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoder') returns the build of 'NNVariationalAutoencoder'.
			%
			% Note that the Element.GETBUILD(NNVAE) and Element.GETBUILD('NNVariationalAutoencoder')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nnvae_class = getClass()
			%GETCLASS returns the class of the normalizer of a neural network data.
			%
			% CLASS = NNVariationalAutoencoder.GETCLASS() returns the class 'NNVariationalAutoencoder'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNVAE.GETCLASS() returns the class of the normalizer of a neural network data NNVAE.
			%  CLASS = Element.GETCLASS(NNVAE) returns the class of 'NNVAE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoder') returns 'NNVariationalAutoencoder'.
			%
			% Note that the Element.GETCLASS(NNVAE) and Element.GETCLASS('NNVariationalAutoencoder')
			%  are less computationally efficient.
			
			nnvae_class = 'NNVariationalAutoencoder';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the normalizer of a neural network data.
			%
			% LIST = NNVariationalAutoencoder.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoder'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNVAE.GETSUBCLASSES() returns all subclasses of the normalizer of a neural network data NNVAE.
			%  LIST = Element.GETSUBCLASSES(NNVAE) returns all subclasses of 'NNVAE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoder') returns all subclasses of 'NNVariationalAutoencoder'.
			%
			% Note that the Element.GETSUBCLASSES(NNVAE) and Element.GETSUBCLASSES('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoder' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of normalizer of a neural network data.
			%
			% PROPS = NNVariationalAutoencoder.GETPROPS() returns the property list of normalizer of a neural network data
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoder.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNVAE.GETPROPS([CATEGORY]) returns the property list of the normalizer of a neural network data NNVAE.
			%  PROPS = Element.GETPROPS(NNVAE[, CATEGORY]) returns the property list of 'NNVAE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoder'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoder'.
			%
			% Note that the Element.GETPROPS(NNVAE) and Element.GETPROPS('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7 20];
				case 3 % Category.PARAMETER
					prop_list = [4 10 11 12 13 14];
				case 4 % Category.DATA
					prop_list = [5 9];
				case 5 % Category.RESULT
					prop_list = 15;
				case 6 % Category.QUERY
					prop_list = [8 16 17 18 21];
				case 9 % Category.GUI
					prop_list = 19;
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of normalizer of a neural network data.
			%
			% N = NNVariationalAutoencoder.GETPROPNUMBER() returns the property number of normalizer of a neural network data.
			%
			% N = NNVariationalAutoencoder.GETPROPNUMBER(CATEGORY) returns the property number of normalizer of a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNVAE.GETPROPNUMBER([CATEGORY]) returns the property number of the normalizer of a neural network data NNVAE.
			%  N = Element.GETPROPNUMBER(NNVAE) returns the property number of 'NNVAE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoder') returns the property number of 'NNVariationalAutoencoder'.
			%
			% Note that the Element.GETPROPNUMBER(NNVAE) and Element.GETPROPNUMBER('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 21;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 3;
				case 3 % Category.PARAMETER
					prop_number = 6;
				case 4 % Category.DATA
					prop_number = 2;
				case 5 % Category.RESULT
					prop_number = 1;
				case 6 % Category.QUERY
					prop_number = 5;
				case 9 % Category.GUI
					prop_number = 1;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in normalizer of a neural network data/error.
			%
			% CHECK = NNVariationalAutoencoder.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSPROP(PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVAE, PROP) checks whether PROP exists for NNVAE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoder, PROP) checks whether PROP exists for NNVariationalAutoencoder.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%  Element.EXISTSPROP(NNVAE, PROP) throws error if PROP does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoder, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoder.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNVAE) and Element.EXISTSPROP('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 21 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoder.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in normalizer of a neural network data/error.
			%
			% CHECK = NNVariationalAutoencoder.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNVAE.EXISTSTAG(TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVAE, TAG) checks whether TAG exists for NNVAE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoder, TAG) checks whether TAG exists for NNVariationalAutoencoder.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNVAE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%  Element.EXISTSTAG(NNVAE, TAG) throws error if TAG does NOT exist for NNVAE.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoder, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoder.
			%   Error id: [BRAPH2:NNVariationalAutoencoder:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNVAE) and Element.EXISTSTAG('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoder.'] ...
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
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoder, POINTER) returns property number of POINTER of NNVariationalAutoencoder.
			%  PROPERTY = NNVAE.GETPROPPROP(NNVariationalAutoencoder, POINTER) returns property number of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPPROP(NNVAE) and Element.GETPROPPROP('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoder, POINTER) returns tag of POINTER of NNVariationalAutoencoder.
			%  TAG = NNVAE.GETPROPTAG(NNVariationalAutoencoder, POINTER) returns tag of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPTAG(NNVAE) and Element.GETPROPTAG('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoder_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'DP_CLASSES'  'EPOCHS'  'BATCH'  'SHUFFLE'  'SOLVER'  'MODEL'  'INPUTS'  'TARGETS'  'TRAIN'  'VERBOSE'  'PLOT_TRAINING'  'PREDICT' };
				tag = nnvariationalautoencoder_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoder, POINTER) returns category of POINTER of NNVariationalAutoencoder.
			%  CATEGORY = NNVAE.GETPROPCATEGORY(NNVariationalAutoencoder, POINTER) returns category of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPCATEGORY(NNVAE) and Element.GETPROPCATEGORY('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoder_category_list = { 1  1  1  3  4  2  2  6  4  3  3  3  3  3  5  6  6  6  9  2  6 };
			prop_category = nnvariationalautoencoder_category_list{prop};
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
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoder, POINTER) returns format of POINTER of NNVariationalAutoencoder.
			%  FORMAT = NNVAE.GETPROPFORMAT(NNVariationalAutoencoder, POINTER) returns format of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPFORMAT(NNVAE) and Element.GETPROPFORMAT('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoder_format_list = { 2  2  2  8  2  2  2  2  8  7  11  11  5  5  17  16  16  1  4  5  16 };
			prop_format = nnvariationalautoencoder_format_list{prop};
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
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoder, POINTER) returns description of POINTER of NNVariationalAutoencoder.
			%  DESCRIPTION = NNVAE.GETPROPDESCRIPTION(NNVariationalAutoencoder, POINTER) returns description of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNVAE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoder_description_list = { 'ELCLASS (constant, string) is the class of the combiner of neural networks datasets.'  'NAME (constant, string) is the name of the combiner of neural networks datasets.'  'DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.'  'TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.'  'ID (data, string) is a few-letter code of the combiner of neural networks datasets.'  'LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.'  'NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the dataset to train the neural network model, and its data point class DP_CLASS defaults to one of the compatible classes within the set of DP_CLASSES.'  'DP_CLASSES (parameter, classlist) is the list of compatible data points.'  'EPOCHS (parameter, scalar) is the maximum number of epochs.'  'BATCH (parameter, scalar) is the size of the mini-batch used for each training iteration.'  'SHUFFLE (parameter, option) is an option for data shuffling.'  'SOLVER (parameter, option) is an option for the solver.'  'MODEL (result, net) is a trained neural network model with the given dataset.'  'INPUTS (query, cell) constructs the cell array of the data.'  'TARGETS (query, cell) constructs the cell array of the targets.'  'TRAIN (query, empty) trains the neural network model with the given dataset.'  'VERBOSE (gui, logical) is an indicator to display training progress information.'  'PLOT_TRAINING (metadata, option) determines whether to plot the training progress.'  'PREDICT (query, cell) returns the predictions of the trained neural network for a dataset.' };
			prop_description = nnvariationalautoencoder_description_list{prop};
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
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoder, POINTER) returns settings of POINTER of NNVariationalAutoencoder.
			%  SETTINGS = NNVAE.GETPROPSETTINGS(NNVariationalAutoencoder, POINTER) returns settings of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPSETTINGS(NNVAE) and Element.GETPROPSETTINGS('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 4 % NNVariationalAutoencoder.TEMPLATE
					prop_settings = 'NNDatasetCombine';
				otherwise
					prop_settings = getPropSettings@NNBase(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoder.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoder.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoder, POINTER) returns the default value of POINTER of NNVariationalAutoencoder.
			%  DEFAULT = NNVAE.GETPROPDEFAULT(NNVariationalAutoencoder, POINTER) returns the default value of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPDEFAULT(NNVAE) and Element.GETPROPDEFAULT('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 1 % NNVariationalAutoencoder.ELCLASS
					prop_default = 'NNDatasetCombine';
				case 2 % NNVariationalAutoencoder.NAME
					prop_default = 'Neural Network Dataset Combiner';
				case 3 % NNVariationalAutoencoder.DESCRIPTION
					prop_default = 'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.';
				case 4 % NNVariationalAutoencoder.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoder.getPropSettings(prop));
				case 5 % NNVariationalAutoencoder.ID
					prop_default = 'NNDatasetCombine ID';
				case 6 % NNVariationalAutoencoder.LABEL
					prop_default = 'NNDatasetCombine label';
				case 7 % NNVariationalAutoencoder.NOTES
					prop_default = 'NNDatasetCombine notes';
				otherwise
					prop_default = getPropDefault@NNBase(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoder.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoder.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNVAE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoder, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoder.
			%  DEFAULT = NNVAE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoder, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoder.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNVAE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoder.conditioning(prop, NNVariationalAutoencoder.getPropDefault(prop));
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
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoder, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoder.
			%  CHECK = NNVAE.CHECKPROP(NNVariationalAutoencoder, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoder.
			% 
			% NNVAE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoder:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNVAE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNVAE.
			%   Error id: BRAPH2:NNVariationalAutoencoder:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoder, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoder.
			%   Error id: BRAPH2:NNVariationalAutoencoder:WrongInput
			%  NNVAE.CHECKPROP(NNVariationalAutoencoder, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoder.
			%   Error id: BRAPH2:NNVariationalAutoencoder:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNVAE) and Element.CHECKPROP('NNVariationalAutoencoder')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoder.getPropProp(pointer);
			
			switch prop
				case 4 % NNVariationalAutoencoder.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoder.getPropSettings(prop));
				otherwise
					if prop <= 21
						check = checkProp@NNBase(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoder:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoder.getPropTag(prop) ' (' NNVariationalAutoencoder.getFormatTag(NNVariationalAutoencoder.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
end
