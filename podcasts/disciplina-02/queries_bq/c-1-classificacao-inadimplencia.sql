-- Parte C, questão 1: Identifique quais contratos devem ser classificados como inadimplentes de acordo com a regra definida.

SELECT
  loan_id,
  customer_id,
  contract_date,
  due_date,
  payment_date,
  loan_amount,
  amount_paid,
  CASE
    WHEN payment_date IS NOT NULL AND payment_date > DATE_ADD(due_date, INTERVAL 15 DAY) THEN 'inadimplente'
    WHEN payment_date IS NOT NULL THEN 'adimplente'
    WHEN DATE_ADD(due_date, INTERVAL 15 DAY) <= DATE '2026-08-23' THEN 'inadimplente'
    ELSE 'nao_maturado'
  END AS status_inadimplencia
FROM `SEU_PROJETO.SEU_DATASET.loans`
ORDER BY contract_date;
