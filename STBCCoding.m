%-----------------------STBC时空块码-----------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月5日15点52分-----------------%
function Frame_STBC = STBCCoding(Frame_mod, N_subcarrier, N_symbol, N_Tx)
Frame_STBC = zeros(N_subcarrier, N_symbol, N_Tx);
if (mod(N_symbol,N_Tx))
    error('空时编码器输入符号不匹配,子程序st_coding出错');
else
    for ispace = 1:N_symbol/N_Tx
        if N_Tx == 2
            X1=Frame_mod(:,(ispace-1)*N_Tx+1);%取第一列，即第一个OFDM符号
            X2=Frame_mod(:,(ispace-1)*N_Tx+2);%取第二列，即第二个OFDM符号
            Symbol_STBC = [X1 X2;-conj(X2) conj(X1)];%alamouti编码
        elseif N_Tx == 4
            X1=Frame_mod(:,(ispace-1)*N_Tx+1);%取第一列，即第一个OFDM符号
            X2=Frame_mod(:,(ispace-1)*N_Tx+2);%取第二列，即第二个OFDM符号
            X3=Frame_mod(:,(ispace-1)*N_Tx+3);%取第一列，即第一个OFDM符号
            X4=Frame_mod(:,(ispace-1)*N_Tx+4);%取第二列，即第二个OFDM符号
            Symbol_STBC = [ X1 X2 X3  X4;...
                            -X2 X1 -X4 X3;...
                            -X3 X4 X1 -X2;...
                            -X4 -X3 X2 X1;...
                            conj(X1) conj(X2) conj(X3) conj(X4);...
                            -conj(X2) conj(X1) -conj(X4) conj(X3);...
                            -conj(X3) conj(X4) conj(X1) -conj(X2);...
                            -conj(X4) -conj(X3) conj(X2) conj(X1)];
        end
        for iant = 1:N_Tx
            Symbol_STBC_per_ant = reshape(Symbol_STBC(:,iant), N_subcarrier, N_Tx);
            Frame_STBC(:, (ispace-1)*N_Tx+1:ispace*N_Tx, iant) = Symbol_STBC_per_ant;
        end
    end
end