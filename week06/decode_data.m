% Original Signal
f_s = 22050; % sampling frequency
t_start = 0; % sampling start time
t_end = 5.5; % sampling end time

t_s = 1 / f_s; % sampling interval
t = t_start:t_s:t_end;

% Sampled Signal
f2_s = 11025; % sampling frequency

t2_s = 1 / f2_s; % sampling interval
t2 = t_start:t2_s:(t_end - t2_s);

% Load x_en
load('encode_data.mat')

% Quantization
A_max = 1;
A_min = -1;
Q_level = 64;
Q_step = (A_max - A_min) / Q_level;

% Decode
tmp2 = reshape(x_en, log2(Q_level), length(t2))';
x_de = zeros(1, length(t2));
for idx = 1:length(t2)
    x_de(idx) = Q_step * (bin2dec(tmp2(idx, :)) - (Q_level / 2) + 0.5);
end

% Reconstructed Signal
y = zeros(1, length(t));
for idx = 1:length(t2)
    y = y + (x_de(idx) * sinc((t - (t(1) + (idx - 1) * t2_s)) / t2_s));
    progress = idx / length(t2) * 100
end

audiowrite('data.wav', y, f_s);
