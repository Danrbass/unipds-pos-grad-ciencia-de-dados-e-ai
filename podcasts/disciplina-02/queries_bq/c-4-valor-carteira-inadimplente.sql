-- Parte C, questão 4: Qual é o valor total da carteira inadimplente?

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
  SUM(IF(status_inadimplencia = 'inadimplente', loan_amount, NULL)) AS valor_carteira_inadimplente
FROM classificados;
