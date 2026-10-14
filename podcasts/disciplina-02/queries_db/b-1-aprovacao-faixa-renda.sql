-- Parte B, questão 1: Calcule a taxa de aprovação por faixa de renda.

SELECT
  CASE
    WHEN cu.income IS NULL THEN 'Sem informação'
    WHEN cu.income < 2000 THEN 'Até R$2.000'
    WHEN cu.income < 4000 THEN 'R$2.000 a R$4.000'
    WHEN cu.income < 6000 THEN 'R$4.000 a R$6.000'
    WHEN cu.income < 10000 THEN 'R$6.000 a R$10.000'
    ELSE 'Acima de R$10.000'
  END AS faixa_renda,
  COUNT(*) FILTER (WHERE ca.status = 'approved') AS qtd_aprovadas,
  COUNT(*) AS qtd_total,
  ROUND(COUNT(*) FILTER (WHERE ca.status = 'approved') * 1.0 / COUNT(*), 4) AS taxa_aprovacao
FROM credit_applications ca
JOIN customers cu ON cu.customer_id = ca.customer_id
GROUP BY faixa_renda
ORDER BY MIN(COALESCE(cu.income, -1));
