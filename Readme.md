#  Zomato SQL Analytics Project

A SQL-based data analysis project using a Zomato-style dataset (users, restaurants, menu, food items, and orders) to derive business insights around revenue, customer behavior, and restaurant performance.

**Dataset source:** [Zomato Database — Kaggle](https://www.kaggle.com/datasets/anas123siddiqui/zomato-database)

---

##  Project Structure

```
├── schema.sql          # Table creation (DDL)
├── datacleaning.sql    # Data cleaning & validation queries
├── queries.sql         # Business analysis queries
└── README.md
```

---

##  How to Run

Run the files in this exact order:

1. **`schema.sql`** — creates all tables
2. **Load the CSV data** into the tables (via `LOAD DATA INFILE`, MySQL Workbench import wizard, or similar)
3. **`datacleaning.sql`** — cleans and validates the loaded data (duplicates, nulls, type/format issues)
4. **`queries.sql`** — runs the business insight queries against clean data

>  Built and tested on **MySQL 8.0+**. Column names containing spaces (e.g. `Family size`, `Monthly Income`) are wrapped in backticks throughout.

---

##  Database Schema

**Users**
| Column | Description |
|---|---|
| user_id | Primary key |
| name, email, password | User details |
| Age, Gender | Demographics |
| Marital Status | Single / Married / Prefer not to say |
| Occupation | User's profession |
| Monthly Income | Income bracket |
| Educational Qualification | Education level |
| Family size | Household size |

**Restaurant**
| Column | Description |
|---|---|
| id | Primary key |
| name, city, address | Restaurant details |
| rating, rating_count | Review metrics |
| cost, cuisine | Pricing & category |
| lic_no, link | License & website |

**Menu**
| Column | Description |
|---|---|
| menu_id | Primary key |
| r_id | FK → Restaurant.id |
| f_id | FK → Food.f_id |
| cuisine, price | Item details |

**Food**
| Column | Description |
|---|---|
| f_id | Primary key |
| item | Food item name |
| veg_or_non_veg | Category flag |

**Orders**
| Column | Description |
|---|---|
| order_id | Primary key |
| order_date | Timestamp of order |
| sales_qty, sales_amount, currency | Order value details |
| user_id | FK → Users.user_id |
| r_id | FK → Restaurant.id |

> **Note:** `Orders` does not store which specific menu item was ordered (no `f_id`/`menu_id`), so item-level order analysis (e.g. "veg vs non-veg orders") isn't possible with this schema — only restaurant- and customer-level analysis.

---

##  Data Cleaning Steps

- Checked for and handled duplicate `menu_id` values in `Menu`
- Verified consistent data types for `r_id` across tables
- Checked for nulls in key fields (ratings, cost, address, license)
- Standardized casing/whitespace in categorical fields (city, gender, cuisine)
- Validated numeric fields (price, sales_amount) for negative/zero/non-numeric values
- Checked rating values fall within valid bounds (0–5)

---

##  Business Questions & Insights

| # | Question | Insight |
|---|---|---|
| 1 | Which restaurants generate the most revenue? | Identifies top-performing partners to prioritize for promotions/retention |
| 2 | Which customer segment (by occupation) spends the most? | Helps target marketing at the right demographic |
| 3 | What's the monthly revenue trend? | Reveals growth, decline, or seasonality for forecasting |
| 4 | Which cuisines drive the most orders and revenue? | Informs menu/partner strategy |
| 5 | Who are the top 10 highest-value customers? | Feeds directly into a loyalty/VIP program |
| 6 | Does family size or marital status affect order value? | Informs family-combo / portion-size marketing |

Each query in `queries.sql` is commented with the business question it answers.

---

##  Tools Used

- MySQL 8.0
- MySQL Workbench (for querying and CSV import)

---

##  Key Learnings / Notes

- Schema limitations (no item-level link in `Orders`) mean item-level questions (e.g. veg vs non-veg order breakdown) aren't reliably answerable with this schema — an important reminder that data availability shapes which business questions can actually be answered.
- Joins across `Orders` → `Menu` can cause row fan-out if not handled carefully (a restaurant with multiple menu items will duplicate order rows, inflating order counts and revenue). Where order-level accuracy mattered (e.g. cuisine analysis), joining through `Restaurant.cuisine` instead of `Menu.cuisine` avoids this issue.

---

##  Possible Extensions

- Add a proper `order_items` linking table (order_id, f_id, quantity) to enable true item-level analysis
- Build a dashboard (Power BI / Tableau) on top of `queries.sql` outputs
- Add cohort/retention analysis once more order history is available
