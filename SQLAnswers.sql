#2A. What are the top 5 brands by receipts scanned for most recent month?
with brands_cte as (
select distinct name, brandCode from brands
),
items as (
select receipts_id, brandcode from rewards_receipts_item
),
receipts_cte as (
select _id as receiptid, strftime('%Y-%m', dateScanned) as date from receipts
)
select r.date, b.name, count(r.receiptid) as cnt_receiptid 
from receipts_cte as r
inner join items as i on i.receipts_id=r.receiptid
inner join brands as b on i.brandCode=b.brandcode
group by 1,2
having r.date = '2021-01'
order by 3 desc 
limit 5;

#2B. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select Accepted
	  ,Rejected
      ,case when accepted > rejected then 'Accepted' else 'Rejected' end as Status 
	from (select avg(case when rewardsReceiptStatus = 'FINISHED' then totalSpent else 0 end) as Accepted
				,avg(case when rewardsReceiptStatus = 'REJECTED' then totalSpent else 0 end) as Rejected
			from test.receipts) t;

#2C. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select Accepted
	  ,Rejected
      ,case when accepted > rejected then 'Accepted' else 'Rejected' end as Status 
	from (select avg(case when rewardsReceiptStatus = 'FINISHED' then purchasedItemCount else 0 end) as Accepted
				,avg(case when rewardsReceiptStatus = 'REJECTED' then purchasedItemCount else 0 end) as Rejected
			from test.receipts) t;


#2D. Which brand has the most spend among users who were created within the past 6 months?
select i.brandcode, sum(r.totalspent)
from test.rewards_receipt_itml i
join test.receipts r 
on i.receipts_id=r.id
where r.userid in (select distinct id as userid from test.users where date_sub(now(), interval 6 month)) 
and i.brandcode is not null and i.brandcode != ''
group by 1 
order by 2 desc
limit 1;

#Which brand has the most transactions among users who were created within the past 6 months?
select i.brandcode, sum(r.purchasedItemCount)
from test.rewards_receipt_itml i
join test.receipts r 
on i.receipts_id=r.id
where r.userid in (select distinct id as userid from test.users where date_sub(now(), interval 6 month)) 
and i.brandcode is not null and i.brandcode != ''
group by 1 
order by 2 desc
limit 1;