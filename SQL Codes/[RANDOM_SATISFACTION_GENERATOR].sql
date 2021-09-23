USE [MyDatabase2]
GO
/****** Object:  StoredProcedure [dbo].[RASGELE_SATISFACTION_ATAYICI]    Script Date: 23.09.2021 16:23:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[RANDOM_SATISFACTION_GENERATOR] (@Dialouge_ID int)
AS BEGIN
	DECLARE @var1 int
	SET @var1 = FLOOR(RAND()*11);
	UPDATE TEXTS
	SET Satisfaction = @var1
	WHERE Dialouge_ID=@Dialouge_ID;
END