%%
           %%Matched Filter WSPR

 %x = ones(10,1);
 b0 = symbol0(end:-1:1);
 b1 = symbol1(end:-1:1);
 b2 = symbol2(end:-1:1);
 b3 = symbol3(end:-1:1);
 
 out0 = sum(filter(b0,1,clip(1:8192)));
 out1 = sum(filter(b1,1,clip(1:8192)));
 out2 = sum(filter(b2,1,clip(1:8192)));
 out3 = sum(filter(b3,1,clip(1:8192)));
 
 matchedopts=[ out0 out1 out2 out3];
 
 %%
 	%max()];
		matchedest=max(matchedopts);
		for kk=1:4
		if matchedest==matchedopts(kk)
		rec4sym(1)=kk-1;
		break
        end
        end
       %%
       
       for jj=2:162
    		start=((jj-1)*8192+1);
	  	   fin= (jj*8192);
        
         out0 = sum(filter(b0,1,clip(start:fin)));
         out1 = sum(filter(b1,1,clip(start:fin)));
         out2 = sum(filter(b2,1,clip(start:fin)));
         out3 = sum(filter(b3,1,clip(start:fin)));
 
         matchedopts=[ out0 out1 out2 out3];
         
         %%
 	%max()];
		matchedest=max(matchedopts);
		for kk=1:4
		if matchedest==matchedopts(kk)
		rec4sym(jj)=kk-1;
		break
        end
        end
        end
 