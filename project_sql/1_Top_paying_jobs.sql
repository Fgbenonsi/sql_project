/*
Question: What are the top paying data science jobs in the world?
- Identify the 10 highest paying data science jobs in the world.
- Focus on job postings with specified salaries (remove nulls)
- Why? Higghlighting the top paying jobs can help job seekers identify lucrative opportunities in the region and assist employers in understanding competitive salary ranges for data analyst positions.
*/

SELECT 
    job_id,
    job_postings_fact.company_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg AS salary,
    job_posted_date:: DATE AS posted_date,
    company_dim.name AS company_name
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id    
WHERE 
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY 
    salary DESC
LIMIT 10
