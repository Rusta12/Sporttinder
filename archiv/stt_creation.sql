/* ���� ������ ����������� ������� ��� ���������� 
 * �������������� ������� ��� �������� ���������� 
 * ��������� � ������� � ����� � ��������������� �����. 
 * ����������� ������ ��������������� ���������� ���������� ����. 
 * �� �������� � ����:
 * + ��������� ����������� 
 * + ���������� ������ 
 * + ������ ����������� 
 * + ���� ������
 * + ���������� (����������� ������)
 * + ������� �� (������ ������ � �������)
 * + ������
 * + ������
 * + ������
 * - ������� (���������� ���������� ����� IP yandex)
 * + ��� ����������� ����������
 * + ��� ����� ������ (�� ������ ������)
 * + ���������� 
 * + ����������� ����������
 * + ������������
 * + �������
 * + ������� ����������� ��. ��� (����������� ������)
 * + ��������� (����������� ������)
 * + ������ (����������� ������)
 * + ���������� (����������� ������)
 * + ����� (����������� ������)
 * - �������� �����������
 */

select * from pg_database;

DROP DATABASE IF EXISTS sporttinder_1;
CREATE DATABASE sporttinder_1;


-- 1  ���������� ��������� �����������
DROP TABLE IF EXISTS competition_rank;
CREATE TABLE Competition_Rank (
	Id_Rank BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Competition VARCHAR(255) UNIQUE,
	Short_Name varchar(25),
	Archiv_Rank BIT not null default 0 
);

-- 2 ���������� ���������� �����
DROP TABLE IF EXISTS age_group;
CREATE TABLE Age_Group(
	Id_AgeGroup BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Age_Group VARCHAR(25),
	MinAge int(11) DEFAULT null,
	MaxAge int(11) DEFAULT null,
	Archiv_Age BIT not null default 0
);

-- 3 ���������� ������� �����������
DROP TABLE IF EXISTS competition_status;
CREATE TABLE Competition_Status (
	Id_Competition_Status BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Competition_Status VARCHAR(50) UNIQUE,
	Archiv_Status BIT not null default 0
);

-- 4 ���������� ����� ������
DROP TABLE IF EXISTS sport;
CREATE TABLE Sport (
	Id_Name_Sport BIGINT NOT NULL AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Sport VARCHAR(255) unique,
	Code_Name_Sport VARCHAR(25),
	Razdel_sport NOT NULL,
	Archiv_Sport BIT not null default 0 
);

 -- 5. ���������� (����������� ������)
DROP TABLE IF EXISTS discipline;
CREATE TABLE Discipline (
	Id_Name_Discipline BIGINT NOT NULL AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Discipline VARCHAR(255) unique,
	Code_Name_Sport VARCHAR(25),
	Sport_name BIGINT,
	Archiv_Sport BIT not null default 0,
FOREIGN KEY (Sport_name) REFERENCES Sport(Id_Name_Sport)	
);

-- 6. ������� �� (������ ������ � �������)
DROP TABLE IF EXISTS geo_regions;
CREATE TABLE geo_regions (
  id_regions int(11) UNSIGNED NOT NULL PRIMARY KEY,
  district_id int(11) UNSIGNED NOT NULL DEFAULT '0',
  name_regions varchar(255) NOT NULL
 );

-- 7. ������
DROP TABLE IF NOT EXISTS geo_city;
CREATE TABLE geo_city (
  id_city int(11) UNSIGNED NOT NULL PRIMARY KEY,
  region_id int(11) UNSIGNED NOT NULL DEFAULT '0',
  name_city varchar(255) NOT NULL,
);

-- 8. ���������� �������
DROP TABLE IF EXISTS district;
CREATE TABLE district (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_district VARCHAR (255) unique,
	shortname_district varchar(20) DEFAULT null UNIQUE
);

-- 9. ���������� ������� ������
DROP TABLE IF EXISTS areadis;
CREATE TABLE areadis (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_area VARCHAR (255) UNIQUE,
	shortName_area varchar(100) DEFAULT null,
	district_areaid BIGINT not NULL,
	FOREIGN key (district_areaid) references district (id_district)
);

-- 10. ������� (���������� ���������� ����� IP yandex) �� ����������� � ���������: �������, �������, �������, ��������.

-- 11. ���������� ����� ����������
DROP TABLE IF EXISTS facillity_type;
CREATE TABLE facillity_type (
	id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	archiv_type BIT not null default 0
);


-- 12. ��������� ����� ������
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), 
	archiv BIT not null default 0
);

-- 13. ����� ����� 
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


-- 14. ���������� �� ����������� (����� ������� ����� ����� �������)
DROP TABLE IF EXISTS facillity;
CREATE TABLE facillity (
	id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	type_facillity BIGINT NOT NULL, -- ���������� ����� �������
	name_facillity VARCHAR (255),
	adress VARCHAR (255) UNIQUE,
	foto_id BIGINT NOT NULL,
	coordinate BIGINT NOT NULL,
	-- District_Facillity BIGINT NOT NULL, -- ���������� �� �������
	-- Area_Facillity BIGINT NOT NULL, -- ���������� �� �������
	archiv_facillity BIT not null default 0,
FOREIGN KEY (type_facillity) REFERENCES facillity_type(id),
FOREIGN KEY (foto_id) REFERENCES media(id),
FOREIGN KEY (coordinate) REFERENCES coordinates(id)
-- FOREIGN KEY (Area_Facillity) REFERENCES Area(Id_Area),
-- FOREIGN KEY (District_Facillity) REFERENCES District(Id_District)
);

-- 14.1 ���������� ��������
DROP TABLE IF EXISTS coordinates;
CREATE TABLE coordinates (
	id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	-- coordinate POINT(x,y)
	latitude FLOAT(8),
	longitude FLOAT(8)
	facillity_cor BIGINT NOT NULL,
FOREIGN KEY (facillity_cor) REFERENCES facillity(id)
)


 -- 15. ������������ (����� ������� ����� ����� �������)
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

-- 16. ������� �������������
DROP TABLE IF EXISTS profiles_users;
CREATE TABLE profiles_users (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1), -- � ��� �
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown int(11), -- ����� ����������
    district BIGINT, -- ����� ����������
    areadis BIGINT, -- ����� ����������
FOREIGN KEY (district) REFERENCES district(id), 
FOREIGN KEY (areadis) REFERENCES areadis(id)

-- 17. ������� ��. ���
DROP TABLE IF EXISTS Firm;
CREATE TABLE Firm (
	Id_Firm BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	Name_Firm VARCHAR (25),
	Email VARCHAR (120) UNIQUE,
	Phone varchar(20),
	ogrn BIGINT, -- �������� ������ http://www.kholenkov.ru/data-validation/ogrn/
	Archiv_Firm BIT not null default 0
);
-- 18. ���������
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

-- 19. ������
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

-- 20. ���������� 
DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 21. �����
DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    
    created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)


-- 22. ������ �����������


