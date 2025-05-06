classdef NNDatasetNormalize < ConcreteElement
	%NNDatasetNormalize transfroms neural network datasets.
	% It is a subclass of <a href="matlab:help ConcreteElement">ConcreteElement</a>.
	%
	% A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
	% The resulting combined dataset contains all the unique datapoints from the input datasets, 
	% and any overlapping datapoints are excluded to ensure data consistency.
	%
	% The list of NNDatasetNormalize properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the combined neural network dataset.
	%  <strong>10</strong> <strong>NORMALIZED_D</strong> 	Normalized_D (data, item) is the normalized neural network dataset.
	%
	% NNDatasetNormalize methods (constructor):
	%  NNDatasetNormalize - constructor
	%
	% NNDatasetNormalize methods:
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
	% NNDatasetNormalize methods (display):
	%  tostring - string with information about the normalizer of a neural network data
	%  disp - displays information about the normalizer of a neural network data
	%  tree - displays the tree of the normalizer of a neural network data
	%
	% NNDatasetNormalize methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two normalizer of a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the normalizer of a neural network data
	%
	% NNDatasetNormalize methods (save/load, Static):
	%  save - saves BRAPH2 normalizer of a neural network data as b2 file
	%  load - loads a BRAPH2 normalizer of a neural network data from a b2 file
	%
	% NNDatasetNormalize method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNDatasetNormalize method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the normalizer of a neural network data
	%
	% NNDatasetNormalize methods (inspection, Static):
	%  getClass - returns the class of the normalizer of a neural network data
	%  getSubclasses - returns all subclasses of NNDatasetNormalize
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
	% NNDatasetNormalize methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNDatasetNormalize methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNDatasetNormalize methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNDatasetNormalize methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNDatasetNormalize; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNDatasetNormalize constants</a>.
	%
	%
	% See also NNDataset, NNDatasetSplit.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		D = 9; %CET: Computational Efficiency Trick
		D_TAG = 'D';
		D_CATEGORY = 4;
		D_FORMAT = 8;
		
		NORMALIZED_D = 10; %CET: Computational Efficiency Trick
		NORMALIZED_D_TAG = 'NORMALIZED_D';
		NORMALIZED_D_CATEGORY = 4;
		NORMALIZED_D_FORMAT = 8;
	end
	methods % constructor
		function dnorm = NNDatasetNormalize(varargin)
			%NNDatasetNormalize() creates a normalizer of a neural network data.
			%
			% NNDatasetNormalize(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNDatasetNormalize(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNDatasetNormalize properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the combined neural network dataset.
			%  <strong>10</strong> <strong>NORMALIZED_D</strong> 	Normalized_D (data, item) is the normalized neural network dataset.
			%
			% See also Category, Format.
			
			dnorm = dnorm@ConcreteElement(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the normalizer of a neural network data.
			%
			% BUILD = NNDatasetNormalize.GETBUILD() returns the build of 'NNDatasetNormalize'.
			%
			% Alternative forms to call this method are:
			%  BUILD = DNORM.GETBUILD() returns the build of the normalizer of a neural network data DNORM.
			%  BUILD = Element.GETBUILD(DNORM) returns the build of 'DNORM'.
			%  BUILD = Element.GETBUILD('NNDatasetNormalize') returns the build of 'NNDatasetNormalize'.
			%
			% Note that the Element.GETBUILD(DNORM) and Element.GETBUILD('NNDatasetNormalize')
			%  are less computationally efficient.
			
			build = 1;
		end
		function dnorm_class = getClass()
			%GETCLASS returns the class of the normalizer of a neural network data.
			%
			% CLASS = NNDatasetNormalize.GETCLASS() returns the class 'NNDatasetNormalize'.
			%
			% Alternative forms to call this method are:
			%  CLASS = DNORM.GETCLASS() returns the class of the normalizer of a neural network data DNORM.
			%  CLASS = Element.GETCLASS(DNORM) returns the class of 'DNORM'.
			%  CLASS = Element.GETCLASS('NNDatasetNormalize') returns 'NNDatasetNormalize'.
			%
			% Note that the Element.GETCLASS(DNORM) and Element.GETCLASS('NNDatasetNormalize')
			%  are less computationally efficient.
			
			dnorm_class = 'NNDatasetNormalize';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the normalizer of a neural network data.
			%
			% LIST = NNDatasetNormalize.GETSUBCLASSES() returns all subclasses of 'NNDatasetNormalize'.
			%
			% Alternative forms to call this method are:
			%  LIST = DNORM.GETSUBCLASSES() returns all subclasses of the normalizer of a neural network data DNORM.
			%  LIST = Element.GETSUBCLASSES(DNORM) returns all subclasses of 'DNORM'.
			%  LIST = Element.GETSUBCLASSES('NNDatasetNormalize') returns all subclasses of 'NNDatasetNormalize'.
			%
			% Note that the Element.GETSUBCLASSES(DNORM) and Element.GETSUBCLASSES('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNDatasetNormalize' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of normalizer of a neural network data.
			%
			% PROPS = NNDatasetNormalize.GETPROPS() returns the property list of normalizer of a neural network data
			%  as a row vector.
			%
			% PROPS = NNDatasetNormalize.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = DNORM.GETPROPS([CATEGORY]) returns the property list of the normalizer of a neural network data DNORM.
			%  PROPS = Element.GETPROPS(DNORM[, CATEGORY]) returns the property list of 'DNORM'.
			%  PROPS = Element.GETPROPS('NNDatasetNormalize'[, CATEGORY]) returns the property list of 'NNDatasetNormalize'.
			%
			% Note that the Element.GETPROPS(DNORM) and Element.GETPROPS('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10];
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
					prop_list = 8;
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of normalizer of a neural network data.
			%
			% N = NNDatasetNormalize.GETPROPNUMBER() returns the property number of normalizer of a neural network data.
			%
			% N = NNDatasetNormalize.GETPROPNUMBER(CATEGORY) returns the property number of normalizer of a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = DNORM.GETPROPNUMBER([CATEGORY]) returns the property number of the normalizer of a neural network data DNORM.
			%  N = Element.GETPROPNUMBER(DNORM) returns the property number of 'DNORM'.
			%  N = Element.GETPROPNUMBER('NNDatasetNormalize') returns the property number of 'NNDatasetNormalize'.
			%
			% Note that the Element.GETPROPNUMBER(DNORM) and Element.GETPROPNUMBER('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 10;
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
					prop_number = 1;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in normalizer of a neural network data/error.
			%
			% CHECK = NNDatasetNormalize.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DNORM.EXISTSPROP(PROP) checks whether PROP exists for DNORM.
			%  CHECK = Element.EXISTSPROP(DNORM, PROP) checks whether PROP exists for DNORM.
			%  CHECK = Element.EXISTSPROP(NNDatasetNormalize, PROP) checks whether PROP exists for NNDatasetNormalize.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DNORM.EXISTSPROP(PROP) throws error if PROP does NOT exist for DNORM.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%  Element.EXISTSPROP(DNORM, PROP) throws error if PROP does NOT exist for DNORM.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%  Element.EXISTSPROP(NNDatasetNormalize, PROP) throws error if PROP does NOT exist for NNDatasetNormalize.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%
			% Note that the Element.EXISTSPROP(DNORM) and Element.EXISTSPROP('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 10 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNDatasetNormalize.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in normalizer of a neural network data/error.
			%
			% CHECK = NNDatasetNormalize.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DNORM.EXISTSTAG(TAG) checks whether TAG exists for DNORM.
			%  CHECK = Element.EXISTSTAG(DNORM, TAG) checks whether TAG exists for DNORM.
			%  CHECK = Element.EXISTSTAG(NNDatasetNormalize, TAG) checks whether TAG exists for NNDatasetNormalize.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DNORM.EXISTSTAG(TAG) throws error if TAG does NOT exist for DNORM.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%  Element.EXISTSTAG(DNORM, TAG) throws error if TAG does NOT exist for DNORM.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%  Element.EXISTSTAG(NNDatasetNormalize, TAG) throws error if TAG does NOT exist for NNDatasetNormalize.
			%   Error id: [BRAPH2:NNDatasetNormalize:WrongInput]
			%
			% Note that the Element.EXISTSTAG(DNORM) and Element.EXISTSTAG('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NORMALIZED_D' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNDatasetNormalize.'] ...
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
			%  PROPERTY = DNORM.GETPROPPROP(POINTER) returns property number of POINTER of DNORM.
			%  PROPERTY = Element.GETPROPPROP(NNDatasetNormalize, POINTER) returns property number of POINTER of NNDatasetNormalize.
			%  PROPERTY = DNORM.GETPROPPROP(NNDatasetNormalize, POINTER) returns property number of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPPROP(DNORM) and Element.GETPROPPROP('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NORMALIZED_D' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = DNORM.GETPROPTAG(POINTER) returns tag of POINTER of DNORM.
			%  TAG = Element.GETPROPTAG(NNDatasetNormalize, POINTER) returns tag of POINTER of NNDatasetNormalize.
			%  TAG = DNORM.GETPROPTAG(NNDatasetNormalize, POINTER) returns tag of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPTAG(DNORM) and Element.GETPROPTAG('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nndatasetnormalize_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NORMALIZED_D' };
				tag = nndatasetnormalize_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = DNORM.GETPROPCATEGORY(POINTER) returns category of POINTER of DNORM.
			%  CATEGORY = Element.GETPROPCATEGORY(NNDatasetNormalize, POINTER) returns category of POINTER of NNDatasetNormalize.
			%  CATEGORY = DNORM.GETPROPCATEGORY(NNDatasetNormalize, POINTER) returns category of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPCATEGORY(DNORM) and Element.GETPROPCATEGORY('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetnormalize_category_list = { 1  1  1  3  4  2  2  6  4  4 };
			prop_category = nndatasetnormalize_category_list{prop};
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
			%  FORMAT = DNORM.GETPROPFORMAT(POINTER) returns format of POINTER of DNORM.
			%  FORMAT = Element.GETPROPFORMAT(NNDatasetNormalize, POINTER) returns format of POINTER of NNDatasetNormalize.
			%  FORMAT = DNORM.GETPROPFORMAT(NNDatasetNormalize, POINTER) returns format of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPFORMAT(DNORM) and Element.GETPROPFORMAT('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetnormalize_format_list = { 2  2  2  8  2  2  2  2  8  8 };
			prop_format = nndatasetnormalize_format_list{prop};
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
			%  DESCRIPTION = DNORM.GETPROPDESCRIPTION(POINTER) returns description of POINTER of DNORM.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNDatasetNormalize, POINTER) returns description of POINTER of NNDatasetNormalize.
			%  DESCRIPTION = DNORM.GETPROPDESCRIPTION(NNDatasetNormalize, POINTER) returns description of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPDESCRIPTION(DNORM) and Element.GETPROPDESCRIPTION('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetnormalize_description_list = { 'ELCLASS (constant, string) is the class of the combiner of neural networks datasets.'  'NAME (constant, string) is the name of the combiner of neural networks datasets.'  'DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.'  'TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.'  'ID (data, string) is a few-letter code of the combiner of neural networks datasets.'  'LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.'  'NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the combined neural network dataset.'  'Normalized_D (data, item) is the normalized neural network dataset.' };
			prop_description = nndatasetnormalize_description_list{prop};
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
			%  SETTINGS = DNORM.GETPROPSETTINGS(POINTER) returns settings of POINTER of DNORM.
			%  SETTINGS = Element.GETPROPSETTINGS(NNDatasetNormalize, POINTER) returns settings of POINTER of NNDatasetNormalize.
			%  SETTINGS = DNORM.GETPROPSETTINGS(NNDatasetNormalize, POINTER) returns settings of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPSETTINGS(DNORM) and Element.GETPROPSETTINGS('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case NNDatasetNormalize.D % __NNDatasetNormalize.D__
					prop_settings = 'NNDataset';
				case NNDatasetNormalize.NORMALIZED_D % __NNDatasetNormalize.NORMALIZED_D__
					prop_settings = 'NNDataset';
				case NNDatasetNormalize.TEMPLATE % __NNDatasetNormalize.TEMPLATE__
					prop_settings = 'NNDatasetCombine';
				otherwise
					prop_settings = getPropSettings@ConcreteElement(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNDatasetNormalize.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetNormalize.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DNORM.GETPROPDEFAULT(POINTER) returns the default value of POINTER of DNORM.
			%  DEFAULT = Element.GETPROPDEFAULT(NNDatasetNormalize, POINTER) returns the default value of POINTER of NNDatasetNormalize.
			%  DEFAULT = DNORM.GETPROPDEFAULT(NNDatasetNormalize, POINTER) returns the default value of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPDEFAULT(DNORM) and Element.GETPROPDEFAULT('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case NNDatasetNormalize.D % __NNDatasetNormalize.D__
					prop_default = Format.getFormatDefault(8, NNDatasetNormalize.getPropSettings(prop));
				case NNDatasetNormalize.NORMALIZED_D % __NNDatasetNormalize.NORMALIZED_D__
					prop_default = Format.getFormatDefault(8, NNDatasetNormalize.getPropSettings(prop));
				case NNDatasetNormalize.ELCLASS % __NNDatasetNormalize.ELCLASS__
					prop_default = 'NNDatasetCombine';
				case NNDatasetNormalize.NAME % __NNDatasetNormalize.NAME__
					prop_default = 'Neural Network Dataset Combiner';
				case NNDatasetNormalize.DESCRIPTION % __NNDatasetNormalize.DESCRIPTION__
					prop_default = 'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.';
				case NNDatasetNormalize.TEMPLATE % __NNDatasetNormalize.TEMPLATE__
					prop_default = Format.getFormatDefault(8, NNDatasetNormalize.getPropSettings(prop));
				case NNDatasetNormalize.ID % __NNDatasetNormalize.ID__
					prop_default = 'NNDatasetCombine ID';
				case NNDatasetNormalize.LABEL % __NNDatasetNormalize.LABEL__
					prop_default = 'NNDatasetCombine label';
				case NNDatasetNormalize.NOTES % __NNDatasetNormalize.NOTES__
					prop_default = 'NNDatasetCombine notes';
				otherwise
					prop_default = getPropDefault@ConcreteElement(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNDatasetNormalize.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetNormalize.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DNORM.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of DNORM.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNDatasetNormalize, POINTER) returns the conditioned default value of POINTER of NNDatasetNormalize.
			%  DEFAULT = DNORM.GETPROPDEFAULTCONDITIONED(NNDatasetNormalize, POINTER) returns the conditioned default value of POINTER of NNDatasetNormalize.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(DNORM) and Element.GETPROPDEFAULTCONDITIONED('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			prop_default = NNDatasetNormalize.conditioning(prop, NNDatasetNormalize.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = DNORM.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = DNORM.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of DNORM.
			%  CHECK = Element.CHECKPROP(NNDatasetNormalize, PROP, VALUE) checks VALUE format for PROP of NNDatasetNormalize.
			%  CHECK = DNORM.CHECKPROP(NNDatasetNormalize, PROP, VALUE) checks VALUE format for PROP of NNDatasetNormalize.
			% 
			% DNORM.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNDatasetNormalize:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DNORM.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of DNORM.
			%   Error id: BRAPH2:NNDatasetNormalize:WrongInput
			%  Element.CHECKPROP(NNDatasetNormalize, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetNormalize.
			%   Error id: BRAPH2:NNDatasetNormalize:WrongInput
			%  DNORM.CHECKPROP(NNDatasetNormalize, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetNormalize.
			%   Error id: BRAPH2:NNDatasetNormalize:WrongInput]
			% 
			% Note that the Element.CHECKPROP(DNORM) and Element.CHECKPROP('NNDatasetNormalize')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNDatasetNormalize.getPropProp(pointer);
			
			switch prop
				case NNDatasetNormalize.D % __NNDatasetNormalize.D__
					check = Format.checkFormat(8, value, NNDatasetNormalize.getPropSettings(prop));
				case NNDatasetNormalize.NORMALIZED_D % __NNDatasetNormalize.NORMALIZED_D__
					check = Format.checkFormat(8, value, NNDatasetNormalize.getPropSettings(prop));
				case NNDatasetNormalize.TEMPLATE % __NNDatasetNormalize.TEMPLATE__
					check = Format.checkFormat(8, value, NNDatasetNormalize.getPropSettings(prop));
				otherwise
					if prop <= ConcreteElement.getPropNumber()
						check = checkProp@ConcreteElement(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetNormalize:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNDatasetNormalize.getPropTag(prop) ' (' NNDatasetNormalize.getFormatTag(NNDatasetNormalize.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
end
