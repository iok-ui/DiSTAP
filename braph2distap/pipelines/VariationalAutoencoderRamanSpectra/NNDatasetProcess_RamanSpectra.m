classdef NNDatasetProcess_RamanSpectra < NNDatasetProcess
	%NNDatasetProcess_RamanSpectra processes Raman spectra into a neural-network dataset.
	% It is a subclass of <a href="matlab:help NNDatasetProcess">NNDatasetProcess</a>.
	%
	% The Raman-spectra dataset process (NNDatasetProcess_RamanSpectra) converts raw Raman spectra stored in *.b2 files into an NNDataset of NNDataPoint_RamanSpectra, 
	%  applying optional spectral transformation and normalisation and attaching label metadata.
	%
	% The list of NNDatasetProcess_RamanSpectra properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the Raman-spectra dataset process.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the Raman-spectra dataset process.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the Raman-spectra dataset process.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the Raman-spectra dataset process.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the Raman-spectra dataset process.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the Raman-spectra dataset process.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are specific notes of the Raman-spectra dataset process.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (result, item) is the neural-network dataset containing NNDataPoint_RamanSpectra built from RAW_DATA and EXTRACT_LABELS.
	%  <strong>10</strong> <strong>STRESS_SEQ</strong> 	STRESS_SEQ (parameter, stringlist) is the canonical stress-label ordering used by EXTRACT_LABELS.
	%  <strong>11</strong> <strong>KIND_SEQ</strong> 	KIND_SEQ (parameter, stringlist) is the canonical species/cultivar code ordering used by EXTRACT_LABELS.
	%  <strong>12</strong> <strong>LOCATION_SEQ</strong> 	LOCATION_SEQ (parameter, stringlist) is the canonical location label ordering used by EXTRACT_LABELS.
	%  <strong>13</strong> <strong>TARGETS_TO_REMOVE</strong> 	TARGETS_TO_REMOVE (data, stringlist) is a list of label tokens to exclude; any data point whose label contains a listed token is removed.
	%  <strong>14</strong> <strong>RAW_DATA_DIR</strong> 	RAW_DATA_DIR (data, string) is the directory containing Raman *.b2 files to be processed.
	%  <strong>15</strong> <strong>WAVELENGTH_START</strong> 	WAVELENGTH_START (parameter, scalar) is the starting wavelength (cm^-1).
	%  <strong>16</strong> <strong>WAVELENGTH_END</strong> 	WAVELENGTH_END (parameter, scalar) is the ending wavelength (cm^-1).
	%  <strong>17</strong> <strong>TRANSFORMATION_RULE</strong> 	TRANSFORMATION_RULE (parameter, option) is the spectral transformation applied before normalisation.
	%  <strong>18</strong> <strong>NORMALIZATION_RULE</strong> 	NORMALIZATION_RULE (parameter, option) is the spectral normalisation applied after transformation.
	%  <strong>19</strong> <strong>SCALE_FACTOR</strong> 	SCALE_FACTOR (parameter, scalar) is the scaling factor used when NORMALIZATION_RULE is Scale.
	%  <strong>20</strong> <strong>WAVELENGTH</strong> 	WAVELENGTH (result, cvector) returns the wavelength vector parsed from the first *.b2 file in RAW_DATA_DIR.
	%  <strong>21</strong> <strong>TRANSFORM_DATA</strong> 	TRANSFORM_DATA (query, cell) applies TRANSFORMATION_RULE to a wavelength×datapoints matrix and returns the transformed data.
	%  <strong>22</strong> <strong>INV_TRANSFORM_DATA</strong> 	INV_TRANSFORM_DATA (query, cell) applies the inverse of TRANSFORMATION_RULE to recover spectra from a derivative representation.
	%  <strong>23</strong> <strong>NORMALIZE_DATA</strong> 	NORMALIZE_DATA (query, cell) applies NORMALIZATION_RULE to a wavelength×datapoints matrix and returns the normalised data.
	%  <strong>24</strong> <strong>INV_NORMALIZE_DATA</strong> 	INV_NORMALIZE_DATA (query, cell) applies the inverse of NORMALIZATION_RULE to restore original scale.
	%  <strong>25</strong> <strong>RAW_DATA</strong> 	RAW_DATA (result, cell) returns the raw spectral data as a cell array (one column per datapoint) extracted by EXTRACT_DATA.
	%  <strong>26</strong> <strong>PROCESS_DATA</strong> 	PROCESS_DATA (query, cell) returns spectra processed by TRANSFORM_DATA followed by NORMALIZE_DATA, packaged as a cell array of column vectors.
	%  <strong>27</strong> <strong>REV_PROCESS_DATA</strong> 	REV_PROCESS_DATA (query, cell) returns spectra reconstructed by INV_NORMALIZE_DATA and INV_TRANSFORM_DATA, packaged as a cell array of column vectors.
	%  <strong>28</strong> <strong>EXTRACT_DATA</strong> 	EXTRACT_DATA (query, cell) extracts spectral intensities from all *.b2 files in RAW_DATA_DIR and returns a cell array of wavelength×1 vectors (one per spectrum).
	%  <strong>29</strong> <strong>EXTRACT_LABELS</strong> 	EXTRACT_LABELS (query, stringlist) extracts a 4-row label matrix per spectrum (species, stress, location, plant ID) using KIND_SEQ, STRESS_SEQ and LOCATION_SEQ, returned as a stringlist of char arrays.
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
	%  tostring - string with information about the Raman-spectra dataset process
	%  disp - displays information about the Raman-spectra dataset process
	%  tree - displays the tree of the Raman-spectra dataset process
	%
	% NNDatasetProcess_RamanSpectra methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two Raman-spectra dataset process are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the Raman-spectra dataset process
	%
	% NNDatasetProcess_RamanSpectra methods (save/load, Static):
	%  save - saves BRAPH2 Raman-spectra dataset process as b2 file
	%  load - loads a BRAPH2 Raman-spectra dataset process from a b2 file
	%
	% NNDatasetProcess_RamanSpectra method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the Raman-spectra dataset process
	%
	% NNDatasetProcess_RamanSpectra method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the Raman-spectra dataset process
	%
	% NNDatasetProcess_RamanSpectra methods (inspection, Static):
	%  getClass - returns the class of the Raman-spectra dataset process
	%  getSubclasses - returns all subclasses of NNDatasetProcess_RamanSpectra
	%  getProps - returns the property list of the Raman-spectra dataset process
	%  getPropNumber - returns the property number of the Raman-spectra dataset process
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
	% See also NNDatasetProcess, NNDataPoint, NNDataPoint_RamanSpectra, NNDataset.
	%
	% BUILD BRAPH2 7 class_name 1
	
	properties (Constant) % properties
		STRESS_SEQ = 10; %CET: Computational Efficiency Trick
		STRESS_SEQ_TAG = 'STRESS_SEQ';
		STRESS_SEQ_CATEGORY = 3;
		STRESS_SEQ_FORMAT = 3;
		
		KIND_SEQ = 11; %CET: Computational Efficiency Trick
		KIND_SEQ_TAG = 'KIND_SEQ';
		KIND_SEQ_CATEGORY = 3;
		KIND_SEQ_FORMAT = 3;
		
		LOCATION_SEQ = 12; %CET: Computational Efficiency Trick
		LOCATION_SEQ_TAG = 'LOCATION_SEQ';
		LOCATION_SEQ_CATEGORY = 3;
		LOCATION_SEQ_FORMAT = 3;
		
		TARGETS_TO_REMOVE = 13; %CET: Computational Efficiency Trick
		TARGETS_TO_REMOVE_TAG = 'TARGETS_TO_REMOVE';
		TARGETS_TO_REMOVE_CATEGORY = 4;
		TARGETS_TO_REMOVE_FORMAT = 3;
		
		RAW_DATA_DIR = 14; %CET: Computational Efficiency Trick
		RAW_DATA_DIR_TAG = 'RAW_DATA_DIR';
		RAW_DATA_DIR_CATEGORY = 4;
		RAW_DATA_DIR_FORMAT = 2;
		
		WAVELENGTH_START = 15; %CET: Computational Efficiency Trick
		WAVELENGTH_START_TAG = 'WAVELENGTH_START';
		WAVELENGTH_START_CATEGORY = 3;
		WAVELENGTH_START_FORMAT = 11;
		
		WAVELENGTH_END = 16; %CET: Computational Efficiency Trick
		WAVELENGTH_END_TAG = 'WAVELENGTH_END';
		WAVELENGTH_END_CATEGORY = 3;
		WAVELENGTH_END_FORMAT = 11;
		
		TRANSFORMATION_RULE = 17; %CET: Computational Efficiency Trick
		TRANSFORMATION_RULE_TAG = 'TRANSFORMATION_RULE';
		TRANSFORMATION_RULE_CATEGORY = 3;
		TRANSFORMATION_RULE_FORMAT = 5;
		
		NORMALIZATION_RULE = 18; %CET: Computational Efficiency Trick
		NORMALIZATION_RULE_TAG = 'NORMALIZATION_RULE';
		NORMALIZATION_RULE_CATEGORY = 3;
		NORMALIZATION_RULE_FORMAT = 5;
		
		SCALE_FACTOR = 19; %CET: Computational Efficiency Trick
		SCALE_FACTOR_TAG = 'SCALE_FACTOR';
		SCALE_FACTOR_CATEGORY = 3;
		SCALE_FACTOR_FORMAT = 11;
		
		WAVELENGTH = 20; %CET: Computational Efficiency Trick
		WAVELENGTH_TAG = 'WAVELENGTH';
		WAVELENGTH_CATEGORY = 5;
		WAVELENGTH_FORMAT = 13;
		
		TRANSFORM_DATA = 21; %CET: Computational Efficiency Trick
		TRANSFORM_DATA_TAG = 'TRANSFORM_DATA';
		TRANSFORM_DATA_CATEGORY = 6;
		TRANSFORM_DATA_FORMAT = 16;
		
		INV_TRANSFORM_DATA = 22; %CET: Computational Efficiency Trick
		INV_TRANSFORM_DATA_TAG = 'INV_TRANSFORM_DATA';
		INV_TRANSFORM_DATA_CATEGORY = 6;
		INV_TRANSFORM_DATA_FORMAT = 16;
		
		NORMALIZE_DATA = 23; %CET: Computational Efficiency Trick
		NORMALIZE_DATA_TAG = 'NORMALIZE_DATA';
		NORMALIZE_DATA_CATEGORY = 6;
		NORMALIZE_DATA_FORMAT = 16;
		
		INV_NORMALIZE_DATA = 24; %CET: Computational Efficiency Trick
		INV_NORMALIZE_DATA_TAG = 'INV_NORMALIZE_DATA';
		INV_NORMALIZE_DATA_CATEGORY = 6;
		INV_NORMALIZE_DATA_FORMAT = 16;
		
		RAW_DATA = 25; %CET: Computational Efficiency Trick
		RAW_DATA_TAG = 'RAW_DATA';
		RAW_DATA_CATEGORY = 5;
		RAW_DATA_FORMAT = 16;
		
		PROCESS_DATA = 26; %CET: Computational Efficiency Trick
		PROCESS_DATA_TAG = 'PROCESS_DATA';
		PROCESS_DATA_CATEGORY = 6;
		PROCESS_DATA_FORMAT = 16;
		
		REV_PROCESS_DATA = 27; %CET: Computational Efficiency Trick
		REV_PROCESS_DATA_TAG = 'REV_PROCESS_DATA';
		REV_PROCESS_DATA_CATEGORY = 6;
		REV_PROCESS_DATA_FORMAT = 16;
		
		EXTRACT_DATA = 28; %CET: Computational Efficiency Trick
		EXTRACT_DATA_TAG = 'EXTRACT_DATA';
		EXTRACT_DATA_CATEGORY = 6;
		EXTRACT_DATA_FORMAT = 16;
		
		EXTRACT_LABELS = 29; %CET: Computational Efficiency Trick
		EXTRACT_LABELS_TAG = 'EXTRACT_LABELS';
		EXTRACT_LABELS_CATEGORY = 6;
		EXTRACT_LABELS_FORMAT = 3;
	end
	methods % constructor
		function dproc = NNDatasetProcess_RamanSpectra(varargin)
			%NNDatasetProcess_RamanSpectra() creates a Raman-spectra dataset process.
			%
			% NNDatasetProcess_RamanSpectra(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNDatasetProcess_RamanSpectra(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNDatasetProcess_RamanSpectra properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the Raman-spectra dataset process.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the Raman-spectra dataset process.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the Raman-spectra dataset process.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the Raman-spectra dataset process.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the Raman-spectra dataset process.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the Raman-spectra dataset process.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are specific notes of the Raman-spectra dataset process.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (result, item) is the neural-network dataset containing NNDataPoint_RamanSpectra built from RAW_DATA and EXTRACT_LABELS.
			%  <strong>10</strong> <strong>STRESS_SEQ</strong> 	STRESS_SEQ (parameter, stringlist) is the canonical stress-label ordering used by EXTRACT_LABELS.
			%  <strong>11</strong> <strong>KIND_SEQ</strong> 	KIND_SEQ (parameter, stringlist) is the canonical species/cultivar code ordering used by EXTRACT_LABELS.
			%  <strong>12</strong> <strong>LOCATION_SEQ</strong> 	LOCATION_SEQ (parameter, stringlist) is the canonical location label ordering used by EXTRACT_LABELS.
			%  <strong>13</strong> <strong>TARGETS_TO_REMOVE</strong> 	TARGETS_TO_REMOVE (data, stringlist) is a list of label tokens to exclude; any data point whose label contains a listed token is removed.
			%  <strong>14</strong> <strong>RAW_DATA_DIR</strong> 	RAW_DATA_DIR (data, string) is the directory containing Raman *.b2 files to be processed.
			%  <strong>15</strong> <strong>WAVELENGTH_START</strong> 	WAVELENGTH_START (parameter, scalar) is the starting wavelength (cm^-1).
			%  <strong>16</strong> <strong>WAVELENGTH_END</strong> 	WAVELENGTH_END (parameter, scalar) is the ending wavelength (cm^-1).
			%  <strong>17</strong> <strong>TRANSFORMATION_RULE</strong> 	TRANSFORMATION_RULE (parameter, option) is the spectral transformation applied before normalisation.
			%  <strong>18</strong> <strong>NORMALIZATION_RULE</strong> 	NORMALIZATION_RULE (parameter, option) is the spectral normalisation applied after transformation.
			%  <strong>19</strong> <strong>SCALE_FACTOR</strong> 	SCALE_FACTOR (parameter, scalar) is the scaling factor used when NORMALIZATION_RULE is Scale.
			%  <strong>20</strong> <strong>WAVELENGTH</strong> 	WAVELENGTH (result, cvector) returns the wavelength vector parsed from the first *.b2 file in RAW_DATA_DIR.
			%  <strong>21</strong> <strong>TRANSFORM_DATA</strong> 	TRANSFORM_DATA (query, cell) applies TRANSFORMATION_RULE to a wavelength×datapoints matrix and returns the transformed data.
			%  <strong>22</strong> <strong>INV_TRANSFORM_DATA</strong> 	INV_TRANSFORM_DATA (query, cell) applies the inverse of TRANSFORMATION_RULE to recover spectra from a derivative representation.
			%  <strong>23</strong> <strong>NORMALIZE_DATA</strong> 	NORMALIZE_DATA (query, cell) applies NORMALIZATION_RULE to a wavelength×datapoints matrix and returns the normalised data.
			%  <strong>24</strong> <strong>INV_NORMALIZE_DATA</strong> 	INV_NORMALIZE_DATA (query, cell) applies the inverse of NORMALIZATION_RULE to restore original scale.
			%  <strong>25</strong> <strong>RAW_DATA</strong> 	RAW_DATA (result, cell) returns the raw spectral data as a cell array (one column per datapoint) extracted by EXTRACT_DATA.
			%  <strong>26</strong> <strong>PROCESS_DATA</strong> 	PROCESS_DATA (query, cell) returns spectra processed by TRANSFORM_DATA followed by NORMALIZE_DATA, packaged as a cell array of column vectors.
			%  <strong>27</strong> <strong>REV_PROCESS_DATA</strong> 	REV_PROCESS_DATA (query, cell) returns spectra reconstructed by INV_NORMALIZE_DATA and INV_TRANSFORM_DATA, packaged as a cell array of column vectors.
			%  <strong>28</strong> <strong>EXTRACT_DATA</strong> 	EXTRACT_DATA (query, cell) extracts spectral intensities from all *.b2 files in RAW_DATA_DIR and returns a cell array of wavelength×1 vectors (one per spectrum).
			%  <strong>29</strong> <strong>EXTRACT_LABELS</strong> 	EXTRACT_LABELS (query, stringlist) extracts a 4-row label matrix per spectrum (species, stress, location, plant ID) using KIND_SEQ, STRESS_SEQ and LOCATION_SEQ, returned as a stringlist of char arrays.
			%
			% See also Category, Format.
			
			dproc = dproc@NNDatasetProcess(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the Raman-spectra dataset process.
			%
			% BUILD = NNDatasetProcess_RamanSpectra.GETBUILD() returns the build of 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  BUILD = DPROC.GETBUILD() returns the build of the Raman-spectra dataset process DPROC.
			%  BUILD = Element.GETBUILD(DPROC) returns the build of 'DPROC'.
			%  BUILD = Element.GETBUILD('NNDatasetProcess_RamanSpectra') returns the build of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETBUILD(DPROC) and Element.GETBUILD('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			
			build = 1;
		end
		function dproc_class = getClass()
			%GETCLASS returns the class of the Raman-spectra dataset process.
			%
			% CLASS = NNDatasetProcess_RamanSpectra.GETCLASS() returns the class 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  CLASS = DPROC.GETCLASS() returns the class of the Raman-spectra dataset process DPROC.
			%  CLASS = Element.GETCLASS(DPROC) returns the class of 'DPROC'.
			%  CLASS = Element.GETCLASS('NNDatasetProcess_RamanSpectra') returns 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETCLASS(DPROC) and Element.GETCLASS('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			
			dproc_class = 'NNDatasetProcess_RamanSpectra';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the Raman-spectra dataset process.
			%
			% LIST = NNDatasetProcess_RamanSpectra.GETSUBCLASSES() returns all subclasses of 'NNDatasetProcess_RamanSpectra'.
			%
			% Alternative forms to call this method are:
			%  LIST = DPROC.GETSUBCLASSES() returns all subclasses of the Raman-spectra dataset process DPROC.
			%  LIST = Element.GETSUBCLASSES(DPROC) returns all subclasses of 'DPROC'.
			%  LIST = Element.GETSUBCLASSES('NNDatasetProcess_RamanSpectra') returns all subclasses of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETSUBCLASSES(DPROC) and Element.GETSUBCLASSES('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNDatasetProcess_RamanSpectra' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of Raman-spectra dataset process.
			%
			% PROPS = NNDatasetProcess_RamanSpectra.GETPROPS() returns the property list of Raman-spectra dataset process
			%  as a row vector.
			%
			% PROPS = NNDatasetProcess_RamanSpectra.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = DPROC.GETPROPS([CATEGORY]) returns the property list of the Raman-spectra dataset process DPROC.
			%  PROPS = Element.GETPROPS(DPROC[, CATEGORY]) returns the property list of 'DPROC'.
			%  PROPS = Element.GETPROPS('NNDatasetProcess_RamanSpectra'[, CATEGORY]) returns the property list of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETPROPS(DPROC) and Element.GETPROPS('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = [4 10 11 12 15 16 17 18 19];
				case 4 % Category.DATA
					prop_list = [5 13 14];
				case 5 % Category.RESULT
					prop_list = [9 20 25];
				case 6 % Category.QUERY
					prop_list = [8 21 22 23 24 26 27 28 29];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of Raman-spectra dataset process.
			%
			% N = NNDatasetProcess_RamanSpectra.GETPROPNUMBER() returns the property number of Raman-spectra dataset process.
			%
			% N = NNDatasetProcess_RamanSpectra.GETPROPNUMBER(CATEGORY) returns the property number of Raman-spectra dataset process
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = DPROC.GETPROPNUMBER([CATEGORY]) returns the property number of the Raman-spectra dataset process DPROC.
			%  N = Element.GETPROPNUMBER(DPROC) returns the property number of 'DPROC'.
			%  N = Element.GETPROPNUMBER('NNDatasetProcess_RamanSpectra') returns the property number of 'NNDatasetProcess_RamanSpectra'.
			%
			% Note that the Element.GETPROPNUMBER(DPROC) and Element.GETPROPNUMBER('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 29;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 9;
				case 4 % Category.DATA
					prop_number = 3;
				case 5 % Category.RESULT
					prop_number = 3;
				case 6 % Category.QUERY
					prop_number = 9;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in Raman-spectra dataset process/error.
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
			
			check = prop >= 1 && prop <= 29 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNDatasetProcess_RamanSpectra.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in Raman-spectra dataset process/error.
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
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'STRESS_SEQ'  'KIND_SEQ'  'LOCATION_SEQ'  'TARGETS_TO_REMOVE'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'TRANSFORM_DATA'  'INV_TRANSFORM_DATA'  'NORMALIZE_DATA'  'INV_NORMALIZE_DATA'  'RAW_DATA'  'PROCESS_DATA'  'REV_PROCESS_DATA'  'EXTRACT_DATA'  'EXTRACT_LABELS' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput' '\n' ...
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
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'STRESS_SEQ'  'KIND_SEQ'  'LOCATION_SEQ'  'TARGETS_TO_REMOVE'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'TRANSFORM_DATA'  'INV_TRANSFORM_DATA'  'NORMALIZE_DATA'  'INV_NORMALIZE_DATA'  'RAW_DATA'  'PROCESS_DATA'  'REV_PROCESS_DATA'  'EXTRACT_DATA'  'EXTRACT_LABELS' })); % tag = pointer %CET: Computational Efficiency Trick
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
				%CET: Computational Efficiency Trick
				nndatasetprocess_ramanspectra_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'STRESS_SEQ'  'KIND_SEQ'  'LOCATION_SEQ'  'TARGETS_TO_REMOVE'  'RAW_DATA_DIR'  'WAVELENGTH_START'  'WAVELENGTH_END'  'TRANSFORMATION_RULE'  'NORMALIZATION_RULE'  'SCALE_FACTOR'  'WAVELENGTH'  'TRANSFORM_DATA'  'INV_TRANSFORM_DATA'  'NORMALIZE_DATA'  'INV_NORMALIZE_DATA'  'RAW_DATA'  'PROCESS_DATA'  'REV_PROCESS_DATA'  'EXTRACT_DATA'  'EXTRACT_LABELS' };
				tag = nndatasetprocess_ramanspectra_tag_list{pointer}; % prop = pointer
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
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_ramanspectra_category_list = { 1  1  1  3  4  2  2  6  5  3  3  3  4  4  3  3  3  3  3  5  6  6  6  6  5  6  6  6  6 };
			prop_category = nndatasetprocess_ramanspectra_category_list{prop};
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
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_ramanspectra_format_list = { 2  2  2  8  2  2  2  2  8  3  3  3  3  2  11  11  5  5  11  13  16  16  16  16  16  16  16  16  3 };
			prop_format = nndatasetprocess_ramanspectra_format_list{prop};
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
			
			%CET: Computational Efficiency Trick
			nndatasetprocess_ramanspectra_description_list = { 'ELCLASS (constant, string) is the class of the Raman-spectra dataset process.'  'NAME (constant, string) is the name of the Raman-spectra dataset process.'  'DESCRIPTION (constant, string) is the description of the Raman-spectra dataset process.'  'TEMPLATE (parameter, item) is the template of the Raman-spectra dataset process.'  'ID (data, string) is a few-letter code of the Raman-spectra dataset process.'  'LABEL (metadata, string) is an extended label of the Raman-spectra dataset process.'  'NOTES (metadata, string) are specific notes of the Raman-spectra dataset process.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (result, item) is the neural-network dataset containing NNDataPoint_RamanSpectra built from RAW_DATA and EXTRACT_LABELS.'  'STRESS_SEQ (parameter, stringlist) is the canonical stress-label ordering used by EXTRACT_LABELS.'  'KIND_SEQ (parameter, stringlist) is the canonical species/cultivar code ordering used by EXTRACT_LABELS.'  'LOCATION_SEQ (parameter, stringlist) is the canonical location label ordering used by EXTRACT_LABELS.'  'TARGETS_TO_REMOVE (data, stringlist) is a list of label tokens to exclude; any data point whose label contains a listed token is removed.'  'RAW_DATA_DIR (data, string) is the directory containing Raman *.b2 files to be processed.'  'WAVELENGTH_START (parameter, scalar) is the starting wavelength (cm^-1).'  'WAVELENGTH_END (parameter, scalar) is the ending wavelength (cm^-1).'  'TRANSFORMATION_RULE (parameter, option) is the spectral transformation applied before normalisation.'  'NORMALIZATION_RULE (parameter, option) is the spectral normalisation applied after transformation.'  'SCALE_FACTOR (parameter, scalar) is the scaling factor used when NORMALIZATION_RULE is Scale.'  'WAVELENGTH (result, cvector) returns the wavelength vector parsed from the first *.b2 file in RAW_DATA_DIR.'  'TRANSFORM_DATA (query, cell) applies TRANSFORMATION_RULE to a wavelength×datapoints matrix and returns the transformed data.'  'INV_TRANSFORM_DATA (query, cell) applies the inverse of TRANSFORMATION_RULE to recover spectra from a derivative representation.'  'NORMALIZE_DATA (query, cell) applies NORMALIZATION_RULE to a wavelength×datapoints matrix and returns the normalised data.'  'INV_NORMALIZE_DATA (query, cell) applies the inverse of NORMALIZATION_RULE to restore original scale.'  'RAW_DATA (result, cell) returns the raw spectral data as a cell array (one column per datapoint) extracted by EXTRACT_DATA.'  'PROCESS_DATA (query, cell) returns spectra processed by TRANSFORM_DATA followed by NORMALIZE_DATA, packaged as a cell array of column vectors.'  'REV_PROCESS_DATA (query, cell) returns spectra reconstructed by INV_NORMALIZE_DATA and INV_TRANSFORM_DATA, packaged as a cell array of column vectors.'  'EXTRACT_DATA (query, cell) extracts spectral intensities from all *.b2 files in RAW_DATA_DIR and returns a cell array of wavelength×1 vectors (one per spectrum).'  'EXTRACT_LABELS (query, stringlist) extracts a 4-row label matrix per spectrum (species, stress, location, plant ID) using KIND_SEQ, STRESS_SEQ and LOCATION_SEQ, returned as a stringlist of char arrays.' };
			prop_description = nndatasetprocess_ramanspectra_description_list{prop};
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
			
			switch prop %CET: Computational Efficiency Trick
				case 10 % NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_settings = Format.getFormatSettings(3);
				case 11 % NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_settings = Format.getFormatSettings(3);
				case 12 % NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_settings = Format.getFormatSettings(3);
				case 13 % NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_settings = Format.getFormatSettings(3);
				case 14 % NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_settings = Format.getFormatSettings(2);
				case 15 % NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_settings = Format.getFormatSettings(11);
				case 16 % NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_settings = Format.getFormatSettings(11);
				case 17 % NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_settings = {'First derivative'};
				case 18 % NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_settings = {'Scale'};
				case 19 % NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_settings = Format.getFormatSettings(11);
				case 20 % NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_settings = Format.getFormatSettings(13);
				case 21 % NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_settings = Format.getFormatSettings(16);
				case 22 % NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_settings = Format.getFormatSettings(16);
				case 23 % NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_settings = Format.getFormatSettings(16);
				case 24 % NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_settings = Format.getFormatSettings(16);
				case 25 % NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_settings = Format.getFormatSettings(16);
				case 26 % NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_settings = Format.getFormatSettings(16);
				case 27 % NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_settings = Format.getFormatSettings(16);
				case 28 % NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_settings = Format.getFormatSettings(16);
				case 29 % NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_settings = Format.getFormatSettings(3);
				case 4 % NNDatasetProcess_RamanSpectra.TEMPLATE
					prop_settings = 'NNDatasetProcess_RamanSpectra';
				case 9 % NNDatasetProcess_RamanSpectra.D
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
			
			switch prop %CET: Computational Efficiency Trick
				case 10 % NNDatasetProcess_RamanSpectra.STRESS_SEQ
					prop_default = {'WL', 'HL', 'LL', 'SH'};
				case 11 % NNDatasetProcess_RamanSpectra.KIND_SEQ
					prop_default = {'AB2', 'CS', 'KL'};
				case 12 % NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					prop_default = {'loc1', 'loc2'};
				case 13 % NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					prop_default = {'ps'};
				case 14 % NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					prop_default = Format.getFormatDefault(2, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 15 % NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					prop_default = 600;
				case 16 % NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					prop_default = 1750;
				case 17 % NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					prop_default = 'First derivative';
				case 18 % NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					prop_default = 'Scale';
				case 19 % NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					prop_default = 1;
				case 20 % NNDatasetProcess_RamanSpectra.WAVELENGTH
					prop_default = Format.getFormatDefault(13, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 21 % NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 22 % NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 23 % NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 24 % NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 25 % NNDatasetProcess_RamanSpectra.RAW_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 26 % NNDatasetProcess_RamanSpectra.PROCESS_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 27 % NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 28 % NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					prop_default = Format.getFormatDefault(16, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 29 % NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					prop_default = Format.getFormatDefault(3, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 1 % NNDatasetProcess_RamanSpectra.ELCLASS
					prop_default = 'NNDatasetProcess_RamanSpectra';
				case 2 % NNDatasetProcess_RamanSpectra.NAME
					prop_default = 'Raman-Spectra Dataset Process';
				case 3 % NNDatasetProcess_RamanSpectra.DESCRIPTION
					prop_default = 'The Raman-spectra dataset process (NNDatasetProcess_RamanSpectra) converts raw Raman spectra stored in *.b2 files into an NNDataset of NNDataPoint_RamanSpectra, applying optional spectral transformation and normalisation and attaching label metadata.';
				case 4 % NNDatasetProcess_RamanSpectra.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 5 % NNDatasetProcess_RamanSpectra.ID
					prop_default = 'NNDatasetProcess_RamanSpectra ID';
				case 6 % NNDatasetProcess_RamanSpectra.LABEL
					prop_default = 'NNDatasetProcess_RamanSpectra label';
				case 7 % NNDatasetProcess_RamanSpectra.NOTES
					prop_default = 'NNDatasetProcess_RamanSpectra notes';
				case 9 % NNDatasetProcess_RamanSpectra.D
					prop_default = Format.getFormatDefault(8, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
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
			%  Error id: BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DPROC.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of DPROC.
			%   Error id: BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput
			%  Element.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_RamanSpectra.
			%   Error id: BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput
			%  DPROC.CHECKPROP(NNDatasetProcess_RamanSpectra, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNDatasetProcess_RamanSpectra.
			%   Error id: BRAPH2:NNDatasetProcess_RamanSpectra:WrongInput]
			% 
			% Note that the Element.CHECKPROP(DPROC) and Element.CHECKPROP('NNDatasetProcess_RamanSpectra')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNDatasetProcess_RamanSpectra.getPropProp(pointer);
			
			switch prop
				case 10 % NNDatasetProcess_RamanSpectra.STRESS_SEQ
					check = Format.checkFormat(3, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 11 % NNDatasetProcess_RamanSpectra.KIND_SEQ
					check = Format.checkFormat(3, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 12 % NNDatasetProcess_RamanSpectra.LOCATION_SEQ
					check = Format.checkFormat(3, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 13 % NNDatasetProcess_RamanSpectra.TARGETS_TO_REMOVE
					check = Format.checkFormat(3, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 14 % NNDatasetProcess_RamanSpectra.RAW_DATA_DIR
					check = Format.checkFormat(2, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 15 % NNDatasetProcess_RamanSpectra.WAVELENGTH_START
					check = Format.checkFormat(11, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 16 % NNDatasetProcess_RamanSpectra.WAVELENGTH_END
					check = Format.checkFormat(11, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 17 % NNDatasetProcess_RamanSpectra.TRANSFORMATION_RULE
					check = Format.checkFormat(5, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 18 % NNDatasetProcess_RamanSpectra.NORMALIZATION_RULE
					check = Format.checkFormat(5, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 19 % NNDatasetProcess_RamanSpectra.SCALE_FACTOR
					check = Format.checkFormat(11, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 20 % NNDatasetProcess_RamanSpectra.WAVELENGTH
					check = Format.checkFormat(13, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 21 % NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 22 % NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 23 % NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 24 % NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 25 % NNDatasetProcess_RamanSpectra.RAW_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 26 % NNDatasetProcess_RamanSpectra.PROCESS_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 27 % NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 28 % NNDatasetProcess_RamanSpectra.EXTRACT_DATA
					check = Format.checkFormat(16, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 29 % NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					check = Format.checkFormat(3, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 4 % NNDatasetProcess_RamanSpectra.TEMPLATE
					check = Format.checkFormat(8, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				case 9 % NNDatasetProcess_RamanSpectra.D
					check = Format.checkFormat(8, value, NNDatasetProcess_RamanSpectra.getPropSettings(prop));
				otherwise
					if prop <= 9
						check = checkProp@NNDatasetProcess(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput'], ...
					['BRAPH2' ':NNDatasetProcess_RamanSpectra:' 'WrongInput' '\n' ...
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
				case 19 % NNDatasetProcess_RamanSpectra.SCALE_FACTOR
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
				case 20 % NNDatasetProcess_RamanSpectra.WAVELENGTH
					rng_settings_ = rng(); rng(dproc.getPropSeed(20), 'twister')
					
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
					
				case 21 % NNDatasetProcess_RamanSpectra.TRANSFORM_DATA
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
					    case 'First derivative'
					        data_tmp = data;
					        data_tmp = data_tmp(2:end, :) - data_tmp(1:end-1, :);
					        data(1:end-1, :) = data_tmp;
					        data(end, :) = 0;
					end
					value = data;
					
				case 22 % NNDatasetProcess_RamanSpectra.INV_TRANSFORM_DATA
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
					    case 'First derivative'
					        base_row = varargin{2}; % raw_data(1, :)
					        detransformed_x = base_row + cumsum([zeros(1, size(deriv, 2)); deriv(1:end-1, :)], 1);
					end
					value = detransformed_x;
					
				case 23 % NNDatasetProcess_RamanSpectra.NORMALIZE_DATA
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
					
				case 24 % NNDatasetProcess_RamanSpectra.INV_NORMALIZE_DATA
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
					
				case 25 % NNDatasetProcess_RamanSpectra.RAW_DATA
					rng_settings_ = rng(); rng(dproc.getPropSeed(25), 'twister')
					
					value = dproc.get('EXTRACT_DATA');
					
					rng(rng_settings_)
					
				case 26 % NNDatasetProcess_RamanSpectra.PROCESS_DATA
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
					
				case 27 % NNDatasetProcess_RamanSpectra.REV_PROCESS_DATA
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
					
				case 28 % NNDatasetProcess_RamanSpectra.EXTRACT_DATA
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
					    ids = cellfun(@(spectrum) spectrum.get('ID'), b2_el.el.get('RE_OUT').get('SP_DICT').get('IT_LIST'), 'UniformOutput', false);
					
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
					        X(:, counter1:counter2) = intensities; %#ok<AGROW>
					    end
					end
					
					for i = 1:size(X, 2)
					    value{i} = X(:, i);
					end
					
				case 29 % NNDatasetProcess_RamanSpectra.EXTRACT_LABELS
					dir_name = dproc.get('RAW_DATA_DIR');
					if isempty(dir_name)
					    value = {};
					    return
					end
					
					stress_seq   = string(dproc.get('STRESS_SEQ'));
					kind_seq     = string(dproc.get('KIND_SEQ'));
					location_seq = string(dproc.get('LOCATION_SEQ'));
					
					file_list = dir(fullfile(dir_name, '*b2'));
					if isempty(file_list)
					    value = {};
					    return
					end
					
					Y = strings(4, 0);
					col_offset = 0;
					
					for f = 1:numel(file_list)
					    file_name = string(file_list(f).name);
					    b2_el = load(fullfile(dir_name, file_list(f).name), '-mat');
					
					    sp_dict = b2_el.el.get('RE_OUT').get('SP_DICT');
					    num_spectrum_file = sp_dict.get('LENGTH');
					    ids = cellfun(@(sp) sp.get('ID'), sp_dict.get('IT_LIST'), 'UniformOutput', false);
					
					    species_label = "";
					    for kk = 1:numel(kind_seq)
					        if contains(file_name, kind_seq(kk))
					            species_label = kind_seq(kk);
					            break
					        end
					    end
					
					    for i = 1:num_spectrum_file
					        sp_el = sp_dict.get('IT', i);
					        intensities = sp_el.get('INTENSITIES');
					        num_col = size(intensities, 2);
					        if num_col == 0
					            continue
					        end
					
					        id = string(ids{i});
					
					        stress_label = "";
					        for ss = 1:numel(stress_seq)
					            if contains(id, stress_seq(ss))
					                stress_label = stress_seq(ss);
					                break
					            end
					        end
					
					        location_label = "";
					        for ll = 1:numel(location_seq)
					            if contains(id, location_seq(ll))
					                location_label = location_seq(ll);
					                break
					            end
					        end
					
					        Y(:, col_offset + (1:num_col)) = [
					            repmat(species_label , 1, num_col)
					            repmat(stress_label  , 1, num_col)
					            repmat(location_label, 1, num_col)
					            repmat(id            , 1, num_col)
					        ];
					
					        col_offset = col_offset + num_col;
					    end
					end
					
					value = cell(1, size(Y, 2));
					for i = 1:size(Y, 2)
					    value{i} = char(Y(:, i));
					end
					
				case 9 % NNDatasetProcess_RamanSpectra.D
					rng_settings_ = rng(); rng(dproc.getPropSeed(9), 'twister')
					
					processed_spectrum_list = dproc.get('PROCESS_DATA');
					raw_label_list = dproc.get('EXTRACT_LABELS');
					
                    targets_to_remove = dproc.get('TARGETS_TO_REMOVE');
                    idx_to_remove = [];
                    if ~isempty(targets_to_remove)
                        for i = 1:numel(raw_label_list)
                            rows = strtrim(cellstr(raw_label_list{i}));   % 4 rows: species, stress, location, plant ID
                            rows = rows(1:3);                              % only species/stress/location
                            for t = 1:numel(targets_to_remove)
                                tok = strtrim(targets_to_remove{t});
                                if any(strcmpi(rows, tok))                 % exact match (no substring hits)
                                    idx_to_remove(end+1) = i; %#ok<AGROW>
                                    break
                                end
                            end
                        end
                    end

                    idx_to_remove = unique(idx_to_remove);
					
					processed_spectrum_list(idx_to_remove) = [];
					raw_label_list(idx_to_remove) = [];
					
					it_list = cellfun(@(data, label) NNDataPoint_RamanSpectra( ...
					    'SP_DATA', data, ...
					    'WL', dproc.getCallback('WAVELENGTH'), ...
					    'WL_START', dproc.getCallback('WAVELENGTH_START'), ...
					    'WL_END', dproc.getCallback('WAVELENGTH_END'), ...
					    'TARGET_CLASS', {label}), ...
					    processed_spectrum_list, raw_label_list, ...
					    'UniformOutput', false);
					
					dp_list = IndexedDictionary( ...
					    'IT_CLASS', 'NNDataPoint_RamanSpectra', ...
					    'IT_LIST', it_list ...
					    );
					
					value = NNDataset( ...
					    'DP_CLASS', 'NNDataPoint_RamanSpectra', ...
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
