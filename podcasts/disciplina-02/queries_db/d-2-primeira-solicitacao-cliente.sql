-- Parte D, questão 2: Para cada cliente, identifique sua primeira solicitação de crédito.

SELECT
  customer_id,
  application_id AS primeira_solicitacao_id,
  application_date AS data_primeira_solicitacao,
  requested_amount,
  status
FROM credit_applications
QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY application_date, application_id) = 1
ORDER BY customer_id;
