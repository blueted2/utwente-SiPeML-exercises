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
