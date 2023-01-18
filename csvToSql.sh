#!/bin/bash

fileName=$1
IFS=,
while read  created_time_start created_time_end event_type executed enabled event courierCode sample_awb total_tracking_number retry_count_0 retry_count_1  retry_count_2 retry_count_3 retry_count_4 retry_count_5
      do
        echo "INSERT INTO event_instance_reporting
(created_time_start,created_time_end,event_type, executed, enabled, event, courierCode,   sample_awb, total_tracking_number, retry_count_0, retry_count_1, retry_count_2, retry_count_3, retry_count_4 , retry_count_5)
values
('$created_time_start', '$created_time_end', '$event_type', '$executed', '$enabled', '$event', '$courierCode',   '$sample_awb', '$total_tracking_number', '$retry_count_0', '$retry_count_1', '$retry_count_2', '$retry_count_3', '$retry_count_4' , '$retry_count_5');"

done < $fileName  | mysql -u root -p'EngServ@001' shiptrack_test;

mv "$fileName" /home/kapil.kumar01.in/shiptrack_status_log_reports/csv_archives1
