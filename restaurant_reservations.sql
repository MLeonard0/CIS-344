CREATE DATABASE restaurant_reservations;
USE restaurant_reservations;

-- Create Customers Table
CREATE TABLE Customers (
customerId INT NOT NULL UNIQUE AUTO_INCREMENT,
customerName VARCHAR(45) NOT NULL,
contactInfo VARCHAR(200),
PRIMARY KEY (customerId)
);
-- Populate Customers Table
INSERT INTO Customers (customerName, contactInfo)
VALUES ('Alice  White', 'alice@gmail.com');
INSERT INTO Customers (customerName, contactInfo) 
VALUES ('Bob Blue', 'bob@gmail.com');
INSERT INTO Customers (customerName, contactInfo) 
VALUES ('Charlie Black', 'charlie@gmail.com');

-- Create Reservations Table
CREATE TABLE Reservations (
    reservationId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    reservationTime DATETIME NOT NULL,
    numberOfGuests INT NOT NULL,
    specialRequests VARCHAR(200),
    PRIMARY KEY (reservationId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);
-- Populate Reservations Table
INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests) 
VALUES
(1, '2022-10-15 18:00:00', 4, 'No special requests'),
(2, '2022-10-20 19:30:00', 2, 'Vegetarian meals for all guests'),
(3, '2022-10-25 20:00:00', 6, 'Birthday cake for a guest');

-- Create DiningPreferences Table
CREATE TABLE DiningPreferences (
    preferenceId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    favoriteTable VARCHAR(45),
    dietaryRestrictions VARCHAR(200),
    PRIMARY KEY (preferenceId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);

-- Populate DiningPreferences Table
INSERT INTO DiningPreferences (customerId, favoriteTable, dietaryRestrictions) 
VALUES 
(1, 'Window', 'Gluten-free'),
(2, 'Corner', 'Vegetarian'),
(3, 'Center', 'Nut allergy');


-- Select statements
SELECT * FROM customers;
SELECT * FROM reservations;
SELECT * FROM diningPreferences;

-- Procedure to find all reservations for a customer using their ID
DELIMITER //
CREATE PROCEDURE findReservations(IN in_customerId INT)
BEGIN
    SELECT * FROM reservations WHERE customerId = in_customerId;
END //
DELIMITER ;

-- Procedure to update the specialRequests field in the reservations table
DELIMITER //
CREATE PROCEDURE addSpecialRequest(IN in_reservationId INT, IN in_requests VARCHAR(200))
BEGIN
    UPDATE reservations SET specialRequests = in_requests WHERE reservationId = in_reservationId;
END //
DELIMITER ;

-- Procedure to create a new reservation with customer details
DELIMITER //
CREATE PROCEDURE addReservation(
    IN in_customerName VARCHAR(45), 
    IN in_contactInfo VARCHAR(200), 
    IN in_reservationTime DATETIME, 
    IN in_numberOfGuests INT, 
    IN in_specialRequests VARCHAR(200)
)
BEGIN
    DECLARE customerId INT;
    
    -- Check if customer already exists
    SELECT customerId INTO customerId FROM customers 
    WHERE customerName = in_customerName AND contactInfo = in_contactInfo;
    
    -- If customer does not exist, create a new one
    IF customerId IS NULL THEN
        INSERT INTO customers (customerName, contactInfo) VALUES (in_customerName, in_contactInfo);
        SET customerId = LAST_INSERT_ID();
    END IF;
    
    -- Add reservation
    INSERT INTO reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES
    (customerId, in_reservationTime, in_numberOfGuests, in_specialRequests);
END //
DELIMITER ;
