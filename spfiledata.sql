create procedure spfiledata(@path nvarchar(30), @type nvarchar(30))
as 
begin

create table #temp(
raw_data nvarchar(2000),
)

declare @myfiles table(id int primary key identity(1,1) , fullpath nvarchar(2000) ) 
declare @pathstring nvarchar(50)

set @pathstring = 'dir "'+@path+'\*.'+@type+'" /o:n/t:c' 
print @pathstring
insert into #temp execute xp_cmdshell @pathstring



insert into  @myfiles select * from #temp where raw_data like '__-__-____%'

select	substring(fullpath ,PATINDEX('%[a-zA-Z]%',fullpath), len(fullpath)-PATINDEX('%[a-zA-Z]%',fullpath)+1)as [file name] ,
		SUBSTRING(fullpath ,1, PATINDEX( '% %', fullpath) -1 )as [date] ,
		SUBSTRING(fullpath ,patindex('%_:_%' , fullpath)-1 , 5 )as [time] , 
		SUBSTRING(fullpath ,patindex('%   [0-9]%' , fullpath)+3 ,PATINDEX('%[a-zA-Z]%',fullpath)-1-(patindex('%   [0-9]%' , fullpath)+3))+' bytes' as size  
		from @myfiles


end
--specify type of file and its directory
execute spfiledata 'd:\c programs', 'cpp'



