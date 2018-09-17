t0=0;tf=10; %Zeitdauer
v0=1.49;    %Anfangsgeschwindigkeit
options = odeset('Event',@event);  
[t1,x1,te1,xe1]=ode45(@BGL,[t0,tf],[0,0,0,v0],options);   %BGL:  Standard Kraftgesetz
[t2,x2,te2,xe2]=ode45(@BGL2,[t0,tf],[0,0,0,v0],options);  %BGL2: Erweitertes Kraftgesetz
figure(1)
plot(x1(:,1)*1000,x1(:,2)*1000,'b.','MarkerSize',5);
hold on 
plot(x1(:,1)*1000,x1(:,2)*1000,'b.','MarkerSize',5);
axis([-150 150 0 300])


