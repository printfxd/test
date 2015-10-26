SELECT * FROM golfclub.image where seq = 16;


SELECT * FROM golfclub.system_conf;

SELECT default_hd_poster_seq defaultSeq FROM golfclub.system_conf;

SELECT default_sd_poster_seq defaultSeq FROM golfclub.system_conf;



SELECT image FROM golfclub.image, (SELECT default_hd_poster_seq defaultSeq FROM golfclub.system_conf) T WHERE seq = T.defaultSeq;

SELECT image FROM golfclub.image, (SELECT default_sd_poster_seq defaultSeq FROM golfclub.system_conf) T WHERE seq = T.defaultSeq;


INSERT INTO `golfclub`.`image` (`image`, `format`, `size`, `width`, `height`, `file_name`, `login_username`) VALUES (load_file("/Users/hdd101022/Desktop/test/s1.png"), 'png', '37587', '210', '240', 's1.png', 'system');
