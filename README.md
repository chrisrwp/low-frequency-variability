# low-frequency-variability

## Journal article using this analysis
Wyburn-Powell, C. & Jahn, A. (2024) Large-Scale Climate Modes Drive Low-Frequency Regional Arctic Sea Ice Variability. *Journal of Climate*. https://doi.org/10.1175/JCLI-D-23-0326.1.

## Location of data
The data required to reproduce all figures in the journal article can be found at The Arctic Data Center: https://doi.org/10.18739/A2MS3K35M. The Jupyter Notebooks and important input and output files used to create each published figure are listed below.

## Abstract of journal article
Summer Arctic sea ice is declining rapidly but with superimposed variability on multiple
timescales that introduces large uncertainties into projections of future sea ice loss. To
better understand what drives at least part of this variability, we show how a simple
linear model can link dominant modes of climate variability to low-frequency regional
Arctic sea ice concentration (SIC) anomalies. Focusing on September, we find skillful
projections from global climate models (GCMs) from the Coupled Model
Intercomparison Project Phase 6 (CMIP6) at lead times of 4-20 years, with up to 60%
of observed low-frequency variability explained at a 5-year lead time. The dominant
driver of low-frequency SIC variability is the Interdecadal Pacific Oscillation (IPO) which
is positively correlated with SIC anomalies in all regions up to a lead time of 15 years,
but with large uncertainty between GCMs and internal variability realization. The Niño
3.4 Index and Atlantic Multidecadal Oscillation have better agreement between GCMs
of being positively and negatively related, respectively, with low-frequency SIC
anomalies for at least 10-year lead times. The large variation between GCMs and
between members within large ensembles indicate the diverse simulation of
teleconnections between the tropics and Arctic sea ice, and the dependence on initial
climate state. Further, the influence of the Niño 3.4 Index was found to be sensitive to
the background climate. Our results suggest that, based on the 2022 phases of
dominant climate variability modes, enhanced loss of sea ice area across the Arctic is
likely during the next decade.

<br>

## `input_data`
This directory is the collection of scripts which take in the model and observational data and processes it and allow it to be analyzed and used in the neural networks. 

### `CMIP6_glade_info.ipynb`
Bring together all CMIP6 data including paths on /glade, doi, modeling centers etc. The outputs are necessary as inputs for most of the other scripts in this repo in order to navigate the file directories and to ensure consistent metadata. <br>

**Outputs:**
- `CMIP6_modeling_center_members_doi.nc`
- `CMIP6_SImon_siconc_paths.pickle`
- `CMIP6_areacello_paths.pickle`
- `CMIP6_areacello_lat_names.pickle`
- `CMIP6_x_y_names.pickle`

### `regrid_MAISE_regions_to_areacello.sh`
Produces a NetCDF file with identifiers of the MASIE-NH regions on the native grid of the global climate models and observational data. These outputs are required for the computations in all other subsequent scripts in this directory. <br>

**Output:**
- `masiemask_<model_name>.nc`

### `Regional_sea_ice_CMIP6.ipynb`
This script reads in the raw siconc model output file and produces the linearly detrended lowpass filtered regional SIC for a given model, all members, over the time period 1920-2014 or 1970-2014. <br>

**Input:**
- `CMIP6_modeling_center_members_doi.nc`
- `CMIP6_SImon_siconc_paths.pickle`
- `CMIP6_areacello_paths.pickle`
- `CMIP6_areacello_lat_names.pickle`
- `CMIP6_x_y_names.pickle`
- `masiemask_<model_name>.nc`
- `areacello_Ofx_<model_name>_historical_<variant_id>_gn.nc`
- `siconc_SImon_<model_name>_historical_<variant_id>_gn_185001-201412.nc`

**Output:**
- `Regional_SIC_detrended_lowpass_filter_<model_name>_<start_year>_2014.nc`

### `Regional_sea_ice_obs.ipynb`
Processes the raw HadISST1 observational sea ice concentrations into regional SIC for 1920-2022. Then linearly detrend and lowpass filter this data in the same format as the model data.

**Input:**
- `https://www.metoffice.gov.uk/hadobs/hadisst/data/HadISST_ice.nc.gz`
- `HadISST1_gridarea.nc`
- `masiemask_HadISST1.nc`

**Outputs:**
- `Regional_SIC_HadISST1_1920_2022.nc`
- `Regional_SIC_detrended_lowpass_filter_HadISST1_1920_2022.nc`

### `Reduce_CVDP_datasets.ipynb`
Reads in the Climate Variability Diagnostics Package (CVDP) NetCDF files and extracts the time series, seasonally, for relevant variables. This data is then standardized and linearly detrended. Observational data is also processed here, with 'CERA20C_ERAI', 'ERA20C_ERAI', and 'HadISST' being observational rather than model datasets. Observational CVDP from 2015-2022 was processed by running the CVDP code, outside of this repo. 

**Inputs:**
- `http://webext.cgd.ucar.edu/Multi-Case/CVDP_repository/cmip6.historical-<group>/cmip6.historical-<group>.cvdp_data.tar/<model_name>_<variant_id>.cvdp_data.<start_year>-<end_year>.nc`
- `http://webext.cgd.ucar.edu/Multi-Case/CVDP_repository/cmip6.historical-<group>/cmip6.historical-<group>.cvdp_data.tar/<observational_dataset>.cvdp_data.1920-2014.nc`

**Outputs:**
- `CVDP_standardized_linear_detrended_<start_year>_2014_historical_<model_name>.nc`
- `CVDP_standardized_linear_detrended_1920_2014_<observational_dataset>_all_var.nc`

### `Extract_SIC_CVDP_from_PI_Control.ipynb` 
Repeat the process of extracting the regional SIC and linear detrended and standardized time series CVDP data, this time for a reduced scope for the pre-industrial control simulations. Here the data is pooled across GCMs and split into 74-year segments instead of members, and this is only computed for September, hence the single output files for SIC and CVDP respectively. 

**Input:**
- `siconc_SImon_<model_name>_piControl_<variant_id>_gn_<start_year>-<end_year>.nc`
- `http://webext.cgd.ucar.edu/Multi-Case/CVDP_repository/cmip6.piControl/cmip6.piControl.cvdp_data.tar/<model_name>_<variant_id>.cvdp_data.<start_year>-<end_year>.nc`

**Output:**
- `Regional_SIC_lowpass_filter_PI_Control_MMLE_500_first_3_train.nc`
- `CVDP_standardized_PI_Control_MMLE_500_first_3_train.nc`

<br>

## `neural_network`
This directory is a collection of scripts which use the processed model and observational data to train neural networks. The outputs from the neural networks are also tested and validated, and the results processed and plotted for publication figures.

### `Train_4_ML_Models.ipynb`
Trains validates and tests the optimal model weights for 4 neural network configurations to predict regional SIC anomalies lagged from standardized climate modes of variability. 

**Input:**
- `CMIP6_modeling_center_members_doi.nc`
- `CVDP_standardized_linear_detrended_<start_year>_2014_historical_<model_name>.nc`
- `Regional_SIC_detrended_lowpass_filter_<model_name>_<start_year>_2014.nc`
- `Regional_SIC_lowpass_filter_PI_Control_MMLE_500_first_3_train.nc`
- `CVDP_standardized_PI_Control_MMLE_500_first_3_train.nc`

**Output:**
- `weights_linear_<model_name>_<month>_month_var_9_best_season_all_months_lowpass_filt.nc`
- `validation_r_values_4ML_<model_name>_<month>_month_var_9_best_season_all_months_lowpass_filt.nc`
- `test_r_values_linear_LEs_var_9_best_season_LE_all_region_Sep.nc`

### `Analyze_4_ML_Models.ipynb`
Make plots and analyses of the trained models' predictive skill against persistence 

**Inputs:**
- `CMIP6_modeling_center_members_doi.nc`
- `CMIP6_members_CVDP_and_SIC.pickle`
- `validation_r_values_4ML_<model_name>_<month>_month_var_9_best_season_LE_all_region_Sep_lowpass_filt.nc`
- `validation_r_values_4ML_CMIP6_month_<month>_var_9_best_season_LE_all_region_Sep_lowpass_filt_1920_2014.nc`
- `validation_r_values_4ML_CMIP6_30_month_<month>_var_9_best_season_LE_all_region_Sep_filt_1920_2014.nc`
- `masiemask_regrid_01_01_nn.nc`
- `HadISST1_regional_SIC_area.nc`
- `HadISST1_1920-2022_regional_lin_detend_on_1920_2014.nc`
- `HadISST1_1920-2022_regional_lowpass_filt_lin_detend_on_1920_2014.nc`

**Output:**
- <ins>Table 1
- <ins>Figure 1
- <ins>Figure 2
- <ins>Figure 3
- <ins>Figure S4

### `Analyze_Linear_Model_Coefs.ipynb`
Make plots and analyses with the trained linear model coefficients

**Input:**
- `CMIP6_members_CVDP_and_SIC.pickle`
- `validation_r_values_4ML_<model_name>_<month>_month_var_9_best_season_LE_all_region_Sep_lowpass_filt.nc`
- `validation_r_values_4ML_CMIP6_month_<month>_var_9_best_season_LE_all_region_Sep_lowpass_filt_1920_2014.nc`
- `validation_r_values_4ML_CMIP6_30_month_<month>_var_9_best_season_LE_all_region_Sep_filt_1920_2014.nc`
- `weights_linear_<model_name>_month_<month>_var_9_all_IPO_lowpass_filt.nc`
- `weights_linear_CMIP6_month_<month>_var_9_best_season_LE_all_region_Sep_lowpass_filt.nc`
- `test_r_values_linear_CMIP6_var_9_best_season_LE_all_region_Sep.nc`
- `test_r_values_linear_LEs_var_9_best_season_LE_all_region_Sep.nc`

**Output:**
- <ins>Figure 4, S1, S2
- <ins>Figure 5
- <ins>Figure S3
- <ins>Figure 6

<br>

## `predict`
This directory is the collection of scripts which use the trained neural network model, and use this to make predictions of unseen outcomes both for the model data and for the observations. Further, the persistence of the regional SIC is also computed as a benchmark of skill. 

### `Null_model_persistence.ipynb`
Calculate the autocorrelation of the sea ice concentration data

**Input:**
- `Pearson_correlation_SIC_lagged_1_20_years_linear_detrended_1920_2014_lowpass_filt_HadISST1_for_1956_2022.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_lowpass_PI_Control.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_<model_name>.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_lowpass_<model_name>.nc`
- `Regional_SIC_lowpass_filter_CESM2-lessmelt_1920_2014.nc`

**Output:**
- `Pearson_correlation_SIC_lagged_1_20_years_linear_detrended_1920_2014_lowpass_filt_HadISST1_for_1956_2022.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_lowpass_PI_Control.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_<model_name>.nc`
- `Pearson_correlation_SIC_lagged_1_20_years_lowpass_<model_name>.nc`
- `Regional_SIC_lowpass_filter_CESM2-lessmelt_1920_2014.nc`


### `Min_max_anomaly_groups.ipynb`
Find the 6 largest regional SIC anomalies in the period 1950-2014 in both the models and observations. Correlate the corresponding standardized climate mode of variability values. 

**Input:**
- `CMIP6_modeling_center_members_doi.nc`
- `CMIP6_members_CVDP_and_SIC.pickle`
- `Regional_SIC_HadISST1_1920_2022.nc`
- `Regional_SIC_detrended_lowpass_filter_<model_name>_<start_year>_2014.nc`
- `CVDP_standardized_linear_detrended_1920_2014_historical_<model_name>.nc`
- `CVDP_standardized_linear_detrended_1920_2014_CERA20C_ERAI_all_var.nc`
- `CVDP_standardized_linear_detrended_1920_2014_ERA20C_ERAI_all_var.nc`
- `CVDP_standardized_linear_detrended_1920_2014_HadISST_all_var.nc`

**Output:**
- <ins>Figure 7

### `Predict_back_test.ipynb`
Use the observed climate modes of variability to make predictions of regional SIC anomalies using the trained linear model coefficients. 

**Input:**
- `HadISST1_regional_SIC_area.nc`
- `HadISST1_1920-2022_regional_lin_detend_on_1920_2014.nc`
- `HadISST1_1920-2022_regional_lowpass_filt_lin_detend_on_1920_2014.nc`
- `weights_linear_<model_name>_month_<month>_var_9_best_season_LE_all_region_Sep_lowpass_filt.nc`
- `weights_linear_CMIP6_month_<month>_var_9_best_season_LE_all_region_Sep_lowpass_filt_1920_2014.nc`
- `CVDP_standardized_linear_detrended_1920_2014_historical_<model_name>.nc`
- `CVDP_standardized_linear_detrended_1920_2014_CERA20C_ERAI_all_var.nc`
- `CVDP_standardized_linear_detrended_1920_2014_ERA20C_ERAI_all_var.nc`
- `CVDP_standardized_linear_detrended_1920_2014_HadISST_all_var.nc`
- `correlation_SIC_lagged_1_20_years_linear_detrended_1920_2014_lowpass_filt_HadISST1_for_1956_2022.nc`

**Output:**
- `GCM_models_1956_2022_predictions_from_obs_best_LE_seasons.nc`
- `MMLE_model_1956_2022_predictions_from_obs_best_LE_seasons.nc`
- `GCMs_predict_r2_HadISST1_1976_2022_best_LE_seasons.nc`
- `MMLE_predict_r2_HadISST1_1976_2022_best_LE_seasons.nc`
- <ins>Figure 8
