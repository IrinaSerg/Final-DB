DROP DATABASE FinalTask IF EXISTS;
CREATE DATABASE FinalTask;

USE FinalTask;

CREATE TABLE Users (
    ID INT PRIMARY KEY NOT NULL AUTOINCREMENT,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    City VARCHAR(255)
);

INSERT INTO Users (FirstName, LastName, City) VALUES 
('Sergey', 'Popov', 'St. Petersburg'),
('Petr', 'Ivanov', 'Moscow'),
('Anton', 'Ershov', 'Tagil');

CREATE TABLE Users_old (
    ID INT PRIMARY KEY NOT NULL AUTOINCREMENT,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    City VARCHAR(255)
);

DROP PROCEDURE migrate_user_to_old IF EXISTS;
DELIMITER //
CREATE PROCEDURE migrate_user_to_old (IN user_id INT)
BEGIN

  DECLARE @user_name VARCHAR(255);
  DECLARE @user_lastname VARCHAR(255);
  DECLARE @user_city VARCHAR(255);

  DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  SET @user_name = (SELECT FirstName FROM Users WHERE ID = @user_id)
  SET @user_lastname = (SELECT LastName FROM Users WHERE ID = @user_id)
  SET @user_city = (SELECT City FROM Users WHERE ID = @user_id)

  INSERT INTO Users_old (FirstName, LastName, City) VALUES
  (@user_name, @user_lastname, @user_city);

  DELETE FROM Users WHERE ID = @user_id;

  COMMIT;
END //
DELIMITER ;

DROP FUNCTION hello IF EXISTS;
DELIMITER //
CREATE FUNCTION hello ()
RETURNS TINYTEXT NOT DETERMINISTIC
BEGIN
	DECLARE hour INT;
	SET hour = HOUR(NOW());
	CASE
		WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
		WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
	END CASE;
END //
DELIMITER ;