Eb_No_dBs = 0:10;
bers = zeros(1, length(Eb_No_dBs));
papr = 0;

j = 1;

for Eb_No_dB = Eb_No_dBs
    sample = 8;
    mod_order = 2;

    N = 10000;

    for i = 1:N
        tx = randi([0 (mod_order - 1)], 1, sample);
        tx_mod = qammod(tx, mod_order)';
        tx_ifft = ifft(tx_mod) * sqrt(sample);
        tx_ofdm = tx_ifft';

        tx_awgn = awgn(tx_ofdm, Eb_No_dB);

        rx_ofdm = tx_awgn';
        rx_fft = fft(rx_ofdm) / sqrt(sample);
        rx = qamdemod(rx_fft, mod_order)';

        bers(1, j) = bers(1, j) + sum(tx ~= rx);
        papr = max(papr, pow2db(max(abs(tx_ofdm) .^ 2) / mean(abs(tx_ofdm) .^ 2)));
    end

    bers(1, j) = bers(1, j) / (N * sample);

    j = j + 1;
end

bers_ = 1/2 * erfc(sqrt(db2pow(Eb_No_dBs)));

grid on
hold on
plot(Eb_No_dBs, bers, '*')
plot(Eb_No_dBs, bers_)
set(gca, 'yscale', 'log')
axis([0 10 1e-4 1])
title('OFDM-BPSK with AWGN')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('BER(측정값)', 'BER(이론값)')

papr
papr_ = pow2db(sample)
