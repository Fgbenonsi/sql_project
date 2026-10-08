/*
Question: What are the most optimal skills to learn for a Data Scientist based on their salary and experience?
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS number_of_jobs
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    GROUP BY 
        skills_dim.skill_id
),skills_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    number_of_jobs,
    average_salary
FROM skills_demand
INNER JOIN skills_salary ON skills_demand.skill_id = skills_salary.skill_id
WHERE number_of_jobs > 10
ORDER BY 
    average_salary DESC,
    number_of_jobs DESC
LIMIT 10;