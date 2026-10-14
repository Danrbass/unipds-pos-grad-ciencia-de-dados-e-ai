-- Parte D, questão 4: Calcule o número de dias entre a primeira solicitação e a primeira
-- aprovação de cada cliente.

WITH por_cliente AS (
  SELECT
    customer_id,
    MIN(application_date) AS primeira_solicitacao,
    MIN(IF(status = 'approved', application_date, NULL)) AS primeira_aprovacao
  FROM `SEU_PROJETO.SEU_DATASET.credit_applications`
  GROUP BY customer_id
)
SELECT
  customer_id,
  primeira_solicitacao,
  primeira_aprovacao,
  DATE_DIFF(primeira_aprovacao, primeira_solicitacao, DAY) AS dias_ate_primeira_aprovacao
FROM por_cliente
WHERE primeira_aprovacao IS NOT NULL
ORDER BY customer_id;
