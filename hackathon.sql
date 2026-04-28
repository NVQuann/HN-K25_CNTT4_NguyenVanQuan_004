create database BuytDien;

use BuytDien;

create table passengers(
	passengers_id VARCHAR(5) primary key,
    full_name varchar(100) not null,
    phone varchar(15) not null unique,
    card_type varchar(50) not null,
    balance decimal(10,2) not null check(balance > 0),
    join_date date not null
);

create table routes(
	route_id varchar(5) primary key,
    route_name varchar(100) not null,
    start_point varchar(100) not null,
    end_point varchar(100) not null,
    distance decimal(5,2) check(distance > 0) not null,
    base_fare decimal(10,2) check(base_fare > 0)
);

create table buses(
	bus_id varchar(5) primary key,
    plate_number varchar(15) not null unique,
    route_id varchar(5) not null,
    capacity int not null,
    battery_level int not null,
    foreign key (route_id) references routes(route_id)
);

create table tickets(
	ticket_id int primary key auto_increment,
    passengers_id varchar(5) not null,
    bus_id varchar(5) not null,
    tap_time datetime not null,
    `status` varchar(20) not null,
    foreign key (passengers_id) references passengers(passengers_id),
    foreign key (bus_id) references buses(bus_id),
    unique(passengers_id, bus_id)
);

alter table passengers add column gender varchar(10);

insert into passengers(passengers_id, full_name, phone, card_type, balance,join_date)
values 
('P01', 'Nguyễn Văn Hùng', '0911222333', 'Student', 50000, '2025-01-01'),
('P02', 'Lê Thị Mai', '0988777666', 'Elder', 100000, '2025-02-10'),
('P03', 'Trần Hoàng Long', '0905444333', 'Normal', 20000, '2025-03-05'),
('P04', 'Phạm Thu Thảo', '0977111222', 'Student', 30000, '2025-04-15');

insert into routes
values 
('R01', 'Tuyến E01', 'Bến xe Mỹ Đình', 'Công viên Thống Nhất', 15.5, 7000),
('R02', 'Tuyến E02', 'Hào Nam', 'Khu đô thị Ocean Park', 22.0, 9000),
('R03', 'Tuyến E03', 'Sân bay Nội Bài', 'Cầu Giấy', 30.0, 15000);

insert into buses
values 
('B01', '29E-001.01', 'R01', 45, 85),
('B02', '29E-002.15', 'R02', 50, 40),
('B03', '29E-003.09', 'R01', 45, 15);

insert into tickets (ticket_id, passengers_id, bus_id, tap_time, `status`)
values
(1, 'P01', 'B01', '2025-11-10 07:15:00', 'Success'),
(2, 'P02', 'B02', '2025-11-10 08:30:00', 'Success'),
(3, 'P03', 'B01', '2025-11-11 17:45:00', 'Failed'),
(4, 'P01', 'B03', '2025-11-12 06:00:00', 'Success');

update routes
set base_fare = base_fare * 1.1
where route_id = 'R02';

update passengers
set card_type = 'Premium'
where passengers_id = 'P03';

delete from tickets
where `status` = 'Failed';

alter table buses add constraint check_battery check(battery_level between 0 and 100);

alter table tickets alter column `status` set default 'Success';

select *
from routes
where distance > 20;

select full_name, phone 
from passengers
where card_type = 'Student';

select bus_id, plate_number, battery_level
from buses
order by battery_level desc;

select *
from tickets
order by tap_time desc
limit 3;

select route_name, base_fare
from routes
limit 2 offset 1;

update routes
set base_fare = base_fare * 0.5
where start_point = 'Hào Nam';

update routes
set start_point = upper(start_point),
	end_point = upper(end_point);

delete from buses
where battery_level = 0;

select t.ticket_id, p.full_name, b.plate_number, r.route_name
from tickets t
join passengers p on t.passengers_id = p.passengers_id
join buses b on t.bus_id = b.bus_id
join routes r on b.route_id = r.route_id
where t.status = 'Success';

select routes.route_name, count(buses.bus_id) 'So_luong_xe'
from routes
left join buses on routes.route_id = buses.route_id
group by routes.route_id, routes.route_name;

select passengers.full_name, count(tickets.ticket_id) 'So_luot'
from tickets
join passengers on tickets.passengers_id = passengers.passengers_id
group by passengers.passengers_id, passengers.full_name
having count(tickets.ticket_id) >= 2;

select * 
from routes
where base_fare > (select avg(base_fare) from routes);

select buses.bus_id, buses.plate_number, buses.battery_level, routes.route_id
from buses
join routes on buses.route_id = routes.route_id
where buses.battery_level < 20;

select p.full_name, sum(r.base_fare) 'Tong_tien'
from tickets t
join passengers p on t.passengers_id = p.passengers_id
join buses b on t.bus_id = b.bus_id
join routes r on b.route_id = r.route_id
group by p.passengers_id, p.full_name;