clc
clear all

x1 = 0.1 : 1/22:1;
x2 = 0.1 : 1/22:1;
d = (1 + 0.6 * sin (2 * pi * x1 / 0.7) + 0.3 * sin (2 * pi * x2)) / 2;
[xa1, xa2] = meshgrid(x1, x2);
datv=(1 + 0.6 * sin (2 * pi * xa1 / 0.7) + 0.3 * sin (2 * pi * xa2)) / 2;
surf(xa1, xa2, datv)
%% Pradinių parametrų reikšmių pasirinkimas

eta=0.01;

% 1 sluoksnis

w11_1=rand(1);  b1_1=rand(1); 
w21_1=rand(1);  b2_1=rand(1);
w31_1=rand(1);  b3_1=rand(1);
w41_1=rand(1);  b4_1=rand(1);

w12_1=rand(1);
w22_1=rand(1);
w32_1=rand(1);
w42_1=rand(1);

% 2 sluoksnis

w11_2=rand(1); b1_2=rand(1);
w12_2=rand(1);
w13_2=rand(1);
w14_2=rand(1);

%% Tinklo atsako skaičiavimas

for k = 1: 100000
    for t_t=1:20
    for t = 1:20

        % 1 sluoksnis
    
        v1_1=w11_1*x1(t_t)+w12_1*x2(t)+b1_1;
        v2_1=w21_1*x1(t_t)+w22_1*x2(t)+b2_1;
        v3_1=w31_1*x1(t_t)+w32_1*x2(t)+b3_1;
        v4_1=w41_1*x1(t_t)+w42_1*x2(t)+b4_1;
    
        y1_1=(1)/(1+exp(-v1_1));
        y2_1=(1)/(1+exp(-v2_1));
        y3_1=(1)/(1+exp(-v3_1));
        y4_1=(1)/(1+exp(-v4_1));
        
        % 2 sluoksnis

        v1_2=y1_1*w11_2+y2_1*w12_2+y3_1*w13_2+y4_1*w14_2+b1_2;
        y=v1_2;

        % Klaidos skaičiavimas

        e=datv(t_t, t)-y;

        % Ryšių svorių atnaujinimas

        Delta_out=e;
        Delta_1=y1_1*(1-y1_1)*w11_2*Delta_out;
        Delta_2=y2_1*(1-y2_1)*w12_2*Delta_out;
        Delta_3=y3_1*(1-y3_1)*w13_2*Delta_out;
        Delta_4=y4_1*(1-y4_1)*w14_2*Delta_out;

        % 1 sluoksnis

        w11_1=w11_1+eta*Delta_1*x1(t_t);
        w21_1=w21_1+eta*Delta_2*x1(t_t);
        w31_1=w31_1*eta*Delta_3*x1(t_t);
        w41_1=w41_1*eta*Delta_4*x1(t_t);

        w12_1=w12_1+eta*Delta_1*x2(t);
        w22_1=w22_1+eta*Delta_2*x2(t);
        w32_1=w32_1+eta*Delta_3*x2(t);
        w42_1=w42_1+eta*Delta_4*x2(t);

        b1_1=b1_1+eta*Delta_1;
        b2_1=b2_1+eta*Delta_2;
        b3_1=b3_1+eta*Delta_3;
        b4_1=b4_1+eta*Delta_4;

        % 2 sluoksnis

        w11_2=w11_2+eta*Delta_out*y1_1;
        w12_2=w12_2+eta*Delta_out*y2_1;
        w13_2=w13_2+eta*Delta_out*y3_1;
        w14_2=w14_2+eta*Delta_out*y4_1;

        b1_2=b1_2+eta*Delta_out;

    end
    end
end

%Testavimas

x1_t=0.1 : 1/50:1;
x2_t=0.1 : 1/50:1;
%y_t=(1 + 0.6 * sin (2 * pi * x1_t / 0.7) + 0.3 * sin (2 * pi * x2_t)) / 2;
[x1a_t, x2a_t] = meshgrid(x1_t, x2_t);
datv_t=(1 + 0.6 * sin (2 * pi * xa1 / 0.7) + 0.3 * sin (2 * pi * xa2)) / 2;
ee=0;

 % 1 sluoksnis

 for ttt = 1:46
 for tt = 1:46
    
        v1_1=w11_1*x1_t(ttt)+w12_1*x2_t(tt)+b1_1;
        v2_1=w21_1*x1_t(ttt)+w22_1*x2_t(tt)+b2_1;
        v3_1=w31_1*x1_t(ttt)+w32_1*x2_t(tt)+b3_1;
        v4_1=w41_1*x1_t(ttt)+w42_1*x2_t(tt)+b4_1;
    
        y1_1=(1)/(1+exp(-v1_1));
        y2_1=(1)/(1+exp(-v2_1));
        y3_1=(1)/(1+exp(-v3_1));
        y4_1=(1)/(1+exp(-v4_1));
        
        % 2 sluoksnis

        v1_2=y1_1*w11_2+y2_1*w12_2+y3_1*w13_2+y4_1*w14_2+b1_2;
        y=v1_2;
        y_t(ttt, tt)=y;
%         V=reshape(y_t, 45,45);

        % Klaidos skaičiavimas

%         ee=ee+abs(d(tt)-y);
 end
 end
hold on
 disp(ee)
figure(2)
surf(x1a_t, x2a_t, y_t)

%  figure(2)
%  plot(x1_t, y_t)
%  hold on
%  plot(x1, d)