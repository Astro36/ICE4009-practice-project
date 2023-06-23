% Original Signal
f_s = 1000; % sampling frequency
t_start = 0; % sampling start time
t_end = 60; % sampling end time

t_s = 1 / f_s; % sampling interval
t = t_start:t_s:t_end;

x = 2 * cos(6 * pi * t) + cos(8 * pi * t); % original signal

X = abs(fftshift(fft(x))); % X(f) = FT{x(t)}
X_f = linspace(-f_s / 2, f_s / 2, length(x));

% Sampled Signal
f2_s = 10; % sampling frequency

t2_s = 1 / f2_s; % sampling interval
t2 = t_start:t2_s:t_end;

x2 = x(1:floor(t2_s / t_s):length(t)); % Sampled signal

x3 = zeros(size(x)); % Sampled signal (same length)
for idx = 1:length(x)
    if mod(idx, floor(t2_s / t_s)) == 1
        x3(idx) = x(idx);
    end
end

X3 = abs(fftshift(fft(x3))); % X3(f) = FT{x3(t)}
X3_f = linspace(-f2_s / 2, f2_s / 2, length(x3));

% Reconstructed Signal
y = zeros(length(t2), length(t));
for idx = 1:length(t2)
    y(idx, :) = x2(idx) * sinc((t - (t(1) + (idx - 1) * t2_s)) / t2_s);
end
y = sum(y);

Y = abs(fftshift(fft(y))); % Y(f) = FT{y(t)}
Y_f = linspace(-f_s / 2, f_s / 2, length(y));

figure()
subplot(3, 1, 1)
plot(t, x)
axis([0 2 -4 4])
legend('Original')
subplot(3, 1, 2)
stem(t2, x2)
axis([0 2 -4 4])
legend('Sampled')
subplot(3, 1, 3)
plot(t, y)
axis([0 2 -4 4])
legend('Reconstructed')

figure()
subplot(3, 1, 1)
stem(X_f, X)
legend('Original')
xlim([0 10])
subplot(3, 1, 2)
stem(X_f, X3)
legend('Sampled')
xlim([0 10])
subplot(3, 1, 3)
stem(Y_f, Y)
legend('Reconstructed')
xlim([0 10])
