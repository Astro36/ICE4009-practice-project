N = 1e5;

h = (randn(1, N) + 1j * randn(1, N)) / sqrt(2);
h_amp = sqrt(h .* conj(h));

h = 0:0.01:5;
dl = h(2) - h(1);
pdf = zeros(1, length(h));
for i = 1:length(h)
    for j = 1:length(h_amp)
        if (h_amp(j) >= h(1) + (i - 1) * dl && h_amp(j) < h(1) + i * dl)
            pdf(i) = pdf(i) + 1 / (length(h_amp) * dl);
        end
    end
end

var = 1/2;
P_h = abs(h) / var .* exp(-abs(h) .^ 2 / (2 * var));

grid on
hold on
plot(h, pdf, 'o')
plot(h, P_h)
xlabel('|h|')
ylabel('PDF')
legend('empirical', 'theoretical')
