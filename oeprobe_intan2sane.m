function Out=oeprobe_intan2sane(in,dotest)
% Input  subset of channels in Cambridge order
% Output subset of channels in Intan     order
%% side of intan 64-ch headstage with chip (black mark, top in pinout picture)
% (starting with "O" in omnetics, so right side in picture)
if nargin<1,in=1:64;end
if nargin<2,dotest=0;end
if dotest,    Out=1:64;Out=Out(in);return,end
% b=[];for i=17:2:47
%     b=[b i+1 i ];
% end
b=16:47;
b=fliplr(b);
% plot(b),b
%%

%% flat side of intan headstage (bottom in pinout picture) 
% (starting with "O" in omnetics, so left in picture)
% % % % a=[];for i=49:2:63
% % % %     a=[a i-1 i];
% % % % end
% % % % for i=1:2:15
% % % %     a=[a i-1 i];
% % % % end
% a=[];for i=49:2:63
%     a=[a i-1 i];
% end
% for i=1:2:15
%     a=[a i-1 i];
% end
a=[48:63 0:15];


a=fliplr(a);
% plot(a),a

%% b (top of picture, black spot side of headstage)
% b/c shank 1 is connected

% looking from top down top (where ribbons connect) first shank is on left,
% connected to flat side of headstage
% So flat goes first (variable a)
out=[ a  b] + 1; % +1 bc of zero-start indexing in pinout picture

Out=out(in);
