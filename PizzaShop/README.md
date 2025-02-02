h1>Description</h1>
<p>The Order and Inventory Management System is a SQL-based project that provides insights into order processing, inventory tracking, and employee management. This system utilizes SQL queries and views to manage and analyze business operations, such as order activity, ingredient usage, and staff costs.</p>
<h1>Features</h1>
<h3>Order Activity</h3>
<ul>
  <li>Retrieves order details, including item price, category, name, and customer delivery details</li>
  <li>Joins orders, item, and address tables to provide a comprehensive overview of each order</li>
</ul>
<h3>Inventory Management</h3>
<ul>
  <li>Tracks inventory usage based on order quantities and recipes</li>
  <li>Calculates ingredient costs per order using price per unit weight</li>
  <li>Determines remaining inventory weight after order fulfillment</li>
</ul>
<h3>Views for Data Aggregation</h3>
<ul>
  <li>Creates a SQL VIEW (order_ingredients_cost) for tracking ingredient costs per order</li>
  <li>Provides a structured way to analyze ingredient expenses and order impact on inventory</li>
</ul>
<h3>Employee Management</h3>
<ul>
  <li>Retrieves employee shift details, including hours worked and associated labor costs</li>
  <li>Uses SQL functions to calculate total working hours and costs based on hourly rates</li>
</ul>
