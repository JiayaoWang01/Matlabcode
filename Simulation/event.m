function [value,isterminal,direction] = event(t,x)
 value=sqrt(x(3)^2+x(4)^2)-0.0001;
 isterminal=1;
 direction=0;
end