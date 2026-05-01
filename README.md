# Hospital Analytics Dashboard

An end-to-end data analytics project that simulates a hospital management system and delivers actionable insights through an interactive dashboard.

---

## Overview

This project demonstrates a complete data workflow starting from database design to visualization. A relational database was built using MySQL (Dockerized), populated with realistic synthetic data, and analyzed using SQL. The insights are presented through an interactive dashboard built with Python (Streamlit + Plotly).

---

## Tech Stack

* **Database:** MySQL (Docker)
* **Query Language:** SQL
* **Backend & Analysis:** Python (Pandas)
* **Visualization:** Streamlit, Plotly
* **Tools:** MySQL Workbench, Docker

---

## Features

* Revenue analysis by department
* Appointment status distribution
* Doctor workload analysis
* Daily revenue trend visualization
* Interactive dashboard with filtering capability

---

## Project Structure

```
hospital-analytics-dashboard/
│
├── app.py
├── requirements.txt
├── README.md
│
├── sql/
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── analytics_queries.sql
|   ├── ERR_diagram.png
│
├── screenshots/
│   └── dashboard 1.png
│   └── dashboard 2.png
│   └── sql_view.png
│
└── docker/
    └── docker_setup.txt
```

---

## How to Run

### 1. Start MySQL using Docker

```
docker run --name hms-mysql -p 3307:3306 -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=hms -d mysql:8
```

---

### 2. Install Dependencies

```
pip install -r requirements.txt
```

---

### 3. Run the Dashboard

```
streamlit run app.py
```

---

## Database Workflow

1. Designed normalized relational schema (patients, staff, appointments, admissions, invoices)
2. Implemented foreign key relationships for data integrity
3. Generated scalable synthetic dataset
4. Wrote SQL queries to extract business insights

---

## Key Insights

* Revenue varies significantly across departments
* No-show appointments impact operational efficiency
* Doctor workload distribution is uneven
* Revenue trends highlight peak activity periods

---

## Learnings

* Practical experience in relational database design
* Writing analytical SQL queries for real-world scenarios
* Building interactive dashboards using Streamlit
* Integrating MySQL with Python for data analysis

---

## Future Improvements

* Add real-time data ingestion
* Deploy dashboard on cloud platforms
* Introduce predictive analytics (machine learning)
* Enhance UI with advanced filtering and layout

---

## Author
Debarati Pal
[Your Name]

