SELECT 
    idVendedor,
    MIN(DATE(dtPedido)) as dtAtivacao
    
FROM pedido as t1

LEFT JOIN item_pedido as t2
    ON t1.idPedido = t2.idPedido

WHERE dtPedido >= '2018-01-01'
    AND dtPedido <= DATE('2018-01-01', '45 days')
    AND idVendedor IS NOT NULL

ORDER BY idVendedor