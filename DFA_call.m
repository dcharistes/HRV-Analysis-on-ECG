%%%DFA_call & pre-process 
function [D,Alpha1]=DFA_call(DATA)

%%Pre-processing
ecg=DATA;
f_s=250;
N=length(ecg);
t=(0:N-1)/f_s; %time period(total sample/Fs)

subplot(221)
plot(t,ecg,'r'); title('Raw ECG Data plotting ')             
xlabel('time')
ylabel('amplitude')

w=50/(250/2);
bw=w;
[num,den]=iirnotch(w,bw); 
ecg_notch=filter(num,den,ecg);
[e,f]=wavedec(ecg_notch,20,'db6');
g=wrcoef('a',e,f,'db6',16); 

ecg_wave=ecg_notch-g; 
ecg_smooth=smooth(ecg_wave); 
N1=length(ecg_smooth);
t1=(0:N1-1)/f_s;

subplot(222)
plot(t1,ecg_smooth),ylabel('amplitude'),xlabel('time')
title('Filtered ECG signal')

hh=ecg_smooth;
j=[];           
time=0;          
th=0.45*max(hh);  
 
for i=2:N1-1  
    if((hh(i)>hh(i+1))&&(hh(i)>hh(i-1))&&(hh(i)>th))  
        j(i)=hh(i);                                   
        time(i)=(i-1)/250;                           
    end
end
j(j==0)=[];              
time(time==0)=[];     
m=(time)';              
k=length(m);
% subplot(223)
% plot(t,hh);            
% hold on;                
% plot(time,j,'*r'); title('PEAK POINTS DETECTED IN ECG SIGNAL')    
% xlabel('time')
% ylabel('amplitude')
% hold off   
%%
%%Calling DFA
n=100:100:1000;
N1=length(n);
F_n=zeros(N1,1);
for i=1:N1
    [F_n(i),y,Yn,N2]=DFA(ecg_smooth,n(i),1);

    subplot(223)
    plot(1:N2,y,"b");hold on;
    plot(1:N2,Yn,"r");hold off;
end
%Plots  
n=n';
subplot(224)
plot(log(n),log(F_n),'-o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
title('DFA Interpretation')  
xlabel('n')
ylabel('F(n)')
A=polyfit(log(n(1:end)),log(F_n(1:end)),1);
Alpha1=A(1);
D=3-A(1);
return;

end