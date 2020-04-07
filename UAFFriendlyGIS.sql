CREATE DATABASE IF NOT EXIST UAFFriendlyGISDatabase;

CREATE TABLE layer(
	Name 	varchar(45) 	NOT NULL,
	Creation_date	DATETIME	NOT NULL,
	Layer_crypto	varchar(45),
	Crypto_key	varchar(45),
	MD5_hash	varchar(45),
	PRIMARY KEY 	(Name)
);

CREATE TABLE nodes(
	NodeName 	varchar(45)	NOT NULL,
	id 	INTERGER	AUTOINCREMENT,
	Latitude varchar(20)	NOT NULL,
	Longitude varchar(20)	NOT NULL,
	PRIMARY KEY	(id),
	FOREIGN KEY	(Layer_Name)	REFERENCES	layer(name)
);

CREATE TABLE attributes(
	Name 	varchar(45)	NOT NULL,
	PRIMARY KEY	(Name),
	FOREIGN KEY	(Layer_Name)	REFERENCES	layer(name),
	FOREIGN KEY	(Node_id)	REFERENCES	nodes(id)
);

CREATE TABLE data(
	Value varchar(45) NOT NULL,
	date_added DATETIME NOT NULL,
	FOREIGN KEY	(Attribute_name)	REFERENCES	attributes(Name),
	FOREIGN KEY	(Layer_Name)	REFERENCES	layer(name),
	FOREIGN KEY	(Node_id)	REFERENCES	nodes(id)
); 

CREATE TABLE units(
	Name varchar(45) NOT NULL,
	PRIMARY KEY	(Name),
	FOREIGN KEY	(Attribute_name)	REFERENCES	attributes(Name),
	FOREIGN KEY	(Layer_Name)	REFERENCES	layer(name),
	FOREIGN KEY	(Node_id)	REFERENCES	nodes(id)
);

CREATE TABLE value_type(
	Name varchar(45) NOT NULL
	PRIMARY KEY (Name),
	FOREIGN KEY	(Unit_name)	REFERENCES	units(Name),
	FOREIGN KEY	(Attribute_name)	REFERENCES	attributes(Name),
	FOREIGN KEY	(Layer_Name)	REFERENCES	layer(name),
	FOREIGN KEY	(Node_id)	REFERENCES	nodes(id)
);
