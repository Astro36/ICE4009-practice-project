% Original Signal
f_s = 1000; % sampling frequency
t_start = 0; % sampling start time
t_end = 10; % sampling end time

t_s = 1 / f_s; % sampling interval
t = t_start:t_s:t_end;

x = 2 * sin(4 * pi * t) + cos(6 * pi * t); % original signal

% Sampled Signal
f2_s = 10; % sampling frequency

t2_s = 1 / f2_s; % sampling interval
t2 = t_start:t2_s:t_end;

x2 = x(1:floor(t2_s / t_s):length(t)); % Sampled signal

subplot(3, 1, 1)
plot(t, x)
hold on
stem(t2, x2)
axis([0 1 -3 3])
legend('Original', 'Sampled')

% Quantization
A_max = max(x2);
A_min = min(x2);
Q_level = 64;
Q_step = (A_max - A_min) / Q_level;

xq_level = min(floor((x2 - A_min) / Q_step), Q_level - 1);
xq = (xq_level * Q_step) + A_min;

tmp = dec2bin(xq_level);
xe = reshape(tmp, 1, numel(tmp));

% Send: xe
% ...
% Receive: tmp2

tmp2 = reshape(xe, length(t2), log2(Q_level));
xd = Q_step * (bin2dec(tmp2) - (Q_level / 2) + 0.5);

subplot(3, 1, 2)
stem(t2, x2)
hold on
stem(t2, xd)
axis([0 1 -3 3])
legend('Sampled', 'Quantized')

% Reconstructed Signal
y = zeros(length(t2), length(t));
for idx = 1:length(t2)
    y(idx, :) = xd(idx) * sinc((t - (t(1) + (idx - 1) * t2_s)) / t2_s);
end
y = sum(y);

subplot(3, 1, 3)
plot(t, x, t, y)
axis([0 1 -3 3])
legend('Original', 'Reconstructed')
