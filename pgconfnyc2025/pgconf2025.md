---
marp: true
theme: default
class: invert
size: 16:9
paginate: true
footer: 'Multitenancy Patterns'
style: |
    footer {
      color:#bbb;
      font-family:Red Hat, sans-serif;
      font-size:0.6em;
    }
    * {
      font-family:Red Hat, sans-serif;
    }
    section::after {
        content: 'Slide ' attr(data-marpit-pagination) ' of ' attr(data-marpit-pagination-total);
    color:#bbb;
    font-family:Avenir, sans-serif;
    font-size:0.6em;
    }

    .corner-label {
      position: fixed;
      bottom: 200px;
      right: 0;
      background: lightgreen;
      color: green;
      padding:10px;
      font-weight: bold;
      font-size:0.8em;
      transform: rotate(-30deg);
      transform-origin: bottom right;
      border: 10px dashed green;
    }

    li .list-item {
      color:#fff;
      padding:10px;
    }

    :root {
      --theme-mistake-1:  #1E3A8A; /* Indigo-900 */;
      --theme-mistake-2: #10B981; /* Emerald-500 */
      --theme-mistake-3:  #334155; /* Slate-800 */
      --theme-mistake-4: #7C3AED; /* Violet-600 */
      --theme-mistake-5:  #D97706; /* Amber-600 */
      --theme-mistake-6:  #581C87; /* Purple-900 */
      --theme-mistake-7:  #0F172A; /* Gray-900 */
      --theme-mistake-8:  #B91C1C; /* Red-700 */
      --theme-mistake-9:  #4D7C0F; /* Lime-800 */
      --theme-mistake-10:  #BE185D; /* Pink-700 */
    }

    .mistake-1 { background-color: var(--theme-mistake-1); }
    .mistake-2 { background-color: var(--theme-mistake-2); }
    .mistake-3 { background-color: var(--theme-mistake-3); }
    .mistake-4 { background-color: var(--theme-mistake-4); }
    .mistake-5 { background-color: var(--theme-mistake-5); }
    .mistake-6 { background-color: var(--theme-mistake-6); }
    .mistake-7 { background-color: var(--theme-mistake-7); }
    .mistake-8 { background-color: var(--theme-mistake-8); }
    .mistake-9 { background-color: var(--theme-mistake-9); }
    .mistake-10 { background-color: var(--theme-mistake-10); }

    .footnote {
      position:absolute;
      bottom:10%;
      color:#bbb;
    }
    .footnote ol, .footnote ul {
      font-size:20px;
    }
    .top-bar {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 60px;
      background-color: #333;
      color: white;
      display: flex;
      z-index: 1000;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }
    .top-bar div {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      border-left: 1px solid #444;
    }
    .top-bar div:first-child {
      border-left: none;
    }
    .active {
      background-color: #555;
      font-weight: bold;
      cursor: pointer;
    }
    .inactive {
      color: #888;
      pointer-events: none;
    }
    .content {
      padding-top: 70px;
    }
    .corner-fixes {
      background-color:#111;
      padding:5px 10px;
      margin:2px;
    }
    .highlight {
      line-height:130%;
      padding:2px;
      margin:2px;
      background-color:yellow;
      color:#000;
    }
    

---
<!-- _color: #fff; -->
<!-- _backgroundColor: #fff; -->
<!-- _backgroundImage: linear-gradient(75deg, #000000 30%, #529FD4 55%, #fff 77%); -->

<style scoped>
  section {
    padding:100px;
  }
h1 { font-size:2.3em;}
a { color: #fff; }
section::after {
    color:#fff;
    }
img.img {
  float:right;
  max-width:250px;

}
.stack-vertical {
  width:300px;
  float:right;
  margin:0;
  padding:0;
}
.stack-vertical img {
  display:block;
  margin:0;
  padding:0;   
  width:100%;
  max-width:300px;
  position:relative;
  top:-70px;
}
.stack-vertical .img {
  max-width:90%;
}
.stack-vertical .img.qr {
  max-width:100%;
  position:relative;
  left:10px;
  top:-10px;
}
.stack-vertical .img.rails {
  position:relative;
  left:-30px;
  top:-20px;
}
.stack-vertical .img.db {
  max-width:50%;
  position:relative;
  left:-80px;
  top:-60px;
}
</style>



# Multitenancy Patterns in Community PostgreSQL

<code style="font-size:2em;">🌐 <a href="https://bit.ly/XXX">bit.ly/XXX</a></code>

---
<style scoped>
  img.rc17 {
    position:absolute;
    top:50px;
    right:30px;
    max-width:600px;
  }
  img.rw24 {
    position:relative;
    bottom:220px;
    left:620px;
    max-width:400px;
  }
</style>

#### Context for talk
- Around 10 Postgres instances with single DB
- Mix of single-tenant and multi-tenant
- Some with barely any use, over-provisioned, costly, how can we fix this?

---
<style scoped>
  img.rc17 {
    position:absolute;
    top:50px;
    right:30px;
    max-width:600px;
  }
  img.rw24 {
    position:relative;
    bottom:50px;
    left:620px;
    max-width:400px;
  }
</style>

#### My Background
- Backend web developer, mostly Ruby on Rails
- Book author: High Performance PostgreSQL for Rails (2024)
- Honored with a Postgres coin in 2024!
- Postgres Specialist!

<img class="rw24" src="images/collage-railsworld-2024.jpg"/>

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
  section {
    background-color:#666;
  }
  li .list-item {
    width:275px;
    font-size: 40px;
    margin:10px 0;
    padding: 0 25px;
  }
  .group-container {
      display: flex;
      align-items: stretch;
      position: relative;
      border:1px solid;
    }

    .group-label {
      writing-mode: vertical-rl;
      transform: rotate(180deg);
      background-color: #f0f0f0;
      color: #333;
      font-weight: bold;
      padding: 0.5rem;
      border-right: 1px solid #333;
      text-align: center;
    }

    .group-content {
      flex: 1;
    }
</style>

<div class="top-bar">
  <div class="active">Forming</div>
  <div class="active">Scaling</div>
  <div class="active">Optimizing</div>
</div>

<div style="display: flex; gap: 2rem;">
  <div style="flex: 1; margin: -30px px; border-radius: 5px;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class='list-item mistake-1'>Single Big DB</div></li>
      <li><div class='list-item mistake-2'>Composite Primary Keys</div></li>
      <li><div class="list-item mistake-3">Tenant Data Logs</div></li>
      <li><div class="list-item mistake-4">Tenant Query Logs</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class="list-item mistake-5">Row Level Security</div></li>
      <li><div class="list-item mistake-6">Partitioned Orders</div></li>
      <li><div class="list-item mistake-7">4. Excessive Data Access</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none; margin:10px 10px 10px 10px;padding:0;">
    <li><div class="list-item mistake-8">3. Missing Data Archival</li>
    <li><div class="list-item mistake-9">2. Missing DB Maintenance</div></li>
    <li><div class="list-item mistake-10">1. Rejecting Mechanical Sympathy</div></li>
    </ul>
  </div>
</div>

<div class='corner-label'>Costs 👀 are here 💵 💵 💵</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Opportunities and Challenges</h2>

- Opportunities: Cost savings, fewer instances
- Opportunities: Less operational complexity, fewer instances
- Opportunities: Improved monitoring, fewer instances
- Challenges: More shared compute resources
- Challenges: Shared Postgres resources (Autovacuum, shared_buffers)
- Challenges: Lacking tenant-scoped monitoring

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Single Big Instance</h2>

- Push limits of (managed) Postgres vertical instance scaling
- GCP: 96 vCPUs, 624 GB
- MS Azure: 96 vCores, 672 GiB
- AWS RDS most CPUs: [db.r8g.48xlarge](https://instances.vantage.sh/aws/rds/db.r8g.48xlarge?currency=USD), 192 vCPUs, 1536GB (1.5 TiB) memory, 210K annually on-demand (17.5k/month), 140K 1-year reservation

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Primary Keys</h2>

- Primary key type decisions: UUID or integer (sequences)
- Single integers, or multiple values (composite primary keys)
- Let's try out CPKs
- Let's review caveats

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Primary Keys</h2>

- In Postgres 17 we can use native UUID V7 primary keys
- This helps us later if we distribute our tables or rows (sharding)

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Tenant Data Logs</h2>

- "Data": Inserts, updates, and deletes
- Create a Suppliers `supplier_data_changes` table


---
<style scoped>
  section {
    font-size: 2.1em;
  }
</style>

<pre style="overflow:hidden;font-size:0.6em;">
~/P/rideshare (chore/anchor_migrations)> cat anchor_migrations/20250623173850_anchor_migration.sql
-- Generated by anchor_migrations 0.1.0
--
-- Examples:
<span class="highlight">CREATE INDEX IF NOT EXISTS</span> 👈
idx_trips_created_at ON trips (created_at);
</pre>

<pre style="overflow:hidden;font-size:0.6em;">
~/P/rideshare (chore/anchor_migrations)> bundle exec anchor lint
warning[require-concurrent-index-creation]: During normal index creation, table updates are blocked,
but reads are still allowed.

 --> anchor_migrations/20250623173850_anchor_migration.sql:4:1

  |
4 | / CREATE INDEX IF NOT EXISTS
5 | | idx_trips_created_at ON trips (created_at);
  | |__________________________________________
  |
  <span class="highlight">= help: Use `CONCURRENTLY` to avoid blocking writes.</span> 👈

Find detailed examples and solutions for each rule at https://squawkhq.com/docs/rules
Found 1 issue in 1 file (checked 1 source file)
</pre>


---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>

![bg 90%](images/accelerate.jpg)
![bg 90%](images/dora-1-small.jpg)
![bg contain 95%](images/dora-2-small.jpg)

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-2);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #9—DB Inexperience

---
<style scoped>
  
  section {
    margin:0;
    padding:0;
  }  
  .group-container {
    display: flex;
    align-items: stretch;
    position: relative;
    margin: 1.5rem;
  }
  .group-label {
    writing-mode: vertical-rl;
    transform: rotate(180deg);
    background-color: #f0f0f0;
    color: #333;
    font-weight: bold;
    padding: 0.5rem;
    border-right: 1px solid #333;
    text-align: center;
    min-width: 1.5rem;
    white-space:nowrap;
  }
  .group-content {
    padding-left: 1rem;
    flex: 1;
  }
</style>

<div class="group-container">
    <div class="group-label">Ruby on Rails</div>
    <div class="group-content">

## Active Record ORM
- Object-orientation, inheritance, classes, methods, Ruby code
- ORM, query generation gems. Abstraction, reusability, portability.

  </div>
</div>

<span style="margin:0px 10px 0px 50px;">🔄 Object–relational mismatch<sup><a href="#footnote-2-1">13</a></sup></span>

<div class="group-container">
    <div class="group-label">Database</div>
    <div class="group-content">

## Relational Database
- Data access, SQL, relations, indexes, execution plans, normalization, caches
- Pages, buffers, locks, MVCC & bloat in PostgreSQL

  </div>
</div>

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-2);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #9—DB Inexperience

- Not hiring DB specialists or DBAs
- Not using SQL in application code or business intelligence
- Not reading and interpreting query execution plans
- Not using *cardinality*, *selectivity*, or execution plan `BUFFERS` info in designs
- Adding indexes haphazardly (over-indexing)<sup><a href="#footnote-2-2">14</a></sup>
- Choosing schema designs with poor performance

<div class="corner-label">💵 Server costs, Developer time</div>

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-2);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #9—DB Inexperience <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>


- Hire experience: DB specialists, DBAs, and consultants
- Grow experience: books, courses, conferences, communities
- Create a production clone instance for experimentation. Use it in your workflow.
- Use concepts of *pages*, buffers, latency, *selectivity*, *cardinality*, *correlation*, and *locality* to improve your designs
- Avoid performance-unfriendly designs like random UUID<sup><a href="#footnote-2-3">15</a></sup> primary keys

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-2);
}
a { color: #fff; }
</style>

## Row versions (Tuples), MVCC, transactions
Which Spiderman is "live" and "dead"?

![bg contain right 90%](images/spiderman.png.webp)

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-2);
}
a { color: #fff; }
</style>

## Fixed-size 8KB Pages
How is table and index data stored and how does that affect latency?

![bg contain right 95%](images/records-small.jpg)

---

![bg 90%](images/high-perf-pg.jpg)
![bg 90%](images/query-opt.jpg)
![bg 90%](images/sql-perf-explained.jpg)
![bg 90%](https://i.imgur.com/zl8jahW.jpg)

---
<style scoped>
  section {
    background:#000;
    color:#fff;
  }
</style>

## [Mastering Postgres](masteringpostgres.com)
## [High Performance SQLite](highperformancesqlite.com)

![bg right 80% vertical](images/mastering-pg-small.jpg)

## [Scaling Postgres](https://scalingpostgres.com/courses)
- PostgreSQL Performance Starter Kit (*Free*)
- Postgres Performance Demystified (*Free*)
- Ludicrous Speed


![bg right 70%](images/scaling-pg-small.jpg)

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-3);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #8—Speculative DB Design
- Avoiding beneficial database constraints *today* due to speculation about *tomorrow*
- Doubting ability to evolve the schema design in the future
- *Not* using third normal form normalization ([3NF](https://en.wikipedia.org/wiki/Third_normal_form)) by default
- Avoiding *all* forms of denormalization, even for use cases like multi-tenancy<sup><a href="#footnote-3-1">16</a></sup>

<div class="corner-label">💵 Data bugs, high maintenance costs</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-3);
}
a { color: #fff; }
.footnote {
      position:absolute;
      bottom:7%;
      color:#bbb;
    }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #8—Speculative DB Design <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Use all available constraints for data consistency, integrity, quality (CORE: *constraint-driven*<sup><a href="#footnote-3-2">17</a></sup>)
- Create matching DB constraints for code validation. Match PK/FK types. Use *database_consistency* gem.<sup><a href="#footnote-3-3">18</a></sup>
- Normalize by default. Eliminate duplication. Design for today, but anticipate growth in data and query volume.
- Use denormalization sometimes, for example tenant identifier columns

---
<style scoped>
  section {
    font-size:2.1em;
  }
</style>

<pre>
-[ RECORD 1 ]----------------+----------
table_schema                 | rideshare
table_count                  | 10
column_count                 | 65
not_null_count               | 54
pk_count                     | 10
fk_count                     | 8
unique_count                 | 0
check_count                  | 57
not_null_ratio               | 0.83
pk_per_table                 | 1.00
<span class="highlight">fk_per_table                                           | 0.80</span> 👈
check_per_column             | 0.88
total_constraints_per_column | 1.15
</pre>
[table_and_constraints_stats_ratios.sql](https://github.com/andyatkinson/pg_scripts/pull/22)

---

![database consistency](images/dbconcheck.jpg)
<small>*database_consistency* gem</small>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-4);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #7—Missing DB Monitoring
- Not logging slow queries or collecting query statistics and execution plans
- Not using the `BUFFERS` information in PostgreSQL execution plans
- Spending time finding application source code locations for SQL queries
- Not monitoring critical background processes like Autovacuum

<div class="corner-label">💵 Triage, incident resolution</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-4);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="active">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #7—Missing DB Monitoring <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Log and store SQL query source code line numbers,<sup><a href="#footnote-4-1">19</a></sup> using Query Logs (*SQLCommenter* formatted), visibile in Rails log
- Collect query execution plans, manually or automatically with *auto_explain*<sup><a href="#footnote-4-2">20</a></sup>
- Reduce `BUFFERS` counts in execution plans<sup><a href="#footnote-4-3">21</a></sup> to reduce latency
- Observe database processes. Postgres: *pg_stat_statements*, *PgHero*, *PgAnalyze*, *PgBadger*
- MySQL: *Percona Monitoring and Management (PMM)*, *Oracle Enterprise Manager for MySQL*,<sup><a href="#footnote-4-4">22</a></sup> SQLite: *SQLite Database Analyzer*<sup><a href="#footnote-4-5">23</a></sup>

---
<style scoped>
  section {
    font-size:2.5em;
  }
  pre {
    overflow:hidden;
  }
</style>

<pre>
ID: 7
Account: my-rideshare-account
Database: rideshare_development
Query ID: 3517660050859089705
Query Text w/o annotations: SELECT "users".* FROM "users" \
  WHERE "users"."id" = $1 LIMIT $2
Annotations: <span class="highlight">controller=trip_requests
action=create
application=Rideshare
source_location=app/models/trip.rb:6:in `rider'</span> 👈
Main Command: SELECT
FROM table: "users"
WHERE clause: "users"."id" = $1
</pre>

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-5);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #6—ORM Pitfalls
- Performing unnecessary, costly ORM queries like `COUNT(*)`, `ORDER BY`
- Using non-scalable query patterns like huge `IN` lists<sup><a href="#footnote-5-2">25</a></sup>
- Not restricting column access, always using `SELECT *`<sup><a href="#footnote-5-1">24</a></sup>
- Using inefficient ORM pagination
- Not using ORM caches

<div class="corner-label">💵 Overprovisioned, inefficient queries</div>

---
<style scoped>
  footer {
    color:#000;
  }
  section::after {
    color:#000;
  }
section {
  color:#fff;
  background-color: var(--theme-mistake-5);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #6—ORM Pitfalls <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Put your app on a SQL Query Diet<sup><a href="#footnote-5-3">26</a></sup> (find sources<sup><a href="#footnote-4-1">19</a></sup>)
- Limit columns to what's needed: `select()`, `pluck()`, better use of indexes
- Refactor huge `IN`<sup><a href="#footnote-5-2">25</a></sup> lists. Use a join, `VALUES`, or `ANY`+`ARRAY` (Postgres)
- Use endless (*keyset*) pagination (*pagy* gem<sup><a href="#footnote-5-3">26</a></sup>) over ORM `LIMIT`/`OFFSET`
- Use the prepared statement cache<sup><a href="#footnote-5-5">28</a></sup> to skip repeated parsing/planning
- Skip unnecessary count queries by using the *counter cache*<sup><a href="#footnote-5-6">29</a></sup>
- Use `size()` over `count()` and `length()`

---
<style scoped>
section {
  font-size:1.7em;
}
</style>

```rb
books = Book.includes(:author).limit(10)
```

```sql
-- Generated SQL from Active Record "includes"
SELECT books.* FROM books LIMIT 10;

SELECT authors.* FROM authors
  WHERE authors.id IN (1,2,3,4,5,6,7,8,9,10);
```

```sql
-- Alternative SQL using ANY + ARRAY
SELECT books.*
FROM books
WHERE author_id = ANY(
  SELECT UNNEST(ARRAY(
    SELECT id
    FROM authors
    WHERE id <= 10
  ))
);
```

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-6);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #5—DDL Fear
- Creating code workarounds to avoid schema evolution and data backfills
- Using blocking DDL due to not understanding exclusive locks and queueing
- Not linting DDL migrations for safety
- Not practicing big DDL changes on a production DB clone
- Not auto-canceling contending DDL operations (Postgres, MySQL, SQLite)


<div class="corner-label">💵 Longer cycles, high maintenance</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-6);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #5—DDL Fear <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Practice DDL changes on a production clone with timing. Understand locks taken and access patterns.
- Use multi-step non-blocking DDL. `ignored_columns`.<sup><a href="#footnote-6-1">32</a></sup> `INVALID` `CHECK` constraint before `NOT NULL`
- Safety-lint DDL. Active Record & PostgreSQL *strong_migrations,*<sup><a href="#footnote-1-9">9</a></sup> (MySQL/MariaDB) *online_migrations*,<sup><a href="#footnote-6-2">33</a></sup> *Squawk*<sup><a href="#footnote-1-9-1">10</a></sup> for SQL
- Learn about locks and conflicts using `pglocks.org`
- Auto-cancel DDLs that fail lock acquisition with a low `lock_timeout`. Retry.

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-7);
}
a { color: #fff; }
</style>

## ❌ Mistake #4—Excessive Data Access

🔲 8 grocery bags in 1 trip
☑️ 2 trips of 4 bags each

![bg right vertical](images/groceries1.jpg)
![bg right vertical](images/groceries2.jpg)

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-7);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

## ❌ Mistake #4—Excessive Data Access
- Querying and retrieving huge sets, 10K+ rows, making users wait
- Ineffective filtering and indexing on *low cardinality* columns
- Missing indexes on *high cardinality* columns or foreign keys for filtering
- Not using advanced indexing strategies or index types
- Performing slow aggregate queries (`SUM`, `COUNT`) causing users to wait
- Not breaking up big tables using table partitioning

<div class="corner-label">💵 Server costs, user experience</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-7);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="active">Scaling</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>❌ Mistake #4—Excessive Data Access <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Work with small sets of data.<sup><a href="#footnote-7-1">34</a></sup> Restructure queries to select fewer rows, columns, and perform fewer joins.
- Add "missing indexes"<sup><a href="#footnote-7-2">35</a></sup> on high cardinality columns,<sup><a href="#footnote-7-3">38</a></sup> try out *pganalyze_lint*<sup><a href="#footnote-7-2-1">36</a></sup> (and *hypopg*<sup><a href="#footnote-7-2-2">37</a></sup>)
- Use advanced indexing like multicolumn, partial indexes, GIN, GiST.
- Pre-calculate aggregates using *rollup* gem,<sup><a href="#footnote-7-4">39</a></sup> create denormalized materialized views, manage using *scenic* gem<sup><a href="#footnote-7-5">40</a></sup>
- Migrate huge tables to partitioned tables<sup><a href="#footnote-7-6">41</a></sup> for improved performance and maintenance

---
<style scoped>
section {
  font-size:2.5em;
}
pre {
  overflow:hidden;
}
</style>

<pre>
<span class="highlight">pganalyze_lint</span> --dbname rideshare_development \
  --host localhost --username andy -v \
  <span class="highlight">check -t rideshare.users</span>

Index Selection Settings:
{"Options":{"Goals":[{"Name":"Minimize Total Cost","Tolerance":0.1},
{"Name":"Minimize Number of Indexes"}]}}

<span class="highlight">Missing indexes found:</span> 👈
<span class="highlight">CREATE INDEX ON rideshare.users USING btree (type)</span> 👈</pre>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-8);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

## ❌ Mistake #3—Missing Data Archival
- Storing a significant proportion of data in tables and indexes that's never queried
- Capturing high growth data using gems like *public_activity*,<sup><a href="#footnote-8-1">42</a></sup> *papertrail*,<sup><a href="#footnote-8-2">43</a></sup> *audited*,<sup><a href="#footnote-8-3">44</a></sup> or *ahoy*,<sup><a href="#footnote-8-4">45</a></sup> and not archiving unneeded data
- Not archiving app data from churned customers, retired features, or soft deleted rows
- Performing resource-intensive massive `DELETE` operations

<div class="corner-label">💵 Server costs, user experience</div>

---

![bg 80%](images/big-deletes.jpg)

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-8);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

<h2>❌ Mistake #3—Missing Data Archival <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Archive **ALL** data that's not regularly queried!
- Shrink a table using *copy swap drop*<sup><a href="#footnote-8-5">46</a></sup>
- Use partition-friendly gems like *logidze* gem<sup><a href="#footnote-8-6">47</a></sup> or partition your big tables, making necessary Rails compatibility changes<sup><a href="#footnote-8-7">48</a></sup>
- Archive app data from churned customers, soft deleted rows, and retired features (discover with *Coverband*<sup><a href="#footnote-8-8">49</a></sup>)
- Replace massive `DELETE` operations by migrating to a partitioned table, unlock ability to `DETACH CONCURRENTLY` instead of `DELETE`

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-9);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

## ❌ Mistake #2—Missing DB Maintenance
- Running unsupported versions of Postgres, MySQL, or SQLite
- Not monitoring or fixing heavily fragmented tables and indexes
- Leaving Autovacuum and other maintenance parameters untuned
- Not removing unneeded database objects

<div class="corner-label">💵 Poor performance, security risk, UX</div>

---

![bg 80%](images/unneeded.jpg)

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-9);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>


<h2>❌ Mistake #2—Missing DB Maintenance <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Upgrade your database. Postgres *why upgrade*?<sup><a href="#footnote-9-1">50</a></sup> Tune Autovacuum for your workload.
- *Prune and Tune* indexes,<sup><a href="#footnote-9-2">51</a></sup> use *pg_dba*<sup><a href="#footnote-9-3">52</a></sup> for psql, *rails_best_practices* gem
- Drop unneeded tables, columns, constraints, indexes, functions, triggers, and extensions
- Rebuild fragmented tables (pg_repack, pg_squeeze,<sup><a href="#footnote-9-4">53</a></sup> `VACUUM FULL`)
- Reindex fragmented indexes (`REINDEX CONCURRENTLY`)
- *Maintainable...Databases?* podcast<sup><a href="#footnote-9-4">53</a></sup> 🎧

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-10);
}
a, blockquote { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

## *Mechanical Sympathy*
> *Mechanical sympathy is when you use a tool or system with an understanding of how it operates best.*<sup><a href="#footnote-9-5-1">55</a></sup>


---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-10);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

## ❌ Mistake #1—Rejecting Mechanical Sympathy
- Using high-churn designs (updates and deletes) for Postgres that don't work well with tuples, MVCC, and Autovacuum
- Over-using limited CPU, memory, and IO from inefficient reads and writes
- Inefficient generated queries from gems like *jsonapi-resources*,<sup><a href="#footnote-9-5-2">56</a></sup> *graphql-ruby*,<sup><a href="#footnote-9-5-3">57</a></sup> *ActiveAdmin*<sup><a href="#footnote-9-5-4">58</a></sup>
- Allowing lazy loading and N+1s
- Not preventing excessively long queries, idle transactions

<div class="corner-label">💵 ALL the costs</div>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-10);
}
a { color: #fff; }
</style>

<div class="top-bar">
  <div class="inactive">Forming</div>
  <div class="inactive">Scaling</div>
  <div class="active">Optimizing</div>
</div>

<h2>❌ Mistake #1—Rejecting Mechanical Sympathy <span class="corner-fixes">✅ 🛠️ Fixes</span></h2>

- Take control of your SQL (`to_sql`)<sup><a href="#footnote-9-5-4-1">59</a></sup> and execution plans (`.explain()`)
- Replace high update churn designs with "append-mostly", e.g. *slotted counters*,<sup><a href="#footnote-9-5-5">60</a></sup> Increase *HOT updates*.<sup><a href="#footnote-9-5-6">61</a></sup>
- Prevent lazy loading by enabling *Strict Loading*.<sup><a href="#footnote-9-5-7">62</a></sup> Start by logging violations.<sup><a href="#footnote-9-5-8">63</a></sup>
- Preserve stability by setting upper limits on allowed durations for queries & idle transactions, number of connections

---
<style scoped>
  strong {
    font-size:1.3em;
  }
</style>

<pre>
# config/application.rb
config.active_record.action_on_strict_loading_violation = <strong class="highlight">:log</strong> 👈
</pre>

<pre>
Trip.limit(10).order(created_at: :desc).<strong class="highlight">to_sql</strong> 👈
</pre>

<pre style="font-size:0.7em;overflow:hidden;padding:10px;">
rideshare(dev)> Trip.limit(10).order(created_at: :desc).<strong class="highlight">explain(:analyze, :buffers)</strong> 👈
  Trip Load (14.2ms)  SELECT "trips".* FROM "trips" ORDER BY "trips"."created_at" DESC LIMIT $1  [["LIMIT", 10]]
=>
EXPLAIN (ANALYZE, BUFFERS) SELECT "trips".* FROM "trips" ORDER BY "trips"."created_at" DESC LIMIT $1 [["LIMIT", 10]]
                                                                   QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.28..0.57 rows=10 width=80) (actual time=0.021..0.022 rows=10 loops=1)
   Buffers: shared hit=3
   ->  Index Scan Backward using idx_trips_created_at on trips  (cost=0.28..30.27 rows=1000 width=80) (actual time=0.020..0.021 rows=10 loops=1)
         Buffers: shared hit=3
 Planning Time: 0.063 ms
 Execution Time: 0.047 ms
(6 rows)
</pre>

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-10);
}
blockquote {
  color:#fff;
}
a { color: #fff; }
</style>

## 🌱 ***Embrace*** Mechanical Sympathy
> When you understand how a system is designed to be used, you can align with the design to gain optimal performance.

🏎️ 🌬️

---
<!-- _color: #fff; -->
<!-- _backgroundColor: #fff; -->
<!-- _backgroundImage: linear-gradient(90deg, #000000 50%, #529FD4 50% 80%); -->

<style scoped>
section {
    font-size: 2em;
}
.qr-code {
  max-width:300px;
  width:300px;
  float:right;
  position:absolute;
  right:0px;
  top:-50px;
  padding:200px 100px 0 0;
}
.qr-code img {
  float:right;
  max-width:400px;
}
</style>

### 👋 Thank you!

<code style="font-size:1.5em;">🌐 <a href="https://bit.ly/rc10m">bit.ly/rc10m</a></code>

💼 Consulting [Refined Pages, LLC](refinedpages.com)
✉️ Newsletter [pgrailsbook.com](pgrailsbook.com)
🦋 [@andyatkinson.com](https://bsky.app/profile/andyatkinson.com)


<div class='qr-code'><img src="images/bitly_rc10m.png"/></div>

---
<style scoped>
section li, section li a { 
  color: #fff; 
  font-size:11px;
}
.footnote {
  position:relative;
  top:-50px;
}
ul {
  list-style-type:none;
  margin-left:-5px;
}
ul.two-column-list {
  column-count: 2;
  column-gap: 2rem;
  padding: 10px 0 0 0;
  list-style-position: inside;
}
</style>

<!--
HTML is generated below from this footnotes source
{{
1-1,atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
1-2,atlassian.com/continuous-delivery/continuous-integration/trunk-based-development
1-3,railsdeveloper.com/survey/2024/#deployment-devops
1-4,dora.dev/guides/dora-metrics-four-keys
1-5,octopus.com/devops/metrics/space-framework
1-6,a.co/d/0Sk81B9
1-7,dora.dev/quickcheck
1-8,github.com/simplecov-ruby/simplecov
1-9,github.com/ankane/strong_migrations
1-9-1,github.com/sbdchd/squawk
1-9-2,github.com/andyatkinson/anchor_migrations
1-9-3,github.com/andyatkinson/rideshare/pull/230

2-1,en.wikipedia.org/wiki/Object–relational_impedance_mismatch
2-2,postgres.fm/episodes/over-indexing
2-3,andyatkinson.com/generating-short-alphanumeric-public-id-postgres

3-1,andyatkinson.com/presentations/blob/main/pass2024/README.md
3-2,andyatkinson.com/constraint-driven-optimized-responsive-efficient-core-db-design
3-3,github.com/djezzzl/database_consistency

4-1,andyatkinson.com/source-code-line-numbers-ruby-on-rails-marginalia-query-logs
4-2,postgresql.org/docs/current/auto-explain.html
4-3,postgres.ai/blog/20220106-explain-analyze-needs-buffers-to-improve-the-postgres-query-optimization-process
4-4,mysql.com/products/enterprise/em.html
4-5,sqlite.org/sqlanalyze.html

5-1,andyatkinson.com/blog/2024/05/28/top-5-postgresql-surprises-from-rails-developers
5-2,andyatkinson.com/big-problems-big-in-clauses-postgresql-ruby-on-rails
5-3,andyatkinson.com/tip-track-sql-queries-quantity-ruby-rails-postgresql
5-4,ddnexus.github.io/pagy/docs/api/keyset/
5-5,island94.org/2024/03/rails-active-record-will-it-bind
5-6,blog.appsignal.com/2018/06/19/activerecords-counter-cache.html
5-7,depesz.com/2024/12/01/sql-best-practices-dont-compare-count-with-0
5-8,bigbinary.com/blog/rails-6-adds-implicit_order_column

6-1,andycroll.com/ruby/safely-remove-a-column-field-from-active-record
6-2,github.com/fatkodima/online_migrations

7-1,github.com/andyatkinson/pg_scripts/pull/18
7-2,github.com/andyatkinson/pg_scripts/blob/main/find_missing_indexes.sql
7-2-1,github.com/pganalyze/lint
7-2-2,github.com/HypoPG/hypopg
7-3,github.com/andyatkinson/pg_scripts/pull/19
7-4,github.com/andyatkinson/rideshare/pull/232
7-5,github.com/scenic-views/scenic
7-6,andyatkinson.com/blog/2023/07/27/partitioning-growing-practice

8-1,github.com/public-activity/public_activity
8-2,github.com/paper-trail-gem/paper_trail
8-3,github.com/collectiveidea/audited
8-4,github.com/ankane/ahoy
8-5,andyatkinson.com/copy-swap-drop-postgres-table-shrink
8-6,github.com/palkan/logidze
8-7,andyatkinson.com/blog/2023/08/17/postgresql-sfpug-table-partitioning-presentation
8-8,github.com/danmayer/coverband

9-1,why-upgrade.depesz.com
9-2,andyatkinson.com/blog/2021/07/30/postgresql-index-maintenance
9-3,github.com/NikolayS/postgres_dba
9-4,cybertec-postgresql.com/en/products/pg_squeeze
9-5,maintainable.fm/episodes/andrew-atkinson-maintainable-databases

9-5-1,wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.concept.mechanical-sympathy.en.html
9-5-2,github.com/cerebris/jsonapi-resources
9-5-3,github.com/rmosolgo/graphql-ruby
9-5-4,github.com/activeadmin/activeadmin
9-5-4-1,boringrails.com/tips/active-record-to-sql
9-5-5,github.com/andyatkinson/rideshare/pull/233
9-5-6,cybertec-postgresql.com/en/hot-updates-in-postgresql-for-better-performance
9-5-7,andyatkinson.com/blog/2022/10/07/pgsqlphriday-2-truths-lie
9-5-8,jordanhollinger.com/2023/11/11/rails-strict-loading
}}
-->

<div class='footnote'><ul class='two-column-list'><li id='footnote-1-1'>
  1. <a href='https://atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow'>atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow</a>
</li>
<li id='footnote-1-2'>
  2. <a href='https://atlassian.com/continuous-delivery/continuous-integration/trunk-based-development'>atlassian.com/continuous-delivery/continuous-integration/trunk-based-development</a>
</li>
<li id='footnote-1-3'>
  3. <a href='https://railsdeveloper.com/survey/2024/#deployment-devops'>railsdeveloper.com/survey/2024/#deployment-devops</a>
</li>
<li id='footnote-1-4'>
  4. <a href='https://dora.dev/guides/dora-metrics-four-keys'>dora.dev/guides/dora-metrics-four-keys</a>
</li>
<li id='footnote-1-5'>
  5. <a href='https://octopus.com/devops/metrics/space-framework'>octopus.com/devops/metrics/space-framework</a>
</li>
<li id='footnote-1-6'>
  6. <a href='https://a.co/d/0Sk81B9'>a.co/d/0Sk81B9</a>
</li>
<li id='footnote-1-7'>
  7. <a href='https://dora.dev/quickcheck'>dora.dev/quickcheck</a>
</li>
<li id='footnote-1-8'>
  8. <a href='https://github.com/simplecov-ruby/simplecov'>github.com/simplecov-ruby/simplecov</a>
</li>
<li id='footnote-1-9'>
  9. <a href='https://github.com/ankane/strong_migrations'>github.com/ankane/strong_migrations</a>
</li>
<li id='footnote-1-9-1'>
  10. <a href='https://github.com/sbdchd/squawk'>github.com/sbdchd/squawk</a>
</li>
<li id='footnote-1-9-2'>
  11. <a href='https://github.com/andyatkinson/anchor_migrations'>github.com/andyatkinson/anchor_migrations</a>
</li>
<li id='footnote-1-9-3'>
  12. <a href='https://github.com/andyatkinson/rideshare/pull/230'>github.com/andyatkinson/rideshare/pull/230</a>
</li>
<li id='footnote-2-1'>
  13. <a href='https://en.wikipedia.org/wiki/Object–relational_impedance_mismatch'>en.wikipedia.org/wiki/Object–relational_impedance_mismatch</a>
</li>
<li id='footnote-2-2'>
  14. <a href='https://postgres.fm/episodes/over-indexing'>postgres.fm/episodes/over-indexing</a>
</li>
<li id='footnote-2-3'>
  15. <a href='https://andyatkinson.com/generating-short-alphanumeric-public-id-postgres'>andyatkinson.com/generating-short-alphanumeric-public-id-postgres</a>
</li>
<li id='footnote-3-1'>
  16. <a href='https://andyatkinson/presentations/blob/main/pass2024/README.md'>andyatkinson.com/presentations/blob/main/pass2024/README.md</a>
</li>
<li id='footnote-3-2'>
  17. <a href='https://andyatkinson.com/constraint-driven-optimized-responsive-efficient-core-db-design'>andyatkinson.com/constraint-driven-optimized-responsive-efficient-core-db-design</a>
</li>
<li id='footnote-3-3'>
  18. <a href='https://github.com/djezzzl/database_consistency'>github.com/djezzzl/database_consistency</a>
</li>
<li id='footnote-4-1'>
  19. <a href='https://andyatkinson.com/source-code-line-numbers-ruby-on-rails-marginalia-query-logs'>andyatkinson.com/source-code-line-numbers-ruby-on-rails-marginalia-query-logs</a>
</li>
<li id='footnote-4-2'>
  20. <a href='https://postgresql.org/docs/current/auto-explain.html'>postgresql.org/docs/current/auto-explain.html</a>
</li>
<li id='footnote-4-3'>
  21. <a href='https://postgres.ai/blog/20220106-explain-analyze-needs-buffers-to-improve-the-postgres-query-optimization-process'>postgres.ai/blog/20220106-explain-analyze-needs-buffers-to-improve-the-postgres-query-optimization-process</a>
</li>
<li id='footnote-4-4'>
  22. <a href='https://mysql.com/products/enterprise/em.html'>mysql.com/products/enterprise/em.html</a>
</li>
<li id='footnote-4-5'>
  23. <a href='https://sqlite.org/sqlanalyze.html'>sqlite.org/sqlanalyze.html</a>
</li>
<li id='footnote-5-1'>
  24. <a href='https://andyatkinson.com/blog/2024/05/28/top-5-postgresql-surprises-from-rails-developers'>andyatkinson.com/blog/2024/05/28/top-5-postgresql-surprises-from-rails-developers</a>
</li>
<li id='footnote-5-2'>
  25. <a href='https://andyatkinson.com/big-problems-big-in-clauses-postgresql-ruby-on-rails'>andyatkinson.com/big-problems-big-in-clauses-postgresql-ruby-on-rails</a>
</li>
<li id='footnote-5-3'>
  26. <a href='https://andyatkinson.com/tip-track-sql-queries-quantity-ruby-rails-postgresql'>andyatkinson.com/tip-track-sql-queries-quantity-ruby-rails-postgresql</a>
</li>
<li id='footnote-5-4'>
  27. <a href='https://ddnexus.github.io/pagy/docs/api/keyset/'>ddnexus.github.io/pagy/docs/api/keyset/</a>
</li>
<li id='footnote-5-5'>
  28. <a href='https://island94.org/2024/03/rails-active-record-will-it-bind'>island94.org/2024/03/rails-active-record-will-it-bind</a>
</li>
<li id='footnote-5-6'>
  29. <a href='https://blog.appsignal.com/2018/06/19/activerecords-counter-cache.html'>blog.appsignal.com/2018/06/19/activerecords-counter-cache.html</a>
</li>
<li id='footnote-5-7'>
  30. <a href='https://depesz.com/2024/12/01/sql-best-practices-dont-compare-count-with-0'>depesz.com/2024/12/01/sql-best-practices-dont-compare-count-with-0</a>
</li>
<li id='footnote-5-8'>
  31. <a href='https://bigbinary.com/blog/rails-6-adds-implicit_order_column'>bigbinary.com/blog/rails-6-adds-implicit_order_column</a>
</li>
<li id='footnote-6-1'>
  32. <a href='https://andycroll.com/ruby/safely-remove-a-column-field-from-active-record'>andycroll.com/ruby/safely-remove-a-column-field-from-active-record</a>
</li>
<li id='footnote-6-2'>
  33. <a href='https://github.com/fatkodima/online_migrations'>github.com/fatkodima/online_migrations</a>
</li>
<li id='footnote-7-1'>
  34. <a href='https://github.com/andyatkinson/pg_scripts/pull/18'>github.com/andyatkinson/pg_scripts/pull/18</a>
</li>
<li id='footnote-7-2'>
  35. <a href='https://github.com/andyatkinson/pg_scripts/blob/main/find_missing_indexes.sql'>github.com/andyatkinson/pg_scripts/blob/main/find_missing_indexes.sql</a>
</li>
<li id='footnote-7-2-1'>
  36. <a href='https://github.com/pganalyze/lint'>github.com/pganalyze/lint</a>
</li>
<li id='footnote-7-2-2'>
  37. <a href='https://github.com/HypoPG/hypopg'>github.com/HypoPG/hypopg</a>
</li>
<li id='footnote-7-3'>
  38. <a href='https://github.com/andyatkinson/pg_scripts/pull/19'>github.com/andyatkinson/pg_scripts/pull/19</a>
</li>
<li id='footnote-7-4'>
  39. <a href='https://github.com/andyatkinson/rideshare/pull/232'>github.com/andyatkinson/rideshare/pull/232</a>
</li>
<li id='footnote-7-5'>
  40. <a href='https://github.com/scenic-views/scenic'>github.com/scenic-views/scenic</a>
</li>
<li id='footnote-7-6'>
  41. <a href='https://andyatkinson.com/blog/2023/07/27/partitioning-growing-practice'>andyatkinson.com/blog/2023/07/27/partitioning-growing-practice</a>
</li>
<li id='footnote-8-1'>
  42. <a href='https://github.com/public-activity/public_activity'>github.com/public-activity/public_activity</a>
</li>
<li id='footnote-8-2'>
  43. <a href='https://github.com/paper-trail-gem/paper_trail'>github.com/paper-trail-gem/paper_trail</a>
</li>
<li id='footnote-8-3'>
  44. <a href='https://github.com/collectiveidea/audited'>github.com/collectiveidea/audited</a>
</li>
<li id='footnote-8-4'>
  45. <a href='https://github.com/ankane/ahoy'>github.com/ankane/ahoy</a>
</li>
<li id='footnote-8-5'>
  46. <a href='https://andyatkinson.com/copy-swap-drop-postgres-table-shrink'>andyatkinson.com/copy-swap-drop-postgres-table-shrink</a>
</li>
<li id='footnote-8-6'>
  47. <a href='https://github.com/palkan/logidze'>github.com/palkan/logidze</a>
</li>
<li id='footnote-8-7'>
  48. <a href='https://andyatkinson.com/blog/2023/08/17/postgresql-sfpug-table-partitioning-presentation'>andyatkinson.com/blog/2023/08/17/postgresql-sfpug-table-partitioning-presentation</a>
</li>
<li id='footnote-8-8'>
  49. <a href='https://github.com/danmayer/coverband'>github.com/danmayer/coverband</a>
</li>
<li id='footnote-9-1'>
  50. <a href='https://why-upgrade.depesz.com'>why-upgrade.depesz.com</a>
</li>
<li id='footnote-9-2'>
  51. <a href='https://andyatkinson.com/blog/2021/07/30/postgresql-index-maintenance'>andyatkinson.com/blog/2021/07/30/postgresql-index-maintenance</a>
</li>
<li id='footnote-9-3'>
  52. <a href='https://github.com/NikolayS/postgres_dba'>github.com/NikolayS/postgres_dba</a>
</li>
<li id='footnote-9-4'>
  53. <a href='https://cybertec-postgresql.com/en/products/pg_squeeze'>cybertec-postgresql.com/en/products/pg_squeeze</a>
</li>
<li id='footnote-9-5'>
  54. <a href='https://maintainable.fm/episodes/andrew-atkinson-maintainable-databases'>maintainable.fm/episodes/andrew-atkinson-maintainable-databases</a>
</li>
<li id='footnote-9-5-1'>
  55. <a href='https://wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.concept.mechanical-sympathy.en.html'>wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.concept.mechanical-sympathy.en.html</a>
</li>
<li id='footnote-9-5-2'>
  56. <a href='https://github.com/cerebris/jsonapi-resources'>github.com/cerebris/jsonapi-resources</a>
</li>
<li id='footnote-9-5-3'>
  57. <a href='https://github.com/rmosolgo/graphql-ruby'>github.com/rmosolgo/graphql-ruby</a>
</li>
<li id='footnote-9-5-4'>
  58. <a href='https://github.com/activeadmin/activeadmin'>github.com/activeadmin/activeadmin</a>
</li>
<li id='footnote-9-5-4-1'>
  59. <a href='https://boringrails.com/tips/active-record-to-sql'>boringrails.com/tips/active-record-to-sql</a>
</li>
<li id='footnote-9-5-5'>
  60. <a href='https://github.com/andyatkinson/rideshare/pull/233'>github.com/andyatkinson/rideshare/pull/233</a>
</li>
<li id='footnote-9-5-6'>
  61. <a href='https://cybertec-postgresql.com/en/hot-updates-in-postgresql-for-better-performance'>cybertec-postgresql.com/en/hot-updates-in-postgresql-for-better-performance</a>
</li>
<li id='footnote-9-5-7'>
  62. <a href='https://andyatkinson.com/blog/2022/10/07/pgsqlphriday-2-truths-lie'>andyatkinson.com/blog/2022/10/07/pgsqlphriday-2-truths-lie</a>
</li>
<li id='footnote-9-5-8'>
  63. <a href='https://jordanhollinger.com/2023/11/11/rails-strict-loading'>jordanhollinger.com/2023/11/11/rails-strict-loading</a>
</li>
</ul></div>
