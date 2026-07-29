
DROP DATABASE IF EXISTS polycode_ai;


CREATE DATABASE polycode_ai;

-- Use database
USE polycode_ai;

CREATE TABLE users (

    user_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    password_hash VARCHAR(255) NOT NULL,

    role ENUM('Developer','Admin') DEFAULT 'Developer',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
CREATE TABLE projects (

    project_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    project_name VARCHAR(200) NOT NULL,

    description TEXT,

    language VARCHAR(50),

    framework VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE

);
CREATE TABLE ai_chats (

    chat_id INT AUTO_INCREMENT PRIMARY KEY,

    project_id INT NOT NULL,

    chat_title VARCHAR(200),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(project_id)
    REFERENCES projects(project_id)
    ON DELETE CASCADE

);
CREATE TABLE ai_prompts (

    prompt_id INT AUTO_INCREMENT PRIMARY KEY,

    chat_id INT NOT NULL,

    prompt_text TEXT NOT NULL,

    prompt_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(chat_id)
    REFERENCES ai_chats(chat_id)
    ON DELETE CASCADE

);
CREATE TABLE ai_responses (

    response_id INT AUTO_INCREMENT PRIMARY KEY,

    prompt_id INT NOT NULL,

    generated_code LONGTEXT,

    explanation TEXT,

    model_name VARCHAR(100),

    response_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(prompt_id)
    REFERENCES ai_prompts(prompt_id)
    ON DELETE CASCADE

);
CREATE TABLE files (

    file_id INT AUTO_INCREMENT PRIMARY KEY,

    project_id INT NOT NULL,

    file_name VARCHAR(200),

    file_type VARCHAR(20),

    file_size INT,

    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(project_id)
    REFERENCES projects(project_id)
    ON DELETE CASCADE

);
