create database test;
USE test;
CREATE TABLE tutorials_tbl(
  tutorial_id INT NOT NULL AUTO_INCREMENT,
  tutorial_title VARCHAR(100) NOT NULL,
  tutorial_author VARCHAR(40) NOT NULL,
  submission_date DATE,
  PRIMARY KEY ( tutorial_id )
);
