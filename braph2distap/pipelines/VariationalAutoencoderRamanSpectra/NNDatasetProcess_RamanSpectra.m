classdef NNDatasetProcess_RamanSpectra < NNDatasetProcess
	%NNDatasetProcess_RamanSpectra processes raw MNIST data into a neural network datasets.
	% It is a subclass of <a href="matlab:help NNDatasetProcess">NNDatasetProcess</a>.
	%
	% The Raman sepctrum processing for a neural network dataset (NNDatasetProcess_Spectrum) processes the raw raman spectrum data into a neural network dataset. 
	%  The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.
	%
	% NNDatasetProcess_RamanSpectra methods (constructor):
	%  NNDatasetProcess_RamanSpectra - constructor
	%
	% NNDatasetProcess_RamanSpectra methods:
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
	% NNDatasetProcess_RamanSpectra methods (display):
	%  tostring - string with information about the processing for a neural network data
	%  disp - displays information about the processing for a neural network data
	%  tree - displays the tree of the processing for a neural network data
	%
	% NNDatasetProcess_RamanSpectra methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two processing for a neural network data are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the processing for a neural network data
	%
	% NNDatasetProcess_RamanSpectra methods (save/load, Static):
	%  save - saves BRAPH2 processing for a neural network data as b2 file
	%  load - loads a BRAPH2 processing for a neural network data from a b2 file
	%
	% NNDatasetProcess_RamanSpectra method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the processing for a neural network data
	%
	% NNDatasetProcess_RamanSpectra method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the processing for a neural network data
	%
	% NNDatasetProcess_RamanSpectra methods (inspection, Static):
	%  getClass - returns the class of the processing for a neural network data
	%  getSubclasses - returns all subclasses of NNDatasetProcess_RamanSpectra
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
	% NNDatasetProcess_RamanSpectra methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNDatasetProcess_RamanSpectra methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNDatasetProcess_RamanSpectra methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNDatasetProcess_RamanSpectra methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNDatasetProcess_RamanSpectra; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNDatasetProcess_RamanSpectra constants</a>.
	%
	%
	% See also NNDatasetProcess, NNDataPoint.
	%
	% BUILD BRAPH2 BRAPH2.BUILD class_name 1
	
	properties (Constant) % properties
		STRESS_SEQ = NNDatasetProcess.getPropNumber() + 1;
		STRESS_SEQ_TAG = 'STRESS_SEQ';
		STRESS_SEQ_CATEGORY = Category.PARAMETER;
		STRESS_SEQ_FORMAT = Format.STRINGLIST;
		
		KIND_SEQ = NNDatasetProcess.getPropNumber() + 2;
		KIND_SEQ_TAG = 'KIND_SEQ';
		KIND_SEQ_CATEGORY = Category.PARAMETER;
		KIND_SEQ_FORMAT = Format.STRINGLIST;
		
		LOCATION_SEQ = NNDatasetProcess.getPropNumber() + 3;
		LOCATION_SEQ_TAG = 'LOCATION_SEQ';
		LOCATION_SEQ_CATEGORY = Category.PARAMETER;
		LOCATION_SEQ_FORMAT = Format.STRINGLIST;
		
		TARGETS_TO_REMOVE = NNDatasetProcess.getPropNumber() + 4;
		TARGETS_TO_REMOVE_TAG = 'TARGETS_TO_REMOVE';
		TARGETS_TO_REMOVE_CATEGORY = Category.DATA;
		TARGETS_TO_REMOVE_FORMAT = Format.STRINGLIST;
		
		RAW_DATA_DIR = NNDatasetProcess.getPropNumber() + 5;
		RAW_DATA_DIR_TAG = 'RAW_DATA_DIR';
		RAW_DATA_DIR_CATEGORY = Category.DATA;
		RAW_DATA_DIR_FORMAT = Format.STRING;
		
		WAVELENGTH_START = NNDatasetProcess.getPropNumber() + 6;
		WAVELENGTH_START_TAG = 'WAVELENGTH_START';
		WAVELENGTH_START_CATEGORY = Category.PARAMETER;
		WAVELENGTH_START_FORMAT = Format.SCALAR;
		
		WAVELENGTH_END = NNDatasetProcess.getPropNumber() + 7;
		WAVELENGTH_END_TAG = 'WAVELENGTH_END';
		WAVELENGTH_END_CATEGORY = Category.PARAMETER;
		WAVELENGTH_END_FORMAT = Format.SCALAR;
		
		TRANSFORMATION_RULE = NNDatasetProcess.getPropNumber() + 8;
		TRANSFORMATION_RULE_TAG = 'TRANSFORMATION_RULE';
		TRANSFORMATION_RULE_CATEGORY = Category.PARAMETER;
		TRANSFORMATION_RULE_FORMAT = Format.OPTION;
		
		NORMALIZATION_RULE = NNDatasetProcess.getPropNumber() + 9;
		NORMALIZATION_RULE_TAG = 'NORMALIZATION_RULE';
		NORMALIZATION_RULE_CATEGORY = Category.PARAMETER;
		NORMALIZATION_RULE_FORMAT = Format.OPTION;
		
		SCALE_FACTOR = NNDatasetProcess.getPropNumber() + 10;
		SCALE_FACTOR_TAG = 'SCALE_FACTOR';
		SCALE_FACTOR_CATEGORY = Category.PARAMETER;
		SCALE_FACTOR_FORMAT = Format.SCALAR;
		
		WAVELENGTH = NNDatasetProcess.getPropNumber() + 11;
		WAVELENGTH_TAG = 'WAVELENGTH';
		WAVELENGTH_CATEGORY = Category.RESULT;
		WAVELENGTH_FORMAT = Format.CVECTOR;
		
		TRANSFORM_DATA = NNDatasetProcess.getPropNumber() + 12;
		TRANSFORM_DATA_TAG = 'TRANSFORM_DATA';
		TRANSFORM_DATA_CATEGORY = Category.QUERY;
		TRANSFORM_DATA_FORMAT = Format.CELL;
		
		INV_TRANSFORM_DATA = NNDatasetProcess.getPropNumber() + 13;
		INV_TRANSFORM_DATA_TAG = 'INV_TRANSFORM_DATA';
		INV_TRANSFORM_DATA_CATEGORY = Category.QUERY;
		INV_TRANSFORM_DATA_FORMAT = Format.CELL;
		
		NORMALIZE_DATA = NNDatasetProcess.getPropNumber() + 14;
		NORMALIZE_DATA_TAG = 'NORMALIZE_DATA';
		NORMALIZE_DATA_CATEGORY = Category.QUERY;
		NORMALIZE_DATA_FORMAT = Format.CELL;
		
		INV_NORMALIZE_DATA = NNDatasetProcess.getPropNumber() + 15;
		INV_NORMALIZE_DATA_TAG = 'INV_NORMALIZE_DATA';
		INV_NORMALIZE_DATA_CATEGORY = Category.QUERY;
		INV_NORMALIZE_DATA_FORMAT = Format.CELL;
		
		RAW_DATA = NNDatasetProcess.getPropNumber() + 16;
		RAW_DATA_TAG = 'RAW_DATA';
		RAW_DATA_CATEGORY = Category.RESULT;
		RAW_DATA_FORMAT = Format.CELL;
		
		PROCESS_DATA = NNDatasetProcess.getPropNumber() + 17;
		PROCESS_DATA_TAG = 'PROCESS_DATA';
		PROCESS_DATA_CATEGORY = Category.QUERY;
		PROCESS_DATA_FORMAT = Format.CELL;
		
		REV_PROCESS_DATA = NNDatasetProcess.getPropNumber() + 18;
		REV_PROCESS_DATA_TAG = 'REV_PROCESS_DATA';
		REV_PROCESS_DATA_CATEGORY = Category.QUERY;
		REV_PROCESS_DATA_FORMAT = Format.CELL;
		
		EXTRACT_DATA = NNDatasetProcess.getPropNumber() + 19;
		EXTRACT_DATA_TAG = 'EXTRACT_DATA';
		EXTRACT_DATA_CATEGORY = Category.QUERY;
		EXTRACT_DATA_FORMAT = Format.CELL;
		
		EXTRACT_LABELS = NNDatasetProcess.getPropNumber() + 20;
		EXTRACT_LABELS_TAG = 'EXTRACT_LABELS';
		EXTRACT_LABELS_CATEGORY = Category.QUERY;
		EXTRACT_LABELS_FORMAT = Format.STRINGLIST;
	end
	methods % constructor
		function dproc = NNDatasetProcess_RamanSpectra(varargin)
			%NNDatasetProcess_RamanSpectra() creates a processing for a neural network data.
			%
			% NNDatasetProcess_RamanSpectra(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNDatasetProcess_RamanSpectra(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			%
			% See also Category, Format.
			
			dproc = dproc@NNDatasetProcess(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the processing for a neural network data.
			%
			% BUILD = NNDatasetProcess_RamanSpectra.GETBUILD() returns the build of 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  BUILD = DPROC.GETBUILD() returns the build of the processing for a neural network data DPROC.
			%  BUILD = Element.GETBUILD(DPROC) returns the build of 'DPROC'.
			%  BUILD = Element.GETBUILD('NNDatasetProcess_RamanSpectra') returns the build of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETBUILD(DPROC) and Element.GETBUILD('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			
			build = 1;
		end
		function dproc_class = getClass()
			%GETCLASS returns the class of the processing for a neural network data.
			%
			% CLASS = NNDatasetProcess_RamanSpectra.GETCLASS() returns the class 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  CLASS = DPROC.GETCLASS() returns the class of the processing for a neural network data DPROC.
			%  CLASS = Element.GETCLASS(DPROC) returns the class of 'DPROC'.
			%  CLASS = Element.GETCLASS('NNDatasetProcess_RamanSpectra') returns 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETCLASS(DPROC) and Element.GETCLASS('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			
			dproc_class = 'NNDatasetProcess_RamanSpectra';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the processing for a neural network data.
			%
			% LIST = NNDatasetProcess_RamanSpectra.GETSUBCLASSES() returns all subclasses of 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  LIST = DPROC.GETSUBCLASSES() returns all subclasses of the processing for a neural network data DPROC.
			%  LIST = Element.GETSUBCLASSES(DPROC) returns all subclasses of 'DPROC'.
			%  LIST = Element.GETSUBCLASSES('NNDatasetProcess_RamanSpectra') returns all subclasses of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETSUBCLASSES(DPROC) and Element.GETSUBCLASSES('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = subclasses('NNDatasetProcess_RamanSpectra', [], [], true);
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of processing for a neural network data.
			%
			% PROPS = NNDatasetProcess_RamanSpectra.GETPROPS() returns the property list of processing for a neural network data
			%  as a row vector.
			%
			% PROPS = NNDatasetProcess_RamanSpectra.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = DPROC.GETPROPS([CATEGORY]) returns the property list of the processing for a neural network data DPROC.
			%  PROPS = Element.GETPROPS(DPROC[, CATEGORY]) returns the property list of 'DPROC'.
			%  PROPS = Element.GETPROPS('NNDatasetProcess_RamanSpectra'[, CATEGORY]) returns the property list of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETPROPS(DPROC) and Element.GETPROPS('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			if nargin == 0
				prop_list = [ ...
					NNDatasetProcess.getProps() ...
						NNDatasetProcess_RamanSpectra.STRESS_SEQ ...
						NNDatasetProcess_RamanSpectra.KIND_SEQ ...
						NNDatasetProcess_RamanSpectra.LOCATION_SEQ ...
						NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE ...
						NNDatasetProcess_RamanSpectra.RAW_DATA_DIR ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH_START ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH_END ...
						NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE ...
						NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE ...
						NNDatasetProcess_RamanSpectra.SCALE_FACTOR ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH ...
						NNDatasetProcess_RamanSpectra.TRANSFORM_DATA ...
						NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA ...
						NNDatasetProcess_RamanSpectra.NORMALIZE_DATA ...
						NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA ...
						NNDatasetProcess_RamanSpectra.RAW_DATA ...
						NNDatasetProcess_RamanSpectra.PROCESS_DATA ...
						NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA ...
						NNDatasetProcess_RamanSpectra.EXTRACT_DATA ...
						NNDatasetProcess_RamanSpectra.EXTRACT_LABELS ...
						];
				return
			end
			
			switch category
				case Category.CONSTANT
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.CONSTANT) ...
						];
				case Category.METADATA
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.METADATA) ...
						];
				case Category.PARAMETER
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.PARAMETER) ...
						NNDatasetProcess_RamanSpectra.STRESS_SEQ ...
						NNDatasetProcess_RamanSpectra.KIND_SEQ ...
						NNDatasetProcess_RamanSpectra.LOCATION_SEQ ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH_START ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH_END ...
						NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE ...
						NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE ...
						NNDatasetProcess_RamanSpectra.SCALE_FACTOR ...
						];
				case Category.DATA
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.DATA) ...
						NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE ...
						NNDatasetProcess_RamanSpectra.RAW_DATA_DIR ...
						];
				case Category.RESULT
					prop_list = [
						NNDatasetProcess.getProps(Category.RESULT) ...
						NNDatasetProcess_RamanSpectra.WAVELENGTH ...
						NNDatasetProcess_RamanSpectra.RAW_DATA ...
						];
				case Category.QUERY
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.QUERY) ...
						NNDatasetProcess_RamanSpectra.TRANSFORM_DATA ...
						NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA ...
						NNDatasetProcess_RamanSpectra.NORMALIZE_DATA ...
						NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA ...
						NNDatasetProcess_RamanSpectra.PROCESS_DATA ...
						NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA ...
						NNDatasetProcess_RamanSpectra.EXTRACT_DATA ...
						NNDatasetProcess_RamanSpectra.EXTRACT_LABELS ...
						];
				case Category.EVANESCENT
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.EVANESCENT) ...
						];
				case Category.FIGURE
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.FIGURE) ...
						];
				case Category.GUI
					prop_list = [ ...
						NNDatasetProcess.getProps(Category.GUI) ...
						];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of processing for a neural network data.
			%
			% N = NNDatasetProcess_RamanSpectra.GETPROPNUMBER() returns the property number of processing for a neural network data.
			%
			% N = NNDatasetProcess_RamanSpectra.GETPROPNUMBER(CATEGORY) returns the property number of processing for a neural network data
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = DPROC.GETPROPNUMBER([CATEGORY]) returns the property number of the processing for a neural network data DPROC.
			%  N = Element.GETPROPNUMBER(DPROC) returns the property number of 'DPROC'.
			%  N = Element.GETPROPNUMBER('NNDatasetProcess_RamanSpectra') returns the property number of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETPROPNUMBER(DPROC) and Element.GETPROPNUMBER('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			prop_number = numel(NNDatasetProcess_RamanSpectra.getProps(varargin{:}));
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in processing for a neural network data/error.
			%
			% CHECK = NNDatasetProcess_RamanSpectra.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DPROC.EXISTSPROP(PROP) checks whether PROP exists for DPROC.
			%  CHECK = Element.EXISTSPROP(DPROC, PROP) checks whether PROP exists for DPROC.
			%  CHECK = Element.EXISTSPROP(NNDatasetProcess_RamanSpectra, PROP) checks whether PROP exists for NNDatasetProcess_RamanSpectra.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DPROC.EXISTSPROP(PROP) throws error if PROP does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%  Element.EXISTSPROP(DPROC, PROP) throws error if PROP does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%  Element.EXISTSPROP(NNDatasetProcess_RamanSpectra, PROP) throws error if PROP does NOT exist for NNDatasetProcess_RamanSpectra.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%
			% Note that the Element.EXISTSPROP(DPROC) and Element.EXISTSPROP('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(prop == NNDatasetProcess_RamanSpectra.getProps());
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNDatasetProcess_RamanSpectra.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in processing for a neural network data/error.
			%
			% CHECK = NNDatasetProcess_RamanSpectra.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = DPROC.EXISTSTAG(TAG) checks whether TAG exists for DPROC.
			%  CHECK = Element.EXISTSTAG(DPROC, TAG) checks whether TAG exists for DPROC.
			%  CHECK = Element.EXISTSTAG(NNDatasetProcess_RamanSpectra, TAG) checks whether TAG exists for NNDatasetProcess_RamanSpectra.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%
			% Alternative forms to call this method are:
			%  DPROC.EXISTSTAG(TAG) throws error if TAG does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%  Element.EXISTSTAG(DPROC, TAG) throws error if TAG does NOT exist for DPROC.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%  Element.EXISTSTAG(NNDatasetProcess_RamanSpectra, TAG) throws error if TAG does NOT exist for NNDatasetProcess_RamanSpectra.
			%   Error id: [BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			%
			% Note that the Element.EXISTSTAG(DPROC) and Element.EXISTSTAG('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			nndatasetprocess_ramanspectra_tag_list = cellfun(@(x) NNDatasetProcess_RamanSpectra.getPropTag(x), num2cell(NNDatasetProcess_RamanSpectra.getProps()), 'UniformOutput', false);
			check = any(strcmp(tag, nndatasetprocess_ramanspectra_tag_list));
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT '\n' ...
					'The value ' tag ' is not a valid tag for NNDatasetProcess_RamanSpectra.'] ...
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
			%  PROPERTY = Element.GETPROPPROP(NNDatasetProcess_RamanSpectra, POINTER) returns property number of POINTER of NNDatasetProcess_RamanSpectra.
			%  PROPERTY = DPROC.GETPROPPROP(NNDatasetProcess_RamanSpectra, POINTER) returns property number of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPPROP(DPROC) and Element.GETPROPPROP('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				nndatasetprocess_ramanspectra_tag_list = cellfun(@(x) NNDatasetProcess_RamanSpectra.getPropTag(x), num2cell(NNDatasetProcess_RamanSpectra.getProps()), 'UniformOutput', false);
				prop = find(strcmp(pointer, nndatasetprocess_ramanspectra_tag_list)); % tag = pointer
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
			%  TAG = Element.GETPROPTAG(NNDatasetProcess_RamanSpectra, POINTER) returns tag of POINTER of NNDatasetProcess_RamanSpectra.
			%  TAG = DPROC.GETPROPTAG(NNDatasetProcess_RamanSpectra, POINTER) returns tag of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPTAG(DPROC) and Element.GETPROPTAG('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				prop = pointer;
				
				switch prop
					case NNDatasetProcess_RamanSpectra.STRESS_SEQ
						tag = NNDatasetProcess_RamanSpectra.STRESS_SEQ_TAG;
					case NNDatasetProcess_RamanSpectra.KIND_SEQ
						tag = NNDatasetProcess_RamanSpectra.KIND_SEQ_TAG;
					case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
						tag = NNDatasetProcess_RamanSpectra.LOCATION_SEQ_TAG;
					case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
						tag = NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE_TAG;
					case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
						tag = NNDatasetProcess_RamanSpectra.RAW_DATA_DIR_TAG;
					case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
						tag = NNDatasetProcess_RamanSpectra.WAVELENGTH_START_TAG;
					case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
						tag = NNDatasetProcess_RamanSpectra.WAVELENGTH_END_TAG;
					case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
						tag = NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE_TAG;
					case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
						tag = NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE_TAG;
					case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
						tag = NNDatasetProcess_RamanSpectra.SCALE_FACTOR_TAG;
					case NNDatasetProcess_RamanSpectra.WAVELENGTH
						tag = NNDatasetProcess_RamanSpectra.WAVELENGTH_TAG;
					case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
						tag = NNDatasetProcess_RamanSpectra.TRANSFORM_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
						tag = NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
						tag = NNDatasetProcess_RamanSpectra.NORMALIZE_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
						tag = NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.RAW_DATA
						tag = NNDatasetProcess_RamanSpectra.RAW_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.PROCESS_DATA
						tag = NNDatasetProcess_RamanSpectra.PROCESS_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
						tag = NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
						tag = NNDatasetProcess_RamanSpectra.EXTRACT_DATA_TAG;
					case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
						tag = NNDatasetProcess_RamanSpectra.EXTRACT_LABELS_TAG;
					otherwise
						tag = getPropTag@NNDatasetProcess(prop);
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
			%  CATEGORY = DPROC.GETPROPCATEGORY(POINTER) returns category of POINTER of DPROC.
			%  CATEGORY = Element.GETPROPCATEGORY(NNDatasetProcess_RamanSpectra, POINTER) returns category of POINTER of NNDatasetProcess_RamanSpectra.
			%  CATEGORY = DPROC.GETPROPCATEGORY(NNDatasetProcess_RamanSpectra, POINTER) returns category of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPCATEGORY(DPROC) and Element.GETPROPCATEGORY('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_category = NNDatasetProcess_RamanSpectra.STRESS_SEQ_CATEGORY;
				case NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_category = NNDatasetProcess_RamanSpectra.KIND_SEQ_CATEGORY;
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_category = NNDatasetProcess_RamanSpectra.LOCATION_SEQ_CATEGORY;
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_category = NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE_CATEGORY;
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_category = NNDatasetProcess_RamanSpectra.RAW_DATA_DIR_CATEGORY;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_category = NNDatasetProcess_RamanSpectra.WAVELENGTH_START_CATEGORY;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_category = NNDatasetProcess_RamanSpectra.WAVELENGTH_END_CATEGORY;
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_category = NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE_CATEGORY;
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_category = NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE_CATEGORY;
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_category = NNDatasetProcess_RamanSpectra.SCALE_FACTOR_CATEGORY;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_category = NNDatasetProcess_RamanSpectra.WAVELENGTH_CATEGORY;
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_category = NNDatasetProcess_RamanSpectra.TRANSFORM_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_category = NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_category = NNDatasetProcess_RamanSpectra.NORMALIZE_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_category = NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_category = NNDatasetProcess_RamanSpectra.RAW_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_category = NNDatasetProcess_RamanSpectra.PROCESS_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_category = NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_category = NNDatasetProcess_RamanSpectra.EXTRACT_DATA_CATEGORY;
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_category = NNDatasetProcess_RamanSpectra.EXTRACT_LABELS_CATEGORY;
				otherwise
					prop_category = getPropCategory@NNDatasetProcess(prop);
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
			%  FORMAT = DPROC.GETPROPFORMAT(POINTER) returns format of POINTER of DPROC.
			%  FORMAT = Element.GETPROPFORMAT(NNDatasetProcess_RamanSpectra, POINTER) returns format of POINTER of NNDatasetProcess_RamanSpectra.
			%  FORMAT = DPROC.GETPROPFORMAT(NNDatasetProcess_RamanSpectra, POINTER) returns format of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPFORMAT(DPROC) and Element.GETPROPFORMAT('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_format = NNDatasetProcess_RamanSpectra.STRESS_SEQ_FORMAT;
				case NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_format = NNDatasetProcess_RamanSpectra.KIND_SEQ_FORMAT;
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_format = NNDatasetProcess_RamanSpectra.LOCATION_SEQ_FORMAT;
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_format = NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE_FORMAT;
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_format = NNDatasetProcess_RamanSpectra.RAW_DATA_DIR_FORMAT;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_format = NNDatasetProcess_RamanSpectra.WAVELENGTH_START_FORMAT;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_format = NNDatasetProcess_RamanSpectra.WAVELENGTH_END_FORMAT;
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_format = NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE_FORMAT;
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_format = NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE_FORMAT;
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_format = NNDatasetProcess_RamanSpectra.SCALE_FACTOR_FORMAT;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_format = NNDatasetProcess_RamanSpectra.WAVELENGTH_FORMAT;
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_format = NNDatasetProcess_RamanSpectra.TRANSFORM_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_format = NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_format = NNDatasetProcess_RamanSpectra.NORMALIZE_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_format = NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_format = NNDatasetProcess_RamanSpectra.RAW_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_format = NNDatasetProcess_RamanSpectra.PROCESS_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_format = NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_format = NNDatasetProcess_RamanSpectra.EXTRACT_DATA_FORMAT;
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_format = NNDatasetProcess_RamanSpectra.EXTRACT_LABELS_FORMAT;
				otherwise
					prop_format = getPropFormat@NNDatasetProcess(prop);
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
			%  DESCRIPTION = DPROC.GETPROPDESCRIPTION(POINTER) returns description of POINTER of DPROC.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNDatasetProcess_RamanSpectra, POINTER) returns description of POINTER of NNDatasetProcess_RamanSpectra.
			%  DESCRIPTION = DPROC.GETPROPDESCRIPTION(NNDatasetProcess_RamanSpectra, POINTER) returns description of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPDESCRIPTION(DPROC) and Element.GETPROPDESCRIPTION('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_description = 'STRESS_SEQ (parameter, stringlist) canonical order for output.';
				case NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_description = 'KIND_SEQ (parameter, stringlist) canonical order for output.';
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_description = 'LOCATION_SEQ (parameter, stringlist) canonical order for output.';
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_description = 'TARGETS_TO_REMOVE (data, stringlist) contains the directory of the b2 file for spectrum data.';
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_description = 'RAW_DATA_DIR (data, string) contains the directory of the b2 file for spectrum data.';
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_description = 'WAVELENGTH_START (parameter, scalar) is the starting wavelength.';
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_description = 'WAVELENGTH_END (parameter, scalar) is the ending  wavelength.';
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_description = 'TRANSFORMATION_RULE (parameter, option) is the transformation methods.';
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_description = 'NORMALIZATION_RULE (parameter, option) is the normalization methods.';
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_description = 'SCALE_FACTOR (parameter, scalar) is the normalization methods.';
				case NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_description = 'WAVELENGTH (result, cvector) is the wavelength.';
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_description = 'TRANSFORM_DATA (query, cell) normalizes the images from the specified IDX files.';
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_description = 'INV_TRANSFORM_DATA (query, cell) inverse-tranforms the images from the specified IDX files.';
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_description = 'NORMALIZE_DATA (query, cell) normalizes the images from the specified IDX files.';
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_description = 'INV_NORMALIZE_DATA (query, cell) inverse-normalizes the images from the specified IDX files.';
				case NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_description = 'RAW_DATA (result, cell) processes the data with normalization and transformation.';
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_description = 'PROCESS_DATA (query, cell) processes the data with normalization and transformation.';
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_description = 'REV_PROCESS_DATA (query, cell) reverse the process step the data with normalization and transformation.';
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_description = 'EXTRACT_DATA (query, cell) extracts the sepctral data with dimension of wavelength x datapoints.';
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_description = 'EXTRACT_LABELS (query, stringlist) extracts labels from all *.b2 files in RAW_DATA_DIR.';
				case NNDatasetProcess_RamanSpectra.ELCLASS
					prop_description = 'ELCLASS (constant, string) is the class of processing MNIST data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.NAME
					prop_description = 'NAME (constant, string) is the name of processing MNIST data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.DESCRIPTION
					prop_description = 'DESCRIPTION (constant, string) is the description of processing data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.TEMPLATE
					prop_description = 'TEMPLATE (parameter, item) is the template of processing data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.ID
					prop_description = 'ID (data, string) is a few-letter code of processing data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.LABEL
					prop_description = 'LABEL (metadata, string) is an extended label of processing data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.NOTES
					prop_description = 'NOTES (metadata, string) are some specific notes of processing data for a neural networks datasets.';
				case NNDatasetProcess_RamanSpectra.D
					prop_description = 'D (result, item) is the neural network dataset containing the datapoint processed from the raw data.';
				otherwise
					prop_description = getPropDescription@NNDatasetProcess(prop);
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
			%  SETTINGS = DPROC.GETPROPSETTINGS(POINTER) returns settings of POINTER of DPROC.
			%  SETTINGS = Element.GETPROPSETTINGS(NNDatasetProcess_RamanSpectra, POINTER) returns settings of POINTER of NNDatasetProcess_RamanSpectra.
			%  SETTINGS = DPROC.GETPROPSETTINGS(NNDatasetProcess_RamanSpectra, POINTER) returns settings of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPSETTINGS(DPROC) and Element.GETPROPSETTINGS('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_settings = Format.getFormatSettings(Format.STRING);
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_settings = {'First derivative'};
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_settings = {'Scale'};
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_settings = Format.getFormatSettings(Format.SCALAR);
				case NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_settings = Format.getFormatSettings(Format.CVECTOR);
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_settings = Format.getFormatSettings(Format.CELL);
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_settings = Format.getFormatSettings(Format.STRINGLIST);
				case NNDatasetProcess_RamanSpectra.TEMPLATE
					prop_settings = 'NNDatasetProcess_RamanSpectra';
				case NNDatasetProcess_RamanSpectra.D
					prop_settings = 'NNDataset';
				otherwise
					prop_settings = getPropSettings@NNDatasetProcess(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNDatasetProcess_RamanSpectra.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetProcess_RamanSpectra.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DPROC.GETPROPDEFAULT(POINTER) returns the default value of POINTER of DPROC.
			%  DEFAULT = Element.GETPROPDEFAULT(NNDatasetProcess_RamanSpectra, POINTER) returns the default value of POINTER of NNDatasetProcess_RamanSpectra.
			%  DEFAULT = DPROC.GETPROPDEFAULT(NNDatasetProcess_RamanSpectra, POINTER) returns the default value of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPDEFAULT(DPROC) and Element.GETPROPDEFAULT('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_default = {'WL', 'HL', 'LL', 'SH'};
				case NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_default = {'AB2', 'CS', 'KL'};
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_default = {'loc1', 'loc2'};
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_default = {'ps'};
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_default = Format.getFormatDefault(Format.STRING, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_default = 600;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_default = 1750;
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_default = 'First derivative';
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_default = 'Scale';
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_default = 1;
				case NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_default = Format.getFormatDefault(Format.CVECTOR, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_default = Format.getFormatDefault(Format.CELL, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_default = Format.getFormatDefault(Format.STRINGLIST, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.ELCLASS
					prop_default = 'NNDatasetProcess_RamanSpectra';
				case NNDatasetProcess_RamanSpectra.NAME
					prop_default = 'Processing Raman Spectrum Data for a Neural Network Dataset';
				case NNDatasetProcess_RamanSpectra.DESCRIPTION
					prop_default = 'The MNIST processing for a neural network dataset (NNDatasetProcess_MNIST) processes the raw MNIST data into a neural network dataset. The resulting neural network dataset contains all the datapoints from the raw data, along with its corresponding labels.';
				case NNDatasetProcess_RamanSpectra.TEMPLATE
					prop_default = Format.getFormatDefault(Format.ITEM, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.ID
					prop_default = 'NNDatasetProcess_RamanSpectra ID';
				case NNDatasetProcess_RamanSpectra.LABEL
					prop_default = 'NNDatasetProcess_RamanSpectra label';
				case NNDatasetProcess_RamanSpectra.NOTES
					prop_default = 'NNDatasetProcess_RamanSpectra notes';
				case NNDatasetProcess_RamanSpectra.D
					prop_default = Format.getFormatDefault(Format.ITEM, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				otherwise
					prop_default = getPropDefault@NNDatasetProcess(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNDatasetProcess_RamanSpectra.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNDatasetProcess_RamanSpectra.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = DPROC.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of DPROC.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNDatasetProcess_RamanSpectra, POINTER) returns the conditioned default value of POINTER of NNDatasetProcess_RamanSpectra.
			%  DEFAULT = DPROC.GETPROPDEFAULTCONDITIONED(NNDatasetProcess_RamanSpectra, POINTER) returns the conditioned default value of POINTER of NNDatasetProcess_RamanSpectra.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(DPROC) and Element.GETPROPDEFAULTCONDITIONED('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			prop_default = NNDatasetProcess_RamanSpectra.conditioning(prop, NNDatasetProcess_RamanSpectra.getPropDefault(prop));
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
			%  CHECK = Element.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) checks VALUE format for PROP of NNDatasetProcess_RamanSpectra.
			%  CHECK = DPROC.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) checks VALUE format for PROP of NNDatasetProcess_RamanSpectra.
			% 
			% DPROC.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: €BRAPH2.STR€:NNDatasetProcess_RamanSpectra:€BRAPH2.WRONG_INPUT€
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DPROC.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of DPROC.
			%   Error id: €BRAPH2.STR€:NNDatasetProcess_RamanSpectra:€BRAPH2.WRONG_INPUT€
			%  Element.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_RamanSpectra.
			%   Error id: €BRAPH2.STR€:NNDatasetProcess_RamanSpectra:€BRAPH2.WRONG_INPUT€
			%  DPROC.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_RamanSpectra.
			%   Error id: €BRAPH2.STR€:NNDatasetProcess_RamanSpectra:€BRAPH2.WRONG_INPUT€]
			% 
			% Note that the Element.CHECKPROP(DPROC) and Element.CHECKPROP('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case NNDatasetProcess_RamanSpectra.STRESS_SEQ % __NNDatasetProcess_RamanSpectra.STRESS_SEQ__
					check = Format.checkFormat(Format.STRINGLIST, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.KIND_SEQ % __NNDatasetProcess_RamanSpectra.KIND_SEQ__
					check = Format.checkFormat(Format.STRINGLIST, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.LOCATION_SEQ % __NNDatasetProcess_RamanSpectra.LOCATION_SEQ__
					check = Format.checkFormat(Format.STRINGLIST, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE % __NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE__
					check = Format.checkFormat(Format.STRINGLIST, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.RAW_DATA_DIR % __NNDatasetProcess_RamanSpectra.RAW_DATA_DIR__
					check = Format.checkFormat(Format.STRING, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_START % __NNDatasetProcess_RamanSpectra.WAVELENGTH_START__
					check = Format.checkFormat(Format.SCALAR, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.WAVELENGTH_END % __NNDatasetProcess_RamanSpectra.WAVELENGTH_END__
					check = Format.checkFormat(Format.SCALAR, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE % __NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE__
					check = Format.checkFormat(Format.OPTION, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE % __NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE__
					check = Format.checkFormat(Format.OPTION, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR % __NNDatasetProcess_RamanSpectra.SCALE_FACTOR__
					check = Format.checkFormat(Format.SCALAR, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.WAVELENGTH % __NNDatasetProcess_RamanSpectra.WAVELENGTH__
					check = Format.checkFormat(Format.CVECTOR, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA % __NNDatasetProcess_RamanSpectra.TRANSFORM_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA % __NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA % __NNDatasetProcess_RamanSpectra.NORMALIZE_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA % __NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.RAW_DATA % __NNDatasetProcess_RamanSpectra.RAW_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA % __NNDatasetProcess_RamanSpectra.PROCESS_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA % __NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA % __NNDatasetProcess_RamanSpectra.EXTRACT_DATA__
					check = Format.checkFormat(Format.CELL, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS % __NNDatasetProcess_RamanSpectra.EXTRACT_LABELS__
					check = Format.checkFormat(Format.STRINGLIST, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.TEMPLATE % __NNDatasetProcess_RamanSpectra.TEMPLATE__
					check = Format.checkFormat(Format.ITEM, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case NNDatasetProcess_RamanSpectra.D % __NNDatasetProcess_RamanSpectra.D__
					check = Format.checkFormat(Format.ITEM, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				otherwise
					if prop <= NNDatasetProcess.getPropNumber()
						check = checkProp@NNDatasetProcess(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT], ...
					[BRAPH2.STR ':NNDatasetProcess_RamanSpectra:' BRAPH2.WRONG_INPUT '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNDatasetProcess_RamanSpectra.getPropTag(prop) ' (' NNDatasetProcess_RamanSpectra.getFormatTag(NNDatasetProcess_RamanSpectra.getPropFormat(prop)) ').'] ...
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
				case NNDatasetProcess_RamanSpectra.SCALE_FACTOR % __NNDatasetProcess_RamanSpectra.SCALE_FACTOR__
					if ~isequal(dproc.get('NORMALIZATION_RULE'), 'Scale')
					    dproc.set('SCALE_FACTOR', 1)
					end
					
				otherwise
					if prop <= NNDatasetProcess.getPropNumber()
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
				case NNDatasetProcess_RamanSpectra.WAVELENGTH % __NNDatasetProcess_RamanSpectra.WAVELENGTH__
					rng_settings_ = rng(); rng(dproc.getPropSeed(NNDatasetProcess_RamanSpectra.WAVELENGTH), 'twister')
					
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
					
				case NNDatasetProcess_RamanSpectra.TRANSFORM_DATA % __NNDatasetProcess_RamanSpectra.TRANSFORM_DATA__
					if isempty(varargin)
					    value = {};
					    return
					end
					data = varargin{1};
					if isempty(data)
					    value = {};
					    return
					end
					transformation = dproc.get('TRANSFORMATION_RULE');
					switch transformation
					    case 'First derivative' % first derivative
					        data_tmp = data;
					        data_tmp = data_tmp(2:end, :) - data_tmp(1:end-1, :);
					        data(1:end-1, :) = data_tmp;
					        data(end, :) = 0;
					end
					value = data;
					
				case NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA % __NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA__
					if isempty(varargin)
					    value = {};
					    return
					end
					deriv = varargin{1};
					if isempty(deriv)
					    value = {};
					    return
					end
					transformation = dproc.get('TRANSFORMATION_RULE');
					switch transformation
					    case 'First derivative' % first derivative
					        base_row = varargin{2}; % should be raw_data(1, :)
					        detransformed_x = base_row + cumsum([zeros(1, size(deriv, 2)); deriv(1:end-1,:)], 1);;
					end
					value = detransformed_x;
					
				case NNDatasetProcess_RamanSpectra.NORMALIZE_DATA % __NNDatasetProcess_RamanSpectra.NORMALIZE_DATA__
					if isempty(varargin)
					    value = {};
					    return
					end
					data = varargin{1};
					if isempty(data)
					    value = {};
					    return
					end
					normalization = dproc.get('NORMALIZATION_RULE');
					switch normalization
					    case 'Scale' 
					        scale_factor = dproc.get('SCALE_FACTOR');
					        data = data ./ scale_factor;
					end
					value = data;
					
				case NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA % __NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA__
					if isempty(varargin)
					    value = {};
					    return
					end
					data = varargin{1};
					if isempty(data)
					    value = {};
					    return
					end
					normalization = dproc.get('NORMALIZATION_RULE');
					switch normalization
					    case 'Scale' 
					        scale_factor = dproc.get('SCALE_FACTOR');
					        data = data .* scale_factor;
					end
					value = data;
					
				case NNDatasetProcess_RamanSpectra.RAW_DATA % __NNDatasetProcess_RamanSpectra.RAW_DATA__
					rng_settings_ = rng(); rng(dproc.getPropSeed(NNDatasetProcess_RamanSpectra.RAW_DATA), 'twister')
					
					value = dproc.get('EXTRACT_DATA');
					
					rng(rng_settings_)
					
				case NNDatasetProcess_RamanSpectra.PROCESS_DATA % __NNDatasetProcess_RamanSpectra.PROCESS_DATA__
					X_raw = dproc.get('RAW_DATA');
					if isempty(X_raw)
					    value = {};
					    return
					end
					X = cat(2, X_raw{:});
					X_tr = dproc.get('TRANSFORM_DATA', X);
					X_tr_nor = dproc.get('NORMALIZE_DATA', X_tr);
					
					for i = 1:size(X_tr_nor, 2)
					    value{i} = X_tr_nor(:, i);
					end
					
				case NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA % __NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA__
					if isempty(varargin)
					    value = {};
					    return
					end
					data = varargin{1};
					selected_idx = varargin{2};
					inv_norm_data = dproc.get('INV_NORMALIZE_DATA', data);
					inv_tran_inv_norm_data = dproc.get('INV_TRANSFORM_DATA', inv_norm_data, selected_idx);
					
					for i = 1:size(inv_tran_inv_norm_data, 2)
					    value{i} = inv_tran_inv_norm_data(:, i);
					end
					
				case NNDatasetProcess_RamanSpectra.EXTRACT_DATA % __NNDatasetProcess_RamanSpectra.EXTRACT_DATA__
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
					    value{i} = X(:, i);
					end
					
				case NNDatasetProcess_RamanSpectra.EXTRACT_LABELS % __NNDatasetProcess_RamanSpectra.EXTRACT_LABELS__
					% VALUE = dproc.get('EXTRACT_LABELS')
					%
					% For each spectrum column in each *.b2 file, this query builds a 4×N
					% label matrix:
					%   row 1 – species  (from KIND_SEQ and filename)
					%   row 2 – stress   (from STRESS_SEQ and spectrum ID)
					%   row 3 – location (from LOCATION_SEQ and spectrum ID)
					%   row 4 – plant ID (full spectrum ID)
					% and returns VALUE as a stringlist where VALUE{i} is a char array with
					% these 4 label rows for the i-th spectrum.
					
					dir_name = dproc.get('RAW_DATA_DIR');
					if isempty(dir_name)
					    value = {};
					    return
					end
					
					% sequences are defined in the process (and may differ per dataset)
					stress_seq   = string(dproc.get('STRESS_SEQ'));    % e.g. ["WL","HL","LL","SH","ps"]
					kind_seq     = string(dproc.get('KIND_SEQ'));      % e.g. ["AB","CS","KL"]
					location_seq = string(dproc.get('LOCATION_SEQ'));  % e.g. ["loc1","loc2","ps"]
					
					file_list = dir(fullfile(dir_name, '*b2'));
					if isempty(file_list)
					    value = {};
					    return
					end
					
					% pre-allocate label matrix as we go
					Y = strings(4, 0);
					col_offset = 0;
					
					for f = 1:numel(file_list)
					    file_name = string(file_list(f).name);
					    b2_el = load(fullfile(dir_name, file_list(f).name), '-mat');
					
					    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
					    num_spectrum_file = sp_dict.get('LENGTH');
					    ids = cellfun(@(sp) sp.get('ID'), sp_dict.get('IT_LIST'), 'UniformOutput', false);
					
					    % --- species (kind) from filename, via KIND_SEQ pattern matching ---
					    species_label = "";
					    for kk = 1:numel(kind_seq)
					        if contains(file_name, kind_seq(kk))
					            species_label = kind_seq(kk);
					            break
					        end
					    end
					    if species_label == ""
					        warning('EXTRACT_LABELS:NoSpeciesMatch', ...
					            'No KIND_SEQ label matched filename "%s". Leaving species row empty.', file_name);
					    end
					
					    % --- loop over spectra in this file ---
					    for i = 1:num_spectrum_file
					        sp_el = sp_dict.get('IT', i);
					        intensities = sp_el.get('INTENSITIES'); % (#wavenumbers × #columns)
					        num_col = size(intensities, 2);
					        if num_col == 0
					            continue
					        end
					
					        id = string(ids{i});
					
					        % stress label from STRESS_SEQ
					        stress_label = "";
					        for ss = 1:numel(stress_seq)
					            if contains(id, stress_seq(ss))
					                stress_label = stress_seq(ss);
					                break
					            end
					        end
					
					        % location label from LOCATION_SEQ
					        location_label = "";
					        for ll = 1:numel(location_seq)
					            if contains(id, location_seq(ll))
					                location_label = location_seq(ll);
					                break
					            end
					        end
					
					        % expand Y to accommodate these columns
					        Y(:, col_offset + (1:num_col)) = [
					            repmat(species_label , 1, num_col)  % row 1: species
					            repmat(stress_label  , 1, num_col)  % row 2: stress
					            repmat(location_label, 1, num_col)  % row 3: location
					            repmat(id            , 1, num_col)  % row 4: plant ID
					        ];
					
					        col_offset = col_offset + num_col;
					    end
					end
					
					% convert 4×N string matrix into stringlist of char arrays
					value = cell(1, size(Y, 2));
					for i = 1:size(Y, 2)
					    value{i} = char(Y(:, i));
					end
					
				case NNDatasetProcess_RamanSpectra.D % __NNDatasetProcess_RamanSpectra.D__
					rng_settings_ = rng(); rng(dproc.getPropSeed(NNDatasetProcess_RamanSpectra.D), 'twister')
					
					processed_spectrum_list = dproc.get('PROCESS_DATA');
					raw_label_list = dproc.get('EXTRACT_LABELS');
					
					targets_to_remove = dproc.get('TARGETS_TO_REMOVE');
					idx_to_remove = [];
					if ~isempty(targets_to_remove)
					    for t = 1:length(targets_to_remove)
					        target_to_remove = targets_to_remove{t};
					        for i = 1:length(raw_label_list)
					            if any(contains(cellstr(raw_label_list{i}), target_to_remove))
					                idx_to_remove = [idx_to_remove i];
					            end
					        end
					    end
					end
					
					processed_spectrum_list(idx_to_remove) = [];
					raw_label_list(idx_to_remove) = [];
					
					it_list = cellfun(@(data, label) NNDataPoint_RamanSpectra( ...
					    'SP_DATA', data, ...
					    'WL', dproc.getCallback('WAVELENGTH'), ...
					    'WL_START', dproc.getCallback('WAVELENGTH_START'), ...
					    'WL_END', dproc.getCallback('WAVELENGTH_END'), ...
					    'TARGET_CLASS', {label}), ...
					    processed_spectrum_list, raw_label_list,...
					    'UniformOutput', false);
					
					dp_list = IndexedDictionary(...
					        'IT_CLASS', 'NNDataPoint_RamanSpectra', ...
					        'IT_LIST', it_list ...
					        );
					
					value = NNDataset( ...
					    'DP_CLASS', 'NNDataPoint_RamanSpectra', ...
					    'DP_DICT', dp_list ...
					    );
					
					rng(rng_settings_)
					
				otherwise
					if prop <= NNDatasetProcess.getPropNumber()
						value = calculateValue@NNDatasetProcess(dproc, prop, varargin{:});
					else
						value = calculateValue@Element(dproc, prop, varargin{:});
					end
			end
			
		end
	end
end
