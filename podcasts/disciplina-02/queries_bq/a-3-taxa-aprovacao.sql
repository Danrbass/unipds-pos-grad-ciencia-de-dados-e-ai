-- Parte A, questão 3: Qual foi a taxa de aprovação das propostas?

SELECT
  COUNTIF(status = 'approved') AS qtd_aprovadas,
  COUNT(*) AS qtd_total,
  ROUND(COUNTIF(status = 'approved') / COUNT(*), 4) AS taxa_aprovacao
FROM `SEU_PROJETO.SEU_DATASET.credit_applications`;
