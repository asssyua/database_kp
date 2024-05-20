use Busstation_db;


drop procedure OrderTransport;
drop procedure CalculateFreeSeats;
drop procedure sp_AddBus;
drop procedure sp_AddDriver;
drop procedure sp_AddPassenger;
drop procedure sp_AddDirection;
drop procedure dbo.AddUser;
drop procedure dbo.AddRoute;
drop procedure dbo.DeleteFromBuses;
drop procedure dbo.DeleteFromDrivers;
drop procedure dbo.DeleteFromPassengers;
drop procedure dbo.DeleteFromDirections;
drop procedure dbo.DeleteFromRoute;
drop procedure dbo.DeleteFromTickets;
drop procedure SaveTableDataToJson;


CREATE OR ALTER PROCEDURE OrderTransport 
    @p_ID_ticket INT, 
    @p_ID_passenger INT, 
    @p_ID_route INT, 
    @p_ID_user INT
AS
BEGIN
    DECLARE @v_Seats_number INT;
    DECLARE @v_Cost FLOAT;

    SELECT @v_Seats_number = b.Seats_number - ISNULL(COUNT(t.ID_ticket), 0)
    FROM Route r
    INNER JOIN Buses b ON r.ID_bus = b.ID_bus
    LEFT JOIN Tickets t ON r.ID_route = t.ID_route
    WHERE r.ID_route = @p_ID_route
    GROUP BY r.ID_route, b.Seats_number;

    SELECT @v_Cost = Cost
    FROM Route
    WHERE ID_route = @p_ID_route;

    INSERT INTO Tickets (ID_ticket, ID_passenger, ID_route, ID_user, Purchase_date, Seats_number, Cost)
    VALUES (@p_ID_ticket, @p_ID_passenger, @p_ID_route, @p_ID_user, GETUTCDATE(), @v_Seats_number, @v_Cost);
END;

EXEC OrderTransport @p_ID_ticket = 8, @p_ID_passenger = 2, @p_ID_route = 3, @p_ID_user = 1;

select * from Tickets;


CREATE OR ALTER PROCEDURE CalculateFreeSeats
AS
BEGIN
    SELECT r.ID_route, b.Seats_number - ISNULL(COUNT(t.ID_ticket), 0) AS Free_seats
    FROM Route r
    JOIN Buses b ON r.ID_bus = b.ID_bus
    LEFT JOIN Tickets t ON r.ID_route = t.ID_route
    GROUP BY r.ID_route, b.Seats_number;
END;

exec CalculateFreeSeats ;

CREATE PROCEDURE sp_AddBus 
  @BusID int,
  @Brand varchar(20),
  @Year date,
  @Seats int
AS
BEGIN
  INSERT INTO Buses (ID_bus, Bus_brand, Release_year, Seats_number)
  VALUES (@BusID, @Brand, @Year, @Seats)
END

EXEC sp_AddBus 3, 'BMW', '2021-01-01', 39;

select * from buses;


CREATE PROCEDURE sp_AddDriver 
  @DriverID int,
  @Surname varchar(20),
  @Name varchar(20),
  @Patronomic varchar(20),
  @License_number int,
  @Telephone_number varchar(20),
  @Age int
AS
BEGIN
  INSERT INTO Drivers (ID_driver, Surname, Name, Patronymic, License_number, Telephone_number, Age)
  VALUES (@DriverID, @Surname, @Name, @Patronomic, @License_number, @Telephone_number, @Age)
END

EXEC sp_AddDriver 5, 'Teplitsa', 'Aleksei', 'dmitrievich', 23456, '+375-33-684-32-25', 50;

select * from Drivers;


CREATE PROCEDURE sp_AddPassenger 
  @PassengerID int,
  @Surname varchar(20),
  @Name varchar(20),
  @Telephone_number varchar(20),
  @Age int
AS
BEGIN
  INSERT INTO Passengers(ID_passenger, Surname, Name, Telephone_number, Age)
  VALUES (@PassengerID, @Surname, @Name, @Telephone_number, @Age)
END

EXEC sp_AddPassenger 100001, 'Teplitsa', 'Anna', '+375-33-313-75-83', 25;

select * from Passengers where ID_passenger=100001;


CREATE PROCEDURE sp_AddDirection
  @DirectionID int,
  @Departure_time time,
  @Departure_date date,
  @Direction_time time,
  @Direction date
AS
BEGIN
  INSERT INTO Directions(ID_direction, Departure_time, Departure_date, Direction_time, Direction)
  VALUES (@DirectionID, @Departure_time, @Departure_date, @Direction_time, @Direction)
END
EXEC sp_AddDirection 5, '08:00:00', '2024-10-10', '13:25:00', '2024-10-10';

select * from Directions;



CREATE OR ALTER PROCEDURE dbo.AddUser
    @ID_user int,
    @Login nvarchar(16),
    @Password nvarchar(7),
    @ID_role int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Roles WHERE ID_role = @ID_role)
    BEGIN
        RAISERROR('Данной роли не существует', 16, 1)
        RETURN
    END
    BEGIN TRY
        INSERT INTO Users (ID_user, Login, Password, ID_role)
        VALUES (@ID_user, @Login, @Password, @ID_role)
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
        BEGIN
            RAISERROR('Нарушение ограничения внешнего ключа. Проверьте правильность идентификатора клиента.', 16, 1)
        END
        ELSE
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
            DECLARE @ErrorState INT = ERROR_STATE()
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
        END
    END CATCH
END;


EXEC dbo.AddUser 
@ID_user = 5, 
@Login = 'ex', 
@Password = 'abc666', 
@ID_role=1;

select * from Users;


	CREATE OR ALTER PROCEDURE dbo.AddRoute
    @ID_route int,
    @Departure_place varchar(50),
    @Destination varchar(50),
    @Stops varchar(20),
    @Cost float,
    @ID_driver int,
    @ID_bus int,
    @ID_direction int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Directions WHERE ID_direction = @ID_direction)
    BEGIN
        RAISERROR('А нету такого маршрута', 16, 1)
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Buses WHERE ID_bus = @ID_bus)
    BEGIN
        RAISERROR('Такого автобусика не существует', 16, 1)
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Drivers WHERE ID_driver = @ID_driver)
    BEGIN
        RAISERROR('Водилы нет', 16, 1)
        RETURN
    END

    BEGIN TRY
        INSERT INTO Route (ID_route, Departure_place, Destination, Stops, Cost, ID_driver, ID_bus, ID_direction)
        VALUES (@ID_route, @Departure_place, @Destination, @Stops, @Cost, @ID_driver, @ID_bus, @ID_direction)
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
        BEGIN
            RAISERROR('нарушение первичного ключа', 16, 1)
        END
        ELSE
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
            DECLARE @ErrorState INT = ERROR_STATE()
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
        END
    END CATCH
END

exec dbo.AddRoute 
@ID_route = 1,
    @Departure_place = 'rrr',
    @Destination = 'rrrr',
    @Stops = 'eee, ffff',
	@Cost = 45.5,
	@ID_driver = 1,
	@ID_bus = 1,
	@ID_direction =2;

drop procedure dbo.AddRoute;


CREATE OR ALTER PROCEDURE dbo.DeleteFromBuses
    @ID_busToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Buses WHERE ID_bus = @ID_busToDelete)
    BEGIN
        RAISERROR ('автобусика нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Buses
        WHERE ID_bus = @ID_busToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END


EXEC dbo.DeleteFromBuses @ID_busToDelete = 2; 
select * from Buses;
select * from Route;

CREATE OR ALTER PROCEDURE dbo.DeleteFromDrivers
    @ID_driverToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Drivers WHERE ID_driver = @ID_driverToDelete)
    BEGIN
        RAISERROR ('водилы нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Drivers
        WHERE ID_driver = @ID_driverToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END


EXEC dbo.DeleteFromDrivers @ID_driverToDelete = 2; 
select * from Drivers;


CREATE OR ALTER PROCEDURE dbo.DeleteFromPassengers
    @ID_passengerToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Passengers WHERE ID_passenger = @ID_passengerToDelete)
    BEGIN
        RAISERROR ('такого пассажира нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Passengers
        WHERE ID_passenger = @ID_passengerToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END


EXEC dbo.DeleteFromPassengers @ID_passengerToDelete = 44586; 

drop procedure  dbo.DeleteFromPassengers;

select * from Passengers where ID_passenger=44586;


CREATE OR ALTER PROCEDURE dbo.DeleteFromDirections
    @ID_directionToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Directions WHERE ID_direction = @ID_directionToDelete)
    BEGIN
        RAISERROR ('маршрута нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Directions
        WHERE ID_direction = @ID_directionToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END


EXEC dbo.DeleteFromDirections @ID_directionToDelete = 2; 
drop procedure  dbo.DeleteFromDirections;

select * from Directions;


CREATE OR ALTER PROCEDURE dbo.DeleteFromRoute
    @ID_routeToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Route WHERE ID_route = @ID_routeToDelete)
    BEGIN
        RAISERROR ('водилы нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Route
        WHERE ID_route = @ID_routeToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END

select * from Route;

EXEC dbo.DeleteFromRoute @ID_routeToDelete = 1; 
----отмена заказанного транспорта

CREATE OR ALTER PROCEDURE dbo.DeleteFromTickets
    @ID_ticketToDelete int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tickets WHERE ID_ticket = @ID_ticketToDelete)
    BEGIN
        RAISERROR ('билета нет', 16, 1)
        RETURN
    END
    BEGIN TRY
        DELETE FROM Tickets
        WHERE ID_ticket = @ID_ticketToDelete
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END

select * from Tickets;

EXEC dbo.DeleteFromTickets @ID_ticketToDelete = 1; 


