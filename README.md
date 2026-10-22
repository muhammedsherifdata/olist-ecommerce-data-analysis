# Brazilian E-Commerce Analysis (Olist)

End-to-end data analytics project on the Olist Brazilian e-commerce dataset, covering database design, data validation, data modeling, a multi-page Power BI dashboard and business insights.

## Tools & Technologies

- SQL Server
- Power BI
- DAX
- Data Modeling
- Data Validation

## Project Workflow

1. **Database design:** turned 9 raw flat files into a structured SQL Server database with primary keys, foreign keys and constraints (see the `database` folder).
2. **Data validation:** ran validation checks that exposed duplicate keys and invalid values, and resolved them before loading.
3. **Data model:** built the Power BI data model on top of the validated database.
4. **Dashboard:** built a multi-page Power BI dashboard (99K orders, 15.8M revenue) with five pages: Executive Overview, Sales & Product Performance, Customer Insights & Retention, Delivery & Logistics, Reviews & Payments (screenshots in `Dashboard/Screenshots`).

## Key Findings

- **Retention:** 96.9% of customers bought only once.
- **Delivery:** 8.1% of orders (7.8K) were delivered late, with late-delivery rates of about 24% in AL and 20% in MA.
- **Delivery vs. satisfaction:** late orders scored about 2.5 in reviews versus about 4.3 for on-time orders. The link was tested rather than assumed to be causal.

## Recommendations

- Evaluate carrier alternatives in the states with the highest late-delivery rates.
- Improve returns handling.
- Re-target one-time buyers to improve retention.

## Repository Structure

```
olist-ecommerce-data-analysis
├── Dashboard/Screenshots
├── database
└── README.md
```
