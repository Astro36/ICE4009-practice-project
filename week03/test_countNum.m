A = rand(1, 1000);
U = -5 + rand(1, 1000) * 10;
G = randn(1, 1000);

gap1 = 0:0.1:1;
numA = countNum(A, gap1)

gap2 = -5:0.1:5;
numU = countNum(U, gap2);
numG = countNum(G, gap2);

f = figure();
subplot(2, 1, 1);
hold on;
plot(gap2, numU);
plot(gap2, ones(1, 101) * 1000/100);
hold off;

subplot(2, 1, 2);
hold on;
plot(gap2, numG);
plot(gap2, 100 / sqrt(2 * pi) * exp(-1/2 * (gap2 .^ 2)));
