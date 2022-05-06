%-----------------------MIMO-OFDM主函数---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月5日10点29分-----------------%
function Symbol_mod = SymbolModulator(Symbol_premod)

N_mod = size(Symbol_premod,1);

switch N_mod
    % BPSK调制
    case 1
        matrix_mapping = [-1 1];
        Symbol_mod = matrix_mapping(Symbol_premod + 1);
    % QPSK调制
    case 2
        %　比特的映射关系,00:-3/4*pi,01:3/4*pi,10: -1/4*pi,11: 1/4*pi
        matrix_mapping = exp(1j*[-3/4*pi 3/4*pi -1/4*pi 1/4*pi]);
        index_mod = [2 1]*Symbol_premod;
        %　把输入比特映射为符号
        Symbol_mod = matrix_mapping(index_mod + 1);
    % 8PSK调制
    case 3
        matrix_mapping = exp(1j*[0  1/4*pi 3/4*pi 1/2*pi  -1/4*pi -1/2*pi pi -3/4*pi ]);
        index_mod = [4 2 1]*Symbol_premod ;
        %　把输入比特映射为符号
        Symbol_mod = matrix_mapping(index_mod + 1);
    % 16QAM调制
    case 4
        % 映射关系参见说明文档
        m=1;
        for k=-3:2:3
            for l=-3:2:3
                % 对符号能量进行归一化
                matrix_mapping(m) = (k+1j*l)/sqrt(10);
            m=m+1;
            end
        end
        matrix_mapping = matrix_mapping([0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]+1);
        index_mod = [8 4 2 1]*Symbol_premod ;
        Symbol_mod = matrix_mapping(index_mod + 1);
    % 64QAM调制         
    case    6
        % 映射关系参见说明文档
        m=1;
        for k=-7:2:7
            for l=-7:2:7
                % 对符号能量进行归一化
                matrix_mapping(m) = (k+1j*l)/sqrt(42); 
            m=m+1;
            end
        end
        matrix_mapping = matrix_mapping(...
         [[ 0  1  3  2  7  6  4  5]...
         8+[ 0  1  3  2  7  6  4  5]... 
         24+[ 0  1  3  2  7  6  4  5]...
         16+[ 0  1  3  2  7  6  4  5]...
         56+[ 0  1  3  2  7  6  4  5]...
         48+[ 0  1  3  2  7  6  4  5]...
         32+[ 0  1  3  2  7  6  4  5]...
         40+[ 0  1  3  2  7  6  4  5]]+1);
        index_mod = [32 16 8 4 2 1]*Symbol_premod ;
        Symbol_mod = matrix_mapping(index_mod + 1);
end