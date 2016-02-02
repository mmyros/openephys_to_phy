function [info , Data]= oe2dat(varargin)
% input 3 = map
% 
% Converts Open Ephys data to KWIK format
%
%   by Josh Siegle, November 2013
%
%  info = convert_open_ephys_to_kwik(input_directory, output_directory)
%
%  input_directory: folder with Open Ephys data
%  output_directory (optional): folder to save the KWIK files
%    - defaults to using the input_directory
%

% KWIK file contains:
% - metadata
% - spikes times
% - clusters
% - recording for each spike time
% - probe-related information
% - information about channels
% - information about cluster groups
% - events, event types
% - aesthetic information, user data, application data
%
% KWX file contains:
% - spike features, masks, waveforms
%
% KWD file contains:
% - raw/filtered recordings
%
% all files contain a kwik_version attribute (currently equal to 2)
%
% PRM = processing parameters
% PRB = probe parameters

input_directory = varargin{1};

if (nargin == 1)
    output_directory = input_directory;
else
    output_directory = varargin{2};

end

mkdir(output_directory)


copyfile('~/Dropbox/spikesort/phy/probes/cambridge/cambridge_1shank_mmy1.prb',output_directory)



info = get_session_info(input_directory);

%%

% 1. create the KWIK file
kwikfile = [get_full_path(output_directory) filesep ...
        'session_info.kwik'];
    
disp(kwikfile)
    
info.kwikfile = kwikfile;
    
% if numel(dir([kwikfile]))
%     delete(kwikfile)
% end
% 
% fid = H5F.create(kwikfile);
% h5writeatt(kwikfile, '/', 'kwik_version', '2')


%%

% 2. create the KWD files

processor_index = 0;

for processor = find(~cellfun(@isempty,info.processors(:,3))')
    
    if length(varargin)<3
        recorded_channels = info.processors{processor, 3};
    else
        recorded_channels = varargin{3};
    end
    
    if length(recorded_channels) > 0
    
        kwdfile = [get_full_path(output_directory) filesep ...
            int2str(info.processors{processor,1}) '_raw.kwd'];
% 
%         if numel(dir([kwdfile]))
%             delete(kwdfile)
%         end
        %% Preallocate
        filename_in = [input_directory filesep ...
            int2str(info.processors{processor, 1}) ...
            '_CH' int2str(1) '.continuous'];
        [data] = load_open_ephys_data_faster(filename_in);
        ldata=length(data);
        clear data
        Data=zeros(length(recorded_channels), ldata,'int16');
        %% Loop over channels
        indch=0;
        for ch = recorded_channels
            indch=indch+1;
            filename_in = [input_directory filesep ...
                int2str(info.processors{processor, 1}) ...
                '_CH' int2str(ch) '.continuous'];
            [data] = load_open_ephys_data_faster(filename_in);
            
%             ch=ch-min(recorded_channels)+1;
            
            Data(indch,:)=(data);

            clear data
        end
        
%         Data=int16(Data);
        %%
        fid=fopen([output_directory '/100_raw.dat'],'w');
        fwrite(fid,Data,'int16')
%         clf,fid=fopen([output_directory '/100_raw.dat']);z=fread(fid,inf,'int16');whos z;plot(z(1:2e4))
    end
end

%%

% 3. create the KWX file

kwxfile = [get_full_path(output_directory) filesep ...
    'spikes.kwx'];

info.kwxfile = kwxfile;

if numel(dir([kwxfile]))
    delete(kwxfile)
end

for X = 1:size(info.electrodes,1)
    
    filename_string = info.electrodes{X, 1};
    channels = info.electrodes{X, 2};
    
    internal_path = ['/channel_groups/' int2str(X-1)];
    
    for ch = 1:length(channels)
       
        h5create(kwikfile, [internal_path '/' int2str(ch-1) '/kwd_index'], [1 1], 'Datatype', 'int16');
        h5write(kwikfile, [internal_path '/' int2str(ch-1) '/kwd_index'], int16(channels(ch)));
    end
    
    h5writeatt(kwikfile, internal_path, 'name', filename_string);
    
    filename_string(find(filename_string == ' ')) = [ ];
    
    filename_in = [input_directory filesep ...
        filename_string '.spikes'];
    
    [data, timestamps, info_spikes] = load_open_ephys_data(filename_in);
    
     h5create(kwxfile, [internal_path '/waveforms_filtered'], ...
                 [size(data)], ...
                 'Datatype', 'int16', ...
                 'ChunkSize',[1 size(data,2) size(data,3)]);
             
     rescaled_waveforms = data.*repmat(reshape(info_spikes.gain, ...
                      [size(info_spikes.gain,1) 1 size(info_spikes.gain,2)]), ...
                      [1 size(data,2) 1])./1000;
    
     h5write(kwxfile,[internal_path '/waveforms_filtered'], ...
             int16(rescaled_waveforms));
    
end
% movefile([output_directory '/100_raw.kwd'],[output_directory '/100_raw.dat'])
