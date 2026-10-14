-- Parte A, questão 4: Qual o ticket médio solicitado e o ticket médio aprovado?

SELECT
  ROUND(AVG(requested_amount), 2) AS ticket_medio_solicitado,
  ROUND(AVG(approved_amount), 2) AS ticket_medio_aprovado
FROM credit_applications;
