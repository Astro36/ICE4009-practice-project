Eb_No_dBs = 0:10;
bers = zeros(1, length(Eb_No_dBs));
sers = zeros(1, length(Eb_No_dBs));

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
        bits = rand(2, 1) >= 0.5; % random binary bit: 0 or 1
        encoded_bits = bits * 2 - 1; % random binary bit: -1 or 1

        Es_mW = 2 * Eb_mW; % symbol energy
        symbol = sqrt(Es_mW / 2) * (encoded_bits(1) + 1j * encoded_bits(2)); % QPSK

        noise = sqrt(No_mW / 2) * (randn() + 1j * randn()); % noise
        y = symbol + noise;

        symbols(:, i) = [real(y); imag(y)]; % generated symbol

        decoded_symbol = ((real(y) > 0) * 2 - 1) + 1j * ((imag(y) > 0) * 2 - 1);

        symbol_error = (symbol ~= decoded_symbol);
        symbol_errors(i) = symbol_error; % error symbol number

        reconstructed_bits = [real(decoded_symbol) > 0; imag(decoded_symbol) > 0]; % decision device

        bit_error = sum(bits ~= reconstructed_bits);
        bit_errors(i) = bit_error; % error bit number
    end

    bers(1, j) = sum(bit_errors) / (2 * N);
    sers(1, j) = sum(symbol_errors) / N;
    j = j + 1;
end

bers_ = berawgn(Eb_No_dBs, 'psk', 4, 'nodiff');
sers_ = 1 - (1 - bers_) .^ 2;

figure()
subplot(1, 2, 1)
grid on
hold on
plot(Eb_No_dBs, bers, '*')
plot(Eb_No_dBs, bers_)
set(gca, 'yscale', 'log')
axis([0 10 1e-5 1])
title('QPSK')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('BER(측정값)', 'BER(이론값)')

subplot(1, 2, 2)
grid on
hold on
plot(Eb_No_dBs, sers, '*')
plot(Eb_No_dBs, sers_)
set(gca, 'yscale', 'log')
axis([0 10 1e-5 1])
title('QPSK')
xlabel('Eb/No [dB]')
ylabel('SER')
legend('SER(측정값)', 'SER(이론값)')

figure()
grid on
hold on
plot(Eb_No_dBs, 1/2 * erfc(sqrt(db2pow(Eb_No_dBs))), '-o')
plot(Eb_No_dBs, bers_, '-x')
set(gca, 'yscale', 'log')
axis([0 10 1e-5 1])
title('BPSK vs QPSK')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('BPSK(이론값)', 'QPSK(이론값)')
