/* CS 4400: Introduction to Database Systems (Spring 2025)
Phase II: Create Table & Insert Statements [v0] Monday, February 3, 2025 @ 17:00
EST

Team 1
Nitya Patil (npatil70) 
Emma Li (eli314)
Kate Jeong (kjeong40)
Hyeyeon (Olivia) Shim (hshim40) */

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.
/* This is a standard preamble for most of our scripts. The intent is to establish
a consistent environment for the database behavior. */

set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'airline_management';
drop database if exists airline_management;
create database if not exists airline_management;
use airline_management;

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and
foreign key
declarations, and data insertion statements here. You may sequence them in any
order that
works for you. When executed, your statements must create a functional database
that contains
all of the data, and supports as many of the constraints as reasonably possible. */


/* Location Table */
DROP TABLE IF EXISTS location;
CREATE TABLE location (
    locationID VARCHAR(100) NOT NULL PRIMARY KEY
) ENGINE=InnoDB;

INSERT INTO location (locationID) VALUES ('port_1');
INSERT INTO location (locationID) VALUES ('port_2');
INSERT INTO location (locationID) VALUES ('port_3');
INSERT INTO location (locationID) VALUES ('port_10');
INSERT INTO location (locationID) VALUES ('port_17');
INSERT INTO location (locationID) VALUES ('plane_1');
INSERT INTO location (locationID) VALUES ('plane_5');
INSERT INTO location (locationID) VALUES ('plane_8');
INSERT INTO location (locationID) VALUES ('plane_13');
INSERT INTO location (locationID) VALUES ('plane_20');
INSERT INTO location (locationID) VALUES ('port_12');
INSERT INTO location (locationID) VALUES ('port_14');
INSERT INTO location (locationID) VALUES ('port_15');
INSERT INTO location (locationID) VALUES ('port_20');
INSERT INTO location (locationID) VALUES ('port_4');
INSERT INTO location (locationID) VALUES ('port_16');
INSERT INTO location (locationID) VALUES ('port_11');
INSERT INTO location (locationID) VALUES ('port_23');
INSERT INTO location (locationID) VALUES ('port_7');
INSERT INTO location (locationID) VALUES ('port_6');
INSERT INTO location (locationID) VALUES ('port_13');
INSERT INTO location (locationID) VALUES ('port_21');
INSERT INTO location (locationID) VALUES ('port_18');
INSERT INTO location (locationID) VALUES ('port_22');
INSERT INTO location (locationID) VALUES ('plane_6');
INSERT INTO location (locationID) VALUES ('plane_18');
INSERT INTO location (locationID) VALUES ('plane_7');
INSERT INTO location (locationID) VALUES ('plane_2');
INSERT INTO location (locationID) VALUES ('plane_3');
INSERT INTO location (locationID) VALUES ('plane_4');
INSERT INTO location (locationID) VALUES ('port_24');
INSERT INTO location (locationID) VALUES ('plane_10');
INSERT INTO location (locationID) VALUES ('port_25');

/* Airport Table */
DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
    airportID char(3) NOT NULL PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    locationID VARCHAR(100),
    constraint fk1 foreign key (locationID) references location(locationID)
) ENGINE=InnoDB;

INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('ATL', 'Atlanta Hartsfield_Jackson International', 'Atlanta', 'Georgia', 'USA', 'port_1');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('DXB', 'Dubai International', 'Dubai', 'Al Garhoud', 'UAE', 'port_2');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('HND', 'Tokyo International Haneda', 'Ota City', 'Tokyo', 'JPN', 'port_3');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('LHR', 'London Heathrow', 'London', 'England', 'GBR', 'port_4');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('IST', 'Istanbul International', 'Arnavutkoy', 'Istanbul ', 'TUR', NULL);
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('DFW', 'Dallas_Fort Worth International', 'Dallas', 'Texas', 'USA', 'port_6');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('CAN', 'Guangzhou International', 'Guangzhou', 'Guangdong', 'CHN', 'port_7');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('DEN', 'Denver International', 'Denver', 'Colorado', 'USA', NULL);
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('LAX', 'Los Angeles International', 'Los Angeles', 'California', 'USA', NULL);
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('ORD', 'O_Hare International', 'Chicago', 'Illinois', 'USA', 'port_10');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('AMS', 'Amsterdam Schipol International', 'Amsterdam', 'Haarlemmermeer', 'NLD', 'port_11');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('CDG', 'Paris Charles de Gaulle', 'Roissy_en_France', 'Paris', 'FRA', 'port_12');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('FRA', 'Frankfurt International', 'Frankfurt', 'Frankfurt_Rhine_Main', 'DEU', 'port_13');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('MAD', 'Madrid Adolfo Suarez_Barajas', 'Madrid', 'Barajas', 'ESP', 'port_14');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('BCN', 'Barcelona International', 'Barcelona', 'Catalonia', 'ESP', 'port_15');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('FCO', 'Rome Fiumicino', 'Fiumicino', 'Lazio', 'ITA', 'port_16');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('LGW', 'London Gatwick', 'London', 'England', 'GBR', 'port_17');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('MUC', 'Munich International', 'Munich', 'Bavaria', 'DEU', 'port_18');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('MDW', 'Chicago Midway International', 'Chicago', 'Illinois', 'USA', NULL);
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('IAH', 'George Bush Intercontinental', 'Houston', 'Texas', 'USA', 'port_20');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('HOU', 'William P_Hobby International', 'Houston', 'Texas', 'USA', 'port_21');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('NRT', 'Narita International', 'Narita', 'Chiba', 'JPN', 'port_22');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('BER', 'Berlin Brandenburg Willy Brandt International', 'Berlin', 'Schonefeld', 'DEU', 'port_23');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('ICN', 'Incheon International Airport', 'Seoul', 'Jung_gu', 'KOR', 'port_24');
INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES ('PVG', 'Shanghai Pudong International Airport', 'Shanghai', 'Pudong', 'CHN', 'port_25');

/* Leg Table */
DROP TABLE IF EXISTS legs;
CREATE TABLE legs (
    legID VARCHAR(100) NOT NULL PRIMARY KEY,
    distance INT check (distance >= 0),
    departure varchar(100),
    arrival varchar(100)
) ENGINE=InnoDB;

INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_4', 600, 'ATL', 'ORD');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_1', 400, 'AMS', 'BER');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_2', 3900, 'ATL', 'AMS');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_31', 3700, 'ORD', 'CDG');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_14', 400, 'CDG', 'MUC');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_3', 3700, 'ATL', 'LHR');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_22', 600, 'LHR', 'BER');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_23', 500, 'LHR', 'MUC');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_29', 400, 'MUC', 'FCO');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_16', 800, 'FCO', 'MAD');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_25', 600, 'MAD', 'CDG');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_13', 200, 'CDG', 'LHR');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_24', 300, 'MAD', 'BCN');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_27', 300, 'MUC', 'BER');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_8', 600, 'BER', 'LGW');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_21', 600, 'LGW', 'BER');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_9', 300, 'BER', 'MUC');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_28', 400, 'MUC', 'CDG');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_11', 500, 'CDG', 'BCN');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_6', 300, 'BCN', 'MAD');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_26', 800, 'MAD', 'FCO');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_30', 200, 'MUC', 'FRA');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_17', 300, 'FRA', 'BER');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_7', 4700, 'BER', 'CAN');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_10', 1600, 'CAN', 'HND');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_18', 100, 'HND', 'NRT');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_5', 500, 'BCN', 'CDG');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_12', 600, 'CDG', 'FCO');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_15', 200, 'DFW', 'IAH');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_20', 100, 'IAH', 'HOU');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_19', 300, 'HOU', 'DFW');
INSERT INTO legs (legID, distance, departure, arrival) VALUES ('leg_32', 6800, 'DFW', 'ICN');

/* Route Table */
DROP TABLE IF EXISTS route;
CREATE TABLE route (
    routeID VARCHAR(100) NOT NULL PRIMARY KEY
) ENGINE=InnoDB;

INSERT INTO route (routeID) VALUES ('americas_hub_exchange');
INSERT INTO route (routeID) VALUES ('americas_one');
INSERT INTO route (routeID) VALUES ('americas_three');
INSERT INTO route (routeID) VALUES ('americas_two');
INSERT INTO route (routeID) VALUES ('big_europe_loop');
INSERT INTO route (routeID) VALUES ('euro_north');
INSERT INTO route (routeID) VALUES ('euro_south');
INSERT INTO route (routeID) VALUES ('germany_local');
INSERT INTO route (routeID) VALUES ('pacific_rim_tour');
INSERT INTO route (routeID) VALUES ('south_euro_loop');
INSERT INTO route (routeID) VALUES ('texas_local');
INSERT INTO route (routeID) VALUES ('korea_direct');

/* Contain Table */
DROP TABLE IF EXISTS contain;
CREATE TABLE contain (
    legID VARCHAR(100) NOT NULL,
    routeID VARCHAR(100) NOT NULL,
    sequence INT NOT NULL, 
    PRIMARY KEY (legID, routeID),
    constraint fk2 foreign key legs(legID) REFERENCES legs(legID),
    constraint fk3 foreign key route(routeID) references route(routeID) 
) ENGINE=InnoDB;

INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_4', 'americas_hub_exchange', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_1', 'americas_one', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_2', 'americas_one', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_31', 'americas_three', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_14', 'americas_three', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_3', 'americas_two', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_22', 'americas_two', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_23', 'big_europe_loop', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_29', 'big_europe_loop', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_16', 'big_europe_loop', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_25', 'big_europe_loop', 4);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_13', 'big_europe_loop', 5);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_24', 'euro_north', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_5', 'euro_north', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_27', 'euro_north', 5);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_8', 'euro_north', 6);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_21', 'euro_south', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_9', 'euro_south', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_28', 'euro_south', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_11', 'euro_south', 4);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_6', 'euro_south', 5);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_26', 'euro_south', 6);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_9', 'germany_local', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_30', 'germany_local', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_17', 'germany_local', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_7', 'pacific_rim_tour', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_10', 'pacific_rim_tour', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_18', 'pacific_rim_tour', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_5', 'south_euro_loop', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_12', 'south_euro_loop', 4);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_15', 'texas_local', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_20', 'texas_local', 2);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_19', 'texas_local', 3);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_32', 'korea_direct', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_16', 'euro_north', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_14', 'euro_north', 4);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_16', 'south_euro_loop', 1);
INSERT INTO contain (legID, routeID, sequence) VALUES ('leg_24', 'south_euro_loop', 2);

/* Flight Table */
DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
    flightID VARCHAR(100) NOT NULL PRIMARY KEY,
    routeID VARCHAR(100) NOT NULL,
    cost decimal(10,2) check (cost >=0),
    constraint fk4 foreign key (routeID) references route(routeID)
) ENGINE=InnoDB;

INSERT INTO flight (flightID, routeID, cost) VALUES ('dl_10', 'americas_one', 200);
INSERT INTO flight (flightID, routeID, cost) VALUES ('un_38', 'americas_three', 200);
INSERT INTO flight (flightID, routeID, cost) VALUES ('ba_61', 'americas_two', 200);
INSERT INTO flight (flightID, routeID, cost) VALUES ('lf_20', 'euro_north', 300);
INSERT INTO flight (flightID, routeID, cost) VALUES ('km_16', 'euro_south', 400);
INSERT INTO flight (flightID, routeID, cost) VALUES ('ba_51', 'big_europe_loop', 100);
INSERT INTO flight (flightID, routeID, cost) VALUES ('ja_35', 'pacific_rim_tour', 300);
INSERT INTO flight (flightID, routeID, cost) VALUES ('ry_34', 'germany_local', 100);
INSERT INTO flight (flightID, routeID, cost) VALUES ('aa_12', 'americas_hub_exchange', 150);
INSERT INTO flight (flightID, routeID, cost) VALUES ('dl_42', 'texas_local', 220);
INSERT INTO flight (flightID, routeID, cost) VALUES ('ke_64', 'korea_direct', 500);
INSERT INTO flight (flightID, routeID, cost) VALUES ('lf_67', 'euro_north', 900);

/* Airline Table */
drop table if exists airline;
create table airline (
	airlineID VARCHAR(100) NOT NULL,
    revenue INT NOT NULL,
    PRIMARY KEY (airlineID)
) ENGINE=InnoDB;

INSERT INTO airline (airlineID, revenue) VALUES ('Delta', 53000);
INSERT INTO airline (airlineID, revenue) VALUES ('United', 48000);
INSERT INTO airline (airlineID, revenue) VALUES ('British Airways', 24000);
INSERT INTO airline (airlineID, revenue) VALUES ('Lufthansa', 35000);
INSERT INTO airline (airlineID, revenue) VALUES ('Air_France', 29000);
INSERT INTO airline (airlineID, revenue) VALUES ('KLM', 29000);
INSERT INTO airline (airlineID, revenue) VALUES ('Ryanair', 10000);
INSERT INTO airline (airlineID, revenue) VALUES ('Japan Airlines', 9000);
INSERT INTO airline (airlineID, revenue) VALUES ('China Southern Airlines', 14000);
INSERT INTO airline (airlineID, revenue) VALUES ('Korean Air Lines', 10000);
INSERT INTO airline (airlineID, revenue) VALUES ('American', 52000);

/* Airplane Table */
CREATE TABLE airplane (
    airlineID VARCHAR(100) NOT NULL,
    tail_num CHAR(100) NOT NULL,
	seat_capacity INT check (seat_capacity >=0),
    speed int check (speed >= 0),
    locationID VARCHAR(100),
    plane_type varchar(100),
	maintenance int,
	model VARCHAR(100),
	neo BOOLEAN, 
    PRIMARY KEY (airlineID, tail_num),
    CONSTRAINT fk5 FOREIGN KEY (airlineID) REFERENCES airline(airlineID)
) ENGINE=InnoDB;

INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Delta', 'n106js', 4, 800, 'plane_1', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Delta', 'n110jn', 5, 800, 'plane_3', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Delta', 'n127js', 4, 600, NULL, 'Airbus', NULL, NULL, 1.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('United', 'n330ss', 4, 800, NULL, 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('United', 'n380sd', 5, 400, 'plane_5', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('British Airways', 'n616lt', 7, 600, 'plane_6', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('British Airways', 'n517ly', 4, 600, 'plane_7', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Lufthansa', 'n620la', 4, 800, 'plane_8', 'Airbus', NULL, NULL, 1.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Lufthansa', 'n401fj', 4, 300, NULL, NULL, NULL, NULL, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Lufthansa', 'n653fk', 6, 600, 'plane_10', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Air_France', 'n118fm', 4, 400, NULL, 'Boeing', 0.0, 777.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Air_France', 'n815pw', 3, 400, NULL, 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('KLM', 'n161fk', 4, 600, 'plane_13', 'Airbus', NULL, NULL, 1.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('KLM', 'n337as', 5, 400, NULL, 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('KLM', 'n256ap', 4, 300, NULL, 'Boeing', 0.0, 737.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Ryanair', 'n156sq', 8, 600, NULL, 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Ryanair', 'n451fi', 5, 600, NULL, 'Airbus', NULL, NULL, 1.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Ryanair', 'n341eb', 4, 400, 'plane_18', 'Boeing', 1.0, 737.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Ryanair', 'n353kz', 4, 400, NULL, 'Boeing', 1.0, 737.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Japan Airlines', 'n305fv', 6, 400, 'plane_20', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Japan Airlines', 'n443wu', 4, 800, NULL, 'Airbus', NULL, NULL, 1.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('China Southern Airlines', 'n454gq', 3, 400, NULL, NULL, NULL, NULL, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('China Southern Airlines', 'n249yk', 4, 400, NULL, 'Boeing', 0.0, 787.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('Korean Air Lines', 'n180co', 5, 600, 'plane_4', 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('American', 'n448cs', 4, 400, NULL, 'Boeing', 1.0, 787.0, NULL);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('American', 'n225sb', 8, 800, NULL, 'Airbus', NULL, NULL, 0.0);
INSERT INTO airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, maintenance, model, neo) VALUES ('American', 'n553qn', 5, 800, 'plane_2', 'Airbus', NULL, NULL, 0.0);

/* Supports Table */
CREATE TABLE supports (
    progress int,
    airplane_status CHAR(100),
    next_time TIME,
    flightID VARCHAR(100) NOT NULL,
    airlineID VARCHAR(100) NOT NULL,
    tail_num CHAR(100) NOT NULL,
    PRIMARY KEY (airlineID, tail_num, flightID),
    CONSTRAINT fk6 FOREIGN KEY airplane(airlineID, tail_num) REFERENCES airplane(airlineID, tail_num),
	CONSTRAINT fk7 FOREIGN key (flightID) references flight(flightID)
) ENGINE=InnoDB;

INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (1, 'in_flight', '08:00:00', 'dl_10', 'Delta', 'n106js');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (2, 'in_flight', '14:30:00', 'un_38', 'United', 'n380sd');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (0, 'on_ground', '09:30:00', 'ba_61', 'British Airways', 'n616lt');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (3, 'in_flight', '11:00:00', 'lf_20', 'Lufthansa', 'n620la');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (6, 'in_flight', '14:00:00', 'km_16', 'KLM', 'n161fk');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (0, 'on_ground', '11:30:00', 'ba_51', 'British Airways', 'n517ly');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (1, 'in_flight', '09:30:00', 'ja_35', 'Japan Airlines', 'n305fv');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (0, 'on_ground', '15:00:00', 'ry_34', 'Ryanair', 'n341eb');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (1, 'on_ground', '12:15:00', 'aa_12', 'American', 'n553qn');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (0, 'on_ground', '13:45:00', 'dl_42', 'Delta', 'n110jn');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (0, 'on_ground', '16:00:00', 'ke_64', 'Korean Air Lines', 'n180co');
INSERT INTO supports (progress, airplane_status, next_time, flightID, airlineID, tail_num) VALUES (6, 'on_ground', '21:23:00', 'lf_67', 'Lufthansa', 'n653fk');

/* Pilot Table */

CREATE TABLE pilot (
	personID VARCHAR(100) NOT NULL,
    first_name varchar(100),
    last_name varchar(100),
    locationID varchar(100) not null,
	taxID CHAR(11),
    experience INT,
    associated_flight char(100), 
    PRIMARY KEY (personID),
    CONSTRAINT fk8 FOREIGN key (locationID) references location(locationID)
) Engine=InnoDB;

INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p1', 'Jeanne', 'Nelson', 'port_1', '330-12-6907', 31, 'dl_10');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p2', 'Roxanne', 'Byrd', 'port_1', '842-88-1257', 9, 'dl_10');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p11', 'Sandra', 'Cruz', 'port_3', '369-22-9505', 22, 'km_16');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p13', 'Bryant', 'Figueroa', 'port_3', '513-40-4168', 24, 'km_16');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p14', 'Dana', 'Perry', 'port_3', '454-71-7847', 13, 'km_16');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p15', 'Matt', 'Hunt', 'port_10', '153-47-8101', 30, 'ja_35');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p16', 'Edna', 'Brown', 'port_10', '598-47-5172', 28, 'ja_35');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p12', 'Dan', 'Ball', 'port_3', '680-92-5329', 24, 'ry_34');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p17', 'Ruby', 'Burgess', 'plane_3', '865-71-6800', 36, 'dl_42');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p18', 'Esther', 'Pittman', 'plane_10', '250-86-2784', 23, 'lf_67');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p19', 'Doug', 'Fowler', 'port_17', '386-39-7881', 2, NULL);
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p8', 'Bennie', 'Palmer', 'port_2', '701-38-2179', 12, 'ry_34');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p20', 'Thomas', 'Olson', 'port_17', '522-44-3098', 28, NULL);
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p3', 'Tanya', 'Nguyen', 'port_1', '750-24-7616', 11, 'un_38');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p4', 'Kendra', 'Jacobs', 'port_1', '776-21-8098', 24, 'un_38');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p5', 'Jeff', 'Burton', 'port_1', '933-93-2165', 27, 'ba_61');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p6', 'Randal', 'Parks', 'port_1', '707-84-4555', 38, 'ba_61');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p10', 'Lawrence', 'Morgan', 'port_3', '769-60-1266', 15, 'lf_20');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p7', 'Sonya', 'Owens', 'port_2', '450-25-5617', 13, 'lf_20');
INSERT INTO pilot (personID, first_name, last_name, locationID, taxID, experience, associated_flight) VALUES ('p9', 'Marlene', 'Warner', 'port_3', '936-44-6941', 13, 'lf_20');

/* Licenses Table */
create table licenses (
    personID varchar(100) not null,
    license_types varchar(100),
    primary key (personID)
) engine = innodb;

INSERT INTO licenses (personID, license_types) VALUES ('p1', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p2', 'airbus, boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p11', 'airbus, boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p13', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p14', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p15', 'airbus, boeing, general');
INSERT INTO licenses (personID, license_types) VALUES ('p16', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p12', 'boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p17', 'airbus, boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p18', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p19', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p8', 'boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p20', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p3', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p4', 'airbus, boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p5', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p6', 'airbus, boeing');
INSERT INTO licenses (personID, license_types) VALUES ('p10', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p7', 'airbus');
INSERT INTO licenses (personID, license_types) VALUES ('p9', 'airbus, boeing, general');

/* Passenger Table */
create table passenger (
    personID varchar(100) not null,
    first_name varchar(100),
    last_name varchar(100),
    locationID varchar(100),
    miles int check (miles >= 0),
    funds int,
    vacations varchar(100),
    primary key (personID),
    CONSTRAINT fk9 FOREIGN key (locationID) references location(locationID)
) engine = innodb;

INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p21', 'Mona', 'Harrison', 'plane_1', 771, 700, 'AMS');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p22', 'Arlene', 'Massey', 'plane_1', 374, 200, 'AMS');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p23', 'Judith', 'Patrick', 'plane_1', 414, 400, 'BER');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p24', 'Reginald', 'Rhodes', 'plane_5', 292, 500, 'MUC, CDG');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p25', 'Vincent', 'Garcia', 'plane_5', 390, 300, 'MUC');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p26', 'Cheryl', 'Moore', 'plane_5', 302, 600, 'MUC');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p27', 'Michael', 'Rivera', 'plane_8', 470, 400, 'BER');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p28', 'Luther', 'Matthews', 'plane_8', 208, 400, 'LGW');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p29', 'Moses', 'Parks', 'plane_13', 292, 700, 'FCO, LHR');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p30', 'Ora', 'Steele', 'plane_13', 686, 500, 'FCO, MAD');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p31', 'Antonio', 'Flores', 'plane_13', 547, 400, 'FCO');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p32', 'Glenn', 'Ross', 'plane_13', 257, 500, 'FCO');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p33', 'Irma', 'Thomas', 'plane_20', 564, 600, 'CAN');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p34', 'Ann', 'Maldonado', 'plane_20', 211, 200, 'HND');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p35', 'Jeffrey', 'Cruz', 'port_12', 233, 500, 'LGW');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p36', 'Sonya', 'Price', 'port_12', 293, 400, 'FCO');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p37', 'Tracy', 'Hale', 'port_12', 552, 700, 'FCO, LGW, CDG');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p38', 'Albert', 'Simmons', 'port_14', 812, 700, 'MUC');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p39', 'Karen', 'Terry', 'port_15', 541, 400, 'MUC');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p40', 'Glen', 'Kelley', 'port_20', 441, 700, 'HND');
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p41', 'Brooke', 'Little', 'port_3', 875, 300, NULL);
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p42', 'Daryl', 'Nguyen', 'port_4', 691, 500, NULL);
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p43', 'Judy', 'Willis', 'port_14', 572, 300, NULL);
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p44', 'Marco', 'Klein', 'port_15', 572, 500, NULL);
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p45', 'Angelica', 'Hampton', 'port_16', 663, 500, NULL);
INSERT INTO passenger (personID, first_name, last_name, locationID, miles, funds, vacations) VALUES ('p46', 'Janice', 'White', 'plane_10', 690, 5000, 'LGW');

/* Vacation Table */
CREATE TABLE vacation (
    personID varchar(100),
    destination VARCHAR(100),
    sequence INT,
    PRIMARY KEY (personID, sequence)
);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p21', 'AMS', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p22', 'AMS', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p23', 'BER', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p24', 'MUC', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p24', 'CDG', 2);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p25', 'MUC', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p26', 'MUC', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p27', 'BER', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p28', 'LGW', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p29', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p29', 'LHR', 2);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p30', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p30', 'MAD', 2);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p31', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p32', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p33', 'CAN', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p34', 'HND', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p35', 'LGW', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p36', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p37', 'FCO', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p37', 'LGW', 2);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p37', 'CDG', 3);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p38', 'MUC', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p39', 'MUC', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p40', 'HND', 1);
INSERT INTO vacation (personID, destination, sequence) VALUES ('p46', 'LGW', 1);
