function [] = Gif_Slicer(filename,foldername)
%GIF_SLICER Slice GIF video into several frames
%   Detailed explanation goes here

info = imfinfo(filename);%?????????????
W = info.Width;
H = info.Height;
W = W(1);
H = H(1);
len = length(info);
mkdir(foldername);
% figure('NumberTitle', 'off', 'ToolBar', 'none', 'Menu', 'none');
% pos = get(gcf, 'position');
% set(gcf, 'position', [pos(1) pos(2) W H]);
% set(gca, 'position', [0 0 1 1]);
% hold on;
for i = 1 : len
    str=sprintf('photo%d.jpg',i);
    str=[foldername,'/',str];
    [Ii, map] = imread(filename, 'frames', i); 
    imwrite(Ii,map,str,'jpg');
%     F(:, i) = im2frame(Ii, map);  
end
% movie(F, 20);
% close;


end

