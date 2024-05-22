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

DELIMITER //

CREATE PROCEDURE findReservations(IN customerId INT)
BEGIN
    SELECT r.reservationId, r.reservationTime, r.numberOfGuests, r.specialRequests 
    FROM Reservations r
    WHERE r.customerId = customerId;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE addSpecialRequest(IN reservationId INT, IN requests VARCHAR(200))
BEGIN
    UPDATE Reservations
    SET specialRequests = requests
    WHERE reservationId = reservationId;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE addReservation(
    IN customerName VARCHAR(45),
    IN contactInfo VARCHAR(200),
    IN reservationTime DATETIME,
    IN numberOfGuests INT,
    IN specialRequests VARCHAR(200)
)
BEGIN
    DECLARE customerId INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- ROLLBACK TRANSACTION IN CASE OF ERROR
        ROLLBACK;
    END;
    
    START TRANSACTION;

    -- Check if customer exists
    SELECT c.customerId INTO customerId
    FROM Customers c
    WHERE c.customerName = customerName AND c.contactInfo = contactInfo
    LIMIT 1;

    -- If customer doesn't exist, create new customer
    IF customerId IS NULL THEN
        INSERT INTO Customers (customerName, contactInfo) VALUES (customerName, contactInfo);
        SET customerId = LAST_INSERT_ID();
    END IF;

    -- Add new reservation
    INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
    VALUES (customerId, reservationTime, numberOfGuests, specialRequests);

    COMMIT;
END //

DELIMITER ;    




