CREATE OR REPLACE VIEW vw_user_projects AS
SELECT
    u.user_id,
    u.full_name,
    u.email,
    p.project_id,
    p.project_name,
    p.language,
    p.framework,
    p.created_at
FROM users u
JOIN projects p
ON u.user_id = p.user_id;

CREATE OR REPLACE VIEW vw_project_chats AS
SELECT
    p.project_name,
    c.chat_id,
    c.chat_title,
    c.created_at
FROM projects p
JOIN ai_chats c
ON p.project_id = c.project_id;
CREATE OR REPLACE VIEW vw_prompt_response AS
SELECT
    pr.prompt_id,
    pr.prompt_text,
    ar.response_id,
    ar.model_name,
    ar.response_time
FROM ai_prompts pr
JOIN ai_responses ar
ON pr.prompt_id = ar.prompt_id;
CREATE OR REPLACE VIEW vw_generated_code AS
SELECT
    ar.response_id,
    LEFT(ar.generated_code,300) AS code_preview,
    ar.model_name,
    ar.response_time
FROM ai_responses ar;
CREATE OR REPLACE VIEW vw_code_versions AS
SELECT
    h.history_id,
    h.response_id,
    h.version_no,
    h.updated_at
FROM code_history h;
CREATE OR REPLACE VIEW vw_execution_logs AS
SELECT
    l.log_id,
    l.response_id,
    l.execution_status,
    l.execution_time
FROM execution_logs l;
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';
SELECT * FROM vw_user_projects;
SELECT * FROM vw_project_chats;
SELECT * FROM vw_prompt_response;
SELECT * FROM vw_generated_code;
SELECT * FROM vw_code_versions;
SELECT * FROM vw_execution_logs;
SELECT * FROM vw_feedback;
SELECT * FROM vw_project_statistics;
SELECT * FROM vw_average_rating;
SELECT * FROM vw_recent_activity;
