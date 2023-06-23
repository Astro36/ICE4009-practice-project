A = 5;
B = 15;
N = 1000;
avg = 10;
stdev = sqrt(3);
R = 20;

G = avg + randn(1, N) * stdev;

resol = (B - A) / R;
X1 = (A:resol:B - resol) + (resol / 2);
M1 = zeros(1, R);

for i = 1:N
    if G(i) >= A && G(i) < B
        idx = floor((G(i) - A) / resol) + 1;
        M1(idx) = M1(idx) + 1;
    end
end

G_avg = sum(G) / N;
G_var = sum((G - G_avg) .^ 2) / N;
G_stdev = sqrt(G_var);
fprintf('avg: %f, var: %f\n', G_avg, G_var)

x = A:0.1:B;
G_new = 1 / (stdev * sqrt(2 * pi)) * exp(-1/2 * ((x - avg) ./ stdev) .^ 2);

hold on;
PDF = M1 / N / resol;
bar(X1, PDF)

CDF = cumsum(PDF * resol);
plot(X1, CDF, '-o', 'LineWidth', 1)

plot(x, G_new)

title('Gaussian Distribution')
xlabel('X')
ylabel('Probability')
legend('PDF', 'CDF', 'f(x)')
hold off;
