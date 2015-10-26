    SELECT vendor.seq,
           IF(vendor.state = '2', concat('＊', vendor.name), vendor.name) AS name,
           '' AS subName,
           '' AS previewSeq,
           '1' AS dataType,
           '0' AS hasDeco,
           vendor.order,
           '1' AS categoryType
      FROM golfclub.product_vendor vendor 
     WHERE vendor.state >= 2 
  ORDER BY vendor.order;


