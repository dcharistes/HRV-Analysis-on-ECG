%%Experiment segment
function fantasia_DFA
clc;
folderPath = 'ecg_dataset';

% Get a list of all text files in the folder
fileList = dir(fullfile(folderPath, '*.txt'));

% Initialize a cell array to store the loaded data
DATA = cell(1, numel(fileList));

% Load data from each file and store it in the cell array
for k = 1:numel(fileList)
    filePath = fullfile(folderPath, fileList(k).name);
    DATA{k} = load(filePath);
end

for k = 1:numel(fileList)
    figure(k)
    [d,a,slope,N]=DFA_call_fant(DATA{k});grid on;
    disp("ECG No.: "+k)
    disp("dimension= "+d);
    disp("average slope of the whole graph is: "+a);
    for j=1:N-1 
    disp("slope("+j+"): "+slope(j))
    end
end

end

%%%DFA_call_F 
function [D,Alpha1,slope,N]=DFA_call_fant(DATA)

%%Pre-processing
ecg=DATA;
f_s=250;
f_pl=50; %powerlines frequency
N=length(ecg);
t=0:N-1; %time period(total sample/Fs)
subplot(221)
plot(t,ecg,'r'),grid on,title('Raw Interbeat interval ECG Signal '),xlim([0 N+200])       
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
title('Filtered interbeat interval ECG signal'),xlim([0 N+200])
 
%%
%%Calling DFA
n=100:100:1000;
N=length(n);
subplot(223)
F_n=zeros(N,1);
slope=zeros(1,N-1);
for i=1:N
    [F_n(i),y,y_n,N1]=DFA(ecg_smooth,n(i),1);
%Plots
    plot(1:N1,y,"b"),grid on,xlim([0 N1+100]),hold on;
    plot(1:N1,y_n,"r"),grid on;
    xlabel('n'),ylabel('f')
    title('y(n) and Yn(n)');legend('y','Yn','Location','northwest');hold off;
end 
n=n';
subplot(224)
plot(log(n),log(F_n),'-o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
title('DFA Interpretation')  
xlabel('n')
ylabel('F(n)')
for j=1:N-1
slope(j)=(log(F_n(j+1))-log(F_n(j)))/(log(n(j+1))-log(n(j)));
end
A=polyfit(log(n(1:end)),log(F_n(1:end)),1);
Alpha1=A(1); %slope of the 1st order polynomial aprox of the DFA graphic representation
%A_c=polyval(A,log(n(1:end)));
%plot(log(n),A_c)
D=3-A(1);
return;

end

%%%DFA algorithm
function [sum1,y,y_n,N1]=DFA(DATA,win_length,order)

%note:The number of windows in each iteration(See lines 62-65,66 on &&Calling DFA) is n. 
%For the 1st it. n=71. So: w1=1:100 w2=101:200...w71=7001:7100 

N=length(DATA);  %7168 1st it
n=floor(N/win_length); %71.00 1st it - n is the number of windows
N1=n*win_length; %7100 1st it
y=zeros(N1,1);
y_n=zeros(N1,1);

fitcoef=zeros(n,order+1);

mean1=mean(DATA(1:N1));

for i=1:N1
    y(i)=sum(DATA(1:i)-mean1);
end

y=y';
x=1:win_length; 
w=(bsxfun(@plus,x',(0:(n-1))*win_length))'; %bsxfun() element-wise addition between two matrices 
                                            %for j=1:n w(j,:)=((j-1)*win_length+1):j*win_length; end
for j=1:n
    fitcoef(j,:)=polyfit(x,y(w(j,:)),order);
    y_n(w(j,:))=polyval(fitcoef(j,:),x);
end

sum1=sqrt(sum((y'-y_n).^2)/N1);

end
