SELECT * FROM golfclub.ads;
SELECT * FROM golfclub.ads_img;
SELECT * FROM golfclub.ads_category;

SELECT * FROM golfclub.image order by seq desc;


SELECT seq 
  FROM golfclub.ads Ads, (SELECT ads_seq FROM golfclub.ads_category WHERE category = '0000') Category 
 WHERE now() BETWEEN service_start_date AND service_stop_date
   AND Ads.seq = Category.ads_seq;

SELECT * FROM golfclub.ads_category WHERE category = '0000';
-- 2.
SELECT *
  FROM golfclub.ads AS Ads, 
       (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '2000') AS Category,
       (SELECT @state := '%') state
 WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
   AND Ads.seq = Category.adsSeq
   AND Ads.state like @state
ORDER BY Ads.state DESC, Ads.service_start_date;
-- 3.
SELECT IF('hd'='sd', AdsImg.sd_img_seq, AdsImg.hd_img_seq) AS 'adSeq',
	    AdsImg.duration AS 'interval'
  FROM golfclub.ads_img AS AdsImg,
       (	
		    SELECT Ads.seq AS adsSeq,
                  Ads.service_start_date AS serviceStartDate
             FROM golfclub.ads AS Ads, 
                  (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '0000') AS Category,
				   (SELECT @state := '%') state
            WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
              AND Ads.seq = Category.adsSeq
              AND Ads.state like @state
		  ORDER BY Ads.state DESC, Ads.service_start_date
       ) AS Ads
 WHERE AdsImg.ads_seq = Ads.adsSeq
ORDER BY Ads.serviceStartDate, AdsImg.order;

-- 我是球場-------------------------------------------------------------------------------
SELECT * FROM golfclub.ads;
SELECT * FROM golfclub.ads_img;
SELECT * FROM golfclub.ads_category;
SELECT * FROM golfclub.image;

SELECT * FROM golfclub.ads_category WHERE course_id = '1';
SELECT * FROM golfclub.ads_category WHERE category = '0300' AND course_id = '211';

SELECT IF('sd'='sd', AdsImg.sd_img_seq, AdsImg.hd_img_seq) AS 'adSeq',
       AdsImg.duration AS 'interval'
  FROM golfclub.ads_img AS AdsImg,
       (	
           SELECT Ads.seq AS adsSeq
             FROM golfclub.ads AS Ads, 
                  (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '0700' AND course_id = '8') AS Category,
                  (SELECT @state := '%') state
            WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
              AND Ads.seq = Category.adsSeq
              AND Ads.state like @state
		  ORDER BY Ads.state DESC, Ads.service_start_date
       ) AS Ads
 WHERE AdsImg.ads_seq = Ads.adsSeq
ORDER BY AdsImg.ads_seq, AdsImg.order;


-- 我是screen


SELECT Ads.adsSeq AS 'adsSeq',
        IF('hd'='sd', AdsImg.sd_img_seq, AdsImg.hd_img_seq) AS 'adSeq',
	    AdsImg.duration AS 'interval',
        Ads.updateDate AS 'updateDate'
  FROM golfclub.ads_img AS AdsImg,
       (	
		    SELECT Ads.seq AS adsSeq,
                  Ads.service_start_date AS serviceStartDate,
                  Ads.update_date AS updateDate
             FROM golfclub.ads AS Ads, 
                  (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '2000') AS Category,
				   (SELECT @state := '%') state
            WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
              AND Ads.seq = Category.adsSeq
              AND Ads.state like @state
		  ORDER BY Ads.state DESC, Ads.service_start_date
       ) AS Ads
 WHERE AdsImg.ads_seq = Ads.adsSeq
ORDER BY Ads.serviceStartDate, AdsImg.order;


           SELECT Ads.seq AS adsSeq,
                  Ads.update_date AS updateDate
             FROM golfclub.ads AS Ads, 
                  (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '2000') AS Category,
				   (SELECT @state := '%') state
            WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
              AND Ads.seq = Category.adsSeq
              AND Ads.state like @state
		  ORDER BY Ads.state DESC, Ads.service_start_date;






                      SELECT update_date AS updateDate
                        FROM golfclub.ads AS Ads,
                             (SELECT ads_seq AS adsSeq FROM golfclub.ads_category WHERE category = '2000') AS Category,
                             (SELECT @state := '%') state
                       WHERE IF(@state = '2', now() BETWEEN Ads.service_start_date AND Ads.service_stop_date, now() < Ads.service_stop_date)
                         AND Ads.seq = Category.adsSeq
                         AND Ads.state like @state
                    ORDER BY Ads.update_date