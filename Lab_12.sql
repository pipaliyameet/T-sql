-- Lab 12 Perform SQL queries to implement constraints

-- Part – A:

-- 1. Create STUDENT_INFO table with given constraints
CREATE TABLE STUDENT_INFO (
    RNO INT primary key,
    NAME VARCHAR(20) NOT NULL,
    BRANCH VARCHAR(20) DEFAULT 'CE'
);

-- 2. Create RESULT table with given constraints
CREATE TABLE RESULT (
    RESULTID INT PRIMARY KEY,
    SPI DECIMAL(4,2) CHECK (SPI BETWEEN 0.00 AND 10.00),
    RNO INT FOREIGN KEY REFERENCES STUDENT_INFO(RNO)
);

-- 3. Insert Data into Student and Result Table
INSERT INTO STUDENT_INFO (RNO, NAME, BRANCH) VALUES
(101, 'RAJU', 'CE'),
(102, 'AMIT', 'CE'),
(103, 'SANJAY', 'ME'),
(104, 'NEHA', 'EC'),
(105, 'MEERA', 'EE'),
(106, 'MAHESH', 'ME');

INSERT INTO RESULT (RESULTID, SPI, RNO) VALUES
(11, 8.8, 101),
(12, 9.2, 102),
(13, 7.6, 103),
(14, 8.2, 104),
(15, 7.0, 105),
(16, 8.9, 106);

-- 4. Create DEPARTMENT table with given constraints
CREATE TABLE DEPARTMENT (
    DEPARTMENTID INT PRIMARY KEY,
    DEPARTMENTNAME VARCHAR(100) NOT NULL UNIQUE,
    DEPARTMENTCODE VARCHAR(50) NOT NULL UNIQUE,
    LOCATION VARCHAR(50) NOT NULL
);

-- 5. Create PERSON table with given constraints
CREATE TABLE PERSON (
    PERSONID INT PRIMARY KEY,
    PERSONNAME VARCHAR(100) NOT NULL,
    DEPARTMENTID INT FOREIGN KEY REFERENCES DEPARTMENT(DEPARTMENTID) NULL,
    SALARY DECIMAL(8,2) NOT NULL,
    JOININGDATE DATETIME NOT NULL,
    CITY VARCHAR(100) NOT NULL
);

-- 6. Insert Data into PERSON and DEPARTMENT Table
INSERT INTO DEPARTMENT (DEPARTMENTID, DEPARTMENTNAME, DEPARTMENTCODE, LOCATION) VALUES
(1, 'ADMIN', 'ADM', 'A-BLOCK'),
(2, 'COMPUTER', 'CE', 'C-BLOCK'),
(3, 'CIVIL', 'CI', 'G-BLOCK'),
(4, 'ELECTRICAL', 'EE', 'E-BLOCK'),
(5, 'MECHANICAL', 'ME', 'B-BLOCK'),
(6, 'CHEMICAL', 'CH', 'D-BLOCK');

INSERT INTO PERSON (PERSONID, PERSONNAME, DEPARTMENTID, SALARY, JOININGDATE, CITY) VALUES
(101, 'RAHUL TRIPATHI', 2, 56000.00, '2000-01-01', 'RAJKOT'),
(102, 'HARDIK PANDYA', 3, 18000.00, '2001-09-25', 'AHMEDABAD'),
(103, 'BHAVIN KANANI', 4, 25000.00, '2000-05-14', 'BARODA'),
(104, 'BHOOMI VAISHNAV', 1, 39000.00, '2005-02-08', 'RAJKOT'),
(105, 'ROHIT TOPIYA', 2, 17000.00, '2001-07-23', 'JAMNAGAR'),
(106, 'PRIYA MENPARA', NULL, 9000.00, '2000-10-18', 'AHMEDABAD'),
(107, 'NEHA SHARMA', 2, 34000.00, '2002-12-25', 'RAJKOT'),
(108, 'NAYAN GOSWAMI', 3, 25000.00, '2001-07-01', 'RAJKOT'),
(109, 'MEHUL BHUNDIYA', 4, 13500.00, '2005-01-09', 'BARODA'),
(110, 'MOHIT MARU', 5, 14000.00, '2000-05-25', 'JAMNAGAR');

select * from PERSON
-- Part – B:

-- 7. Create PUBLISHER table with given constraints
CREATE TABLE PUBLISHER (
    PUBLISHERID INT PRIMARY KEY,
    PUBLISHERNAME VARCHAR(100) NOT NULL UNIQUE,
    CITY VARCHAR(50) NOT NULL
);

-- 8. Create AUTHOR table with given constraints
CREATE TABLE AUTHOR (
    AUTHORID INT PRIMARY KEY,
    AUTHORNAME VARCHAR(100) NOT NULL,
    COUNTRY VARCHAR(50) NULL
);

-- 9. Create BOOK table with given constraints
CREATE TABLE BOOK (
    BOOKID INT PRIMARY KEY,
    TITLE VARCHAR(200) NOT NULL,
    AUTHORID INT FOREIGN KEY REFERENCES AUTHOR(AUTHORID) NOT NULL,
    PUBLISHERID INT FOREIGN KEY REFERENCES PUBLISHER(PUBLISHERID) NOT NULL,
    PRICE DECIMAL(8,2) NOT NULL,
    PUBLICATIONYEAR INT NOT NULL
);

-- 10. Insert Data into PUBLISHER, AUTHOR and BOOK Table
INSERT INTO PUBLISHER (PUBLISHERID, PUBLISHERNAME, CITY) VALUES
(1, 'RUPA PUBLICATIONS', 'NEW DELHI'),
(2, 'PENGUIN INDIA', 'GURUGRAM'),
(3, 'HARPERCOLLINS INDIA', 'NOIDA'),
(4, 'ALEPH BOOK COMPANY', 'NEW DELHI');

INSERT INTO AUTHOR (AUTHORID, AUTHORNAME, COUNTRY) VALUES
(1, 'CHETAN BHAGAT', 'INDIA'),
(2, 'ARUNDHATI ROY', 'INDIA'),
(3, 'AMISH TRIPATHI', 'INDIA'),
(4, 'RUSKIN BOND', 'INDIA'),
(5, 'JHUMPA LAHIRI', 'INDIA'),
(6, 'PAULO COELHO', 'BRAZIL'),
(7, 'SUDHA MURTY', 'INDIA');

INSERT INTO BOOK (BOOKID, TITLE, AUTHORID, PUBLISHERID, PRICE, PUBLICATIONYEAR) VALUES
(101, 'FIVE POINT SOMEONE', 1, 1, 250.00, 2004),
(102, 'THE GOD OF SMALL THINGS', 2, 2, 350.00, 1997),
(103, 'IMMORTALS OF MELUHA', 3, 3, 300.00, 2010),
(104, 'THE BLUE UMBRELLA', 4, 1, 180.00, 1980),
(105, 'THE LOWLAND', 5, 2, 400.00, 2013),
(106, 'REVOLUTION 2020', 1, 1, 275.00, 2011),
(107, 'SITA: WARRIOR OF MITHILA', 3, 3, 320.00, 2017),
(108, 'THE ROOM ON THE ROOF', 4, 4, 200.00, 1956);

-- 11. Create STADIUM table with given constraints
CREATE TABLE STADIUM (
    Stadium_id INT PRIMARY KEY,
    Stadium_name VARCHAR(200) NOT NULL UNIQUE,
    Stadium_capacity INT NOT NULL,
    Stadium_city VARCHAR(200) NOT NULL
);

-- 12. Create TEAM table with given constraints
CREATE TABLE TEAM (
    TEAM_ID INT PRIMARY KEY,
    TEAM_NAME VARCHAR(200) NOT NULL UNIQUE,
    TEAM_COACH VARCHAR(200) NOT NULL,
    TEAM_WINS INT NOT NULL,
    TEAM_TOTAL_MATCHES INT NULL,
    HOME_STADIUM_ID INT FOREIGN KEY REFERENCES STADIUM(Stadium_id) NULL
);

-- 13. Create PLAYER table with given constraints
CREATE TABLE PLAYER (
    PLAYER_ID INT PRIMARY KEY,
    PLAYER_FIRST_NAME VARCHAR(200) NOT NULL,
    PLAYER_LAST_NAME VARCHAR(200) NOT NULL,
    TEAM_ID INT FOREIGN KEY REFERENCES TEAM(TEAM_ID) NULL,
    PLAYER_ROLE VARCHAR(200) NULL,
    PLAYER_JERSEY_NUMBER INT NOT NULL,
    PLAYER_MATCHES_PLAYED INT NULL
);

-- 14. Insert Data into STADIUM and TEAM Table
INSERT INTO STADIUM (Stadium_id, Stadium_name, Stadium_capacity, Stadium_city) VALUES
(101, 'Wankhede Stadium', 55000, 'Mumbai'),
(102, 'Chepauk Stadium', 50000, 'Chennai'),
(103, 'Chinnaswamy Stadium', 45000, 'Bangalore'),
(104, 'Eden Gardens', 68000, 'Kolkata'),
(105, 'Sawai Mansingh Stadium', 30000, 'Jaipur'),
(106, 'Arun Jaitley Stadium', 42000, 'Delhi'),
(107, 'Bindra Stadium', 38000, 'Mohali'),
(108, 'Rajiv Gandhi Stadium', 55000, 'Hyderabad');

INSERT INTO TEAM (TEAM_ID, TEAM_NAME, TEAM_COACH, TEAM_WINS, TEAM_TOTAL_MATCHES, HOME_STADIUM_ID) VALUES
(1, 'Mumbai Indians', 'Mark Boucher', 12, 14, 101),
(2, 'Chennai Super Kings', 'Stephen Fleming', 10, 14, 102),
(3, 'Royal Challengers Bangalore', 'Faf du Plessis', 9, 14, 103),
(4, 'Kolkata Knight Riders', 'Gautam Gambhir', 11, 14, 104),
(5, 'Rajasthan Royals', 'Rahul Dravid', 8, 14, 105),
(6, 'Delhi Capitals', 'Ricky Ponting', 7, 14, 106),
(7, 'Punjab Kings', 'Anil Kumble', 6, 14, 107),
(8, 'Sunrisers Hyderabad', 'Brian Lara', 9, 14, 108);

-- 15. Insert Data into PLAYER Table
INSERT INTO PLAYER (PLAYER_ID, PLAYER_FIRST_NAME, PLAYER_LAST_NAME, TEAM_ID, PLAYER_ROLE, PLAYER_JERSEY_NUMBER, PLAYER_MATCHES_PLAYED) VALUES
(201, 'Virat', 'Kohli', 3, 'Batsman', 18, 25),
(202, 'Rohit', 'Sharma', 1, 'Batsman', 45, 28),
(203, 'Jasprit', 'Bumrah', 1, 'Bowler', 93, 26),
(204, 'MS', 'Dhoni', 2, 'Wicketkeeper', 7, 30),
(205, 'Ravindra', 'Jadeja', 2, 'All-rounder', 8, 27),
(206, 'Andre', 'Russell', 4, 'All-rounder', 12, 24),
(207, 'Sanju', 'Samson', 5, 'Batsman', 11, 23),
(208, 'Yuzvendra', 'Chahal', 5, 'Bowler', 3, 22),
(209, 'Glenn', 'Maxwell', 3, 'All-rounder', 32, 21),
(210, 'Sunil', 'Narine', 4, 'Bowler', 74, 29),
(211, 'David', 'Warner', 6, 'Batsman', 31, 26),
(212, 'Rishabh', 'Pant', 6, 'Wicketkeeper', 17, 24),
(213, 'Kagiso', 'Rabada', 6, 'Bowler', 25, 23),
(214, 'Shikhar', 'Dhawan', 7, 'Batsman', 42, 27),
(215, 'Liam', 'Livingstone', 7, 'All-rounder', 23, 22),
(216, 'Arshdeep', 'Singh', 7, 'Bowler', 2, 21),
(217, 'Aiden', 'Markram', 8, 'Batsman', 4, 23),
(218, 'Bhuvneshwar', 'Kumar', 8, 'Bowler', 15, 28),
(219, 'Rahul', 'Tripathi', 8, 'Batsman', 52, 24),
(220, 'Abdul', 'Samad', 8, 'All-rounder', 11, 29);
