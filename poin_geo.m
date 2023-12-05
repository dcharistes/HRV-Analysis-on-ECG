function poin_geo
clc; 
close all;
% p=dir('heartbeat\*.txt');
% N=length(p);
% A = cell(1,N);
% for k=1:N    
%     fid = fopen(p(k).name);
%     A{k}= cell2mat(textscan(fid,"%f %f"));  % use {} for indexing A    
%     fclose(fid);
%     %A(k)=load(p(k).name,'r');  
% end
%for i=1:N
%ecg=A(i);
ecg=load("Y1.txt");
f_s=250;
N=length(ecg);
t=(0:N-1)/f_s; %time period(total sample/Fs )
figure
plot(t,ecg,'r'); title('Raw ECG Data plotting ')             
xlabel('time')
ylabel('amplitude')
w=50/(250/2);
bw=w;
[num,den]=iirnotch(w,bw); % notch filter implementation 
ecg_notch=filter(num,den,ecg);
[e,f]=wavedec(ecg_notch,10,'db6');% Wavelet implementation
g=wrcoef('a',e,f,'db6',8); 
ecg_wave=ecg_notch-g; % subtracting 10th level aproximation signal
                       %from original signal                  
ecg_smooth=smooth(ecg_wave); % using average filter to remove glitches
                             %to increase the performance of peak detection 
N1=length(ecg_smooth);
t1=(0:N1-1)/f_s;
figure,plot(t1,ecg_smooth),ylabel('amplitude'),xlabel('time')
title('Filtered ECG signal')
% Peak detection algorithm 
% For more detailsor detailed explanation on this look into 
% Matlab for beginers 
hh=ecg_smooth;
 j=[];           %loop initialing, having all the value zero in the array
time=0;          %loop initialing, having all the value zero in the array
th=0.45*max(hh);  %thresold setting at 45 percent of maximum value
 
for i=2:N1-1 % length selected for comparison  
    % deopping first ie i=1:N-1  point because hh(1-1) 
    % in the next line  will be zero which is not appreciable in matlab 
    if((hh(i)>hh(i+1))&&(hh(i)>hh(i-1))&&(hh(i)>th))  
% condition, i should be> then previous(i-1),next(i+1),thrsold point;
        j(i)=hh(i);                                   
%if condition satisfy store hh(i)in place of j(i)value whichis initially 0;   
        time(i)=(i-1)/250;           %position stored where peak value met;                   
    end
end
 j(j==0)=[];               % neglect all zeros from array;
 time(time==0)=[];     % neglect all zeros from array;
m=(time)';               % converting rows in column;
k=length(m);
figure;
plot(t,hh);            %x-axis time, y-smooth signal value;
hold on;                 % hold the plot and wait for next instruction;
plot(time,j,'*r'); title('PEAK POINTS DETECTED IN ECG SIGNAL')    
%x-axis time, yaxis-peak value,r=marker;
xlabel('time')
ylabel('amplitude')
hold off                 % instruction met;
% to remove unwanted zeros from variable j and time 
rr2=m(2:k);     %second array from 2nd to last point;
rr1=m(1:k-1);   %first array from 1st to 2nd last point;
% rr2 & rr1 is of equall length now;
rr3=rr2-rr1;
hr=60./rr3;         % computate heart rate variation ;
figure;
stairs(hr); title(' DISPLAY HRV') % stairs are used to show the variation 
rr33=(rr3)';
ki=length(rr33);
rr4=rr33(2:ki); 
rr5=rr33(1:ki-1);
figure(7);
plot(rr4,rr5,'r*') %plot  R-R(n)(X-Axis) vs R-R(n-1)(Y-Axis)
 title('POINCARE PLOT'), xlabel('RR(n+1)') ,ylabel('RR(n)')
 %% Task 4-b
ki=length(rr3) ;
ahr=mean(hr);       % mean heart rate;
disp(['mean hrv = ' num2str(ahr)]); 
% disp is used to display the value(s);
SDNN = std(rr3); 
% SDNN, standard deviation for RR interval used in statical analysis;
disp(['SDNN = ' num2str(SDNN)]);
sq = diff(rr3).^2;
rms = sqrt(mean(sq)); % RMSSD,
disp(['RMSSD = ' num2str(rms)]);  
% RMS difference for RR interval used in statical analysis;
 
NN50 = sum(abs(diff(rr3))>.05); 
% NN50 no. of pairs of RR that is more than 50, used in statical analysis;
disp(['NN50 = ' num2str(NN50)]);
%% Try 4/3
%figure,
%comet(ecg_smooth(1:1000))
%end
end