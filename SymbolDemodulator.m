%-----------------------每个符号的QAM解调-----------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月7日11点51分-----------------%
function Symbol_demod = SymbolDemodulator(Symbol, N_mod)

switch N_mod

    % BPSK解调
    case 1
        Symbol_demod = real(Symbol) > 0; 

    % QPSK解调
    case 2 
        % 由QPSK的星座图可以观察到
        bit0 = real(Symbol) ; 
        bit1 = imag(Symbol) ;
        
        % 得到2行, 列数为符号数的输出矩阵
        Symbol_demod(1,:) = bit0 > 0;
        Symbol_demod(2,:) = bit1 > 0;

    % 8PSK解调
    case 3
        % 参见8PSK的星座图
        bit0 = -imag( Symbol * exp(1j*pi/8)) ;
        % bit1和bit2解调,都需要进行星座旋转
        bit1 = -real(Symbol * exp(1j*pi/8)) ;
        
        bit2 = [];
        for isymbol = 1:length(Symbol)
            tmp = Symbol(isymbol) * exp(-1j*pi/8); 
            if ((real(tmp) <0) && (imag(tmp) >0)) || ((real(tmp) >0) && (imag(tmp) <0))
                bit2 = [bit2 0];
            else
                bit2 = [bit2 1];
            end   
        end
        
        Symbol_demod(1,:) = bit0 >0;
        Symbol_demod(2,:) = bit1 >0;
        Symbol_demod(3,:) = bit2 ;    %　已经硬判决
            % 16QAM解调   
    case    4
        bit0 = real(Symbol);
        bit2 = imag(Symbol);

        % 以bit1的生成来说明方法:
        % 2/sqrt(10) 为临界值, abs(real(sym))大于此, 则bit1为负,硬判决得到0 ; 反之为正
        bit1 = 2/sqrt(10)-(abs(real(Symbol)));
        bit3 = 2/sqrt(10)-(abs(imag(Symbol)));

        Symbol_demod(1,:) = bit0 > 0;
        Symbol_demod(2,:) = bit1 > 0;
        Symbol_demod(3,:) = bit2 > 0;
        Symbol_demod(4,:) = bit3 > 0;
            % 64QAM解调         
    case    6       
        bit0 = real(Symbol);
        bit3 = imag(Symbol);
        bit1 = 4/sqrt(42)-abs(real(Symbol));
        bit4 = 4/sqrt(42)-abs(imag(Symbol));
        for m=1:size(Symbol,2)
            for k=1:size(Symbol,1)
                if abs(4/sqrt(42)-abs(real(Symbol(k,m)))) <= 2/sqrt(42)  
                    bit2(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(real(Symbol(k,m))));
                elseif abs(real(Symbol(k,m))) <= 2/sqrt(42) 
                    bit2(k,m) = -2/sqrt(42) + abs(real(Symbol(k,m)));
                else
                    bit2(k,m) = 6/sqrt(42)-abs(real(Symbol(k,m)));
                end
      
                if abs(4/sqrt(42)-abs(imag(Symbol(k,m)))) <= 2/sqrt(42)  
                    bit5(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(imag(Symbol(k,m))));
                elseif abs(imag(Symbol(k,m))) <= 2/sqrt(42) 
                    bit5(k,m) = -2/sqrt(42) + abs(imag(Symbol(k,m)));
                else
                    bit5(k,m) = 6/sqrt(42)-abs(imag(Symbol(k,m)));
                end
            end
        end

        Symbol_demod(1,:) = bit0 > 0;
        Symbol_demod(2,:) = bit1 > 0;
        Symbol_demod(3,:) = bit2 > 0;
        Symbol_demod(4,:) = bit3 > 0;
        Symbol_demod(5,:) = bit4 > 0;
        Symbol_demod(6,:) = bit5 > 0;
end
