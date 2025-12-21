-- CS4400: Introduction to Database Systems: Monday, March 3, 2025
-- Simple Airline Management System Course Project Mechanics [TEMPLATE] (v0)
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
	returns time reads sql data
begin
	declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);
end //
delimiter ;

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like the model and the engine.  
Finally, an airplane must have a new and database-wide unique location
since it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_maintenanced boolean, in ip_model varchar(50),
    in ip_neo boolean)
sp_main: begin
 -- Must be sponsored by an existing airline
    if (select count(*) from airline where airlineID = ip_airlineID) < 1 then 
        leave sp_main;
    end if;

    -- Tail number must be unique per airline
    if (select count(*) from airplane where airlineID = ip_airlineID and tail_num = ip_tail_num) > 0 then 
        leave sp_main;
    end if;

    -- Seat capacity and speed must be positive
    if ip_seat_capacity <= 0 or ip_speed <= 0 then 
        leave sp_main;
    end if;

    -- Conditional checks based on airplane type
    if ip_plane_type = 'Airbus' then 
        if ip_neo is null then
            leave sp_main;
        end if;
    elseif ip_plane_type = 'Boeing' then 
        if (ip_maintenanced is null or ip_maintenanced = 0) or ip_model is null then 
            leave sp_main;
        end if; 
    end if;
    
    -- if not boeing or airbus, data null but need speed and seat cap
    if ip_plane_type != 'Airbus' and ip_plane_type != 'Boeing' then
		if ip_speed is null or ip_seat_capacity is null then
			leave sp_main;
		end if;
	end if;

    -- Location must be new and unique
    if (select count(*) from location where locationID = ip_locationID) > 0 then 
        leave sp_main;
    end if;

    -- Insert into location
    insert into location (locationID) values (ip_locationID);

    -- Insert into airplane
    insert into airplane (
        airlineID, tail_num, seat_capacity, speed, locationID,
        plane_type, maintenanced, model, neo
    ) values (
        ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID,
        ip_plane_type, ip_maintenanced, ip_model, ip_neo
    );

end // 
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a new and database-wide unique location if it will be used
to support airplane takeoffs and landings.  An airport may have a longer, more
descriptive name.  An airport must also have a city, state, and country designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state varchar(100), in ip_country char(3), in ip_locationID varchar(50))
sp_main: begin
	-- unique airportID 
    if (select count(*) from airport where airportID = ip_airportID) > 0 then 
		leave sp_main; 
	end if; 
    
    -- unique locationID
    if (select count(*) from location where locationID = ip_locationID) > 0 then
		leave sp_main;
	end if;

    -- must have a city, state, country 
    if ip_city is null or ip_state is null or ip_country is null then
		leave sp_main;
	end if;
    
	insert into location values (ip_locationID);
	insert into airport values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_country, ip_locationID);

end //
delimiter ;

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person must have a first name, and might also have a last name.

A person can hold a pilot role or a passenger role (exclusively).  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  As a
passenger, a person will have some amount of frequent flyer miles, along with a
certain amount of funds needed to purchase tickets for flights. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_miles integer, in ip_funds integer)
sp_main: begin
	-- Ensure that the location is valid
    if not exists (select * from location where locationID=ip_locationID) then
		leave sp_main;
	end if;
        
    -- Ensure that the personID is unique
    if exists (select * from person where personID=ip_personID) then
		leave sp_main;
	end if;
        
	-- first name required but last name not
    if ip_first_name is null then
		leave sp_main;
	end if;
    
    -- Ensure that the person is a pilot or passenger
    if (ip_taxID is not null and ip_experience is not null and ip_miles is null and ip_funds is null) then
        -- person table
        insert into person (personID, first_name, last_name, locationID)
        values (ip_personID, ip_first_name, ip_last_name, ip_locationID);
      
      -- pilot table
        insert into pilot (personID, taxID, experience)
        values (ip_personID, ip_taxID, ip_experience);
    elseif (ip_miles IS NOT NULL AND ip_funds IS NOT NULL AND ip_taxID IS NULL AND ip_experience IS NULL) THEN
      
      -- person table
        insert into person (personID, first_name, last_name, locationID)
        values (ip_personID, ip_first_name, ip_last_name, ip_locationID);
      
      -- passenger table
        insert into passenger (personID, miles, funds)
        values (ip_personID, ip_miles, ip_funds);
    else
        leave sp_main;
    end if;

end //
delimiter ;

-- [4] grant_or_revoke_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure inverts the status of a pilot license.  If the license
doesn't exist, it must be created; and, if it aready exists, then it must be removed. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS grant_or_revoke_pilot_license;
DELIMITER //
CREATE PROCEDURE grant_or_revoke_pilot_license (
    IN ip_personID VARCHAR(50),
    IN ip_license VARCHAR(100)
)
sp_main: BEGIN
    DECLARE pilot_count INT DEFAULT 0;
    DECLARE license_count INT DEFAULT 0;
    DECLARE cleaner_license VARCHAR(100);

    IF ip_personID IS NULL OR ip_license IS NULL THEN
        LEAVE sp_main;
    END IF;

    SET cleaner_license = UPPER(TRIM(ip_license));
    IF cleaner_license = '' THEN
        LEAVE sp_main;
    END IF;

    -- Ensure person is a valid pilot
    SELECT COUNT(*) INTO pilot_count
    FROM pilot
    WHERE personID = ip_personID;

    IF pilot_count = 0 THEN
        LEAVE sp_main;
    END IF;

    -- Check if license already exists
    SELECT COUNT(*) INTO license_count
    FROM pilot_licenses
    WHERE personID = ip_personID AND license = cleaner_license;

    IF license_count > 0 THEN
        DELETE FROM pilot_licenses
        WHERE personID = ip_personID AND license = cleaner_license;
    ELSE
        INSERT INTO pilot_licenses (personID, license)
        VALUES (ip_personID, cleaner_license);
    END IF;

END //
DELIMITER ;
-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  And
the airplane, if designated, must not be in use by another flight.  The flight
can be started at any valid location along the route except for the final stop,
and it will begin on the ground.  You must also include when the flight will
takeoff along with its cost. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_next_time time, in ip_cost integer)
sp_main: begin
    declare progress_int int;
    declare airplane_status_val varchar(20); 
    -- Route must exist and determine number of stops
    select count(*) into progress_int from route_path where routeID = ip_routeID;
    
    -- Progress must be less than number of stops
    if ip_progress >= progress_int then
        leave sp_main;
    end if;

    -- FlightID must be unique
    if (select count(*) from flight where flightID = ip_flightID) > 0 then
        leave sp_main;
    end if;

    -- Time and cost must not be null
    if ip_next_time is null or ip_cost is null then
        leave sp_main;
    end if;

    -- Airplane checks (if provided)
    if ip_support_airline is not null or ip_support_tail is not null then
			if ip_progress is null or ip_next_time is null then 
            leave sp_main;
        end if;

        -- Ensure airplane is not already used
        if (select count(*) from flight where support_airline = ip_support_airline and support_tail = ip_support_tail) > 0 then
            leave sp_main;
        end if;
    end if;

    -- Insert the flight
    insert into flight values (
        ip_flightID, ip_routeID, ip_support_airline, ip_support_tail,
        ip_progress, 'on_ground', ip_next_time, ip_cost
    );

end //
delimiter ;

-- [6] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	declare v_current_leg integer default 0;
    declare v_current_status varchar(100) default null;
    declare v_curr_next_time time default null;
    declare v_new_airplane_status varchar(100) default null;
    declare v_new_next_time time default null;
    declare v_supp_airline varchar(50) default null;
    declare v_supp_tail varchar(50) default null;
    declare v_num_miles integer default 0;
    declare v_plane_num varchar(50) default null;
                
	-- Ensure that the flight exists
	if (select count(*) from flight f where f.flightID = ip_flightID) < 1 then leave sp_main; end if;
    
    set v_current_leg = (select progress from flight f where f.flightID = ip_flightID);
	set v_curr_next_time = (select next_time from flight f where f.flightID = ip_flightID);
    set v_current_status = (select airplane_status from flight f where f.flightID = ip_flightID);

	-- Make sure that the flight has made any amount of progress
    if (v_current_leg is null or v_current_leg < 1) then 
		leave sp_main; 
	end if;
    
     -- Ensure that the flight is in the air
    if (v_current_status is null or v_current_status = 'on_ground') then 
		leave sp_main; 
	end if;
    
    -- Update the status of the flight and increment the next time to 1 hour later
	-- Hint: use addtime()
    set v_new_airplane_status = 'on_ground';
    set v_new_next_time = ADDTIME(v_curr_next_time, MAKETIME(1, 0, 0));
    
    update flight f set f.airplane_status = v_new_airplane_status, f.next_time = v_new_next_time
	where f.flightID = ip_flightID;
            
	set v_supp_airline = (select support_airline from flight f where f.flightID = ip_flightID);
    set v_supp_tail = (select support_tail from flight f where f.flightID = ip_flightID);
    -- set supp_flight = (select personID from pilot p where p.commanding_flight = ip_flightID);
	
      -- Increment the pilot's experience by 1
    update pilot p set p.experience = p.experience + 1
    where p.commanding_flight = ip_flightID;
          
	-- add miles to passenger, update plane location 
	set v_num_miles = (select l.distance from (leg l join route_path rp on l.legID = rp.legID) 
	join flight f on rp.routeID = f.routeID and rp.sequence = f.progress where f.flightID = ip_flightID);
	set v_plane_num = (select locationID from airplane a where a.airlineID = v_supp_airline and a.tail_num = v_supp_tail);
    
    -- Increment the frequent flyer miles of all passengers on the plane
	update passenger p set p.miles = p.miles + v_num_miles where p.personID in 
	(select pr.personID from person pr where pr.locationID = v_plane_num);

end //
delimiter ;

-- [7] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that Airbus and general planes have at least one pilot
assigned, while Boeing must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
    declare v_current_status varchar(20);
    declare v_progress int;
    declare v_routeID varchar(50);
    declare v_support_airline varchar(50);
    declare v_support_tail varchar(50);
    declare v_leg_count int;
    declare v_plane_type varchar(100);
    declare v_speed int;
    declare v_pilot_count int;
    declare v_next_legID varchar(50);
    declare v_next_leg_distance int;
    declare v_flight_time int;

    -- Get flight details
    select airplane_status, progress, routeID, support_airline, support_tail 
    into v_current_status, v_progress, v_routeID, v_support_airline, v_support_tail
    from flight 
    where flightID = ip_flightID;
    
    -- If flight does not exist or not on ground, exit
    IF v_current_status IS NULL OR v_current_status != 'on_ground' THEN
        LEAVE sp_main;
    END IF;

    -- Get total number of legs in the route
    select MAX(sequence) into v_leg_count 
    from route_path 
    WHERE routeID = v_routeID;

    -- Check if there is another leg to fly
    IF v_progress >= v_leg_count THEN
        LEAVE sp_main;
    END IF;

    -- Get airplane type and speed
    select plane_type, speed into v_plane_type, v_speed
    from airplane 
    where airlineID = v_support_airline AND tail_num = v_support_tail;

    -- Count assigned pilots
    select COUNT(*) INTO v_pilot_count 
    from pilot 
    where commanding_flight = ip_flightID;

    -- Check pilot requirements
    IF (v_plane_type = 'Boeing' AND v_pilot_count < 2) OR 
       ((v_plane_type != 'Boeing' OR v_plane_type IS NULL) AND v_pilot_count < 1) THEN
        UPDATE flight 
        SET next_time = ADDTIME(next_time, '00:30:00')
        where flightID = ip_flightID;
        LEAVE sp_main;
    END IF;

    -- Get next leg ID
    select legID into v_next_legID 
    from route_path 
    where routeID = v_routeID AND sequence = v_progress + 1;

	-- make sure leg is not null 
    if v_next_legID is null then 
		leave sp_main;
	end if; 
    
    -- Get next leg distance
    select distance into v_next_leg_distance 
    from leg 
    where legID = v_next_legID;

    -- Calculate flight time in seconds
    set v_flight_time = (v_next_leg_distance / v_speed) * 3600;
    
    -- Update flight status, progress, and next_time
    update flight 
    set 
        airplane_status = 'in_flight',
        progress = progress + 1,
        next_time = ADDTIME(next_time, SEC_TO_TIME(v_flight_time))
    where flightID = ip_flightID;

end //
delimiter ;

-- [8] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the same airport as the flight,
and the flight must be heading towards that passenger's desired destination.
Also, each passenger must have enough funds to cover the flight.  Finally, there
must be enough seats to accommodate all boarding passengers. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS passengers_board;
DELIMITER //

CREATE PROCEDURE passengers_board (IN ip_flightID VARCHAR(50))
sp_main: BEGIN

    DECLARE v_current_leg INT DEFAULT 0;
    DECLARE v_total_legs INT DEFAULT 0;
    DECLARE v_airplane_status VARCHAR(100);
    DECLARE v_route_id VARCHAR(50);
    DECLARE v_support_airline VARCHAR(50);
    DECLARE v_support_tail VARCHAR(50);
    DECLARE v_departing_airport CHAR(3);
    DECLARE v_arriving_airport CHAR(3);
    DECLARE v_departure_location_id VARCHAR(50);
    DECLARE v_airplane_location_id VARCHAR(50);
    DECLARE v_seat_capacity INT;
    DECLARE v_flight_cost FLOAT;
    DECLARE v_eligible_passenger_count INT;
    DECLARE v_leg_id VARCHAR(50);
    DECLARE v_distance INT;

    -- Check if flight exists
    IF NOT EXISTS (SELECT 1 FROM flight WHERE flightID = ip_flightID) THEN
        LEAVE sp_main;
    END IF;

    -- Get flight info
    SELECT progress, routeID, airplane_status, support_airline, support_tail, cost
    INTO v_current_leg, v_route_id, v_airplane_status, v_support_airline, v_support_tail, v_flight_cost
    FROM flight
    WHERE flightID = ip_flightID;

    -- Ensure the flight is on the ground
    IF v_airplane_status = 'in_flight' THEN
        LEAVE sp_main;
    END IF;

    -- Get total legs
    SELECT COUNT(*) INTO v_total_legs
    FROM route_path
    WHERE routeID = v_route_id;

    -- Ensure flight has more legs to fly
    IF v_current_leg >= v_total_legs THEN
        LEAVE sp_main;
    END IF;

    -- Get departure and arrival airport for the next leg
    SELECT l.legID, l.departure, l.arrival
    INTO v_leg_id, v_departing_airport, v_arriving_airport
    FROM route_path rp
    JOIN leg l ON rp.legID = l.legID
    WHERE rp.routeID = v_route_id AND rp.sequence = v_current_leg + 1;

    -- Get location ID for departing airport
    SELECT locationID INTO v_departure_location_id
    FROM airport
    WHERE airportID = v_departing_airport;

    -- Get airplane's location and seat capacity
    SELECT locationID, seat_capacity
    INTO v_airplane_location_id, v_seat_capacity
    FROM airplane
    WHERE airlineID = v_support_airline AND tail_num = v_support_tail;

    -- Count eligible passengers
    SELECT COUNT(*)
    INTO v_eligible_passenger_count
    FROM person
    JOIN passenger ON person.personID = passenger.personID
    JOIN passenger_vacations pv ON person.personID = pv.personID
    WHERE person.locationID = v_departure_location_id
      AND pv.sequence = 1
      AND pv.airportID = v_arriving_airport
      AND passenger.funds >= v_flight_cost;

    -- Not enough seats
    IF v_eligible_passenger_count > v_seat_capacity THEN
        LEAVE sp_main;
    END IF;

    -- Get distance for leg
    SELECT distance INTO v_distance
    FROM leg
    WHERE legID = v_leg_id;

    -- Update airline revenue
    UPDATE airline
    SET revenue = revenue + (v_flight_cost * v_eligible_passenger_count)
    WHERE airlineID = v_support_airline;

    -- Update passengers: deduct funds, move location, add miles
    UPDATE passenger
    JOIN person ON passenger.personID = person.personID
    JOIN passenger_vacations pv ON passenger.personID = pv.personID
    SET passenger.funds = passenger.funds - v_flight_cost,
        person.locationID = v_airplane_location_id
    WHERE person.locationID = v_departure_location_id
      AND pv.sequence = 1
      AND pv.airportID = v_arriving_airport
      AND passenger.funds >= v_flight_cost;

END //
DELIMITER ;

-- [9] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS passengers_disembark;
DELIMITER //

CREATE PROCEDURE passengers_disembark (IN ip_flightID VARCHAR(50))
sp_main: BEGIN
    DECLARE v_route_id VARCHAR(50);
    DECLARE v_current_leg_id VARCHAR(50);
    DECLARE v_flight_progress INT;
    DECLARE v_arrival_airport_code CHAR(3);
    DECLARE v_arrival_location_id VARCHAR(50);
    DECLARE v_support_airline_id VARCHAR(50);
    DECLARE v_support_tail_number VARCHAR(50);
    DECLARE v_plane_location_id VARCHAR(50);

    -- Ensure the flight exists and is on the ground
    IF NOT EXISTS (SELECT 1 FROM flight WHERE flightID = ip_flightID) THEN
        LEAVE sp_main;
    END IF;

    IF (SELECT airplane_status FROM flight WHERE flightID = ip_flightID) = 'in_flight' THEN
        LEAVE sp_main;
    END IF;

    -- Retrieve flight information
    SELECT routeID, progress, support_airline, support_tail
    INTO v_route_id, v_flight_progress, v_support_airline_id, v_support_tail_number
    FROM flight
    WHERE flightID = ip_flightID;

    -- Get the current leg and arrival airport information
    SELECT leg.legID, leg.arrival
    INTO v_current_leg_id, v_arrival_airport_code
    FROM route_path
    JOIN leg ON route_path.legID = leg.legID
    WHERE routeID = v_route_id AND sequence = v_flight_progress;

    -- Fetch the arrival location corresponding to the arrival airport
    SELECT locationID
    INTO v_arrival_location_id
    FROM airport
    WHERE airportID = v_arrival_airport_code;

    -- Determine the airplane's current location
    SELECT locationID
    INTO v_plane_location_id
    FROM airplane
    WHERE airlineID = v_support_airline_id AND tail_num = v_support_tail_number;

    -- Update the location of each person who is on the plane and whose next vacation stop is this airport
    UPDATE person
    JOIN passenger_vacations pv ON person.personID = pv.personID
    SET person.locationID = v_arrival_location_id
    WHERE person.locationID = v_plane_location_id
      AND pv.sequence = 1
      AND pv.airportID = v_arrival_airport_code;

    -- Remove completed vacation steps for passengers who have disembarked
    DELETE FROM passenger_vacations
    WHERE sequence = 1
      AND airportID = v_arrival_airport_code
      AND personID IN (
          SELECT personID
          FROM person
          WHERE locationID = v_arrival_location_id
      );

END //
DELIMITER ;


-- [10] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
flight.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS assign_pilot;
DELIMITER //

CREATE PROCEDURE assign_pilot (
    IN in_flight_id VARCHAR(50),
    IN in_person_id VARCHAR(50)
)
main_block: BEGIN

    DECLARE v_plane_loc VARCHAR(50);
    DECLARE v_pilot_loc VARCHAR(50);
    DECLARE v_plane_type VARCHAR(100);
    DECLARE v_airline_id VARCHAR(50);
    DECLARE v_tail_num VARCHAR(50);
    DECLARE v_route_id VARCHAR(50);
    DECLARE v_progress INT DEFAULT 0;
    DECLARE v_leg_id VARCHAR(50);
    DECLARE v_total_legs INT;
    DECLARE v_airport_id CHAR(3);
    DECLARE v_flight_status VARCHAR(100);
    DECLARE v_plane_id VARCHAR(50);

    -- Check flight exists
    IF (SELECT COUNT(*) FROM flight WHERE flightID = in_flight_id) = 0 THEN 
        LEAVE main_block;
    END IF;

    -- Check pilot exists
    IF (SELECT COUNT(*) FROM person WHERE personID = in_person_id) = 0 THEN 
        LEAVE main_block;
    END IF;

    -- Retrieve flight and airplane info
    SELECT 
        f.support_airline, f.support_tail, f.routeID, f.progress, f.airplane_status
    INTO 
        v_airline_id, v_tail_num, v_route_id, v_progress, v_flight_status
    FROM flight f
    WHERE f.flightID = in_flight_id;

    -- Ensure flight is on the ground
    IF v_flight_status = 'in_flight' THEN 
        LEAVE main_block;
    END IF;

    -- Get airplane type and location
    SELECT a.plane_type, a.locationID
    INTO v_plane_type, v_plane_id
    FROM airplane a
    WHERE a.airlineID = v_airline_id AND a.tail_num = v_tail_num;

    -- Check pilot has the license
    IF (SELECT COUNT(*) FROM pilot_licenses WHERE personID = in_person_id AND license = v_plane_type) = 0 THEN 
        LEAVE main_block;
    END IF;

    -- Get total legs in route
    SELECT COUNT(*) INTO v_total_legs
    FROM route_path
    WHERE routeID = v_route_id;

    -- Ensure flight has legs left
    IF v_progress = v_total_legs THEN 
        LEAVE main_block;
    END IF;

    -- Determine current leg and airport
    IF v_progress = 0 THEN
        SELECT rp.legID INTO v_leg_id
        FROM route_path rp
        WHERE rp.routeID = v_route_id AND rp.sequence = 1;
        
        SELECT l.departure INTO v_airport_id
        FROM leg l
        WHERE l.legID = v_leg_id;
    ELSE
        SELECT rp.legID INTO v_leg_id
        FROM route_path rp
        WHERE rp.routeID = v_route_id AND rp.sequence = v_progress;

        SELECT l.arrival INTO v_airport_id
        FROM leg l
        WHERE l.legID = v_leg_id;
    END IF;

    -- Get airport location and pilot location
    SELECT a.locationID INTO v_plane_loc
    FROM airport a
    WHERE a.airportID = v_airport_id;

    SELECT p.locationID INTO v_pilot_loc
    FROM person p
    WHERE p.personID = in_person_id;

    -- Ensure pilot is at plane's location
    IF v_plane_loc != v_pilot_loc THEN 
        LEAVE main_block;
    END IF;

    -- Ensure pilot is available
    IF (SELECT COUNT(*) FROM pilot p WHERE p.personID = in_person_id AND p.commanding_flight IS NULL) = 0 THEN 
        LEAVE main_block;
    END IF;

    -- Assign pilot and update location
    UPDATE pilot 
    SET commanding_flight = in_flight_id 
    WHERE personID = in_person_id;

    UPDATE person 
    SET locationID = v_plane_id 
    WHERE personID = in_person_id;

END //
DELIMITER ;


-- [11] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS recycle_crew;
DELIMITER //
CREATE PROCEDURE recycle_crew (IN ip_flightID VARCHAR(50))
sp_main: BEGIN
	DECLARE v_current_leg_num INTEGER DEFAULT 0;
    DECLARE v_total_legs INTEGER DEFAULT 0;
    DECLARE v_current_status VARCHAR(100) DEFAULT NULL;
    DECLARE v_support_airline VARCHAR(50) DEFAULT NULL;
    DECLARE v_support_tail VARCHAR(50) DEFAULT NULL;
    DECLARE v_plane_location VARCHAR(50) DEFAULT NULL;
    DECLARE v_num_passengers INTEGER DEFAULT 0;
    DECLARE v_route_id VARCHAR(50) DEFAULT NULL;
    DECLARE v_current_leg_id VARCHAR(50) DEFAULT NULL;
    DECLARE v_arrival_airport_id CHAR(3) DEFAULT NULL;
    DECLARE v_port_location_id VARCHAR(50) DEFAULT NULL;
    
    -- Check if the flight ID exists
	IF (SELECT COUNT(*) FROM flight WHERE flightID = ip_flightID) < 1 THEN 
        LEAVE sp_main; 
    END IF;
    
    -- Fetch flight details
    SELECT 
        progress, airplane_status, support_airline, support_tail,
        (SELECT count(*) FROM route_path WHERE routeID = f.routeID) AS total_legs
    INTO 
        v_current_leg_num, v_current_status, v_support_airline, v_support_tail, v_total_legs
    FROM 
        flight f
    WHERE 
        f.flightID = ip_flightID;
	-- Ensure that the flight is on the ground
    IF v_current_status = 'in_flight' THEN 
        LEAVE sp_main; 
    END IF;
    
    -- Ensure that the flight has completed all legs
    IF v_current_leg_num != v_total_legs THEN 
        LEAVE sp_main; 
    END IF;
    
    -- Get airplane's current location and count passengers
    SET v_plane_location = (SELECT locationID FROM airplane WHERE airlineID = v_support_airline AND tail_num = v_support_tail);
    SET v_num_passengers = (SELECT COUNT(*) FROM person WHERE locationID = v_plane_location AND personID IN (SELECT personID FROM passenger));
    
	-- Ensure that no passengers are on the flight
    IF v_num_passengers > 0 THEN 
        LEAVE sp_main; 
    END IF;
            
	SET v_route_id = (SELECT routeID FROM flight WHERE flightID = ip_flightID);
	SET v_current_leg_id = (SELECT legID FROM route_path WHERE routeID = v_route_id AND sequence = v_current_leg_num);
	SET v_arrival_airport_id = (SELECT arrival FROM leg WHERE legID = v_current_leg_id);
    SET v_port_location_id = (SELECT locationID FROM airport WHERE airportID = v_arrival_airport_id);
	
    -- Update locations and clear flight commands for pilots
    UPDATE person SET locationID = v_port_location_id WHERE personID IN (SELECT personID FROM pilot WHERE commanding_flight = ip_flightID);          
    UPDATE pilot SET commanding_flight = NULL WHERE commanding_flight = ip_flightID;  

END //
DELIMITER ;

-- [12] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  And the flight must be empty - no pilots or passengers. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS retire_flight;
DELIMITER //

CREATE PROCEDURE retire_flight(IN ip_flightID VARCHAR(50))
sp_main: BEGIN

    DECLARE v_flight_exists BOOL DEFAULT FALSE;
    DECLARE v_current_status VARCHAR(100);
    DECLARE v_current_progress INT DEFAULT 0;
    DECLARE v_total_legs INT DEFAULT 0;
    DECLARE v_airplane_location VARCHAR(50);
    DECLARE v_people_on_board INT DEFAULT 0;
    DECLARE v_route_id VARCHAR(50);
    DECLARE v_support_airline VARCHAR(50);
    DECLARE v_support_tail VARCHAR(50);

    SELECT EXISTS(
        SELECT 1 FROM flight WHERE flightID = ip_flightID
    ) INTO v_flight_exists;

    IF v_flight_exists = FALSE THEN
        LEAVE sp_main;
    END IF;

    SELECT airplane_status, progress, routeID, support_airline, support_tail
    INTO v_current_status, v_current_progress, v_route_id, v_support_airline, v_support_tail
    FROM flight
    WHERE flightID = ip_flightID;

    IF v_current_status = 'in_flight' THEN
        LEAVE sp_main;
    END IF;

    SELECT COUNT(*) INTO v_total_legs
    FROM route_path
    WHERE routeID = v_route_id;

    IF v_current_progress < v_total_legs THEN
        LEAVE sp_main;
    END IF;

    SELECT locationID INTO v_airplane_location
    FROM airplane
    WHERE airlineID = v_support_airline AND tail_num = v_support_tail;

    SELECT COUNT(*) INTO v_people_on_board
    FROM person
    WHERE locationID = v_airplane_location;

    IF v_people_on_board > 0 THEN
        LEAVE sp_main;
    END IF;

    DELETE FROM flight WHERE flightID = ip_flightID;

END //
DELIMITER ;

-- [13] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS simulation_cycle;
DELIMITER //

CREATE PROCEDURE simulation_cycle()
sp_main: BEGIN

    DECLARE v_flightID VARCHAR(50);
    DECLARE v_airplane_status VARCHAR(100);
    DECLARE v_routeID VARCHAR(50);
    DECLARE v_progress INT;
    DECLARE v_max_leg_seq INT;

    SELECT flightID
    INTO v_flightID
    FROM flight
    ORDER BY
        next_time ASC,
        CASE airplane_status
            WHEN 'in_flight' THEN 0
            WHEN 'on_ground' THEN 1
            ELSE 2
        END,
        flightID ASC
    LIMIT 1;

    -- Load flight details
    SELECT airplane_status, routeID, progress
    INTO v_airplane_status, v_routeID, v_progress
    FROM flight
    WHERE flightID = v_flightID;

    -- Get the total number of legs in the route
    SELECT MAX(sequence)
    INTO v_max_leg_seq
    FROM route_path
    WHERE routeID = v_routeID;

-- If the flight is in the air:
		-- Land the flight and disembark passengers
        -- If it has reached the end:
			-- Recycle crew and retire flight
            
    -- If flight is in the air → LAND + DISEMBARK
    -- If the plane is currently flying → LAND and DISEMBARK
    IF v_airplane_status = 'in_flight' THEN
        CALL flight_landing(v_flightID);
        CALL passengers_disembark(v_flightID);

        -- If flight has completed its last leg, recycle and retire
        IF v_progress = v_max_leg_seq THEN
            CALL recycle_crew(v_flightID);
            CALL retire_flight(v_flightID);
        END IF;

    -- If the plane is on the ground → Either board/takeoff or retire
    ELSEIF v_airplane_status = 'on_ground' THEN

        IF v_progress = v_max_leg_seq THEN
            -- Already at final destination, retire
            CALL recycle_crew(v_flightID);
            CALL retire_flight(v_flightID);
        ELSE
            -- Not yet finished, continue journey
            CALL passengers_board(v_flightID);
            CALL flight_takeoff(v_flightID);  -- Automatically updates time
        END IF;

    END IF;

END //
DELIMITER ;

-- [14] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. 
We need to display what airports these flights are departing from, what airports 
they are arriving at, the number of flights that are flying between the 
departure and arrival airport, the list of those flights (ordered by their 
flight IDs), the earliest and latest arrival times for the destinations and the 
list of planes (by their respective flight IDs) flying these flights. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as
select
    l.departure as departing_from,
    l.arrival as arriving_at,
    count(*) as num_flights,
    group_concat(f.flightID order by f.flightID separator ',') as flight_list,
    min(f.next_time) as earliest_arrival,
    max(f.next_time) as latest_arrival,
    group_concat(ap.locationID order by f.flightID separator ',') as airplane_list
from flight f
join route_path rp on f.routeID = rp.routeID and f.progress = rp.sequence
join leg l on rp.legID = l.legID
join airplane ap on f.support_airline = ap.airlineID and f.support_tail = ap.tail_num
where f.airplane_status = 'in_flight'
group by l.departure, l.arrival;

-- [15] flights_on_the_ground()
-- ------------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are 
located. We need to display what airports these flights are departing from, how 
many flights are departing from each airport, the list of flights departing from 
each airport (ordered by their flight IDs), the earliest and latest arrival time 
amongst all of these flights at each airport, and the list of planes (by their 
respective flight IDs) that are departing from each airport.*/
-- ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW flights_on_the_ground AS
WITH on_ground_flights AS (
    SELECT f.*, a.locationID AS locID
    FROM flight_tracking.flight f
    JOIN flight_tracking.airplane a
      ON (f.support_airline, f.support_tail) = (a.airlineID, a.tail_num)
    WHERE f.airplane_status = 'on_ground'
),
flight_departures AS (
    SELECT 
        f.flightID,
        f.routeID,
        f.progress,
        CASE 
            WHEN f.progress = 0 THEN (
                SELECT l.departure
                FROM route_path rp
                JOIN leg l ON rp.legID = l.legID
                WHERE rp.routeID = f.routeID AND rp.sequence = 1
                LIMIT 1
            )
            ELSE (
                SELECT l.arrival
                FROM route_path rp
                JOIN leg l ON rp.legID = l.legID
                WHERE rp.routeID = f.routeID AND rp.sequence = f.progress
                LIMIT 1
            )
        END AS departing_from
    FROM on_ground_flights f
),
flight_grouping AS (
    SELECT 
        f.flightID,
        f.locID,
        d.departing_from
    FROM on_ground_flights f
    JOIN flight_departures d ON f.flightID = d.flightID
),
num_flights_grouping AS (
    SELECT 
        d.departing_from,
        COUNT(*) AS num_flights
    FROM flight_grouping d
    GROUP BY d.departing_from
),
arrival_grouping AS (
    SELECT 
        d.departing_from,
        MIN(f.next_time) AS earliest_arrival,
        MAX(f.next_time) AS latest_arrival
    FROM flight_grouping d
    JOIN on_ground_flights f ON d.flightID = f.flightID
    GROUP BY d.departing_from
)
SELECT 
    fg.departing_from,
    nfg.num_flights,
    GROUP_CONCAT(fg.flightID) AS flight_list,
    ag.earliest_arrival,
    ag.latest_arrival,
    GROUP_CONCAT(fg.locID) AS airplane_list
FROM flight_grouping fg
JOIN num_flights_grouping nfg ON fg.departing_from = nfg.departing_from
JOIN arrival_grouping ag ON fg.departing_from = ag.departing_from
GROUP BY 
    fg.departing_from,
    nfg.num_flights,
    ag.earliest_arrival,
    ag.latest_arrival;


-- [16] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. We 
need to display what airports these people are departing from, what airports 
they are arriving at, the list of planes (by the location id) flying these 
people, the list of flights these people are on (by flight ID), the earliest 
and latest arrival times of these people, the number of these people that are 
pilots, the number of these people that are passengers, the total number of 
people on the airplane, and the list of these people by their person id. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
select
    l.departure as departing_from,
    l.arrival as arriving_at,
    count(distinct f.flightID) as num_airplanes,
    group_concat(distinct ap.locationID order by ap.locationID separator ',') as airplane_list,
    group_concat(distinct f.flightID order by f.flightID separator ',') as flight_list,
    min(f.next_time) as earliest_arrival,
    max(f.next_time) as latest_arrival,
    count(distinct pl.personID) as num_pilots,
    count(distinct ps.personID) as num_passengers,
    count(distinct coalesce(pl.personID, ps.personID)) as joint_pilots_passengers,
    group_concat(distinct p.personID order by p.personID separator ',') as person_list
from flight f
join route_path rp on f.routeID = rp.routeID and f.progress = rp.sequence
join leg l on rp.legID = l.legID
join airplane ap on ap.airlineID = f.support_airline and ap.tail_num = f.support_tail
join person p on p.locationID = ap.locationID
left join pilot pl on p.personID = pl.personID
left join passenger ps on p.personID = ps.personID
where f.airplane_status = 'in_flight'
group by l.departure, l.arrival;

-- [17] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground and in an 
airport are located. We need to display what airports these people are departing 
from by airport id, location id, and airport name, the city and state of these 
airports, the number of these people that are pilots, the number of these people 
that are passengers, the total number people at the airport, and the list of 
these people by their person id. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, country, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
select
    a.airportID as departing_from,
    a.locationID as airport,
    a.airport_name,
    a.city,
    a.state,
    a.country,
    count(distinct pl.personID) as num_pilots,
    count(distinct ps.personID) as num_passengers,
    count(distinct coalesce(pl.personID, ps.personID)) as joint_pilots_passengers,
    group_concat(distinct p.personID order by p.personID separator ',') as person_list
from airport a
join person p on p.locationID = a.locationID
left join pilot pl on pl.personID = p.personID
left join passenger ps on ps.personID = p.personID
group by
    a.airportID, a.locationID, a.airport_name, a.city, a.state, a.country;

-- [18] route_summary()
-- -----------------------------------------------------------------------------
/* This view will give a summary of every route. This will include the routeID, 
the number of legs per route, the legs of the route in sequence, the total 
distance of the route, the number of flights on this route, the flightIDs of 
those flights by flight ID, and the sequence of airports visited by the route. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
select
    r.routeID as route,
    count(rp.legID) as num_legs,
    group_concat(rp.legID order by rp.sequence separator ', ') as leg_sequence,
    sum(l.distance) as route_length,
    (select count(*) from flight f where f.routeID = r.routeID) as num_flights,
    (select group_concat(f.flightID order by f.flightID separator ', ')
     from flight f where f.routeID = r.routeID) as flight_list,
    group_concat(concat(l.departure, '->', l.arrival) order by rp.sequence separator ', ') as airport_sequence
from route r
join route_path rp on r.routeID = rp.routeID
join leg l on rp.legID = l.legID
group by r.routeID;

-- [19] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. It should 
specify the city, state, the number of airports shared, and the lists of the 
airport codes and airport names that are shared both by airport ID. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, country, num_airports,
	airport_code_list, airport_name_list) as
select
    city,
    state,
    country,
    count(*) as num_airports,
    group_concat(airportID order by airportID separator ',') as airport_code_list,
    group_concat(airport_name order by airportID separator ',') as airport_name_list
from airport
group by city, state, country
having count(*) > 1;