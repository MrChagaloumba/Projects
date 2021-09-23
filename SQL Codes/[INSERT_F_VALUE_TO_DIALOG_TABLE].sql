USE [MyDatabase2]
GO
/****** Object:  StoredProcedure [dbo].[INSERT_F_VALUE_TO_DIALOG_TABLE]    Script Date: 23.09.2021 16:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[F_VALUE_DIYALOG_TABLOYA_EKLEME] (@Dialouge_ID int)
AS BEGIN
	DECLARE @var1 DEC(7,5)
	DECLARE @max_number_words int
	DECLARE @max_satisfaction int
	DECLARE @min_number_words int 
	DECLARE @min_satisfaction int
	DECLARE @avg_number_words dec(12,5)
	DECLARE @avg_satisfaction dec(5,3)
	DECLARE @ID_number_words int
	DECLARE @ID_satistaction int
	
	DECLARE curs CURSOR FOR select max(Number_Words) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @max_number_words
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select max(Satisfaction) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @max_satisfaction
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select min(Number_Words) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @min_number_words
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select min(Satisfaction) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @min_satisfaction
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select avg(Number_Words) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @avg_number_words
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select avg(Satisfaction) from TEXTS 
	OPEN curs
	FETCH NEXT FROM curs INTO @avg_satisfaction
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select Number_Words from TEXTS where Dialouge_ID = @Dialouge_ID 
	OPEN curs
	FETCH NEXT FROM curs INTO @ID_number_words
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select Satisfaction from TEXTS where Dialouge_ID = @Dialouge_ID 
	OPEN curs
	FETCH NEXT FROM curs INTO @ID_satistaction
	CLOSE curs
	DEALLOCATE curs

	IF (@ID_number_words > @avg_number_words and @ID_satistaction > @avg_satisfaction)
	BEGIN
		SET @var1 = CONVERT(DECIMAL(7,5),((CONVERT(DECIMAL(12,5),CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_number_words-@min_number_words)/(CONVERT(DECIMAL(12,5),@max_number_words-@min_number_words))))))*CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_satistaction-@min_satisfaction)/(CONVERT(DECIMAL(12,5),@max_satisfaction-@min_satisfaction))))));
	END
	ELSE
	BEGIN
		SET @var1 = CONVERT(DECIMAL(7,5),((CONVERT(DECIMAL(12,5),CONVERT(DECIMAL(12,5),1-(CONVERT(DECIMAL(12,5),@ID_number_words-@min_number_words)/(CONVERT(DECIMAL(12,5),@max_number_words-@min_number_words))))))*CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_satistaction-@min_satisfaction)/(CONVERT(DECIMAL(12,5),@max_satisfaction-@min_satisfaction))))));
	END

	UPDATE TEXTS
	SET F_Value = @var1
	WHERE Dialouge_ID = @Dialouge_ID
END