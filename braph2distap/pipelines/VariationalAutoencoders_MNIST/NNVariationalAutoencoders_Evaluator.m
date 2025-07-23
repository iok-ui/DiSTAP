classdef NNVariationalAutoencoders_Evaluator < NNEvaluator
	%NNVariationalAutoencoders_Evaluator evaluates the performance of a trained neural network model with a dataset.
	% It is a subclass of <a href="matlab:help NNEvaluator">NNEvaluator</a>.
	%
	% A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset.
	% Instances of this class should not be created. Use one of its subclasses instead.
	% Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.
	%
	% The list of NNVariationalAutoencoders_Evaluator properties is:
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
	%  <strong>12</strong> <strong>PLOT_LATENT_CONTINUITY</strong> 	PLOT_LATENT_CONTINUITY (query, empty) is to plot latetn representations.
	%  <strong>13</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
	%
	% NNVariationalAutoencoders_Evaluator methods (constructor):
	%  NNVariationalAutoencoders_Evaluator - constructor
	%
	% NNVariationalAutoencoders_Evaluator methods:
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
	% NNVariationalAutoencoders_Evaluator methods (display):
	%  tostring - string with information about the neural network evaluator
	%  disp - displays information about the neural network evaluator
	%  tree - displays the tree of the neural network evaluator
	%
	% NNVariationalAutoencoders_Evaluator methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two neural network evaluator are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the neural network evaluator
	%
	% NNVariationalAutoencoders_Evaluator methods (save/load, Static):
	%  save - saves BRAPH2 neural network evaluator as b2 file
	%  load - loads a BRAPH2 neural network evaluator from a b2 file
	%
	% NNVariationalAutoencoders_Evaluator method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoders_Evaluator method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoders_Evaluator methods (inspection, Static):
	%  getClass - returns the class of the neural network evaluator
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoders_Evaluator
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
	% NNVariationalAutoencoders_Evaluator methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoders_Evaluator methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoders_Evaluator methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoders_Evaluator methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoders_Evaluator; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoders_Evaluator constants</a>.
	%
	%
	% See also NNDataPoint, NNDataset, NNBase.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		PLOT_LATENT_REPRESENTATIONS = 11; %CET: Computational Efficiency Trick
		PLOT_LATENT_REPRESENTATIONS_TAG = 'PLOT_LATENT_REPRESENTATIONS';
		PLOT_LATENT_REPRESENTATIONS_CATEGORY = 6;
		PLOT_LATENT_REPRESENTATIONS_FORMAT = 1;
		
		PLOT_LATENT_CONTINUITY = 12; %CET: Computational Efficiency Trick
		PLOT_LATENT_CONTINUITY_TAG = 'PLOT_LATENT_CONTINUITY';
		PLOT_LATENT_CONTINUITY_CATEGORY = 6;
		PLOT_LATENT_CONTINUITY_FORMAT = 1;
		
		PREDICT_ENCODER = 13; %CET: Computational Efficiency Trick
		PREDICT_ENCODER_TAG = 'PREDICT_ENCODER';
		PREDICT_ENCODER_CATEGORY = 6;
		PREDICT_ENCODER_FORMAT = 16;
	end
	methods % constructor
		function nne = NNVariationalAutoencoders_Evaluator(varargin)
			%NNVariationalAutoencoders_Evaluator() creates a neural network evaluator.
			%
			% NNVariationalAutoencoders_Evaluator(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoders_Evaluator(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoders_Evaluator properties is:
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
			%  <strong>12</strong> <strong>PLOT_LATENT_CONTINUITY</strong> 	PLOT_LATENT_CONTINUITY (query, empty) is to plot latetn representations.
			%  <strong>13</strong> <strong>PREDICT_ENCODER</strong> 	PREDICT_ENCODER (query, cell) returns the predictions of an encoder.
			%
			% See also Category, Format.
			
			nne = nne@NNEvaluator(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the neural network evaluator.
			%
			% BUILD = NNVariationalAutoencoders_Evaluator.GETBUILD() returns the build of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNE.GETBUILD() returns the build of the neural network evaluator NNE.
			%  BUILD = Element.GETBUILD(NNE) returns the build of 'NNE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoders_Evaluator') returns the build of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Note that the Element.GETBUILD(NNE) and Element.GETBUILD('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nne_class = getClass()
			%GETCLASS returns the class of the neural network evaluator.
			%
			% CLASS = NNVariationalAutoencoders_Evaluator.GETCLASS() returns the class 'NNVariationalAutoencoders_Evaluator'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNE.GETCLASS() returns the class of the neural network evaluator NNE.
			%  CLASS = Element.GETCLASS(NNE) returns the class of 'NNE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoders_Evaluator') returns 'NNVariationalAutoencoders_Evaluator'.
			%
			% Note that the Element.GETCLASS(NNE) and Element.GETCLASS('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			
			nne_class = 'NNVariationalAutoencoders_Evaluator';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the neural network evaluator.
			%
			% LIST = NNVariationalAutoencoders_Evaluator.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNE.GETSUBCLASSES() returns all subclasses of the neural network evaluator NNE.
			%  LIST = Element.GETSUBCLASSES(NNE) returns all subclasses of 'NNE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoders_Evaluator') returns all subclasses of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Note that the Element.GETSUBCLASSES(NNE) and Element.GETSUBCLASSES('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoders_Evaluator' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of neural network evaluator.
			%
			% PROPS = NNVariationalAutoencoders_Evaluator.GETPROPS() returns the property list of neural network evaluator
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoders_Evaluator.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNE.GETPROPS([CATEGORY]) returns the property list of the neural network evaluator NNE.
			%  PROPS = Element.GETPROPS(NNE[, CATEGORY]) returns the property list of 'NNE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoders_Evaluator'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Note that the Element.GETPROPS(NNE) and Element.GETPROPS('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = 4;
				case 4 % Category.DATA
					prop_list = [5 9 10];
				case 6 % Category.QUERY
					prop_list = [8 11 12 13];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoders_Evaluator.GETPROPNUMBER() returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoders_Evaluator.GETPROPNUMBER(CATEGORY) returns the property number of neural network evaluator
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNE.GETPROPNUMBER([CATEGORY]) returns the property number of the neural network evaluator NNE.
			%  N = Element.GETPROPNUMBER(NNE) returns the property number of 'NNE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoders_Evaluator') returns the property number of 'NNVariationalAutoencoders_Evaluator'.
			%
			% Note that the Element.GETPROPNUMBER(NNE) and Element.GETPROPNUMBER('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 13;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 1;
				case 4 % Category.DATA
					prop_number = 3;
				case 6 % Category.QUERY
					prop_number = 4;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in neural network evaluator/error.
			%
			% CHECK = NNVariationalAutoencoders_Evaluator.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSPROP(PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNE, PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoders_Evaluator, PROP) checks whether PROP exists for NNVariationalAutoencoders_Evaluator.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%  Element.EXISTSPROP(NNE, PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoders_Evaluator, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoders_Evaluator.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNE) and Element.EXISTSPROP('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 13 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoders_Evaluator.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in neural network evaluator/error.
			%
			% CHECK = NNVariationalAutoencoders_Evaluator.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSTAG(TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNE, TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoders_Evaluator, TAG) checks whether TAG exists for NNVariationalAutoencoders_Evaluator.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%  Element.EXISTSTAG(NNE, TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoders_Evaluator, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoders_Evaluator.
			%   Error id: [BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNE) and Element.EXISTSTAG('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PLOT_LATENT_CONTINUITY'  'PREDICT_ENCODER' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoders_Evaluator.'] ...
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
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoders_Evaluator, POINTER) returns property number of POINTER of NNVariationalAutoencoders_Evaluator.
			%  PROPERTY = NNE.GETPROPPROP(NNVariationalAutoencoders_Evaluator, POINTER) returns property number of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPPROP(NNE) and Element.GETPROPPROP('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PLOT_LATENT_CONTINUITY'  'PREDICT_ENCODER' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoders_Evaluator, POINTER) returns tag of POINTER of NNVariationalAutoencoders_Evaluator.
			%  TAG = NNE.GETPROPTAG(NNVariationalAutoencoders_Evaluator, POINTER) returns tag of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPTAG(NNE) and Element.GETPROPTAG('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoders_evaluator_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PLOT_LATENT_CONTINUITY'  'PREDICT_ENCODER' };
				tag = nnvariationalautoencoders_evaluator_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoders_Evaluator, POINTER) returns category of POINTER of NNVariationalAutoencoders_Evaluator.
			%  CATEGORY = NNE.GETPROPCATEGORY(NNVariationalAutoencoders_Evaluator, POINTER) returns category of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPCATEGORY(NNE) and Element.GETPROPCATEGORY('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_evaluator_category_list = { 1  1  1  3  4  2  2  6  4  4  6  6  6 };
			prop_category = nnvariationalautoencoders_evaluator_category_list{prop};
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
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoders_Evaluator, POINTER) returns format of POINTER of NNVariationalAutoencoders_Evaluator.
			%  FORMAT = NNE.GETPROPFORMAT(NNVariationalAutoencoders_Evaluator, POINTER) returns format of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPFORMAT(NNE) and Element.GETPROPFORMAT('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_evaluator_format_list = { 2  2  2  8  2  2  2  2  8  8  1  1  16 };
			prop_format = nnvariationalautoencoders_evaluator_format_list{prop};
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
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoders_Evaluator, POINTER) returns description of POINTER of NNVariationalAutoencoders_Evaluator.
			%  DESCRIPTION = NNE.GETPROPDESCRIPTION(NNVariationalAutoencoders_Evaluator, POINTER) returns description of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoders_evaluator_description_list = { 'ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.'  'NAME (constant, string) is the name of the evaluator for the neural network analysis.'  'DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.'  'TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.'  'ID (data, string) is a few-letter code for the evaluator for the neural network analysis.'  'LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.'  'NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'NN (data, item) contains a trained neural network model.'  'D (data, item) is the dataset to evaluate the neural network model.'  'PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.'  'PLOT_LATENT_CONTINUITY (query, empty) is to plot latetn representations.'  'PREDICT_ENCODER (query, cell) returns the predictions of an encoder.' };
			prop_description = nnvariationalautoencoders_evaluator_description_list{prop};
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
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoders_Evaluator, POINTER) returns settings of POINTER of NNVariationalAutoencoders_Evaluator.
			%  SETTINGS = NNE.GETPROPSETTINGS(NNVariationalAutoencoders_Evaluator, POINTER) returns settings of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPSETTINGS(NNE) and Element.GETPROPSETTINGS('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 11 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_REPRESENTATIONS
					prop_settings = Format.getFormatSettings(1);
				case 12 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_CONTINUITY
					prop_settings = Format.getFormatSettings(1);
				case 13 % NNVariationalAutoencoders_Evaluator.PREDICT_ENCODER
					prop_settings = Format.getFormatSettings(16);
				case 4 % NNVariationalAutoencoders_Evaluator.TEMPLATE
					prop_settings = 'NNEvaluator';
				otherwise
					prop_settings = getPropSettings@NNEvaluator(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders_Evaluator.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders_Evaluator.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoders_Evaluator, POINTER) returns the default value of POINTER of NNVariationalAutoencoders_Evaluator.
			%  DEFAULT = NNE.GETPROPDEFAULT(NNVariationalAutoencoders_Evaluator, POINTER) returns the default value of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPDEFAULT(NNE) and Element.GETPROPDEFAULT('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 11 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_REPRESENTATIONS
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 12 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_CONTINUITY
					prop_default = Format.getFormatDefault(1, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 13 % NNVariationalAutoencoders_Evaluator.PREDICT_ENCODER
					prop_default = Format.getFormatDefault(16, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 1 % NNVariationalAutoencoders_Evaluator.ELCLASS
					prop_default = 'NNVariationalAutoencoders_Evaluator';
				case 2 % NNVariationalAutoencoders_Evaluator.NAME
					prop_default = 'Neural Network Evaluator';
				case 3 % NNVariationalAutoencoders_Evaluator.DESCRIPTION
					prop_default = 'A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset. Instances of this class should not be created. Use one of its subclasses instead. Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.';
				case 4 % NNVariationalAutoencoders_Evaluator.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 5 % NNVariationalAutoencoders_Evaluator.ID
					prop_default = 'NNEvaluator ID';
				case 6 % NNVariationalAutoencoders_Evaluator.LABEL
					prop_default = 'NNEvaluator label';
				case 7 % NNVariationalAutoencoders_Evaluator.NOTES
					prop_default = 'NNEvaluator notes';
				otherwise
					prop_default = getPropDefault@NNEvaluator(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoders_Evaluator.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoders_Evaluator.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders_Evaluator, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders_Evaluator.
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoders_Evaluator, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoders_Evaluator.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoders_Evaluator.conditioning(prop, NNVariationalAutoencoders_Evaluator.getPropDefault(prop));
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
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoders_Evaluator, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders_Evaluator.
			%  CHECK = NNE.CHECKPROP(NNVariationalAutoencoders_Evaluator, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoders_Evaluator.
			% 
			% NNE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNE.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoders_Evaluator, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders_Evaluator.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput
			%  NNE.CHECKPROP(NNVariationalAutoencoders_Evaluator, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoders_Evaluator.
			%   Error id: BRAPH2:NNVariationalAutoencoders_Evaluator:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNE) and Element.CHECKPROP('NNVariationalAutoencoders_Evaluator')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoders_Evaluator.getPropProp(pointer);
			
			switch prop
				case 11 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_REPRESENTATIONS
					check = Format.checkFormat(1, value, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 12 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_CONTINUITY
					check = Format.checkFormat(1, value, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 13 % NNVariationalAutoencoders_Evaluator.PREDICT_ENCODER
					check = Format.checkFormat(16, value, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				case 4 % NNVariationalAutoencoders_Evaluator.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoders_Evaluator.getPropSettings(prop));
				otherwise
					if prop <= 10
						check = checkProp@NNEvaluator(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoders_Evaluator:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoders_Evaluator.getPropTag(prop) ' (' NNVariationalAutoencoders_Evaluator.getFormatTag(NNVariationalAutoencoders_Evaluator.getPropFormat(prop)) ').'] ...
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
				case 11 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_REPRESENTATIONS
					nnvae = nne.get('NN');
					netE = nnvae.get('ENCODER');
					d = nne.get('D');
					
					XTrain = nnvae.get('INPUTS', d);
					YTrain = categorical(nnvae.get('TARGETS', d));
					
					dsXTrain = arrayDatastore(XTrain, IterationDimension=4);
					dsYTrain = arrayDatastore(YTrain);
					dsTrain = combine(dsXTrain, dsYTrain);
					
					numOutputs = nnvae.get('NUM_LATENT_REP');;
					
					miniBatchSize = nnvae.get('BATCH');
					mbqTrain = minibatchqueue(dsTrain, numOutputs, ...
					    MiniBatchSize = miniBatchSize, ...
					    MiniBatchFcn=@preprocessMiniBatch, ...
					    MiniBatchFormat=["SSCB",""], ...
					    PartialMiniBatch="discard");
					
					latentInfo = nne.get('PREDICT_ENCODER', netE, mbqTrain);
					ZLatent = latentInfo{1};
					YLatent = latentInfo{2};
					%index_selected = (YLatent == 2) | (YLatent == 1) | (YLatent == 10) | (YLatent == 8) | (YLatent == 3);
					
					%figure;
					%h = scatter(ZLatent(1, index_selected), ZLatent(2, index_selected), 30, YLatent(index_selected), 'filled');
					h = scatter(ZLatent(1, :), ZLatent(2, :), 30, YLatent(:), 'filled');
					
					title('Scatter Plot with Color-Coded Categories');
					value = [];
					
				case 12 % NNVariationalAutoencoders_Evaluator.PLOT_LATENT_CONTINUITY
					netD = nne.get('NN').get('DECODER');
					n = 20;
					figsize = 15;
					
					% Display an n x n 2D manifold of data points
					digit_size = 28;
					scale = 1.0;
					
					% Initialize the figure
					figure = zeros(digit_size * n, digit_size * n);
					
					% Linearly spaced coordinates corresponding to the 2D plot
					% of data points in the latent space
					grid_x = linspace(-scale, scale, n);
					grid_y = linspace(-scale, scale, n);
					
					% Reverse grid_y to match the original Python code
					grid_y = flip(grid_y);
					
					for i = 1:n
					    for j = 1:n
					        z_sample = [grid_x(j); grid_y(i)];
					        z_sample = dlarray(z_sample,"CB");
					        x_decoded = predict(netD, z_sample);
					        digit = reshape(x_decoded, digit_size, digit_size);
					        figure(1 + (i - 1) * digit_size:i * digit_size, 1 + (j - 1) * digit_size:j * digit_size) = digit;
					    end
					end
					
					% Create the figure
					
					start_range = digit_size / 2;
					end_range = n * digit_size + start_range;
					pixel_range = start_range:digit_size:end_range;
					sample_range_x = round(grid_x, 1);
					sample_range_y = round(grid_y, 1);
					
					xticks(pixel_range);
					xticklabels(sample_range_x);
					yticks(pixel_range);
					yticklabels(sample_range_y);
					xlabel('z[0]');
					ylabel('z[1]');
					imagesc(figure);
					colormap('gray');
					
					% Display the plot
					axis equal;
					axis tight;
					axis off;
					
					% Show the figure
					set(gcf, 'Color', 'w');
					drawnow;
					value = [];
					
				case 13 % NNVariationalAutoencoders_Evaluator.PREDICT_ENCODER
					if isempty(varargin)
					    value = {};
					    return
					end
					
					netE = varargin{1};
					mbq = varargin{2};
					
					Z = [];
					Y = [];
					
					% Loop over mini-batches.
					while hasdata(mbq)
					    [X_individual, Y_individual] = next(mbq);
					
					    % Forward through encoder.
					    %Z_individual = predict(netE,X_individual,Outputs='latentOuput');
					    [Z_individual, mu, logSigmaSq] = predict(netE,X_individual);
					    
					    % Extract and concatenate predictions.
					    %Z = cat(2,Z,extractdata(Z_individual));
					    Z = cat(2, Z, extractdata(mu));
					
					    Y_individual = extractdata(gather(Y_individual));
					    
					    Y_number = [];
					    for col = 1:size(Y_individual, 2)
					        Y_number(col) = find(Y_individual(:, col) == 1);
					    end
					    Y = cat(2,Y,Y_number);
					
					    if size(Y, 2) ~= size(Z, 2)
					        szie(Y, 2)
					    end
					end
					
					value = [{Z}, {Y}];
					
				otherwise
					if prop <= 10
						value = calculateValue@NNEvaluator(nne, prop, varargin{:});
					else
						value = calculateValue@Element(nne, prop, varargin{:});
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
end
