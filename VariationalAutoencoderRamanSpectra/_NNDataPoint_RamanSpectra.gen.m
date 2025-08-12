%% ¡header!
NNDataPoint_SpectrumSignal < NNDataPoint (dp, spectrum data point) is a data point for a spectrum.

%%% ¡description!
A data point for a spectrum (NNDataPoint_SpectrumSignal) 
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
'NNDataPoint_SpectrumSignal'

%%% ¡prop!
NAME (constant, string) is the name of the data point for spectrum.
%%%% ¡default!
'Neural Network Data Point for Classification with a Graph'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the data point for spectrum.
%%%% ¡default!
'A data point for a spectrum (NNDataPoint_SpectrumSignal) contains both spectral input and target for neural network analysis. The input is the value of the spectrum. The target is obtained from the variables of interest of the datapoint, such as the spectrum type.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the data point for spectrum.
%%%% ¡settings!
'NNDataPoint_SpectrumSignal'

%%% ¡prop!
ID (data, string) is a few-letter code for the data point for spectrum.
%%%% ¡default!
'NNDataPoint_SpectrumSignal ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the data point for spectrum.
%%%% ¡default!
'NNDataPoint_SpectrumSignal label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the data point for spectrum.
%%%% ¡default!
'NNDataPoint_SpectrumSignal notes'

%%% ¡prop!
INPUT (result, cell) is the input value for this data point for spectrum.
%%%% ¡calculate!
wavelength = dp.get('WL');
wavelength_start = dp.get('WL_START');
wavelength_end = dp.get('WL_END');

diff_start = wavelength - wavelength_start;
[~, idx_wav_start] = min(abs(diff_start));
diff_end = wavelength - wavelength_end;
[~, idx_wav_end] = min(abs(diff_end));

sp_data = dp.get('SP_DATA');
if isempty(sp_data)
    value = {};
else
    value = {sp_data(idx_wav_start:idx_wav_end)};
end

%%% ¡prop!
TARGET (result, cell) is the target values for this data point for spectrum.
%%%% ¡calculate!
value = cellfun(@(c) sum(double(c)), dp.get('TARGET_CLASS'), 'UniformOutput', false);

%% ¡props!

%%% ¡prop!
SP_DATA (data, cvector) is the spectrum value.

%%% ¡prop!
WL (data, cvector) is the vector of the wavelengths at which the spectrum is acquired.

%%% ¡prop!
WL_START (data, scalar) is the starting wavelength.
%%%% ¡default!
600

%%% ¡prop!
WL_END (data, scalar) is the ending wavelength.
%%%% ¡default!
1750

%%% ¡prop!
TARGET_CLASS (parameter, stringlist) is a list of variable-of-interest IDs to be used as the class targets.

%%% ¡prop!
WL_LABELS (query, stringlist) is the labels for the wavelengths.
%%%% ¡calculate!
value = arrayfun(@(wavelength) [num2str(wavelength) ' cm-1'], dp.get('WL')', 'UniformOutput', false);



