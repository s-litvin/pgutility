CREATE TABLE public.audit
(
  id integer NOT NULL DEFAULT nextval('archive_id_seq'::regclass),
  table_name character varying,
  id_row bigint,
  field_name character varying,
  old_value character varying,
  new_value character varying,
  crtime timestamp with time zone DEFAULT now(),
  CONSTRAINT archive_pkey PRIMARY KEY (id)
);


CREATE OR REPLACE FUNCTION public.before_update()
  RETURNS trigger AS
$BODY$DECLARE
row record;
tmp record;
BEGIN
    FOR row IN SELECT json_object_keys(s2.js) AS key FROM (SELECT row_to_json(NEW.*) AS js) AS s2
        LOOP
            EXECUTE 'SELECT $1.'|| row.key ||'<>$2.'|| row.key ||' as not_equals;' INTO tmp USING NEW, OLD;
            IF (tmp.not_equals) THEN
                EXECUTE 'INSERT INTO archive (table_name, id_row, field_name, old_value, new_value) 
                         VALUES (''' || TG_RELNAME ||''', $1.id, '''||row.key||''', $2.'||row.key||', $1.'||row.key||');' USING NEW, OLD;
            END IF;
        END LOOP;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER before_update_movies
  BEFORE UPDATE
  ON public.sometable
  FOR EACH ROW
  EXECUTE PROCEDURE public.before_update();