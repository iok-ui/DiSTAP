classdef NNDatasetProcess_SpectrumSignal < NNDatasetProcess
	%NNDatasetProcess_SpectrumSignal processes raw MNIST data into a neural network datasets.
	% It is a subclass of <a href="matlab:help NNDatasetProcess">NNDatasetProcess</a>.
	%
	% The Raman sepctrum processing for a neural network dataset (NNDatasetProcess_Spectrum) processes the raw raman spectrum data into a neural network dataset. 
	%  The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.
	%
	% The list of NNDatasetProcess_SpectrumSignal properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of processing MNIST data for a neural networks datasets.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of processing MNIST data for a neural networks datasets.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of processing data for a neural networks datasets.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of processing data for a neural networks datasets.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of processing data for a neural networks datasets.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of processing data for a neural networks datasets.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of processing data for a neural networks datasets.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (result, item) is the neural network dataset containing the datapoint processed from the raw data.
	%  <strong>10</strong> <strong>RAW_DATA_DIR</strong> 	RAW_DATA_DIR (data, string) contains the directory of the b2 file for spectrum data.
	%  <strong>11</strong> <strong>WAVELENGTH_START</strong> 	WAVELENGTH_START (parameter, scalar) is the starting wavelength.
	%  <strong>12</strong> <strong>WAVELENGTH_END</strong> 	WAVELENGTH_END (parameter, scalar) is the ending  wavelength.
	%  <strong>13</strong> <strong>TRANSFORMATION_RULE</strong> 	TRANSFORMATION_RULE (parameter, option) is the transformation methods.
	%  <strong>14</strong> <strong>NORMALIZATION_RULE</strong> 	NORMALIZATION_RULE (parameter, option) is the normalization methods.
	%  <strong>15</strong> <strong>SCALE_FACTOR</strong> 	SCALE_FACTOR (parameter, scalar) is the normalization methods.
	%  <strong>16</strong> <strong>WAVELENGTH</strong> 	WAVELENGTH (result, cvector) is the wavelength.
	%  <strong>17</strong> <strong>EXTRACT_DATA</strong> 	EXTRACT_DATA (query, cell) extracts the images from the specified IDX files.
	%  <strong>18</strong> <strong>EXTRACT_LABELS</strong> 	EXTRACT_LABELS (query, stringlist) extracts the labels from the specified IDX files.
	%
	% NNDatasetProcess_SpectrumSignal methods (constructor):
	%  NNDatasetProcess_SpectrumSignal - constructor
	%
	% NNDatasetProcess_SpectrumSignal methods:
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
	% NNDatasetProcess_SpectrumSignal methods (display):
	%  tostring - string with information about the processing for a neural network data
	%  disp - displays information about the processing for a neural network data
	%  tree - displays the tree of the processing for a neural network data
	%
	% NNDatasetProcess_SpectrumSignal methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two processing for a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the processing for a neural network data
	%
	% NNDatasetProcess_SpectrumSignal methods (save/load, Static):
	%  save - saves BRAPH2 processing for a neural network data as b2 file
	%  load - loads a BRAPH2 processing for a neural network data from a b2 file
	%
	% NNDatasetProcess_SpectrumSignal method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the processing for a neural network data
	%
	% NNDatasetProcess_SpectrumSignal method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the processing for a neural network data
	%
	% NNDatasetProcess_SpectrumSignal methods (inspection, Static):
	%  getClass - returns the class of the processing for a neural network data
	%  getSubclasses - returns all subclasses of NNDatasetProcess_SpectrumSignal
	%  getProps - returns the property list of the processing for a neural network data
	%  getPropNumber - returns the property number of the processing for a neural network data
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
	% NNDatasetProcess_SpectrumSignal methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNDatasetProcess_SpectrumSignal methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNDatasetProcess_SpectrumSignal methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNDatasetProcess_SpectrumSignal methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNDatasetProcess_SpectrumSignal; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNDatasetProcess_SpectrumSignal constants</a>.
	%
	%
	% See also NNDatasetProcess, NNDataPoint.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		RAW_DATA_DIR = 10; %CET: Computational Efficiency Trick
		RAW_DATA_DIR_TAG = 'RAW_DATA_DIR';
		RAW_DATA_DIR_CATEGORY = 4;
		RAW_DATA_DIR_FORMAT = 2;
		
		WAVELENGTH_START = 11; %CET: Computational Efficiency Trick
		WAVELENGTH_START_TAG = 'WAVELENGTH_START';
		WAVELENGTH_START_CATEGORY = 3;
		WAVELENGTH_START_FORMAT = 11;
		
		WAVELENGTH_END = 12; %CET: Computational Efficiency Trick
		WAVELENGTH_END_TAG = 'WAVELENGTH_END';
		WAVELENGTH_END_CATEGORY = 3;
		WAVELENGTH_END_FORMAT = 11;
		
		TRANSFORMATION_RULE = 13; %CET: Computational Efficiency Trick
		TRANSFORMATION_RULE_TAG = 'TRANSFORMATION_RULE';
		TRANSFORMATION_RULE_CATEGORY = 3;
		TRANSFORMATION_RULE_FORMAT = 5;
		
		NORMALIZATION_RULE = 14; %CET: Computational Efficiency Trick
		NORMALIZATION_RULE_TAG = 'NORMALIZATION_RULE';
		NORMALIZATION_RULE_CATEGORY = 3;
		NORMALIZATION_RULE_FORMAT = 5;
		
		SCALE_FACTOR = 15; %CET: Computational Efficiency Trick
		SCALE_FACTOR_TAG = 'SCALE_FACTOR';
		SCALE_FACTOR_CATEGORY = 3;
		SCALE_FACTOR_FORMAT = 11;
		
		WAVELENGTH = 16; %CET: Computational Efficiency Trick
		WAVELENGTH_TAG = 'WAVELENGTH';
		WAVELENGTH_CATEGORY = 5;
		WAVELENGTH_FORMAT = 13;
		
		EXTRACT_DATA = 17; %CET: Computational Efficiency Trick
		EXTRACT_DATA_TAG = 'EXTRACT_DATA';
		EXTRACT_DATA_CATEGORY = 6;
		EXTRACT_DATA_FORMAT = 16;
		
		EXTRACT_LABELS = 18; %CET: Computational Efficiency Trick
		EXTRACT_LABELS_TAG = 'EXTRACT_LABELS';
		EXTRACT_LABELS_CATEGORY = 6;
		EXTRACT_LABELS_FORMAT = 3;
	end
	methods % constructor
		function dproc = NNDatasetProcess_SpectrumSignal(varargin)
			%NNDatasetProcess_SpectrumSignal() creates a processing for a neural network data.
			%
			% NNDatasetProcess_SpectrumSignal(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNDatasetProcess_SpectrumSignal(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNDatasetProcess_SpectrumSignal properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of processing MNIST data for a neural networks datasets.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of processing MNIST data for a neural networks datasets.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of processing data for a neural networks datasets.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of processing data for a neural networks datasets.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of processing data for a neural networks datasets.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of processing data for a neural networks datasets.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes of processing data for a neural networks datasets.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (result, item) is the neural network dataset containing the datapoint processed from the raw data.
			%  <strong>10</strong> <strong>RAW_DATA_DIR</strong> 	RAW_DATA_DIR (data, string) contains the directory of the b2 file for spectrum data.
			%  <strong>11</strong> <strong>WAVELENGTH_START</strong> 	WAVELENGTH_START (parameter, scalar) is the starting wavelength.
			%  <strong>12</strong> <strong>WAVELENGTH_END</strong> 	WAVELENGTH_END (parameter, scalar) is the ending  wavelength.
			%  <strong>13</strong> <strong>TRANSFORMATION_RULE</strong> 	TRANSFORMATION_RULE (parameter, option) is the transformation methods.
			%  <strong>14</strong> <strong>NORMALIZATION_RULE</strong> 	NORMALIZATION_RULE (parameter, option) is the normalization methods.
			%  <strong>15</strong> <strong>SCALE_FACTOR</strong> 	SCALE_FACTOR (parameter, scalar) is the normalization methods.
			%  <strong>16</strong> <strong>WAVELENGTH</strong> 	WAVELENGTH (result, cvector) is the wavelength.
			%  <strong>17</strong> <strong>EXTRACT_DATA</strong> 	EXTRACT_DATA (query, cell) extracts the images from the specified IDX files.
			%  <strong>18</strong> <strong>EXTRACT_LABELS</strong> 	EXTRACT_LABELS (query, stringlist) extracts the labels from the specified IDX files.
			%
			% See also Category, Format.
			
			dproc = dproc@NNDatasetProcess(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the processing for a neural network data.
			%
			% BUILD = NNDatasetProcess_SpectrumSignal.GETBUILD() returns the build of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Alternative forms to call this method are:
			%  BUILD = DPROC.GETBUILD() returns the build of the processing for a neural network data DPROC.
			%  BUILD = Element.GETBUILD(DPROC) returns the build of 'DPROC'.
			%  BUILD = Element.GETBUILD('NNDatasetProcess_SpectrumSignal') returns the build of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Note that the Element.GETBUILD(DPROC) and Element.GETBUILD('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			
			build = 1;
		end
		function dproc_class = getClass()
			%GETCLASS returns the class of the processing for a neural network data.
			%
			% CLASS = NNDatasetProcess_SpectrumSignal.GETCLASS() returns the class 'NNDatasetProcess_SpectrumSignal'.
			%
			% Alternative forms to call this method are:
			%  CLASS = DPROC.GETCLASS() returns the class of the processing for a neural network data DPROC.
			%  CLASS = Element.GETCLASS(DPROC) returns the class of 'DPROC'.
			%  CLASS = Element.GETCLASS('NNDatasetProcess_SpectrumSignal') returns 'NNDatasetProcess_SpectrumSignal'.
			%
			% Note that the Element.GETCLASS(DPROC) and Element.GETCLASS('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			
			dproc_class = 'NNDatasetProcess_SpectrumSignal';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the processing for a neural network data.
			%
			% LIST = NNDatasetProcess_SpectrumSignal.GETSUBCLASSES() returns all subclasses of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Alternative forms to call this method are:
			%  LIST = DPROC.GETSUBCLASSES() returns all subclasses of the processing for a neural network data DPROC.
			%  LIST = Element.GETSUBCLASSES(DPROC) returns all subclasses of 'DPROC'.
			%  LIST = Element.GETSUBCLASSES('NNDatasetProcess_SpectrumSignal') returns all subclasses of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Note that the Element.GETSUBCLASSES(DPROC) and Element.GETSUBCLASSES('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNDatasetProcess_SpectrumSignal' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of processing for a neural network data.
			%
			% PROPS = NNDatasetProcess_SpectrumSignal.GETPROPS() returns the property list of processing for a neural network data
			%  as a row vector.
			%
			% PROPS = NNDatasetProcess_SpectrumSignal.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = DPROC.GETPROPS([CATEGORY]) returns the property list of the processing for a neural network data DPROC.
			%  PROPS = Element.GETPROPS(DPROC[, CATEGORY]) returns the property list of 'DPROC'.
			%  PROPS = Element.GETPROPS('NNDatasetProcess_SpectrumSignal'[, CATEGORY]) returns the property list of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Note that the Element.GETPROPS(DPROC) and Element.GETPROPS('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = [4 11 12 13 14 15];
				case 4 % Category.DATA
					prop_list = [5 10];
				case 5 % Category.RESULT
					prop_list = [9 16];
				case 6 % Category.QUERY
					prop_list = [8 17 18];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of processing for a neural network data.
			%
			% N = NNDatasetProcess_SpectrumSignal.GETPROPNUMBER() returns the property number of processing for a neural network data.
			%
			% N = NNDatasetProcess_SpectrumSignal.GETPROPNUMBER(CATEGORY) returns the property number of processing for a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = DPROC.GETPROPNUMBER([CATEGORY]) returns the property number of the processing for a neural network data DPROC.
			%  N = Element.GETPROPNUMBER(DPROC) returns the property number of 'DPROC'.
			%  N = Element.GETPROPNUMBER('NNDatasetProcess_SpectrumSignal') returns the property number of 'NNDatasetProcess_SpectrumSignal'.
			%
			% Note that the Element.GETPROPNUMBER(DPROC) and Element.GETPROPNUMBER('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 18;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 6;
				case 4 % Category.DATA
					prop_number = 2;
				case 5 % Category.RESULT
					prop_number = 2;
				case 6 % Category.QUERY
					prop_number = 3;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in processing for a neural network data/error.
			%
			% CHECK = NNDatasetProcess_SpectrumSignal.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DPROC.EXISTSPROP(PROP) checks whether PROP exists for DPROC.
			%  CHECK = Element.EXISTSPROP(DPROC, PROP) checks whether PROP exists for DPROC.
			%  CHECK = Element.EXISTSPROP(NNDatasetProcess_SpectrumSignal, PROP) checks whether PROP exists for NNDatasetProcess_SpectrumSignal.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DPROC.EXISTSPROP(PROP) throws error if PROP does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%  Element.EXISTSPROP(DPROC, PROP) throws error if PROP does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%  Element.EXISTSPROP(NNDatasetProcess_SpectrumSignal, PROP) throws error if PROP does NOT exist for NNDatasetProcess_SpectrumSignal.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%
			% Note that the Element.EXISTSPROP(DPROC) and Element.EXISTSPROP('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 18 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNDatasetProcess_SpectrumSignal.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in processing for a neural network data/error.
			%
			% CHECK = NNDatasetProcess_SpectrumSignal.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DPROC.EXISTSTAG(TAG) checks whether TAG exists for DPROC.
			%  CHECK = Element.EXISTSTAG(DPROC, TAG) checks whether TAG exists for DPROC.
			%  CHECK = Element.EXISTSTAG(NNDatasetProcess_SpectrumSignal, TAG) checks whether TAG exists for NNDatasetProcess_SpectrumSignal.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DPROC.EXISTSTAG(TAG) throws error if TAG does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%  Element.EXISTSTAG(DPROC, TAG) throws error if TAG does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%  Element.EXISTSTAG(NNDatasetProcess_SpectrumSignal, TAG) throws error if TAG does NOT exist for NNDatasetProcess_SpectrumSignal.
			%   Error id: [BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			%
			% Note that the Element.EXISTSTAG(DPROC) and Element.EXISTSTAG('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'EXTRACT_DATA'  'EXTRACT_LABELS' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNDatasetProcess_SpectrumSignal.'] ...
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
			%  PROPERTY = DPROC.GETPROPPROP(POINTER) returns property number of POINTER of DPROC.
			%  PROPERTY = Element.GETPROPPROP(NNDatasetProcess_SpectrumSignal, POINTER) returns property number of POINTER of NNDatasetProcess_SpectrumSignal.
			%  PROPERTY = DPROC.GETPROPPROP(NNDatasetProcess_SpectrumSignal, POINTER) returns property number of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPPROP(DPROC) and Element.GETPROPPROP('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'EXTRACT_DATA'  'EXTRACT_LABELS' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = DPROC.GETPROPTAG(POINTER) returns tag of POINTER of DPROC.
			%  TAG = Element.GETPROPTAG(NNDatasetProcess_SpectrumSignal, POINTER) returns tag of POINTER of NNDatasetProcess_SpectrumSignal.
			%  TAG = DPROC.GETPROPTAG(NNDatasetProcess_SpectrumSignal, POINTER) returns tag of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPTAG(DPROC) and Element.GETPROPTAG('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nndatasetprocess_spectrumsignal_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'EXTRACT_DATA'  'EXTRACT_LABELS' };
				tag = nndatasetprocess_spectrumsignal_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = DPROC.GETPROPCATEGORY(POINTER) returns category of POINTER of DPROC.
			%  CATEGORY = Element.GETPROPCATEGORY(NNDatasetProcess_SpectrumSignal, POINTER) returns category of POINTER of NNDatasetProcess_SpectrumSignal.
			%  CATEGORY = DPROC.GETPROPCATEGORY(NNDatasetProcess_SpectrumSignal, POINTER) returns category of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPCATEGORY(DPROC) and Element.GETPROPCATEGORY('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_spectrumsignal_category_list = { 1  1  1  3  4  2  2  6  5  4  3  3  3  3  3  5  6  6 };
			prop_category = nndatasetprocess_spectrumsignal_category_list{prop};
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
			%  FORMAT = DPROC.GETPROPFORMAT(POINTER) returns format of POINTER of DPROC.
			%  FORMAT = Element.GETPROPFORMAT(NNDatasetProcess_SpectrumSignal, POINTER) returns format of POINTER of NNDatasetProcess_SpectrumSignal.
			%  FORMAT = DPROC.GETPROPFORMAT(NNDatasetProcess_SpectrumSignal, POINTER) returns format of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPFORMAT(DPROC) and Element.GETPROPFORMAT('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_spectrumsignal_format_list = { 2  2  2  8  2  2  2  2  8  2  11  11  5  5  11  13  16  3 };
			prop_format = nndatasetprocess_spectrumsignal_format_list{prop};
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
			%  DESCRIPTION = DPROC.GETPROPDESCRIPTION(POINTER) returns description of POINTER of DPROC.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNDatasetProcess_SpectrumSignal, POINTER) returns description of POINTER of NNDatasetProcess_SpectrumSignal.
			%  DESCRIPTION = DPROC.GETPROPDESCRIPTION(NNDatasetProcess_SpectrumSignal, POINTER) returns description of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPDESCRIPTION(DPROC) and Element.GETPROPDESCRIPTION('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_spectrumsignal_description_list = { 'ELCLASS (constant, string) is the class of processing MNIST data for a neural networks datasets.'  'NAME (constant, string) is the name of processing MNIST data for a neural networks datasets.'  'DESCRIPTION (constant, string) is the description of processing data for a neural networks datasets.'  'TEMPLATE (parameter, item) is the template of processing data for a neural networks datasets.'  'ID (data, string) is a few-letter code of processing data for a neural networks datasets.'  'LABEL (metadata, string) is an extended label of processing data for a neural networks datasets.'  'NOTES (metadata, string) are some specific notes of processing data for a neural networks datasets.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (result, item) is the neural network dataset containing the datapoint processed from the raw data.'  'RAW_DATA_DIR (data, string) contains the directory of the b2 file for spectrum data.'  'WAVELENGTH_START (parameter, scalar) is the starting wavelength.'  'WAVELENGTH_END (parameter, scalar) is the ending  wavelength.'  'TRANSFORMATION_RULE (parameter, option) is the transformation methods.'  'NORMALIZATION_RULE (parameter, option) is the normalization methods.'  'SCALE_FACTOR (parameter, scalar) is the normalization methods.'  'WAVELENGTH (result, cvector) is the wavelength.'  'EXTRACT_DATA (query, cell) extracts the images from the specified IDX files.'  'EXTRACT_LABELS (query, stringlist) extracts the labels from the specified IDX files.' };
			prop_description = nndatasetprocess_spectrumsignal_description_list{prop};
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
			%  SETTINGS = DPROC.GETPROPSETTINGS(POINTER) returns settings of POINTER of DPROC.
			%  SETTINGS = Element.GETPROPSETTINGS(NNDatasetProcess_SpectrumSignal, POINTER) returns settings of POINTER of NNDatasetProcess_SpectrumSignal.
			%  SETTINGS = DPROC.GETPROPSETTINGS(NNDatasetProcess_SpectrumSignal, POINTER) returns settings of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPSETTINGS(DPROC) and Element.GETPROPSETTINGS('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 10 % NNDatasetProcess_SpectrumSignal.RAW_DATA_DIR
					prop_settings = Format.getFormatSettings(2);
				case 11 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_START
					prop_settings = Format.getFormatSettings(11);
				case 12 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_END
					prop_settings = Format.getFormatSettings(11);
				case 13 % NNDatasetProcess_SpectrumSignal.TRANSFORMATION_RULE
					prop_settings = {'First derivative'};
				case 14 % NNDatasetProcess_SpectrumSignal.NORMALIZATION_RULE
					prop_settings = {'Scale'};
				case 15 % NNDatasetProcess_SpectrumSignal.SCALE_FACTOR
					prop_settings = Format.getFormatSettings(11);
				case 16 % NNDatasetProcess_SpectrumSignal.WAVELENGTH
					prop_settings = Format.getFormatSettings(13);
				case 17 % NNDatasetProcess_SpectrumSignal.EXTRACT_DATA
					prop_settings = Format.getFormatSettings(16);
				case 18 % NNDatasetProcess_SpectrumSignal.EXTRACT_LABELS
					prop_settings = Format.getFormatSettings(3);
				case 4 % NNDatasetProcess_SpectrumSignal.TEMPLATE
					prop_settings = 'NNDatasetProcess_SpectrumSignal';
				case 9 % NNDatasetProcess_SpectrumSignal.D
					prop_settings = 'NNDataset';
				otherwise
					prop_settings = getPropSettings@NNDatasetProcess(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNDatasetProcess_SpectrumSignal.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetProcess_SpectrumSignal.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DPROC.GETPROPDEFAULT(POINTER) returns the default value of POINTER of DPROC.
			%  DEFAULT = Element.GETPROPDEFAULT(NNDatasetProcess_SpectrumSignal, POINTER) returns the default value of POINTER of NNDatasetProcess_SpectrumSignal.
			%  DEFAULT = DPROC.GETPROPDEFAULT(NNDatasetProcess_SpectrumSignal, POINTER) returns the default value of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPDEFAULT(DPROC) and Element.GETPROPDEFAULT('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 10 % NNDatasetProcess_SpectrumSignal.RAW_DATA_DIR
					prop_default = Format.getFormatDefault(2, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 11 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_START
					prop_default = 600;
				case 12 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_END
					prop_default = 1750;
				case 13 % NNDatasetProcess_SpectrumSignal.TRANSFORMATION_RULE
					prop_default = 'First derivative';
				case 14 % NNDatasetProcess_SpectrumSignal.NORMALIZATION_RULE
					prop_default = 'Scale';
				case 15 % NNDatasetProcess_SpectrumSignal.SCALE_FACTOR
					prop_default = 1;
				case 16 % NNDatasetProcess_SpectrumSignal.WAVELENGTH
					prop_default = Format.getFormatDefault(13, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 17 % NNDatasetProcess_SpectrumSignal.EXTRACT_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 18 % NNDatasetProcess_SpectrumSignal.EXTRACT_LABELS
					prop_default = Format.getFormatDefault(3, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 1 % NNDatasetProcess_SpectrumSignal.ELCLASS
					prop_default = 'NNDatasetProcess_SpectrumSignal';
				case 2 % NNDatasetProcess_SpectrumSignal.NAME
					prop_default = 'Processing Raman Spectrum Data for a Neural Network Dataset';
				case 3 % NNDatasetProcess_SpectrumSignal.DESCRIPTION
					prop_default = 'The MNIST processing for a neural network dataset (NNDatasetProcess_MNIST) processes the raw MNIST data into a neural network dataset. The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.';
				case 4 % NNDatasetProcess_SpectrumSignal.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 5 % NNDatasetProcess_SpectrumSignal.ID
					prop_default = 'NNDatasetProcess_SpectrumSignal ID';
				case 6 % NNDatasetProcess_SpectrumSignal.LABEL
					prop_default = 'NNDatasetProcess_SpectrumSignal label';
				case 7 % NNDatasetProcess_SpectrumSignal.NOTES
					prop_default = 'NNDatasetProcess_SpectrumSignal notes';
				case 9 % NNDatasetProcess_SpectrumSignal.D
					prop_default = Format.getFormatDefault(8, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				otherwise
					prop_default = getPropDefault@NNDatasetProcess(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNDatasetProcess_SpectrumSignal.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetProcess_SpectrumSignal.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DPROC.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of DPROC.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNDatasetProcess_SpectrumSignal, POINTER) returns the conditioned default value of POINTER of NNDatasetProcess_SpectrumSignal.
			%  DEFAULT = DPROC.GETPROPDEFAULTCONDITIONED(NNDatasetProcess_SpectrumSignal, POINTER) returns the conditioned default value of POINTER of NNDatasetProcess_SpectrumSignal.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(DPROC) and Element.GETPROPDEFAULTCONDITIONED('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			prop_default = NNDatasetProcess_SpectrumSignal.conditioning(prop, NNDatasetProcess_SpectrumSignal.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = DPROC.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = DPROC.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of DPROC.
			%  CHECK = Element.CHECKPROP(NNDatasetProcess_SpectrumSignal, PROP, VALUE) checks VALUE format for PROP of NNDatasetProcess_SpectrumSignal.
			%  CHECK = DPROC.CHECKPROP(NNDatasetProcess_SpectrumSignal, PROP, VALUE) checks VALUE format for PROP of NNDatasetProcess_SpectrumSignal.
			% 
			% DPROC.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DPROC.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of DPROC.
			%   Error id: BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput
			%  Element.CHECKPROP(NNDatasetProcess_SpectrumSignal, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_SpectrumSignal.
			%   Error id: BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput
			%  DPROC.CHECKPROP(NNDatasetProcess_SpectrumSignal, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_SpectrumSignal.
			%   Error id: BRAPH2:NNDatasetProcess_SpectrumSignal:WrongInput]
			% 
			% Note that the Element.CHECKPROP(DPROC) and Element.CHECKPROP('NNDatasetProcess_SpectrumSignal')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNDatasetProcess_SpectrumSignal.getPropProp(pointer);
			
			switch prop
				case 10 % NNDatasetProcess_SpectrumSignal.RAW_DATA_DIR
					check = Format.checkFormat(2, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 11 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_START
					check = Format.checkFormat(11, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 12 % NNDatasetProcess_SpectrumSignal.WAVELENGTH_END
					check = Format.checkFormat(11, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 13 % NNDatasetProcess_SpectrumSignal.TRANSFORMATION_RULE
					check = Format.checkFormat(5, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 14 % NNDatasetProcess_SpectrumSignal.NORMALIZATION_RULE
					check = Format.checkFormat(5, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 15 % NNDatasetProcess_SpectrumSignal.SCALE_FACTOR
					check = Format.checkFormat(11, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 16 % NNDatasetProcess_SpectrumSignal.WAVELENGTH
					check = Format.checkFormat(13, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 17 % NNDatasetProcess_SpectrumSignal.EXTRACT_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 18 % NNDatasetProcess_SpectrumSignal.EXTRACT_LABELS
					check = Format.checkFormat(3, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 4 % NNDatasetProcess_SpectrumSignal.TEMPLATE
					check = Format.checkFormat(8, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				case 9 % NNDatasetProcess_SpectrumSignal.D
					check = Format.checkFormat(8, value, NNDatasetProcess_SpectrumSignal.getPropSettings(prop));
				otherwise
					if prop <= 9
						check = checkProp@NNDatasetProcess(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_SpectrumSignal:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNDatasetProcess_SpectrumSignal.getPropTag(prop) ' (' NNDatasetProcess_SpectrumSignal.getFormatTag(NNDatasetProcess_SpectrumSignal.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
	methods (Access=protected) % postset
		function postset(dproc, prop)
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
				case 15 % NNDatasetProcess_SpectrumSignal.SCALE_FACTOR
					if ~isequal(dproc.get('NORMALIZATION_RULE'), 'Scale')
					    dproc.set('SCALE_FACTOR', 1)
					end
					
				otherwise
					if prop <= 9
						postset@NNDatasetProcess(dproc, prop);
					end
			end
		end
	end
	methods (Access=protected) % calculate value
		function value = calculateValue(dproc, prop, varargin)
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
				case 16 % NNDatasetProcess_SpectrumSignal.WAVELENGTH
					rng_settings_ = rng(); rng(dproc.getPropSeed(16), 'twister')
					
					dir_name = dproc.get('RAW_DATA_DIR');
					if isempty(dir_name)
					    value = [];
					    return
					end
					file_list = dir([dir_name filesep '*b2']);
					if isequal(length(file_list), 0)
					    value = [];
					    return
					end
					for i = 1:length(file_list)
					    file_names(i) = string(file_list(i).name);
					end
					file_names = file_names';
					
					b2_el = load([dir_name filesep char(file_names(1))], '-mat');
					
					% simplify this part
					if strcmp(b2_el.el.get('ELCLASS'), 'Pipeline')
					    sp_dict = b2_el.el.get('PS_DICT').get('IT', 7).get('PC_DICT').get('IT', 1).get('EL').get('RE_OUT').get('SP_DICT');
					elseif strcmp(b2_el.el.get('ELCLASS'), 'RamanExperiment')
					    sp_dict = b2_el.el.get('SP_DICT');
					elseif strcmp(b2_el.el.get('ELCLASS'), 'BaselineRemover')
					    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
					elseif strcmp(b2_el.el.get('ELCLASS'), 'CosmicRayNoiseRemover')
					    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
					end
					value = sp_dict.get('IT', 1).get('WAVELENGTH');
					
					rng(rng_settings_)
					
				case 17 % NNDatasetProcess_SpectrumSignal.EXTRACT_DATA
					dir_name = dproc.get('RAW_DATA_DIR');
					if isempty(dir_name)
					    value = {};
					    return
					end
					file_list = dir([dir_name filesep '*b2']);
					for i = 1:length(file_list)
					    file_names(i) = string(file_list(i).name);
					end
					file_names = file_names';
					
					
					X = [];
					for file_idx = 1:length(file_names)
					    file_name = file_names(file_idx);
					    b2_el = load([dir_name filesep char(file_name)], '-mat');
					
					    num_spectrum_file = b2_el.el.get('RE_OUT').get('SP_DICT').get('LENGTH');
					    ids = cellfun(@(spectrum) spectrum.get('ID'), b2_el.el.get('RE_OUT').get('SP_DICT').get('IT_LIST') ,'UniformOutput', false);
					
					    num_previous_col = size(X, 2);
					    
					    for i = 1:num_spectrum_file
					        intensities = b2_el.el.get('RE_OUT').get('SP_DICT').get('IT', i).get('INTENSITIES');
					        num_col = size(intensities, 2);
					        if file_idx == 1
					            counter1 = (i-1)*num_col + 1;
					            counter2 = num_col*i;
					        else
					            counter1 = (i-1)*num_col + 1 + num_previous_col;
					            counter2 = num_col*i + num_previous_col;
					        end
					
					        % get X
					        X(:, counter1:counter2)= intensities;
					    end
					end
					
					for i = 1:size(X, 2)
					    value{i} =  X(:, i);
					end
					
				case 18 % NNDatasetProcess_SpectrumSignal.EXTRACT_LABELS
					dir_name = dproc.get('RAW_DATA_DIR');
					if isempty(dir_name)
					    value = {};
					    return
					end
					file_list = dir([dir_name filesep '*b2']);
					for i = 1:length(file_list)
					    file_names(i) = string(file_list(i).name);
					end
					file_names = file_names';
					
					Y = "";
					for file_idx = 1:length(file_names)
					    file_name = file_names(file_idx);
					    b2_el = load([dir_name filesep char(file_name)], '-mat');
					
					    num_spectrum_file = b2_el.el.get('RE_OUT').get('SP_DICT').get('LENGTH');
					    ids = cellfun(@(spectrum) spectrum.get('ID'), b2_el.el.get('RE_OUT').get('SP_DICT').get('IT_LIST') ,'UniformOutput', false);
					
					    num_previous_col = size(Y, 2);
					    
					    for i = 1:num_spectrum_file
					        intensities = b2_el.el.get('RE_OUT').get('SP_DICT').get('IT', i).get('INTENSITIES');
					        num_col = size(intensities, 2);
					        if file_idx == 1
					            counter1 = (i-1)*num_col + 1;
					            counter2 = num_col*i;
					        else
					            counter1 = (i-1)*num_col + 1 + num_previous_col;
					            counter2 = num_col*i + num_previous_col;
					        end
					
					        id = ids{i};
					        Y(1, counter1:counter2) = extractBetween(file_name, '_', '_'); % type
					        if Y(1, counter1:counter2) == "AB2"
					            Y(1, counter1:counter2) = "AB";
					        end 
					
					        if contains(id, 'WL')
					            Y(2, counter1:counter2) = "WL"; % shade
					        elseif contains(id, 'HL')
					            Y(2, counter1:counter2) = "HL"; % shade
					        elseif contains(id, 'LL')
					            Y(2, counter1:counter2) = "LL"; % shade
					        elseif contains(id, 'SH')
					            Y(2, counter1:counter2) = "SH"; % shade
					        elseif contains(id, 'ps')
					            Y(2, counter1:counter2) = "ps"; % shade
					        end
					        if contains(id, 'loc1')
					            Y(3, counter1:counter2) = "loc1"; % location
					        elseif contains(id, 'loc2')
					            Y(3, counter1:counter2) = "loc2"; % location
					        elseif contains(id, 'ps')
					            Y(3, counter1:counter2) = "ps"; % location
					        end
					        Y(4, counter1:counter2) = id; % id of the plant
					    end
					end
					
					for i = 1:size(Y, 2)
					    value{i} = char(Y(:, i));
					end
					
				case 9 % NNDatasetProcess_SpectrumSignal.D
					rng_settings_ = rng(); rng(dproc.getPropSeed(9), 'twister')
					
					raw_spectrum_list = dproc.get('EXTRACT_DATA');
					raw_label_list = dproc.get('EXTRACT_LABELS');
					
					it_list = cellfun(@(data, label) NNDataPoint_SpectrumSignal( ...
					    'SP_DATA', data, ...
					    'WL', dproc.getCallback('WAVELENGTH'), ...
					    'WL_START', dproc.getCallback('WAVELENGTH_START'), ...
					    'WL_END', dproc.getCallback('WAVELENGTH_END'), ...
					    'TARGET_CLASS', {label}), ...
					    raw_spectrum_list, raw_label_list,...
					    'UniformOutput', false);
					
					dp_list = IndexedDictionary(...
					        'IT_CLASS', 'NNDataPoint_SpectrumSignal', ...
					        'IT_LIST', it_list ...
					        );
					
					value = NNDataset( ...
					    'DP_CLASS', 'NNDataPoint_SpectrumSignal', ...
					    'DP_DICT', dp_list ...
					    );
					
					rng(rng_settings_)
					
				otherwise
					if prop <= 9
						value = calculateValue@NNDatasetProcess(dproc, prop, varargin{:});
					else
						value = calculateValue@Element(dproc, prop, varargin{:});
					end
			end
			
		end
	end
end
