%-----------------------QAM解调-----------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月7日11点51分-----------------%
function Frame_demod = Demodulator(Frame_decoded, index_data_iuser, N_mod, N_symbol)

Frame_demod = [];

for isymbol = 1:N_symbol
        Symbol_demod = SymbolDemodulator(Frame_decoded(index_data_iuser, isymbol).', N_mod);
        Frame_demod = [Frame_demod; Symbol_demod(:)];
end