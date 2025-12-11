-- Tickets per severity
SELECT severity, COUNT(*) AS total_tickets
FROM Tickets
GROUP BY severity
ORDER BY total_tickets DESC;

-- Tickets per category
SELECT filed_against, COUNT(*) AS total_tickets
FROM Tickets
GROUP BY filed_against
ORDER BY total_tickets DESC;

-- Avg allowed days by requester seniority
SELECT requester_seniority, AVG(priority_max_day) AS avg_allowed_days
FROM Tickets
GROUP BY requester_seniority;

-- Critical and major tickets with tightest deadlines
SELECT *
FROM Tickets
WHERE severity IN ('3 - Major')
ORDER BY priority_max_day ASC;


-- Potential SLA Risks
SELECT ticket_id, filed_against, severity, priority_type, max_day,
FROM Tickets
WHERE
    -- severity 3+ or priority 3+ 
    CAST(SUBSTR(severity, 1, INSTR(severity, ' ') - 1) AS INT)   >= 3
    OR CAST(SUBSTR(priority_type, 1, INSTR(priority_type, ' ') - 1) AS INT) >= 3
  AND max_day <= 2
ORDER BY max_day ASC;

-- Severity distribution per system
SELECT filed_against, severity, COUNT(*) AS total_tickets
FROM Tickets
GROUP BY filed_against, severity
ORDER BY filed_against, severity;

-- Ranking "risk score" for tickets 
--> higher severity, higher priority, and lower max_day = more urgent = risk score.
SELECT ticket_id, filed_against, severity, priority_type, max_day,
    -- numeric versions
    CAST(SUBSTR(severity, 1, INSTR(severity, ' ') - 1) AS INT)   AS severity_level,
    CAST(SUBSTR(priority_type, 1, INSTR(priority_type, ' ') - 1) AS INT) AS priority_level,
    -- simple risk score: severity + priority, lower max_day adds risk
    (CAST(SUBSTR(severity, 1, INSTR(severity, ' ') - 1) AS INT)
     + CAST(SUBSTR(priority_type, 1, INSTR(priority_type, ' ') - 1) AS INT)
     + CASE WHEN max_day <= 1 THEN 2
            WHEN max_day <= 3 THEN 1
            ELSE 0
       END) AS risk_score
FROM Tickets

ORDER BY risk_score DESC, max_day ASC;
