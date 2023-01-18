cd /home/kapil.kumar01.in/shiptrack_status_log_reports/
startDateTime=$(date --date='-15 minute' '+%Y-%m-%d %H:%M:%S')
endDateTime=$(date '+%Y-%m-%d %H:%M:%S')
groupingByMinutes=5

v_today=`date -d "$startDateTime" +%Y-%m-%d-T-%H-%M-%S`
mysql -sN -u   pa14350IU -pq#zfXk27b -h 10.70.30.183 -P 3611 shiptrack -e"
select
min(updated) as created_time_start,
max(updated) as created_time_end,
event_type,
executed,
enabled,
case when event_type in ('terminateRequest', 'sendInitiateRequest', 'sendUpdateRequest')
then substring_index(substring_index(substring(json_arguments,instr(json_arguments,'eventCode'),50),'\\\\',3),'\"',-1)
else substring_index(substring_index(substring(json_arguments,instr(json_arguments,'statusCode'),50),'\\\\',3),'\"',-1) end as event,
substring_index(substring_index(substring(json_arguments,instr(json_arguments,'courierCode'),50),'\\\\',3),'\"',-1) as courierCode,
min(tracking_number) as sample_awb,
count(tracking_number) as total_tracking_number,
sum(case when retry_count=0 then 1 else 0 END) as retry_count_0,
sum(case when retry_count=1 then 1 else 0 END) as retry_count_1,
sum(case when retry_count=2 then 1 else 0 END) as retry_count_2,
sum(case when retry_count=3 then 1 else 0 END) as retry_count_3,
sum(case when retry_count=4 then 1 else 0 END) as retry_count_4,
sum(case when retry_count=5 then 1 else 0 END) as retry_count_5
from event_instance
where updated between '${startDateTime}' and '${endDateTime}'
group by updated - INTERVAL extract(SECOND FROM updated) second - INTERVAL EXTRACT(MINUTE FROM updated) %  ${groupingByMinutes}  MINUTE ,3,4,5,6,7;"  | sed 's/\t/,/g' > "${v_today}.csv";


sh csvToSql.sh  "$v_today.csv"
