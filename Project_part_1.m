clc
clear

m=45;%Kg        bicycle mass
h=0.45;%m       height of bicycle COM
l1=0.81;%m      dist b/w ground and balancer
b=1.06;%m       bicycle wheel base
c=0.5;%m        dist between rear wheel and reference point
l=0.2;%m        
eta=65*2*pi/180;
delta=0.2;%m
Js=0.35;%Kgm^2
mb=13.2;%Kg
hb=0.29;%m
Ib=0.22;%Kgm^2

%%

s=tf('s');
d1=(m*h*h)+(mb*l1*l1);
d2=mb*l1*hb;
d3=(mb*hb*hb)+Ib;

%syms beta;
% beta=-1:0.01:1;
% W=(beta/2)+(((d3-d1)*atan((d3-2d2+d1)^0.5*tan(beta/2)))/(((d3-2d2+d1)*(d3+2d2+d1))^0.5));
% W1=-0.055423331578112612949639095976032*beta;
% W2=0.4864*beta;
% %W1=- 8.419146665399794175599615812091*beta.^3 - 0.055423331578112612949639095976032*beta;
% %W1=vpa(taylor(W,beta,'expansionpoint',0,'order',5));
% plot(beta,W);
% hold on;
% plot(beta,W1);
% hold on;
% plot(beta,W2);

%% Plant dynamics

A=[0,0,1,0;
    0,0,0,1;
    44.21,-15.4,0,0;
    -175.5,79.612,0,0];
B=[0,0,-0.316,1.8]';
C1=[1,0,0,0];%alpha=roll angle of bicycle
C2=[0,1,0,0];%beta=balancer angle
C3=[0,0,1,0];%alpha_dot
C4=[0,0,0,1];%beta_dot

D=0;

ss1=ss(A,B,C1,D);
tf1=tf(ss1);

step(tf1);

%% Controller 

k=[590.5,-70.9,120.3,6.1];
Ac=A+(B*k);
t=0:0.0010494:4;
u=100*(10*t);


ss2=ss(Ac,B,C1,D);
tf2=tf(ss2);
figure;
%alp=step(tf2,20);
alp=lsim(tf2,u,t);
plot(alp);

hold on;
ss3=ss(Ac,B,C3,D);
tf3=tf(ss3);
%alpdot=step(tf3,20);
alpdot=lsim(tf3,u,t);
plot(alpdot);

figure;
ss4=ss(Ac,B,C2,D);
tf4=tf(ss4);
%bet=step(tf4,20);
bet=lsim(tf4,u,t);
plot(bet);

hold on;
ss5=ss(Ac,B,C4,D);
tf5=tf(ss5);
%betdot=step(tf5,20);
betdot=lsim(tf5,u,t);
plot(betdot);

 labels= zeros(3812,1);
 for i=1:3812;
     labels(i)=(alp(i)*k(1))+(bet(i)*k(2))+(alpdot(i)*k(3))+(betdot(i)*k(4));
 end




y=lsim(tf2,u,t);


figure;
plot(labels);

%% Test data

%Talp=step(tf2,10);
%Talpdot=step(tf3,10);
%Tbet=step(tf4,10);
%Tbetdot=step(tf5,10);

%test_data=zeros(4,1906);
%Tlabels= zeros(1906,1);
%for i=1:1906;
%    test_data(1,i)= alp(i,1);
%    test_data(2,i)= bet(i,1);
%    test_data(3,i)= alpdot(i,1);
%    test_data(4,i)= betdot(i,1);
%    Tlabels(i)=(Talp(i)*k(1))+(Tbet(i)*k(2))+(Talpdot(i)*k(3))+(Tbetdot(i)*k(4));
%end
%Tlabels=Tlabels';

%% Training data



training_dataset=zeros(4,3812);
for i=1:3812;
    training_dataset(1,i)= alp(i,1);
    training_dataset(2,i)= bet(i,1);
    training_dataset(3,i)= alpdot(i,1);
    training_dataset(4,i)= betdot(i,1);    
end
%training_labels=labels';
training_labels = y';
