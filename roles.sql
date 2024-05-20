use Busstation_db;


CREATE LOGIN admin_busstation_log WITH PASSWORD = 'admin_bus123';
CREATE LOGIN user_busstation_log WITH PASSWORD = 'user_123';
CREATE USER admin_busstation FOR LOGIN admin_busstation_log;
CREATE USER user_busstation FOR LOGIN user_busstation_log;
CREATE ROLE administrator_role;
CREATE ROLE user_role;
ALTER ROLE administrator_role ADD MEMBER admin_busstation;
ALTER ROLE user_role ADD MEMBER user_busstation;

---------------привелегии

GRANT EXECUTE ON SaveTableDataToJson TO administrator_role;
GRANT EXECUTE ON calculateTotalTicketCost TO administrator_role;
GRANT EXECUTE ON totalTicketsUsers TO administrator_role;
GRANT EXECUTE ON totalTicketsDirections TO administrator_role;
GRANT EXECUTE ON totalRoutesDirections TO administrator_role;
GRANT EXECUTE ON totalDateTickets TO administrator_role;
GRANT EXECUTE ON sp_AddBus TO administrator_role;
GRANT EXECUTE ON sp_AddDriver TO administrator_role;
GRANT EXECUTE ON sp_AddPassenger TO administrator_role;
GRANT EXECUTE ON sp_AddDirection TO administrator_role;
GRANT EXECUTE ON dbo.AddUser TO administrator_role;
GRANT EXECUTE ON dbo.AddRoute TO administrator_role;
GRANT EXECUTE ON dbo.DeleteFromBuses TO administrator_role;
GRANT EXECUTE ON dbo.DeleteFromDrivers TO administrator_role;
GRANT EXECUTE ON dbo.DeleteFromPassengers TO administrator_role;
GRANT EXECUTE ON dbo.DeleteFromDirections TO administrator_role;
GRANT EXECUTE ON dbo.DeleteFromRoute TO administrator_role;
GRANT EXECUTE ON SaveTableDataToJson TO administrator_role;

GRANT SELECT, INSERT,  DELETE ON Buses TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Drivers TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Passengers TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Directions TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Route TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Users TO administrator_role;
GRANT SELECT, INSERT,  DELETE ON Tickets TO administrator_role;

GRANT SELECT ON dbo.totalTicketsUsers TO user_role;
GRANT SELECT ON DBO.calculateTotalTicketCost TO user_role;
GRANT EXECUTE ON CalculateFreeSeats TO user_role;


EXECUTE AS USER = 'admin_busstation';
	SELECT * FROM Users;
	EXEC OrderTransport @p_ID_ticket = 9, @p_ID_passenger = 2, @p_ID_route = 3, @p_ID_user = 1;

REVERT;

EXECUTE AS USER = 'user_busstation';
	exec SaveTableDataToJson @tableName = 'Tickets';
	select * from Tickets;
REVERT;

