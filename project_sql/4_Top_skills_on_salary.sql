/*
Question: What are the most in-demand skills for Data Scientists based on salary?
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;


/*
- Governance and production skills pay top dollar — GDPR tops the list (~$217.7K), while Go/Golang (~$208.8K), Rust, C, and Elixir rank high. The premium is on data scientists who can handle compliance and build production-grade systems, not just run models.

- Niche and specialized tools command a bump — Neo4j, DynamoDB, Cassandra, Redis, Solidity, OpenCV, and Selenium all sit in the $160K–$180K range, suggesting that expertise in graph/NoSQL databases, blockchain, computer vision, and automation is well rewarded.

- BI, MLOps, and enterprise tooling remain valuable — MicroStrategy, Qlik, Looker, Tidyverse, Airflow, and DataRobot all appear, showing that dashboarding, pipeline orchestration, and AutoML skills still carry strong salaries alongside core data science work.

[
  {
    "skills": "gdpr",
    "average_salary": "217738"
  },
  {
    "skills": "golang",
    "average_salary": "208750"
  },
  {
    "skills": "atlassian",
    "average_salary": "189700"
  },
  {
    "skills": "selenium",
    "average_salary": "180000"
  },
  {
    "skills": "opencv",
    "average_salary": "172500"
  },
  {
    "skills": "neo4j",
    "average_salary": "171655"
  },
  {
    "skills": "microstrategy",
    "average_salary": "171147"
  },
  {
    "skills": "dynamodb",
    "average_salary": "169670"
  },
  {
    "skills": "php",
    "average_salary": "168125"
  },
  {
    "skills": "tidyverse",
    "average_salary": "165513"
  },
  {
    "skills": "solidity",
    "average_salary": "165000"
  },
  {
    "skills": "c",
    "average_salary": "164865"
  },
  {
    "skills": "go",
    "average_salary": "164691"
  },
  {
    "skills": "datarobot",
    "average_salary": "164500"
  },
  {
    "skills": "qlik",
    "average_salary": "164485"
  },
  {
    "skills": "redis",
    "average_salary": "162500"
  },
  {
    "skills": "watson",
    "average_salary": "161710"
  },
  {
    "skills": "rust",
    "average_salary": "161250"
  },
  {
    "skills": "elixir",
    "average_salary": "161250"
  },
  {
    "skills": "cassandra",
    "average_salary": "160850"
  },
  {
    "skills": "looker",
    "average_salary": "158715"
  },
  {
    "skills": "slack",
    "average_salary": "158333"
  },
  {
    "skills": "terminal",
    "average_salary": "157500"
  },
  {
    "skills": "airflow",
    "average_salary": "157414"
  },
  {
    "skills": "julia",
    "average_salary": "157244"
  }
]

*/