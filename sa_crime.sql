use data_project2;
-- Creating new table
-- Create Table SA_Crime 
-- (Reported_Date date, 
-- Suburb_Incident varchar(50), 
-- Postcode_Incident int,
-- Offence_Level1 varchar(50),
-- Offence_Level2 varchar(50),
-- Offence_Level3 varchar(50),
-- Offence_Count int
-- );
-- Drop Table SA_Crime;

select * from SA_Crime;
-- load the file into the table created
-- Load Data Infile 'C:/sa_crime.csv' into Table SA_Crime
-- Fields Terminated by ','
-- Ignore 1 lines;

-- SET sql_mode = "";

-- select @@secure_file_priv;

-- identify how many suburbs
select count(distinct Suburb_Incident)
from SA_Crime;

-- get the top 10 suburb with the highest offence count
select Suburb_Incident, sum(Offence_Count) as Offence
from SA_Crime
group by Suburb_Incident
order by Offence desc
limit 10;

select * from SA_Crime;



-- create a view where zipcode is null and suburbs that are null and not disclosed
Drop View drop_nulls_sa_crime ;
Create View drop_nulls_sa_crime
As
select *
from SA_Crime
where Suburb_Incident is not Null and Postcode_Incident is not Null and Suburb_Incident != "NOT DISCLOSED" and Suburb_Incident != "";

select * from drop_nulls_sa_crime;

-- select the top 10 suburbs/town with the highest offence count

Drop View Top_10_Suburbs;
CREATE VIEW Top_10_Suburbs
AS
select Suburb_Incident, Postcode_Incident, sum(Offence_Count) as Offence
from drop_nulls_sa_crime
group by Suburb_Incident, Postcode_Incident
order by Offence desc
limit 10;


-- get the major Offence incident in Adelaide

select distinct Offence_Level1, sum(Offence_Count)
from drop_nulls_sa_crime
where Suburb_Incident LIKE "Adelaide"
group by Offence_Level1;

Drop view Top_Offences_in_Adelaide;
CREATE VIEW Offences_Against_Property_Adelaide
AS
select distinct Offence_Level2, count(Offence_Count) as total_offence
from drop_nulls_sa_crime
where Offence_Level1 = "OFFENCES AGAINST PROPERTY" and Suburb_Incident LIKE "Adelaide"
group by Offence_Level2
order by total_offence desc
;

CREATE VIEW Offences_Against_The_Person_Adelaide
AS
select distinct Offence_Level2, count(Offence_Count) as total_offence
from drop_nulls_sa_crime
where Offence_Level1 = "OFFENCES AGAINST THE PERSON" and Suburb_Incident LIKE "Adelaide"
group by Offence_Level2
order by total_offence desc
;

Drop View Against_Person;
CREATE VIEW Against_Person
AS
select YEAR(Reported_Date) Year_Reported, Offence_Level1, sum(Offence_Count)
from drop_nulls_sa_crime
where Offence_Level1 = "OFFENCES AGAINST THE PERSON"
group by YEAR(Reported_Date);

Drop View Against_Property;
CREATE VIEW Against_Property
AS
select YEAR(Reported_Date) Year_Reported, Offence_Level1, sum(Offence_Count)
from drop_nulls_sa_crime
where Offence_Level1 = "OFFENCES AGAINST PROPERTY"
group by YEAR(Reported_Date);

select *
from Against_Property AProp
JOIN Against_Person APer
on AProp.Year_Reported = APer.Year_Reported;