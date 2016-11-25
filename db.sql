DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY key,
    text TEXT NOT NULL
);

INSERT INTO statement (text) VALUES
('__ROOT__') -- root for all
,('Kouření by mělo být v hospodách zakázáno.') -- 2
,('Majitel by si měl sám rozhodnout.') -- 3
,('Omezilo by to kouření celkově.') -- 4
,('Hromadná doprava by měla být zdarma.') -- 5
,('Ulevilo by to silnicím.'); -- 6



DROP TABLE IF EXISTS statement_closure;
CREATE TABLE statement_closure (
    ancestor INTEGER,
    descendant INTEGER,
    depth INTEGER
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
(1, 1, 0)
,(2, 2, 0)
,(1, 2, 1)
,(3, 3, 0)
,(1, 3, 2)
,(2, 3, 1)
,(4, 4, 0)
,(2, 4, 1)
,(1, 4, 2)
,(5, 5, 0)
,(1, 5, 1)
,(6, 6, 0)
,(5, 6, 1)
,(2, 6, 2)
,(1, 6, 3);

