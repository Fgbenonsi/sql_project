/*
Question: What are the top paying job skills for Data Scientists in the Anywhere location?
- Identify the top paying job skills for Data Scientists in the Anywhere location.
- Why? Highlighting the top paying job skills can help job seekers identify lucrative opportunities in the
*/


WITH top_paying_job AS(
    SELECT 
        job_id,
        job_title,
        salary_year_avg AS salary,
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
)

SELECT
    top_paying_job.*,
    skills
FROM top_paying_job
INNER JOIN skills_job_dim ON top_paying_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary DESC;