CREATE TABLE fs_vendedor_cliente AS

WITH tb_join AS (

    SELECT DISTINCT
            t1.idPedido,
            t1.idCliente,
            t2.idVendedor,
            t3.descUF

    FROM pedido AS  t1

    LEFT JOIN item_pedido as t2
        ON t1.idPedido = t2.idPedido

    LEFT JOIN cliente as t3
        ON t1.idCliente = t3.idCliente

    WHERE t1.dtPedido < '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t2.idVendedor is NOT NULL

),

tb_group AS (

  SELECT
        idVendedor,

        count(distinct descUF) as qtdUFsPedidos,

        count(distinct case when descUF = 'AC' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoAC,
        count(distinct case when descUF = 'AL' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoAL,
        count(distinct case when descUF = 'AM' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoAM,
        count(distinct case when descUF = 'AP' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoAP,
        count(distinct case when descUF = 'BA' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoBA,
        count(distinct case when descUF = 'CE' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoCE,
        count(distinct case when descUF = 'DF' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoDF,
        count(distinct case when descUF = 'ES' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoES,
        count(distinct case when descUF = 'GO' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoGO,
        count(distinct case when descUF = 'MA' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoMA,
        count(distinct case when descUF = 'MG' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoMG,
        count(distinct case when descUF = 'MS' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoMS,
        count(distinct case when descUF = 'MT' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoMT,
        count(distinct case when descUF = 'PA' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoPA,
        count(distinct case when descUF = 'PB' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoPB,
        count(distinct case when descUF = 'PE' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoPE,
        count(distinct case when descUF = 'PI' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoPI,
        count(distinct case when descUF = 'PR' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoPR,
        count(distinct case when descUF = 'RJ' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoRJ,
        count(distinct case when descUF = 'RN' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoRN,
        count(distinct case when descUF = 'RO' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoRO,
        count(distinct case when descUF = 'RR' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoRR,
        count(distinct case when descUF = 'RS' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoRS,
        count(distinct case when descUF = 'SC' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoSC,
        count(distinct case when descUF = 'SE' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoSE,
        count(distinct case when descUF = 'SP' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoSP,
        count(distinct case when descUF = 'TO' then idPedido end) / CAST(count(distinct idPedido) AS FLOAT) as pctPedidoTO

    FROM tb_join

    GROUP BY idVendedor

)

SELECT 
    '2018-01-01' AS dtReferencia,
    *

FROM tb_group