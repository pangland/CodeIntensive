CREATE TABLE signature_techniques (
  id INTEGER PRIMARY KEY,
  technique VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE practitioners (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  martial_arts INTEGER,

  FOREIGN KEY(style_id) REFERENCES practitioner(id)
);

CREATE TABLE styles (
  id INTEGER PRIMARY KEY,
  style VARCHAR(255) NOT NULL
);

INSERT INTO
  schools (id, title)
VALUES
  (1, "Brazilian Jiu Jitsu"),
  (2, "Jeet Kun Do"),
  (3, "Boxing");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Marcelo", "Garcia", 1),
  (2, "Demian", "Maia", 1),
  (3, "Bruce", "Lee", 2),
  (4, "'Sugar' Ray", "Robinson", 3);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Arm drag", 1),
  (2, "Triangle choke", 2),
  (3, "Side kick to knee", 3),
  (4, "Swining nunchucks around while shouting like a mad man", 3),
  (5, "Left hook", 4);
