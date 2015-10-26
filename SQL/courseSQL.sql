SELECT * FROM golfclub.course;
SELECT * FROM golfclub.course_fairway;

-- 取指定資料 2013/01/01
SELECT seq, id, title, address, phone, imageSeq
FROM (
   SELECT CAST(@row_num := IF(@prev_value=Course.area,@row_num+1,1) AS UNSIGNED) AS seq,
		   Course.id AS id,
		   IF(Course.state = 1, concat('[＊]', Course.name), Course.name) AS title, 
		   Course.address AS address, 
		   Course.phone AS phone, 
		   IF('sd' = 'sd', Course.sd_img_seq, Course.hd_img_seq) AS imageSeq,
			@prev_value := Course.area AS area
	  FROM golfclub.course Course,
		   (SELECT @row_num := 1) x,
		   (SELECT @prev_value := '') y
	 WHERE Course.area in (2)
	   AND Course.state like '%'
       AND Course.type = '1'
  ORDER BY Course.area, Course.state DESC, Course.order
	 ) subquery;



     SELECT courseSeq, id, title, updateDate
             FROM (
                 SELECT CAST(@row_num := IF(@prev_value=course.area,@row_num+1,1) AS UNSIGNED) AS courseSeq,
                        course.id AS id,
                        IF(course.state = 1, concat('＊', course.name), course.name) AS title,
                        course.update_date AS updateDate,
                        @prev_value := course.area AS area
                   FROM golfclub.course course,
                        (SELECT @row_num := 1) x,
                        (SELECT @prev_value := '') y
                  WHERE course.area in (2)
                    AND course.state >= '1'
                    AND course.is_nScreen = TRUE
                    AND course.type = '1'
               ORDER BY course.area, course.state DESC, course.order
           ) subquery;




-- 取各地區球場分類數量
SELECT count(*) totalCount, area
  FROM golfclub.course
 WHERE area in (1,2,3,4)
   AND state like '%'
 GROUP BY area
 ORDER BY area;

-- 球場資料
-- info , traffic
SELECT Course.name AS `title`,
       Course.desc AS `desc`,
		IF (Course.type = '1',
		    CONCAT(
               IF(@resolution = 'sd', Course.desc1_sd_img_seq, Course.desc1_hd_img_seq),
		         ',',
			    IF(@resolution = 'sd', Course.desc2_sd_img_seq, Course.desc2_hd_img_seq)
	        ),
		    IF(@resolution = 'sd', Course.desc1_sd_img_seq, Course.desc1_hd_img_seq)
		) AS `imageSeq`,
       IF(@resolution = 'sd', Course.traffic_sd_img_seq, Course.traffic_hd_img_seq) AS `trafficSeq`
  FROM golfclub.course Course, (SELECT @resolution := 'sd') X
 WHERE id = '58';

-- strategy
  SELECT * FROM golfclub.course_fairway;

  SELECT Fairway.zone AS `zone`,
         Fairway.hole_no AS `holeSeq`,
         IF('sd' = 'sd', Fairway.sd_img_seq, Fairway.hd_img_seq) AS `imageSeq`
    FROM golfclub.course_fairway Fairway
   WHERE Fairway.course_id = '102'
ORDER BY Fairway.zone, Fairway.hole_no;