-- Create raw tables
CREATE TABLE raw_users (
user_id INT,
user_name VARCHAR(100),
country VARCHAR(50)
);
CREATE TABLE raw_posts (
post_id INT,
post_text VARCHAR(500),
post_date DATE,
user_id INT
);
CREATE TABLE raw_likes (
like_id INT,
user_id INT,
post_id INT,
like_date DATE
);
-- Insert sample data
INSERT INTO raw_users
VALUES

(1, 'john_doe', 'Canada'),
(2, 'jane_smith', 'USA'),
(3, 'bob_johnson', 'UK');
INSERT INTO raw_posts
VALUES
(101, 'My first post!', '2020-01-01', 1),
(102, 'Having fun learning SQL', '2020-01-02', 2),
(103, 'Big data is cool', '2020-01-03', 1),
(104, 'Just joined this platform', '2020-01-04', 3),
(105, 'Whats everyone up to today?', '2020-01-05', 2),
(106, 'Data science is the future', '2020-01-06', 1),
(107, 'Practicing my SQL skills', '2020-01-07', 2),
(108, 'Hows the weather where you are?', '2020-01-08', 3),
(109, 'TGI Friday!', '2020-01-09', 1),
(110, 'Any big plans for the weekend?', '2020-01-10', 2);
INSERT INTO raw_likes
VALUES
(1001, 1, 101, '2020-01-01'),
(1002, 3, 101, '2020-01-02'),
(1003, 2, 102, '2020-01-03'),
(1004, 1, 103, '2020-01-04'),
(1005, 3, 104, '2020-01-05'),
(1006, 2, 104, '2020-01-06'),
(1007, 1, 105, '2020-01-07'),
(1008, 2, 106, '2020-01-08'),
(1009, 3, 107, '2020-01-09'),
(1010, 1, 108, '2020-01-10'),
(1011, 2, 109, '2020-01-11'),
(1012, 3, 110, '2020-01-12');

--------------------------------DATA MODELING---------------------

--  dim_user
CREATE TABLE dim_user (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255),
    country VARCHAR(100),
);

-- populate dim_user
INSERT INTO dim_user (user_id, user_name, country)
SELECT
    user_id,
    user_name,
    country
FROM
    raw_users;


-- dim_post
CREATE TABLE dim_post (
    post_id SERIAL PRIMARY KEY,
    post_text TEXT,
    post_date DATE,
    user_id INT REFERENCES dim_user(user_id)
);

-- populate dim_post
INSERT INTO dim_post (post_text, post_date, user_id)
SELECT DISTINCT
    post_text,
    post_date,
    (SELECT user_id FROM dim_user WHERE dim_user.user_name = raw_posts.user_name)
FROM
    raw_posts;

-- dim_date
CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    day_of_week INT,
    month INT,
    quarter INT,
    year INT
);

-- populate dim_date
INSERT INTO dim_date (date_id, day_of_week, month, quarter, year)
SELECT DISTINCT
    date_column,
    EXTRACT(DOW FROM date_column) AS day_of_week,
    EXTRACT(MONTH FROM date_column) AS month,
    EXTRACT(QUARTER FROM date_column) AS quarter,
    EXTRACT(YEAR FROM date_column) AS year
FROM
    (
        SELECT post_date AS date_column FROM raw_posts
        UNION
        SELECT like_date AS date_column FROM raw_likes
    ) AS unique_dates;


-- create fact_post_performance
CREATE TABLE fact_post_performance (
    fact_id SERIAL PRIMARY KEY,
    post_id INT REFERENCES dim_post(post_id),
    date_id DATE REFERENCES dim_date(date_id),
    views INT,
    likes INT
);

-- populate fact_post_performance
INSERT INTO fact_post_performance (post_id, date_id, views, likes)
SELECT
    dp.post_id,
    dd.date_id,
    COUNT(DISTINCT rv.user_id) AS views,
    COUNT(DISTINCT rl.user_id) AS likes
FROM
    dim_post dp
JOIN
    dim_date dd ON dp.post_date = dd.date_id
LEFT JOIN
    raw_views rv ON dp.post_id = rv.post_id AND rv.view_date = dd.date_id
LEFT JOIN
    raw_likes rl ON dp.post_id = rl.post_id AND rl.like_date = dd.date_id
GROUP BY
    dp.post_id, dd.date_id;


-- create fact_daily_posts
CREATE TABLE fact_daily_posts (
    fact_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES dim_user(user_id),
    date_id DATE REFERENCES dim_date(date_id),
    posts_count INT
);

-- populate fact_daily_posts
INSERT INTO fact_daily_posts (user_id, date_id, posts_count)
SELECT
    du.user_id,
    dp.post_date,
    COUNT(dp.post_id) AS posts_count
FROM
    dim_user du
JOIN
    dim_post dp ON du.user_id = dp.user_id
GROUP BY
    du.user_id, dp.post_date;
