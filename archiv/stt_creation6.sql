/* ���� ������ ����������� ������� ��� ���������� 
 * �������������� ������� ��� �������� ���������� 
 * ��������� � �������, � ����� � ��������������� �����. 
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
 * ! ������� (���������� ���������� ����� IP yandex)
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
	id SERIAL PRIMARY KEY,
	name_competition VARCHAR(50) UNIQUE,
	short_name VARCHAR(25),
	archiv_rank BOOL not null default false 
);
-- COMMENT ON COLUMN competition_rank.archiv_rank IS '������ ��������';
INSERT INTO competition_rank (name_competition, short_name) VALUES
	('������ �� ���� ��������', '� ����'),
	('���������� �� �����', '� ����'),
	('������ � ���� ��������', '���� � �����')
;

-- DELETE FROM competition_rank WHERE id = 1;

-- 2 ���������� ���������� �����
DROP TABLE IF EXISTS age_group;
CREATE TABLE age_group(
	id SERIAL PRIMARY KEY,
	name_age_group VARCHAR(25),
	minage smallint DEFAULT null,
	maxage smallint DEFAULT null,
	archiv_age BOOL not null default false
);

INSERT INTO age_group (name_age_group, minage, maxage) VALUES
	('�����', '17', '14'),
	('�������', '17', '14'),
	('��������', '15', '10'),
	('�������', '15', '10')
;


-- 3 ���������� ������� �����������
DROP TABLE IF EXISTS competition_status;
CREATE TABLE competition_status (
	id SERIAL PRIMARY KEY,
	name_competition_status VARCHAR(50) UNIQUE,
	archiv_status BOOL not null default false
);

INSERT INTO competition_status (name_competition_status) VALUES
	('���� �����'),
	('������'),
	('���� ����'),
	('������')
;

-- 4 ���������� ����� ������
DROP TABLE IF EXISTS sport;
CREATE TABLE sport (
	id SERIAL PRIMARY KEY,
	name_sport VARCHAR(50) NOT NULL UNIQUE,
	code_name_sport VARCHAR(25),
	razdel_sport VARCHAR(25),
	archiv_sport BOOL not null default false
);

INSERT INTO sport (name_sport, code_name_sport, razdel_sport) VALUES
	('������', '0010002611�', '��������������'),
	('���������', '0140002611�', '��������������'),
	('��������', '0120002611�', '��������������')
;
-- DELETE FROM sport WHERE id = 1;

 -- 5. ���������� (����������� ������)
DROP TABLE IF EXISTS discipline;
CREATE TABLE discipline (
	id SERIAL PRIMARY KEY,
	name_discipline VARCHAR(255) UNIQUE,
	code_name_sport VARCHAR(25),
	sport_name INTEGER,
	archiv_sport BOOL not null default false,
FOREIGN KEY (sport_name) REFERENCES sport(id)	
);

INSERT INTO discipline (name_discipline, code_name_sport, sport_name) VALUES
	('������', '0010012611�', '1'),
	('����-������ (������)', '0010022811�', '1'),
	('��������� 3�3', '0140022611�', '2')
;
-- DELETE FROM discipline WHERE id = 2;

 -- 12. ��������� ����� ������
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name_types VARCHAR(255), 
	archiv_types BOOL not null default false
);

INSERT INTO media_types (name_types) VALUES
('����'),
('�����'),
('��������')
;

-- 13. ����� ����� 
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
INSERT INTO media (type_id, filename, body) VALUES
(1, 'www.image.com\sport.bmp', '��� ����'),
(2, 'youtube.com', '�����'),
(3, '��������� �����������', '������� ����')
;
-- UPDATE media SET body = '������ �����', updated_at = DEFAULT WHERE id = 1; -- ����� � ���� �����������!


-- 6. ������� �� (������ ������ � �������)
DROP TABLE IF EXISTS geo_regions;
CREATE TABLE geo_regions (
  id SERIAL PRIMARY KEY,
  district_id smallint not null default 0,
  name_regions varchar(255) NOT NULL,
  archiv_region BOOL not null default false
 );

INSERT INTO geo_regions (id, district_id, name_regions) VALUES
	(42, 2, '������'),
	(43, 2, '���������� �������'),
	(59, 4, '�����-���������')
;


-- 7. ������
DROP TABLE IF EXISTS geo_city;
CREATE TABLE geo_city (
  id SERIAL PRIMARY KEY,
  region_id smallint NOT NULL DEFAULT '0',
  name_city varchar(255) NOT NULL,
  archiv_city BOOL not null default false,
FOREIGN KEY (region_id) REFERENCES geo_regions(id)
);

INSERT INTO geo_city (id, region_id, name_city) VALUES
	(365, 42, '������'),
	(191, 42, '������ (������)'),
	(197, 42, '�������� (������)')
;

-- 8. ���������� �������
DROP TABLE IF EXISTS district;
CREATE TABLE district (
	id SERIAL PRIMARY KEY,
	name_city SMALLINT DEFAULT '0',
	name_district VARCHAR (255) unique,
	shortname_district VARCHAR(20) DEFAULT null UNIQUE,
	archiv_district BOOL not null default false,
FOREIGN KEY (name_city) REFERENCES geo_city(id)
);

INSERT INTO district (name_city, name_district, shortname_district) VALUES 
(365, '����� ���������������� �����','���')
,(365, '���-�������� ���������������� �����','����')
,(365, '���-��������� ���������������� �����','����')
,(365, '����������� ���������������� �����','���')
,(191, '�������� ���������������� �����','���')
,(365, '������-�������� ���������������� �����','����')
,(365, '������-��������� ���������������� �����','����')
,(365, '�������� ���������������� �����','���')
,(197, '�������������� ���������������� �����','����')
,(365, '�������������� ���������������� �����','�����')
,(365, '�������� ���������������� �����','���')
,(365, '��������� ���������������� �����','���')
;

-- 9. ���������� ������� ������
DROP TABLE IF EXISTS areadis;
CREATE TABLE areadis (
	id SERIAL PRIMARY KEY,
	name_area VARCHAR (255) UNIQUE,
	short_name varchar(100) DEFAULT null,
	district_id BOOL not null default false,
FOREIGN key (district_id) references district (id)
);

INSERT INTO areadis (name_area, short_name, district_id) VALUES 
('������������� �����','�������������',2)
,('������������ �����','������������',7)
,('������������ �����','������������',7)
,('����� �����','�����',4)
,('����� ��������','��������',8)
;

-- 10. ������� (���������� ���������� ����� IP yandex) �� ����������� � ���������: �������, �������, �������, ��������.
-- (��������� ��� � ��)

-- 10.1 ���������� ���� ���������� 
DROP TABLE IF EXISTS coordinat;
CREATE TABLE coordinat (
	id SERIAL PRIMARY KEY,
	-- coordinate POINT(x,y)
	latitude FLOAT(8),
	longitude FLOAT(8)
);

-- 11. ���������� ���� ����������(���������� ����)
DROP TABLE IF EXISTS object_area_type;
CREATE TABLE object_area_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	minimum_players SMALLINT not null default 0,
	maximum_players SMALLINT not null default 0,
	archiv_type BOOL not null default false
);
INSERT INTO object_area_type (name_type) VALUES 
	('������������� ��������')
	,('������������� ��������')
	,('���������� ��������')
	,('������������� ���������� ���')
;

-- 12. ���������� �������� (����������)
DROP TABLE IF EXISTS facillity_type;
CREATE TABLE facillity_type (
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255) unique,
	archiv_type BOOL not null default false
);
INSERT INTO facillity_type (name_type) VALUES 
	 ('����')
	,('�������� ����������')
	,('���������� ����')
	,('�������')
;

-- 12. ���������� �� ������� (����� ������� ����� ����� �������) <== �������!!!
DROP TABLE IF EXISTS facillity;
CREATE TABLE facillity (
	id SERIAL PRIMARY KEY,
	type_id INTEGER NOT NULL, -- ���������� ����� �������
	name_facillity VARCHAR (255),
	short_name_facillity VARCHAR (50),
	adress VARCHAR (255) UNIQUE, -- �����, ��� ���� ���� �� ip ������ => ������� 10
	firm_id BIGINT,
	media_id BIGINT,
	coordinate_id BIGINT NOT NULL,
	geo_regions_id BIGINT NOT NULL,
	geo_city_id BIGINT NOT NULL,
	district_facillity INTEGER, -- ���������� �� �������
	areadis_facillity INTEGER, -- ���������� �� �������
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
	archiv_facillity BOOL not null default false,
FOREIGN KEY (type_id) REFERENCES facillity_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (geo_regions_id) REFERENCES geo_regions(id),
FOREIGN KEY (geo_city_id) REFERENCES geo_city(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id),
FOREIGN KEY (areadis_facillity) REFERENCES areadis(id),
FOREIGN KEY (district_facillity) REFERENCES district(id)
);
INSERT INTO facillity (type_id, name_facillity, adress) VALUES 
('������ �������� ���������','�������, 2-� ������� 20�',36,3)
,('��������� ����� ����������','2-� ��. ��������� 19',48,3)
,('���������� �������� ���������������� ����������','������� ������������� ��. 1 ',58,4)
;

--13. ���������� �� ����������� (���������� ����) (����� ������� ����� ����� �������) <== �������!!!
DROP TABLE IF EXISTS object_area;
CREATE TABLE object_area (
	id SERIAL PRIMARY KEY,
	type_id BIGINT NOT NULL, -- ���������� ����� �������
	name_object_area VARCHAR (255),
	short_name_area VARCHAR (50),
	facillity_id BIGINT NOT NULL,
	media_id BIGINT,
	coordinate_id BIGINT NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
	archiv_object_area BOOL not null default false,
FOREIGN KEY (type_id) REFERENCES object_area_type(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (coordinate_id) REFERENCES coordinat(id),
FOREIGN KEY (facillity_id) REFERENCES facillity(id)
);


 -- 15. ������������ (����� ������� ����� ����� �������)
DROP TABLE IF EXISTS users;
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



-- 16. ������� ������������� +
DROP TABLE IF EXISTS profiles_users;
CREATE TABLE profiles_users (
	user_id SERIAL NOT NULL UNIQUE, -- id �����
    gender CHAR(1), -- � ��� �
    birthday DATE,
	photo_id BIGINT,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
    hometown BIGINT NOT NULL, -- ����� ����������
    district BIGINT, -- ����� ����������
    areadis BIGINT, -- ����� ����������
FOREIGN KEY (district) REFERENCES district(id), 
FOREIGN KEY (areadis) REFERENCES areadis(id)
);

-- 17. ������� ��. ��� +
DROP TABLE IF EXISTS firm;
CREATE TABLE Firm (
	id SERIAL PRIMARY KEY,
	name_firm VARCHAR (25),
	email VARCHAR (120) UNIQUE,
	phone varchar(20),
	ogrn BIGINT, -- �������� ������ ��� ������� - http://www.kholenkov.ru/data-validation/ogrn/
	archiv_Firm BOOL not null default false
);

-- 18. ���������
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

-- 19. ������ +
DROP TABLE IF EXISTS friend_requests;
-- ������� ����� ������������ ��� �������
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

-- 20. ���������� �� ��������� (����� ������ ���������)
DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	admin_user_id BIGINT NOT NULL,
FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 21. �����
DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    media_id BIGINT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)
);

-- 22. �������� ������� ����������� ����������� ��������������

DROP TABLE IF EXISTS competition;
CREATE TABLE competition (
	id SERIAL PRIMARY KEY,
	competition_rank_id INTEGER NOT NULL,
	competition_status_id BIGINT,
	name_competition VARCHAR (255) NOT NULL,
	short_name VARCHAR (50),
	sport_id BIGINT NOT NULL,
	discipline_id BIGINT,
	age_group_id BIGINT,
	media_id BIGINT,
	geo_regions_id BIGINT NOT NULL,
	geo_city_id BIGINT NOT NULL,
	facillity_id BIGINT UNIQUE NOT NULL, 
	firm_id BIGINT,
	communities_id BIGINT,
	likes_id BIGINT,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT now(),
	archiv_facillity BOOL not null default false,
FOREIGN KEY (competition_rank_id) REFERENCES competition_rank(id),
FOREIGN KEY (competition_status_id) REFERENCES competition_status(id),
FOREIGN KEY (sport_id) REFERENCES sport(id),
FOREIGN KEY (discipline_id) REFERENCES discipline(id),
FOREIGN KEY (age_group_id) REFERENCES age_group(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (facillity_id) REFERENCES facillity(id),
FOREIGN KEY (firm_id) REFERENCES firm(id),
FOREIGN KEY (communities_id) REFERENCES communities(id),
FOREIGN KEY (likes_id) REFERENCES likes(id)
);


