close all
clear all
clc
%%
wsprcvd=audiorecorder(12000,8,1);

%%

    %zz=120
            ii=1;
            while ii<120
              disp('.')
              pause(1)
            
                clk=clock;

                %if clk(6)<=1&&mod(clk(5),2)==0
                 if clk(6)>=57&&mod(clk(5),2)==1
                disp('Rx!')
                recordblocking(wsprcvd,115)
                ii=120;
                elseif mod(clk(5),2)==1
                    ii=ii+1
                clk = clock;
                disp('waiting to receive')
                end
            end
            
            clip=getaudiodata(wsprcvd);
            noisest=clip(1:8192);
%% Trim audio clip to correct length

            [xr,locr]=findpeaks(clip);
            %meanp = mean(xr);
            [row,colmn]=find(xr>(0.5));
            begin=locr(row(end))-1327103;
            clip=clip(begin:locr(row(end)));
             clipcp=clip;
             
             %%
              
for jj=2:162
    		start=((jj-1)*8192+1);
	  	fin= (jj*8192);

noisest(start:fin)=noisest(1:8192);
end
clipF=fft(clip);
noiseF=fft(noisest)*2/1327104;
clipF=clipF-noisest;
clip=ifft(clipF);

            plot(abs(clip))
%)%
pad=(ones(1,1327104-length(clip)))*mean(clip);
clip=clip';
clip=[pad clip];

%f4=(1500+(36000/8192))*(8192/12000)
%f2=(1500+(12000/8192))*(8192/12000)
%f1=1500*(8192/12000)
%f3=(1500+(12000/8192))*(8192/12000)

%%
sintablen = 8192;
SINTAB = cos(2*pi*(0:sintablen-1)./sintablen);
fs = 12000;

%%
Fcon=abs(fft(clip));
Fcon=resample(Fcon,1,162);
testpat=[zeros(1,1024) 1 1 1 1 zeros(1,7164)];

Fcand=xcorr(Fcon,testpat);
Fcand=Fcand(8000:8400);

[xrr,locrr]=findpeaks(Fcand);
[xrrmax locrrmax]=max(xrr);
Fcandmax=locrr(locrrmax)-192+1024;
Fcandmax=Fcandmax-1;
Fcandmax=Fcandmax*12000/8192;


%%
F_required = Fcandmax;
index = 1; step = (F_required/fs)*sintablen;
for iii = 1:8192
     if index<0.5
        index=1;
    end
    sin1500Hz(iii) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end
%%
F_required = Fcandmax+(12000/12);
index = 1; step = (F_required/fs)*sintablen;
for iii = 1:8192
    if index<0.5
        index=1;
    end
    sin1501Hz(iii) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = Fcandmax+(24000/8192);
index = 1; step = (F_required/fs)*sintablen;
for iii = 1:8192
     if index<0.5
        index=1;
    end
    sin1502Hz(iii) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end

%%
F_required = Fcandmax+(36000/8192);
index = 1; step = (F_required/fs)*sintablen;
for iii = 1:8192
     if index<0.5
        index=1;
    end
    sin1504Hz(iii) = SINTAB(round(index));
    index = index+step;
    if index>sintablen
        index = index-sintablen;
    end
end


FSK=clip;
L=162
FS=length(FSK)/L
%FS=1001
%tt=0:1/8192:1-1/8192;
%sym0=cos(2*pi*f1*tt);
%sym1=cos(2*pi*f2*tt);
%sym2=cos(2*pi*f3*tt);
%sym3=cos(2*pi*f4*tt);


    symbol0=sin1500Hz;
    symbol1=sin1501Hz;
    symbol2=sin1502Hz;
    symbol3=sin1504Hz;
    
    %%
   
    %WN=Fcandmax/6000+0.1;
    
%BP1=fir1(121,WN,'low'); 
%[n,fo,ao,w] = firpmord([1500 1800],[1 0],[0.001 0.01],8192);
%b = firpm(n,fo,ao,w);

Fs = 8192; Wo = (Fcandmax*8192/12000)/(Fs/2);  BW = 10/(Fs/2);
       [b,a] = iirpeak(Wo,BW);
   %   fvtool(b,a);
%clip=filter(b,a,clip);
    
%%
            xcorr0=xcorr(clip(1:8192),symbol0);
            xcorr1=xcorr(clip(1:8192),symbol1);
            xcorr2=xcorr(clip(1:8192),symbol2);
            xcorr3=xcorr(clip(1:8192),symbol3);
            %xcorr0=xcorr0.^2;
            %xcorr1=xcorr1.^2;
            %xcorr2=xcorr2.^2;
            %xcorr3=xcorr3.^2;
            
    
            xcorr0=sum(xcorr0(1:8192))-sum(symbol0.^2)/100;
            xcorr1=sum(xcorr1(1:8192))-sum(symbol1.^2)/100;
            xcorr2=sum(xcorr2(1:8192))-sum(symbol2.^2)/100;
            xcorr3=sum(xcorr3(1:8192))-sum(symbol3.^2)/100;
            
            xcorropts=[xcorr0 xcorr1 xcorr2 xcorr3];

            %xcorropts=[sum(xcorr0(1:8192)) sum(xcorr1(1:8192)) sum(xcorr2(1:8192)) sum(xcorr3(1:8192))];
         %xcorropts=[xcorr0(8192) xcorr1(8192) xcorr2(8192) xcorr3(8192)];
          %xcorropts=[max(xcorr0) max(xcorr1) max(xcorr2) max(xcorr3)];

	
		%xcorropts=[max()
		%max()
		%max()
		%max()];
		xcorrest=max(xcorropts);
		for kk=1:4
		if xcorrest==xcorropts(kk)
		rec4sym(1)=kk-1;
		break
        end
        end
	
	for jj=2:162
    		start=((jj-1)*8192+1);
	  	fin= (jj*8192);
        
        xcorr0=xcorr(clip(start:fin),symbol0);
        xcorr1=xcorr(clip(start:fin),symbol1);
        xcorr2=xcorr(clip(start:fin),symbol2);
        xcorr3=xcorr(clip(start:fin),symbol3);
            %xcorr0=xcorr0.^2;
            %xcorr1=xcorr1.^2;
            %xcorr2=xcorr2.^2;
            %xcorr3=xcorr3.^2;
            
            
            xcorr0=sum(xcorr0(1:8192))-sum(symbol0.^2)/100;
            xcorr1=sum(xcorr1(1:8192))-sum(symbol1.^2)/100;
            xcorr2=sum(xcorr2(1:8192))-sum(symbol2.^2)/100;
            xcorr3=sum(xcorr3(1:8192))-sum(symbol3.^2)/100;
            
            xcorropts=[xcorr0 xcorr1 xcorr2 xcorr3];

            
            
         %xcorropts=[sum(xcorr0(1:8192)) sum(xcorr1(1:8192)) sum(xcorr2(1:8192)) sum(xcorr3(1:8192))];
        %xcorropts=[xcorr0(8192) xcorr1(8192) xcorr2(8192) xcorr3(8192)];
         %xcorropts=[max(xcorr0) max(xcorr1) max(xcorr2) max(xcorr3)];


		xcorrest=max(xcorropts);
		for kk=1:4
		if xcorrest==xcorropts(kk)
		rec4sym(jj)=kk-1;
		break
		end
		end		
	end


 %rec4sym=circshift(rec4sym,-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Weak Signal Propagation Reporter (WSPR) Recieve Code         %
%      Refernece credit to Dr. Jonathon Y. Cheah (NZ0C)          %
%                   for the use of this code                     %
%           Ultra low baud rate communication study              %
%                                                                %
%               Consult www.wsprnet.org for details              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all Matlab memory buffers
      %close all
      %clear all
      %clc

% get the channel symbol file generated by transmit code
      %signal=textread('signal.dat','%u'); 
      signal=rec4sym';
      signal=vertcat(signal,0,0,0,0,0,0);
      sym=zeros(length(signal),1);
     
% set the initial variable configuration
      MAXBITS=103;        %
      gamma=zeros(MAXBITS-1);           %
      metrics=zeros(4,MAXBITS-1);       %
      tm=zeros(2,MAXBITS-1);         
      nstate=zeros(MAXBITS-1);     %
      
% configure FEC sequence
      npoly1=2^32-221228207;
      npoly2=2^32-463389625;
      
% configure the Fano decoder 
      partab=textread('partab.dat','%u');
      mettab=textread('mettab.dat','%d');
      mettab=reshape(mettab,256,2);
   
% configure the sync sequence
      sync=textread('sync.dat','%u'); 

%   
% Strip the sync sequence from channel signal.
         sym=uint8(sign(signal-sync));
         disp ('wspr signal sync stripped:')
         %sy1=reshape(sym,8,length(sym)/8)';                   %
        % disp (sy1)
         
%  
% De-interleave channel symbols.
%      symbol=deinterleave(sym);
      P=1;
      I=0;
      symbol=zeros(1,168);
      while P < 162
        J=bin2dec(fliplr(bin(fi(I,0,8,0))));
        if J<162
            symbol(P)=sym(J+1);
            P=P+1;
        end
      I=I+1;
      end
      disp ('De-interleaved:')
      sy2=reshape(symbol,8,length(symbol)/8)';                   %
      disp(sy2)
      
%
% Configure fano decoder.
      dat=zeros(11);
      nsym=162;
      nbits=50+31;
      ndelta=50;
      maxcycles=20000;
      ntail=nbits-31;
      i4a=0;
      i4b=0;
      for np =1:nbits
          jjj=2*np;
          i4a=-symbol(jjj-1);
          i4b=-symbol(jjj);
          if (i4a<0)
              i4a=i4a+256;
          end
          if (i4b<0)
              i4b=i4b+256;
          end
          metrics(1,np) = mettab(i4a+1,1) + mettab(i4b+1,1);
          metrics(2,np) = mettab(i4a+1,1) + mettab(i4b+1,2);
          metrics(3,np) = mettab(i4a+1,2) + mettab(i4b+1,1);
          metrics(4,np) = mettab(i4a+1,2) + mettab(i4b+1,2);
      end
      np=1;
      nstate(np)=0;
      
 %     
 % Compute and sort fano branch metrics 
      n=bitand(nstate(np),npoly1);
      n=bitxor(n,bitshift(n,-16));
      m=bitand(bitxor(n,bitshift(n,-8)),255);
      lsym=partab(m+1);
      n=bitand(nstate(np),npoly2);
      n=bitxor(n,bitshift(n,-16));
      m=bitand(bitxor(n,bitshift(n,-8)),255);
      lsym=lsym+lsym+partab(m+1);
      m0=metrics(lsym+1,np);
      m1=metrics(bitxor(3,lsym)+1,np);
  %
  % tm(1,np)=m0 if 0-branch is better
  %         =m1 if 1-branch is better
      if m0>m1
          tm(1,np)= m0;                   
          tm(2,np)=m1;
      else
          tm(1,np)=m1;                    
          tm(2,np)=m0;
          nstate(np)=mod(nstate(np) + 1,2^32) ;     
      end
  
      ii(np)=0;                                
      gamma(np)=0;
      nt=0;
      
  %
  % Start fano with the best branch
      for iiiii=1:nbits*maxcycles-1                
          ngamma=gamma(np) + tm(ii(np)+1,np);
          if ngamma>nt         
              if gamma(np)<(nt+ndelta)
                  nt=nt + ndelta * floor((ngamma-nt)/ndelta);
              end
        
              gamma(np+1)=ngamma;              
              nstate(np+1)=mod(bitshift(nstate(np),1),2^32);
              np=np+1;
              
  %
  % fano decoding done.
              if np == nbits
              break                            
              end
              
  %
  % fano processing.          
              n=mod(bitand(nstate(np),npoly1),2^32);
              n=mod(bitxor(n,bitshift(n,-16)),2^32);
              lsym=partab(bitand(bitxor(n,bitshift(n,-8)),255)+1);
              n=mod(bitand(nstate(np),npoly2),2^32);
              n=mod(bitxor(n,bitshift(n,-16)),2^32);
              lsym=lsym+lsym+partab(bitand(bitxor(n,bitshift(n,-8)),255)+1);
   
   %
   % fano at the tail
              if np >ntail+1
                  tm(1,np)=metrics(lsym+1,np);   
              else
                  m0=metrics(lsym+1,np);
                  m1=metrics(bitxor(3,lsym)+1,np);
                  if m0>m1
                      tm(1,np)=m0;              
                      tm(2,np)=m1;
                  else
                      tm(1,np)=m1;               
                      tm(2,np)=m0;
                      nstate(np)=mod(nstate(np) + 1,2^32);  
                  end
              end
              
  %
  % Start at the best branch
              ii(np)=0  ;                        
               continue     
          end
       npp=0;
       
     while(true)    
       noback=0;
            if np==1
               noback=1;
            end   
            if np>1        
                 if gamma(np-1)<nt
                    noback=1;
                 end
            end
            if(noback)
               nt=nt-ndelta;
                    if ii(np)~=0
                       ii(np)=0;
                       nstate(np)=mod(bitxor(nstate(np),1),32);
                    end
            break   
            end   
            
  % Back up search          
            np=np-1;                            
            if(np<ntail+1 && ii(np)~=1)
  
  %Search next best branch
               ii(np)=ii(np)+1;                   
               nstate(np)=mod(bitxor(nstate(np),1),2^32);
            break
            end
     end
      end
       metric=gamma(np);  
       
  %
  % message code generation 
       nbytes=(nbits+7)/8;                               
       np=8;
for jjj=1:nbytes-1
    i4a=nstate(np);
      if mod(floor(i4a/128),2)==1
         dat(jjj) = mod(i4a,128)-128;
        else
         dat(jjj) = mod(i4a,128);
      end     
    np=np+8;
end

  %
  % Clean-up and display recived message.
   dat(nbytes)=0;
  
   disp ('message code:')
   da=dat(:,1);
   disp(da')
  % mess=messageDecode(dat);
  %%
  data0=dat;
  space=' ';
blank='   ';
% unpack the message code into n1 for callsign and n2 for locator & power
      for j=1:length(data0)
         if (data0(j)< 0) 
             data0(j)=data0(j)+256;
         end
      end
      i=data0(1);
      i4=bitand(i,255);
      n1=bitshift(i4,20);
      i=data0(2);
      i4=bitand(i,255);
      n1=n1 + bitshift(i4,12);
      i=data0(3);
      i4=bitand(i,255);
      n1=n1 + bitshift(i4,4);
      i=data0(4);
      i4=bitand(i,255);
      n1=n1 + bitand(bitshift(i4,-4),15);
      n2=bitshift(bitand(i4,15),18);
      i=data0(5);
      i4=bitand(i,255);
      n2=n2 + bitshift(i4,10);
      i=data0(6);
      i4=bitand(i,255);
      n2=n2 + bitshift(i4,2);
      i=data0(7);
      i4=bitand(i,255);
      n2=n2 + bitand(bitshift(i4,-6),3);
%
%unpack n1 for callsign
      c ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
      callsign='      ';
      
%Plain text message ...
      if(n1>262177560)
          return          
      else
        i=mod(n1,27)+11;
        callsign(6)=c(i);
        n1=n1/27;
        i=floor(mod(n1,27)+11);
        callsign(5)=c(i);
        n1=n1/27;
        i=floor(mod(n1,27)+11);
        callsign(4)=c(i);
        n1=n1/27;
        i=floor(mod(n1,10)+1);
        callsign(3)=c(i);
        n1=n1/10;
        i=floor(mod(n1,36)+1);
        callsign(2)=c(i);
        n1=n1/36;
        i=floor(n1+1);
        callsign(1)=c(i);
      end
% unpack n2 for locator (Transmit uses maidenhead-> log,lat)
%                       (Receive reverses long,lat -> maidenhead)
          ng=n2/128;
          dlat=mod(ng,180)-90;
          dlong=-(ng/180)*2 - 180;        
          if(dlong<-180.0)
             dlong=dlong+360.0;
          end
          if(dlong>180.0)
             dlong=dlong-360.0;
          end
          nlong=60.0*(180+dlong)/5.0;
          na=floor(nlong/240);                     
          nb=floor((nlong-240*na)/24 );            
          grid(1)=char(double('A')+na) ;    
          grid(3)=char(double('0')+nb);
          nlat=60.0*(dlat+90)/2.5;
          na=floor(nlat/240) ;                     
          nb=floor((nlat-240*na)/24) ;              
          grid(2)=char(double('A')+na);
          grid(4)=char(double('0')+nb);
          
% unpack n2 for power
    ntype=bitand(n2,127)-64;
    
% Standard WSPR power message (types 0 3 7 10 13 17 ... 60)
 if(ntype>0 && ntype < 62)
    nu=mod(ntype,10);   
    if(nu==0 || nu==3 || nu==7)
        pwr=num2str(ntype);  
        [~,i1]=sscanf(callsign,'%c');
        mess=strcat(callsign(1:i1),{space},grid,{space},pwr);       
    else
        [~,i2]=sscanf(callsign,' ');
        mess=strcat(callsign(1:i2),blank);    
    end
 end
   fprintf('Received message = %s\n', mess{:});


   
