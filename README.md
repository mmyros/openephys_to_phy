I run phy from MATLAB like so:
```
oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks, dowait, doconvert_only)
```

For instance:
```
path_to_data='~/data/oe/';
folder_experiment_id='md53d_2016-01-14_19-18-01/'
folder_to_write= '~/res/oe/'
shanks=1:4
oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks)
```
The layout for each probe MUST be changed to obtain meaningful results in the file: 
oeprobe_cambr
It is written to facilitate copy/pasting vertically the layouts. For reference, see the picture of the probe with ID 'mmy1' in https://mmyros.github.io/github.io/cambr_intan.html
