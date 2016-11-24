DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    id BIGSERIAL PRIMARY key,
    text TEXT NOT NULL
);

DROP TABLE IF EXISTS statement_closure;
CREATE TABLE statement_closure (
    ancestor INTEGER,
    descendant INTEGER,
    depth INTEGER
);
