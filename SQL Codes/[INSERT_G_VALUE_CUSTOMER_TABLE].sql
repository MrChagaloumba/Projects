USE [MyDatabase2]
GO
/****** Object:  StoredProcedure [dbo].[INSERT_G_VALUE_CUSTOMER_TABLE]    Script Date: 23.09.2021 16:15:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[G_VALUE_CUSTOMER_TABLOYA_EKLEME] (@Customer_ID int)
AS BEGIN
	DECLARE @var1 DEC(7,5)
	DECLARE @max_F_Value DEC(7,5)
	DECLARE @min_F_Value DEC(7,5)
	DECLARE @avg_F_Value DEC(7,5) 
	DECLARE @ID_F_Value DEC(7,5)

	DECLARE curs CURSOR FOR select max(F_Value) from CALL_CENTER_AND_CUSTOMER JOIN TEXTS ON CALL_CENTER_AND_CUSTOMER.Dialouge_ID = TEXTS.Dialouge_ID
	OPEN curs
	FETCH NEXT FROM curs INTO @max_F_Value
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select min(F_Value) from CALL_CENTER_AND_CUSTOMER JOIN TEXTS ON CALL_CENTER_AND_CUSTOMER.Dialouge_ID = TEXTS.Dialouge_ID
	OPEN curs
	FETCH NEXT FROM curs INTO @min_F_Value
	CLOSE curs
	DEALLOCATE curs
	
	DECLARE curs CURSOR FOR select avg(F_Value) from CALL_CENTER_AND_CUSTOMER JOIN TEXTS ON CALL_CENTER_AND_CUSTOMER.Dialouge_ID = TEXTS.Dialouge_ID
	OPEN curs
	FETCH NEXT FROM curs INTO @avg_F_Value
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select avg(F_Value) from CALL_CENTER_AND_CUSTOMER JOIN TEXTS ON CALL_CENTER_AND_CUSTOMER.Dialouge_ID = TEXTS.Dialouge_ID WHERE Customer_ID = @Customer_ID
	OPEN curs
	FETCH NEXT FROM curs INTO @ID_F_Value
	CLOSE curs
	DEALLOCATE curs

	SET @var1 = (@ID_F_Value-@min_F_Value)/(@max_F_Value-@min_F_Value)

	UPDATE CUSTOMER
	SET G_Value = @var1
	WHERE Customer_ID = @Customer_ID
END