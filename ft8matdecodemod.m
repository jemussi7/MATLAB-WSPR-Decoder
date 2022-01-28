%%%FT8 Matlab demodulator decoder %%%


close all
clear all
clc

%%
ft8rcvd=audiorecorder(12000,8,1);

%%

            ii=1;
            while ii<15
              disp('.')
              pause(1)
            
                clk=clock;

                 if mod(clk(6),15)<=2
                disp('Rx!')
                recordblocking(ft8rcvd,15)
                ii=15;
                elseif mod(clk(6),15)>=2
                    ii=ii+1
                clk = clock;
                disp('waiting to receive')
                end
            end
            
            clip=getaudiodata(ft8rcvd);
            
            %%Trim audio clip to correct length
            clip=clip(1:end-4320);
            clipcp=clip;
            %clip=clip';

            [xr,locr]=findpeaks(clip);
            %meanp = mean(xr);
            [row,colmn]=find(xr>(0.5));
            begin=locr(row(end))-151679;
            clip=clip(begin:locr(row(end)));
             clipcp1=clip;
             
            %%
            Fcon=abs(fft(clip));
            Fcon=resample(Fcon,1,79);
            
            testpat=[zeros(1,192) 1 1 1 1 1 1 1 1 zeros(1,1720)];

            Fcand=xcorr(Fcon,testpat);
            Fcand=Fcand';
            %Fcand=Fcand(1888:1952);

            [xrr,locrr]=findpeaks(Fcand);
            [xrrmax locrrmax]=max(xrr);
            Fcandmax=locrr(locrrmax)-1920+193;
           % Fcandmax=Fcandmax-1;
            Fcandmax=Fcandmax*12000/1920;

             
             %%

sintablen = 1920/4;

SINTAB = sin(2*pi*(0:sintablen-1)./sintablen);

fs = 48000/4;

%%

F_required = Fcandmax;

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1200Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end

%%

F_required = Fcandmax+(6.25);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1206Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end



%%

F_required = Fcandmax+(12.5);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1212Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end



%%

F_required = Fcandmax+(18.75);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1218Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end



%%

F_required = Fcandmax+(25);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1225Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end

%%

F_required = Fcandmax+(31.25);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1231Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end

%%

F_required = Fcandmax+(37.5);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1237Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end

%%

F_required = Fcandmax+(43.75);

index = 1; step = (F_required/fs)*sintablen;

for i = 1:1920

    sin1243Hz(i) = SINTAB(ceil(index));

    index = index+step;

    if index>sintablen

        index = index-sintablen;

    end

end

%%

    symbol0=sin1200Hz;
    symbol1=sin1206Hz;
    symbol2=sin1212Hz;
    symbol3=sin1218Hz;
    symbol4=sin1225Hz;
    symbol5=sin1231Hz;
    symbol6=sin1237Hz;
    symbol7=sin1243Hz;
    
    %%
  costas_symbols = [ symbol4, symbol2, symbol5, symbol1, symbol7, symbol6, symbol3 ];

  
    %%
   
    

            xcorr0=xcorr(clip(1:1920),symbol0);
            xcorr1=xcorr(clip(1:1920),symbol1);
            xcorr2=xcorr(clip(1:1920),symbol2);
            xcorr3=xcorr(clip(1:1920),symbol3);
            xcorr4=xcorr(clip(1:1920),symbol4);
            xcorr5=xcorr(clip(1:1920),symbol5);
            xcorr6=xcorr(clip(1:1920),symbol6);
            xcorr7=xcorr(clip(1:1920),symbol7);
            
            xcorr0=xcorr0.^2;
            xcorr1=xcorr1.^2;
            xcorr2=xcorr2.^2;
            xcorr3=xcorr3.^2;
            xcorr4=xcorr4.^2;
            xcorr5=xcorr5.^2;
            xcorr6=xcorr6.^2;
            xcorr7=xcorr7.^2;

          
         xcorropts=[sum(xcorr0(1:1920)) sum(xcorr1(1:1920)) sum(xcorr2(1:1920)) sum(xcorr3(1:1920))...
             sum(xcorr4(1:1920)) sum(xcorr5(1:1920)) sum(xcorr6(1:1920)) sum(xcorr7(1:1920))];

	

		xcorrest=max(xcorropts);
		for kk=1:8
		if xcorrest==xcorropts(kk)
		cgan8sym(1)=kk-1;
		break
        end
        end
        
        
	for jj=2:79
    		start=((jj-1)*1920+1);
	  	fin= (jj*1920);
        
        xcorr0=xcorr(clip(start:fin),symbol0);
        xcorr1=xcorr(clip(start:fin),symbol1);
        xcorr2=xcorr(clip(start:fin),symbol2);
        xcorr3=xcorr(clip(start:fin),symbol3);
        xcorr4=xcorr(clip(start:fin),symbol4);
        xcorr5=xcorr(clip(start:fin),symbol5);
        xcorr6=xcorr(clip(start:fin),symbol6);
        xcorr7=xcorr(clip(start:fin),symbol7);
        
            xcorr0=xcorr0.^2;
            xcorr1=xcorr1.^2;
            xcorr2=xcorr2.^2;
            xcorr3=xcorr3.^2;
            xcorr4=xcorr4.^2;
            xcorr5=xcorr5.^2;
            xcorr6=xcorr6.^2;
            xcorr7=xcorr7.^2;
            
        
         xcorropts=[sum(xcorr0(1:1920)) sum(xcorr1(1:1920)) sum(xcorr2(1:1920)) sum(xcorr3(1:1920))...
             sum(xcorr4(1:1920)) sum(xcorr5(1:1920)) sum(xcorr6(1:1920)) sum(xcorr7(1:1920))];

	

		xcorrest=max(xcorropts);
		for kk=1:8
		if xcorrest==xcorropts(kk)
		chan8sym(jj)=kk-1;
		break
		end
		end		
	end

%%

CRCSYM=[chan8sym(8:37) chan8sym(45:72)]


graymap = [ 0, 1, 2,3,4 , 5, 6, 7 ];  



key=[0:7];



for (ll=1:58)

    for (mm=1:8)

    if CRCSYM(ll)==key(mm)

        CRCSYM(ll)=graymap(mm);

        break

    else

    end

    end

end

CRC58_3=de2bi(CRCSYM)
CRC=reshape(CRC58_3,1,174)

%out=CRC(92:end)
%CRC=CRC(1:91)

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

rawg=rawg(:,1:end-1);

CRCMAT=zeros(size(rawg));
%%
for j=1:83
%SUM(1,j)=
end
%%
OUT=CRCMAT./rawg;
    