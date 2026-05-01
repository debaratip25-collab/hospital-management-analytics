import streamlit as st
import pandas as pd
import mysql.connector
import plotly.express as px

st.set_page_config(page_title="Hospital Dashboard", layout="wide")

# DB connection
@st.cache_resource
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        port=3307,
        user="root",
        password="pass",
        database="hms"
    )

conn = get_connection()

@st.cache_data
def load_data(query):
    return pd.read_sql(query, conn)

# Queries
df_rev = load_data("""
SELECT d.dept_name, SUM(i.amount) AS revenue
FROM invoices i
JOIN admissions a ON i.admission_id = a.admission_id
JOIN departments d ON a.dept_id = d.dept_id
GROUP BY d.dept_id;
""")

df_status = load_data("""
SELECT status, COUNT(*) AS count
FROM appointments
GROUP BY status;
""")

df_doc = load_data("""
SELECT s.first_name, COUNT(a.appt_id) AS total_appointments
FROM staff s
JOIN appointments a ON s.staff_id = a.doctor_id
GROUP BY s.staff_id;
""")

df_trend = load_data("""
SELECT DATE(invoice_datetime) AS date, SUM(amount) AS revenue
FROM invoices
GROUP BY DATE(invoice_datetime)
ORDER BY date;
""")

# Title
st.title("🏥 Hospital Analytics Dashboard")

# KPIs
col1, col2 = st.columns(2)
col1.metric("Total Revenue", f"{df_rev['revenue'].sum():,.0f}")
col2.metric("Total Appointments", int(df_status['count'].sum()))

# Charts
st.subheader("Revenue by Department")
fig1 = px.bar(df_rev, x="dept_name", y="revenue")
st.plotly_chart(fig1, use_container_width=True)

st.subheader("Appointment Status")
fig2 = px.pie(df_status, names="status", values="count", hole=0.4)
st.plotly_chart(fig2, use_container_width=True)

st.subheader("Doctor Workload")
fig3 = px.bar(df_doc, x="first_name", y="total_appointments")
st.plotly_chart(fig3, use_container_width=True)

st.subheader("Revenue Trend")
fig4 = px.line(df_trend, x="date", y="revenue", markers=True)
st.plotly_chart(fig4, use_container_width=True)