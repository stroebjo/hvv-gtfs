--
-- Based on: https://github.com/BlinkTagInc/gtfs-to-mysql
--

DROP TABLE IF EXISTS agency;

CREATE TABLE `agency` (
  agency_id int(11) PRIMARY KEY,
  agency_name VARCHAR(255),
  agency_url VARCHAR(255),
  agency_timezone VARCHAR(50),
  agency_lang VARCHAR(50),
  agency_phone VARCHAR(50)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS calendar;

CREATE TABLE `calendar` (
  service_id INT(11),
  monday TINYINT(1),
  tuesday TINYINT(1),
  wednesday TINYINT(1),
  thursday TINYINT(1),
  friday TINYINT(1),
  saturday TINYINT(1),
  sunday TINYINT(1),
  start_date VARCHAR(8),
  end_date VARCHAR(8),
  KEY `service_id` (service_id)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE `calendar_dates` (
  service_id INT(11),
  `date` VARCHAR(8),
  exception_type INT(2),
  KEY `service_id` (service_id),
  KEY `exception_type` (exception_type)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS fare_attributes;

CREATE TABLE `fare_attributes` (
  fare_id INT(11),
  price DECIMAL(9,6),
  currency_type VARCHAR(8),
  payment_method INT(11),
  transfers INT(11),
  KEY `fare_id` (fare_id)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS fare_rules;

CREATE TABLE `fare_rules` (
  fare_id INT(11),
  route_id INT(11),
  KEY `fare_id` (fare_id),
  KEY `route_id` (route_id)
) character set UTF8mb4 collate utf8mb4_bin;


DROP TABLE IF EXISTS routes;

CREATE TABLE `routes` (
  route_id VARCHAR(100) PRIMARY KEY,
  agency_id INT(11),
  route_short_name VARCHAR(50),
  route_long_name VARCHAR(255),
  route_type INT(2),
  route_color VARCHAR(255),
  route_text_color VARCHAR(255),
  route_desc VARCHAR(255),
  KEY `route_type` (route_type)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS shapes;

CREATE TABLE `shapes` (
  shape_id VARCHAR(50),
  shape_pt_lat DECIMAL(9,6),
  shape_pt_lon DECIMAL(9,6),
  shape_pt_sequence INT(11),
  KEY `shape_id` (shape_id)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS stop_times;

CREATE TABLE `stop_times` (
  trip_id INT(11),
  arrival_time VARCHAR(8),
  departure_time VARCHAR(8),
  stop_id VARCHAR(100),
  stop_sequence INT(11),
  KEY `trip_id` (trip_id),
  KEY `stop_id` (stop_id),
  KEY `stop_sequence` (stop_sequence)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS stops;

CREATE TABLE `stops` (
    stop_id VARCHAR(100) PRIMARY KEY,
    stop_code VARCHAR(50),
    stop_name VARCHAR(255) NOT NULL,
    stop_desc VARCHAR(255),
    stop_lat DECIMAL(10,6) NOT NULL,
    stop_lon DECIMAL(10,6) NOT NULL,
    location_type VARCHAR(2),
    parent_station VARCHAR(100),
    wheelchair_boarding VARCHAR(1) DEFAULT 0,
    platform_code VARCHAR(50),

    KEY `stop_lat` (stop_lat),
    KEY `stop_lon` (stop_lon),
    KEY `location_type` (location_type),
    KEY `parent_station` (parent_station)
) character set UTF8mb4 collate utf8mb4_bin;

DROP TABLE IF EXISTS transfers;

CREATE TABLE `transfers` (
    from_stop_id VARCHAR(100),
    to_stop_id VARCHAR(100),
    transfer_type TINYINT(1),

    min_transfer_time INT(11),

    from_route_id VARCHAR(100),
    to_route_id VARCHAR(100),

    from_trip_id INT(11),
    to_trip_id INT(11),

    KEY `from_stop_id` (from_stop_id),
    KEY `to_stop_id` (to_stop_id)
) character set UTF8mb4 collate utf8mb4_bin;


DROP TABLE IF EXISTS trips;

CREATE TABLE `trips` (
    route_id VARCHAR(100),
    service_id INT(11),
    trip_id INT(11) PRIMARY KEY,
    trip_headsign VARCHAR(255),
    trip_short_name VARCHAR(255),
    direction_id TINYINT(1),
    block_id VARCHAR(255),
    shape_id INT(11),
    wheelchair_accessible VARCHAR(1),
    bikes_allowed VARCHAR(50),

    KEY `route_id` (route_id), 
    KEY `service_id` (service_id),
    KEY `direction_id` (direction_id),
    KEY `shape_id` (shape_id)
) character set UTF8mb4 collate utf8mb4_bin;


LOAD DATA LOCAL INFILE '/tmp/data/agency.txt' INTO TABLE agency CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/calendar.txt' INTO TABLE calendar CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/calendar_dates.txt' INTO TABLE calendar_dates CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/routes.txt' INTO TABLE routes CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/shapes.txt' INTO TABLE shapes CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/stop_times.txt' INTO TABLE stop_times CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/stops.txt' INTO TABLE stops CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/transfers.txt' INTO TABLE transfers CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/tmp/data/trips.txt' INTO TABLE trips CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n" IGNORE 1 LINES;
