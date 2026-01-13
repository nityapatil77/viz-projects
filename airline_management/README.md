# Airline Management & Flight Tracking System

**CS 4400: Introduction to Database Systems** at Georgia Tech. 

## Project Overview
This project is a relational database system designed to manage the logistics of a global airline network. The system tracks everything from airplane maintenance to passenger frequent flyer miles and real-time flight statuses. 

The database was created to solve the complex challenge of coordinating interconnected entities in a high-stakes environment:
* **Strict Constraint Enforcement:** Ensuring data integrity, such as requiring Boeing aircraft to have at least two pilots before takeoff.
* **Dynamic Logistics:** Managing a "Location" system where a person can be at an airport or on a specific airplane at any given time.
* **Financial & Geographical Tracking:** Automating revenue collection for airlines and frequent flyer mile updates for passengers based on flight distances.

---

## Steps Taken 
* The first step was to create an entity-relationship diagram.
* This was vital to understand how everything was to be related when we created the database.
[entity-relationship.pdf](https://github.com/user-attachments/files/24279435/entity-relationship.1.pdf)
* We then created the database using dummy data, and given certain constraints, created procedures to deal with uncertainty.

---

## Tech Stack & Tools
* **Language:** SQL (MySQL)
* **Environment:** GitHub Codespaces
* **Database Engine:** InnoDB (to support foreign key constraints and ACID transactions)

---

## Database Architecture
The schema is built around several core entities:
* **Entities:** `location`, `airport`, `airline`, `airplane`, `pilot`, and `passenger`.
* **Flight Mechanics:** `legs` define the distance between two airports, which are then grouped into `route` paths.
* **Automated Logic:** Stored procedures like `simulation_cycle()` handle the chronological progression of the database state.

---

## How to See the Results

### 1. Initialize the Database
Execute `database_creation.sql` to build the tables and insert the initial seed data, including 25+ airports and 11 major airlines.

### 2. Load the Procedures
Run `airline_procedures.sql` to implement the system's logic, including custom functions like `leg_time` and procedures like `passengers_board`.

### 3. Run a Simulation
To progress the database state, call the simulation procedure:
```sql
CALL simulation_cycle();
