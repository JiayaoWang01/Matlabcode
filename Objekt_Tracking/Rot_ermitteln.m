SS=15;
Img=frames(:,:,:,k);
imshow(Img)
title('Bitte klicken roten Punkt');
[x,y]=ginput(1);
x=round(x);
y=round(y);
fprintf('Bitte nach diesen Werten den neuen RGB-Wert')
fprintf('R')
Img(y-SS:y+SS,x-SS:x+SS,1)
fprintf('G')
Img(y-SS:y+SS,x-SS:x+SS,2)
fprintf('B')
Img(y-SS:y+SS,x-SS:x+SS,3)