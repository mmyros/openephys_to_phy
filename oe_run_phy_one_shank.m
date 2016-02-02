function oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks, dowait, doconvert_only)
%% Required inputs: path to data, name of experiment, output folder
%% Optional: consecutive number of shanks to run, whether to wait for
% completion of each shank, whether to convert open-ephys files without
% running phy
%% oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks, dowait, dotest)
% path_to_data='~/data/oe/';
% folder_experiment_id='md53d_2016-01-14_19-18-01/'
% folder_to_write= '~/res/oe/'
% shanks=1:4
addpath('~/Dropbox/depends/oe/')
if nargin<6,doconvert_only=0;end
dotest=1;
if nargin<5,dowait=1,end
if nargin<4,shanks=1:4,end
if nargin<3,folder_to_write=['~/usb/res/oe/'],end
if isempty(path_to_data),path_to_data='~/data/oe/',end
mkdir([folder_to_write 'phy'])
% do shank by shank
for ishank=shanks
    map_cambr=oeprobe_cambr(ishank,'mmy1');
    map= oeprobe_intan2sane(map_cambr);
    if dotest
        map_cambr=oeprobe_cambr(ishank,'test');
        map= oeprobe_intan2sane(map_cambr,1);
        
    end
    config_name = '100_raw.prm';
    output_directory=[folder_to_write  'phy/shank' ns(ishank)];
    mkdir(output_directory)
    copyfile(['~/Dropbox/spikesort/phy/config/' config_name],output_directory)
    oe2dat([path_to_data folder_experiment_id],output_directory,map)
    command=['export PATH="~/miniconda/bin:$PATH"; source activate phy;' ...
        'cd ' folder_to_write 'phy/shank' ns(ishank) '; phy spikesort --overwrite  ' config_name];
    if ~dowait,command=[command ' &'];end

    if ~doconvert_only
        system(command)
    end
end
