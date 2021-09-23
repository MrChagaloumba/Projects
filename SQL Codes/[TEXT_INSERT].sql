USE [MyDatabase2]
GO
/****** Object:  StoredProcedure [dbo].[TEXT_ATAYICI]    Script Date: 23.09.2021 16:25:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TEXT_INSERT] (@text varchar(max))
AS BEGIN
	INSERT INTO TEXTS (Dialouge_Text) VALUES
	(@text)
	DECLARE @tempTable TABLE (kelime varchar(30))
	DECLARE @tmpWord VARCHAR(500) = '';
	DECLARE @t VARCHAR(500) = '';
	DECLARE @I INT;
	DECLARE @cumle varchar(max)
	DECLARE curs CURSOR FOR SELECT Dialouge_Text FROM TEXTS WHERE Dialouge_Text = @text
	OPEN curs
	FETCH NEXT FROM curs INTO @cumle
	CLOSE curs
	DEALLOCATE curs
    
	SELECT @I = 0
    WHILE(@I < LEN(@cumle)+1)
    BEGIN
      SET @t = SUBSTRING(@cumle,@I,1)

      IF(@t != ' ')
      BEGIN
		SET @tmpWord = @tmpWord + @t
      END
      ELSE
      BEGIN
		INSERT INTO @tempTable Values(@tmpWord);
        SET @tmpWord=''
      END
		SET @I = @I + 1
    END
	INSERT INTO @tempTable Values(@tmpWord);

	DELETE FROM @tempTable where kelime=' ';

	UPDATE @tempTable
	set kelime = LEFT(kelime,len(kelime)-1)
	WHERE kelime like '%,' or kelime like '%.' or kelime like '%;' or kelime like '%:' or kelime like '%)';
	
	DECLARE @number_words int
	DECLARE curs CURSOR FOR SELECT COUNT(kelime) FROM @tempTable;
	OPEN curs
	FETCH NEXT FROM curs INTO @number_words
	CLOSE curs
	DEALLOCATE curs
	--KELİME SAYISI ATANDI
	UPDATE TEXTS
	set Number_Words = @number_words
	WHERE Dialouge_Text = @text
	--Random Satistaction Atandı
	DECLARE @var1 int
	SET @var1 = FLOOR(RAND()*11);
	UPDATE TEXTS
	SET Satisfaction = @var1
	WHERE Dialouge_Text = @text;

	--F_Value Ata
	DECLARE @var DEC(7,5)
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

	DECLARE curs CURSOR FOR select Number_Words from TEXTS where Dialouge_Text = @text 
	OPEN curs
	FETCH NEXT FROM curs INTO @ID_number_words
	CLOSE curs
	DEALLOCATE curs

	DECLARE curs CURSOR FOR select Satisfaction from TEXTS where Dialouge_Text = @text
	OPEN curs
	FETCH NEXT FROM curs INTO @ID_satistaction
	CLOSE curs
	DEALLOCATE curs

	IF (@ID_number_words > @avg_number_words and @ID_satistaction > @avg_satisfaction)
	BEGIN
		SET @var = CONVERT(DECIMAL(7,5),((CONVERT(DECIMAL(12,5),CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_number_words-@min_number_words)/(CONVERT(DECIMAL(12,5),@max_number_words-@min_number_words))))))*CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_satistaction-@min_satisfaction)/(CONVERT(DECIMAL(12,5),@max_satisfaction-@min_satisfaction))))));
	END
	ELSE
	BEGIN
		SET @var = CONVERT(DECIMAL(7,5),((CONVERT(DECIMAL(12,5),CONVERT(DECIMAL(12,5),1-(CONVERT(DECIMAL(12,5),@ID_number_words-@min_number_words)/(CONVERT(DECIMAL(12,5),@max_number_words-@min_number_words))))))*CONVERT(DECIMAL(12,5),(CONVERT(DECIMAL(12,5),@ID_satistaction-@min_satisfaction)/(CONVERT(DECIMAL(12,5),@max_satisfaction-@min_satisfaction))))));
	END

	UPDATE TEXTS
	SET F_Value = @var
	WHERE Dialouge_Text = @text
END