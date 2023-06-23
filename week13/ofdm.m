sample = 15;
mod_order = 2;

tx = randi([0 (mod_order - 1)], 1, sample);
tx_mod = qammod(tx, mod_order)';
tx_ifft = ifft(tx_mod) * sqrt(sample);
tx_ofdm = tx_ifft';

figure()
subplot(2, 1, 1)
stem(1:sample, tx_mod)
grid on
title('BPSK Symbols')
xlabel('frequency')
ylabel('value')

subplot(2, 1, 2)
plot(1:sample, tx_ifft, 'r')
grid on
title('BPSK Symbols after IFFT')
xlabel('time')
ylabel('amplitude')

rx_ofdm = tx_ofdm';
rx_fft = fft(rx_ofdm) / sqrt(sample);
rx = qamdemod(rx_fft, mod_order);

figure()
subplot(2, 1, 1)
hold on
stem(1:sample, tx_mod)
stem(1:sample, rx_fft, 'rx--')
grid on
xlabel('symbol')
ylabel('value')
legend('before IFFT', 'after FFT')

subplot(2, 1, 2)
hold on
stem(1:sample, tx)
stem(1:sample, rx, 'rx--')
grid on
xlabel('index')
ylabel('value')
legend('Tx', 'Rx')

max_pow = max(abs(tx_ofdm) .^ 2);
mean_pow = mean(abs(tx_ofdm) .^ 2);
PAPR = 10 * log10(max_pow / mean_pow)
