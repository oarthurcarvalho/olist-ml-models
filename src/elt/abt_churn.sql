-- CREATE TABLE tb_pedido as 
WITH tb_activate as (
    SELECT
        idVendedor,
        MIN(DATE(dtPedido)) as dtAtivacao
        
    FROM pedido as t1

    LEFT JOIN item_pedido as t2
        ON t1.idPedido = t2.idPedido

    WHERE dtPedido >= '2018-01-01'
        AND dtPedido <= DATE('2018-01-01', '45 days')
        AND idVendedor IS NOT NULL

    GROUP BY idVendedor
)

SELECT 
    t1.*,
    t2.*,
    t3.*,
    t4.*,
    t5.*,
    t6.*,
    CASE WHEN t7.idVendedor IS NULL THEN 1 ELSE 0 END AS flChurn

FROM fs_vendedor_vendas AS t1

LEFT JOIN fs_vendedor_avaliacao as t2
    ON t1.idVendedor = t2.idVendedor
    AND t1.dtReferencia = t2.dtReferencia

LEFT JOIN fs_vendedor_cliente as t3
    ON t1.idVendedor = t3.idVendedor
    AND t1.dtReferencia = t3.dtReferencia

LEFT JOIN fs_vendedor_entrega as t4
    ON t1.idVendedor = t4.idVendedor
    AND t1.dtReferencia = t4.dtReferencia

LEFT JOIN fs_vendedor_pagamentos as t5
    ON t1.idVendedor = t5.idVendedor
    AND t1.dtReferencia = t5.dtReferencia

LEFT JOIN fs_vendedor_produto as t6
    ON t1.idVendedor = t6.idVendedor
    AND t1.dtReferencia = t6.dtReferencia

LEFT JOIN tb_activate AS t7
    ON t1.idVendedor = t7.idVendedor
    AND JULIANDAY(t7.dtAtivacao) - JULIANDAY(t1.dtReferencia) + t1.qtdeRecencia <= 45

WHERE t1.qtdeRecencia <= 45