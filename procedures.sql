USE polycode_ai;

DELIMITER $$

CREATE PROCEDURE sp_add_user(
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_password_hash VARCHAR(255),
    IN p_role VARCHAR(20)
)
BEGIN
    INSERT INTO users(full_name,email,password_hash,role)
    VALUES(p_full_name,p_email,p_password_hash,p_role);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_create_project(
    IN p_user_id INT,
    IN p_project_name VARCHAR(200),
    IN p_description TEXT,
    IN p_language VARCHAR(50),
    IN p_framework VARCHAR(50)
)
BEGIN
    INSERT INTO projects(user_id,project_name,description,language,framework)
    VALUES(p_user_id,p_project_name,p_description,p_language,p_framework);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_create_chat(
    IN p_project_id INT,
    IN p_chat_title VARCHAR(200)
)
BEGIN
    INSERT INTO ai_chats(project_id,chat_title)
    VALUES(p_project_id,p_chat_title);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_add_prompt(
    IN p_chat_id INT,
    IN p_prompt_text TEXT
)
BEGIN
    INSERT INTO ai_prompts(chat_id,prompt_text)
    VALUES(p_chat_id,p_prompt_text);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_add_response(
    IN p_prompt_id INT,
    IN p_generated_code LONGTEXT,
    IN p_explanation TEXT,
    IN p_model_name VARCHAR(100)
)
BEGIN
    INSERT INTO ai_responses
    (
        prompt_id,
        generated_code,
        explanation,
        model_name
    )
    VALUES
    (
        p_prompt_id,
        p_generated_code,
        p_explanation,
        p_model_name
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_add_feedback(
    IN p_user_id INT,
    IN p_response_id INT,
    IN p_rating INT,
    IN p_comments TEXT
)
BEGIN
    INSERT INTO feedback
    (
        user_id,
        response_id,
        rating,
        comments
    )
    VALUES
    (
        p_user_id,
        p_response_id,
        p_rating,
        p_comments
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_log_execution(
    IN p_response_id INT,
    IN p_status VARCHAR(50),
    IN p_output TEXT
)
BEGIN
    INSERT INTO execution_logs
    (
        response_id,
        execution_status,
        output
    )
    VALUES
    (
        p_response_id,
        p_status,
        p_output
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_update_project(
    IN p_project_id INT,
    IN p_project_name VARCHAR(200),
    IN p_description TEXT,
    IN p_language VARCHAR(50),
    IN p_framework VARCHAR(50)
)
BEGIN
    UPDATE projects
    SET
        project_name = p_project_name,
        description = p_description,
        language = p_language,
        framework = p_framework
    WHERE project_id = p_project_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_delete_project(
    IN p_project_id INT
)
BEGIN
    DELETE FROM projects
    WHERE project_id = p_project_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_project_statistics()
BEGIN
    SELECT
        p.project_id,
        p.project_name,
        COUNT(DISTINCT c.chat_id) AS total_chats,
        COUNT(DISTINCT pr.prompt_id) AS total_prompts,
        COUNT(DISTINCT ar.response_id) AS total_responses
    FROM projects p
    LEFT JOIN ai_chats c
        ON p.project_id = c.project_id
    LEFT JOIN ai_prompts pr
        ON c.chat_id = pr.chat_id
    LEFT JOIN ai_responses ar
        ON pr.prompt_id = ar.prompt_id
    GROUP BY
        p.project_id,
        p.project_name;
END$$

DELIMITER ;
