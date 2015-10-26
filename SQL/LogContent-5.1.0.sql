INSERT INTO golfclub.view_product_log
(subscriber_id, product_content_seq, product_content_name, path, area, play_url, date, play_success)
VALUES
('11111111', '1', 'test', 'http://google.com', '1', 'wwwwwww', now(), TRUE);

SELECT * FROM golfclub.view_product_log;



UPDATE golfclub.view_product_log
SET
date = now(),
play_success = FALSE
WHERE seq = 1
