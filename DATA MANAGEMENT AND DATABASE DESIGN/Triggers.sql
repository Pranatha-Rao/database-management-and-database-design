

CREATE TABLE [dbo].[DepartmentAudit](
    [DepartmentAuditID] int not null primary key  identity(1,1),
	[dept_no] [char](4) NOT NULL,
	[dept_name] [varchar](25) NOT NULL,
	[location] [varchar](25) NULL,
	[Action] char(1),
	[ActionDate] datetime
)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
/*
This trigger captures changes on department table
*/
-- =============================================
ALTER TRIGGER deptHistory
   ON  dbo.department
  FOR UPDATE
AS 
BEGIN
declare @action char(1)
SET @action = 'U'

		INSERT INTO  DepartmentAudit ( 
			  [dept_no]
			  ,[dept_name]
			  ,[location]
			  ,[Action]
			  ,[ActionDate]
			  )
		  SELECT [dept_no]
			  ,[dept_name]
			  ,[location]
			  ,@action,
			  GETDATE()
			   FROM DELETED
END

GO


select *
from department WHERE dept_no = 'D2' 

update 
 department SET [LOCATION] ='Seattle' WHERE dept_no = 'D2' 

 select * from DepartmentAudit


delete from department WHERE dept_no = 'D2' 


