function avg = mValue(X)
    total = sum(X(:));
    len = length(X(:));
    avg = total / len;
end
