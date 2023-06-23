function num = countNum(in, gap)
    N = length(in);
    R = length(gap);
    step = gap(2) - gap(1);
    num = zeros(1, R);
    for i = 1:N
        idx = floor((in(i) - gap(1)) / step) + 1;
        if idx >= 1 && idx <= R
            num(idx) = num(idx) + 1;
        end
    end
end
