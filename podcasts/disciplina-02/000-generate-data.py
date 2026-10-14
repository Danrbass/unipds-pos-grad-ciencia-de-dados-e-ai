"""Gera os 3 datasets sinteticos do case de credito (customers, credit_applications, loans).

Pontos de atencao cobertos na geracao:
- Clientes com mais de uma solicitacao de credito, incluindo o padrao rejeitado -> aprovado.
- Clientes aprovados que nao contrataram o emprestimo (nem toda aprovacao vira loan).
- Clientes com mais de um contrato (loan).
- Pagamentos realizados antes, no dia e depois do vencimento.
- Contratos ainda sem pagamento.
- Contratos recentes cujo vencimento ainda nao completou a janela de 15 dias de
  inadimplencia (ficam com payment_date/amount_paid nulos, nem pagos nem classificaveis).
- Valores nulos em campos em que isso faz sentido (income, age, risk_score).
- risk_score determina tanto a probabilidade de aprovacao quanto a de inadimplencia,
  com diferenca perceptivel entre faixas (para sustentar a questao aberta do case).

Regra de inadimplencia: pagamento >15 dias apos vencimento OU sem pagamento apos esse prazo.

Rodar: python3 000-generate-data.py
Saida: customers.csv, credit_applications.csv, loans.csv (na pasta data/).
"""

import csv
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(42)

SNAPSHOT_DATE = date(2026, 8, 23)
CUSTOMER_START = date(2022, 1, 1)
N_CUSTOMERS = 10_000
OUT_DIR = Path(__file__).resolve().parent / "data"

STATES = [
    "SP", "MG", "RJ", "BA", "PR", "RS", "PE", "CE", "PA", "SC",
    "GO", "MA", "PB", "ES", "PI", "AL", "RN", "MT", "DF", "MS",
    "SE", "RO", "TO", "AM", "AC", "AP", "RR",
]
STATE_WEIGHTS = [
    22, 10, 8, 7, 6, 6, 5, 4, 4, 4,
    3, 3, 2, 2, 2, 2, 2, 2, 2, 1,
    1, 1, 1, 2, 0.5, 0.5, 0.5,
]

APPS_PER_CUSTOMER = [1, 2, 3, 4]
APPS_PER_CUSTOMER_WEIGHTS = [0.45, 0.35, 0.15, 0.05]

TERM_DAYS_CHOICES = [30, 60, 90, 120, 180, 270, 360]
TERM_DAYS_WEIGHTS = [0.15, 0.20, 0.20, 0.15, 0.15, 0.10, 0.05]

P_CONTRACT_IF_APPROVED = 0.93


def rand_date(start: date, end: date) -> date:
    if end <= start:
        return start
    delta_days = (end - start).days
    return start + timedelta(days=random.randint(0, delta_days))


def clip(value, lo, hi):
    return max(lo, min(hi, value))


def p_approve(score: float) -> float:
    return clip(0.10 + 0.80 * (score / 1000), 0.05, 0.95)


def p_bad(score: float) -> float:
    return clip(0.32 - 0.30 * (score / 1000), 0.02, 0.35)


def gen_customers():
    customers = []
    for customer_id in range(1, N_CUSTOMERS + 1):
        created_at = rand_date(CUSTOMER_START, SNAPSHOT_DATE)
        state = random.choices(STATES, weights=STATE_WEIGHTS, k=1)[0]

        income = None
        if random.random() > 0.03:
            income = round(clip(random.lognormvariate(8.16, 0.5), 800, 60_000), 2)

        age = None
        if random.random() > 0.015:
            age = int(round(clip(random.triangular(18, 70, 30), 18, 75)))

        latent_quality = random.gauss(0, 1)
        customers.append({
            "customer_id": customer_id,
            "created_at": created_at,
            "state": state,
            "income": income,
            "age": age,
            "_latent_quality": latent_quality,
        })
    return customers


def gen_applications(customers):
    applications = []
    application_id = 1

    for cust in customers:
        n_apps = random.choices(APPS_PER_CUSTOMER, weights=APPS_PER_CUSTOMER_WEIGHTS, k=1)[0]
        last_date = cust["created_at"]

        for _ in range(n_apps):
            gap_days = random.randint(10, 170)
            application_date = last_date + timedelta(days=gap_days)
            if application_date > SNAPSHOT_DATE:
                break
            last_date = application_date

            true_score = clip(
                550 + 150 * cust["_latent_quality"] + random.gauss(0, 80), 0, 1000
            )
            requested_amount = round(clip(random.lognormvariate(8.99, 0.6), 500, 80_000), 2)

            approved = random.random() < p_approve(true_score)
            status = "approved" if approved else "rejected"
            approved_amount = None
            if approved:
                approved_amount = round(requested_amount * random.uniform(0.5, 1.0), 2)

            risk_score_display = None
            if random.random() > 0.03:
                risk_score_display = int(round(true_score))

            applications.append({
                "application_id": application_id,
                "customer_id": cust["customer_id"],
                "application_date": application_date,
                "requested_amount": requested_amount,
                "approved_amount": approved_amount,
                "status": status,
                "risk_score": risk_score_display,
                "_true_score": true_score,
                "_approved_amount_raw": approved_amount,
            })
            application_id += 1

    return applications


def gen_loans(applications):
    loans = []
    loan_id = 1

    for app in applications:
        if app["status"] != "approved":
            continue
        if random.random() >= P_CONTRACT_IF_APPROVED:
            continue

        contract_date = app["application_date"] + timedelta(days=random.randint(1, 10))
        if contract_date > SNAPSHOT_DATE:
            continue

        loan_amount = round(app["_approved_amount_raw"] * random.uniform(0.95, 1.0), 2)
        term_days = random.choices(TERM_DAYS_CHOICES, weights=TERM_DAYS_WEIGHTS, k=1)[0]
        due_date = contract_date + timedelta(days=term_days)

        payment_date = None
        amount_paid = None

        if due_date <= SNAPSHOT_DATE:
            bad = random.random() < p_bad(app["_true_score"])
            if bad:
                if random.random() < 0.55:
                    delay = random.randint(16, 90)
                    candidate = due_date + timedelta(days=delay)
                    if candidate <= SNAPSHOT_DATE:
                        payment_date = candidate
                        amount_paid = round(loan_amount * random.uniform(0.98, 1.18), 2)
                # else: never pays -> fica nulo
            else:
                if random.random() < 0.70:
                    delay = random.randint(-5, 0)
                else:
                    delay = random.randint(1, 14)
                candidate = due_date + timedelta(days=delay)
                if candidate <= SNAPSHOT_DATE:
                    payment_date = candidate
                    amount_paid = round(loan_amount * random.uniform(0.98, 1.18), 2)

        loans.append({
            "loan_id": loan_id,
            "customer_id": app["customer_id"],
            "contract_date": contract_date,
            "loan_amount": loan_amount,
            "due_date": due_date,
            "payment_date": payment_date,
            "amount_paid": amount_paid,
        })
        loan_id += 1

    return loans


def write_csv(path, rows, fieldnames):
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            clean = {k: ("" if row.get(k) is None else row[k]) for k in fieldnames}
            writer.writerow(clean)


def generate_all():
    customers = gen_customers()
    applications = gen_applications(customers)
    loans = gen_loans(applications)

    write_csv(
        OUT_DIR / "customers.csv",
        customers,
        ["customer_id", "created_at", "state", "income", "age"],
    )
    write_csv(
        OUT_DIR / "credit_applications.csv",
        applications,
        ["application_id", "customer_id", "application_date", "requested_amount",
         "approved_amount", "status", "risk_score"],
    )
    write_csv(
        OUT_DIR / "loans.csv",
        loans,
        ["loan_id", "customer_id", "contract_date", "loan_amount", "due_date",
         "payment_date", "amount_paid"],
    )

    print(f"customers: {len(customers)}")
    print(f"credit_applications: {len(applications)}")
    print(f"loans: {len(loans)}")


if __name__ == "__main__":
    generate_all()
