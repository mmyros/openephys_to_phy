function MAP=oeprobe_cambr(Shank,probename)
%% oeprobe_cambr(shank,probename[opt])
% You HAVE to change this file to get a sane layout of probe sites! 
% Refer to site map - it's different for every probe
% in=1:16;
if nargin<2
    probename='mmy1';
end
if nargin<1
    Shank=1:4;
end
% MAP=[11 3 15 5 13 4 16 10 2 1 14 12 9 7 6 4 ...
%     25 28 26 32 28 20 29 22 27 23 30 24 31 21 17 19 ...
%     39 48 40 34 38 46 35 44 37 41 36 42 33 43 47 45 ...
%     53 61 49 59 51 62 50 56 64 63 52 54 55 57 58 60 ];
%%
MAP=[];
for shank=Shank
    switch probename
        case 'test'
            switch shank
                case 1, map=1 :16;
                case 2, map=17:32;
                case 3, map=33:48;
                case 4, map=49:64;
            end
        case 'mmy1'
            switch shank
                case 4,
                    map=[ ...
                        61	59	62	56	63	54	57	60 ; ...
                        53	49	51	50	64	52	55	58 ; ...
                        ] ;
                case 3
                    map=[ ...
                        48	34	46	44	41	42	43	45 ; ...
                        39	40	38	35	37	36	33	47 ; ...
                        ] ;
                    
                case 2
                    map=[ 18	32	20	22	23	24	21	19 ;...
                          25	26	28	29	27	30	31	17 ; ...
                        ] ;
                    
                case 1
                    map=[ 3 	5	4	10	1	12	7	6 ;...
                          11	15	13	16	2	14	9	8 ;...
                        ] ;
            end
        otherwise
            disp('No such probe silly! Create your own map please')
    end
    if ~strcmp(probename,'test')
        %% stagger rows of electrodes (columns of map)
        Map=[];
        for irow=1:8
            Map=[Map [map(2,irow) map(1,irow)]];
        end
    else
        Map=map;
    end
    
    MAP=[MAP Map];
end
