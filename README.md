# fs-data-utils
Shell and python utilities for gathering Freesurfer stats into csv format


# Usage
The shell scripts should be run first, followed by the python scripts. 

## aseg.stats
First, we cut the aseg.stats file to the last 46 lines that are formatted like a tsv
```
for i in `ls project/bids/derivatives/sourcedata/freesurfer/sub*/stats/aseg.stats`; do echo ${i} && tail -n 46 ${i} > ${i}.csv; done
```

Then we make a copy of these files with their BIDS participant label in the filename
```
for i in `ls project/bids/derivatives/sourcedata/freesurfer/sub*/stats/aseg.stats.csv`; do echo ${i} && ii=`echo ${i} | rev | cut -d/ -f3 | rev` && cp ${i} ./${ii}_aseg.stats.csv
```

Now we can adjust the path for the csvs in the python script and create the combined csv at the group level
```
python3 collate_aseg.py
```

If all has gone well, we can delete the participant-level csvs
```
rm ./sub-*_aseg.stats.csv
```

## brainvol.stats

```
for i in `ls project/bids/derivatives/fmriprep/sourcedata/freesurfer/sub*/stats/brainvol.stats`; do echo ${i} && ii=`echo ${i} | rev | cut -d/ -f3 | rev` && ./brainvol_extract.sh ${i} ${i}.csv && mv ${i}.csv ./${ii}_brainvol.stats.csv; done
```
Set the path for the csvs in the python script and create the combined csv at the group level
```
python3 collate_brainvol.py
```
