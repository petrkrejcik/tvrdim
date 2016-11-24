DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY key,
    text TEXT NOT NULL
);

INSERT INTO statement (text) VALUES
('Kouření by mělo být v hospodách zakázáno.') -- 1
,('Majitel by si měl sám rozhodnout.') -- 2
,('Omezilo by to kouření celkově.') -- 3
,('Hromadná doprava by měla být zdarma.') -- 4
,('Ulevilo by to silnicím.'); -- 5



DROP TABLE IF EXISTS statement_closure;
CREATE TABLE statement_closure (
    ancestor INTEGER,
    descendant INTEGER,
    depth INTEGER
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
(1, 1, 0)
,(1, 2, 1)
,(1, 3, 1)
,(2, 2, 0)
,(3, 3, 0)
,(4, 4, 0)
,(4, 5, 1);

