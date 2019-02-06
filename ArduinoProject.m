clear
clc

a=arduino(); %initializes Arduino
pulsePin='A0'; %where pulse monitor is plugged into board
b(1)=readVoltage(a,pulsePin); %reads voltage from pulse clip
% b(2)=readVoltage(a, pulsePin);
counter=0; %initialize variables
elapsedtime=0;
row=1;
peak=zeros(10,1);
pulseinterval=zeros(10,1);
k=1;
j=1;
x=1;
while x~=0;
while b~=0; %while voltage is being detected
    tic; %starts timer
    peakflag=0; %initializes pulse interval timer
    data(row,1)=counter; %assigns column 1 in the matrix to be the time
    data(row,2)=b; %assigns column 2 in the matrix to be the voltage from the pulse monitor
    prevVal=b;
    b=readVoltage(a,pulsePin);
    currVal=b;
    b=readVoltage(a,pulsePin);
    nextVal=b;
    voltage_threshold0=2.6; %mV voltage threshold, above this value are the pulse peaks
    voltage_threshold_min=2.0; %mV minimum voltage threshold to identify troughs
   
    if b > voltage_threshold0 & nextVal<currVal & currVal>prevVal; %only the peak counts as a beat
        %record peak if above threshold
        k=k+1;
        peak(k)=currVal;
        peakflag=1;    
        
   end

    if b>4.5;
        x=0;
    end
    
    elapsedtime=toc;    
    counter=counter+elapsedtime; %keeps accumulating time 
    
    if peakflag==1;
        writeDigitalPin(a,'D11',1); %turns on LED if a peak is found
        writeDigitalPin(a,'D11',0); %turns off LED 
        j=j+1;
        pulseinterval(j)=counter;        
        peakflag=0;
    end
    
    row=row+1;
    pause(0.0001) %a brief pause to allow plotting
    plot(data(:,1),data(:,2),'r-') %plots voltage vs time
    xlabel('time')
    ylabel('mV')
    hold on %waits for additional data to live plot
    
if k>=10 && j>=10;
P=peak((k-9):k);
pulsecount=length(P);
interval=pulseinterval((j-9):j);
I=pulseinterval(j)-pulseinterval(j-9);
BPM=pulsecount/(I/60);
fprintf('The BPM is %.2f\n',BPM)
end


end


end






    