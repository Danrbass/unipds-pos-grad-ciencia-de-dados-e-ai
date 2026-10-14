-- Parte D, questão 3: Identifique clientes que tiveram uma solicitação rejeitada e
-- posteriormente uma solicitação aprovada.

SELECT DISTINCT ca1.customer_id
FROM `SEU_PROJETO.SEU_DATASET.credit_applications` ca1
WHERE ca1.status = 'rejected'
  AND EXISTS (
    SELECT 1
    FROM `SEU_PROJETO.SEU_DATASET.credit_applications` ca2
    WHERE ca2.customer_id = ca1.customer_id
      AND ca2.status = 'approved'
      AND ca2.application_date > ca1.application_date
  )
ORDER BY ca1.customer_id;
