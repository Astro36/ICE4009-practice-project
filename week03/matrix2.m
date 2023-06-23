A = [-8.5 0 5.5 -2.6 4.8;
     1.9 7.3 -3.3 0.4 -6;
     -0.5 -8.1 -1.5 3.1 1;
     -8.9 2.5 0.9 1.6 -0.5;
     3.6 0.6 -0.7 -2.6 4.6]

A_abs = abs(A);
B = sum(A_abs, 2)

C = A >= 0

D = A(find(A > 0))

E = (round(A) > A) - (round(A) < A)

F1 = sort(A(:))
F2 = reshape(F1, [5, 5])

G1 = A ^ 2
G2 = A .^ 2

[A_V, A_D] = eig(A)
k = rank(A)
