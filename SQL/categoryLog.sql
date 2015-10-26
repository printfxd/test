SELECT * FROM golfclub.view_category_log;

INSERT INTO golfclub.view_category_log (subscriber_id, category, date, user_agent, area) VALUES ('72162076', '0000', now(), 'MOD206', '1chtn');
INSERT INTO golfclub.view_category_log (subscriber_id, category, date, user_agent, area) VALUES ('72162076', '0000', now(), 'MOD206', '6');
SELECT * FROM golfclub.view_category_log;


-- 我是 portable
INSERT INTO golfclub.view_category_log (phone_number, category, date, user_agent, area, is_nScreen_user) VALUES ('0928800457', '0300', now(), 'hTCOneX', '0', TRUE);
SELECT * FROM golfclub.view_category_log order by date desc ;