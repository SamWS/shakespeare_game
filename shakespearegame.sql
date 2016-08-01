CREATE DATABASE shakespeare;

CREATE TABLE games(
  id SERIAL4 PRIMARY KEY,
  play VARCHAR(100) NOT NULL,
  quote VARCHAR(500) NOT NULL,
  character VARCHAR(100) NOT NULL
);

INSERT INTO games (play, quote, character) VALUES ('Richard III', 'My Kingdom for a Horse', 'Richard III');




CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  password_digest VARCHAR(400) NOT NULL,
  high_score INTEGER,
  admin BOOLEAN
);

-- ALTER TABLE dishes ADD user_id INTEGER;
