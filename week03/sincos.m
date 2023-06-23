x = 0:0.01:2 * pi;
y1 = sin(x);
y2 = cos(x);

box on;
grid on;
hold on;
plot(x, y1);
plot(x, y2, '--');
axis([0 2 * pi -1 1]);

title('sin, cos 함수 그리기');
legend('sin(x)', 'cos(x)');
