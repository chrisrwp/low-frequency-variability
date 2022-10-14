#!bin/bash

#regrids specified areacello reduced files within the directory to the 'MASIE' NSIDC regions using nearest neighbor
#input files have a naming convention <model_name>_resampled_<month>_<adj|>_<ensemble|individual>.nc

module load cdo #this loads the module - climate data operators

dir_path="/glade/work/cwpowell/low-frequency-variability/raw_data/masie_masks"

for file in $(ls ${dir_path}) #loop through the whole list of files in this directory
do
    now=$(date +"%T")
    echo "${file}" 
    echo "${now}"
    if grep -q "areacello_" <<< "${file}"; then #only select the files containing 'areacello'

        model_name=$(echo "${file}" | sed 's/areacello_//' | sed 's/_30N.nc//') #extract the model name
        
        cdo remapnn,${dir_path}/${file} ${dir_path}/masiemask_ims4km_just_regions.nc ${dir_path}/masiemask_${model_name}.nc #regrid MASIE regions onto areacello grid
        
    fi
done
