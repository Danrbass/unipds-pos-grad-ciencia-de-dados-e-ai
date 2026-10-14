-- Parte D, questão 5: Divida os clientes em cinco grupos de acordo com o risk_score e
-- calcule a inadimplência de cada grupo.

WITH classificados AS (
  SELECT
    loan_id,
    customer_id,
    contract_date,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > DATE_ADD(due_date, INTERVAL 15 DAY) THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN DATE_ADD(due_date, INTERVAL 15 DAY) <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM `SEU_PROJETO.SEU_DATASET.loans`
),
com_score AS (
  SELECT
    c.*,
    (
      SELECT ca.risk_score
      FROM `SEU_PROJETO.SEU_DATASET.credit_applications` ca
      WHERE ca.customer_id = c.customer_id
        AND ca.status = 'approved'
        AND ca.application_date <= c.contract_date
      ORDER BY ca.application_date DESC
      LIMIT 1
    ) AS risk_score_referencia
  FROM classificados c
  WHERE c.status_inadimplencia IN ('adimplente', 'inadimplente')
),
com_quintil AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY risk_score_referencia, loan_id) AS quintil_risk_score
  FROM com_score
  WHERE risk_score_referencia IS NOT NULL
)
SELECT
  quintil_risk_score,
  MIN(risk_score_referencia) AS score_min,
  MAX(risk_score_referencia) AS score_max,
  COUNTIF(status_inadimplencia = 'inadimplente') AS qtd_inadimplentes,
  COUNT(*) AS qtd_contratos,
  ROUND(COUNTIF(status_inadimplencia = 'inadimplente') / COUNT(*), 4) AS taxa_inadimplencia
FROM com_quintil
GROUP BY quintil_risk_score
ORDER BY quintil_risk_score;
