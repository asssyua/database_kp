create database Busstation_db;
drop database Busstation_db;


drop table Buses;
drop table Drivers;
drop table Passengers;
drop table Directions;
drop table Route;
drop table Roles;
drop table Users;
drop table Tickets;

 create table Buses(
	ID_bus int primary key,
	Bus_brand varchar(20),
	Release_year date,
	Seats_number int
 );

 create table Drivers(
	ID_driver int primary key,
	Surname varchar(20),
	Name varchar(10),
	Patronymic varchar(20),
	License_number int,
	Telephone_number varchar(20),
	Age int
);
 create table Passengers(
	ID_passenger int primary key,
	Surname varchar(20),
	Name varchar(10),
	Telephone_number varchar(20),
	Age int
);


create table Directions(
	ID_direction int primary key,
	Departure_time time,
	Departure_date date,
	Direction_time time,
	Direction date
);

create table Route(
	ID_route int primary key,
	Departure_place varchar(50),
	Destination varchar(50),
	Stops varchar(20),
	Cost float,
	ID_driver int foreign key references Drivers(ID_driver),
	ID_bus int foreign key references Buses(ID_bus),
	ID_direction int foreign key references Directions(ID_direction)
);

alter table Route drop constraint FK__Route__ID_bus__403A8C7D;
alter table Route add constraint FK__Route__ID_bus__403A8C7D foreign key(ID_bus) references Buses(ID_bus) on delete cascade;


create table Roles(
	ID_role int primary key,
	Role_name varchar(10)
);

create table Users(
	ID_user int primary key,
	Login varchar(20),
	Password varchar(20),
	ID_role int foreign key references Roles(ID_role),
);

create table Tickets(
	ID_ticket int primary key,
	ID_passenger int foreign key references Passengers(ID_passenger),
	ID_route int foreign key references Route(ID_Route),
	ID_user int foreign key references Users(ID_user),
	Purchase_date date,
	Seats_number int,
	Cost float
);
alter table Tickets drop constraint FK__Tickets__ID_rout__49C3F6B7;
alter table Tickets add constraint FK__Tickets__ID_rout__49C3F6B7 foreign key(ID_route) references Route(ID_route) on delete cascade;


INSERT INTO Buses VALUES (1, 'Volvo', '2015-10-25', 50);
INSERT INTO Buses VALUES (2, 'Mercedes', '2018-05-12', 45);
INSERT INTO Buses VALUES (3, 'Scania', '2019-08-30', 55);

INSERT INTO Drivers VALUES (1, 'Smith', 'John', 'Михайлович', 123456, '123-456-7890', 40);
INSERT INTO Drivers VALUES (2, 'Johnson', 'Robert', 'Иванович', 789012, '456-789-1230', 35);
INSERT INTO Drivers VALUES (3, 'Williams', 'David', 'Михайлович', 456789, '789-123-4560', 45);

INSERT INTO Passengers VALUES (1, 'Taylor', 'Emma', '987-654-3210', 25);
INSERT INTO Passengers VALUES (2, 'Anderson', 'James', '654-321-0987', 30);
INSERT INTO Passengers VALUES (3, 'Martinez', 'Sophia', '321-098-7654', 20);

INSERT INTO Directions VALUES (1, '08:00:00', '2022-10-10', '12:00:00', '2022-10-10');
INSERT INTO Directions VALUES (2, '12:30:00', '2022-10-12', '16:30:00', '2022-10-12');
INSERT INTO Directions VALUES (3, '10:00:00', '2022-10-15', '14:00:00', '2022-10-15');

INSERT INTO Route VALUES (1, 'City A', 'City B', 'Stop 1',60,  1, 1, 1);
INSERT INTO Route VALUES (2, 'City C', 'City D', 'Stop 2', 70.5, 2, 2, 2);
INSERT INTO Route VALUES (3, 'City E', 'City F', 'Stop 7, Stop 8',55, 3, 3, 3);

INSERT INTO Roles VALUES (1, 'Admin');
INSERT INTO Roles VALUES (2, 'Passenger');

INSERT INTO Users VALUES (1, 'admin_user', 'admin123', 1);
INSERT INTO Users VALUES (2, 'passenger_user', 'passenger789', 2);


