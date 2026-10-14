-- Parte A, questão 1: Quantas solicitações de crédito foram realizadas por mês?

SELECT
  DATE_TRUNC(application_date, MONTH) AS mes,
  COUNT(*) AS qtd_solicitacoes
FROM `SEU_PROJETO.SEU_DATASET.credit_applications`
GROUP BY mes
ORDER BY mes;
