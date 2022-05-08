%-----------------------OFDM的接收---------------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月5日16点35分-----------------%
function Frame_recieve = OFDMDemodulator(Frame_noise, N_sym, N_subcarrier,N_symbol,N_Rx, N_GI)
Frame_recieve = zeros(N_subcarrier,N_symbol,N_Rx);

for iant = 1:N_Rx
    Frame_symbol = reshape(Frame_noise(1,:,iant), N_sym, N_symbol);
    Frame_noGI = Frame_symbol(N_GI+1:end, :);
    % fft乘1/sqrt(N_subc)以保证变换前后能量不变
    % 我们假设频域的样点是在[-fs/2  fs/2]中的, fs是采样频率
    % fftshift目的是使得变换后的频域样点在[-fs/2  fs/2]中,而不是[0 fs]中
    Frame_recieve(:,:,iant) = fftshift(1/sqrt(N_subcarrier) * fft( Frame_noGI ), 1);
end
% Frame_recieve = Frame_FD(:, 1:N_symbol ,:);     % 数据OFDM符号, 包括导频符号