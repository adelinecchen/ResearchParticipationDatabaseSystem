-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS sona_db;
USE sona_db;

-- USERS TABLE (for login/authentication)
CREATE TABLE IF NOT EXISTS users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY username (username),
    UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- lily's credits:

-- ATTENDANCE TABLE (existing credit tracking system)
CREATE TABLE IF NOT EXISTS attendance (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    event_date DATE NOT NULL,
    event_name VARCHAR(100) NOT NULL,
    credits_earned DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY user_id (user_id),
    CONSTRAINT attendance_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CREDITS TABLE (existing credit tracking system)
CREATE TABLE IF NOT EXISTS credits (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    total_credits DECIMAL(5,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY user_id (user_id),
    CONSTRAINT credits_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- here is from our relational schema:
-- FACULTY TABLE
CREATE TABLE IF NOT EXISTS Faculty (
    FacultyID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    UserID INT DEFAULT NULL,
    FOREIGN KEY (UserID) REFERENCES users(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- FACULTY PHONE NUMBER TABLE (multivalued attribute)
CREATE TABLE IF NOT EXISTS FacultyPhoneNumber (
    FacultyID INT NOT NULL,
    FacultyPhoneNumber VARCHAR(15) NOT NULL,
    PRIMARY KEY (FacultyID, FacultyPhoneNumber),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- STUDENT TABLE
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    UserID INT DEFAULT NULL,
    FOREIGN KEY (UserID) REFERENCES users(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- STUDENT PHONE NUMBER TABLE (multivalued attribute)
CREATE TABLE IF NOT EXISTS StudentPhoneNumber (
    StudentID INT NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    PRIMARY KEY (StudentID, PhoneNumber),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- RESEARCHER TABLE
CREATE TABLE IF NOT EXISTS Researcher (
    ResearcherID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    UserID INT DEFAULT NULL,
    FOREIGN KEY (UserID) REFERENCES users(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- RESEARCHER PHONE NUMBER TABLE (multivalued attribute)
CREATE TABLE IF NOT EXISTS ResearcherPhoneNumber (
    ResearcherID INT NOT NULL,
    ResearcherPhoneNumber VARCHAR(15) NOT NULL,
    PRIMARY KEY (ResearcherID, ResearcherPhoneNumber),
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- STUDY TABLE
CREATE TABLE IF NOT EXISTS Study (
    StudyID INT PRIMARY KEY AUTO_INCREMENT,
    StudyTitle VARCHAR(200) NOT NULL,
    Description TEXT,
    Status VARCHAR(20) DEFAULT 'Active',
    StartDate DATE,
    EndDate DATE,
    ResearcherID INT NOT NULL,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MENTOR TABLE (relationship between Faculty and Researcher)
CREATE TABLE IF NOT EXISTS Mentor (
    FacultyID INT NOT NULL,
    ResearcherID INT NOT NULL,
    PRIMARY KEY (FacultyID, ResearcherID),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- EMAIL NOTIFICATION TABLE
CREATE TABLE IF NOT EXISTS EmailNotification (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    Subject VARCHAR(200) NOT NULL,
    MessageBody TEXT NOT NULL,
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ResearcherID INT NOT NULL,
    StudentID INT NOT NULL,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CITI TRAINING TABLE
CREATE TABLE IF NOT EXISTS CITITraining (
    TrainingID INT PRIMARY KEY AUTO_INCREMENT,
    CompletionDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    CertificateURL VARCHAR(255),
    ResearcherID INT NOT NULL,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- LOCATION TABLE
CREATE TABLE IF NOT EXISTS Location (
    BuildingName VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY (BuildingName, RoomNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- IN-PERSON SESSION TABLE
CREATE TABLE IF NOT EXISTS InPersonSession (
    SessionID INT PRIMARY KEY AUTO_INCREMENT,
    SessionDate DATE NOT NULL,
    Duration INT NOT NULL COMMENT 'Duration in minutes',
    AttendanceStatus VARCHAR(20) DEFAULT 'Scheduled',
    StudyID INT NOT NULL,
    StudentID INT NOT NULL,
    ResearcherID INT NOT NULL,
    BuildingName VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    FOREIGN KEY (StudyID) REFERENCES Study(StudyID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (BuildingName, RoomNumber) REFERENCES Location(BuildingName, RoomNumber) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;