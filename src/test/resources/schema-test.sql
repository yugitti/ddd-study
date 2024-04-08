CREATE TABLE IF NOT EXISTS Addresses (
    address_id SERIAL PRIMARY KEY,
    prefectures VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    line1 VARCHAR(255) NOT NULL,
    line2 VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Users (
    user_id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    birthday DATE NOT NULL,
    gender VARCHAR(255) NOT NULL, -- ENUMの代わりにVARCHARを使用
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);