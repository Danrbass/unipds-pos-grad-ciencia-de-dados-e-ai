-- DDL BigQuery Standard SQL para o case "SQL na Prática: Um Caso de Crédito"
-- Ajuste `SEU_PROJETO.SEU_DATASET` antes de rodar.
-- Depois de criar as tabelas, carregue os CSVs (customers.csv, credit_applications.csv,
-- loans.csv) via console do BigQuery ou `bq load --source_format=CSV --skip_leading_rows=1`.

CREATE TABLE `SEU_PROJETO.SEU_DATASET.customers` (
  customer_id INT64 NOT NULL,
  created_at DATE NOT NULL,
  state STRING,
  income FLOAT64,
  age INT64
);

CREATE TABLE `SEU_PROJETO.SEU_DATASET.credit_applications` (
  application_id INT64 NOT NULL,
  customer_id INT64 NOT NULL,
  application_date DATE NOT NULL,
  requested_amount FLOAT64 NOT NULL,
  approved_amount FLOAT64,
  status STRING NOT NULL,
  risk_score INT64
);

CREATE TABLE `SEU_PROJETO.SEU_DATASET.loans` (
  loan_id INT64 NOT NULL,
  customer_id INT64 NOT NULL,
  contract_date DATE NOT NULL,
  loan_amount FLOAT64 NOT NULL,
  due_date DATE NOT NULL,
  payment_date DATE,
  amount_paid FLOAT64
);
