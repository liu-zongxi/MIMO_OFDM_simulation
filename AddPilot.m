%-----------------------导频插入函数---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月6日20点47分-----------------%
function Frame_pilot = AddPilot(Frame_STBC, index_pilot, N_symbol, N_Tx)
for iant = 1:N_Tx
    for isymbol = 1:N_symbol
        Frame_STBC(index_pilot, isymbol, iant) = 1;
    end
end
Frame_pilot = Frame_STBC;