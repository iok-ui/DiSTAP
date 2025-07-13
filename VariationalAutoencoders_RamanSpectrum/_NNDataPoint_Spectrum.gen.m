%% ¡header!
NNDataPoint_Spectrum < NNDataPoint (dp, spectrum data point) is a data point for a spectrum.

%%% ¡description!
A data point for a spectrum (NNDataPoint_Spectrum) 
 contains both spectral input and target for neural network analysis.
The input is the value of the spectrum.
The target is obtained from the variables of interest of the datapoint, such as the spectrum type.

%%% ¡seealso!
NNDataPoint_Graph_REG, NNDataPoint_Measure_REG, NNDataPoint_Measure_CLA

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the data point for spectrum.
%%%% ¡default!
'NNDataPoint_Spectrum'

%%% ¡prop!
NAME (constant, string) is the name of the data point for spectrum.
%%%% ¡default!
'Neural Network Data Point for Classification with a Graph'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the data point for spectrum.
%%%% ¡default!
'A data point for a spectrum (NNDataPoint_Spectrum) contains both spectral input and target for neural network analysis. The input is the value of the spectrum. The target is obtained from the variables of interest of the datapoint, such as the spectrum type.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the data point for spectrum.
%%%% ¡settings!
'NNDataPoint_Spectrum'

%%% ¡prop!
ID (data, string) is a few-letter code for the data point for spectrum.
%%%% ¡default!
'NNDataPoint_Spectrum ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the data point for spectrum.
%%%% ¡default!
'NNDataPoint_Spectrum label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the data point for spectrum.
%%%% ¡default!
'NNDataPoint_Spectrum notes'

%%% ¡prop!
INPUT (result, cell) is the input value for this data point for spectrum.
%%%% ¡calculate!
sp = dp.get('SP');
wl = dp.get('WL');
wl_start = dp.get('WL_START');
wl_end = dp.get('WL_END');
diff_start = wl - wl_start;
[~, idx_wl_start] = min(abs(diff_start));
diff_end = wavelength - wavelength_end;
[~, idx_wl_end] = min(abs(diff_end));
value = sp(idx_wl_start:idx_wl_end);
    
%%% ¡prop!
TARGET (result, cell) is the target values for this data point for spectrum.
%%%% ¡calculate!
value = cellfun(@(c) sum(double(c)), dp.get('TARGET_CLASS'), 'UniformOutput', false);

%% ¡props!

%%% ¡prop!
SP (data, rvector) is the spectrum.

%%% ¡prop!
WL (data, rvector) is the wavelength.

%%% ¡prop!
WL_START (data, scalar) is the starting wavelength.
%%%% ¡default!
600

%%% ¡prop!
WL_END (data, scalar) is the ending  wavelength.
%%%% ¡default!
1750

%%% ¡prop!
TARGET_CLASS (parameter, stringlist) is a list of variable-of-interest IDs to be used as the class targets.

%% ¡tests!


