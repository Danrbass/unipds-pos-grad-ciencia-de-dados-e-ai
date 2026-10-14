-- Parte C, questão 4: Qual é o valor total da carteira inadimplente?

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
  SUM(loan_amount) FILTER (WHERE status_inadimplencia = 'inadimplente') AS valor_carteira_inadimplente
FROM classificados;
