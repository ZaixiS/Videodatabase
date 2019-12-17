clear
close all
clc
speed = zeros(1,9);
%%%% add to path necessary files
addpath(genpath('functions'))

%%%% SpEED parameters
blk_speed = 5;
sigma_nsq = 0.1;
down_size = 4;
window = fspecial('gaussian', 7, 7/6);
window = window/sum(sum(window));

%%%% load a reference and a distorted video here
% ref_video = 'E:\LiveVQA\pa1_25fps.yuv';
% dis_video = 'E:\LiveVQA\pa2_25fps.yuv';
% Nframes = 250;
% frame_height = 432;
% frame_width = 768;
para = [1,2,3,5,7,10,15,17,20,22,25,30];
for time = [1:12]
    


ref_video = 'slices\out';
dis_video = ['blured\' num2str(para(time)) '\o'];
Nframes = 100;


%%%% memory allocation
speed_s = zeros(1, Nframes);
speed_t = zeros(1, Nframes);
speed_s_sn = zeros(1, Nframes);
speed_t_sn = zeros(1, Nframes);

tic

for frame_ind = 1 : Nframes
    
    if frame_ind < Nframes
        filename1 = [ref_video num2str(frame_ind) '.png'];
        filename2 = [ref_video num2str(frame_ind+1) '.png'];
        %%%% read i and i+1 frames of reference and distorted video
        ref_frame =rgb2gray(imread(filename1));
        ref_frame_next = rgb2gray(imread(filename2));
        ref_frame = double(ref_frame);
        ref_frame_next = double(ref_frame_next);
        
        dis_frame = rgb2gray(imread([dis_video num2str(frame_ind) '.png']));
        dis_frame_next = rgb2gray(imread([dis_video num2str(frame_ind+1) '.png']));
        dis_frame = double(dis_frame);
        dis_frame_next = double(dis_frame_next);
        
        %%%% calaculate SpEED
        [speed_s(frame_ind), speed_s_sn(frame_ind), ...
            speed_t(frame_ind), speed_t_sn(frame_ind)] = ...
            Single_Scale_Video_SPEED(ref_frame, ref_frame_next, ...
            dis_frame, dis_frame_next, ...
            down_size, window, blk_speed, sigma_nsq);
        
    else
        
        %%%% cannot read more frame, use previous values
        speed_s(frame_ind) = speed_s(frame_ind - 1);
        speed_t(frame_ind) = speed_t(frame_ind - 1);
        speed_s_sn(frame_ind) = speed_s_sn(frame_ind - 1);
        speed_t_sn(frame_ind) = speed_t_sn(frame_ind - 1); 
        
    end;
    
end;

time_took = toc;

non_nan_inds = intersect(find(~isnan(speed_s)), ...
    find(~isnan(speed_t)));
VideoSpEED = mean(speed_s(non_nan_inds)) * mean(speed_t(non_nan_inds));

disp(['Video SpEED: ' num2str(VideoSpEED)])
% disp(['Took ' num2str(time_took) ' sec. for ' ...
%     num2str(Nframes) ' frames of size' ' ' num2str(frame_width) 'x' ....
%     num2str(frame_height)])
speed(time) =  VideoSpEED;
end

figure;
plot(para,speed);
xlabel('gblur-sigma')
ylabel('VideoSpEED')
set(gca,'fontsize',20)
title('Gaussian Blured Video Score')