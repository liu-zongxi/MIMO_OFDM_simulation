%-----------------------生成高斯噪声---------------------%
%-----------------------author:lzx--------------------------%
%-----------------------date:2022年5月6日22点43分-----------------%
function noise = NoiseGenerator(EbN0, Power_transmit, N_noise)
sigma = sqrt(Power_transmit/(2*EbN0));%标准差sigma
noise_real = randn(1,N_noise,2);
noise_real(:,:,1)=noise_real(:,:,1).*sigma(1);
noise_real(:,:,2)=noise_real(:,:,2).*sigma(2);
noise_imag = randn(1,N_noise,2);
noise_imag(:,:,1)=noise_imag(:,:,1).*sigma(1);
noise_imag(:,:,2)=noise_imag(:,:,2).*sigma(2);
noise=complex(noise_real,noise_imag);%复噪声序列