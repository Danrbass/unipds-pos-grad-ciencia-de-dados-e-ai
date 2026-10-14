-- Parte B, questão 4: Qual percentual do valor solicitado foi efetivamente aprovado?

SELECT
  SUM(approved_amount) AS valor_total_aprovado,
  SUM(requested_amount) AS valor_total_solicitado,
  ROUND(SUM(approved_amount) / SUM(requested_amount), 4) AS pct_valor_aprovado
FROM credit_applications;
