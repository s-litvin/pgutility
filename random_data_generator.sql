INSERT INTO parts (title, code, id_category)
SELECT p.title, p.code, p.id_category FROM (
    SELECT generate_series(1,100) AS num,
           upper(substring(md5(random()::text) from 0 for 10)) AS code,
           substring(md5(random()::text) from 0 for 15) AS title,
           random()*10 * random()*10 * random()*2 AS id_category
    ) p
ON CONFLICT DO NOTHING;
