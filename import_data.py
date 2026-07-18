import pandas as pd
import sqlite3

# Connect to (or create) the SQLite database
conn = sqlite3.connect("database/zomato.db")

# Read CSV files
users = pd.read_csv("dataset/users.csv")
restaurants = pd.read_csv("dataset/restaurant.csv")
food = pd.read_csv("dataset/food.csv")
menu = pd.read_csv("dataset/menu.csv")
orders = pd.read_csv("dataset/orders.csv")

# Write each DataFrame to a table
users.to_sql("users", conn, if_exists="replace", index=False)
restaurants.to_sql("restaurant", conn, if_exists="replace", index=False)
food.to_sql("food", conn, if_exists="replace", index=False)
menu.to_sql("menu", conn, if_exists="replace", index=False)
orders.to_sql("orders", conn, if_exists="replace", index=False)

# Close the connection
conn.close()

print("✅ Database 'zomato.db' created successfully!")