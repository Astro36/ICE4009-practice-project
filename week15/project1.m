r = conj(h) ./ (abs(h) .^ 2) .* y;

bit_stream_re = pskdemod(r, 2, pi); % BPSK: % 1+0j -> 1, -1+0j -> 0

image_bit_re = reshape(bit_stream_re, [Height_ * Width_ * RGB_CH, Level_binary]);
image_vec_re = bi2de(image_bit_re);
image_re = uint8(reshape(image_vec_re, [Height_, Width_, RGB_CH]));

figure()
imshow(image_re);

% image_re_top = image_re(1:25, :, :);
% figure()
% imshow(image_re_top);

N = Width_ * 25;
ber = sum(~bit_stream_re(1:N)) / N

Eb_No = (1 - 4 * ber + 4 * (ber ^ 2)) / (4 * ber - 4 * (ber ^ 2));
Eb_No_dB = pow2db(Eb_No)

% bers_ = 1/2 * (1 - sqrt(db2pow(Eb_No_dB) / (db2pow(Eb_No_dB) + 1)))
