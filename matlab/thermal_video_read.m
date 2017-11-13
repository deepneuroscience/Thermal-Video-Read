%% 25 Apr 2016

% B: raw thermal imaging sequences [320x240x frame length]
% timearray: Time information (unit: second)
% file: file name with its directory, i.e., './xxxx.dat'

%% Copyright Information
% Copyright (c) 25-April-2016 by Youngjun Cho
%
% * Ph.D Candidate, UCLIC, Faculty of Brain Sciences, University College London (UCL)
% * MSc in Robotics, BSc in ICT
% * Email: youngjun.cho.15@ucl.ac.uk
% * http://youngjuncho.com


function [B, timearray]=thermalImageReadYJ(file)


	fileID=fopen(file);
	RawThermal=fread(fileID,[320*240+4,inf],'uint16');

	[row,column]=size(RawThermal);
	B=zeros(320,240,column);

	
	timearray = zeros(column,1);

	for k=1:column
     	for j=1:240
         	 for i=1:320
          	  B(i,j,k)=(RawThermal(j+240*(i-1),k)-27315)/100;%        				end
             end
        end
           
        timeinfo1 = RawThermal(320*240+4,k);
    %     Bit swapping. by YJ. 28th Apr. 2016
        HighByte=bitand(round(timeinfo1),hex2dec('00FF'));
        HighByte=bitshift(HighByte,8);
        LowByte=bitshift(round(timeinfo1),-8);
        timeinfo1=HighByte+LowByte;

        timeinfo2 = RawThermal(320*240+3,k);    
    %     Bit swapping. by YJ. 28th Apr. 2016
        HighByte=bitand(round(timeinfo2),hex2dec('00FF'));
        HighByte=bitshift(HighByte,8);
        LowByte=bitshift(round(timeinfo2),-8);
        timeinfo2=HighByte+LowByte;

        timeinfo = bitshift(round(timeinfo2),16)+timeinfo1;
        timearray(k,1)=timeinfo/1000;    
        
	end

end

