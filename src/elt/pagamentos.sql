WITH tb_join as (
SELECT t2.*,
        t3.idVendedor,
        t1.dtPedido
FROM pedido AS t1

LEFT JOIN pagamento_pedido as t2
    ON t1.idPedido = t2.idPedido

LEFT JOIN item_pedido as t3
    ON t1.idPedido = t3.idPedido

WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
    AND t3.idVendedor is NOT NULL

ORDER BY t1.dtPedido
),

tb_group as (
SELECT idVendedor,
        descTipoPagamento,
        count(DISTINCT idPedido) as qtdePedidoMeioPagamento,
        sum(vlPagamento) as vlPedidoMeioPagamento
FROM tb_join

GROUP BY idVendedor, descTipoPagamento
ORDER BY idVendedor, descTipoPagamento
)

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