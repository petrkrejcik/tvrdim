CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    social_id BIGINT,
    social_network TEXT
);


CREATE TABLE IF NOT EXISTS statement (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    user_id INTEGER REFERENCES users (id),
    created_time timestamp
);

INSERT INTO statement (text, created_time) VALUES
('__ROOT__', 'NOW'); -- root for all


CREATE TABLE IF NOT EXISTS statement_closure (
    id BIGSERIAL PRIMARY KEY,
    ancestor INTEGER REFERENCES statement (id) ON DELETE CASCADE,
    descendant INTEGER REFERENCES statement (id) ON DELETE CASCADE,
    depth INTEGER,
    agree BOOLEAN
);

INSERT INTO statement_closure (ancestor, descendant, depth) VALUES ('1', '1', 0);

ALTER TABLE statement ADD COLUMN is_private BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE statement ALTER COLUMN is_private DROP NOT NULL;
ALTER TABLE statement ALTER COLUMN is_private SET DEFAULT NULL;
UPDATE statement SET is_private = NULL WHERE is_private = FALSE;

ALTER TABLE users ALTER COLUMN social_id TYPE TEXT;
