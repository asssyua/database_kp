drop trigger CheckPasswordLength;
drop trigger CheckUserAge;


CREATE TRIGGER CheckPasswordLength
ON Users
AFTER INSERT
AS
BEGIN
    IF (SELECT MIN(LEN(Password)) FROM inserted) < 6
    BEGIN
        RAISERROR('Ошибка: Пароль должен содержать не менее 6 символов', 16, 1)
        ROLLBACK TRANSACTION
    END
END;



CREATE TRIGGER CheckUserAge
ON Passengers
AFTER INSERT
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted WHERE Age < 16 OR Age > 110) > 0
    BEGIN
        RAISERROR('Ошибка: Возраст пользователя должен быть от 16 до 110 лет', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
