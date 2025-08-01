# TimeSheet - Oracle RDBMS

A database project for an employee time tracking system (TimeSheet), implemented on Oracle Database.  
This project includes SQL scripts to create tables, constraints, views, triggers, and procedures for a comprehensive time management solution.

## Overview

**TimeSheet** is a relational database system designed to help organizations efficiently track employees' working hours, project allocations, and attendance.  
The project is tailored for Oracle RDBMS and can be used as a starting point for developing a complete time management application.

## Features

- Employees and departments management
- Daily time logging (attendance, work hours, etc.)
- Project assignment and tracking
- Leave requests and approvals
- Detailed reporting via views
- Data consistency enforced by triggers and constraints
- Modular structure for easy extension

## Database Schema

The SQL script (`rdbms_davax_tema_complet.sql`) creates all necessary objects, including:

- **Tables**: employees, departments, timesheets, projects, leave_requests, etc.
- **Views**: for reporting and summarizing attendance
- **Triggers**: to enforce business logic (e.g., preventing duplicate entries)
- **Procedures & Functions**: for common operations (e.g., time logging, approvals)

*You can open the SQL file for detailed table structures and relationships.*

## Installation

1. **Prerequisites:**
   - Oracle Database (tested on 12c/19c, but compatible with most versions)
   - SQL*Plus, SQL Developer, or any compatible SQL client

2. **Setup Steps:**
   - Clone or download this repository
   - Open your SQL client and connect to your Oracle database
   - Run the script:
     ```sql
     @rdbms_davax_tema_complet.sql
     ```

## Usage

- Insert data into core tables (employees, departments, projects) using the provided procedures or via SQL commands.
- Use the views for quick reporting and data aggregation.
- Extend or adapt the logic as needed for your use-case.

---
