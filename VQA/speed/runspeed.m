REF_DIR = 'F:\SportsVideos\Original3\';
DIS_DIR = [ "F:\SportsVideos\compression_by_crf\crf_1\", "F:\SportsVideos\compression_by_crf\crf_3\", "F:\SportsVideos\compression_by_crf\crf_5\", "F:\SportsVideos\compression_by_crf\crf_7\", "F:\SportsVideos\compression_by_crf\crf_9\", "F:\SportsVideos\compression_by_crf\crf_11\", "F:\SportsVideos\compression_by_crf\crf_13\", "F:\SportsVideos\compression_by_crf\crf_15\", "F:\SportsVideos\compression_by_crf\crf_17\", "F:\SportsVideos\compression_by_crf\crf_19\", "F:\SportsVideos\compression_by_crf\crf_21\", "F:\SportsVideos\compression_by_crf\crf_23\", "F:\SportsVideos\compression_by_crf\crf_25\", "F:\SportsVideos\compression_by_crf\crf_27\", "F:\SportsVideos\compression_by_crf\crf_29\", "F:\SportsVideos\compression_by_crf\crf_31\", "F:\SportsVideos\compression_by_crf\crf_33\", "F:\SportsVideos\compression_by_crf\crf_35\", "F:\SportsVideos\compression_by_crf\crf_37\", "F:\SportsVideos\compression_by_crf\crf_39\", "F:\SportsVideos\compression_by_crf\crf_41\", "F:\SportsVideos\compression_by_crf\crf_43\", "F:\SportsVideos\compression_by_crf\crf_45\", "F:\SportsVideos\compression_by_crf\crf_47\", "F:\SportsVideos\compression_by_crf\crf_49\", "F:\SportsVideos\compression_by_crf\crf_50\"  ];
speedScore = [];

for disv_dir = DIS_DIR
    scores = [];
    disv_dir = char(disv_dir);
    vnames = dir([disv_dir '*.mp4']);
    for vid_indx = 1:length(vnames)
        dis_video = vnames(vid_indx).name;
        ref_video = [REF_DIR dis_video(1:end-4) '.avi'];
        dis_video = [disv_dir dis_video];
        speed = video_speed(ref_video , dis_video);
        scores  = [scores speed];
    end
    speedScore = [speedScore ; scores];
end
        