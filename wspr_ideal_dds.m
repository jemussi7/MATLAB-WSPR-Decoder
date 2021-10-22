%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Weak Signal Propagation Reporter (WSPR) Transmit Code        %
%      Refernece credit to Dr. Jonathon Y. Cheah (NZ0C)          %
%                   for the use of this code                     %
%           Output is audioband cp 4fsk  WSPR  message which can be fed to RF carrier modulation hardware or software            %
%               for transmission over the air                                                 %
%                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc
%%WSPR message channel symbols
%%

% user entries         ================== % call must have 6 letter 
                        call = 'SM1DE '     % spaces for standard HAM
                         loc = 'JO01'        % Radio callsign.
                        power = 30
%                      ==================



%
% process various callsign types  
if (chr_normf(call(3))>9)

        
        call(6)=call(5);
        call(5)=call(4);
        call(4)=call(3);
        call(3)=call(2);
        call(2)=call(1);
        call(1)=' ';
end

call=call(1:6);
%
% pack callsign
%n1=chr_normf(call(1));
%n1=n1*36+chr_normf(call(2));
%n1=n1*10+chr_normf(call(3));
%n1=n1*27+chr_normf(call(4))-10;
%n1=n1*27+chr_normf(call(5))-10;
%n1=n1*27+chr_normf(call(6))-10;
cc=36;
if (call(1)>='0' && call(1)<='9') cc=call(1)-'0';
end
if (call(1)>='A' && call(1)<='Z') cc=call(1)-'A'+10;
end
if (call(1)>='a' && call(1)<='z') cc=call(1)-'a'+10;
end
if (call(1)==' ') cc=36;
end
n1=cc;

cc=36;
if (call(2)>='0' && call(2)<='9') cc=call(2)-'0';
end
if (call(2)>='A' && call(2)<='Z') cc=call(2)-'A'+10;
end
if (call(2)>='a' && call(2)<='z') cc=call(2)-'a'+10;
end
if (call(2)==' ') cc=36;
end
n1=n1*36+cc;
cc=36;
if (call(3)>='0' && call(3)<='9') cc=call(3)-'0';
end
if (call(3)>='A' && call(3)<='Z') cc=call(3)-'A'+10;
end
if (call(3)>='a' && call(3)<='z') cc=call(3)-'a'+10;
end
if (call(3)==' ') cc=36;
end
n1=n1*10+cc;

cc=36;
if (call(4)>='0' && call(4)<='9') cc=call(4)-'0';
end
if (call(4)>='A' && call(4)<='Z') cc=call(4)-'A'+10;
end
if (call(4)>='a' && call(4)<='z') cc=call(4)-'a'+10;
end
if (call(4)==' ') cc=36;
end
n1=n1*27+cc-10;

cc=36;
if (call(5)>='0' && call(5)<='9') cc=call(5)-'0';
end
if (call(5)>='A' && call(5)<='Z') cc=call(5)-'A'+10;
end
if (call(5)>='a' && call(5)<='z') cc=call(5)-'a'+10;
end
if (call(5)==' ') cc=36;
end
n1=n1*27+cc-10;

cc=36;
if (call(6)>='0' && call(6)<='9') cc=call(6)-'0';
end
if (call(6)>='A' && call(6)<='Z') cc=call(6)-'A'+10;
end
if (call(6)>='a' && call(6)<='z') cc=call(6)-'a'+10;
end
if (call(6)==' ') cc=36;
end
n1=n1*27+cc-10;

%
% pack locator 
%m1=179-10*(chr_normf(loc(1))-10)-chr_normf(loc(3));
%m1=m1*180+10*(chr_normf(loc(2))-10)+chr_normf(loc(4));
cc=36;
if (loc(1)>='0' && loc(1)<='9') cc=loc(1)-'0';
end
if (loc(1)>='A' && loc(1)<='Z') cc=loc(1)-'A'+10;
end
if (loc(1)>='a' && loc(1)<='z') cc=loc(1)-'a'+10;
end
if (loc(1)==' ') cc=36;
end

m1=179-10*(cc-10)

cc=36;
if (loc(3)>='0' && loc(3)<='9') cc=loc(3)-'0';
end
if (loc(3)>='A' && loc(3)<='Z') cc=loc(3)-'A'+10;
end
if (loc(3)>='a' && loc(3)<='z') cc=loc(3)-'a'+10;
end
if (loc(3)==' ') cc=36;
end

m1=m1-cc;

cc=36;
if (loc(2)>='0' && loc(2)<='9') cc=loc(2)-'0';
end
if (loc(2)>='A' && loc(2)<='Z') cc=loc(2)-'A'+10;
end
if (loc(2)>='a' && loc(2)<='z') cc=loc(2)-'a'+10;
end
if (loc(2)==' ') cc=36;
end
m1=m1*180+10*(cc-10);

cc=36;
if (loc(4)>='0' && loc(4)<='9') cc=loc(4)-'0';
end
if (loc(4)>='A' && loc(4)<='Z') cc=loc(4)-'A'+10;
end
if (loc(4)>='a' && loc(4)<='z') cc=loc(4)-'a'+10;
end
if (loc(4)==' ') cc=36;
end

m1=m1+cc;

%
% pack power dBm
m1=m1*128+power+64;

c(1)=bitsll(uint32(n1),4);
c(1)=c(1)+ bitand(15,bitsrl(uint32(m1),18));
c(2)=bitsll(uint32(m1),6);

%Turn c(1) and C(2) into HEX characters
H1=dec2hex(c(1));
H2=dec2hex(c(2));
if numel(H2)<6
    H2(2:6)=H2;
    H2(1)='0';
   h=strcat(H1(1:8),H2(1:6));
end
if numel(H2)==6
   h=strcat(H1(1:8),H2);
end
if numel(H2)>6
    h=strcat(H1(1:8),H2(2:7));
end

disp('Source-encoded message')
disp(h)

%
%To convolve with Polynomials
x{1}=dec2bin(hex2dec('F2D05351'));
x{2}=dec2bin(hex2dec('E4613C47'));
h= dec2bin(hex2dec(h));
m=length(x{1});
n=length(h);

%
%allocate memory
X(1,:)=[x{1},zeros(1,m)]; 
X(2,:)=[x{2},zeros(1,m)];
H=[h,zeros(1,(n+m))]; 

% create a temporary m-length register TH
% for h data stream
TH=zeros(1,m);

% create 2 output bit registers
Y(1,:)=zeros(1,(n+m));
Y(2,:)=zeros(1,(n+m));

% shifting H into TH
for i=1:m+n
      TH=[TH(2:end) 0];
    if str2num(H(i))>0
        TH(m)=1;
    else
        TH(m)=0;
    end
    
% got register TH with h a bit at a time
% AND TH with polynomials
  for k=1:2
    for j=1:m      
% sum the AND value and keeps count
         Y(k,i)=Y(k,i)+sum(str2num(X(k,j))& TH(j));
    end
% parity bit is 0 if the sum is even.
    Y(k,i)=mod(Y(k,i),2);
  end
end

% interlace the 2 polynomial outputs.
YI=zeros(1,2*(m+n));
YI(1:2:end)=Y(1,:);
YI(2:2:end)=Y(2,:);

%%%    for display purposes only. can be deleted %%          
disp(' ')                                         %
disp('FEC symbols in Hex')                        %
%This is just for the sake of a nice display      %
% needs a lot of twists and turns                 %
%A=reshape(YI,8,length(YI)/8);                     %
                                        %
%                                                %%

%interleave
sym=zeros(1,168); 
P=1;
I=0;
while P < 162
        J=bin2dec(fliplr(bin(fi(I,0,8,0))));
        if J<162
            sym(J+1)=YI(P);
            P=P+1;
        end
    I=I+1;
end

disp(' ')
disp('Interleave data')
SYM=reshape(sym,8,length(sym)/8)';
disp(SYM)

% add sync bits
  sync=textread('sync.dat','%u');

% Channel symbol with sync added.
smb=sync'+2*sym;

disp(' ') 
disp('Channel symbols')
ch=reshape(smb,8,length(smb)/8)';
disp(ch)

% The channel symbols in output
% This file is ready for wspr beacon implementation
fid=fopen('signal.dat','w');
fprintf(fid,'%i\n', smb);
fclose(fid);
     x=smb;         %WSPR message channel symbols
%%
%sin1500Hz=ideal_dds(48000,8,8,1500,0,32768);
%sin1501Hz=ideal_dds(48000,8,8,(1500+(12000/8192)),0,32768);
%sin1502Hz=ideal_dds(48000,8,8,(1500+(24000/8192)),0,32768);
%sin1504Hz=ideal_dds(48000,8,8,(1500+(36000/8192)),0,32768);

%%
sintablen = 32768;
SINTAB = sin(2*pi*(0:sintablen-1)./sintablen);
fs = 48000;
%%
F_required = 1500;
index = 1; step = (F_required/fs)*sintablen;
for i = 1:32768
    sin1500Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = 1500+(12000/8192);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:32768
    sin1501Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = 1500+(24000/8192);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:32768
    sin1502Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = 1500+(36000/8192);
index = 1; step = (F_required/fs)*sintablen;
for i = 1:32768
    sin1504Hz(i) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
x=x(1:162);
n=length(x);
Xcpfsk=[];
for z=1:n
    rep=1;
  %  while x(z)==x(z+1),
        
        %Xcpfsk=[Xcpfsk,Xcpfsk((end-32778):end)];
 rep=rep+1;
    %end
         if(x(z)==0)
        Xcpfsk=[Xcpfsk,sin1500Hz(1:32768)];
         z=z+1;
         elseif(x(z)==1)
        Xcpfsk=[Xcpfsk,sin1501Hz(1:32768)];
         z=z+1;
         elseif(x(z)==2)
        Xcpfsk=[Xcpfsk,sin1502Hz(1:32768)];
         z=z+1;
          elseif(x(z)==3)
        Xcpfsk=[Xcpfsk,sin1504Hz(1:32768)];
         z=z+1;
           
    else
          
        disp('error');
        return
       
    end
end
    disp('press enter to continue')
    pause
%%
%%
t = timer('TimerFcn', 'stat=false; disp(''Timer Elapsed!'')',... 
                 'StartDelay',360);
start(t)

stat=true;
while(stat==true)
  disp('.')
  pause(1)

clk = clock;

    if clk(6)<=2&&mod(clk(5),2)==0
    disp('Tx!')
    sound(Xcpfsk,48000)
    elseif mod(clk(5),2)==1
    clk = clock;
     disp('waiting to transmit')
    end
end
%% Manually execute this command in the command window on an even minute
% to successfully transmit a WSPR message
% sound(Xcpfsk,48000)  