function [xmitte,ymitte] = TrackingYellowPoint(frames,End,SearchSize,R,G,B)
global g
g=1;
Img=frames(:,:,:,g);
figure(1)
imshow(Img)
title('Bitte klicken gelben Punkt');
[x,y]=ginput(1);
close
x=round(x);
y=round(y);
a=1;
xr=[];
yr=[];

for i=y-SearchSize:y+SearchSize
        for j=x-SearchSize:x+SearchSize
            if((Img(i,j,1)>R&Img(i,j,2)>G&Img(i,j,3)<B)==1)
            xr(a)=j;
            yr(a)=i;
            a=a+1;
            end
        end
end
    [xmitte(g),ymitte(g)]=Searchcentre(xr,yr);

for k=2:End
    Img=frames(:,:,:,g);
    clear xr yr a
    x=round(xmitte(g-1));
    y=round(ymitte(g-1));
    a=1;
    xr=[];
    yr=[];
    for i=y-SearchSize:y+SearchSize
        for j=x-SearchSize:x+SearchSize
            if((Img(i,j,1)>R&Img(i,j,2)>G&Img(i,j,3)<B)==1)
            xr(a)=j;
            yr(a)=i;
            a=a+1;
            end
        end
    end
    [xmitte(g),ymitte(g)]=Searchcentre(xr,yr);
end
end
