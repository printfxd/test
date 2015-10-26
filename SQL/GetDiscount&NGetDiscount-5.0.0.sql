-- SQL_SELECT_STB_RATES_LIST
SELECT rate.short_name AS shortName,
       IFNULL(FORMAT(rate.nonvip_wday_price,0), '-') AS normalWday,
       IFNULL(FORMAT(rate.nonvip_hday_price,0), '-') AS normalHday,
       IFNULL(FORMAT(rate.nonvip_wdaym_price,0), '-') AS normalWdaym,
       IFNULL(FORMAT(rate.vip_wday_price,0), '-') AS vipWday,
       IFNULL(FORMAT(rate.vip_hday_price,0), '-') AS vipHday,
       IFNULL(FORMAT(rate.vip_wdaym_price,0), '-') AS vipWdaym,
       course.order
  FROM (SELECT @state := '2') state,
       golfclub.course_rates rate
  LEFT JOIN golfclub.course course ON (rate.course_id = course.id AND course.state >= @state)
 WHERE rate.state >= @state
   AND course.state >= @state
   AND course.type = '1'
   AND course.area = '1'
   AND (rate.nonvip_wday_price IS NOT NULL
        OR rate.nonvip_hday_price IS NOT NULL
        OR rate.nonvip_wdaym_price IS NOT NULL
        OR rate.vip_wday_price IS NOT NULL
        OR rate.vip_hday_price IS NOT NULL
        OR rate.vip_wdaym_price IS NOT NULL)
ORDER BY course.order;

-- SQL_SELECT_PORTABLE_RATES_LIST
           SELECT IF(rate.state = '1', concat('＊', rate.short_name), rate.short_name) AS shortName,
                  IFNULL(FORMAT(rate.nonvip_wday_price,0), '-') AS normalWday,
                  IFNULL(FORMAT(rate.nonvip_hday_price,0), '-') AS normalHday,
                  IFNULL(FORMAT(rate.nonvip_wdaym_price,0), '-') AS normalWdaym,
                  IFNULL(FORMAT(rate.vip_wday_price,0), '-') AS vipWday,
                  IFNULL(FORMAT(rate.vip_hday_price,0), '-') AS vipHday,
                  IFNULL(FORMAT(rate.vip_wdaym_price,0), '-') AS vipWdaym
             FROM (SELECT @state := '2') state,
                  golfclub.course_rates rate
                  LEFT JOIN golfclub.course course ON (rate.course_id = course.id AND course.state >= @state)
            WHERE rate.state >= @state
              AND course.state >= @state
              AND course.type = '1'
              AND course.area = '1'
              AND rate.nonvip_wday_price IS NOT NULL
              AND (rate.vip_wday_price IS NOT NULL
                   OR rate.vip_hday_price IS NOT NULL
                   OR rate.vip_wdaym_price IS NOT NULL)
         ORDER BY course.order;