CREATE TABLE fs_vendedor_entrega AS

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

  WHERE t1.dtPedido < '2018-01-01'
      AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
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
    '2018-01-01' as dtReferencia,
    idVendedor,
    COUNT(DISTINCT CASE WHEN DATE(COALESCE(dtEntregue, '2018-01-01')) > DATE(dtEstimativaEntrega) THEN idPedido END) /
            CAST(COUNT(DISTINCT CASE WHEN descSituacao = 'delivered' THEN idPedido END) AS FLOAT) AS pctPedidoAtraso,

    COUNT(DISTINCT CASE WHEN descSituacao = 'canceled' THEN idPedido END) / CAST(COUNT(DISTINCT idPedido) AS FLOAT) AS pctPedidoCancelado,
    AVG(totalFrete) as avgFrete,
    MAX(totalFrete) as maxFrete,
    MIN(totalFrete) as minFrete,
    
    AVG(julianday(COALESCE(dtEntregue, '2018-01-01')) - julianday(dtAprovado)) AS qtdeDiasAprovadoEntrega,
    AVG(julianday(COALESCE(dtEntregue, '2018-01-01')) - julianday(dtPedido)) AS qtdeDiasPedidoEntrega,
    AVG(julianday(dtEstimativaEntrega) - julianday(COALESCE(dtEntregue, '2018-01-01'))) AS qtdeDiasEntregaPromessa

FROM tb_pedido

GROUP BY idVendedor