-- Parte A, questão 3: Qual foi a taxa de aprovação das propostas?

SELECT
  COUNT(*) FILTER (WHERE status = 'approved') AS qtd_aprovadas,
  COUNT(*) AS qtd_total,
  ROUND(COUNT(*) FILTER (WHERE status = 'approved') * 1.0 / COUNT(*), 4) AS taxa_aprovacao
FROM credit_applications;
