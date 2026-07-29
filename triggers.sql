USE polycode_ai;

ALTER TABLE projects
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP;

DELIMITER $$

CREATE TRIGGER trg_project_update
BEFORE UPDATE ON projects
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_code_history
BEFORE UPDATE ON ai_responses
FOR EACH ROW
BEGIN
    INSERT INTO code_history
    (
        response_id,
        version_no,
        code_snapshot,
        updated_at
    )
    VALUES
    (
        OLD.response_id,
        (
            SELECT IFNULL(MAX(version_no),0)+1
            FROM code_history
            WHERE response_id = OLD.response_id
        ),
        OLD.generated_code,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_validate_rating
BEFORE INSERT ON feedback
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_prompt_validation
BEFORE INSERT ON ai_prompts
FOR EACH ROW
BEGIN
    IF TRIM(NEW.prompt_text) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prompt cannot be empty';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_unique_email
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM users
        WHERE email = NEW.email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_execution_log
AFTER INSERT ON ai_responses
FOR EACH ROW
BEGIN
    INSERT INTO execution_logs
    (
        response_id,
        execution_status,
        output,
        execution_time
    )
    VALUES
    (
        NEW.response_id,
        'Generated',
        'AI response generated successfully.',
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_default_chat
AFTER INSERT ON projects
FOR EACH ROW
BEGIN
    INSERT INTO ai_chats
    (
        project_id,
        chat_title,
        created_at
    )
    VALUES
    (
        NEW.project_id,
        'Default Chat',
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_project_name
BEFORE INSERT ON projects
FOR EACH ROW
BEGIN
    IF TRIM(NEW.project_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Project name cannot be empty';
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS;
ALTER TABLE projects
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE projects
ADD COLUMN updated_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP;
