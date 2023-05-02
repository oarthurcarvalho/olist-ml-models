WITH tb_pedido_item AS (

    SELECT 
        t2.*,
        t1.dtPedido

    FROM pedido as t1

    LEFT JOIN item_pedido as t2
        on t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t2.idVendedor is NOT NULL
),

tb_summary as (
    SELECT
        idVendedor,
        COUNT(DISTINCT idPedido) as qtdePedidos,
        COUNT(DISTINCT DATE(dtPedido)) as qtdeDias,
        COUNT(idProduto) as qtdeItens,
        MIN(JULIANDAY('2018-01-01') - JULIANDAY(dtPedido)) as qtdeRecencia,
        SUM(vlPreco) / COUNT(DISTINCT idPedido) as avgTicker,
        AVG(vlPreco) as avgValorProduto,
        MAX(vlPreco) as maxValorProduto,
        MIN(vlPreco) as minValorProduto,
        COUNT(idProduto) / COUNT(DISTINCT idPedido) as avgProdutoPedido

    FROM tb_pedido_item

    GROUP BY idVendedor
),

tb_pedido_summary as (
    SELECT 
        idVendedor,
        idPedido,
        SUM(vlPreco) as vlPreco

    FROM tb_pedido_item as t1

    GROUP BY idVendedor, idPedido
),

tb_min_max as (
    SELECT
        idVendedor,
        MIN(vlPreco) as minVlPedido,
        MAX(vlPreco) as maxVlPedido

    FROM tb_pedido_summary

    GROUP BY idVendedor
),

tb_life as (
    SELECT 
        t2.idVendedor,
        SUM(vlPreco) as LTV,
        MAX(JULIANDAY('2018-01-01') - JULIANDAY(dtPedido)) as qtdeDiasBase

    FROM pedido as t1

    LEFT JOIN item_pedido as t2
        ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '2018-01-01'
        AND t2.idVendedor IS NOT NULL

    GROUP BY t2.idVendedor
),

tb_dtpedido as (

    SELECT 
        DISTINCT idVendedor,
        DATE(dtPedido) as dtPedido

    FROM tb_pedido_item

    ORDER BY 1, 2
),

tb_lag as (
    SELECT 
        *,
        LAG(dtPedido) OVER (PARTITION BY idVendedor ORDER BY dtPedido) AS lag1

    FROM tb_dtpedido
),

tb_intervalo as (
    SELECT
        idVendedor,
        AVG(JULIANDAY(dtPedido) - JULIANDAY(lag1)) as avgIntervaloVendas

    FROM tb_lag

    GROUP BY idVendedor
)

SELECT
    '2018-01-01' as dtReferencia,
    DATE('now') as dtIngestao,
    t1.*,
    t2.minvlPedido,
    t2.maxvlPedido,
    t3.LTV,
    t3.qtdeDiasBase,
    t4.avgIntervaloVendas

FROM tb_summary as t1

LEFT JOIN tb_min_max as t2
    ON t1.idVendedor = t2.idVendedor

LEFT JOIN tb_life as t3
    ON t1.idVendedor = t3.idVendedor

LEFT JOIN tb_intervalo as t4
    ON t1.idVendedor = t4.idVendedor