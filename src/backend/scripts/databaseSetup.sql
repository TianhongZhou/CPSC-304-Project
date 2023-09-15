CREATE TABLE Organizations_1 (
                                 Name			CHAR(40) PRIMARY KEY,
                                 PhoneNumber		CHAR(20) UNIQUE
);

CREATE TABLE Organizations_3 (
                                 Name			CHAR(40) PRIMARY KEY,
                                 FundedBy		CHAR(20)
);

CREATE TABLE Organizations_4 (
                                 Address		CHAR(60) PRIMARY KEY,
                                 Name			CHAR(40) NOT NULL,
                                 FOREIGN KEY (Name)
                                     REFERENCES Organizations_1(Name)
                                     ON DELETE CASCADE
);


CREATE TABLE Continents (
                            Name			CHAR(20) PRIMARY KEY,
                            NumberOfCountries	INTEGER NOT NULL
);

CREATE TABLE CountriesPartOf (
                                 CountryName		CHAR(20) PRIMARY KEY,
                                 Capital			CHAR(20) UNIQUE,
                                 Population		INTEGER NOT NULL,
                                 OfficialLanguage	CHAR(20) NOT NULL,
                                 Continent		CHAR(20) NOT NULL,
                                 FOREIGN KEY (Continent)
                                     REFERENCES Continents(Name)
                                         ON DELETE CASCADE
);


CREATE TABLE ResponsibleFor (
                                CountryName		CHAR(20),
                                OrganizationAddress	CHAR(60),
                                PRIMARY KEY (CountryName, OrganizationAddress),
                                FOREIGN KEY (CountryName)
                                    REFERENCES CountriesPartOf(CountryName)
                                    ON DELETE CASCADE,
                                FOREIGN KEY (OrganizationAddress)
                                    REFERENCES ORGANIZATIONS_4(Address)
                                    ON DELETE CASCADE
);


CREATE TABLE WorkersWorkIn (
                               ID			INTEGER,
                               Name			CHAR(20) NOT NULL,
                               Gender		CHAR(10),
                               Address		CHAR(60),
                               PRIMARY KEY (ID, Address),
                               FOREIGN KEY (Address)
                                   REFERENCES Organizations_4(Address)
                                   ON DELETE CASCADE
);



CREATE TABLE LivingEnvironment (
                                   Name			CHAR(50),
                                   Biome			CHAR(30),
                                   PRIMARY KEY (Name, Biome)
);


CREATE TABLE Contains (
                          CountriesName	CHAR(20),
                          EnvironmentName	CHAR(50),
                          Biome			CHAR(30),
                          PRIMARY KEY (CountriesName, EnvironmentName, Biome),
                          FOREIGN KEY (CountriesName)
                              REFERENCES CountriesPartOf(CountryName)
                              ON DELETE CASCADE,
                              FOREIGN KEY (EnvironmentName, Biome)
                              REFERENCES LivingEnvironment(Name, Biome)
                              ON DELETE CASCADE
);

CREATE TABLE EndangeredAnimal (
                                  ScientificName	CHAR(300) PRIMARY KEY,
                                  CommonName	CHAR(30) NOT NULL,
                                  Type			CHAR(20) NOT NULL,
                                  Habitat			CHAR(30) NOT NULL,
                                  Appearance		CHAR(400) NOT NULL
);


CREATE TABLE EndangeredIn (
                              ScientificName	CHAR(300),
                              Countries		CHAR(20),
                              Status			CHAR(40) NOT NULL,
                              Population		INTEGER NOT NULL,
                              "DATE"			DATE NOT NULL,
                              PRIMARY KEY (ScientificName, Countries),
                              FOREIGN KEY (ScientificName)
                                  REFERENCES EndangeredAnimal(ScientificName)
                                  ON DELETE CASCADE,
                              FOREIGN KEY (Countries)
                                  REFERENCES CountriesPartOf(CountryName)
                                  ON DELETE CASCADE
);

CREATE TABLE Live (
                      ScientificName	CHAR(300),
                      EnvironmentName	CHAR(50) NOT NULL,
                      Biome			CHAR(30) NOT NULL,
                      PRIMARY KEY (ScientificName, EnvironmentName, Biome),
                      FOREIGN KEY (ScientificName)
                          REFERENCES EndangeredAnimal(ScientificName)
                          ON DELETE CASCADE,
                      FOREIGN KEY (EnvironmentName, Biome)
                          REFERENCES LivingEnvironment(Name, Biome)
                          ON DELETE CASCADE
);

CREATE TABLE Help (
                      WorkerID		INTEGER,
                      Address		CHAR(60),
                      ScientificName	CHAR(300),
                      Services		CHAR(150) NOT NULL,
                      PRIMARY KEY (WorkerID, Address, ScientificName),
                      FOREIGN KEY (WorkerID, Address)
                          REFERENCES WorkersWorkIn(ID, Address)
                          ON DELETE CASCADE,
                      FOREIGN KEY (ScientificName)
                          REFERENCES EndangeredAnimal(ScientificName)
                          ON DELETE CASCADE
);

CREATE TABLE Threats_1 (
                           DescriptionOfThreat	CHAR(100) PRIMARY KEY,
                           ThreatSeverity		INTEGER NOT NULL
);

CREATE TABLE Threats_2 (
                           ThreatID		INTEGER PRIMARY KEY,
                           PlaceIdentified	CHAR(40) NOT NULL,
                           DescriptionOfThreat	CHAR(100) NOT NULL,
                           "DATE"			DATE,
                           FOREIGN KEY (DescriptionOfThreat)
                               REFERENCES Threats_1(DescriptionOfThreat)
                               ON DELETE CASCADE
);

CREATE TABLE NaturalDisaster (
                                 ThreatID		INTEGER PRIMARY KEY,
                                 Type			CHAR(30) NOT NULL
);

CREATE TABLE Predator (
                          ThreatID		INTEGER PRIMARY KEY,
                          Name			CHAR(30) NOT NULL
);

CREATE TABLE Harm (
                      ThreatID		INTEGER,
                      ScientificName	CHAR(300),
                      PRIMARY KEY (ThreatID, ScientificName),
                      FOREIGN KEY (ThreatID)
                          REFERENCES Threats_2(ThreatID)
                          ON DELETE CASCADE,
                      FOREIGN KEY (ScientificName)
                          REFERENCES EndangeredAnimal(ScientificName)
                          ON DELETE CASCADE
);


CREATE TABLE Affect (
                        ThreatID		INTEGER,
                        EnvironmentName	CHAR(50),
                        Biome			CHAR(30),
                        DateLastAffected	DATE NOT NULL,
                        PRIMARY KEY (ThreatID, EnvironmentName, Biome),
                        FOREIGN KEY (ThreatID)
                            REFERENCES NaturalDisaster(ThreatID)
                            ON DELETE CASCADE,
                        FOREIGN KEY (EnvironmentName, Biome)
                            REFERENCES LivingEnvironment(Name, Biome)
                            ON DELETE CASCADE
);

CREATE TABLE Reduce (
                        WorkerID INT,
                        Address VARCHAR(60),
                        ThreatID INT,
                        MitigationMeasure VARCHAR(100)
);



CREATE TABLE Food_1 (
                        DescriptionOfFoodSource	CHAR(100) PRIMARY KEY,
                        Seasonality			CHAR(30)
);

CREATE TABLE Food_2 (
                        Name				CHAR(30) PRIMARY KEY,
                        DescriptionOfFoodSource	CHAR(100),
                        FOREIGN KEY (DescriptionOfFoodSource)
                            REFERENCES Food_1(DescriptionOfFoodSource)
                            ON DELETE CASCADE
);

CREATE TABLE Eat (
                     FoodName		CHAR(30),
                     ScientificName	CHAR(300),
                     PRIMARY KEY (FoodName, ScientificName),
                     FOREIGN KEY (FoodName)
                         REFERENCES Food_2(Name)
                         ON DELETE CASCADE,
                     FOREIGN KEY (ScientificName)
                         REFERENCES EndangeredAnimal(ScientificName)
                         ON DELETE CASCADE
);

INSERT INTO Organizations_1 (Name, PhoneNumber) VALUES ('Canada Rescue Organization', '+1-111-234-5678');
INSERT INTO Organizations_1 (Name, PhoneNumber) VALUES ('Toronto Rescue Organization', '+91-111-234-6789');
INSERT INTO Organizations_1 (Name, PhoneNumber) VALUES ('America Rescue Organization', '+86-222-234-5678');
INSERT INTO Organizations_1 (Name, PhoneNumber) VALUES ('Sweden Rescue Organization', '+21-222-234-6789');
INSERT INTO Organizations_1 (Name, PhoneNumber) VALUES ('Rhodes Rescue Organization', '+11-111-111-2222');

INSERT INTO Organizations_3 (Name, FundedBy)
VALUES ('Canada Rescue Organization', 'Jordan');

INSERT INTO Organizations_3 (Name, FundedBy)
VALUES ('Toronto Rescue Organization', 'Messi');

INSERT INTO Organizations_3 (Name, FundedBy)
VALUES ('America Rescue Organization', 'Lionel');

INSERT INTO Organizations_3 (Name, FundedBy)
VALUES ('Sweden Rescue Organization', 'Patrice');

INSERT INTO Organizations_3 (Name, FundedBy)
VALUES ('Rhodes Rescue Organization', 'Margo');

INSERT INTO Organizations_4(Address, Name)
VALUES ('123-ABC Street, Vancouver, BC, Canada', 'Canada Rescue Organization');

INSERT INTO Organizations_4(Address, Name)
VALUES ('234-BCD Street, Toronto, OA, Canada', 'Toronto Rescue Organization');

INSERT INTO Organizations_4(Address, Name)
VALUES ('345-CDE Street, New York, NY, US', 'America Rescue Organization');

INSERT INTO Organizations_4(Address, Name)
VALUES ('456-DEF Street, Shanghai, China', 'Sweden Rescue Organization');

INSERT INTO Organizations_4(Address, Name)
VALUES ('567-EFG Street, Beijing, China', 'Rhodes Rescue Organization');

INSERT INTO WorkersWorkIn (ID, Name, Gender, Address)
VALUES (001, 'James', 'male', '123-ABC Street, Vancouver, BC, Canada');

INSERT INTO WorkersWorkIn (ID, Name, Gender, Address)
VALUES (010, 'Jason', 'male', '234-BCD Street, Toronto, OA, Canada');

INSERT INTO WorkersWorkIn (ID, Name, Gender, Address)
VALUES (011, 'Alice', 'female', '345-CDE Street, New York, NY, US');

INSERT INTO WorkersWorkIn (ID, Name, Gender, Address)
VALUES (100, 'John', 'male', '456-DEF Street, Shanghai, China');

INSERT INTO WorkersWorkIn (ID, Name, Gender, Address)
VALUES (101, 'Ben', 'male', '567-EFG Street, Beijing, China');

INSERT INTO Continents(Name, NumberOfCountries)
VALUES ('North America', 23);

INSERT INTO Continents(Name, NumberOfCountries)
VALUES ('Asia', 49);

INSERT INTO Continents(Name, NumberOfCountries)
VALUES ('Europe', 50);

INSERT INTO Continents(Name, NumberOfCountries)
VALUES ('Africa', 54);

INSERT INTO Continents(Name, NumberOfCountries)
VALUES ('South America', 12);

INSERT INTO CountriesPartOf (CountryName, Capital, Population, OfficialLanguage, Continent)
VALUES ('Canada', 'Ottawa', 30000000, 'English', 'North America');

INSERT INTO CountriesPartOf (CountryName, Capital, Population, OfficialLanguage, Continent)
VALUES ('United States', 'Washington DC', 331000000, 'English', 'North America');

INSERT INTO CountriesPartOf (CountryName, Capital, Population, OfficialLanguage, Continent)
VALUES ('China', 'Beijing', 1400000000, 'Chinese', 'Asia');

INSERT INTO CountriesPartOf (CountryName, Capital, Population, OfficialLanguage, Continent)
VALUES ('Vietnam', 'Hanoii', 100000000, 'Vietnamese', 'Asia');

INSERT INTO CountriesPartOf (CountryName, Capital, Population, OfficialLanguage, Continent)
VALUES ('France', 'Paris', 123456789, 'French', 'Europe');

INSERT INTO CountriesPartOf (CountryName, Population, OfficialLanguage, Continent)
VALUES ('South Africa', 12345678, 'English', 'Africa');

INSERT INTO CountriesPartOf (CountryName, Population, OfficialLanguage, Continent)
VALUES ('Brazil', 1234566780, 'Portuguese', 'South America');

INSERT INTO ResponsibleFor (CountryName, OrganizationAddress)
VALUES ('Canada', '123-ABC Street, Vancouver, BC, Canada');

INSERT INTO ResponsibleFor (CountryName, OrganizationAddress)
VALUES ('Canada', '234-BCD Street, Toronto, OA, Canada');

INSERT INTO ResponsibleFor (CountryName, OrganizationAddress)
VALUES ('United States', '345-CDE Street, New York, NY, US');

INSERT INTO ResponsibleFor (CountryName, OrganizationAddress)
VALUES ('China', '456-DEF Street, Shanghai, China');

INSERT INTO ResponsibleFor (CountryName, OrganizationAddress)
VALUES ('China', '567-EFG Street, Beijing, China');

INSERT INTO LivingEnvironment
VALUES ('Rocky Mountains', 'Tundra');

INSERT INTO LivingEnvironment
VALUES ('Tibetan Plateau', 'Grassland');

INSERT INTO LivingEnvironment
VALUES ('Yangtze Plain', 'Mixed forest');

INSERT INTO LivingEnvironment
VALUES ('Mekong Delta', 'Wetland');

INSERT INTO LivingEnvironment
VALUES ('Alps Mountains', 'Alpine');

INSERT INTO LivingEnvironment
VALUES ('South Africa Plateau', 'Grassland');

INSERT INTO LivingEnvironment
VALUES ('Planalto Brasileiro', 'Grassland');

INSERT INTO Contains
VALUES ('Canada', 'Rocky Mountains', 'Tundra');

INSERT INTO Contains
VALUES ('China', 'Tibetan Plateau', 'Grassland');

INSERT INTO Contains
VALUES ('China', 'Yangtze Plain', 'Mixed forest');

INSERT INTO Contains
VALUES ('Vietnam', 'Mekong Delta', 'Wetland');

INSERT INTO Contains
VALUES ('France', 'Alps Mountains', 'Alpine');

INSERT INTO Contains
VALUES ('South Africa', 'South Africa Plateau', 'Grassland');

INSERT INTO Contains
VALUES ('Brazil', 'Planalto Brasileiro', 'Grassland');

INSERT INTO EndangeredAnimal
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Javan rhino', 'Mammal', 'Southeast Asia', 'Javan rhinos are smaller than the Indian rhinoceros, and are close in size to the black rhinoceros');

INSERT INTO EndangeredAnimal
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis', 'Amur leopard', 'Mammal', 'Northern China', 'Amur leopard can easily be differentiated from other leopard subspecies by its thick, pale cream-colored fur, Particularly in winter');

INSERT INTO EndangeredAnimal
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Primates, Suborder:Haplorhini, Infraorder: Simiiformes, Family: Hominidae, Subfamily: Homininae, Genus: Gorilla, Species: G. beringei, Subspecies: G. b. beringei', 'Mountain gorillas', 'Mammal', 'East Africa', 'The fur of mountain gorilla, often thicker and longer than that of other gorilla species, enables them to live in colder temperatures');

INSERT INTO EndangeredAnimal
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis', 'Yangtze finless porpoise', 'Mammal', 'Yangtze River in China', 'A finless porpoise can grow up to 2.27m in length and weigh up to 71.8kg');

INSERT INTO EndangeredAnimal
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis', 'African forest elephant', 'Mammal', 'West Africa', 'The African forest elephant has grey skin, which looks yellow to reddish after wallowing');

INSERT INTO EndangeredIn
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Vietnam', 'Critically Endangered', 75, DATE '2011-05-28');

INSERT INTO EndangeredIn
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis', 'China', 'Critically Endangered', 100, DATE '2010-04-02');

INSERT INTO EndangeredIn
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Primates, Suborder:Haplorhini, Infraorder: Simiiformes, Family: Hominidae, Subfamily: Homininae, Genus: Gorilla, Species: G. beringei, Subspecies: G. b. beringei', 'South Africa', 'Critically Endangered', 50, DATE '2014-09-10');

INSERT INTO EndangeredIn
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis', 'China', 'Critically Endangered', 80, DATE '2008-07-15');

INSERT INTO EndangeredIn
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis', 'South Africa', 'Critically Endangered', 60, DATE '2016-06-19');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Rocky Mountains', 'Tundra');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Tibetan Plateau', 'Grassland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Yangtze Plain', 'Mixed forest');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Mekong Delta', 'Wetland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Alps Mountains', 'Alpine');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'South Africa Plateau', 'Grassland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus', 'Planalto Brasileiro', 'Grassland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis', 'Tibetan Plateau', 'Grassland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Primates, Suborder:Haplorhini, Infraorder: Simiiformes, Family: Hominidae, Subfamily: Homininae, Genus: Gorilla, Species: G. beringei, Subspecies: G. b. beringei', 'South Africa Plateau', 'Grassland');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis', 'Yangtze Plain', 'Mixed forest');

INSERT INTO Live
VALUES ('Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis', 'South Africa Plateau', 'Grassland');

INSERT INTO Reduce
VALUES (100, '456-DEF Street, Shanghai, China', 4, 'Artificial rainfall');

INSERT INTO Reduce
VALUES (101, '567-EFG Street, Beijing, China', 1, 'Use chemicals to clean water');

INSERT INTO Reduce
VALUES (001, '123-ABC Street, Vancouver, BC, Canada', 2, 'Provide food');

INSERT INTO Reduce
VALUES (010, '234-BCD Street, Toronto, OA, Canada', 3, 'Build nature reserves');

INSERT INTO Threats_1
VALUES ('Water pollution', 8);

INSERT INTO Threats_1
VALUES ('Lack of food', 6);

INSERT INTO Threats_1
VALUES ('Harmed or killed by tigers', 6);

INSERT INTO Threats_1
VALUES ('Drought', 8);

INSERT INTO Threats_1
VALUES ('Being hunted', 8);

INSERT INTO Threats_1
VALUES ('Typhoon', 7);

INSERT INTO Threats_1
VALUES ('Hurricane', 7);

INSERT INTO Threats_1
VALUES ('Snowstorm', 5);

INSERT INTO Threats_1
VALUES ('Flood', 5);

INSERT INTO Threats_1
VALUES ('Harmed or killed by sharks', 6);

INSERT INTO Threats_1
VALUES ('Harmed or killed by lions', 6);

INSERT INTO Threats_1
VALUES ('Harmed or killed by snakes', 6);

INSERT INTO Threats_1
VALUES ('Harmed or killed by bears', 6);

INSERT INTO Threats_2
VALUES (1, 'Yangtze River in China', 'Water pollution', TO_DATE('2012-06-30', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (2, 'Mekong Delta in Vietnam', 'Lack of food', TO_DATE('2014-02-18', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (3, 'South Africa Plateau in South Africa', 'Harmed or killed by tigers', TO_DATE('2020-08-21', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (4, 'South Africa Plateau in South Africa', 'Drought', TO_DATE('2009-01-20', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (5, 'Yangtze River in China', 'Being hunted', TO_DATE('2017-03-21', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (6, 'Yangtze Plain in China', 'Typhoon', TO_DATE('2015-04-25', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (7, 'Rocky Mountain in the United States', 'Hurricane', TO_DATE('2016-02-01', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (8, 'Hida Mountain in Japan', 'Snowstorm', TO_DATE('2014-01-12', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (9, 'Yangtze Plain in China', 'Flood', TO_DATE('2010-07-21', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (10, 'Pacific Ocean', 'Harmed or killed by sharks', TO_DATE('2001-12-15', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (11, 'South Africa Plateau in South Africa', 'Harmed or killed by lions', TO_DATE('2009-08-15', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (12, 'Amazon Rain Forest in Brazil', 'Harmed or killed by snakes', TO_DATE('2002-02-15', 'YYYY-MM-DD'));

INSERT INTO Threats_2
VALUES (13, 'Rocky Mountain in Canada', 'Harmed or killed by bears', TO_DATE('2009-07-15', 'YYYY-MM-DD'));

INSERT INTO NaturalDisaster
VALUES (4, 'Drought');

INSERT INTO NaturalDisaster
VALUES (6, 'Typhoon');

INSERT INTO NaturalDisaster
VALUES (7, 'Hurricane');

INSERT INTO NaturalDisaster
VALUES (8, 'Snowstorm');

INSERT INTO NaturalDisaster
VALUES (9, 'Flood');

INSERT INTO Predator VALUES (3, 'Tigers');
INSERT INTO Predator VALUES (10, 'Sharks');
INSERT INTO Predator VALUES (11, 'Lions');
INSERT INTO Predator VALUES (12, 'Snakes');
INSERT INTO Predator VALUES (13, 'Bears');

INSERT INTO Harm
VALUES (1, 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis');

INSERT INTO Harm
VALUES (2, 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus');

INSERT INTO Harm
VALUES (3, 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Primates, Suborder:Haplorhini, Infraorder: Simiiformes, Family: Hominidae, Subfamily: Homininae, Genus: Gorilla, Species: G. beringei, Subspecies: G. b. beringei');

INSERT INTO Harm
VALUES (4, 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis');

INSERT INTO Harm
VALUES (5, 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis');

INSERT INTO Food_1
VALUES ('Leaves, young shoots, grass, twigs', 'Spring');

INSERT INTO Food_1
VALUES ('Strong-scented carrion', NULL);

INSERT INTO Food_1
VALUES ('Bamboo and fruits', 'Spring');

INSERT INTO Food_1
VALUES ('Small fish, molluscs and crustaceans', NULL);

INSERT INTO Food_1
VALUES ('Pinecone and nuts', 'Spring');

INSERT INTO Food_2
VALUES ('Leaves', 'Leaves, young shoots, grass, twigs');

INSERT INTO Food_2
VALUES ('Carrion', 'Strong-scented carrion');

INSERT INTO Food_2
VALUES ('Bamboo', 'Bamboo and fruits');

INSERT INTO Food_2
VALUES ('Small marine animals', 'Small fish, molluscs and crustaceans');

INSERT INTO Food_2
VALUES ('Nuts', 'Pinecone and nuts');

INSERT INTO Eat
VALUES ('Leaves', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Perissodactyla, Family: Rhinocerotidae, Genus: Rhinoceros, Species: Rhinoceros sondaicus');

INSERT INTO Eat
VALUES ('Carrion', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis');

INSERT INTO Eat
VALUES ('Bamboo', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Primates, Suborder:Haplorhini, Infraorder: Simiiformes, Family: Hominidae, Subfamily: Homininae, Genus: Gorilla, Species: G. beringei, Subspecies: G. b. beringei');

INSERT INTO Eat
VALUES ('Small marine animals', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis');

INSERT INTO Eat
VALUES ('Leaves', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis');

INSERT INTO Affect
VALUES (4, 'South Africa Plateau', 'Grassland', TO_DATE('2020-08-31', 'YYYY-MM-DD'));

INSERT INTO Affect
VALUES (6, 'Yangtze Plain', 'Mixed forest', TO_DATE('2022-06-30', 'YYYY-MM-DD'));

INSERT INTO Affect
VALUES (7, 'Rocky Mountains', 'Tundra', TO_DATE('2021-07-25', 'YYYY-MM-DD'));

INSERT INTO Affect
VALUES (8, 'Yangtze Plain', 'Mixed forest', TO_DATE('2019-01-10', 'YYYY-MM-DD'));

INSERT INTO Affect
VALUES (9, 'Yangtze Plain', 'Mixed forest', TO_DATE('2017-02-13', 'YYYY-MM-DD'));

INSERT INTO Help
VALUES (100, '456-DEF Street, Shanghai, China', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis', 'Recycle and buy sustainable product');

INSERT INTO Help
VALUES (101, '567-EFG Street, Beijing, China', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Artiodactyla, Infraorder: Cetacea, Family: Phocoenidae, Genus: Neophocaena, Species: N. asiaeorientalis', 'Host a community fundraising event');

INSERT INTO Help
VALUES (100, '456-DEF Street, Shanghai, China', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis', 'Sponsor endangered animals');

INSERT INTO Help
VALUES (101, '567-EFG Street, Beijing, China', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Feliformia, Family: Felidae, Subfamily: Pantherinae, Genus: Panthera, Species: P. pardus, Subspecies: P. p. orientalis', 'Protect wildlife habitats');

INSERT INTO Help
VALUES (011, '345-CDE Street, New York, NY, US', 'Kingdom: Animalia, Phylum: Chordata, Class: Mammalia, Order: Proboscidea, Family: Elephantidae, Genus: Loxodonta, Species: L. cyclotis', 'Boycott of purchasing illegal products that come from endangered species');



