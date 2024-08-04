close all
clear all
clc
%%message bits

MB=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 1 1 1 1 0 0 0 1 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 1 ];

%%Channel Symbols

CS=[3 1 4 0 6 5 2 0 0 0 0 0 0 0 0 1 0 6 5 6 3 6 2 3 7 4 1 0 5 4 0 3 2 3 2 1 3 1 4 0 6 5 2 0 1 3 4 5 3 7 3 0 6 3 1 2 1 6 4 1 4 5 4 0 2 3 5 1 3 7 5 5 3 1 4 0 6 5 2 ] ;
%%
sintablen = 7680;
SINTAB = sin(2*pi*(0:sintablen-1)./sintablen);
fs = 48000;
%%
F_required = 1200;
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1200Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = 1200+(6.25);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1206Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = 1200+(12.5);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1212Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = 1200+(18.75);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1218Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = 1200+(25);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1225Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = 1200+(31.25);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1231Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = 1200+(37.5);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1237Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = 1200+(43.75);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:7680
    sin1243Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
n=length(CS);
Xcpfsk=[];
for z=1:n
    rep=1;
  %  while CS(z)==CS(z+1),
        
        %Xcpfsk=[Xcpfsk,Xcpfsk((end-32778):end)];
 rep=rep+1;
    %end
         if(CS(z)==0)
        Xcpfsk=[Xcpfsk,sin1200Hz(1:7680)];
         z=z+1;
         elseif(CS(z)==1)
        Xcpfsk=[Xcpfsk,sin1206Hz(1:7680)];
         z=z+1;
         elseif(CS(z)==2)
        Xcpfsk=[Xcpfsk,sin1212Hz(1:7680)];
         z=z+1;
          elseif(CS(z)==3)
        Xcpfsk=[Xcpfsk,sin1218Hz(1:7680)];
         z=z+1;
         elseif(CS(z)==4)
        Xcpfsk=[Xcpfsk,sin1225Hz(1:7680)];
         z=z+1;
         elseif(CS(z)==5)
        Xcpfsk=[Xcpfsk,sin1231Hz(1:7680)];
         z=z+1;
         elseif(CS(z)==6)
        Xcpfsk=[Xcpfsk,sin1237Hz(1:7680)];
         z=z+1;
           elseif(CS(z)==7)
        Xcpfsk=[Xcpfsk,sin1243Hz(1:7680)];
         z=z+1;
    else
          
        disp('error');
        return
       
    end
    end
%% Manually execute this command in the command window on an even minute
% to successfully transmit a WSPR message
% sound(Xcpfsk,48000)  
