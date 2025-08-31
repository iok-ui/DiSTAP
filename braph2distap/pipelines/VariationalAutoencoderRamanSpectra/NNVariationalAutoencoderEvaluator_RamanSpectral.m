classdef NNVariationalAutoencoderEvaluator_RamanSpectral < NNVariationalAutoencoderEvaluator
	%NNVariationalAutoencoderEvaluator_RamanSpectral evaluates the performance of a trained neural network model with a dataset.
	% It is a subclass of <a href="matlab:help NNVariationalAutoencoderEvaluator">NNVariationalAutoencoderEvaluator</a>.
	%
	% A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset.
	% Instances of this class should not be created. Use one of its subclasses instead.
	% Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.
	%
	% The list of NNVariationalAutoencoderEvaluator_RamanSpectral properties is:
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
	%  <strong>13</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (result, rvector) indentifies importance peaks.
	%  <strong>14</strong> <strong>ZERO_CROSSING_P2N</strong> 	ZERO_CROSSING_P2N (query, rvector) indentifies the index when crossing from positve to negative.
	%  <strong>15</strong> <strong>ZERO_CROSSING_N2P</strong> 	ZERO_CROSSING_N2P (query, rvector) indentifies the index when crossing from negative to positive.
	%  <strong>16</strong> <strong>DIRECTORY</strong> 	DIRECTORY (data, string) is the directory saving the exporting figure.
	%  <strong>17</strong> <strong>PLOT_R_SCRIPT</strong> 	PLOT_R_SCRIPT (metadata, logical) indentifies the index when crossing from negative to positive.
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (constructor):
	%  NNVariationalAutoencoderEvaluator_RamanSpectral - constructor
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods:
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
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (display):
	%  tostring - string with information about the neural network evaluator
	%  disp - displays information about the neural network evaluator
	%  tree - displays the tree of the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two neural network evaluator are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (save/load, Static):
	%  save - saves BRAPH2 neural network evaluator as b2 file
	%  load - loads a BRAPH2 neural network evaluator from a b2 file
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the neural network evaluator
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (inspection, Static):
	%  getClass - returns the class of the neural network evaluator
	%  getSubclasses - returns all subclasses of NNVariationalAutoencoderEvaluator_RamanSpectral
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
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNVariationalAutoencoderEvaluator_RamanSpectral methods (format, Static):
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
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNVariationalAutoencoderEvaluator_RamanSpectral; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNVariationalAutoencoderEvaluator_RamanSpectral constants</a>.
	%
	%
	% See also NNDataPoint, NNDataset, NNBase.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		PEAK_IDENTIFICATION = 13; %CET: Computational Efficiency Trick
		PEAK_IDENTIFICATION_TAG = 'PEAK_IDENTIFICATION';
		PEAK_IDENTIFICATION_CATEGORY = 5;
		PEAK_IDENTIFICATION_FORMAT = 12;
		
		ZERO_CROSSING_P2N = 14; %CET: Computational Efficiency Trick
		ZERO_CROSSING_P2N_TAG = 'ZERO_CROSSING_P2N';
		ZERO_CROSSING_P2N_CATEGORY = 6;
		ZERO_CROSSING_P2N_FORMAT = 12;
		
		ZERO_CROSSING_N2P = 15; %CET: Computational Efficiency Trick
		ZERO_CROSSING_N2P_TAG = 'ZERO_CROSSING_N2P';
		ZERO_CROSSING_N2P_CATEGORY = 6;
		ZERO_CROSSING_N2P_FORMAT = 12;
		
		DIRECTORY = 16; %CET: Computational Efficiency Trick
		DIRECTORY_TAG = 'DIRECTORY';
		DIRECTORY_CATEGORY = 4;
		DIRECTORY_FORMAT = 2;
		
		PLOT_R_SCRIPT = 17; %CET: Computational Efficiency Trick
		PLOT_R_SCRIPT_TAG = 'PLOT_R_SCRIPT';
		PLOT_R_SCRIPT_CATEGORY = 2;
		PLOT_R_SCRIPT_FORMAT = 4;
	end
	methods % constructor
		function nne = NNVariationalAutoencoderEvaluator_RamanSpectral(varargin)
			%NNVariationalAutoencoderEvaluator_RamanSpectral() creates a neural network evaluator.
			%
			% NNVariationalAutoencoderEvaluator_RamanSpectral(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNVariationalAutoencoderEvaluator_RamanSpectral(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNVariationalAutoencoderEvaluator_RamanSpectral properties is:
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
			%  <strong>13</strong> <strong>PEAK_IDENTIFICATION</strong> 	PEAK_IDENTIFICATION (result, rvector) indentifies importance peaks.
			%  <strong>14</strong> <strong>ZERO_CROSSING_P2N</strong> 	ZERO_CROSSING_P2N (query, rvector) indentifies the index when crossing from positve to negative.
			%  <strong>15</strong> <strong>ZERO_CROSSING_N2P</strong> 	ZERO_CROSSING_N2P (query, rvector) indentifies the index when crossing from negative to positive.
			%  <strong>16</strong> <strong>DIRECTORY</strong> 	DIRECTORY (data, string) is the directory saving the exporting figure.
			%  <strong>17</strong> <strong>PLOT_R_SCRIPT</strong> 	PLOT_R_SCRIPT (metadata, logical) indentifies the index when crossing from negative to positive.
			%
			% See also Category, Format.
			
			nne = nne@NNVariationalAutoencoderEvaluator(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the neural network evaluator.
			%
			% BUILD = NNVariationalAutoencoderEvaluator_RamanSpectral.GETBUILD() returns the build of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNE.GETBUILD() returns the build of the neural network evaluator NNE.
			%  BUILD = Element.GETBUILD(NNE) returns the build of 'NNE'.
			%  BUILD = Element.GETBUILD('NNVariationalAutoencoderEvaluator_RamanSpectral') returns the build of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Note that the Element.GETBUILD(NNE) and Element.GETBUILD('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nne_class = getClass()
			%GETCLASS returns the class of the neural network evaluator.
			%
			% CLASS = NNVariationalAutoencoderEvaluator_RamanSpectral.GETCLASS() returns the class 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNE.GETCLASS() returns the class of the neural network evaluator NNE.
			%  CLASS = Element.GETCLASS(NNE) returns the class of 'NNE'.
			%  CLASS = Element.GETCLASS('NNVariationalAutoencoderEvaluator_RamanSpectral') returns 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Note that the Element.GETCLASS(NNE) and Element.GETCLASS('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			
			nne_class = 'NNVariationalAutoencoderEvaluator_RamanSpectral';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the neural network evaluator.
			%
			% LIST = NNVariationalAutoencoderEvaluator_RamanSpectral.GETSUBCLASSES() returns all subclasses of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNE.GETSUBCLASSES() returns all subclasses of the neural network evaluator NNE.
			%  LIST = Element.GETSUBCLASSES(NNE) returns all subclasses of 'NNE'.
			%  LIST = Element.GETSUBCLASSES('NNVariationalAutoencoderEvaluator_RamanSpectral') returns all subclasses of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Note that the Element.GETSUBCLASSES(NNE) and Element.GETSUBCLASSES('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNVariationalAutoencoderEvaluator_RamanSpectral' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of neural network evaluator.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPS() returns the property list of neural network evaluator
			%  as a row vector.
			%
			% PROPS = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNE.GETPROPS([CATEGORY]) returns the property list of the neural network evaluator NNE.
			%  PROPS = Element.GETPROPS(NNE[, CATEGORY]) returns the property list of 'NNE'.
			%  PROPS = Element.GETPROPS('NNVariationalAutoencoderEvaluator_RamanSpectral'[, CATEGORY]) returns the property list of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Note that the Element.GETPROPS(NNE) and Element.GETPROPS('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7 17];
				case 3 % Category.PARAMETER
					prop_list = 4;
				case 4 % Category.DATA
					prop_list = [5 9 10 16];
				case 5 % Category.RESULT
					prop_list = 13;
				case 6 % Category.QUERY
					prop_list = [8 11 12 14 15];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPNUMBER() returns the property number of neural network evaluator.
			%
			% N = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPNUMBER(CATEGORY) returns the property number of neural network evaluator
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNE.GETPROPNUMBER([CATEGORY]) returns the property number of the neural network evaluator NNE.
			%  N = Element.GETPROPNUMBER(NNE) returns the property number of 'NNE'.
			%  N = Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RamanSpectral') returns the property number of 'NNVariationalAutoencoderEvaluator_RamanSpectral'.
			%
			% Note that the Element.GETPROPNUMBER(NNE) and Element.GETPROPNUMBER('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 17;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 3;
				case 3 % Category.PARAMETER
					prop_number = 1;
				case 4 % Category.DATA
					prop_number = 4;
				case 5 % Category.RESULT
					prop_number = 1;
				case 6 % Category.QUERY
					prop_number = 5;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in neural network evaluator/error.
			%
			% CHECK = NNVariationalAutoencoderEvaluator_RamanSpectral.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSPROP(PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNE, PROP) checks whether PROP exists for NNE.
			%  CHECK = Element.EXISTSPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP) checks whether PROP exists for NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%  Element.EXISTSPROP(NNE, PROP) throws error if PROP does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%  Element.EXISTSPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP) throws error if PROP does NOT exist for NNVariationalAutoencoderEvaluator_RamanSpectral.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNE) and Element.EXISTSPROP('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 17 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNVariationalAutoencoderEvaluator_RamanSpectral.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in neural network evaluator/error.
			%
			% CHECK = NNVariationalAutoencoderEvaluator_RamanSpectral.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNE.EXISTSTAG(TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNE, TAG) checks whether TAG exists for NNE.
			%  CHECK = Element.EXISTSTAG(NNVariationalAutoencoderEvaluator_RamanSpectral, TAG) checks whether TAG exists for NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNE.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%  Element.EXISTSTAG(NNE, TAG) throws error if TAG does NOT exist for NNE.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%  Element.EXISTSTAG(NNVariationalAutoencoderEvaluator_RamanSpectral, TAG) throws error if TAG does NOT exist for NNVariationalAutoencoderEvaluator_RamanSpectral.
			%   Error id: [BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNE) and Element.EXISTSTAG('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'PEAK_IDENTIFICATION'  'ZERO_CROSSING_P2N'  'ZERO_CROSSING_N2P'  'DIRECTORY'  'PLOT_R_SCRIPT' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNVariationalAutoencoderEvaluator_RamanSpectral.'] ...
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
			%  PROPERTY = Element.GETPROPPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns property number of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  PROPERTY = NNE.GETPROPPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns property number of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPPROP(NNE) and Element.GETPROPPROP('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'PEAK_IDENTIFICATION'  'ZERO_CROSSING_P2N'  'ZERO_CROSSING_N2P'  'DIRECTORY'  'PLOT_R_SCRIPT' })); % tag = pointer %CET: Computational Efficiency Trick
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
			%  TAG = Element.GETPROPTAG(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns tag of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  TAG = NNE.GETPROPTAG(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns tag of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPTAG(NNE) and Element.GETPROPTAG('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnvariationalautoencoderevaluator_ramanspectral_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'NN'  'D'  'PLOT_LATENT_REPRESENTATIONS'  'PREDICT_ENCODER'  'PEAK_IDENTIFICATION'  'ZERO_CROSSING_P2N'  'ZERO_CROSSING_N2P'  'DIRECTORY'  'PLOT_R_SCRIPT' };
				tag = nnvariationalautoencoderevaluator_ramanspectral_tag_list{pointer}; % prop = pointer
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
			%  CATEGORY = Element.GETPROPCATEGORY(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns category of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  CATEGORY = NNE.GETPROPCATEGORY(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns category of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPCATEGORY(NNE) and Element.GETPROPCATEGORY('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_ramanspectral_category_list = { 1  1  1  3  4  2  2  6  4  4  6  6  5  6  6  4  2 };
			prop_category = nnvariationalautoencoderevaluator_ramanspectral_category_list{prop};
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
			%  FORMAT = Element.GETPROPFORMAT(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns format of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  FORMAT = NNE.GETPROPFORMAT(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns format of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPFORMAT(NNE) and Element.GETPROPFORMAT('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_ramanspectral_format_list = { 2  2  2  8  2  2  2  2  8  8  1  16  12  12  12  2  4 };
			prop_format = nnvariationalautoencoderevaluator_ramanspectral_format_list{prop};
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
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns description of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  DESCRIPTION = NNE.GETPROPDESCRIPTION(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns description of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNE) and Element.GETPROPDESCRIPTION('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnvariationalautoencoderevaluator_ramanspectral_description_list = { 'ELCLASS (constant, string) is the class of the evaluator of the neural network analysis.'  'NAME (constant, string) is the name of the evaluator for the neural network analysis.'  'DESCRIPTION (constant, string) is the description of the evaluator for the neural network analysis.'  'TEMPLATE (parameter, item) is the template of the evaluator for the neural network analysis.'  'ID (data, string) is a few-letter code for the evaluator for the neural network analysis.'  'LABEL (metadata, string) is an extended label of the evaluator for the neural network analysis.'  'NOTES (metadata, string) are some specific notes about the evaluator for the neural network analysis.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'NN (data, item) contains a trained neural network model.'  'D (data, item) is the dataset to evaluate the neural network model.'  'PLOT_LATENT_REPRESENTATIONS (query, empty) is to plot latetn representations.'  'PREDICT_ENCODER (query, cell) returns the predictions of an encoder.'  'PEAK_IDENTIFICATION (result, rvector) indentifies importance peaks.'  'ZERO_CROSSING_P2N (query, rvector) indentifies the index when crossing from positve to negative.'  'ZERO_CROSSING_N2P (query, rvector) indentifies the index when crossing from negative to positive.'  'DIRECTORY (data, string) is the directory saving the exporting figure.'  'PLOT_R_SCRIPT (metadata, logical) indentifies the index when crossing from negative to positive.' };
			prop_description = nnvariationalautoencoderevaluator_ramanspectral_description_list{prop};
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
			%  SETTINGS = Element.GETPROPSETTINGS(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns settings of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  SETTINGS = NNE.GETPROPSETTINGS(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns settings of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPSETTINGS(NNE) and Element.GETPROPSETTINGS('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 13 % NNVariationalAutoencoderEvaluator_RamanSpectral.PEAK_IDENTIFICATION
					prop_settings = Format.getFormatSettings(12);
				case 14 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_P2N
					prop_settings = Format.getFormatSettings(12);
				case 15 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_N2P
					prop_settings = Format.getFormatSettings(12);
				case 16 % NNVariationalAutoencoderEvaluator_RamanSpectral.DIRECTORY
					prop_settings = Format.getFormatSettings(2);
				case 17 % NNVariationalAutoencoderEvaluator_RamanSpectral.PLOT_R_SCRIPT
					prop_settings = Format.getFormatSettings(4);
				case 4 % NNVariationalAutoencoderEvaluator_RamanSpectral.TEMPLATE
					prop_settings = 'NNVariationalAutoencoder_RamanSpectralEvaluator';
				otherwise
					prop_settings = getPropSettings@NNVariationalAutoencoderEvaluator(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULT(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns the default value of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  DEFAULT = NNE.GETPROPDEFAULT(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns the default value of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPDEFAULT(NNE) and Element.GETPROPDEFAULT('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 13 % NNVariationalAutoencoderEvaluator_RamanSpectral.PEAK_IDENTIFICATION
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 14 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_P2N
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 15 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_N2P
					prop_default = Format.getFormatDefault(12, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 16 % NNVariationalAutoencoderEvaluator_RamanSpectral.DIRECTORY
					prop_default = fileparts(which('test_braph2'));
				case 17 % NNVariationalAutoencoderEvaluator_RamanSpectral.PLOT_R_SCRIPT
					prop_default = Format.getFormatDefault(4, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 1 % NNVariationalAutoencoderEvaluator_RamanSpectral.ELCLASS
					prop_default = 'NNVariationalAutoencoder_RamanSpectralEvaluator';
				case 2 % NNVariationalAutoencoderEvaluator_RamanSpectral.NAME
					prop_default = 'Neural Network Evaluator';
				case 3 % NNVariationalAutoencoderEvaluator_RamanSpectral.DESCRIPTION
					prop_default = 'A neural network evaluator (NNEvaluator) evaluates the performance of a neural network model with a specific dataset. Instances of this class should not be created. Use one of its subclasses instead. Its subclasses shall be specifically designed to cater to different evaluation cases such as a classification task, a regression task, or a data generation task.';
				case 4 % NNVariationalAutoencoderEvaluator_RamanSpectral.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 5 % NNVariationalAutoencoderEvaluator_RamanSpectral.ID
					prop_default = 'NNEvaluator ID';
				case 6 % NNVariationalAutoencoderEvaluator_RamanSpectral.LABEL
					prop_default = 'NNEvaluator label';
				case 7 % NNVariationalAutoencoderEvaluator_RamanSpectral.NOTES
					prop_default = 'NNEvaluator notes';
				otherwise
					prop_default = getPropDefault@NNVariationalAutoencoderEvaluator(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNVariationalAutoencoderEvaluator_RamanSpectral.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNE.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  DEFAULT = NNE.GETPROPDEFAULTCONDITIONED(NNVariationalAutoencoderEvaluator_RamanSpectral, POINTER) returns the conditioned default value of POINTER of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNE) and Element.GETPROPDEFAULTCONDITIONED('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			prop_default = NNVariationalAutoencoderEvaluator_RamanSpectral.conditioning(prop, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropDefault(prop));
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
			%  CHECK = Element.CHECKPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%  CHECK = NNE.CHECKPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP, VALUE) checks VALUE format for PROP of NNVariationalAutoencoderEvaluator_RamanSpectral.
			% 
			% NNE.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNE.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNE.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput
			%  Element.CHECKPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput
			%  NNE.CHECKPROP(NNVariationalAutoencoderEvaluator_RamanSpectral, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNVariationalAutoencoderEvaluator_RamanSpectral.
			%   Error id: BRAPH2:NNVariationalAutoencoderEvaluator_RamanSpectral:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNE) and Element.CHECKPROP('NNVariationalAutoencoderEvaluator_RamanSpectral')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNVariationalAutoencoderEvaluator_RamanSpectral.getPropProp(pointer);
			
			switch prop
				case 13 % NNVariationalAutoencoderEvaluator_RamanSpectral.PEAK_IDENTIFICATION
					check = Format.checkFormat(12, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 14 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_P2N
					check = Format.checkFormat(12, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 15 % NNVariationalAutoencoderEvaluator_RamanSpectral.ZERO_CROSSING_N2P
					check = Format.checkFormat(12, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 16 % NNVariationalAutoencoderEvaluator_RamanSpectral.DIRECTORY
					check = Format.checkFormat(2, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 17 % NNVariationalAutoencoderEvaluator_RamanSpectral.PLOT_R_SCRIPT
					check = Format.checkFormat(4, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				case 4 % NNVariationalAutoencoderEvaluator_RamanSpectral.TEMPLATE
					check = Format.checkFormat(8, value, NNVariationalAutoencoderEvaluator_RamanSpectral.getPropSettings(prop));
				otherwise
					if prop <= 12
						check = checkProp@NNVariationalAutoencoderEvaluator(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput'], ...
					['BRAPH2' ':NNVariationalAutoencoderEvaluator_RamanSpectral:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNVariationalAutoencoderEvaluator_RamanSpectral.getPropTag(prop) ' (' NNVariationalAutoencoderEvaluator_RamanSpectral.getFormatTag(NNVariationalAutoencoderEvaluator_RamanSpectral.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
end
