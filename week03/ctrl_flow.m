A = randi(100, [1, 100])

A1 = A;
for i = 1:length(A1)
    [val, idx] = min(A1);
    B(i) = val;
    A1(idx) = 1000;
end
B

A1 = A;
i = 1;
while i <= length(A1)
    [val, idx] = max(A1);
    C(i) = val;
    A1(idx) = 0;
    i = i + 1;
end
C

D = zeros([1, 3]);
for i = 1:length(A)
    if 1 <= A(i) && A(i) <= 33
        D(1) = D(1) + 1;
    elseif 34 <= A(i) && A(i) <= 66
        D(2) = D(2) + 1;
    elseif 67 <= A(i) && A(i) <= 100
        D(3) = D(3) + 1;
    end
end
D
