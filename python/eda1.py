
# ==========================================
# OLIST E-COMMERCE - ORDER ANALYSIS
# ==========================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Load Dataset
orders = pd.read_csv("data/raw/olist_orders_dataset.csv")

# 2. Convert Purchase Date into Datetime
orders["order_purchase_timestamp"] = pd.to_datetime(
    orders["order_purchase_timestamp"]
)

# 3. Total Orders
print("\nTotal Orders:")
print(orders["order_id"].nunique())

# 4. Order Status Analysis
print("\nOrder Status Analysis:")
status_count = orders["order_status"].value_counts()
print(status_count)

# 5. Monthly Orders Analysis
orders["month"] = orders["order_purchase_timestamp"].dt.to_period("M")

monthly_orders = orders.groupby("month")["order_id"].nunique()

print("\nMonthly Orders:")
print(monthly_orders)

# 6. Plot Order Status
plt.figure(figsize=(9, 5))
status_count.plot(kind="bar")

plt.title("Order Status Distribution")
plt.xlabel("Order Status")
plt.ylabel("Number of Orders")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 7. Plot Monthly Orders
plt.figure(figsize=(12, 5))
monthly_orders.plot(kind="line", marker="o")

plt.title("Monthly Order Trend")
plt.xlabel("Month")
plt.ylabel("Number of Orders")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()

print("\nOrder Analysis Completed Successfully!")
