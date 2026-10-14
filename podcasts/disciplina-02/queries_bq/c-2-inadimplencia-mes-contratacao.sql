-- Parte C, questão 2: Calcule a taxa de inadimplência por mês de contratação.

WITH classificados AS (
  SELECT
    contract_date,
    CASE
      WHEN payment_date IS NOT NULL AND payment_date > DATE_ADD(due_date, INTERVAL 15 DAY) THEN 'inadimplente'
      WHEN payment_date IS NOT NULL THEN 'adimplente'
      WHEN DATE_ADD(due_date, INTERVAL 15 DAY) <= DATE '2026-08-23' THEN 'inadimplente'
      ELSE 'nao_maturado'
    END AS status_inadimplencia
  FROM `SEU_PROJETO.SEU_DATASET.loans`
)
SELECT
  DATE_TRUNC(contract_date, MONTH) AS mes_contratacao,
  COUNTIF(status_inadimplencia = 'inadimplente') AS qtd_inadimplentes,
  COUNTIF(status_inadimplencia IN ('adimplente', 'inadimplente')) AS qtd_classificados,
  ROUND(
    COUNTIF(status_inadimplencia = 'inadimplente')
      / COUNTIF(status_inadimplencia IN ('adimplente', 'inadimplente')),
    4
  ) AS taxa_inadimplencia
FROM classificados
GROUP BY mes_contratacao
HAVING COUNTIF(status_inadimplencia IN ('adimplente', 'inadimplente')) >= 20
ORDER BY mes_contratacao;
