DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY KEY,
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
    ancestor BIGSERIAL,
    descendant BIGSERIAL,
    depth INTEGER,
    is_approving BOOLEAN
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
('1', '1', 0, null)
,('2', '2', 0, null)
,('1', '2', 1, null)
,('3', '3', 0, null)
,('1', '3', 2, null)
,('2', '3', 1, false)
,('4', '4', 0, null)
,('2', '4', 1, true)
,('1', '4', 2, null)
,('5', '5', 0, null)
,('1', '5', 1, null)
,('6', '6', 0, null)
,('5', '6', 1, true)
,('1', '6', 3, null);

