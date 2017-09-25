SELECT 
   dist_mod_dist_mod_id,
   xmlagg(xmlelement(s, sku_id || ';')).extract('//text()').getclobval() as skus
    FROM item i
   GROUP BY dist_mod_dist_mod_id
