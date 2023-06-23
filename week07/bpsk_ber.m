syms Eb t Tb

f = 1 / Tb;
phi_t = sqrt(2 / Tb) * cos(2 * pi * f * t); % basis function

Eb_N0_dBs = -2:2:10;
bers = zeros(1, length(Eb_N0_dBs));
ber_awgns = zeros(1, length(Eb_N0_dBs));

tic

j = 1;
for Eb_N0_dB = -2:2:10
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

    bers(1, j) = sum(symbol_errors) / N
    ber_awgns(1, j) = 1/2 * erfc(sqrt(db2pow(Eb_N0_dB)))
    j = j + 1;
end

toc

hold on;
plot(Eb_N0_dBs, bers, '-x')
plot(Eb_N0_dBs, ber_awgns, '-o')
set(gca, 'yscale', 'log')
axis([-2 10 1e-5 1])
legend('BER(측정값)', 'BER AWGN(이론값)')
