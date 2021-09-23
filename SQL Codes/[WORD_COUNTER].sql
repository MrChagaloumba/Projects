USE [MyDatabase2]
GO
/****** Object:  StoredProcedure [dbo].[WORD_COUNTER]    Script Date: 23.09.2021 16:18:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[KELIME_SAYICI] (@Dialouge_ID int)
AS BEGIN
	DECLARE @tempTable TABLE (kelime varchar(30))
	DECLARE @tmpWord VARCHAR(500) = '';
	DECLARE @t VARCHAR(500) = '';
	DECLARE @I INT;
	DECLARE @cumle varchar(max)
	DECLARE curs CURSOR FOR SELECT Dialouge_Text FROM TEXTS WHERE Dialouge_ID = @Dialouge_ID
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
	
	SELECT kelime,COUNT(kelime)
	FROM @tempTable
	GROUP BY kelime;
END