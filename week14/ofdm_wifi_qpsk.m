sample = 52;
mod_order = 4;

tx = randi([0 (mod_order - 1)], 1, sample);

% QPSK modulation
bits = log2(mod_order);
tx_mod = sqrt(bits) * pskmod(tx, mod_order);

% Data mapping
n_fft = 64;
tx_map = zeros([1 n_fft]);
subcarrier_idx = [-26:-1 1:26];
tx_map(subcarrier_idx + n_fft / 2 + 1) = tx_mod;

% S/P
tx_map = tx_map';

% IFFT
tx_ifft = ifft(tx_map, n_fft) * sqrt(n_fft);

% CP(Cyclic Prefix) insertion
n_cp = n_fft / 4;
tx_ofdm = [tx_ifft((n_fft - n_cp + 1):end); tx_ifft];

% P/S
tx_ofdm = tx_ofdm';

Eb_No_dBs = 0:10;
bers = zeros(1, length(Eb_No_dBs));
sers = zeros(1, length(Eb_No_dBs));

k = 1;

for Eb_No_dB = Eb_No_dBs
    No_mW = db2pow(-Eb_No_dB);
    N = 10000;

    for i = 1:N
        rx_ofdm = awgn(tx_ofdm, Eb_No_dB);

        % S/P
        rx_ofdm = rx_ofdm';

        % CP removing
        rx_signal = rx_ofdm((n_cp + 1):end);

        % FFT
        rx_fft = fft(rx_signal, n_fft) / sqrt(n_fft);

        % Data de-mapping
        rx_demap = rx_fft(subcarrier_idx + n_fft / 2 + 1);

        % P/S
        rx_demap = rx_demap';

        % QPSK demodulation
        rx = pskdemod(rx_demap, mod_order);

        bers(1, k) = bers(1, k) + sum(de2bi(tx) ~= de2bi(rx), 'all');
        sers(1, k) = sers(1, k) + sum(tx ~= rx);
    end

    bers(1, k) = bers(1, k) / (N * sample * bits);
    sers(1, k) = sers(1, k) / (N * sample);
    k = k + 1;
end

bers_ = berawgn(Eb_No_dBs, 'psk', mod_order, 'nodiff');
sers_ = 1 - (1 - bers_) .^ 2;

bers_bspk_ = berawgn(Eb_No_dBs, 'psk', 2, 'nodiff');

figure()
grid on
hold on
plot(Eb_No_dBs, bers, '*')
plot(Eb_No_dBs, bers_)
plot(Eb_No_dBs, bers_bspk_, 'o')
set(gca, 'yscale', 'log')
axis([0 10 1e-6 1])
title('IEEE802.11a(QPSK) with AWGN')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('BER(측정값)', 'BER(이론값, QPSK)', 'BER(이론값, BPSK)')

figure()
grid on
hold on
plot(Eb_No_dBs, sers, '*')
plot(Eb_No_dBs, sers_)
set(gca, 'yscale', 'log')
axis([0 10 1e-6 1])
title('IEEE802.11a(QPSK) with AWGN')
xlabel('Eb/No [dB]')
ylabel('BER')
legend('SER(측정값)', 'SER(이론값)')

f = figure();
f.Position = [680 0 560 800];
subplot(4, 1, 1)
grid on
stem(tx)
title('tx bits')
xlabel('bits')
ylabel('value')

subplot(4, 1, 2)
grid on
stem(tx_mod)
title('after QPSK modulation')
xlabel('symbols')
ylabel('value')

subplot(4, 1, 3)
grid on
stem(tx_ifft)
title('after IFFT')
xlabel('symbols')
ylabel('value')

subplot(4, 1, 4)
grid on
stem(tx_ofdm)
title('after CP insertion')
xlabel('symbols')
ylabel('value')

f = figure();
f.Position = [680 0 560 800];
subplot(4, 1, 1)
grid on
hold on
stem(tx_ofdm)
stem(rx_ofdm, '*')
title('after AWGN')
xlabel('symbols')
ylabel('value')

subplot(4, 1, 2)
grid on
hold on
stem(tx_ifft)
stem(rx_signal, '*')
title('after CP removing')
xlabel('symbols')
ylabel('value')

subplot(4, 1, 3)
grid on
hold on
stem(tx_map)
stem(rx_fft, '*')
title('after FFT')
xlabel('symbols')
ylabel('value')

subplot(4, 1, 4)
grid on
hold on
stem(tx)
stem(rx, '*')
title('after QPSK demodulation')
xlabel('bits')
ylabel('value')
