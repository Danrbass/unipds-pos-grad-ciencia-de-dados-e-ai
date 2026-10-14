-- Parte B, questão 2: Calcule a taxa de aprovação por faixa de risk_score.

SELECT
  CASE
    WHEN risk_score IS NULL THEN 'Sem score'
    WHEN risk_score < 200 THEN '0-199'
    WHEN risk_score < 400 THEN '200-399'
    WHEN risk_score < 600 THEN '400-599'
    WHEN risk_score < 800 THEN '600-799'
    ELSE '800-1000'
  END AS faixa_risk_score,
  COUNT(*) FILTER (WHERE status = 'approved') AS qtd_aprovadas,
  COUNT(*) AS qtd_total,
  ROUND(COUNT(*) FILTER (WHERE status = 'approved') * 1.0 / COUNT(*), 4) AS taxa_aprovacao
FROM credit_applications
GROUP BY faixa_risk_score
ORDER BY MIN(COALESCE(risk_score, -1));
