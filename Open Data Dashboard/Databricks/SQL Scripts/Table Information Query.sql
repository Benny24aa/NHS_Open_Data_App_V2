SELECT `table_name`, `last_altered`, `created`
FROM `nhs_open_data_ai`.`information_schema`.`tables`
WHERE `table_name` LIKE '%random_forest%'
ORDER BY `created` DESC
LIMIT 10;