%-----------------------调制函数---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月5日23点22分-----------------%
function Frame_mod = Modulator(Frame_zero_padding, index_data_per_user, N_data, N_user, N_symbol, N_mod, N_subcarrier)

Frame_mod = zeros(N_subcarrier, N_symbol);
N_subcarrier_per_user = N_data / N_user;
for iuser = 1:N_user
    for isymbol = 1:N_symbol
        L_symbol = N_subcarrier_per_user* N_mod;
        index_symbol = (isymbol-1)*L_symbol+1 : isymbol*L_symbol;
        Symbol = Frame_zero_padding{iuser}(index_symbol);
        Symbol_premod = reshape(Symbol, N_mod, N_subcarrier_per_user);
        Symbol_mod = SymbolModulator(Symbol_premod);
        Frame_mod(index_data_per_user{iuser}, isymbol) = Symbol_mod.';
    end
end