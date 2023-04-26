CREATE TABLE fs_vendedor_avaliacao AS

WITH tb_pedido as (

    SELECT DISTINCT
            t1.idPedido,
            t2.idVendedor

    FROM pedido as t1

    LEFT JOIN item_pedido as t2
        ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t2.idVendedor is NOT NULL
),

tb_join as (

SELECT t1.*,
        t2.vlNota

FROM tb_pedido as t1

LEFT JOIN avaliacao_pedido as t2
    ON t1.idPedido = t2.idPedido
),

tb_summary as (

    SELECT idVendedor,
            AVG(vlNota) as avgNota,
            MIN(vlNota) as minNota,
            MAX(vlNota) as maxNota, 
            COUNT(vlNota) / COUNT(idPedido) as pctAvaliacao

    FROM tb_join

    GROUP BY idVendedor
)

SELECT '2018-01-01' as dtReferencia,
        *

FROM tb_summary