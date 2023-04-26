CREATE TABLE fs_vendedor_pagamentos AS

WITH tb_pedidos as (
    SELECT 
        DISTINCT
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
    SELECT 
            t1.idVendedor,
            t2.*
            
    FROM tb_pedidos AS t1

    LEFT JOIN pagamento_pedido as t2
        ON t1.idPedido = t2.idPedido

),

tb_group as (
SELECT idVendedor,
        descTipoPagamento,
        count(DISTINCT idPedido) as qtdePedidoMeioPagamento,
        sum(vlPagamento) as vlPedidoMeioPagamento
FROM tb_join

GROUP BY idVendedor, descTipoPagamento
ORDER BY idVendedor, descTipoPagamento
),

tb_summary as (
    SELECT idVendedor,
            SUM(
                CASE WHEN descTipoPagamento = 'credit_card'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) as qtde_credit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'boleto'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) as qtde_boleto_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'debit_card'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) as qtde_debit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'voucher'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) as qtde_voucher_pedido,

            SUM(
                CASE WHEN descTipoPagamento = 'credit_card'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) as valor_credit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'boleto'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) as valor_boleto_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'debit_card'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) as valor_debit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'voucher'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) as valor_voucher_pedido,

            -- Proporção

            SUM(
                CASE WHEN descTipoPagamento = 'credit_card'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) / SUM(qtdePedidoMeioPagamento) as pct_qtde_credit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'boleto'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) / SUM(qtdePedidoMeioPagamento) as pct_qtde_boleto_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'debit_card'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) / SUM(qtdePedidoMeioPagamento) as pct_qtde_debit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'voucher'
                    THEN qtdePedidoMeioPagamento ELSE 0 END
            ) / SUM(qtdePedidoMeioPagamento) as pct_qtde_voucher_pedido,

            SUM(
                CASE WHEN descTipoPagamento = 'credit_card'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) / SUM(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'boleto'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) / SUM(vlPedidoMeioPagamento) as pct_valor_boleto_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'debit_card'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) / SUM(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido,
            
            SUM(
                CASE WHEN descTipoPagamento = 'voucher'
                    THEN vlPedidoMeioPagamento ELSE 0 END
            ) / SUM(vlPedidoMeioPagamento) as pct_valor_voucher_pedido

    FROM tb_group
    GROUP by idVendedor
),

tb_cartao as (

    SELECT
            idVendedor,
            AVG(nrParcelas) as avgQtdeParcelas,
            MAX(nrParcelas) as maxQtdeParcelas,
            MIN(nrParcelas) as minQtdeParcelas

    FROM tb_join

    WHERE descTipoPagamento = 'credit_card'

    GROUP BY idVendedor
)

SELECT
        '2018-01-01' as  dtReferencia,
        t1.*,
        t2.avgQtdeParcelas,
        t2.maxQtdeParcelas,
        t2.minQtdeParcelas

FROM tb_summary as t1

LEFT JOIN tb_cartao as t2
    ON t1.idVendedor = t2.idVendedor

