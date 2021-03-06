%-----------------------MIMO-OFDM主函数---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月5日10点11分-----------------%
clear;clf;
%% 参数设置

% 用户及天线设置
N_Tx = 2;
N_Rx = 2;
N_pair = N_Tx * N_Rx;   % 收发天线数目
N_user = 4;

% 包和帧设置
N_symbol = 10;     % 一帧中有几个OFDM符号
N_frame = 10;      % 一个包中有多少帧
N_subcarrier = 1024;% 这就是以往代码中的Nfft和Nk，这两者实际上是要相等的
index_used = [-300:-1 1:300];   % 一帧中使用的子载波，剩下的就是VC等了
index_pilot = [-300:25:-25 25:25:300];  % 导频所使用的子载波
index_data = IndexDataGenerator(index_used, index_pilot);% 数据使用的子载波
index_used = index_used + N_subcarrier/2 +1;    %使用的子载波坐标
index_pilot = index_pilot + N_subcarrier/2 +1;  %导频子载波坐标
index_data = index_data + N_subcarrier/2 +1;    %数据子载波坐标
N_used = length(index_used);              % 使用的子载波数 600
N_pilot = length(index_pilot);            % 导频的子载波数
N_data = length(index_data);              % 数据的个数
N_GI = N_subcarrier/4;                    % CP长度
N_sym = N_subcarrier + N_GI;              % 一帧的总长度

% 调制设置
N_mod = 4;          %调制方式选择，2--QPSK调制, 3--8PSK,4--16QAM调制,6--64QAM
M_mod = 2^N_mod;
E_symbol = 1;                 % 在QPSK, 16QAM调制方式下,符号能量都被归一化
E_bit = E_symbol/N_mod;          % 每比特能量

% 信噪比设置
EbN0s_dB = 0:2:20;
EbN0s = 10.^(EbN0s_dB/10);
N_EbN0 = length(EbN0s);

% 频率设置
%仿真参数选择的是LTE系统带宽为20MHz时参数
f_carrier = 5e9;                        %  载波频率(Hz)   5GHz
BW = 20e6;                              %  基带系统带宽(Hz) 10MHz
f_sample = 15.36e6;                     %  基带抽样频率 1024*15KHz=15360000Hz
T_sample = 1/f_sample;                  %  基带时域样点间隔(s)

%% 主函数
for iebn0 = 1:N_EbN0
    EbN0 = EbN0s(iebn0);
    var_noise = E_bit/(2*EbN0);   % 噪声样点的功率   No为单边功率 No=2*var_noise
    for iframe = 1:N_frame
        %%%%%%%%%%%%%%%%%%%%%%%%%发射机%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 生成比特,得到 (Nmod*Ndata*Nsymbol/N_user, N_user)
        Frame_bit = FrameBitGenerator(N_data, N_user, N_mod, N_symbol);
        % 信道编码,无
        Frame_bit_coded = Frame_bit;%无信道编码，RS码，卷积码等
        % 子载波分配, 给每个用户分配子载波
        % index_data_per_user被分为了（N_data/N_user, N_user）
        % Frame_zero_padding变为了(N_mod * N_data / N_user * N_symbol, N_user)
        % 实际上是一样的，因为我们自己填满了
        [index_data_per_user, Frame_zero_padding]=SubcarrierAllocation(Frame_bit_coded, index_data, N_data, N_user,N_symbol, N_mod, "neighbour");
        % 调制,Frame的大小是(N_subcarrier, Nsymbol)
        % 但实际大小是（N_data/N_user*N_user,N_symbol）
        % 因为只有这部分子载波被使用了
%         Frame_zero_padding = cell(1,4);
%         for ii = 1:4
%             data = randi([0,1], 5760, 1);
%             % data = [ones(5760/2,1); zeros(5760/2,1)];
%             % data = zeros(5760,1);
%             Frame_zero_padding{ii} = data;
%         end
        Frame_mod = Modulator(Frame_zero_padding, index_data_per_user, N_data, N_user, N_symbol, N_mod, N_subcarrier);
        % 空时编码
        Frame_STBC = STBCCoding(Frame_mod, N_subcarrier, N_symbol, N_Tx);
        % 插入导频
        Frame_pilot = AddPilot(Frame_STBC, index_pilot, N_symbol, N_Tx);
        % OFDM调制,加循环前缀，加前导序列. 如果使用发送分集,则输出多条天线的信号
        %%%%%实际函数中不添加前导序列
        Frame_transmit = OFDMModulator(Frame_pilot, N_sym, N_subcarrier, N_symbol, N_Tx, N_GI);
        %%%%%%%%%%%%%%%%%%%%%%%%%信道%%%%%%%%%%%%%%%%%%%%%%%%%%
        H = ones(N_subcarrier, N_Tx*N_Rx);
        Power_transmit = var(Frame_transmit);%发送信号功率
        N_noise = size(Frame_transmit,2);
        noise = NoiseGenerator(EbN0, Power_transmit, N_noise);
        Frame_noise = Frame_transmit+noise;
        %%%%%%%%%%%%%%%%%%%%%%%%%接收机%%%%%%%%%%%%%%%%%%%%%%%%%%
        for iuser = 1:N_user
            %无信道估计，同步等

            % OFDM解调
            Frame_recieve = OFDMDemodulator(Frame_noise, N_sym, N_subcarrier,N_symbol,N_Rx, N_GI);
            % 接收机分集处理和空时解码
            Frame_decoded = STBCDecoding(Frame_recieve, H, N_subcarrier, N_Tx,N_Rx, N_symbol);
            % 根据每用户,每子载波的调制方式,进行解调
            Frame_demod = Demodulator(Frame_mod, index_data_per_user{iuser}, N_mod, N_symbol);
            %无信道解码, 包括RS解码, 卷积码Viterbi编码等
            Frame_result{iuser}= Frame_demod;
            % 本帧,本信噪比下,本用户的性能统计
            n_biterror = sum(abs(Frame_result{iuser} - Frame_zero_padding{iuser}))
            % n_biterror = sum(abs(Frame_result{iuser} - Frame_bit(iuser).data))%误码率计算
            BERs{iuser}(iframe,iebn0) = n_biterror ;
        end
    end
end