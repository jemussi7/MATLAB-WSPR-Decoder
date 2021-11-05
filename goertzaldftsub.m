%%DFT

            
		for jj=2:162
    		  start=((jj-1)*8192+1);
	  	  fin= (jj*8192);
        	  Fcon(jj,:)=abs(fft(clip(start:fin)));
		  Fcontot=Fcontot+Fcon(jj,:);		
	        end

		
testpat=[zeros(1,1024) 1 1 1 1 zeros(1,7164)];

Fcand=xcorr(Fcontot,testpat);
Fcand=Fcand(8000:8400);

[xrr,locrr]=findpeaks(Fcand);
[xrrmax locrrmax]=max(xrr);
Fcandmax=locrr(locrrmax)-192+1024;
Fcandmax=Fcandmax-1;
Fcandmax=Fcandmax*12000/8192;

%%

ff0=Fcandmax*8192/12000;
ff1=ff0+1;
ff2=ff0+2;
ff3=ff0+3;


%%Frequency content

f = [ff0 ff1 ff2 ff3];
freq_indices = round(f/12000*8192) + 1; 


            Fcon_data(1,:) = goertzel(clip(1:8192),freq_indices);

            [xrrg locrrg]=find(max(abs(Fcon_data(1,:))));
          Fconest=locrrg;

         
		for kk=1:4
		if Fconest==f(kk)
		rec4sym(1)=kk-1;
		break
        end
        end
	
	for jj=2:162
    		start=((jj-1)*8192+1);
	  	fin= (jj*8192);
        
        
            Fcon_data(jj,:) = goertzel(clip(start:fin),freq_indices);
            
            
            [xrrg locrrg]=find(max(abs(Fcon_data(jj,:))));
          Fconest=locrrg;

         
		for kk=1:4
		if Fconest==f(kk)
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


   
