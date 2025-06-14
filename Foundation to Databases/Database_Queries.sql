>-- Friezas Gonçalves Christophe

/* Select all Circuit with their full name, reference and the total amount of races driven on them which have had more
 * than 3 races conducted on them */

select c.circuitref, c.name, count(race_id) as amount_Races -- select necessary columns and aggregate function
from circuits c inner join races r on c.circuitref =r.circuitref  -- join on necessary tables for combined information
group by c.circuitref, c.name  -- group per circuit and name
having count(race_id) >3;      -- condition on races

/* Select forename, surname and reference for drivers who have never won a race */

select  forename, surname, driver_ref  from drivers d inner join results r on d.driver_ref =r.driverref  -- select necessary columns and join necessary tables
where driver_ref not in (select r2.driverref from results r2 where r2.position_order = 1)  -- condition to select first place by subquery and not picking people in the subquery
group by d.driver_ref  -- group by drivers


/* Select the qualifying id, position of each qualyfing as well as the sum of all individual qualyfings for Fernando Alonso on the Monaco race track*/

select q.qualifyid,  q."POSITION" , sum(q1_time)over w as total_driving_time_1,sum(q2_time)over w as total_driving_time_2,sum(q3_time)over w as total_driving_time_3 -- select necessary column and use window w for our partition for the aggregate functions
from drivers d inner join qualifying q on d.driver_ref = q.driverref  -- join necessary tables
where q.race_id in (select r.race_id from races r where r.circuitref='monaco') and driver_ref = 'alonso' -- check for alonso and a subquery to check for races on the monaco track
window w as (partition by driver_ref order by q.qualifyid) -- create the window for less repetition in the first line, window partitions table on common value driver_ref with an order by for a summative result instead of immediate sum