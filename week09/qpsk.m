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

    % decision device
    reconstructed_bits = [real(decoded_symbol) > 0; imag(decoded_symbol) > 0];

    bit_error = sum(bits ~= reconstructed_bits);
    bit_errors(i) = bit_error; % error bit number
end

ser = sum(symbol_errors) / N
ber = sum(bit_errors) / (2 * N)
ser_ = erfc(sqrt(db2pow(Eb_No_dB)))
ber_ = berawgn(Eb_No_dB, 'psk', 4, 'nodiff')

grid on
hold on
qpsk_symbols = [1 1 -1 -1; 1 -1 1 -1];
plot(symbols(1, :), symbols(2, :), '*b', 'MarkerSize', 2)
plot(qpsk_symbols(1, :), qpsk_symbols(2, :), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
axis([-2 2 -2 2])
title(['Eb/No=' int2str(Eb_No_dB) 'dB'])
xlabel('In-phase')
ylabel('Quadrature')
