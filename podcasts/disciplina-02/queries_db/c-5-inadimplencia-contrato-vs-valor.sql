-- Parte C, questão 5: Compare a inadimplência calculada por quantidade de contratos com a
-- inadimplência calculada sobre o valor concedido.

WITH classificados AS (
  SELECT
    loan_amount,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > due_date + INTERVAL 15 DAY THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN due_date + INTERVAL 15 DAY <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM loans
)
SELECT
  ROUND(
    COUNT(*) FILTER (WHERE status_inadimplencia = 'inadimplente') * 1.0
      / COUNT(*) FILTER (WHERE status_inadimplencia IN ('adimplente', 'inadimplente')),
    4
  ) AS taxa_inadimplencia_por_contrato,
  ROUND(
    SUM(loan_amount) FILTER (WHERE status_inadimplencia = 'inadimplente')
      / SUM(loan_amount) FILTER (WHERE status_inadimplencia IN ('adimplente', 'inadimplente')),
    4
  ) AS taxa_inadimplencia_por_valor
FROM classificados;
