SELECT * FROM golfclub.view_travel_log;

INSERT INTO golfclub.view_travel_log
(subscriber_id, travel_video_seq, travel_video_name, path, areA, play_url, date, play_success)
VALUES ('11111111', '1', 'test', 'http://google.com', '1', 'wwwwwww', now(), TRUE);


UPDATE golfclub.view_travel_log
SET
date = now(),
play_success = FALSE
WHERE seq = 1;