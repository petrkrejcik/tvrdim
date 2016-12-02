DROP TABLE IF EXISTS statement_closure;
DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY KEY,
    text TEXT NOT NULL
);

INSERT INTO statement (text) VALUES
('__ROOT__'); -- root for all

CREATE TABLE statement_closure (
    ancestor BIGSERIAL REFERENCES statement (id) ON DELETE CASCADE,
    descendant BIGSERIAL REFERENCES statement (id) ON DELETE CASCADE,
    depth INTEGER,
    agree BOOLEAN
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
('1', '1', 0);
