--========================================================================================--
-- —в€зи многие ко многим - дисциплины к меропри€тию 
DROP TABLE IF EXISTS discipline_to_competition;
CREATE TABLE discipline_to_competition (
	id SERIAL PRIMARY KEY,
	discipline_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_discipline_id" FOREIGN KEY (discipline_id) REFERENCES discipline(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_discipline_to_competition_competition_id_discipline_id"
  ON "discipline_to_competition"
  USING btree
  ("discipline_id", "competition_id");
--========================================================================================--
 
 -- —в€зи многие ко многим - возвростные группы к меропри€тию
DROP TABLE IF EXISTS age_group_to_competition;
CREATE TABLE age_group_to_competition (
	id SERIAL PRIMARY KEY,
	age_group_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_age_group_id" FOREIGN KEY (age_group_id) REFERENCES age_group(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_age_group_to_competition_competition_id_age_group_id"
  ON "age_group_to_competition"
  USING btree
  ("age_group_id", "competition_id");
 --========================================================================================--
 
 -- —в€зи многие ко многим - организаторы к меропри€тию
DROP TABLE IF EXISTS firm_to_competition;
CREATE TABLE firm_to_competition (
	id SERIAL PRIMARY KEY,
	firm_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_firm_id" FOREIGN KEY (firm_id) REFERENCES firm(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_firm_to_competition_competition_id_firm_id"
  ON "firm_to_competition"
  USING btree
  ("firm_id", "competition_id");
--========================================================================================--

 -- —в€зи многие ко многим - сообщества к меропри€тию
DROP TABLE IF EXISTS communities_to_competition;
CREATE TABLE communities_to_competition (
	id SERIAL PRIMARY KEY,
	communities_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_communities_id" FOREIGN KEY (communities_id) REFERENCES communities(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_communities_to_competition_competition_id_communities_id"
  ON "communities_to_competition"
  USING btree
  ("communities_id", "competition_id");
 --========================================================================================--
 
  -- —в€зи многие ко многим - сооружени€ к объектам
DROP TABLE IF EXISTS object_area_to_facillity;
CREATE TABLE object_area_to_facillity (
	id SERIAL PRIMARY KEY,
	object_area_id BIGINT NOT NULL,
	facillity_id BIGINT NOT NULL,
CONSTRAINT "FK_object_area_id" FOREIGN KEY (object_area_id) REFERENCES object_area(id),
CONSTRAINT "FK_facillity_id" FOREIGN KEY (facillity_id) REFERENCES facillity(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_object_area_to_facillity_facillity_id_object_area_id"
  ON "object_area_to_facillity"
  USING btree
  ("object_area_id", "facillity_id");
--========================================================================================--
 
  -- —в€зи многие ко многим - сооружени€ к меропри€ти€м
DROP TABLE IF EXISTS object_area_to_competition;
CREATE TABLE object_area_to_competition (
	id SERIAL PRIMARY KEY,
	object_area_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_object_area_id" FOREIGN KEY (object_area_id) REFERENCES object_area(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_object_area_to_competition_competition_id_object_area_id"
  ON "object_area_to_competition"
  USING btree
  ("object_area_id", "competition_id");
--========================================================================================--
 
 -- —в€зи многие ко многим - объекты к меропри€ти€м
DROP TABLE IF EXISTS facillity_to_competition;
CREATE TABLE facillity_to_competition (
	id SERIAL PRIMARY KEY,
	facillity_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_facillity_id" FOREIGN KEY (facillity_id) REFERENCES facillity(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_facillity_to_competition_competition_id_facillity_id"
  ON "facillity_to_competition"
  USING btree
  ("facillity_id", "competition_id");
 --========================================================================================--
 
 -- —в€зи многие ко многим - организаторы к меропри€тию
DROP TABLE IF EXISTS firm_to_competition;
CREATE TABLE firm_to_competition (
	id SERIAL PRIMARY KEY,
	firm_id BIGINT NOT NULL,
	competition_id BIGINT NOT NULL,
CONSTRAINT "FK_firm_id" FOREIGN KEY (firm_id) REFERENCES firm(id),
CONSTRAINT "FK_competition_id" FOREIGN KEY (competition_id) REFERENCES competition(id)
);
-- ƒобовл€ем уникальный индекс, что бы избежать повторений
CREATE UNIQUE INDEX "UI_firm_to_competition_competition_id_firm_id"
  ON "firm_to_competition"
  USING btree
  ("firm_id", "competition_id");
--========================================================================================--