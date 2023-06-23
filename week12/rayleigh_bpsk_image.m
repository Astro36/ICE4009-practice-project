Eb_No_dB = 10;
Eb_mW = 1;
Eb_dBm = pow2db(Eb_mW);
No_dBm = Eb_dBm - Eb_No_dB;
No_mW = db2pow(No_dBm);

image_original = imread("original.jpg");

image_height = size(image_original, 1);
image_width = size(image_original, 2);
image_channel = size(image_original, 3);
image_level = double(max(max(max(image_original))));
image_level_bin = ceil(log2(image_level));

image_vec = image_original(:);
image_bit = de2bi(image_vec);

bit_stream = image_bit(:);
N = length(bit_stream);

symbol = double(bit_stream) * 2 - 1; % symbol: -1 or 1

h = (randn(N, 1) + 1j * randn(N, 1)) / sqrt(2);
noise = sqrt(No_mW/2) * (randn(N, 1) + 1j * randn(N, 1)); % noise

y = symbol .* h + noise;

r = conj(h) ./ (abs(h) .^ 2) .* y;
bit_stream_re = real(r) > 0;

image_bit_re =  reshape(bit_stream_re, [image_height * image_width * image_channel, image_level_bin]);
image_vec_re = bi2de(image_bit_re);
image_re = uint8(reshape(image_vec_re, [image_height, image_width, image_channel]));

imshow(image_re);
