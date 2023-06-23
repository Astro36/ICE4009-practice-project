t = 0:0.01:2 * pi;

x = cos(t);
y = sin(t);

f = figure();
f.Position(3:4) = [840 420];

subplot(2, 2, 1);
plot(t, x, 'r');
axis([0 2 * pi -1 1]);
subtitle('x=cos(t)');

subplot(2, 2, 3);
plot(t, y, 'b');
axis([0 2 * pi -1 1]);
subtitle('y=sin(t)');

subplot(2, 2, [2, 4]);
plot(x - 1, 2 * y, 'k--');
grid on;
xticks(-3:0.5:1)
axis([-3 1 -3 3]);
subtitle('Ellipse');
legend('(x-1)^2+y^2/4=1')
