-- Parte A, questão 2: Qual foi o valor total solicitado e o valor total aprovado em cada mês?

SELECT
  DATE_TRUNC('month', application_date) AS mes,
  SUM(requested_amount) AS valor_total_solicitado,
  SUM(approved_amount) AS valor_total_aprovado
FROM credit_applications
GROUP BY mes
ORDER BY mes;
