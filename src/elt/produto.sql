CREATE TABLE fs_vendedor_produto AS

WITH tb_join AS (

    SELECT DISTINCT
            t2.idVendedor,
            t3.*

    FROM pedido as t1

    LEFT JOIN item_pedido as t2
        ON t1.idPedido = t2.idPedido

    LEFT JOIN produto as t3
        ON t2.idProduto = t3.idProduto

    WHERE t1.dtPedido < '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t2.idVendedor is NOT NULL
),

tb_summary as (

    SELECT idVendedor,
            AVG(coalesce(nrFotos, 0)) as avgFotos,
            AVG(vlComprimentoCm * vlAlturaCm * vlLarguraCm) as avgVolumeProduto,
            MIN(coalesce(nrFotos, 0)) as minFotos,
            MAX(vlComprimentoCm * vlAlturaCm * vlLarguraCm) as maxVolumeProduto,

            COUNT(DISTINCT CASE WHEN descCategoria = 'cama_mesa_banho' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriacama_mesa_banho,

            COUNT(DISTINCT CASE WHEN descCategoria = 'beleza_saude' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriabeleza_saude,

            COUNT(DISTINCT CASE WHEN descCategoria = 'esporte_lazer' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriaesporte_lazer,

            COUNT(DISTINCT CASE WHEN descCategoria = 'informatica_acessorios' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriainformatica_acessorios,

            COUNT(DISTINCT CASE WHEN descCategoria = 'moveis_decoracao' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriamoveis_decoracao,

            COUNT(DISTINCT CASE WHEN descCategoria = 'utilidades_domesticas' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriautilidades_domesticas,

            COUNT(DISTINCT CASE WHEN descCategoria = 'relogios_presentes' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriarelogios_presentes,

            COUNT(DISTINCT CASE WHEN descCategoria = 'telefonia' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriatelefonia,

            COUNT(DISTINCT CASE WHEN descCategoria = 'automotivo' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriaautomotivo,

            COUNT(DISTINCT CASE WHEN descCategoria = 'brinquedos' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriabrinquedos,

            COUNT(DISTINCT CASE WHEN descCategoria = 'cool_stuff' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriacool_stuff,

            COUNT(DISTINCT CASE WHEN descCategoria = 'ferramentas_jardim' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriaferramentas_jardim,

            COUNT(DISTINCT CASE WHEN descCategoria = 'perfumaria' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriaperfumaria,

            COUNT(DISTINCT CASE WHEN descCategoria = 'bebes' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriabebes,

            COUNT(DISTINCT CASE WHEN descCategoria = 'eletronicos' THEN idProduto END) /
                        COUNT(DISTINCT idProduto) AS pctCategoriaeletronicos


    FROM tb_join

    GROUP BY idVendedor
)

SELECT
    '2018-01-01' as dtReferencia,
    *

FROM tb_summary