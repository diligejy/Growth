

```SQL

drop table billing;
create table billing
(
      customer_id               int
    , customer_name             varchar(1)
    , billing_id                varchar(5)
    , billing_creation_date     date
    , billed_amount             int
);

insert into billing values (1, 'A', 'id1', to_date('10-10-2020','dd-mm-yyyy'), 100);
insert into billing values (1, 'A', 'id2', to_date('11-11-2020','dd-mm-yyyy'), 150);
insert into billing values (1, 'A', 'id3', to_date('12-11-2021','dd-mm-yyyy'), 100);
insert into billing values (2, 'B', 'id4', to_date('10-11-2019','dd-mm-yyyy'), 150);
insert into billing values (2, 'B', 'id5', to_date('11-11-2020','dd-mm-yyyy'), 200);
insert into billing values (2, 'B', 'id6', to_date('12-11-2021','dd-mm-yyyy'), 250);
insert into billing values (3, 'C', 'id7', to_date('01-01-2018','dd-mm-yyyy'), 100);
insert into billing values (3, 'C', 'id8', to_date('05-01-2019','dd-mm-yyyy'), 250);
insert into billing values (3, 'C', 'id9', to_date('06-01-2021','dd-mm-yyyy'), 300);

select * from billing;

with cte as
    (select customer_id,customer_name
    , sum(case when to_char(billing_creation_date,'yyyy') = '2019' then billed_amount else 0 end)::decimal as bill_2019_sum
    , sum(case when to_char(billing_creation_date,'yyyy') = '2020' then billed_amount else 0 end)::decimal as bill_2020_sum
    , sum(case when to_char(billing_creation_date,'yyyy') = '2021' then billed_amount else 0 end)::decimal as bill_2021_sum
    , count(case when to_char(billing_creation_date,'yyyy') = '2019' then billed_amount else null end) as bill_2019_cnt
    , count(case when to_char(billing_creation_date,'yyyy') = '2020' then billed_amount else null end) as bill_2020_cnt
    , count(case when to_char(billing_creation_date,'yyyy') = '2021' then billed_amount else null end) as bill_2021_cnt
    from billing
    group by customer_id,customer_name)
select customer_id, customer_name
, round((bill_2019_sum + bill_2020_sum + bill_2021_sum)/
    (  case when bill_2019_cnt = 0 then 1 else bill_2019_cnt end
     + case when bill_2020_cnt = 0 then 1 else bill_2020_cnt end
     + case when bill_2021_cnt = 0 then 1 else bill_2021_cnt end
    ),2)
from cte
order by 1;



-- Sample:
create table test (id int);
insert into test values (1),(2),(null),(3),(null);


```