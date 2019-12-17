function VideoSpEED=video_speed(reference_videoname, distorted_videoname)
%%
%little function for calculate the speed score with two video names.
%%%% add to path necessary files
addpath(genpath('functions'))

%%%% SpEED parameters
blk_speed = 5;
sigma_nsq = 0.1;
down_size = 4;
window = fspecial('gaussian', 7, 7/6);
window = window/sum(sum(window));

ref_video = reference_videoname;
dis_video = distorted_videoname;
Nframes = 150;


%%%% memory allocation
speed_s = zeros(1, Nframes);
speed_t = zeros(1, Nframes);
speed_s_sn = zeros(1, Nframes);
speed_t_sn = zeros(1, Nframes);

tic
v_ref = VideoReader(ref_video);
v_dis = VideoReader(dis_video);


for frame_ind = 1 : Nframes
    
    if frame_ind < Nframes
        filename1 = read(v_ref,frame_ind);
        filename2 = read(v_dis,frame_ind+1);
        %%%% read i and i+1 frames of reference and distorted video
        ref_frame =rgb2gray(filename1);
        ref_frame_next = rgb2gray(filename2);
        ref_frame = double(ref_frame);
        ref_frame_next = double(ref_frame_next);
        
        filename1 = read(v_dis,frame_ind);
        filename2 = read(v_dis,frame_ind+1);
        dis_frame = rgb2gray(filename1);
        dis_frame_next = rgb2gray(filename2);
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
        
    end
    
end


non_nan_inds = intersect(find(~isnan(speed_s)), ...
    find(~isnan(speed_t)));
VideoSpEED = mean(speed_s(non_nan_inds)) * mean(speed_t(non_nan_inds));

disp(['Video SpEED: ' num2str(VideoSpEED)])


end