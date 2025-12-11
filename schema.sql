CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    request_id INT,
    requester_seniority VARCHAR(50),
    filed_against VARCHAR(100),
    ticket_type VARCHAR(50),
    severity VARCHAR(50),
    priority_type VARCHAR (50),
    max_day INT
);