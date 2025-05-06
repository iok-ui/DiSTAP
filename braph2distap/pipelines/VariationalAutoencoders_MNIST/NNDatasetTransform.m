classdef NNDatasetTransform < ConcreteElement
	%NNDatasetTransform transfroms neural network datasets.
	% It is a subclass of <a href="matlab:help ConcreteElement">ConcreteElement</a>.
	%
	% A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. 
	% The resulting combined dataset contains all the unique datapoints from the input datasets, 
	% and any overlapping datapoints are excluded to ensure data consistency.
	%
	% The list of NNDatasetTransform properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the combined neural network dataset.
	%  <strong>10</strong> <strong>TRANSFORMED_D</strong> 	Transformed_D (data, item) is the transformed neural network dataset.
	%
	% NNDatasetTransform methods (constructor):
	%  NNDatasetTransform - constructor
	%
	% NNDatasetTransform methods:
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
	% NNDatasetTransform methods (display):
	%  tostring - string with information about the transformer of a neural network data
	%  disp - displays information about the transformer of a neural network data
	%  tree - displays the tree of the transformer of a neural network data
	%
	% NNDatasetTransform methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two transformer of a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the transformer of a neural network data
	%
	% NNDatasetTransform methods (save/load, Static):
	%  save - saves BRAPH2 transformer of a neural network data as b2 file
	%  load - loads a BRAPH2 transformer of a neural network data from a b2 file
	%
	% NNDatasetTransform method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the transformer of a neural network data
	%
	% NNDatasetTransform method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the transformer of a neural network data
	%
	% NNDatasetTransform methods (inspection, Static):
	%  getClass - returns the class of the transformer of a neural network data
	%  getSubclasses - returns all subclasses of NNDatasetTransform
	%  getProps - returns the property list of the transformer of a neural network data
	%  getPropNumber - returns the property number of the transformer of a neural network data
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
	% NNDatasetTransform methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNDatasetTransform methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNDatasetTransform methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNDatasetTransform methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNDatasetTransform; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNDatasetTransform constants</a>.
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
		
		TRANSFORMED_D = 10; %CET: Computational Efficiency Trick
		TRANSFORMED_D_TAG = 'TRANSFORMED_D';
		TRANSFORMED_D_CATEGORY = 4;
		TRANSFORMED_D_FORMAT = 8;
	end
	methods % constructor
		function dtran = NNDatasetTransform(varargin)
			%NNDatasetTransform() creates a transformer of a neural network data.
			%
			% NNDatasetTransform(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNDatasetTransform(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNDatasetTransform properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the combiner of neural networks datasets.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the combiner of neural networks datasets.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the combiner of neural networks datasets.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the combined neural network dataset.
			%  <strong>10</strong> <strong>TRANSFORMED_D</strong> 	Transformed_D (data, item) is the transformed neural network dataset.
			%
			% See also Category, Format.
			
			dtran = dtran@ConcreteElement(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the transformer of a neural network data.
			%
			% BUILD = NNDatasetTransform.GETBUILD() returns the build of 'NNDatasetTransform'.
			%
			% Alternative forms to call this method are:
			%  BUILD = DTRAN.GETBUILD() returns the build of the transformer of a neural network data DTRAN.
			%  BUILD = Element.GETBUILD(DTRAN) returns the build of 'DTRAN'.
			%  BUILD = Element.GETBUILD('NNDatasetTransform') returns the build of 'NNDatasetTransform'.
			%
			% Note that the Element.GETBUILD(DTRAN) and Element.GETBUILD('NNDatasetTransform')
			%  are less computationally efficient.
			
			build = 1;
		end
		function dtran_class = getClass()
			%GETCLASS returns the class of the transformer of a neural network data.
			%
			% CLASS = NNDatasetTransform.GETCLASS() returns the class 'NNDatasetTransform'.
			%
			% Alternative forms to call this method are:
			%  CLASS = DTRAN.GETCLASS() returns the class of the transformer of a neural network data DTRAN.
			%  CLASS = Element.GETCLASS(DTRAN) returns the class of 'DTRAN'.
			%  CLASS = Element.GETCLASS('NNDatasetTransform') returns 'NNDatasetTransform'.
			%
			% Note that the Element.GETCLASS(DTRAN) and Element.GETCLASS('NNDatasetTransform')
			%  are less computationally efficient.
			
			dtran_class = 'NNDatasetTransform';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the transformer of a neural network data.
			%
			% LIST = NNDatasetTransform.GETSUBCLASSES() returns all subclasses of 'NNDatasetTransform'.
			%
			% Alternative forms to call this method are:
			%  LIST = DTRAN.GETSUBCLASSES() returns all subclasses of the transformer of a neural network data DTRAN.
			%  LIST = Element.GETSUBCLASSES(DTRAN) returns all subclasses of 'DTRAN'.
			%  LIST = Element.GETSUBCLASSES('NNDatasetTransform') returns all subclasses of 'NNDatasetTransform'.
			%
			% Note that the Element.GETSUBCLASSES(DTRAN) and Element.GETSUBCLASSES('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNDatasetTransform' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of transformer of a neural network data.
			%
			% PROPS = NNDatasetTransform.GETPROPS() returns the property list of transformer of a neural network data
			%  as a row vector.
			%
			% PROPS = NNDatasetTransform.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = DTRAN.GETPROPS([CATEGORY]) returns the property list of the transformer of a neural network data DTRAN.
			%  PROPS = Element.GETPROPS(DTRAN[, CATEGORY]) returns the property list of 'DTRAN'.
			%  PROPS = Element.GETPROPS('NNDatasetTransform'[, CATEGORY]) returns the property list of 'NNDatasetTransform'.
			%
			% Note that the Element.GETPROPS(DTRAN) and Element.GETPROPS('NNDatasetTransform')
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
			%GETPROPNUMBER returns the property number of transformer of a neural network data.
			%
			% N = NNDatasetTransform.GETPROPNUMBER() returns the property number of transformer of a neural network data.
			%
			% N = NNDatasetTransform.GETPROPNUMBER(CATEGORY) returns the property number of transformer of a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = DTRAN.GETPROPNUMBER([CATEGORY]) returns the property number of the transformer of a neural network data DTRAN.
			%  N = Element.GETPROPNUMBER(DTRAN) returns the property number of 'DTRAN'.
			%  N = Element.GETPROPNUMBER('NNDatasetTransform') returns the property number of 'NNDatasetTransform'.
			%
			% Note that the Element.GETPROPNUMBER(DTRAN) and Element.GETPROPNUMBER('NNDatasetTransform')
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
			%EXISTSPROP checks whether property exists in transformer of a neural network data/error.
			%
			% CHECK = NNDatasetTransform.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DTRAN.EXISTSPROP(PROP) checks whether PROP exists for DTRAN.
			%  CHECK = Element.EXISTSPROP(DTRAN, PROP) checks whether PROP exists for DTRAN.
			%  CHECK = Element.EXISTSPROP(NNDatasetTransform, PROP) checks whether PROP exists for NNDatasetTransform.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DTRAN.EXISTSPROP(PROP) throws error if PROP does NOT exist for DTRAN.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%  Element.EXISTSPROP(DTRAN, PROP) throws error if PROP does NOT exist for DTRAN.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%  Element.EXISTSPROP(NNDatasetTransform, PROP) throws error if PROP does NOT exist for NNDatasetTransform.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%
			% Note that the Element.EXISTSPROP(DTRAN) and Element.EXISTSPROP('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 10 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNDatasetTransform.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in transformer of a neural network data/error.
			%
			% CHECK = NNDatasetTransform.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DTRAN.EXISTSTAG(TAG) checks whether TAG exists for DTRAN.
			%  CHECK = Element.EXISTSTAG(DTRAN, TAG) checks whether TAG exists for DTRAN.
			%  CHECK = Element.EXISTSTAG(NNDatasetTransform, TAG) checks whether TAG exists for NNDatasetTransform.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DTRAN.EXISTSTAG(TAG) throws error if TAG does NOT exist for DTRAN.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%  Element.EXISTSTAG(DTRAN, TAG) throws error if TAG does NOT exist for DTRAN.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%  Element.EXISTSTAG(NNDatasetTransform, TAG) throws error if TAG does NOT exist for NNDatasetTransform.
			%   Error id: [BRAPH2:NNDatasetTransform:WrongInput]
			%
			% Note that the Element.EXISTSTAG(DTRAN) and Element.EXISTSTAG('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'TRANSFORMED_D' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNDatasetTransform.'] ...
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
			%  PROPERTY = DTRAN.GETPROPPROP(POINTER) returns property number of POINTER of DTRAN.
			%  PROPERTY = Element.GETPROPPROP(NNDatasetTransform, POINTER) returns property number of POINTER of NNDatasetTransform.
			%  PROPERTY = DTRAN.GETPROPPROP(NNDatasetTransform, POINTER) returns property number of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPPROP(DTRAN) and Element.GETPROPPROP('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'TRANSFORMED_D' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = DTRAN.GETPROPTAG(POINTER) returns tag of POINTER of DTRAN.
			%  TAG = Element.GETPROPTAG(NNDatasetTransform, POINTER) returns tag of POINTER of NNDatasetTransform.
			%  TAG = DTRAN.GETPROPTAG(NNDatasetTransform, POINTER) returns tag of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPTAG(DTRAN) and Element.GETPROPTAG('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nndatasettransform_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'TRANSFORMED_D' };
				tag = nndatasettransform_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = DTRAN.GETPROPCATEGORY(POINTER) returns category of POINTER of DTRAN.
			%  CATEGORY = Element.GETPROPCATEGORY(NNDatasetTransform, POINTER) returns category of POINTER of NNDatasetTransform.
			%  CATEGORY = DTRAN.GETPROPCATEGORY(NNDatasetTransform, POINTER) returns category of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPCATEGORY(DTRAN) and Element.GETPROPCATEGORY('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasettransform_category_list = { 1  1  1  3  4  2  2  6  4  4 };
			prop_category = nndatasettransform_category_list{prop};
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
			%  FORMAT = DTRAN.GETPROPFORMAT(POINTER) returns format of POINTER of DTRAN.
			%  FORMAT = Element.GETPROPFORMAT(NNDatasetTransform, POINTER) returns format of POINTER of NNDatasetTransform.
			%  FORMAT = DTRAN.GETPROPFORMAT(NNDatasetTransform, POINTER) returns format of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPFORMAT(DTRAN) and Element.GETPROPFORMAT('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasettransform_format_list = { 2  2  2  8  2  2  2  2  8  8 };
			prop_format = nndatasettransform_format_list{prop};
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
			%  DESCRIPTION = DTRAN.GETPROPDESCRIPTION(POINTER) returns description of POINTER of DTRAN.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNDatasetTransform, POINTER) returns description of POINTER of NNDatasetTransform.
			%  DESCRIPTION = DTRAN.GETPROPDESCRIPTION(NNDatasetTransform, POINTER) returns description of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPDESCRIPTION(DTRAN) and Element.GETPROPDESCRIPTION('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasettransform_description_list = { 'ELCLASS (constant, string) is the class of the combiner of neural networks datasets.'  'NAME (constant, string) is the name of the combiner of neural networks datasets.'  'DESCRIPTION (constant, string) is the description of the combiner of neural networks datasets.'  'TEMPLATE (parameter, item) is the template of the combiner of neural networks datasets.'  'ID (data, string) is a few-letter code of the combiner of neural networks datasets.'  'LABEL (metadata, string) is an extended label of the combiner of neural networks datasets.'  'NOTES (metadata, string) are some specific notes of the combiner of neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the combined neural network dataset.'  'Transformed_D (data, item) is the transformed neural network dataset.' };
			prop_description = nndatasettransform_description_list{prop};
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
			%  SETTINGS = DTRAN.GETPROPSETTINGS(POINTER) returns settings of POINTER of DTRAN.
			%  SETTINGS = Element.GETPROPSETTINGS(NNDatasetTransform, POINTER) returns settings of POINTER of NNDatasetTransform.
			%  SETTINGS = DTRAN.GETPROPSETTINGS(NNDatasetTransform, POINTER) returns settings of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPSETTINGS(DTRAN) and Element.GETPROPSETTINGS('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case NNDatasetTransform.D % __NNDatasetTransform.D__
					prop_settings = 'NNDataset';
				case NNDatasetTransform.TRANSFORMED_D % __NNDatasetTransform.TRANSFORMED_D__
					prop_settings = 'NNDataset';
				case NNDatasetTransform.TEMPLATE % __NNDatasetTransform.TEMPLATE__
					prop_settings = 'NNDatasetCombine';
				otherwise
					prop_settings = getPropSettings@ConcreteElement(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNDatasetTransform.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetTransform.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DTRAN.GETPROPDEFAULT(POINTER) returns the default value of POINTER of DTRAN.
			%  DEFAULT = Element.GETPROPDEFAULT(NNDatasetTransform, POINTER) returns the default value of POINTER of NNDatasetTransform.
			%  DEFAULT = DTRAN.GETPROPDEFAULT(NNDatasetTransform, POINTER) returns the default value of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPDEFAULT(DTRAN) and Element.GETPROPDEFAULT('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case NNDatasetTransform.D % __NNDatasetTransform.D__
					prop_default = Format.getFormatDefault(8, NNDatasetTransform.getPropSettings(prop));
				case NNDatasetTransform.TRANSFORMED_D % __NNDatasetTransform.TRANSFORMED_D__
					prop_default = Format.getFormatDefault(8, NNDatasetTransform.getPropSettings(prop));
				case NNDatasetTransform.ELCLASS % __NNDatasetTransform.ELCLASS__
					prop_default = 'NNDatasetCombine';
				case NNDatasetTransform.NAME % __NNDatasetTransform.NAME__
					prop_default = 'Neural Network Dataset Combiner';
				case NNDatasetTransform.DESCRIPTION % __NNDatasetTransform.DESCRIPTION__
					prop_default = 'A dataset combiner (NNDatasetCombine) takes a list of neural network datasets and combines them into a single dataset. The resulting combined dataset contains all the unique datapoints from the input datasets, and any overlapping datapoints are excluded to ensure data consistency.';
				case NNDatasetTransform.TEMPLATE % __NNDatasetTransform.TEMPLATE__
					prop_default = Format.getFormatDefault(8, NNDatasetTransform.getPropSettings(prop));
				case NNDatasetTransform.ID % __NNDatasetTransform.ID__
					prop_default = 'NNDatasetCombine ID';
				case NNDatasetTransform.LABEL % __NNDatasetTransform.LABEL__
					prop_default = 'NNDatasetCombine label';
				case NNDatasetTransform.NOTES % __NNDatasetTransform.NOTES__
					prop_default = 'NNDatasetCombine notes';
				otherwise
					prop_default = getPropDefault@ConcreteElement(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNDatasetTransform.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetTransform.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DTRAN.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of DTRAN.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNDatasetTransform, POINTER) returns the conditioned default value of POINTER of NNDatasetTransform.
			%  DEFAULT = DTRAN.GETPROPDEFAULTCONDITIONED(NNDatasetTransform, POINTER) returns the conditioned default value of POINTER of NNDatasetTransform.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(DTRAN) and Element.GETPROPDEFAULTCONDITIONED('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			prop_default = NNDatasetTransform.conditioning(prop, NNDatasetTransform.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = DTRAN.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = DTRAN.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of DTRAN.
			%  CHECK = Element.CHECKPROP(NNDatasetTransform, PROP, VALUE) checks VALUE format for PROP of NNDatasetTransform.
			%  CHECK = DTRAN.CHECKPROP(NNDatasetTransform, PROP, VALUE) checks VALUE format for PROP of NNDatasetTransform.
			% 
			% DTRAN.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNDatasetTransform:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DTRAN.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of DTRAN.
			%   Error id: BRAPH2:NNDatasetTransform:WrongInput
			%  Element.CHECKPROP(NNDatasetTransform, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetTransform.
			%   Error id: BRAPH2:NNDatasetTransform:WrongInput
			%  DTRAN.CHECKPROP(NNDatasetTransform, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetTransform.
			%   Error id: BRAPH2:NNDatasetTransform:WrongInput]
			% 
			% Note that the Element.CHECKPROP(DTRAN) and Element.CHECKPROP('NNDatasetTransform')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNDatasetTransform.getPropProp(pointer);
			
			switch prop
				case NNDatasetTransform.D % __NNDatasetTransform.D__
					check = Format.checkFormat(8, value, NNDatasetTransform.getPropSettings(prop));
				case NNDatasetTransform.TRANSFORMED_D % __NNDatasetTransform.TRANSFORMED_D__
					check = Format.checkFormat(8, value, NNDatasetTransform.getPropSettings(prop));
				case NNDatasetTransform.TEMPLATE % __NNDatasetTransform.TEMPLATE__
					check = Format.checkFormat(8, value, NNDatasetTransform.getPropSettings(prop));
				otherwise
					if prop <= ConcreteElement.getPropNumber()
						check = checkProp@ConcreteElement(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetTransform:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNDatasetTransform.getPropTag(prop) ' (' NNDatasetTransform.getFormatTag(NNDatasetTransform.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
end
