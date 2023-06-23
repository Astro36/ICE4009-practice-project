Eb_No_dBs = -10:5:30;
bers = zeros(1, length(Eb_No_dBs));

j = 1;

for Eb_No_dB = Eb_No_dBs
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
        noise = sqrt(No_mW / 2) * (randn() + 1j * randn()); % noise

        y = symbol * h + noise;

        r = conj(h) / (abs(h) ^ 2) * y;
        bit_re = real(r) > 0;

        symbols(:, i) = [real(r); imag(r)]; % generated symbol

        bit_error = sum(bit_re ~= bit);
        bit_errors(i) = bit_error; % error bit number
    end

    bers(1, j) = mean(bit_errors);
    j = j + 1;
end

bers_ = 1/2 * (1 - sqrt(db2pow(Eb_No_dBs) ./ (db2pow(Eb_No_dBs) + 1)));

grid on
hold on
plot(Eb_No_dBs, bers, '*')
plot(Eb_No_dBs, bers_)
set(gca, 'yscale', 'log')
axis([-10 30 1e-4 1])
title('Rayleigh fading BPSK')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('BER(측정값)', 'BER(이론값)')
