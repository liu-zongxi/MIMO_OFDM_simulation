%-----------------------思考虚拟子载波的问题-----------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年5月5日14点33分-----------------%
function Frame_bit = FrameBitGenerator(N_data, N_user, N_mod, N_symbol)
% 输入
% N_data:一个符号中要发送的符号数
% N_user:用户数
% N_mod:调制数
% N_symbol:一帧中有多少个符号
% 输出
% Frame_bit:一个（1，N_user）的结构体，包含data和num两个field，分别表示每个用户的数据和数据长度
    N_bit_per_symbol = N_mod * N_data;
    % 可以选择用户比特分布为：
    % 1) 所有用户比特相同。 
    N_bit_per_user_per_symbol = repmat(N_bit_per_symbol/N_user,1,N_user);

    % 2) 用户按照比例 (1:N_user)/((1 + N_user)*N_user/2) 发送比特数据
    % 目的是为了仿真不同用户的信息比特长度不同的情况,也可以修改得到其他的用户数据比例
    % N_bit_per_user_per_symbol = round([1:N_user]/((1 + N_user)*N_user/2) * N_bit_per_symbol);
    N_bit_per_user = N_bit_per_user_per_symbol * N_symbol;
    for iuser = 1:N_user
        % frame_bit_temp{iuser} = rand(N_bit_per_user(iuser), 1) > 0.5;
        Frame_bit(iuser).data = rand(N_bit_per_user(iuser), 1) > 0.5;
        Frame_bit(iuser).num = N_bit_per_user(iuser);
    end
end