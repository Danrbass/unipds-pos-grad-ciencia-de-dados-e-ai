-- Parte C, questão 2: Calcule a taxa de inadimplência por mês de contratação.

WITH classificados AS (
  SELECT
    contract_date,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > due_date + INTERVAL 15 DAY THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN due_date + INTERVAL 15 DAY <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM loans
)
SELECT
  DATE_TRUNC('month', contract_date) AS mes_contratacao,
  COUNT(*) FILTER (WHERE status_inadimplencia = 'inadimplente') AS qtd_inadimplentes,
  COUNT(*) FILTER (WHERE status_inadimplencia IN ('adimplente', 'inadimplente')) AS qtd_classificados,
  ROUND(
    COUNT(*) FILTER (WHERE status_inadimplencia = 'inadimplente') * 1.0
      / COUNT(*) FILTER (WHERE status_inadimplencia IN ('adimplente', 'inadimplente')),
    4
  ) AS taxa_inadimplencia
FROM classificados
GROUP BY mes_contratacao
HAVING COUNT(*) FILTER (WHERE status_inadimplencia IN ('adimplente', 'inadimplente')) >= 20
ORDER BY mes_contratacao;
