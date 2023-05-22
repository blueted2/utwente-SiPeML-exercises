%%%% ex2.m: SiPe exercise 2

%% Initialize variables of system Gd1(s). Note that ex1.m must be available!

% load configuration variables from ex1
ex1_variables

Gc=tf(zpk(z,p,k));

Ts1 = 0.01;
fs = 1 / Ts1;

%% Prepare and plot transfer function
G0 = c2d(Gc, Ts1, 'zoh');
pzmap(G0);


%% Create idpoly
[nd,dd,ts] = tfdata(G0,'v');
g0 = idpoly(dd,nd,1,1,1,0.05^2,ts);

% generate input u ..
u  = idinput(4096,'prbs');
% .. and disturbance e
e  = randn(4096,1);

% simulate system with disturbance ..
y  = sim(g0, [u e]);
% .. and without disturbance
y0 = sim(g0, [u 0*e]);

% convert to format more compatible with systemIdentification
g0dat = iddata(y,u,ts);

%% a. Qualifying the whiteness of our signals

% - in time domain

% calculate auto-covariance for u and e
[u_auto_cov, u_lags] = xcov(u);
[e_auto_cov, e_lags] = xcov(e);

[u_auto_cov_50, u_lags_50] = xcov(u, u, 50);
[e_auto_cov_50, e_lags_50] = xcov(e, e, 50);

figure('Name', 'Input auto-covariances')
tiledlayout(2, 2);

nexttile;
plot(u_lags, u_auto_cov);
title('u auto-covariance - all');

nexttile;
plot(u_lags_50, u_auto_cov_50);
title('u auto-covariance - 50');

nexttile;
plot(e_lags, e_auto_cov);
title('e auto-covariance - all');

nexttile;
plot(e_lags_50, e_auto_cov_50);
title('e auto-covariance - 50');


% - frequency domain
u_fft = fft(u);
e_fft = fft(e);


figure('Name', 'Spectral')
tiledlayout(2, 1);

n = length(u_fft);
f = (0:n-1)*(fs/n);

u_power = abs(u_fft).^2/n;
e_power = abs(e_fft).^2/n;

nexttile;
loglog(f,u_power)
title('u');
xlabel('Frequency')
ylabel('Power')

nexttile;
loglog(f,e_power)
title('e');
xlabel('Frequency')
ylabel('Power')


%% b. Impulse response estimation
[Ryu, lags] = xcov(y, u, 50);
Ry0u = xcov(y0, u, 50);

Ryu = Ryu(51: 101);
Ry0u = Ry0u(51: 101);

lags = lags(length(lags) / 2: length(lags));

u_variance = xcov(u, u, 0) * Ts1;

imp = Ryu ./ u_variance;
imp0 = Ry0u ./ u_variance;

[g0_50, tOut] = impulse(G0, 50 * Ts1);
tOut = tOut / Ts1;

figure('Name', 'impulse')
plot(lags, imp, lags, imp0, tOut, g0_50);
legend('from y', 'from y0', 'ground truth')


%% c. Spectrum estimate
figure;
tiledlayout(2, 1);
G0_e_estim = fft(y) ./ fft(u);
G0_estim = fft(y0) ./ fft(u);

f = (0:length(G0_e_estim) - 1) / length(G0_estim) * fs;

nexttile;
plot(f, abs(G0_e_estim));
title("with noise");

nexttile;
plot(f, abs(G0_estim));
title("without noise");

figure;
h = bodeplot(G0);
setoptions(h,'FreqScale','linear','FreqUnits','Hz','Grid','on', 'MagUnits', 'abs');





