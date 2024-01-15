%%%DFA_call_pre_process
function [D,Alpha1,slope,N]=DFA_call_p(DATA)

%%Pre-processing
ecg=DATA;
f_s=250;
f_pl=50;  %powerlines frequency
N_ecg=length(ecg);
t=0:N_ecg-1; %time period(total sample/Fs)
subplot(221)
plot(t,ecg,'r');title('Raw Interbeat interval ECG Signal '), grid on
xlim([0 N_ecg+200]), yl=ylim;     
xlabel('Beat number')
ylabel('amplitude')

w=f_pl/(f_s/2); %50Hz is the frequency of the powerlines we are trying to remove here, electrical interference in US, ζωνοφρακτικο φιλτρο
bw=w;
[num,den]=iirnotch(w,bw);
ecg_notch=filter(num,den,ecg);
[e,f]=wavedec(ecg_notch,10,'db6');
g=wrcoef('d',e,f,'db6',6);

ecg_wave=ecg_notch-g; 
ecg_smooth=smooth(ecg_wave); 
N1=length(ecg_smooth);
t1=0:N1-1;

subplot(222)
plot(t1,ecg_smooth),grid on,ylabel('amplitude'),xlabel('Beat number')
title('Filtered interbeat interval ECG signal'),xlim([0 N_ecg+200]), ylim(yl)

%%Calling DFA
n=100:100:1000;
N=length(n);
F_n=zeros(N,1);
slope=zeros(N-1,2);
for i=1:N
    [F_n(i),y,y_n,N1]=DFA(ecg_smooth,n(i),1);
%Plots
    subplot(223)
    plot(1:N1,y,"b"),grid on, xlim([0 N1+100]),hold on;
    plot(1:N1,y_n,"r"),grid on;
    xlabel('n'),ylabel('amplitude')
    title('y(n) and Yn(n)'),legend('y','y_n','Location','northwest'),hold off
end  
n=n';
subplot(224)
plot(log10(n),log10(F_n),'-o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]),grid on;hold on;
title('DFA Interpretation')  
xlabel('log_1_0n')
ylabel('log_1_0F(n)')

for j=1:N-1
    slope(j,:)=polyfit(log10(n(j:j+1)),log10(F_n(j:j+1)),1);
end

A=polyfit(log10(n(1:end)),log10(F_n(1:end)),1);
Alpha1=A(1); %slope of the 1st order polynomial aprox of the DFA graphic representation

D=3-A(1);
return;

end