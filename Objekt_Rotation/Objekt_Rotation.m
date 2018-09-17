clear all
%% Figur Einstellung
FigurEinstellung

%% Parameter eingeben
h=15.4;   % Die Höhe der Scheibe
H=545;    % Der Abstand von der Platte zum Sensor der Kamera für Brennweite 50mm
HV=h/H;   % Das Verhältnis h/H zur Verminderung des optischen Fehlers     
U=1/5.95; % Verhältnis der Umrechung von Pixel zu mm
xm=1920/2; ym=1080/2; % Mittelpunkt des Bilds

%% Video herunterladen 
FileName='Video\C0349.mp4';  % den Namen des Videos eingeben
video=VideoReader(FileName); % read Video
NrFrames=video.NumberOfFrames; 
End=NrFrames;                % Die Zahl von Frames
frames=(read(video,[1 End]));

%% Gaussi Filter
sigma=1.6;
gausFilter=fspecial('gaussian',[5,5],sigma);
for i=1:End
    frames(:,:,:,i)=imfilter(frames(:,:,:,i),gausFilter,'replicate');
end

%% Winkel der Schleifenrichtung bestimmen
firstframe=frames(:,:,:,1);
[w] = schRichtung(firstframe); 

%% rote und gelbe Trackingpunkte erhalten
global r g
SearchSize=20;
Rr=100;Gr=150;Br=150;    %RGB-Wert der roten Farbe (R>,G<,B<)
                         % Wenn mit diesen Werten es nicht geht, laufen Sie
                         % Rot_ermitteln.m zur Bestimmung des RGB-Wertes.
[xmitte_r,ymitte_r]=TrackingRedPoint(frames,End,SearchSize,Rr,Gr,Br);
Ry=100;Gy=100;By=130;    % RGB-Wert der gelben Farbe (R>,G>,B<)
                         % Wenn mit diesen Werten es nicht geht, laufen Sie
                         % Gelb_ermitteln.m zur Bestimmung des RGB-Wertes.
[xmitte_y,ymitte_y]=TrackingYellowPoint(frames,End,SearchSize,Ry,Gy,By);

%% den Winkel berechnen und (zeigen)
for k=1:End
    b(k)=Drehungwinkel(xmitte_r(k),ymitte_r(k),xmitte_y(k),ymitte_y(k));
%     figure(1)
%     imshow(frames(:,:,:,k));
%     hold all
%     plot(xmitte_r(k),ymitte_r(k),'rx','linewidt',3,'markersize',15);
%     plot(xmitte_y(k),ymitte_y(k),'yx','linewidt',3,'markersize',15);
%     title(strcat('frame #',num2str(k)));
%     text(1700,900,strcat('ß=',num2str(b(k)),'°'),'FontSize',30,'Color','green');
end

%% Geschwindigkeit in y-Richtung berechnen
Xr=(1-HV)*(xmitte_r-xm)+xm;
Yr=(1-HV)*(ymitte_r-ym)+ym;
X=U*(Yr-Yr(1)); Y=U*(Xr-Xr(1));
Fps=500; 
dt=1/Fps;
Vx=diff(X)/dt/1000; 
Vy=diff(Y)/dt/1000; 
FVx=medfilt1(Vx,8); 
FVy=medfilt1(Vy,8);
for ka=1:End-1      
    if FVy(ka)>0.1 
        break
    end
end
for ke=Vp:End-1
    if FVy(ke)<0.05 
        break
    end
end
Ap=ka-5;     
Ep=ke+5;

%%  die Geschwindigkeit und den Winkel plot
Fps=500; % Frame Rate der Aufzeichnung
dt=1/Fps;
t=0:dt:(Ep-Ap)*dt; 
figure(1)
suptitle(strcat('Schleifrichtung:',num2str(w),'°'));
subplot(2,1,1)
plot(t,Vy(Ap:Ep),'b')
hold on
plot(t,FVy(Ap:Ep),'r');
hold on
legend('Ohne Filter','Mit Filter')
xlabel('t(s)')
ylabel('V_y(m/s)')
title('Geschwindigkeit in y-Richtung')
subplot(2,1,2)
plot(t,b(Ap:Ep),'r');
xlabel('t(s)')
ylabel('\phi(°)')
title('Die Änderung des Drehwinkels im Lauf der Zeit')
saveas(figure(1),strcat('Drehwinkel_',FileName(7:11),'.fig'));