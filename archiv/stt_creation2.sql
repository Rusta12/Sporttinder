/* База данных Спорттиндер создана для публикации 
 * пользователями событий для занятием физической 
 * культурой и спортом а также в развлекательных целях. 
 * Расширенная версия предусматривает спортивную социальную сеть. 
 * БД содержит в себе:
 * + Категория мероприятия 
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
	('Идет игра')
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

-- 6. Регионы РФ (только Москва и область)
DROP TABLE IF EXISTS geo_regions;
CREATE TABLE geo_regions (
  id SERIAL PRIMARY KEY,
  district_id int(11) UNSIGNED not null default 0,
  name_regions varchar(255) NOT NULL
 );

-- 7. Города
DROP TABLE IF NOT EXISTS geo_city;
CREATE TABLE geo_city (
  id_city int(11) UNSIGNED NOT NULL PRIMARY KEY,
  region_id int(11) UNSIGNED NOT NULL DEFAULT '0',
  name_city varchar(255) NOT NULL,
);

-- 8. Справочник округов
DROP TABLE IF EXISTS district;
CREATE TABLE district (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_district VARCHAR (255) unique,
	shortname_district varchar(20) DEFAULT null UNIQUE
);

-- 9. Справочник районов Москвы
DROP TABLE IF EXISTS areadis;
CREATE TABLE areadis (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_area VARCHAR (255) UNIQUE,
	shortName_area varchar(100) DEFAULT null,
	district_areaid BIGINT not NULL,
	FOREIGN key (district_areaid) references district (id_district)
);

-- 10. Адресса (необходимо реализация через IP yandex) по возможности с привязкой: районов, округов, городов, регионов.

-- 11. Справочник типов сооружений
DROP TABLE IF EXISTS facillity_type;
CREATE TABLE facillity_type (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	archiv_type BIT not null default 0
);


-- 12. Категория медиа файлов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), 
	archiv BIT not null default 0
);

-- 13. Медиа файлы 
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    facillity_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

FOREIGN KEY (media_type_id) REFERENCES media_types(id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (facillity_id) REFERENCES facillity(id)
);


-- 14. Информация по сооружениям (много записей нужны будут индексы)
DROP TABLE IF EXISTS facillity;
CREATE TABLE facillity (
	id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	type_facillity BIGINT NOT NULL, -- справочник типов объекта
	name_facillity VARCHAR (255),
	adress VARCHAR (255) UNIQUE,
	foto_id BIGINT NOT NULL,
	coordinate BIGINT NOT NULL,
	-- District_Facillity BIGINT NOT NULL, -- справочник от округов
	-- Area_Facillity BIGINT NOT NULL, -- справочник от районов
	archiv_facillity BIT not null default 0,
FOREIGN KEY (type_facillity) REFERENCES facillity_type(id),
FOREIGN KEY (foto_id) REFERENCES media(id),
FOREIGN KEY (coordinate) REFERENCES coordinates(id)
-- FOREIGN KEY (Area_Facillity) REFERENCES Area(Id_Area),
-- FOREIGN KEY (District_Facillity) REFERENCES District(Id_District)
);

-- 14.1 Координаты объектов
DROP TABLE IF EXISTS coordinates;
CREATE TABLE coordinates (
	id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	-- coordinate POINT(x,y)
	latitude FLOAT(8),
	longitude FLOAT(8)
	facillity_cor BIGINT NOT NULL,
FOREIGN KEY (facillity_cor) REFERENCES facillity(id)
)


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
	ogrn BIGINT, -- проверка ОГРНов http://www.kholenkov.ru/data-validation/ogrn/
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

-- 20. Сообщества 
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


-- 22. Список мероприятий


