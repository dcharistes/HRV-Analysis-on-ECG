%%%DFA_final
function DFA_final
clc;
DATA=load("O1.txt");
disp("ECG Analysis of one signal")
[d,a,slope,N]=DFA_call_F(DATA);
disp("dimension= "+d);disp("average slope of the whole graph is: "+a);
for j=1:N-1 
    disp("slope("+j+"): "+slope(j))
end
end

%%%DFA_call_F 
function [D,Alpha1,slope,N]=DFA_call_F(DATA)

%%Pre-processing
ecg=DATA;
f_s=250;
N=length(ecg);
t=0:N-1; %time period(total sample/Fs)
figure (1)
subplot(221)
plot(t,ecg,'r');title('Raw Interbeat interval ECG Signal '),xlim([0 N+200]),grid on;          
xlabel('Beat number')
ylabel('amplitude')

w=50/(250/2); %50Hz is the frequency of the powerlines we are trying to remove here
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
title('Filtered interbeat interval ECG signal'),xlim([0 N+200]);

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

%%Calling DFA
n=100:100:1000;
N=length(n);
F_n=zeros(N,1);
slope=zeros(1,N-1);
for i=1:N
    [F_n(i),y,Yn,N1]=DFA(ecg_smooth,n(i),1);
%Plots
    subplot(223)
    plot(1:N1,y,"b"),hold on,grid on, xlim([0 N1+100]);
    plot(1:N1,Yn,"r"),grid on;
    xlabel('n'),ylabel('f')
    title('y(n) and Yn(n)'),legend('y','Yn','Location','northwest'),hold off;
end  
n=n';
subplot(224)
plot(log(n),log(F_n),'-o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);grid on;hold on;
title('DFA Interpretation')  
xlabel('n')
ylabel('F(n)')
for j=1:N-1
slope(j)=(log(F_n(j+1))-log(F_n(j)))/(log(n(j+1))-log(n(j)));
end
A=polyfit(log(n(1:end)),log(F_n(1:end)),1);
Alpha1=A(1); %slope for the whole graph
%A_c=polyval(A,log(n(1:end)));
%plot(log(n),A_c)
D=3-A(1);
return;

end

%%%DFA algorithm
function [out1,out2,out3,out4]=DFA(DATA,win_length,order)

%note:The number of windows in each iteration(See lines 62-65,66 on &&Calling DFA) is n. 
%For the 1st it. n=71. So: w1=1:100 w2=101:200...w71=7001:7100 

N=length(DATA);  %7168 1st it
n=floor(N/win_length); %71.00 1st it - n is the number of windows
N1=n*win_length; %7100 1st it
y=zeros(N1,1);
Yn=zeros(N1,1);

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
    Yn(w(j,:))=polyval(fitcoef(j,:),x);
end

sum1=sqrt(sum((y'-Yn).^2)/N1);

out1=sum1;
out2=y;
out3=Yn;
out4=N1;

end
