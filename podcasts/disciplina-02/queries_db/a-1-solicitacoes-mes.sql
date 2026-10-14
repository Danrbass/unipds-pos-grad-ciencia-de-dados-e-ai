-- Parte A, questão 1: Quantas solicitações de crédito foram realizadas por mês?

SELECT
  DATE_TRUNC('month', application_date) AS mes,
  COUNT(*) AS qtd_solicitacoes
FROM credit_applications
GROUP BY mes
ORDER BY mes;
