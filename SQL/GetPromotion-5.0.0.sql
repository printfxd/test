               SELECT CONCAT(IF(promotionList.state = 1, '＊', ''), promotionList.course_name) AS title,
                      -- IF(@resolution = 'sd', promotionList.sd_img_seq, promotionList.hd_img_seq) AS descImageSeq,
                      CASE @resolution 
                          WHEN 'sd' then (promotionList.sd_img_seq)
                          WHEN 'hd' then (promotionList.hd_img_seq)
                          WHEN 'nScreen' then (promotionList.nScreen_img_seq)
                      END AS descImageSeq,
                      IF(promotionList.state = 1,
                         promotionList.limited_sale,
                         IF(now() between promotionList.sale_start_date AND promotionList.sale_stop_date, promotionList.limited_sale, '')
                      ) AS shortInfo,
                      CAST(
                      IF(promotionList.state = 1,
                         promotionList.sale_stop_date,
                         IF(now() between promotionList.sale_start_date AND promotionList.sale_stop_date, promotionList.sale_stop_date, '')
                      ) AS DATETIME) AS infoStopDate
                 FROM golfclub.promotion_list promotionList,
                      (
                          SELECT seq AS promotionSeq
                            FROM golfclub.course_promotion,
                                 (SELECT @state := 2) state,
                                 (SELECT @month := 201307) month
                           WHERE IF(@state = 1, month = @month, month >= @month)
                             AND state >= @state
                        ORDER BY golfclub.course_promotion.month
                      ) coursePromotion,
                      (SELECT @resolution := 'hd') resolution
                WHERE promotionList.course_promotion_seq = coursePromotion.promotionSeq 
                  AND state >= @state
                  AND IF(@resolution = 'sd', promotionList.sd_img_seq is not null, TRUE)
                  AND IF(@resolution = 'hd', promotionList.hd_img_seq is not null, TRUE)
                  AND IF(@resolution = 'nScreen', promotionList.nScreen_img_seq is not null, TRUE)
             ORDER BY promotionList.course_promotion_seq, promotionList.state DESC, promotionList.order;