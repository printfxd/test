                 SELECT Course.name AS `title`,
                      Course.desc AS `desc`,
                      Course.address AS `address`,
                      Course.phone AS `phone`,
                      Course.nScreen_name_img_seq AS `titleSeq`,
                      CONCAT(Course.hd_img_seq, ',',Course.desc1_hd_img_seq, ',', Course.desc2_hd_img_seq) AS `imageSeq`, 
                      Course.traffic_nScreen_img_seq AS `trafficSeq`,
                      IFNULL(Course.longitude, '') AS `lon`,
                      IFNULL(Course.latitude, '') AS `lat`
                 FROM golfclub.course Course
                WHERE Course.id = 59
                  AND Course.is_nScreen = TRUE;