syms Eb t Tb

f = 1 / Tb;
phi_t = sqrt(2 / Tb) * cos(2 * pi * f * t); % basis function

Eb_N0_dB = 3;

tic

N = 1000; % # of symbols
symbols = zeros(2, N);
symbol_errors = zeros(1, N);

for i = 1:N
    bit = rand() >= 0.5; % random binary bit

    if bit == 1
        s_t = sqrt(Eb) * phi_t;
    else
        s_t = -sqrt(Eb) * phi_t;
    end

    s_t_ = subs(s_t, Eb, 1); % set Eb = 1mW
    noise = sqrt(db2pow(-Eb_N0_dB) / 2) * randn() * phi_t; % noise
    x_t = s_t_ + noise;

    s = int(x_t * phi_t, t, [0 Tb]);

    % decision device
    if s > 0
        b_est = 1;
    else
        b_est = 0;
    end

    symbols(1, i) = s;
    symbol_errors(i) = (b_est ~= bit);
end

ber = sum(symbol_errors) / N
ber_awgn = 1/2 * erfc(sqrt(db2pow(Eb_N0_dB)))

toc

s1_t = sqrt(Eb) * phi_t;
s0_t = -sqrt(Eb) * phi_t;

s1_t_ = subs(s1_t, Eb, 1);
c1_ = int(s1_t_ * phi_t, t, [0 Tb]);
s0_t_ = subs(s0_t, Eb, 1);
c0_ = int(s0_t_ * phi_t, t, [0 Tb]);

grid on
hold on
plot(c1_, 0, 'o', 'markersize', 15, 'markerEdgeColor', 'b', 'MarkerFaceColor', 'b')
plot(c0_, 0, 'o', 'markersize', 15, 'markerEdgeColor', 'b', 'MarkerFaceColor', 'b')
plot(symbols(1, find(symbol_errors)), symbols(2, find(symbol_errors)), 'x', 'markersize', 8, 'color', 'r', 'LineWidth', 2)
plot(symbols(1, setdiff(1:N, find(symbol_errors))), symbols(2, setdiff(1:N, find(symbol_errors))), 'o', 'markersize', 2, 'color', 'g')
set(gca, 'ytick', -1:2:1)
axis([-2 2 -0.1 0.1])
title(['BPSK constellation (E_b/N_0=', int2str(Eb_N0_dB), 'dB)'])
