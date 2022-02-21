
clc
clear a b c d e1 e2 e3 ee i ii j x1 x2

%% %Corrected Matlab indexed version
Nm = [

     5    32    60    92    93    97   154
     6    33    61    94   116   147     1
     7    25    62    95   123   152     1
     8    34    63    96    97   144     1
     9    26    64    84    94    97   149
     7    33    65    98   127   139     1
     6    35    66    79    99   108   155
    10    36    67   100   140   147     1
    11    37    68   101   108   127     1
    12    38    68    88   102   140   159
    13    39    69   103   106   156     1
    14    40    70   104   150   163     1
     9    41    71    83   105   115   146
    15    42    72    89   103   124   157
    16    43    60   107   124   160     1
     2    34    73   107   108   158     1
    17    44    74   109   142   161     1
    18    38    75    82   110   132   155
    12    45    76   111   122   167     1
    46    56    65   112   131   162   174
     9    47    72   113   120   167     1
    19    37    77    90   114   115   144
    20    39    78   105   117   164     1
    21    48    71    93   139   166     1
     3    49    75   114   129   161     1
    22    46    79    84   118   122   152
    23    48    59   119   128   165     1
    17    40    63   113   135   159     1
    24    44    80   121   132   146     1
    20    36    60    74   111   126   162
    21    37    64    95   137   162     1
    15    32    80    99   133   165     1
     4    45    81   125   128   170     1
    20    47    82   118   136   168     1
     8    50    59    91   101   106   169
    13    51    62   119   120   145     1
    14    52    65   115   119   158     1
    25    53    77   130   149   150     1
    26    54    70    91   102   131   157
    21    47    66    81   121   141   171
    22    55    78   101   141   172     1
    36    83   134   143   172   175     1
    15    31    84   114   126   171     1
     5    30    69   121   135   174     1
     2     5    53    58    87   137   153
    27    52    57    92   123   138   169
    53    85   111   116   146   169     1
     8    51    82   100   133   174     1
    24    56    68    96   173   175     1
    27    42    78   110   142   149     1
     3    28    42    62    63   116   134
    28    41    57   125   126   127     1
    19    50    56   125   142   168     1
     7    34    86   109   117   157     1
    29    49    71    86   106   130   159
    10    55    64   132   148   156     1
    23    54    69   110   122   175     1
     4    14    49    79    96   124     1
    32    70   134   151   156   170     1
    13    44    67    90    98   136   160
     6    40    76   103   137   168     1
     3    55    87   102   136   165     1
    16    57    88   109   120   172     1
    11    45    83    92   112   145   150
    24    35    72    95   128   154     1
    12    50    89    93   143   158     1
    30    35    88    98   148   163     1
    31    51    61    87   138   143   163
    11    54    67    85   113   129   166
    23    58    86    94   141   160     1
    29    33    73   104   133   167     1
    29    30    85    89   118   144   151
     2    27    46    81   129   148     1
    18    28    90   104   117   154     1
    52    58    99   164   166   173     1
    22    38    74   139   153   170     1
    17    48    77   131   138   155     1
     4    25    31    73   105   140     1
    10    41    91   107   135   152     1
    16    59    61    75   112   151   164
    19    43    80   145   147   153     1
    26    39    66   100   123   161     1
    18    43    76   130   171   173     1

];   

Mn = [
    17    46    74
    26    52    63
    34    59    79
     2    45    46
     3     8    62
     4     7    55
     5    36    49
     6    14    22
     9    57    80
    10    65    70
    11    20    67
    12    37    61
    13    38    59
    15    33    44
    16    64    81
    18    29    78
    19    75    84
    23    54    82
    24    31    35
    25    32    41
    27    42    77
    28    58    71
    30    50    66
     4    39    79
     6    40    83
    47    51    74
    52    53    75
    56    72    73
    45    68    73
    44    69    79
     2    33    60
     3     7    72
     5    17    55
     8    66    68
     9    31    43
    10    23    32
    11    19    77
    12    24    83
    13    29    62
    14    53    80
    15    51    52
    16    82    84
    18    30    61
    20    34    65
    21    27    74
    22    35    41
    25    28    78
    26    56    59
    36    54    67
    37    49    69
    38    47    76
    39    46    48
    40    58    70
    42    57    63
    21    50    54
    47    53    64
    46    71    76
    28    36    81
     2    16    31
     3    69    81
     4    37    52
     5    29    52
     6    32    57
     7    21    38
     8    41    83
     9    61    70
    10    11    50
    12    45    58
    13    40    60
    14    25    56
    15    22    66
    17    72    79
    18    31    77
    19    26    81
    20    62    84
    23    39    78
    24    42    51
     8    27    59
    30    33    82
    34    41    74
    19    35    49
    14    43    65
     6    27    44
    48    70    73
    55    56    71
    46    63    69
    11    64    68
    15    67    73
    23    61    75
    36    40    80
     2    47    65
     2    25    67
     3     6    71
     4    32    66
     5    50    59
     2     5     6
     7    61    68
     8    33    76
     9    49    83
    10    36    42
    11    40    63
    12    15    62
    13    72    75
    14    24    79
    12    36    56
    16    17    80
     8    10    17
    18    55    64
    19    51    58
    20    31    48
    21    65    81
    22    29    70
    23    26    44
    14    23    38
     3    48    52
    24    55    75
    27    35    73
    28    37    38
    22    37    64
    30    41    45
    20    27    58
     4    47    83
    15    16    59
    34    53    54
    31    44    53
     7    10    53
    28    34    66
    26    70    74
    39    56    84
    21    40    78
    19    30    57
    33    49    72
    43    52    60
    29    45    80
    35    61    63
    32    46    62
    47    69    78
     7    25    77
     9    11    79
    41    42    71
    18    51    54
    43    67    69
     5    23    73
    37    65    82
    14    30    48
     3     9    82
    57    68    74
     6    39    51
    13    39    65
    60    73    81
     4    27    80
    46    77    82
     2    66    75
     8    19    78
    12    57    60
    15    40    55
    17    38    67
    11    29    56
    16    61    71
    18    26    83
    21    31    32
    13    68    69
    24    76    81
    28    33    63
    25    70    76
    20    22    72
    35    54    62
    36    47    48
    34    60    77
    41    44    84
    42    43    64
    50    76    84
    21    45    49
    43    50    58
];

x1=NaN(1,83);
x2=NaN(1,83);
 b=NaN(1,83);
 c=NaN(1,83);
 d=NaN(1,83);

ldpc_iters=8;
%codeword=[CRC 0];

nmx=Nm;   %nmx = numpy.array(Nm, dtype=numpy.int32)
  mnx=Mn;   %mnx = numpy.array(Mn, dtype=numpy.int32)

%%parity check large array
 m = zeros(83, 174);  
 tic
 %    m = numpy.zeros((83, 174))
% m=sparse(m);

  for i=1:174   %for i in range(0, 174):
      for j=1:83    %for j in range(0, 83):
       m(j,i)=codeword(i);  %m[j][i] = codeword[i] 
     end
  end  
  %%
 for k=1:ldpc_iters%for iter in range(0, ldpc_iters):
 % iteration large array
  
 
  ee = zeros(83, 174);  %e = numpy.zeros((83, 174))
 % ee=sparse(ee);
  %ee=['float'];
  a=1;
  
  for j=1:83    %for j in range(0, 83):
      
      for i=1:7  %for i in Nm[j]:
          if Nm(j,i)<=1  %if i <= 0:
          continue
          
          end
         a=1;
          for ii=1:7    %for ii in Nm[j]:
               
              if Nm(j,ii)~=i
                  if Nm(j,ii)==1
                      a=a*tanh(m(j,174) / 2);
                     % ee(j,Nm(j,i)-1) = log((1 + a) / (1 - a));
                  end
                  continue
                  a=a*tanh(m(j,Nm(j,ii)-1) / 2); % INDEXING!! %a *= math.tanh(m[j][ii-1] / 2.0)
                  
              end
                  ee(j,Nm(j,i)-1) = log((1 + a) / (1 - a)); %e[j][i-1] = math.log((1 + a) / (1 - a))
          end
      end  
  end        
   %%   
   count=0;
   for i=1:7    %for i in range(0, 7):
              aa=ones(1,83);    %a becomes an array here 83%a = numpy.ones(83)
              
              for ii=1:7 %PRODUCT %for ii in range(0, 7):
           
                  if ii ~= i
                      for j1=1:83
                       if nmx(j1,ii)==1 
                           nmx(j1,ii)=174;
                       end 
                      end
                      
                     for j1=1:83
                    x1(1,j1)=tanh(m((j1), nmx(j1,ii)-1) / 2.0);  %82? INDEXING!! %x1 = numpy.tanh(m[range(0, 83), nmx[:,ii]-1] / 2.0)
                      % x1=tanh(m((1:83), nmx(:,ii)-1) / 2.0);
                     
                    if Nm(j1,ii)>1.0   %FIX!!
                        x2(1,j1)=x1(1,j1);    %x2 = numpy.where(numpy.greater(nmx[:,ii], 0.0), x1, 1.0)
                    else
                        x2(1,j1)=1.0;
                    end
                    %x2 = numpy.where(numpy.greater(nmx[:,ii], 0.0), x1, 1.0);
                    %aa = aa.*x2;    %a = a * x2
                    aa(1,j1)=aa(1,j1)*x2(1,j1);
                  count=count+1;
                      end
                      
                 
                  
                  for j2=1:83   %b = numpy.where(numpy.less(a, 0.99999), a, 0.99)
                    if aa(1,j2)<0.99999
                        b(1,j2)=aa(1,j2);
                    else
                        b(1,j2)=0.99;
                    end
                  end
                  
                  for j2=1:83
            c(1,j2) = log((b(1,j2) + 1.0) / (1.0 - b(1,j2))); %c = numpy.log((b + 1.0) / (1.0 - b))
                  end
                  
                  for j2=1:83
                    if nmx(j2,i)==1
                     nmx(j2,i)=175
                        d(1,j2)=ee(j2,nmx(j2,i)-1);   % d = numpy.where(numpy.equal(nmx[:,i], 0), e[range(0,83), nmx[:,i]-1], c)

                        else
                            d(1,j2)=c(1,j2);
                        end
                  end
                  
            
            for j2=1:83
            ee(j2, nmx(j2,i)-1) = d(1,j2);    %e[range(0,83), nmx[:,i]-1] = d
            end
            
                  end
              
          
       for j2=1:174
        e1(j2,1) = ee(mnx(j2,1)-1,j2);    %e0 = e[mnx[:,0]-1, range(0,174)]
        e2(j2,1) = ee(mnx(j2,2)-1,j2);    %e1 = e[mnx[:,1]-1, range(0,174)]
        e3(j2,1) = ee(mnx(j2,3)-1,j2);    %e2 = e[mnx[:,2]-1, range(0,174)] %SUM
       end
       
        lll = codeword + e1+ e2+e3;   %ll reused var name % ll = codeword + e0 + e1 + e2
                       
              end
        end
     
       
  
  
  %%
      cw=ones(174,1)    %cw = numpy.select( [ ll < 0 ], [ numpy.ones(174, dtype=numpy.int32) ])

  for qq=1:174
      if lll(qq,1)<0
          cw(qq,1)=1
      end
  end
  
  %% ldpc_check
      
%for iii=1:83
   % SUM(iii)=sum(Nm(iii,:));
    %colproc(iii)=mod(SUM(1,iii),2);
%end

%%
for j=1:3   %for j in range(0, 3):
    lll=codeword;   %ll = codeword
    
    if j ~=1    %if j != 0:
        for j2=1:174
        e1(j2,1)=ee(mnx(j2,1)-1,j2);  %e0 = e[mnx[:,0]-1, range(0,174)]
        end
    end
    lll=lll+e1; %ll = ll + e0
     if j~=2    %if j != 1:
         for j2=1:174
        e2(j2,1)=ee(mnx(j2,2)-1,j2);  %e1 = e[mnx[:,1]-1, range(0,174)]
         end
     end
     lll=lll+e2;    %ll = ll + e1
     if j~=3    %if j != 2:
         for j2=1:174
        e3(j2,1)=ee(mnx(j2,3)-1,j2);  %e2 = e[mnx[:,2]-1, range(0,174)]
         end
    end
    lll=lll+e3; %ll = ll + e2
    
    for j2=1:174
        m(mnx(j2,j)-1,j2)=lll(j2,1); %m[mnx[:,j]-1, range(0,174)] = ll
    end
    end
end

toc