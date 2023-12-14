function [out1,out2,out3,out4]=DFA(DATA,win_length,order)
      
N=length(DATA);   
n=floor(N/win_length);
N1=n*win_length;
y=zeros(N1,1);
Yn=zeros(N1,1);

fitcoef=zeros(n,order+1);
    mean1=mean(DATA(1:N1));
for i=1:N1
        y(i)=sum(DATA(1:i)-mean1);
end
y=y';
for j=1:n
    fitcoef(j,:)=polyfit(1:win_length,y(((j-1)*win_length+1):j*win_length),order);
end

for j=1:n
    Yn(((j-1)*win_length+1):j*win_length)=polyval(fitcoef(j,:),1:win_length);
end

sum1=sqrt(sum((y'-Yn).^2)/N1);

out1=sum1; 
out2=y;
out3=Yn;
out4=N1;

end