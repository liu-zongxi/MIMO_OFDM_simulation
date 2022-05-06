%-----------------------思考虚拟子载波的问题-----------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月5日16点35分-----------------%
function [index_data_per_user, Frame_zero_padding]=SubcarrierAllocation(Frame_bit_coded, index_data, N_data, N_user,N_symbol, N_mod, type_alloc)
Frame_zero_padding = cell(1,N_user);
index_data_per_user = cell(1,N_user);
% 计算填零的个数
N_subcarrier_per_user = N_data / N_user;    % 平均分配,每个用户所被分配的子载波个数
for iuser = 1:N_user
    N_zero_padding = N_mod * N_subcarrier_per_user * N_symbol - Frame_bit_coded(iuser).num;
    % 子载波分配方式，这里只给出相邻分配
    if type_alloc == "neighbour"
        index_data_per_user{iuser} = index_data((iuser-1)*N_subcarrier_per_user + 1: iuser*N_subcarrier_per_user)';
    end
    Frame_zero_padding{iuser} = [Frame_bit_coded(iuser).data; zeros(N_zero_padding, 1)];
end
