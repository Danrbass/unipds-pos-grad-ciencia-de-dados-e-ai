-- Parte D, questão 1: Para cada mês, calcule a taxa de aprovação e a variação em relação
-- ao mês anterior.

WITH por_mes AS (
  SELECT
    DATE_TRUNC('month', application_date) AS mes,
    COUNT(*) FILTER (WHERE status = 'approved') AS qtd_aprovadas,
    COUNT(*) AS qtd_total,
    ROUND(COUNT(*) FILTER (WHERE status = 'approved') * 1.0 / COUNT(*), 4) AS taxa_aprovacao
  FROM credit_applications
  GROUP BY mes
)
SELECT
  mes,
  taxa_aprovacao,
  ROUND(taxa_aprovacao - LAG(taxa_aprovacao) OVER (ORDER BY mes), 4) AS variacao_vs_mes_anterior,
  ROUND(LEAD(taxa_aprovacao) OVER (ORDER BY mes) - taxa_aprovacao, 4) AS variacao_vs_mes_seguinte,
  RANK() OVER (ORDER BY taxa_aprovacao DESC) AS rank_taxa_aprovacao
FROM por_mes
ORDER BY mes;
