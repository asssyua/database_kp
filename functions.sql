drop function calculateTotalTicketCost;
drop function totalTicketsUsers;
drop function totalTicketsDirections;
drop function totalRoutesDirections;
drop function totalDateTickets;


CREATE FUNCTION calculateTotalTicketCost( @ID_user int) RETURNS int
BEGIN
  DECLARE @totalCost int ;
  
  set @totalcost = (SELECT SUM(Cost)
  FROM Tickets
  WHERE ID_user = ID_user)
  
  RETURN @totalCost;
END;

select DBO.calculateTotalTicketCost(1) AS 'стоимость всех билетов пользователя';

--– Поиска всех билетов, приобретенных пассажиром

CREATE or alter FUNCTION totalTicketsUsers( @ID_user int) RETURNS int
BEGIN
  DECLARE @totalticketsU int ;
  
  set @totalticketsU = (SELECT count(ID_ticket)
  FROM Tickets
  WHERE ID_user = ID_user)
  
  RETURN @totalticketsU;
END;

select dbo.totalTicketsUsers(1) AS 'количетсво билетов, приобретенных пассажиром';

--– Подсчета количества билетов, приобретенных на определенный рейс;

CREATE OR ALTER FUNCTION totalTicketsDirections (@ID_route int) RETURNS int
AS
BEGIN
  DECLARE @totalticketsR int ;
  
  SELECT @totalticketsR = COUNT(ID_ticket)
  FROM Tickets
  WHERE ID_Route = @ID_route;

  RETURN @totalticketsR;
END;

select dbo.totalTicketsDirections(3) AS 'количество билетов приобретенных на определенный рейс';

--– Поиска всех рейсов для определенного направления;
CREATE or alter FUNCTION totalRoutesDirections ( @ID_direction int) RETURNS int
BEGIN
  DECLARE @totalRoutesD int ;
  
  set @totalRoutesD = (SELECT count(ID_route)
  FROM Route
  WHERE ID_direction = ID_direction)
  
  RETURN @totalRoutesD;
END;

select dbo.totalRoutesDirections (1) AS 'все рейсы на определенное направление';
--– Поиска всех билетов, которые были куплены в указанную дату

CREATE or alter FUNCTION totalDateTickets ( @Purchase_date date) RETURNS int
BEGIN
  DECLARE @dateTickets int ;
  
  set @dateTickets = (SELECT count(ID_ticket)
  FROM Tickets
  WHERE Purchase_date = @Purchase_date)
  
  RETURN @dateTickets;
END ;

select dbo.totalDateTickets ('2021-09-17') AS 'все билеты купленные в определенную дату' ;
