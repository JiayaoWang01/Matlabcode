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
FileName='Video\C0384.mp4';  % den Namen des Videos eingeben
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

%% Trackingpunkte erhalten
global k
SearchSize=30;     % halbe Seitenlange der Suchgröße   
R=100;G=200;B=200; % RGB-Wert der roten Punkt (normal>100,<200,<200;
                   % dunkel:>100,>230,<230;hell:>150,<150,<150).
                   % Wenn mit diesen Werten es nicht geht, laufen Sie
                   % Rot_ermitteln.m zur Bestimmung des RGB-Wertes. 
[xmitte,ymitte]=TrackingRedPoint(frames,End,SearchSize,R,G,B);

%% optische Fehler eliminieren
Xr=(1-HV)*(xmitte-xm)+xm;
Yr=(1-HV)*(ymitte-ym)+ym;

%% Umrechnung der Einheit und Koordinatentransformation
X=U*(Yr-Yr(1)); Y=U*(Xr-Xr(1));

%% Geschwindigkeit und Beschleunigung berechnen
Fps=500; % Frame Rate der Aufzeichnung
dt=1/Fps;
Vx=diff(X)/dt/1000; %Geschwindigkeit in x-Richtung
Vy=diff(Y)/dt/1000; %Geschwindigkeit in y-Richtung
Ax=diff(Vx)/dt;     %Beschleunigung in x-Richtung
Ay=diff(Vy)/dt;     %Beschleunigung in y-Richtung

%% Median-Filter
FVx=medfilt1(Vx,8); 
FVy=medfilt1(Vy,8);
FAx=medfilt1(Ax,16);
FAy=medfilt1(Ay,16);

%% ungültige Punkte entfernen und Anfangsgeschwindigkeit suchen 
[Vmax,Vp]=max(Vy);  
V0=roundn(Vmax,-2); % V0: Anfangsgeschwindigkeit, Vp: Index von V0
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
Ap=ka-5;           % Ap: gültige Anfangspunkt
Ep=ke+5;           % Ep: gültige Endpunkt

%% Trajektorie zeichnen
figure(1)
imshow(frames(:,:,:,End));
hold all
plot(xmitte(Ap:Ep),ymitte(Ap:Ep),'r.','Markersize',15);
title('Trajektorie');
text(1700,180,strcat('a=',num2str(w),'°'),'FontSize',30,'Color','red');
saveas(figure(1),strcat('Figure\Tracking_',num2str(w),FileName(7:11),'.fig'));

%% Gleitpfad rekonstruieren
s=1;              % s=1: den kompletten Gleitpfad zeigen;  
                  % s=2: den Gleitpfad ohne Beschleunigungvorgang zeigen (zum Vergleich mit Simulation)
figure(2)
switch (s)
    case 1
        plot(X(Ap:Ep),Y(Ap:Ep),'r.','MarkerSize',5);
    case 2
        plot(X(Ap:Ep)-x(Ap),Y(Ap:Ep)-Y(Ap),'r.','MarkerSize',5);
end
axis([-150 150 0 300])
xlabel('x(mm)')
ylabel('y(mm)')
title(strcat('Tatsächlicher Gleitpfad','(a=',num2str(w),'°)'));
saveas(figure(2),strcat('Figure\RealTracking_',num2str(w),FileName(7:11),'.fig'));

%% Geschwindigkeitdiagramm
t=0:dt:(Ep-Ap)*dt;      % Zeitdauer des Bewegungsverlaufs
figure(3)
suptitle(strcat('Schleifrichtung:',num2str(w),'°, Anfangsgeschwindigkeit:',...
         num2str(V0),'m/s'));
subplot(1,2,1)
plot(t,Vx(Ap:Ep),'b');
hold on 
plot(t,FVx(Ap:Ep),'r');
legend('Ohne Filter','Mit Filter')
xlabel('t(s)')
ylabel('V_x(m/s)')
title('Geschwindigkeit in x-Richtung')
subplot(1,2,2)
plot(t,Vy(Ap:Ep),'b')
hold on
plot(t,FVy(Ap:Ep),'r');
hold on
legend('Ohne Filter','Mit Filter')
xlabel('t(s)')
ylabel('V_y(m/s)')
title('Geschwindigkeit in y-Richtung')
% Reibwert berechnen, wenn alpha 0° oder 90° ist.
if abs(w)<=1||abs(w)>=89
   xp=(Vp-Ap)*dt:dt:(ke-Ap)*dt;
   yp=FVy(Vp:ke);
   P=polyfit(xp,yp,1);              % Linear Fitting
   mu=roundn(-P(1)/9.81,-3);        % mu: Reibwert
   aa=roundn(P(1),-2);
   bb=roundn(P(2),-2);
   ypp=polyval(P,t);
   plot(t,ypp,'k');
   text(3*t(5),ypp(5),strcat('y=',num2str(aa),'x+',num2str(bb),' (µ=',num2str(mu),')'));
end
saveas(figure(3),strcat('Figure\Vimg_',num2str(w),FileName(7:11),'.fig'));

%%Daten speichern [(xmitte,ymitte):Tracking Punkte; (X,Y):Gleitpfade Punkte; (Vx,Vy): Geschwindigkeit
%                  (FVx,Fvy): Gefilterte Geschwindigkeit]
save(strcat('Daten\',FileName(7:11),'.mat'),...
    'HV','w','xmitte','ymitte','X','Y','Vx','Vy','FVx','FVy','t','Ap','Ep','Vp','V0');