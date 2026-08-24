# Database Layer

This folder contains the SQL scripts used to build and validate the Olist relational database.

## Scope

The database was created from the original Olist flat files and structured into relational tables.

### Database Components

- 9 relational tables
- 8 primary keys
- 7 foreign keys
- 2 composite primary keys
- 6 check constraints
- Foreign key integrity validation
- Duplicate and NULL validation
- Orphan record validation

## Data Quality

During validation, two credit-card payment records were identified with zero installments while having positive payment values.

These records were preserved as part of the original dataset and documented as data quality exceptions.
