/* База данных Спорттиндер создана для публикации 
 * пользователями событий для занятием физической 
 * культурой и спортом, а также в развлекательных целях. 
 * Расширенная версия предусматривает спортивную социальную сеть. 
 * БД содержит в себе:
 * + Категории мероприятия 
 * + Возвратные группы 
 * + Статус мероприятий 
 * + Виды спорта
 * + Дисциплины (Расширенная версия)
 * + Регионы РФ (только Москва и область)
 * + Города
 * + Округа
 * + Районы
 * ! Адресса (необходимо реализация через IP yandex)
 * + Тип спортивного сооружения
 * + Тип медиа файлов (на всякий случай)
 * + Медиафайлы 
 * + Спортивнвые сооружения
 * + Пользователи
 * + Профили
 * + Профиль Организаций Юр. лиц (Расширенная версия)
 * + Сообщения (Расширенная версия)
 * + Дружба (Расширенная версия)
 * + Сообщества (Расширенная версия)
 * + Лайки (Расширенная версия)
 * - Созданые мероприятия
 */

select * from pg_database;

DROP DATABASE IF EXISTS sporttinder_1;
CREATE DATABASE sporttinder_1;


-- 1  Справочник категорий Мероприятий
DROP TABLE IF EXISTS competition_rank;
CREATE TABLE Competition_Rank (
	id SERIAL  PRIMARY KEY,
	name_competition VARCHAR(50) UNIQUE,
	short_name VARCHAR(25),
	archiv_rank SMALLINT not null default 0 
);
-- COMMENT ON COLUMN competition_rank.archiv_rank IS 'РАЗДАЙ КОММЕНТЫ';
INSERT INTO competition_rank (name_competition, short_name) VALUES
	('Выходи во двор поиграем', 'у дома'),
	('Тренировка во дворе', 'у дома'),
	('Выходи в парк поиграем', 'игра в парке')
;

-- DELETE FROM competition_rank WHERE id = 1;

-- 2 Справочник возрастных групп
DROP TABLE IF EXISTS age_group;
CREATE TABLE age_Group(
	id SERIAL PRIMARY KEY,
	name_age_group VARCHAR(25),
	minage smallint DEFAULT null,
	maxage smallint DEFAULT null,
	archiv_age smallint not null default 0
);

INSERT INTO age_group (name_age_group, minage, maxage) VALUES
	('Юноши', '17', '14'),
	('Девушки', '17', '14'),
	('Мальчики', '15', '10'),
	('Девочки', '15', '10')
;


-- 3 Справочник статуса Мероприятий
DROP TABLE IF EXISTS competition_status;
CREATE TABLE competition_status (
	id SERIAL PRIMARY KEY,
	name_competition_status VARCHAR(50) UNIQUE,
	archiv_status smallint not null default 0
);

INSERT INTO competition_status (name_competition_status) VALUES
	('Идет набор'),
	('Собран'),
	('Идет игра'),
	('Отмена')
;

-- 4 Справочник Видов спорта
DROP TABLE IF EXISTS sport;
CREATE TABLE sport (
	id SERIAL PRIMARY KEY,
	name_sport VARCHAR(50) NOT NULL UNIQUE,
	code_name_sport VARCHAR(25),
	razdel_sport VARCHAR(25),
	archiv_sport smallint not null default 0 
);

INSERT INTO sport (name_sport, code_name_sport, razdel_sport) VALUES
	('Футбол', '0010002611Я', 'Общероссийские'),
	('Баскетбол', '0140002611Я', 'Общероссийские'),
	('Волейбол', '0120002611Я', 'Общероссийские')
;
-- DELETE FROM sport WHERE id = 1;

 -- 5. Дисциплины (Расширенная версия)
DROP TABLE IF EXISTS discipline;
CREATE TABLE discipline (
	id SERIAL PRIMARY KEY,
	name_discipline VARCHAR(255) UNIQUE,
	code_name_sport VARCHAR(25),
	sport_name INTEGER,
	archiv_sport smallint not null default 0,
FOREIGN KEY (sport_name) REFERENCES sport(id)	
);

INSERT INTO discipline (name_discipline, code_name_sport, sport_name) VALUES
	('футбол', '0010012611Я', '1'),
	('мини-футбол (футзал)', '0010022811Я', '1'),
	('баскетбол 3х3', '0140022611Я', '2')
;
-- DELETE FROM discipline WHERE id = 2;

 -- 12. Категория медиа файлов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name_types VARCHAR(255), 
	archiv_types smallint not null default 0
);

INSERT INTO media_types (name_types) VALUES
('Фото'),
('Видео'),
('Документ')
;

-- 13. Медиа файлы 
DROP TABLE IF EXISTS media CASCADE;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    type_id BIGINT NOT NULL,
  	filename VARCHAR(50),
    body text,
	metadata JSON,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
FOREIGN KEY (type_id) REFERENCES media_types(id)
);
INSERT INTO media (type_id, filename, body) VALUES
(1, 'www.image.com\sport.bmp', 'что либо'),
(2, 'youtube.com', 'видео'),
(3, 'Регламент мероприятия', 'Правила игры')
;
-- UPDATE media SET body = 'меняем текст', updated_at = DEFAULT WHERE id = 1;


-- 6. Регионы РФ (только Москва и область)
DROP TABLE IF EXISTS geo_regions;
CREATE TABLE geo_regions (
  id SERIAL PRIMARY KEY,
  district_id smallint not null default 0,
  name_regions varchar(255) NOT NULL,
  archiv_region smallint not null default 0
 );

INSERT INTO geo_regions (id, district_id, name_regions) VALUES
	(42, 2, 'Москва'),
	(43, 2, 'Московская область'),
	(59, 4, 'Санкт-Петербург')
;


-- 7. Города
DROP TABLE IF EXISTS geo_city;
CREATE TABLE geo_city (
  id SERIAL PRIMARY KEY,
  region_id smallint NOT NULL DEFAULT '0',
  name_city varchar(255) NOT NULL,
  archiv_city smallint not null default 0,
FOREIGN KEY (region_id) REFERENCES geo_regions(id)
);

INSERT INTO geo_city (id, region_id, name_city) VALUES
	(365, 42, 'Москва'),
	(191, 42, 'Троицк (Москва)'),
	(197, 42, 'Щербинка (Москва)')
;

-- 8. Справочник округов
DROP TABLE IF EXISTS district;
CREATE TABLE district (
	id SERIAL PRIMARY KEY,
	name_city SMALLINT DEFAULT '0',
	name_district VARCHAR (255) unique,
	shortname_district VARCHAR(20) DEFAULT null UNIQUE,
	archiv_district smallint not null default 0,
FOREIGN KEY (name_city) REFERENCES geo_city(id)
);

INSERT INTO district (name_city, name_district, shortname_district) VALUES 
(365, 'Южный административный округ','ЮАО')
,(365, 'Юго-Западный административный округ','ЮЗАО')
,(365, 'Юго-Восточный административный округ','ЮВАО')
,(365, 'Центральный административный округ','ЦАО')
,(191, 'Троицкий административный округ','ТАО')
,(365, 'Северо-Западный административный округ','СЗАО')
,(365, 'Северо-Восточный административный округ','СВАО')
,(365, 'Северный административный округ','САО')
,(197, 'Новомосковский административный округ','НМАО')
,(365, 'Зеленоградский административный округ','ЗелАО')
,(365, 'Западный административный округ','ЗАО')
,(365, 'Восточный административный округ','ВАО')
;

-- 9. Справочник районов Москвы
DROP TABLE IF EXISTS areadis;
CREATE TABLE areadis (
	id SERIAL PRIMARY KEY,
	name_area VARCHAR (255) UNIQUE,
	short_name varchar(100) DEFAULT null,
	district_id smallint not NULL,
FOREIGN key (district_id) references district (id)
);

INSERT INTO areadis (name_area, short_name, district_id) VALUES 
('Академический район','Академический',2)
,('Алексеевский район','Алексеевский',7)
,('Алтуфьевский район','Алтуфьевский',7)
,('район Арбат','Арбат',4)
,('район Аэропорт','Аэропорт',8)
;

-- 10. Адресса (необходимо реализация через IP yandex) по возможности с привязкой: районов, округов, городов, регионов.
-- (сохраняем все в БД)

-- 10.1 Координаты мест проведения 
DROP TABLE IF EXISTS coordinat;
CREATE TABLE coordinat (
	id SERIAL PRIMARY KEY,
	-- coordinate POINT(x,y)
	latitude FLOAT(8),
	longitude FLOAT(8)
);

-- 11. Справочник типы сооружений(спортивные зоны)
DROP TABLE IF EXISTS object_area_type;
CREATE TABLE object_area_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	minimum_players SMALLINT not null default 0,
	maximum_players SMALLINT not null default 0,
	archiv_type SMALLINT not null default 0
);
INSERT INTO object_area_type (name_type) VALUES 
	('универсальная площадка')
	,('баскетбольная площакда')
	,('футбольная площадка')
	,('универсальный спортивный зал')
;

-- 12. Справочник объектов (территорий)
DROP TABLE IF EXISTS facillity_type;
CREATE TABLE facillity_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	archiv_type SMALLINT not null default 0
);
INSERT INTO facillity_type (name_type) VALUES 
	 ('парк')
	,('дворовая территория')
	,('футбольное поле')
	,('стадион')
;

-- 12. Информация об объекте (много записей нужны будут индексы) <== ИНДЕКСЫ!!!
DROP TABLE IF EXISTS facillity;
CREATE TABLE facillity (
	id SERIAL PRIMARY KEY,
	type_id INTEGER NOT NULL, -- справочник типов объекта
	name_facillity VARCHAR (255),
	short_name_facillity VARCHAR (50),
	adress VARCHAR (255) UNIQUE, -- улица, дом либо айди по ip яндекс => таблица 10
	firm_id BIGINT,
	media_id BIGINT,
	coordinate_id BIGINT NOT NULL,
	geo_regions_id BIGINT NOT NULL,
	geo_city_id BIGINT NOT NULL,
	district_facillity INTEGER, -- справочник от округов
	areadis_facillity INTEGER, -- справочник от районов
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
	archiv_facillity SMALLINT not null default 0,
FOREIGN KEY (type_id) REFERENCES facillity_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (geo_regions_id) REFERENCES geo_regions(id),
FOREIGN KEY (geo_city_id) REFERENCES geo_city(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id),
FOREIGN KEY (areadis_facillity) REFERENCES areadis(id),
FOREIGN KEY (district_facillity) REFERENCES district(id)
);
INSERT INTO facillity (type_id, name_facillity, adress,) VALUES 
('Дворец культуры «Капотня»','Капотня, 2-й квартал 20А',36,3)
,('Досуговый центр «Эдельвейс»','2-я ул. Синичкина 19',48,3)
,('Спортивный комплекс образовательного учреждения','Большая Переяславская ул. 1 ',58,4)
;

--13. Информация об сооружениях (спортивные зоны) (много записей нужны будут индексы) <== ИНДЕКСЫ!!!
DROP TABLE IF EXISTS object_area;
CREATE TABLE object_area (
	id SERIAL PRIMARY KEY,
	type_id BIGINT NOT NULL, -- справочник типов объекта
	name_object_area VARCHAR (255),
	short_name_area VARCHAR (50),
	facillity_id BIGINT NOT NULL,
	media_id BIGINT,
	coordinate_id BIGINT NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
	archiv_object_area SMALLINT not null default 0,
FOREIGN KEY (type_id) REFERENCES object_area_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id),
FOREIGN KEY (facillity_id) REFERENCES facillity(id)
);


 -- 15. Пользователи (много записей нужны будут индексы)
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nickname VARCHAR(50),
	firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE
	archiv_users BIT not null default 0
);

-- 16. Профиль пользователей
DROP TABLE IF EXISTS profiles_users;
CREATE TABLE profiles_users (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1), -- м или ж
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown int(11), -- город проживания
    district BIGINT, -- округ проживания
    areadis BIGINT, -- район проживания
FOREIGN KEY (district) REFERENCES district(id), 
FOREIGN KEY (areadis) REFERENCES areadis(id)

-- 17. Профиль юр. лиц
DROP TABLE IF EXISTS Firm;
CREATE TABLE Firm (
	Id_Firm BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Firm VARCHAR (25),
	Email VARCHAR (120) UNIQUE,
	Phone varchar(20),
	ogrn BIGINT, -- проверка ОГРНов как вариант - http://www.kholenkov.ru/data-validation/ogrn/
	Archiv_Firm BIT not null default 0
);
-- 18. Сообщения
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (from_user_id) REFERENCES users(id),
FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- 19. Дружба
DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    target_user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined'),
   	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME ON UPDATE NOW(),
FOREIGN KEY (initiator_user_id) REFERENCES users(id),
FOREIGN KEY (target_user_id) REFERENCES users(id),
CHECK (initiator_user_id <> target_user_id)
);

-- 20. Сообщества по интересам
DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 21. Лайки
DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    
    created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)


-- 22. Основная таблица мероприятий заполняемая пользователими


