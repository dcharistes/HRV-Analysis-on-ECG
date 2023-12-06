function [D,Alpha1]=DFA_TEST(DATA)
n=100:100:1000;
N1=length(n);
F_n=zeros(N1,1);
 for i=1:N1
     F_n(i)=DFA(DATA,n(i),1);
 end
 n=n';
 plot(log(n),log(F_n));
xlabel('n')
ylabel('F(n)')
 A=polyfit(log(n(1:end)),log(F_n(1:end)),1);
Alpha1=A(1);
 D=3-A(1);
return