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