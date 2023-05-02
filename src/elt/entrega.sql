WITH tb_pedido AS (
  
  SELECT t1.idPedido,
          t2.idVendedor,
          t1.descSituacao,
          t1.dtPedido,
          t1.dtAprovado,
          t1.dtEntregue,
          t1.dtEstimativaEntrega,
          sum(vlFrete) as totalFrete

  FROM pedido AS t1

  LEFT JOIN item_pedido as t2
    ON t1.idPedido = t2.idPedido

  WHERE t1.dtPedido < '{date}'
      AND t1.dtPedido >= DATE('{date}', '-6 months')
      AND t2.idVendedor is NOT NULL

  GROUP BY t1.idPedido,
            t2.idVendedor,
            t1.descSituacao,
            t1.dtPedido,
            t1.dtAprovado,
            t1.dtEntregue,
            t1.dtEstimativaEntrega
)

SELECT 
    '{date}' as dtReferencia,
    DATE('now') as dtIngestao,
    idVendedor,
    COUNT(DISTINCT CASE WHEN DATE(COALESCE(dtEntregue, '{date}')) > DATE(dtEstimativaEntrega) THEN idPedido END) /
            CAST(COUNT(DISTINCT CASE WHEN descSituacao = 'delivered' THEN idPedido END) AS FLOAT) AS pctPedidoAtraso,

    COUNT(DISTINCT CASE WHEN descSituacao = 'canceled' THEN idPedido END) / CAST(COUNT(DISTINCT idPedido) AS FLOAT) AS pctPedidoCancelado,
    AVG(totalFrete) as avgFrete,
    MAX(totalFrete) as maxFrete,
    MIN(totalFrete) as minFrete,
    
    AVG(julianday(COALESCE(dtEntregue, '{date}')) - julianday(dtAprovado)) AS qtdeDiasAprovadoEntrega,
    AVG(julianday(COALESCE(dtEntregue, '{date}')) - julianday(dtPedido)) AS qtdeDiasPedidoEntrega,
    AVG(julianday(dtEstimativaEntrega) - julianday(COALESCE(dtEntregue, '{date}'))) AS qtdeDiasEntregaPromessa

FROM tb_pedido

GROUP BY idVendedor