# final-test
GADIS SYAHRANI ELHAKIM

Essay 1 - ETL
Sebagai seorang Data Engineer, kamu diberikan tugas untuk melakukan Web Scraping kumpulan berita dari suatu API.
API URL: https://berita-indo-api-next.vercel.app/api/cnn-news/teknologi
Tasks:
1. Buatlah API request untuk mendapatkan data return API berupa JSON seperti contoh di atas dengan menggunakan Python
2. Ambil value dari key ‘data’ dalam JSON, dan transformasi menjadi sebuah DataFrame. Contoh:
3. Transformasi data kolom ‘isoDate’ menjadi tipe data datetime
4. Aggregasi data berdasarkan kolom ‘creator’, serta urutkan berdasarkan jumlah berita terbanyak. Contoh:


Essay 2 - Data Warehouse
Questions
1. Please create dimension tables dim_user , dim_post , and dim_date to store
normalized data from the raw tables
2. Populate the dimension tables by inserting data from the related raw tables
3. Create a fact table called fact_post_performance to store metrics like post views and
likes over time
4. Populate the fact table by joining and aggregating data from the raw tables
5. Please create a fact_daily_posts table to capture the number of posts per user per
day
6. Also populate the fact table by joining and aggregating data from the raw tables
