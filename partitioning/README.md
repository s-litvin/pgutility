
	1. ������� ������� ������ ������� (base_models). ������ � ��� ����� ��������� �� ������ � ������.
	2. ������� �������, ����������� �������, � ��������� ������� ������� �� �������:
		1. create table models1 (CHECK(id%10=1)) inherits (base_models);
		2. create table models2 (CHECK(id%10=2)) inherits (base_models);
		3. create table models3 (CHECK(id%10=3)) inherits (base_models);
		4. create table models4 (CHECK(id%10=4)) inherits (base_models);
		5. create table models5 (CHECK(id%10=5)) inherits (base_models);
		6. create table models6 (CHECK(id%10=6)) inherits (base_models);
		7. create table models7 (CHECK(id%10=7)) inherits (base_models);
		8. create table models8 (CHECK(id%10=8)) inherits (base_models);
		9. create table models9 (CHECK(id%10=9)) inherits (base_models);
		10. create table models0 (CHECK(id%10=0)) inherits (base_models);


	3. �������� ������� ������ �������� ��� ������� ������:


CREATE OR REPLACE FUNCTION models_insert_trigger()
returns trigger as $$
DECLARE
    v_parition_name text;
BEGIN
    v_parition_name := format( 'models%s', NEW.id % 10 );
    execute 'INSERT INTO ' || v_parition_name || ' VALUES ( ($1).* )' USING NEW;
    return NULL;
END;
$$ language plpgsql;

     4. ������� ������� ��� ������� ������� base_models:
               CREATE TRIGGER insert_models_trigger
  BEFORE INSERT ON base_models
  FOR EACH ROW EXECUTE PROCEDURE models_insert_trigger();

     5. ������� ������ � ������� �������:
               INSERT INTO base_models (title) VALUES ('some title')

     6. ������� ������ �� ������� ������� (������ ���� ������):
               SELECT * FROM ONLY base_models LIMIT 10;

     7. ��� �������������� ������� �� ������ �������� ����� � ������ ������� �������� ����� ������� ���������� id:
               select * from base_models where id=123 and id%10=123%10;
