CREATE TABLE ACCOUNTS (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  customerid int(11) unsigned NOT NULL,
  amount decimal(10, 2) NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET=utf8;

CREATE TABLE CUSTOMERS (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  firstname varchar(255) NOT NULL DEFAULT '',
  surname varchar(255) NOT NULL DEFAULT '',
  address varchar(255) NOT NULL DEFAULT '',
  email varchar(255) NOT NULL DEFAULT '',
  username varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY UX_username (username)
) DEFAULT CHARSET=utf8;

CREATE TABLE TRANSACTIONS (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  fromid int(11) unsigned NOT NULL,
  payee int(11) unsigned NOT NULL,
  amount decimal(10, 2) NOT NULL,
  details varchar(255),
  txdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET=utf8;

INSERT INTO CUSTOMERS VALUES (1, 'Gareth', 'Healy', '200 Fowler Avenue, Farnborough', 'ghealy@redhat.com', 'ghealy');
INSERT INTO CUSTOMERS VALUES (2, 'Nabeel','Saad', '64 Baker Street, London', 'nsaad@redhat.com', 'nsaad');
INSERT INTO CUSTOMERS VALUES (3, 'Costas', 'Sterpis', '200 Fowler Avenue, Farnborough', 'csterpis@redhat.com','sterpis');
INSERT INTO CUSTOMERS VALUES (4, 'Chris', 'Milsted', '200 Fowler Avenue, Farnborough', 'cmilsted@redhat.com', 'cmilsted');
INSERT INTO CUSTOMERS VALUES (5, 'Jim', 'Minter', '64 Baker Street, London', 'jminter@redhat.com', 'jminter');

INSERT INTO ACCOUNTS VALUES (1, 1, 100.00);
INSERT INTO ACCOUNTS VALUES (2, 2, 100.00);
INSERT INTO ACCOUNTS VALUES (3, 3, 100.00);
INSERT INTO ACCOUNTS VALUES (4, 4, 100.00);
INSERT INTO ACCOUNTS VALUES (5, 5, 100.00);
