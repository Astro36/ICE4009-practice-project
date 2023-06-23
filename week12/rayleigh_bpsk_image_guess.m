r1 = conj(h) ./ (abs(h) .^ 2) .* y1;
bit_stream_re1 = real(r1) > 0;
image_bit_re1 = reshape(bit_stream_re1, [Width_ * Height_ * CH_, Level_binary]);
image_vec_re1 = bi2de(image_bit_re1);
image_re1 = uint8(reshape(image_vec_re1, [Height_, Width_, CH_]));

r2 = conj(h) ./ (abs(h) .^ 2) .* y2;
bit_stream_re2 = real(r2) > 0;
image_bit_re2 = reshape(bit_stream_re2, [Width_ * Height_ * CH_, Level_binary]);
image_vec_re2 = bi2de(image_bit_re2);
image_re2 = uint8(reshape(image_vec_re2, [Height_, Width_, CH_]));

r3 = conj(h) ./ (abs(h) .^ 2) .* y3;
bit_stream_re3 = real(r3) > 0;
image_bit_re3 = reshape(bit_stream_re3, [Width_ * Height_ * CH_, Level_binary]);
image_vec_re3 = bi2de(image_bit_re3);
image_re3 = uint8(reshape(image_vec_re3, [Height_, Width_, CH_]));

figure()
imshow(image_re1);
figure()
imshow(image_re2);
figure()
imshow(image_re3);
