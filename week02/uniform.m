A = 2;
B = 3;
N = 10000;
R = 10;

U = A + rand(1, N) * (B - A);

% [M, X] = hist(U, R)
% resol = X(2) - X(1);
resol = (B - A) / R;
X1 = (A:resol:B - resol) + (resol / 2);
M1 = zeros(1, R);

for i = 1:N
    idx = floor((U(i) - A) / resol) + 1;
    M1(idx) = M1(idx) + 1;
end

U_avg = sum(U) / N;
fprintf('avg: %f\n', U_avg)

hold on;
PDF = M1 / N / resol;
bar(X1, PDF)

CDF = cumsum(PDF * resol);
plot(X1, CDF, '-o', 'LineWidth', 1)

title('Uniform Distribution')
xlabel('X')
ylabel('Probability')
legend('PDF', 'CDF')
hold off;
