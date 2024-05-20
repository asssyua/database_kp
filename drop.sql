use Busstation_db;



drop view RoleUsers;
drop view TicketDetails;


CREATE VIEW RoleUsers AS
SELECT R.Role_name, 
       U.ID_user, 
       U.Login, 
       U.Password
FROM Roles R
JOIN Users U ON R.ID_role = U.ID_role;

select * from RoleUsers; 


CREATE VIEW TicketDetails AS
SELECT T.ID_ticket, 
       P.Surname AS Passenger_Surname, 
       P.Name AS Passenger_Name, 
       P.Telephone_number AS Passenger_Telephone, 
       R.Departure_place AS Departure_place, 
       R.Destination, 
       U.Login AS User_Login, 
       T.Purchase_date, 
       T.Cost
FROM Tickets T
JOIN Passengers P ON T.ID_passenger = P.ID_passenger
JOIN Route R ON T.ID_route = R.ID_route
JOIN Users U ON T.ID_user = U.ID_user;

select * from TicketDetails;



CREATE VIEW OrdersByUser AS
SELECT *
FROM Tickets
WHERE ID_user = 1; 

select * from OrdersByUser

CREATE TRIGGER UpdateOrdersByUser
ON Tickets
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID int;

    SELECT @UserID = ID_user
    FROM inserted;

    UPDATE OrdersByUser
    SET ID_ticket = t.ID_ticket,
        ID_passenger = t.ID_passenger,
        ID_route = t.ID_route,
        ID_user = t.ID_user,
        Purchase_date = t.Purchase_date,
        Seats_number = t.Seats_number,
        Cost = t.Cost
    FROM OrdersByUser ou
    JOIN Tickets t ON ou.ID_ticket = t.ID_ticket
    WHERE t.ID_user = @UserID;
END