Eb_No_dB = 10;
Eb_mW = 1;
Eb_dBm = pow2db(Eb_mW);
No_dBm = Eb_dBm - Eb_No_dB;
No_mW = db2pow(No_dBm);

N = 10000; % # of symbols
symbols = zeros(2, N);
symbol_errors = zeros(1, N);
bit_errors = zeros(1, N);

for i = 1:N
    bit = rand() >= 0.5; % random binary bit: 0 or 1
    symbol = bit * 2 - 1; % random symbol: -1 or 1

    h = (randn() + 1j * randn()) / sqrt(2);
    noise = sqrt(No_mW/2) * (randn() + 1j * randn()); % noise

    y = symbol * h + noise;

    r = conj(h) / (abs(h) ^ 2) * y;
    bit_re = real(r) > 0;

    symbols(:, i) = [real(r); imag(r)]; % generated symbol

    bit_error = sum(bit_re ~= bit);
    bit_errors(i) = bit_error; % error bit number
end

ber = mean(bit_errors)
ber_ = 1/2 * (1-sqrt(db2pow(Eb_No_dB) / (db2pow(Eb_No_dB) + 1)))

grid on
hold on
bpsk_symbols = [1 -1; 0 0];
plot(symbols(1, :), symbols(2, :), 'sb', 'MarkerSize', 2)
plot(symbols(1, find(symbols(1,:) > 0)), symbols(2, find(symbols(1,:) > 0)), 'sk', 'MarkerSize', 2)
plot(bpsk_symbols(1, :), bpsk_symbols(2, :), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
axis([-2 2 -2 2])
title(['Eb/No=' int2str(Eb_No_dB) 'dB'])
