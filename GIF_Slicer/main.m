

% mydir=uigetdir('./','??????');
mydir='GFI';
if mydir(end)~='/'
 mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.gif']);  %???

n=length(DIRS);
for i=1:n
 if ~DIRS(i).isdir
%   DIRS(i).name  %%%%%%%?????????????????
  Gif_Slicer([mydir,DIRS(i).name],DIRS(i).name);
 end
end