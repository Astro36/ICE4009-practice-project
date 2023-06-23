% OFDM symbols
rx_symbols = reshape(y', [], N_OFDM_symbols)';

symbols = zeros(N_OFDM_symbols, nSubcarrier);
for t = 1:N_OFDM_symbols
    rx_ofdm = rx_symbols(t, :);

    % CP removing
    rx_signal = rx_ofdm((nSampGI + 1):end);

    % S/P
    rx_signal = rx_signal';

    % FFT
    rx_fft = fft(rx_signal, nFFTSize) / sqrt(nFFTSize);

    % Data de-mapping
    rx_demap = rx_fft(subcarrierIndex);

    % P/S
    rx_demap = rx_demap';

    % BPSK demodulation
    rx = pskdemod(rx_demap, modOrder, pi); % 1+0j -> 1, -1+0j -> 0

    symbols(t, :) = rx;
end
symbols = symbols';

x_en = symbols(:);
x_en = x_en(1:end - 2); % drop last 2 bits

% De-quantization
Q_level = 64;

x_de = bin2dec(num2str(reshape(x_en, log2(Q_level), [])'));
x_s = zeros(size(x_de));
for t = 1:length(x_de)
    x_s(t) = Sampling_values(x_de(t) + 1);
end

% Reconstruction
t_start = 0; % sampling start time
t_end = 7.4; % sampling end time
t_s = 1 / Sampling_frequency; % sampling interval
t = t_start:t_s:t_end;

x = zeros(1, length(t));
for idx = 1:length(x_s)
    x = x + sinc(t / t_s - (idx - 1)) * x_s(idx);
end
x(x < -1) = -1; % normalization: -1 < x < 1 

audiowrite('project2.wav', x, Sampling_frequency);
