%-----------------------根据used和pilot生成data----------------------%
%-----------------------author:lzx-------------------------%
%-----------------------date:2022年3月27日11点16分----------%
function index_data = IndexDataGenerator(index_used, index_pilot)
% 输入
% index_used：所使用的子载波的index
% index_pilot：所使用的导频的子载波的index
% 输出
% index_data： 所使用的数据的子载波的index

    index_data = zeros(1, length(index_used) - length(index_pilot));
    idata = 1;
    ipilot = 1;
    for iused = 1:length(index_used)
        if index_used(iused)~= index_pilot(ipilot)
            index_data(idata) = index_used(iused);
            idata = idata + 1;
        else
            if ipilot ~= length(index_pilot)
                ipilot = ipilot+1;
            end
        end
    end
end