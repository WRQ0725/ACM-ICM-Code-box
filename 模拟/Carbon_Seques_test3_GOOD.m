clear;clc
for k=0:1:10
w=0.1*k;%砍伐率
loss=0.85;%加工成产品过程的损耗后剩余率
Ymax=200;%树木寿命平均值
Nmax=3000;%环境容纳量
l2=Ymax/21^4;%树龄Logistic参数
l1=Nmax/10^9;%种群Logistic参数

Mf=zeros(300,1);%总CO2封存量
Mt=zeros(300,1);%树木CO2封存量 
Mp=zeros(300,1);%产品CO2封存量
Omega=0.5;%测试：生长率中树年龄和生物量的固定权重
Mt(1)=100;
Mp(1)=0;
Mf(1)=Mt(1)+Mp(1);%初始固CO2量
b=0.68;%产品氧化保留率
COUNT=0;
average_age=70;%森林中初始树年龄平均值
for i=1:299
    
    if mod(i,17)==0 %砍伐周期
    %种群数量-速率影响因子
    a1=l1.*Mt(i).*(1-Mt(i)/Nmax)+1;
    %树年龄-速率影响因子
    a2=l2.*average_age.*(1-average_age/Ymax)+1;
    %a=Mt(i)/Nmax.*a1+(1-Mt(i)/Nmax).*a2;
    a=Omega.*a1+(1-Omega).*a2;
    M=Mt(i).*w;%砍伐量
    Mt(i+1)=a.*(Mt(i)-M);
    Mp(i+1)=Mp(i).*b+M.*loss;
    Mf(i+1)=Mt(i+1)+Mp(i+1);
    average_age=(1-w).*average_age;
else
     %种群数量-速率影响因子
    a1=l1.*Mt(i).*(1-Mt(i)/Nmax)+1;
    %树年龄-速率影响因子
    a2=l2.*average_age.*(1-average_age/Ymax)+1;
    %a=Mt(i)/Nmax.*a1+(1-Mt(i)/Nmax).*a2;
    a=Omega.*a1+(1-Omega).*a2;
    M=0;
    Mt(i+1)=a.*(Mt(i)-M);
    Mp(i+1)=Mp(i).*b+M.*loss;
    Mf(i+1)=Mt(i+1)+Mp(i+1);
    average_age=average_age+1;
    if average_age>=Ymax/2
        average_age=Ymax/2;
    end
    end

% Mf_k(:,k+1)=Mf;
% plot(Mf)
% legend()
% hold on
end
Mf_k(:,k+1)=Mf;
plot(Mf)
hold on
end
legend
filename = 'Carbon_year_different_management.csv';  % 保存的文件名

writematrix(Mf_k, filename);