DROP TABLE IF EXISTS statement_closure;
DROP TABLE IF EXISTS statement;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    social_id BIGINT,
    social_network TEXT
);


CREATE TABLE statement (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    user_id INTEGER REFERENCES users (id)
);

INSERT INTO statement (text) VALUES
('__ROOT__'); -- root for all


CREATE TABLE statement_closure (
    ancestor INTEGER REFERENCES statement (id) ON DELETE CASCADE,
    descendant INTEGER REFERENCES statement (id) ON DELETE CASCADE,
    depth INTEGER,
    agree BOOLEAN
);

INSERT INTO statement_closure VALUES
-- (asc, desc, depth)
('1', '1', 0);

