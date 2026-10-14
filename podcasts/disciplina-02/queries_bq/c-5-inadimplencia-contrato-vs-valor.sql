-- Parte C, questão 5: Compare a inadimplência calculada por quantidade de contratos com a
-- inadimplência calculada sobre o valor concedido.

WITH classificados AS (
  SELECT
    loan_amount,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > DATE_ADD(due_date, INTERVAL 15 DAY) THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN DATE_ADD(due_date, INTERVAL 15 DAY) <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM `SEU_PROJETO.SEU_DATASET.loans`
)
SELECT
  ROUND(
    COUNTIF(status_inadimplencia = 'inadimplente')
      / COUNTIF(status_inadimplencia IN ('adimplente', 'inadimplente')),
    4
  ) AS taxa_inadimplencia_por_contrato,
  ROUND(
    SUM(IF(status_inadimplencia = 'inadimplente', loan_amount, NULL))
      / SUM(IF(status_inadimplencia IN ('adimplente', 'inadimplente'), loan_amount, NULL)),
    4
  ) AS taxa_inadimplencia_por_valor
FROM classificados;
