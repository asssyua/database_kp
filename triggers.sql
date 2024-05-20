drop trigger CheckPasswordLength;
drop trigger CheckUserAge;


CREATE TRIGGER CheckPasswordLength
ON Users
AFTER INSERT
AS
BEGIN
    IF (SELECT MIN(LEN(Password)) FROM inserted) < 6
    BEGIN
        RAISERROR('������: ������ ������ ��������� �� ����� 6 ��������', 16, 1)
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
        RAISERROR('������: ������� ������������ ������ ���� �� 16 �� 110 ���', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
