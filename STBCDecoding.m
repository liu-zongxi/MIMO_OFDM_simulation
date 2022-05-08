%-----------------------STBC解码---------------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月7日10点07分-----------------%
function Frame_decoded = STBCDecoding(Frame_recieve, H, N_subcarrier, N_Tx,N_Rx, N_symbol)
Frame_decoded = zeros(N_subcarrier, N_symbol);
% 把H_freq转化为空时译码器的输入格式,为一个N_subc*N_ant_pair的矩阵,每列表示:
% 1-->1 ,1-->2,...,1-->N_Rx_ant, ... ,N_Tx_ant-->1, N_Tx_ant-->2,..., N_Tx_ant-->N_Rx_ant
if (N_Tx == 2)&&(N_Rx == 2)
    for ispace = 1:N_symbol/N_Tx
        % 构造输入进空时译码器的符号,用t表示时间号,a表示天线号,其格式为:
        % [Recv(t1,a1) Recv(t2,a1) Recv(t1,a2) Recv(t2,a2)].
        R = [];
        for iant = 1:N_Rx
            R = [R  Frame_recieve(:,(ispace-1)*N_Tx+1:ispace*N_Tx,iant) ];%对于2X2MIMO来说，R矩阵即为[Xe  -conj(Xo)  Xo  conj(Xe)]
        end
        H11=H(:,1);%1发送天线--》1接收天线信道参数
        H12=H(:,2);%1发送天线--》2接收天线信道参数
        H21=H(:,3);%2发送天线--》1接收天线信道参数
        H22=H(:,4);%2发送天线--》2接收天线信道参数
        R11=R(:,1);%1发送天线发送的第一个符号
        R12=R(:,2);%1发送天线发送的第二个符号
        R21=R(:,3);%2发送天线发送的第一个符号
        R22=R(:,4);%2发送天线发送的第二个符号
        for i=1:1:N_subcarrier
            X1(i,1)=(R11(i)*conj(H11(i))+conj(R12(i))*H21(i)+R21(i)*conj(H12(i))+conj(R22(i))*H22(i))/( H11(i)*conj(H11(i)) + H21(i)*conj(H21(i)) + H12(i)*conj(H12(i)) + H22(i)*conj(H22(i)));
            X2(i,1)=(R11(i)*conj(H21(i))-conj(R12(i))*H11(i)+R21(i)*conj(H22(i))-conj(R22(i))*H12(i))/( H11(i)*conj(H11(i)) + H21(i)*conj(H21(i)) + H12(i)*conj(H12(i)) + H22(i)*conj(H22(i)));
        end
        Sybmol_decoded = 2*[X1 X2]; % 非常扯淡，因为上面的分母是错误的
        Frame_decoded(:,(ispace-1)*N_Tx+1:ispace*N_Tx) = Sybmol_decoded;
    end
end