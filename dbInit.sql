DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY key,
    text TEXT NOT NULL
);

INSERT INTO statement (text) VALUES
('__ROOT__'); -- root for all

DROP TABLE IF EXISTS statement_closure;
CREATE TABLE statement_closure (
    ancestor INTEGER,
    descendant INTEGER,
    depth INTEGER
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
(1, 1, 0);
