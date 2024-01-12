%Dimitrios Bismpas 2037
%Dimitrios Charistes 2031
%Ομάδα χρηστών 16

%%Experiment segment
function fantasia_DFA
clc;
folderPath = 'ecg_dataset';

fileList = dir(fullfile(folderPath, '*.txt'));

DATA = cell(1, numel(fileList));

for k = 1:numel(fileList)
    filePath = fullfile(folderPath, fileList(k).name);
    DATA{k} = load(filePath);
end

for k = 1:numel(fileList)
    figure(k)
    [d,a,slope,N]=DFA_call_fant(DATA{k});grid on;
    disp('----')
    disp("ECG No.: "+k)
    disp("dimension= "+d);
    disp("average slope of the whole graph is: "+a);
    for j=1:N-1 
    disp("slope("+j+"): "+slope(j,1))
    end
end

end

%%%DFA_call_F 
function [D,Alpha1,slope,N]=DFA_call_fant(DATA)

%%Pre-processing
ecg=DATA;
f_s=250;
f_pl=50; 
N_ecg=length(ecg);
t=0:N_ecg-1;
subplot(221)
plot(t,ecg,'r'),grid on,title('Raw Interbeat interval ECG Signal '),xlim([0 N_ecg+200])       
xlabel('Beat number')
ylabel('amplitude')

w=f_pl/(f_s/2);
bw=w;
[num,den]=iirnotch(w,bw); 
ecg_notch=filter(num,den,ecg);
[e,f]=wavedec(ecg_notch,20,'db6');
g=wrcoef('d',e,f,'db6',16); 

ecg_wave=ecg_notch-g; 
ecg_smooth=smooth(ecg_wave); 
N1=length(ecg_smooth);
t1=0:N1-1;

subplot(222)
plot(t1,ecg_smooth),grid on,ylabel('amplitude'),xlabel('Beat number')
title('Filtered interbeat interval ECG signal'),xlim([0 N_ecg+200])
 
%%
%%Calling DFA
n=100:100:1000;
N=length(n);
subplot(223)
F_n=zeros(N,1);
slope=zeros(N-1,2);
for i=1:N
    [F_n(i),y,y_n,N1]=DFA(ecg_smooth,n(i),1);
%Plots
    plot(1:N1,y,"b"),grid on,xlim([0 N1+100]),hold on;
    plot(1:N1,y_n,"r"),grid on;
    xlabel('n'),ylabel('amplitude')
    title('y(n) and y_n(n)');legend('y','y_n','Location','northwest');hold off;
end 
n=n';
subplot(224)
plot(log(n),log(F_n),'-o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
title('DFA Interpretation')  
xlabel('log_1_0n')
ylabel('log_1_0F(n)')

for j=1:N-1
    slope(j,:)=polyfit(log10(n(j:j+1)),log10(F_n(j:j+1)),1);
end
A=polyfit(log10(n(1:end)),log10(F_n(1:end)),1);
Alpha1=A(1);

D=3-A(1);
return;

end

%%%DFA algorithm
function [sum1,y,y_n,N1]=DFA(DATA,win_length,order) 

N=length(DATA);
n=floor(N/win_length);
N1=n*win_length;
y=zeros(N1,1);
y_n=zeros(N1,1);

fitcoef=zeros(n,order+1);

mean1=mean(DATA(1:N1));

for i=1:N1
    y(i)=sum(DATA(1:i)-mean1);
end

y=y';
x=1:win_length; 
w=(bsxfun(@plus,x',(0:(n-1))*win_length))'; 

for j=1:n
    fitcoef(j,:)=polyfit(x,y(w(j,:)),order);
    y_n(w(j,:))=polyval(fitcoef(j,:),x);
end

sum1=sqrt(sum((y'-y_n).^2)/N1);

end
