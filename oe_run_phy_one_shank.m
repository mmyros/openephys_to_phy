function oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks, dowait, dotest)
% oe_run_phy_one_shank(path_to_data, folder_experiment_id, folder_to_write,shanks, dowait, dotest)
% path_to_data='~/data/oe/';
% folder_experiment_id='md53d_2016-01-14_19-18-01/'
% folder_to_write= '~/res/oe/'
% shanks=1:4
addpath('~/Dropbox/depends/oe/')
if nargin<6,dotest=0;end
if nargin<5,dowait=1,end
if nargin<4,shanks=1:4,end
if nargin<3,folder_to_write=['~/usb/res/oe/'],end
if isempty(path_to_data),path_to_data='~/data/oe/',end
mkdir([folder_to_write folder_experiment_id 'phy'])
% do shank by shank
for ishank=shanks
    map_cambr=oeprobe_cambr(ishank,'mmy1');
    map= oeprobe_intan2sane(map_cambr);
    if dotest
        map_cambr=oeprobe_cambr(ishank,'test');
        map= oeprobe_intan2sane(map_cambr,1);
        
    end
    oe2dat([path_to_data folder_experiment_id],[folder_to_write folder_experiment_id 'phy/shank' ns(ishank)],map)
    command=['export PATH="~/miniconda/bin:$PATH"; source activate phy;' ...
        'cd ' folder_to_write folder_experiment_id 'phy/shank' ns(ishank) '; phy spikesort --overwrite 100_raw.prm  '];
    if ~dowait,command=[command ' &'];end
    system(command)
end
