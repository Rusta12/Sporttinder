/* База данных Спорттиндер создана для публикации 
 * пользователями событий для занятием физической 
 * культурой и спортом, а также в развлекательных целях. 
 * Расширенная версия предусматривает спортивную социальную сеть. 
 * БД содержит в себе:
 * + Категории мероприятия 
 * + Возвратные группы 
 * + Статус мероприятий 
 * + Виды спорта
 * + Дисциплины 
 * + Регионы РФ (только Москва и область)
 * + Города
 * + Округа
 * + Районы
 * ! Адресса (необходимо реализация через IP yandex)
 * + Тип спортивного сооружения
 * + Тип медиа файлов 
 * + Медиафайлы 
 * + Информация об объекте
 * + Информация об сооружениях
 * + Пользователи
 * + Профили
 * + Профиль Организаций Юр. лиц 
 * + Сообщения 
 * + Дружба 
 * + Сообщества 
 * + Лайки 
 * + Созданые мероприятия
 */

select * from pg_database;

DROP DATABASE IF EXISTS sporttinder;
CREATE DATABASE sporttinder;


-- 1.  Справочник категорий Мероприятий
DROP TABLE IF EXISTS competition_rank CASCADE;
CREATE TABLE Competition_Rank (
	id SERIAL PRIMARY KEY,
	name_competition VARCHAR(50) UNIQUE,
	short_name VARCHAR(25),
	archiv_rank BOOL not null default false 
);
-- COMMENT ON COLUMN competition_rank.archiv_rank IS 'РАЗДАЙ КОММЕНТЫ';

-- 2. Справочник возрастных групп
DROP TABLE IF EXISTS age_group CASCADE;
CREATE TABLE age_group(
	id SERIAL PRIMARY KEY,
	name_age_group VARCHAR(25),
	minage smallint DEFAULT null,
	maxage smallint DEFAULT null,
	archiv_age BOOL not null default false
);


-- 3. Справочник статуса Мероприятий
DROP TABLE IF EXISTS competition_status CASCADE;
CREATE TABLE competition_status (
	id SERIAL PRIMARY KEY,
	name_competition_status VARCHAR(50) UNIQUE,
	archiv_status BOOL not null default false
);

-- 4. Справочник Видов спорта
DROP TABLE IF EXISTS sport CASCADE;
CREATE TABLE sport (
	id SERIAL PRIMARY KEY,
	name_sport VARCHAR(50) NOT NULL UNIQUE,
	code_name_sport VARCHAR(25),
	razdel_sport VARCHAR(25),
	archiv_sport BOOL not null default false
);

 -- 5. Дисциплины
DROP TABLE IF EXISTS discipline CASCADE;
CREATE TABLE discipline (
	id SERIAL PRIMARY KEY,
	name_discipline VARCHAR(255) UNIQUE,
	code_name_sport VARCHAR(25),
	sport_name INTEGER,
	archiv_sport BOOL not null default false,
FOREIGN KEY (sport_name) REFERENCES sport(id)	
);

 -- 6. Категория медиа файлов
DROP TABLE IF EXISTS media_types CASCADE;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    	name_types VARCHAR(255), 
	archiv_types BOOL not null default false
);


-- 7. Медиа файлы 
DROP TABLE IF EXISTS media CASCADE;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    	type_id BIGINT NOT NULL,
  	filename VARCHAR(255),
    	body text,
	metadata JSON,
    	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    	updated_at timestamp DEFAULT now(),
FOREIGN KEY (type_id) REFERENCES media_types(id)
);
-- UPDATE media SET body = 'меняем текст', updated_at = DEFAULT WHERE id = 1; -- время и дата обнавляются!


-- 7. Регионы РФ (только Москва и область)
DROP TABLE IF EXISTS geo_regions CASCADE;
CREATE TABLE geo_regions (
 	 id SERIAL PRIMARY KEY,
  	 district_id smallint not null default 0,
 	 name_regions varchar(255) NOT NULL,
  	 archiv_region BOOL not null default false
 );

-- 8. Города
DROP TABLE IF EXISTS geo_city CASCADE;
CREATE TABLE geo_city (
  	id SERIAL PRIMARY KEY,
  	region_id smallint NOT NULL DEFAULT '0',
  	name_city varchar(255) NOT NULL,
  	archiv_city BOOL not null default false,
FOREIGN KEY (region_id) REFERENCES geo_regions(id)
);

-- 9. Справочник округов
DROP TABLE IF EXISTS district CASCADE;
CREATE TABLE district (
	id SERIAL PRIMARY KEY,
	name_city SMALLINT DEFAULT '0',
	name_district VARCHAR (255) unique,
	shortname_district VARCHAR(20) DEFAULT null UNIQUE,
	archiv_district BOOL not null default false,
FOREIGN KEY (name_city) REFERENCES geo_city(id)
);

-- 10. Справочник районов Москвы
DROP TABLE IF EXISTS areadis CASCADE;
CREATE TABLE areadis (
	id SERIAL PRIMARY KEY,
	name_area VARCHAR (255) UNIQUE,
	short_name varchar(100) DEFAULT null,
	district_id INTEGER NOT NULL,
FOREIGN key (district_id) references district (id)
);

-- 11. Адресса (необходимо реализация через IP yandex) по возможности с привязкой: районов, округов, городов, регионов.
-- (сохраняем все в БД)

-- 11.1 Координаты мест проведения 
DROP TABLE IF EXISTS coordinat CASCADE;
CREATE TABLE coordinat (
	id SERIAL PRIMARY KEY,
	-- coordinate POINT(x,y)
	latitude FLOAT(8),
	longitude FLOAT(8)
);

-- 12. Справочник типы сооружений(спортивные зоны)
DROP TABLE IF EXISTS object_area_type CASCADE;
CREATE TABLE object_area_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	minimum_players SMALLINT not null default 0,
	maximum_players SMALLINT not null default 0,
	archiv_type BOOL not null default false
);

-- 13. Справочник объектов (территорий)
DROP TABLE IF EXISTS facillity_type CASCADE;
CREATE TABLE facillity_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	archiv_type BOOL not null default false
);

-- 14. Информация об объекте 
DROP TABLE IF EXISTS facillity CASCADE;
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
	district_id INTEGER, -- справочник от округов
	areadis_id INTEGER, -- справочник от районов
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    	updated_at timestamp DEFAULT now(),
	archiv_facillity BOOL not null default false,
FOREIGN KEY (type_id) REFERENCES facillity_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (geo_regions_id) REFERENCES geo_regions(id),
FOREIGN KEY (firm_id) REFERENCES firm(id),
FOREIGN KEY (geo_city_id) REFERENCES geo_city(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id),
FOREIGN KEY (areadis_id) REFERENCES areadis(id),
FOREIGN KEY (district_id) REFERENCES district(id)
);


-- 15. Информация об сооружениях (спортивные зоны) (много записей нужны будут индексы) <== ИНДЕКСЫ!!!
DROP TABLE IF EXISTS object_area CASCADE;
CREATE TABLE object_area (
	id SERIAL PRIMARY KEY,
	type_id BIGINT NOT NULL, -- справочник типов объекта
	name_object_area VARCHAR (255),
	short_name_area VARCHAR (50),
	media_id BIGINT,
	coordinate_id BIGINT NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
   	updated_at timestamp DEFAULT now(),
	archiv_object_area BOOL not null default false,
FOREIGN KEY (type_id) REFERENCES object_area_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id)
);


 -- 16. Пользователи 
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    	nickname VARCHAR(50),
	firstname VARCHAR(50),
    	lastname VARCHAR(50),
    	email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNIQUE,
	archiv_users BOOL not null default false
);



-- 17. Профиль пользователей 
DROP TABLE IF EXISTS profiles_users;
CREATE TABLE profiles_users (
	user_id SERIAL NOT NULL UNIQUE, 
    	gender CHAR(1), -- м или ж
    	birthday DATE,
	photo_id BIGINT,
    	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    	updated_at timestamp DEFAULT now(),
	geo_regions_id BIGINT,
	geo_city_id BIGINT,
    	district_id BIGINT, -- округ проживания
    	areadis_id BIGINT, -- район проживания
FOREIGN KEY (user_id) REFERENCES users(id),     
FOREIGN KEY (district_id) REFERENCES district(id), 
FOREIGN KEY (areadis_id) REFERENCES areadis(id)
);

-- 18. Профиль юр. лиц 
DROP TABLE IF EXISTS firm CASCADE;
CREATE TABLE Firm (
	id SERIAL PRIMARY KEY,
	name_firm VARCHAR (25),
	email VARCHAR (120) UNIQUE,
	phone varchar(20),
	ogrn BIGINT NOT NULL, -- проверка ОГРНов как вариант - http://www.kholenkov.ru/data-validation/ogrn/
	archiv_Firm BOOL not null default false
);

-- 19. Сообщения
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT NOT NULL,
    	to_user_id BIGINT NOT NULL,
   	body TEXT,
   	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
   	updated_at timestamp DEFAULT now(),
FOREIGN KEY (from_user_id) REFERENCES users(id),
FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- 20. Дружба +
DROP TABLE IF EXISTS friend_requests;
-- создаем выбор перечеслений для таблицы
CREATE TYPE mood AS ENUM ('requested', 'approved', 'unfriended', 'declined');

CREATE TABLE friend_requests (
	initiator_user_id BIGINT NOT NULL,
    	target_user_id BIGINT NOT NULL,
    	status mood,
   	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    	updated_at timestamp DEFAULT now(),
PRIMARY KEY (initiator_user_id, target_user_id),
FOREIGN KEY (initiator_user_id) REFERENCES users(id),
FOREIGN KEY (target_user_id) REFERENCES users(id),
CHECK (initiator_user_id <> target_user_id)
);

-- 21. Сообщества по интересам (нужно дальше развивать)
DROP TABLE IF EXISTS communities CASCADE;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	admin_user_id BIGINT NOT NULL,
FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 22. Лайки
DROP TABLE IF EXISTS likes CASCADE;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
    	user_id BIGINT NOT NULL,
    	media_id BIGINT NOT NULL,
    	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)
);

-- 23. Основная таблица мероприятий заполняемая пользователими

DROP TABLE IF EXISTS competition CASCADE;
CREATE TABLE competition (
	id SERIAL PRIMARY KEY,
	competition_rank_id INTEGER NOT NULL,
	competition_status_id BIGINT,
	name_competition VARCHAR (255) NOT NULL,
	short_name VARCHAR (50),
	sport_id BIGINT NOT NULL,
	date_start DATE NOT NULL,
	time_start TIME,
	date_finish DATE NOT NULL,
	time_finish TIME,
	-- media_id BIGINT,
	geo_regions_id BIGINT NOT NULL,
	geo_city_id BIGINT NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    	updated_at timestamp DEFAULT now(),
	archiv_competition BOOL not null default false,
	archiv_comment VARCHAR (25),
FOREIGN KEY (competition_rank_id) REFERENCES competition_rank(id),
FOREIGN KEY (competition_status_id) REFERENCES competition_status(id),
FOREIGN KEY (sport_id) REFERENCES sport(id)
-- FOREIGN KEY (media_id) REFERENCES media(id),
-- FOREIGN KEY (likes_id) REFERENCES likes(id)
);


