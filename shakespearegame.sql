CREATE DATABASE shakespeare;

######## WASTE OF F&*CKING TIME
-- CREATE TABLE games(
--   id SERIAL4 PRIMARY KEY,
--   play VARCHAR(100) NOT NULL,
--   quote VARCHAR(500) NOT NULL,
--   character VARCHAR(100) NOT NULL
-- );
--
-- INSERT INTO games (play, quote, character) VALUES ('Richard III', 'My Kingdom for a Horse', 'Richard III');

CREATE TABLE plays(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(100)
);

ALTER TABLE plays ADD user_id INTEGER;

INSERT INTO plays (title) VALUES ('Richard III');

#####

CREATE TABLE quotes(
  id SERIAL4 PRIMARY KEY,
  script VARCHAR(500),
  character VARCHAR(100),
  play_id INTEGER
);

INSERT INTO quotes (script, character, play_id) VALUES ('My Kingdom for a horse', 'Richard III', 1)

#####

CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  password_digest VARCHAR(400) NOT NULL,
  high_score INTEGER,
  admin BOOLEAN
);

ALTER TABLE users ADD current_score INTEGER;
-- ALTER TABLE dishes ADD user_id INTEGER;
