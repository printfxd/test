    SELECT GROUP_CONCAT(ProductImg2.rows ORDER BY ProductImg2.column SEPARATOR '#' ) pages
      FROM
         (
           SELECT ProductImg1.column,
                  GROUP_CONCAT(IF('sd' = 'sd',ProductImg1.sd_img_seq, ProductImg1.hd_img_seq) ORDER BY ProductImg1.row SEPARATOR ',' ) AS rows,
                  ProductImg1.product_content_seq AS productContentSeq
             FROM golfclub.product_img ProductImg1
            WHERE ProductImg1.product_content_seq = '5'
         GROUP BY ProductImg1.column
         ORDER BY ProductImg1.column
         ) ProductImg2
  GROUP BY ProductImg2.productContentSeq;