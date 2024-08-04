%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FT8 Transmit Code        %
%      Reference credit to Dr. Jonathon Y. Cheah (NZ0C)          %
%                   for the use of dome of this code                     %
%           Output is audioband cp 4fsk  FT8 message which can be fed to RF carrier modulation hardware or software            %
%               for transmission over the air                                                 %
%                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
%%

% user entries         ================== % call must have 6 letter 
                        call=' K1JT '     % spaces for standard HAM
                         loc='JO01'        % Radio callsign.
                      
%                      ==================
%
% process various callsign types  
if (chr_normf(call(3))>9)%right shift call sign
        
        call(6)=call(5);
        call(5)=call(4);
        call(4)=call(3);
        call(3)=call(2);
        call(2)=call(1);
        call(1)=' ';
end

%
calldec=zeros(size(call));
locdec=zeros(size(loc));
chrset=' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
pad28=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
calltype=[0 0 0 0 0 1]; %initialize calltype
%%
for(i=1:37)
    if(chrset(i)==call(1))
    calldec(1)=i-1;
    end
end

chrset='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

for(i=1:36)
    if(chrset(i)==call(2))
    calldec(2)=i-1;
    end
end
chrset='0123456789';
for(i=1:10)
    if(chrset(i)==call(3))
    calldec(3)=i-1;
    end
end

chrset=' ABCDEFGHIJKLMNOPQRSTUVWXYZ';

for(ii=4:6)
for(i=1:27)
    if(chrset(i)==call(ii))
    calldec(ii)=i-1;
    end
end
end
%%
varbase=[37 36 10 27 27 27];

decint=calldec(1)*36*10*27*27*27 + 10*27*27*27*calldec(2) + 27*27*27*calldec(3) + 27*27*calldec(4) + 27*calldec(5) + calldec(6);
decint=decint+6257896;
calltype(1)=mod(decint,2);
%%
chrset = 'ABCDEFGHIJKLMNOPQR';
for(ii=1:2)
for(i=1:18)
    if(chrset(i)==loc(ii))
    locdec(ii)=i-1;
    end
end
end

chrset='0123456789';
for(ii=3:4)
for(i=1:10)
    if(chrset(i)==loc(ii))
    locdec(ii)=i-1;
    end
end
end

locbase=[18 18 10 10];

locint=18*10*10*locdec(1)+10*10*locdec(2)+10*locdec(3)+locdec(4);

%%
binint=de2bi(decint,'left-msb',28);
binint=[0 binint(1:end-1)];%rotate right once not sure why but appears necessary
%while(size(binint)<28)  %zero pad for 28 bits
%binint=[ 0 binint];
%end
%while(binint(end)==0)
   % binint=[ 0 binint(1:end-1)];
%end
locbin=de2bi(locint);
while(size(locbin)<15)
locbin=[0 locbin ];
end
locbin=fliplr(locbin);


%%
chrset='0123456789'
%for(u=1:10)
   % if(loc(4)==chrset(u))
      %  loc3=de2bi(u-1,4,'left-msb')
        %break
    %end
%end
%calltype(1:3)=loc3(2:4);
%locbin(end)=loc3(1);
MB=[ pad28 binint calltype(1:3)  locbin calltype(4:end)];

%%
MB=[MB 0 0 0 0 0]
%CSMOD=[CS(8:36) CS(43:72)]
crc14poly =[ 1,   1, 0,   0, 1, 1, 1,   0, 1, 0, 1,   0, 1, 1, 1 ]
%crc14poly =fliplr(crc14poly);

%crc14poly=fliplr(crc14poly);
%'z^14 + z^13 + z ^10+ z^9+z^8+z^6+z^4+z^2+z+1'
ft8_crc= comm.CRCGenerator('Polynomial',[1,   1, 0,   0, 1, 1, 1,   0, 1, 0, 1,   0, 1, 1, 1 ])
MB=MB';
CRC=ft8_crc(MB);
CRC=CRC';
CRC=[CRC(1:77) CRC(83:end)];

%%
% LDPC generator matrix from WSJT-X's ldpc_174_91_c_generator.f90.
% 83 rows, since LDPC(174,91) needs 83 parity bits.
% each row has 23 hex digits, to be turned into 91 bits,
% to be xor'd with the 91 data bits.
%
rawg = [
 hexToBinaryVector( "8329ce11bf31eaf509f27fc",92),
  hexToBinaryVector("761c264e25c259335493132",92),
  hexToBinaryVector("dc265902fb277c6410a1bdc",92), 
 hexToBinaryVector("1b3f417858cd2dd33ec7f62",92), 
  hexToBinaryVector("09fda4fee04195fd034783a",92), 
  hexToBinaryVector("077cccc11b8873ed5c3d48a",92), 
  hexToBinaryVector("29b62afe3ca036f4fe1a9da",92), 
  hexToBinaryVector("6054faf5f35d96d3b0c8c3e",92), 
  hexToBinaryVector("e20798e4310eed27884ae90",92), 
  hexToBinaryVector("775c9c08e80e26ddae56318",92), 
  hexToBinaryVector("b0b811028c2bf997213487c",92), 
  hexToBinaryVector("18a0c9231fc60adf5c5ea32",92), 
  hexToBinaryVector("76471e8302a0721e01b12b8",92), 
  hexToBinaryVector("ffbccb80ca8341fafb47b2e",92), 
  hexToBinaryVector("66a72a158f9325a2bf67170",92), 
  hexToBinaryVector("c4243689fe85b1c51363a18",92), 
  hexToBinaryVector("0dff739414d1a1b34b1c270",92), 
  hexToBinaryVector("15b48830636c8b99894972e",92), 
  hexToBinaryVector("29a89c0d3de81d665489b0e",92), 
  hexToBinaryVector("4f126f37fa51cbe61bd6b94",92), 
  hexToBinaryVector("99c47239d0d97d3c84e0940",92), 
  hexToBinaryVector("1919b75119765621bb4f1e8",92), 
  hexToBinaryVector("09db12d731faee0b86df6b8",92), 
  hexToBinaryVector("488fc33df43fbdeea4eafb4",92),
  hexToBinaryVector("827423ee40b675f756eb5fe",92), 
  hexToBinaryVector("abe197c484cb74757144a9a",92), 
  hexToBinaryVector("2b500e4bc0ec5a6d2bdbdd0",92), 
  hexToBinaryVector("c474aa53d70218761669360",92), 
  hexToBinaryVector("8eba1a13db3390bd6718cec",92), 
  hexToBinaryVector("753844673a27782cc42012e",92), 
  hexToBinaryVector("06ff83a145c37035a5c1268",92), 
  hexToBinaryVector("3b37417858cc2dd33ec3f62",92), 
  hexToBinaryVector("9a4a5a28ee17ca9c324842c",92), 
  hexToBinaryVector("bc29f465309c977e89610a4",92), 
  hexToBinaryVector("2663ae6ddf8b5ce2bb29488",92), 
  hexToBinaryVector("46f231efe457034c1814418",92), 
  hexToBinaryVector("3fb2ce85abe9b0c72e06fbe",92), 
  hexToBinaryVector("de87481f282c153971a0a2e",92), 
  hexToBinaryVector("fcd7ccf23c69fa99bba1412",92), 
  hexToBinaryVector("f0261447e9490ca8e474cec",92), 
  hexToBinaryVector("4410115818196f95cdd7012",92), 
  hexToBinaryVector("088fc31df4bfbde2a4eafb4",92), 
  hexToBinaryVector("b8fef1b6307729fb0a078c0",92), 
  hexToBinaryVector("5afea7acccb77bbc9d99a90",92), 
  hexToBinaryVector("49a7016ac653f65ecdc9076",92), 
  hexToBinaryVector("1944d085be4e7da8d6cc7d0",92), 
  hexToBinaryVector("251f62adc4032f0ee714002",92), 
  hexToBinaryVector("56471f8702a0721e00b12b8",92), 
  hexToBinaryVector("2b8e4923f2dd51e2d537fa0",92), 
  hexToBinaryVector("6b550a40a66f4755de95c26",92), 
  hexToBinaryVector("a18ad28d4e27fe92a4f6c84",92), 
  hexToBinaryVector("10c2e586388cb82a3d80758",92), 
  hexToBinaryVector("ef34a41817ee02133db2eb0",92), 
  hexToBinaryVector("7e9c0c54325a9c15836e000",92), 
  hexToBinaryVector("3693e572d1fde4cdf079e86",92), 
  hexToBinaryVector("bfb2cec5abe1b0c72e07fbe",92), 
  hexToBinaryVector("7ee18230c583cccc57d4b08",92), 
  hexToBinaryVector("a066cb2fedafc9f52664126",92), 
  hexToBinaryVector("bb23725abc47cc5f4cc4cd2",92), 
  hexToBinaryVector("ded9dba3bee40c59b5609b4",92), 
  hexToBinaryVector("d9a7016ac653e6decdc9036",92), 
  hexToBinaryVector("9ad46aed5f707f280ab5fc4",92), 
  hexToBinaryVector("e5921c77822587316d7d3c2",92), 
  hexToBinaryVector("4f14da8242a8b86dca73352",92), 
  hexToBinaryVector("8b8b507ad467d4441df770e",92), 
  hexToBinaryVector("22831c9cf1169467ad04b68",92), 
  hexToBinaryVector("213b838fe2ae54c38ee7180",92), 
  hexToBinaryVector("5d926b6dd71f085181a4e12",92), 
  hexToBinaryVector("66ab79d4b29ee6e69509e56",92), 
  hexToBinaryVector("958148682d748a38dd68baa",92), 
  hexToBinaryVector("b8ce020cf069c32a723ab14",92), 
  hexToBinaryVector("f4331d6d461607e95752746",92), 
  hexToBinaryVector("6da23ba424b9596133cf9c8",92), 
  hexToBinaryVector("a636bcbc7b30c5fbeae67fe",92), 
  hexToBinaryVector("5cb0d86a07df654a9089a20",92), 
  hexToBinaryVector("f11f106848780fc9ecdd80a",92), 
  hexToBinaryVector("1fbb5364fb8d2c9d730d5ba",92), 
  hexToBinaryVector("fcb86bc70a50c9d02a5d034",92), 
  hexToBinaryVector("a534433029eac15f322e34c",92), 
 hexToBinaryVector("c989d9c7c3d3b8c55d75130",92), 
  hexToBinaryVector("7bb38b2f0186d46643ae962",92), 
  hexToBinaryVector("2644ebadeb44b9467d1f42c",92), 
  hexToBinaryVector("608cc857594bfbb55d69600",92)
];

%%
%rawg=hex2dec(rawg);
%rawg=de2bi(rawg,'left-msb');
%rawg=fliplr(rawg);
%for(j=1:83)
%rawg(j,:)=hexToBinaryVector(rawg(j,:),'left-msb');
%end
rawg=rawg(:,1:end-1);
CRCMAT=zeros(size(rawg));

%CRC=CRC';
col_mask=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
iii=0;
for(i=1:83)
    CRCMAT(i,:)=CRC(:,:);
end
%OUT=bitand(rawg,CRCMAT);
%OUT=xor(rawg,CRCMAT);
OUT=rawg.*CRCMAT;
%%

out=zeros(1,83);

SUM=zeros(1,83);
%temp=[];
for(j=1:83)
SUM(1,j)=sum(OUT(j,:));
%%
out(1,j)=mod(SUM(1,j),2);
end
%%
%if(j==1)
   % out(1,j)=mod(SUM(1,j),2);  %check if we need to set a parity bit
%else
   % out(1,j)=xor(out(1,j-1),mod(SUM(1,j),2));
%end
    %if(out(1,j)==1)
    %out=out|col_mask
    %out=or(out,col_mask)
    %end
   % col_mask=[0 col_mask(1:end-1)];
%end
%CRC=[CRC fliplr(out)];
CRC=[CRC out];
 
%%
CRC58_3=reshape(CRC,3,58);
CRC58_3=CRC58_3';
CRCSYM=bi2de(CRC58_3,'left-msb');  
graymap = [ 0, 1, 3, 2, 5, 6, 4, 7 ];  
%graymap = [ 0     1     3     2     6     7     5     4 ];
key=[0:7];

for (ii=1:58)
    for (jj=1:8)
    if CRCSYM(ii)==key(jj)
        CRCSYM(ii)=graymap(jj);
        break
    else
    end
    end
end
costas_symbols = [ 3, 1, 4, 0, 6, 5, 2 ];
costas_symbols=costas_symbols';

%%
CHANSYM=[costas_symbols;CRCSYM(1:29);costas_symbols;CRCSYM(30:end);costas_symbols];

%%
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
n=length(CHANSYM);
Xcpfsk=[];
for z=1:n
    rep=1;

 rep=rep+1;
    %end
         if(CHANSYM(z)==0)
        Xcpfsk=[Xcpfsk,sin1200Hz(1:7680)];
         z=z+1;
         elseif(CHANSYM(z)==1)
        Xcpfsk=[Xcpfsk,sin1206Hz(1:7680)];
         z=z+1;
         elseif(CHANSYM(z)==2)
        Xcpfsk=[Xcpfsk,sin1212Hz(1:7680)];
         z=z+1;
          elseif(CHANSYM(z)==3)
        Xcpfsk=[Xcpfsk,sin1218Hz(1:7680)];
         z=z+1;
         elseif(CHANSYM(z)==4)
        Xcpfsk=[Xcpfsk,sin1225Hz(1:7680)];
         z=z+1;
         elseif(CHANSYM(z)==5)
        Xcpfsk=[Xcpfsk,sin1231Hz(1:7680)];
         z=z+1;
         elseif(CHANSYM(z)==6)
        Xcpfsk=[Xcpfsk,sin1237Hz(1:7680)];
         z=z+1;
           elseif(CHANSYM(z)==7)
        Xcpfsk=[Xcpfsk,sin1243Hz(1:7680)];
         z=z+1;
    else
          
        disp('error');
        return
       
    end
    end
%% Manually execute this command in the command window on an even minute
% to successfully transmit a FT8 message
% sound(Xcpfsk,48000)  




