-- Parte B, questão 3: Qual percentual dos clientes aprovados efetivamente contratou um empréstimo?

WITH clientes_aprovados AS (
  SELECT DISTINCT customer_id
  FROM credit_applications
  WHERE status = 'approved'
)
SELECT
  COUNT(*) FILTER (WHERE EXISTS (SELECT 1 FROM loans l WHERE l.customer_id = ca.customer_id)) AS qtd_aprovados_que_contrataram,
  COUNT(*) AS qtd_clientes_aprovados,
  ROUND(
    COUNT(*) FILTER (WHERE EXISTS (SELECT 1 FROM loans l WHERE l.customer_id = ca.customer_id)) * 1.0 / COUNT(*),
    4
  ) AS pct_aprovados_que_contrataram
FROM clientes_aprovados ca;
