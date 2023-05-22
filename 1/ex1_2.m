%%%% ex1.m: SiPe exercise 1

clf;
close all;

%% Initialize variables of system Gc(s):

z = [       3+100i;  3-100i; -141+141i; -141-141i ];
p = [ -80; -10+60i; -10-60i;  -45+120i;  -45-120i ];
k = 25;

%% Create continuous-time system and discrete-time systems:

% Use tf() and/or zpk() to create Gc
%  Gc = ...;
% Gc = tf(z.', p.');
Gc = zpk(z, p, k);


% Use c2d() to create Gd1 and Gd2
Ts1 = 0.01; Ts2 = 0.04;
% Gd1 = c2d(...);
% Gd2 = c2d(...);
Gd1 = c2d(Gc, Ts1);
Gd2 = c2d(Gc, Ts2);

%% Simulations

% Use lsim() to simulate the output y from input u at time instances t.
% So create a vector with the time instances:
%    t1 = begin:step:end;
% and input
%    u1 = sin(...) or gensig(...);
% to call 
%    y1 = lsim(...);
% Etcetera.

tau = 2 * pi;

% number of periods to evaluate
p = 10;

f1 = 5;
f2 = 10;
f3 = 15;

% 0 to whathever t gives 5 periods of fN
% for Ts1 = 0.01
t1_1 = 0:Ts1:p / f1;
t2_1 = 0:Ts1:p / f2;
t3_1 = 0:Ts1:p / f3;

% for Ts2 = 0.04
t1_2 = 0:Ts2:p / f1;
t2_2 = 0:Ts2:p / f2;
t3_2 = 0:Ts2:p / f3;

u1_1 = sin(t1_1 * tau * f1);
u2_1 = sin(t2_1 * tau * f2);
u3_1 = sin(t3_1 * tau * f3);

u1_2 = sin(t1_2 * tau * f1);
u2_2 = sin(t2_2 * tau * f2);
u3_2 = sin(t3_2 * tau * f3);

yc1 = lsim(Gc, u1_1, t1_1);
yc2 = lsim(Gc, u2_1, t2_1);
yc3 = lsim(Gc, u3_1, t3_1);

yd1_1 = lsim(Gd1, u1_1, t1_1);
yd2_1 = lsim(Gd1, u2_1, t2_1);
yd3_1 = lsim(Gd1, u3_1, t3_1);

yd1_2 = lsim(Gd2, u1_2, t1_2);
yd2_2 = lsim(Gd2, u2_2, t2_2);
yd3_2 = lsim(Gd2, u3_2, t3_2);

%% Show results

tiledlayout(3,3);

nexttile;
plot(t1_1, yc1);
axis([0 inf -4 4]);
title('5 Hz continuous');

nexttile;
plot(t2_1, yc2);
axis([0 inf -4 4]);
title('10 Hz continuous');

nexttile;
plot(t3_1, yc3);
axis([0 inf -4 4]);
title('15 Hz continuous');

nexttile;
stairs(t1_1, yd1_1);
axis([0 inf -4 4]);
title('5 Hz disc. 0.01');

nexttile;
stairs(t2_1, yd2_1);
axis([0 inf -4 4]);
title('10 Hz disc. 0.01');

nexttile;
stairs(t3_1, yd3_1);
axis([0 inf -4 4]);
title('15 Hz disc. 0.01');

nexttile;
stairs(t1_2, yd1_2);
axis([0 inf -4 4]);
title('5 Hz disc. 0.04');

nexttile;
stairs(t2_2, yd2_2);
axis([0 inf -4 4]);
title('10 Hz disc. 0.04');

nexttile;
stairs(t3_2, yd3_2);
axis([0 inf -4 4]);
title('15 Hz disc. 0.04');

figure;

% With plot(...), bode(...), ...

h = bodeplot(Gc, Gd1, Gd2, {0, 100 * tau});
setoptions(h,'FreqScale','linear','FreqUnits','Hz','Grid','on', 'MagUnits', 'abs');

%% Impulse response
[imp_1, imp_t_1] = impulse(Gd1, 0.5);
[imp_2, imp_t_2] = impulse(Gd1, 1);
[imp_3, imp_t_3] = impulse(Gd1, 2);

figure;
tiledlayout(2,3);

nexttile;
plot(imp_t_1, imp_1);
title("Impulse 0.5");

nexttile;
plot(imp_t_2, imp_2);
title("Impulse 1");

nexttile;
plot(imp_t_3, imp_3);
title("Impulse 2");

fs = 1 / Ts1;

fft1 = fft(imp_1);
fft1_f = (0:length(fft1)-1)* fs / length(fft1);

fft2 = fft(imp_2);
fft2_f = (0:length(fft2)-1)* fs / length(fft2);

fft3 = fft(imp_3);
fft3_f = (0:length(fft3)-1)* fs / length(fft3);

nexttile;

plot(fft1_f, abs(fft1));
title("FFT 0.5s");
xlabel("f (Hz)");

nexttile;
plot(fft2_f, abs(fft2));
title("FFT 1s");
xlabel("f (Hz)");

nexttile;
plot(fft3_f, abs(fft3));
title("FFT 2s");
xlabel("f (Hz)");
