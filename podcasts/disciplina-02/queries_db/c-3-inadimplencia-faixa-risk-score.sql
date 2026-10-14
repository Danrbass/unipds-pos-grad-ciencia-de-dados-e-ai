-- Parte C, questão 3: Calcule a taxa de inadimplência por faixa de risk_score.

WITH classificados AS (
  SELECT
    loan_id,
    customer_id,
    contract_date,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > due_date + INTERVAL 15 DAY THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN due_date + INTERVAL 15 DAY <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM loans
),
com_score AS (
  SELECT
    c.*,
    (
      SELECT ca.risk_score
      FROM credit_applications ca
      WHERE ca.customer_id = c.customer_id
        AND ca.status = 'approved'
        AND ca.application_date <= c.contract_date
      ORDER BY ca.application_date DESC
      LIMIT 1
    ) AS risk_score_referencia
  FROM classificados c
  WHERE c.status_inadimplencia IN ('adimplente', 'inadimplente')
)
SELECT
  CASE
    WHEN risk_score_referencia IS NULL THEN 'Sem score'
    WHEN risk_score_referencia < 200 THEN '0-199'
    WHEN risk_score_referencia < 400 THEN '200-399'
    WHEN risk_score_referencia < 600 THEN '400-599'
    WHEN risk_score_referencia < 800 THEN '600-799'
    ELSE '800-1000'
  END AS faixa_risk_score,
  COUNT(*) FILTER (WHERE status_inadimplencia = 'inadimplente') AS qtd_inadimplentes,
  COUNT(*) AS qtd_classificados,
  ROUND(COUNT(*) FILTER (WHERE status_inadimplencia = 'inadimplente') * 1.0 / COUNT(*), 4) AS taxa_inadimplencia
FROM com_score
GROUP BY faixa_risk_score
ORDER BY MIN(COALESCE(risk_score_referencia, -1));
