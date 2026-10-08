/*
What are the most in-demand skills for Data Scientists in the Anywhere location?
- Identify the most in-demand skills for Data Scientists in the Anywhere location.
- Focus on job postings with specified salaries (remove nulls)
- Why? Highlighting the most in-demand skills can help job seekers identify lucrative opportunities in the
*/


SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS number_of_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere'
GROUP BY skills
ORDER BY number_of_jobs DESC
LIMIT 8;