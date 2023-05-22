%%%% ex1.m: SiPe exercise 1

clf;
close all;
clear;

%% Global variables
tau = 2 * pi;

%% Initialize variables of system Gc(s):

z = [       3+100i;  3-100i; -141+141i; -141-141i ];
p = [ -80; -10+60i; -10-60i;  -45+120i;  -45-120i ];
k = 25;



%% Create continuous-time system and discrete-time systems:
Ts1 = 0.01; Ts2 = 0.04;

Gc = zpk(z, p, k);
Gd1 = c2d(Gc, Ts1);
Gd2 = c2d(Gc, Ts2);

Gs = {Gc, Gd1, Gd2};

%% Simulations

% number of periods to evaluate
p = 10;

freqs = [1, 2, 5, 10, 15, 20, 40];

G_params = cartesianProduct(Gs, freqs);
% rename columns to G, freq
G_params.Properties.VariableNames = {'G', 'freq'};


% for each row in params, simulate the system
for i = 1:height(G_params)
    G = G_params.G(i);
    G = G{1};
    freq = G_params.freq(i);

    % get sampling time from G. Set to 0.01 if equal to 0
    Ts = max(G.Ts, 0.01);

    t = 0:Ts:p / freq;
    u = sin(t * freq * tau);
    y = lsim(G, u, t);
    
    G_params.t{i} = t;
    G_params.u{i} = u;
    G_params.y{i} = y;
end


%% Show results

figure('Name', 'Individual frequency responses');

% create a tiled layout with enough rows for each G and enough columns for each freq
tiledlayout(length(Gs), length(freqs));

% for each row in params, plot the results in a tile and give a title with Ts and freq
for i = 1:height(G_params)
    nexttile;
    
    % check if G is discrete or continuous and add it to the title
    if G_params.G{i}.Ts == 0
        plot(G_params.t{i}, G_params.y{i});
        title(sprintf("Cont. %dHz", G_params.freq(i)));
    else
        stairs(G_params.t{i}, G_params.y{i});
        title(sprintf("Disc(%.2fs) %dHz", G_params.G{i}.Ts, G_params.freq(i)));
    end

    ylim([-4, 4]);
    xlabel("t (s)");
    ylabel("y");
end


%% Bode plots
figure('Name', 'Bode plots');

h = bodeplot(Gc, Gd1, Gd2, {0, 100 * tau});
legend('Continuous', 'Discrete 0.01s', 'Discrete 0.04s')
setoptions(h,'FreqScale','linear','FreqUnits','Hz','Grid','on', 'MagUnits', 'abs');

%% Impulse response


durations = [0.1, 0.5, 1, 2, 5];

figure('Name', 'Impulse responses and FFTs');
tiledlayout(2, length(durations));

% get the impulse response of Gd1 for each duration and save the result in a table
% with columns duration, imp and imp_t
% preallocate the table with height = length(durations)
imp_res = table('Size', [length(durations), 3], 'VariableTypes', {'double', 'double', 'cell'});

for i = 1:length(durations)
    nexttile;

    duration = durations(i);
    [imp, imp_t] = impulse(Gd1, duration);
    imp_res.duration(i) = duration;
    imp_res.imp(i) = {imp};
    imp_res.imp_t(i) = {imp_t};

    plot(imp_t, imp);
    title(sprintf("Imp. resp. %.2fs", duration));
end


fs = 1 / Ts1;

% for each row in imp_res, compute the fft and plot it
for i = 1:height(imp_res)
    imp = imp_res.imp{i};
    imp_t = imp_res.imp_t{i};

    fft_res = fft(imp) * fs;

    % normalize frequency with respect to time, not samples
    fft_f = (0:length(fft_res)-1) * fs / length(fft_res);

    nexttile;
    plot(fft_f, abs(fft_res));
    title(sprintf("FFT %.2fs", imp_res.duration(i)));
    xlabel("f (Hz)");
end