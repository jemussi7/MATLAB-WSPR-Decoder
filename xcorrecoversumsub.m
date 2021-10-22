
%%Frequency content symbol summation method


            Fcon(1,:)=abs(fft(clip(1:8192)));
		Fcontot=Fcon(1);
            
		for jj=2:162
    		  start=((jj-1)*8192+1);
	  	  fin= (jj*8192);
        	  Fcon(jj,:)=abs(fft(clip(start:fin)));
		  Fcontot=Fcontot+Fcon(jj,:);		
	        end
