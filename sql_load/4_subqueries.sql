SELECT 
    *
FROM (
    SELECT *
         FROM job_postings_fact
         WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
    


---CET

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1   
)

SELECT *
FROM january_jobs;


SELECT name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact 
    WHERE job_no_degree_mention = TRUE
)

/*
Find the count of number of remote jobs postings per skills
*/


SELECT 
    COUNT(skills_job.job_id) AS number_of_remote_jobs,
    skills_job.skill_id AS skill_id,
    skills.skills AS skill_name
FROM 
    skills_job_dim AS skills_job
LEFT JOIN 
    skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE(
    
    skills_job.job_id IN (
        SELECT job_id
        FROM job_postings_fact
        WHERE job_location = 'Anywhere' AND 
        job_title_short = 'Data Analyst'
    )
)
GROUP BY skills_job.skill_id, skills.skills
ORDER BY number_of_remote_jobs DESC
LIMIT 5;




