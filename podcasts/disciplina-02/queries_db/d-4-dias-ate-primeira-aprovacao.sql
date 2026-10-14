-- Parte D, questão 4: Calcule o número de dias entre a primeira solicitação e a primeira
-- aprovação de cada cliente.

WITH por_cliente AS (
  SELECT
    customer_id,
    MIN(application_date) AS primeira_solicitacao,
    MIN(application_date) FILTER (WHERE status = 'approved') AS primeira_aprovacao
  FROM credit_applications
  GROUP BY customer_id
)
SELECT
  customer_id,
  primeira_solicitacao,
  primeira_aprovacao,
  DATE_DIFF('day', primeira_solicitacao, primeira_aprovacao) AS dias_ate_primeira_aprovacao
FROM por_cliente
WHERE primeira_aprovacao IS NOT NULL
ORDER BY customer_id;
