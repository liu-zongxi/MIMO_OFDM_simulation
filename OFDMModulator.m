%-----------------------调制函数---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月6日21点11分-----------------%
function Frame_transmit = OFDMModulator(Frame_pilot, N_sym, N_subcarrier, N_symbol, N_Tx, N_GI)

Frame_transmit = zeros(1,N_sym*N_symbol,N_Tx);

for iant = 1:N_Tx
    % ifft乘sqrt(N_subc)以保证变换前后能量不变
    % 我们假设频域的样点是在[-fs/2  fs/2]中的, fs是采样频率
    % 使用fftshift函数目的是使得变换前的频域样点转换到[0 fs]中,以满足IFFT变换的要求
    Frame_TD = sqrt(N_subcarrier) * ifft( fftshift( Frame_pilot(:,:,iant), 1 ) );
    Frame_CP = Frame_TD(N_subcarrier - N_GI + 1:N_subcarrier ,:);
    Frame_withCP = [Frame_CP; Frame_TD];
    % 转换为串行信号
    Frame_transmit(:,:,iant) = reshape( Frame_withCP, 1, N_sym*N_symbol);
end
