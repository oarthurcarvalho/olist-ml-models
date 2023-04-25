WITH tb_pedido_item as (
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
)

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
)