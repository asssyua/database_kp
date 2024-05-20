DECLARE @counter INT, @counter1 varchar(10)
SET @counter = 4

WHILE @counter <= 100000
BEGIN
   SET @counter1 = CAST(@counter AS varchar(10))  -- Initialize @counter1 with the value of @counter
   
   INSERT INTO Passengers(ID_passenger, Surname, Name, Telephone_number, Age)
   VALUES (@counter, 
           CONCAT('Surname', @counter1), 
           CONCAT('Name', @counter1), 
           CONCAT('375-33', @counter), 
           ABS(CHECKSUM(NEWID())) % 80 + 18)

   SET @counter = @counter + 1
END

drop index idx_SurnamePassenger on Passengers;
create INDEX idx_SurnamePassenger ON Passengers(Surname);
create index idx_Seats_number_Bus on Buses(Seats_number);
create index idx_Departure_place on Route(Departure_place);
create index idx_CostTickets on Tickets(Cost);


SET SHOWPLAN_ALL ON;
GO
SELECT Surname
FROM Passengers
WHERE Surname = 'Surname9969';
GO
SET SHOWPLAN_ALL OFF;
GO


























