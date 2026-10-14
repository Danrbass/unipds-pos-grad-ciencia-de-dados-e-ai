-- Parte B, questão 3: Qual percentual dos clientes aprovados efetivamente contratou um empréstimo?

WITH clientes_aprovados AS (
  SELECT DISTINCT customer_id
  FROM `SEU_PROJETO.SEU_DATASET.credit_applications`
  WHERE status = 'approved'
)
SELECT
  COUNTIF(EXISTS (SELECT 1 FROM `SEU_PROJETO.SEU_DATASET.loans` l WHERE l.customer_id = ca.customer_id)) AS qtd_aprovados_que_contrataram,
  COUNT(*) AS qtd_clientes_aprovados,
  ROUND(
    COUNTIF(EXISTS (SELECT 1 FROM `SEU_PROJETO.SEU_DATASET.loans` l WHERE l.customer_id = ca.customer_id)) / COUNT(*),
    4
  ) AS pct_aprovados_que_contrataram
FROM clientes_aprovados ca;
