%%%DFA algorithm
function [out1,out2,out3,out4]=DFA(DATA,win_length,order)

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
w=(bsxfun(@plus,x',(0:(n-1))*win_length))'; %element-wise addition between two matrices
for j=1:n
    fitcoef(j,:)=polyfit(x,y(w(j,:)),order);
end

for j=1:n
    Yn(w(j,:))=polyval(fitcoef(j,:),x);  
end

sum1=sqrt(sum((y'-Yn).^2)/N1);

out1=sum1; 
out2=y;
out3=Yn;
out4=N1;

end