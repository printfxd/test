    SELECT travelArea.seq,
           IF(travelArea.state = '2', concat('＊', travelArea.name), travelArea.name) AS name,
           '' AS subName,
           '' AS previewSeq,
           '1' AS dataType,
           '0' AS hasDeco,
           travelArea.order,
           '3' AS categoryType
      FROM (SELECT @state := '2') userState,
           golfclub.travel_area travelArea
     WHERE travelArea.product_travel_seq = '1'
       AND travelArea.state >= @state
  ORDER BY travelArea.order;