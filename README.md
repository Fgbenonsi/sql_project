# Introduction
This project dives into the data job market with a focus on data science roles. It explores the top-paying jobs, the most in-demand skills, and the intersection where high demand meets high salary in data science.

Curious about the analysis? Check out the SQL queries here:[project sql folder](/project_sql/)

# Background
This project was born from a simple frustration: navigating the data science job market is overwhelming. I wanted to pinpoint which roles pay the most and which skills are genuinely in demand; so others can skip the guesswork and zero in on the best opportunities.

### Question

1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What are skills most in demand for data scientist?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?


# Tools I used
- **SQL**: the backbone of my analysis
- **PostgreSQL**: The chosen database management system
- **Visual Studio Code**: Environment for executing SQL queries

# The Analysis
### 1. Top-paying jobs
```sql
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
```
#### Findings
🔍 Key Insights
- **Leadership and seniority dominate the top tier.**
Nearly all of the highest-paying roles are senior or leadership positions—Staff Data Scientist, Head of Data Science, Director, and Distinguished Data Scientist. This signals that in data science, compensation scales sharply with seniority and scope of responsibility, not just technical skill.

- **Salaries range from $300K to $550K—a $250K spread.**
The top role (Staff Data Scientist/Quant Researcher at Selby Jennings, $550K) earns nearly double the entry point of this list ($300K). Notably, the highest-paying roles skew toward quant research and finance-adjacent work, suggesting that niche specialization commands a significant premium.

- **Remote flexibility and high pay aren't mutually exclusive.**
Every single role on this list is listed as "Anywhere" and Full-time. This challenges the assumption that top salaries require in-office presence—at least in data science, employers are willing to pay premium rates for fully remote talent.

### 2. Top-paying jobs skills
```sql
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
```
#### Findings
- **Python and SQL are the foundational skills of top earners.**
Python and SQL appear most frequently across these high-paying roles—including the two highest-paid positions (both at Selby Jennings). If you're targeting premium data science salaries, these two are non-negotiable baseline skills.

**Specialization drives the premium—finance and big data pay more.**
The top roles lean heavily into quant research, finance, and large-scale data engineering. The $375K role at Algo Capital Group, for example, demands a full big-data stack (Spark, Hadoop, Cassandra, Java). Meanwhile, the highest-paid roles combine Python/SQL with quant expertise, suggesting that pairing core skills with a high-value niche is what pushes salaries into the $500K+ range.

**AI/ML frameworks cluster in the mid-to-upper tier.**
TensorFlow, PyTorch, Keras, and scikit-learn appear repeatedly in the $300K–$320K roles (Teramind, Walmart). Cloud platforms (AWS, Azure, GCP) and orchestration tools (Kubernetes) round out the modern data science stack—showing that deep learning + cloud/deployment skills are now expected at the senior level.

### 3- In-demand skills
```sql
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
```
#### Findings
- **Python and SQL dominate by a wide margin.**
Python leads with 10,390 job postings, and SQL follows at 7,488—together they appear in far more postings than any other skill. This confirms them as the universal entry ticket to data science roles, regardless of seniority or industry.

- **There's a steep drop-off after the top two.**
R (4,674) is the only other skill above 4,000 postings, and everything below it falls under 2,600. This ~55% gap between SQL and R suggests that while the field values variety, the core stack is remarkably concentrated—master Python and SQL, and you've already covered the majority of demand.

- **Demand splits into three tiers: core, cloud/BI, and big-data.**
  
  - Core languages: Python, SQL, R

  - Cloud & visualization: AWS, Tableau, Azure

  - Big data & legacy analytics: Spark, SAS

### 4- Top-paying skills on salary
```sql
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
```
#### Findings
- **The highest-paying skills are niche, not mainstream.**
GDPR ($217K), Golang ($208K), and Atlassian ($189K) top the list—none of which are the "usual suspects" like Python or SQL. This suggests that specialized, compliance, or infrastructure-oriented skills command a premium precisely because fewer candidates have them.

- **Specialized tools beat general-purpose ones on pay.**
Skills like Neo4j (graph databases), OpenCV (computer vision), Solidity (blockchain), and Rust/Elixir (systems languages) all sit above $160K. These represent emerging or domain-specific technologies where supply of talent lags behind demand—driving salaries up.

- **Modern data infrastructure skills are quietly lucrative.**
Tools like Airflow ($157K), Redis ($162K), Cassandra ($160K), DynamoDB ($169K), and Looker ($158K) round out the list. These are production and pipeline skills—the "plumbing" of data science—and they pay well because they're essential to deploying models at scale, not just building them.

### 5. Optimal salary
```sql
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
```
#### Findings
These ten skills sit at the true sweet spot—strong pay and real demand.
Unlike the previous list (where GDPR and Solidity paid well but appeared in very few postings), every skill here balances a healthy number_of_jobs count with a six-figure-plus average salary. This is the actionable list—these skills are both worth learning and actually hireable.

- Cloud and data-warehouse skills lead the pack.
GCP (59 jobs), Snowflake (72 jobs), and BigQuery (36 jobs) all appear with salaries above $152K. This confirms that cloud data platforms are where modern data science infrastructure is headed—and employers are paying a premium for them.

- PyTorch stands out as the highest-demand skill on the list.
With 115 job postings—nearly double Snowflake—PyTorch offers the best combination of volume and pay ($152K). If you're choosing where to invest, deep learning frameworks (PyTorch) offer the widest runway of opportunity.

- Snowflake and GCP show the strongest balance—both have solid demand (72 and 59 jobs) and premium salaries ($152K–$155K). These are arguably the safest "high-ROI" skills to pursue.

- Scala, Go, and C appear here too, echoing your top-paying skills data—proving that systems/programming languages consistently deliver both demand and compensation.


# Conclusions
1. **Top-Paying Jobs**
Salaries range from $300K to $550K, and the list is dominated by senior and leadership roles—Staff, Head, Director, and Distinguished Data Scientist. The highest pay skews toward quant research and finance, and every role on the list was remote and full-time.

2. **Skills in Top-Paying Jobs**
Python and SQL are the baseline in nearly every top role. Big-data stacks (Spark, Hadoop, Cassandra, Java) add a premium, but at the very top ($500K+), domain expertise matters more than tool breadth.

3. **Most In-Demand Skills**
Python (10,390) and SQL (7,488) lead by a wide margin, with a steep drop-off after the top two. Demand splits into three tiers: core languages, cloud/BI tools, and big-data/legacy tools.

4. **Top-Paying Skills**
Niche skills pay most—GDPR ($217K), Golang ($208K), Atlassian ($189K)—alongside specialized tools like Solidity, Rust, and Neo4j. The paradox: the most in-demand skills aren't the highest paying.

5. **Optimal Skills ⭐ (high demand + high salary)**
PyTorch leads with the highest demand (115 jobs) at $152K, while Snowflake (72 jobs) and GCP (59 jobs) offer the strongest balance of both. These are the skills that are both worth learning and actually hireable.


