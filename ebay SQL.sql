/*exercise 1*/	     
/*Assumptions:
1. If Promotional_Rate does not exist, it is equal null.*/

select	Room_Num, Floor_Num, isnull(Promotional_Rate, Std_Rate) as RoomRate
from Rooms ro
where 
	Ocean_View='True' and
	not exists (select 1 from Reservations re where ro.Room_Num = re.Room_Num and '2016-08-01' between re.Check_In_DT and re.Check_Out_DT)

/*exercise 2*/
/*assumptions: */

select	Room_Num, 
		Floor_Num, 
		isnull(Promotional_Rate, Std_Rate) as RoomRate, 
		case Bed_Type 
			when 'King' then 'Deluxe'
			else 'Standard'
		end as RoomType
from Rooms ro
where 
	Ocean_View='True' and
	not exists (select 1 from Reservations re where ro.Room_Num = re.Room_Num and '2016-08-01' between re.Check_In_DT and re.Check_Out_DT)

			

/*exercise 3*/

select top 3 Floor_Num, min(Room_Rate)
from Rooms
Where Ocean_View = 'True'
and not exists (select 1 from Reservations re where ro.Room_Num = re.Room_Num and '2016-08-01' between re.Check_In_DT and re.Check_Out_DT)
group by Floor_Num
having count(*) >= 3
order by Floor_Num desc

/*exercise 4*/


;with RoomsInFloor as
(
	select Floor_Num, Room_Num, Room_Rate, Row_Number() over (partition by Floor_Num order by Room_Rate) as Rate_Priority
	from Rooms
)
select f.Floor_Num, rif.Room_num, rif.Room_Rate
from RoomsInFloor rif
inner join( select Floor_Num
			from Rooms
			Where Ocean_View = 'True'
			and not exists (select 1 from Reservations re where ro.Room_Num = re.Room_Num and '2016-08-01' between re.Check_In_DT and re.Check_Out_DT)
			group by Floor_Num
			having count(*) >= 3) f
	on rif.Floor_Num = f.Floor_Num
where rif.Rate_Priority <= 3
order by rif.Floor_Num desc

/*exercise 5*/
/*Assumptions:
1. Reservation_ID is Identity column
2. Guest_ID column is not identity
3. The family ordered 3 rooms with the same Guest_ID*/
insert into Guests (Guest_ID, First, Last, City, CC_Number, Phone_Num)
select 7, 'Family', 'Cohen', 'Haifa', 3333, (310) '954-6588'

;with RoomsInFloor as
(
	select Floor_Num, Room_Num, Room_Rate, Row_Number() over (partition by Floor_Num order by Room_Rate) as Rate_Priority
	from Rooms
)
insert into Reservations (Guest_ID, Room_Num, Check_In_DT, Check_Out_DT)
select top 3 (7, rid.Room_Num, '2016-08-01', '2016-08-02')
from RoomsInFloor rif
inner join( select Floor_Num
			from Rooms
			Where Ocean_View = 'True'
			and not exists (select 1 from Reservations re where ro.Room_Num = re.Room_Num and '2016-08-01' between re.Check_In_DT and re.Check_Out_DT)
			group by Floor_Num
			having count(*) >= 3) f
	on rif.Floor_Num = f.Floor_Num
where rif.Rate_Priority <= 3
order by rif.Floor_Num desc




