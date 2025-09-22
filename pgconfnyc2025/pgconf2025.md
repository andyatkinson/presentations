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

#### Context
- We managed a dozen PostgreSQL instances with "copies" of the same database for deployments of the web app.
- Instances were set up at different times, not using infra-as-code. Initially "multi-customer" environments, then later single-customer split outs
- Poor config consistency. Mix of users, permissions, schema objects, tables, indexes.
- Most were either over-provisioned (over spending), or under-provisioned (performance problems).

How could we do better?

---
<style scoped>
  img.rw24 {
    position:relative;
    bottom:60px;
    left:620px;
    max-width:400px;
  }
</style>

![bg right 90%](images/collage-railsworld-2024.jpg)

#### My Background
- Web developer, 20 years, 10 with PostgreSQL
- Author: *High Performance PostgreSQL for Rails* (2024)
- Received a PostgreSQL Contributor Coin Gift (2024)<sup><a href="#footnote-1-1">1</a></sup>


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

## Solution: Multitenancy

Let's explore 6 patterns using community PostgreSQL

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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<div style="display: flex; gap: 2rem;">
  <div style="flex: 1; margin: -30px px; border-radius: 5px;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class='list-item mistake-1'>#1 Single Big DB</div></li>
      <li><div class='list-item mistake-2'>#2 Composite Primary Keys</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class="list-item mistake-3">#3 Tenant Data Logs</div></li>
      <li><div class="list-item mistake-4">#4 Tenant Query Logs</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none; margin:10px 10px 10px 10px;padding:0;">
    <li><div class="list-item mistake-5">#5 Row Level Security</div></li>
    <li><div class="list-item mistake-6">#6 Partitioned Orders</div></li>
    </ul>
  </div>
</div>


---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

## Multitenancy Opportunities

- Cost savings, fewer instances
- Less complexity, less inconsistency
- Tenant data isolation
- Easier management for monitoring, upgrade, administer

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

## Multitenancy Challenges

- Shared server instance resources (CPU, Memory, IOPS)
- Shared Postgres resources (Autovacuum, buffer cache)
- Lacking tenant-scoped observability out of the box

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>E-commerce multi-tenant DB design</h2>

- Keep it simple: single database `pgconf`, schema `pgconf`, instance
- Table: `suppliers` (Our "tenant")
- Table: `customers`
- Table: `orders` (FK `supplier_id`, FK `customer_id`)

🛒 Customers create orders, orders are for items from suppliers

---

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     Server instance (Postgres 18: CPUs, Memory, cache etc.)     │
│                                                                 │
│      ┌────────────────────────────────────────────────────┐     │
│      │                                                    │     │
│      │   Database "pgconf"                                │     │
│      │                                                    │     │
│      │      ┌───────────────────────────────────────┐     │     │
│      │      │                                       │     │     │
│      │      │   Schema "pgconf"                     │     │     │
│      │      │                                       │     │     │
│      │      │  ┌────────────────┐  ┌──────────────┐ │     │     │
│      │      │  │ Table          │  │ Table        │ │     │     │
│      │      │  │ customers      │  │ orders       │ │     │     │
│      │      │  │                │  │              │ │     │     │
│      │      │  │                │  │              │ │     │     │
│      │      │  │                │  │              │ │     │     │
│      │      │  └────────────────┘  └──────────────┘ │     │     │
│      │      │                                       │     │     │
│      │      └───────────────────────────────────────┘     │     │
│      │                                                    │     │
│      └────────────────────────────────────────────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# Schema Design: Single Integer Primary Keys

- Identify `suppliers` tenant data with a `supplier_id` column
- Add `supplier_id` to every table for simple queries and indexing (a form of denormalization) (more on next slide)
- Goldilocks PK data type: `bigint` 8 bytes. `integer` 4 bytes too small. 16 bytes UUID too big.

---

# Tenant id column `supplier_id` on every table

- Easy tenant data identification, easy queries, no joins
- Uniformity for scripts, use `generated column` on `suppliers` table
- Less joins: Less work for query planner to parse, plan, execute tenant queries
- Use multicolumn indexes with `supplier_id` leading column
- Easier row data movement, copy tenant rows to other environments: staging, demo

---

# Demos

- `github.com / andyatkinson / presentations / pgconf2025 / README.md`
- Docker Postgres 18 instance
- Entrypoint script: `sh create_db.sh`

From there, we’ll look at corresponding SQL files for each pattern

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>#1 Scaling the Single Big DB</h2>

- Scale Postgres instance vertically as long as possible
- Major cloud offerings (Sep. 2025): GCP: 96 vCPUs, 624 GB
- MS Azure: 96 vCores, 672 GB
- AWS RDS [db.r8g.48xlarge](https://instances.vantage.sh/aws/rds/db.r8g.48xlarge?currency=USD), 192 vCPUs, 1536 GB (1.5 TB) memory, 210K annually on-demand (17.5k/month), 140K 1-year reservation

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>#2 Composite Primary Keys</h2>

- CPKs enforce unique tenant-data via primary key
- Check ORM Support. Active Record (Ruby on Rails) supports them.
- Tenant data isolation
- Longer foreign key definitions:
```sql
  CONSTRAINT fk_customer
      FOREIGN KEY (supplier_id, id)
      REFERENCES customers (supplier_id, id)
```

DEMO

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Alternative: UUID Primary Keys</h2>

- Postgres 18 can generate UUID V7 values natively, useful as primary keys
- UUIDs avoid integer conflicts with multiple primary instances, which could be a reason to chose them

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="active">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>#3 Tenant Data Logs</h2>

- "Data" here is Inserts, Updates, and Deletes for Tenants
- Create table: `supplier_data_changes` to capture these
- Use triggers to capture changes
- Store and query using JSON formatted data

DEMO

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="active">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>#4 Tenant Query Logs</h2>

- What about our reads for tenants?
- We have `pg_stat_statements` (PGSS) but due to query grouping, we actually lose the `supplier_id` field, so we can't see queries by tenant easily
- To correct this, we can make our own query logs table scoped to tenants

DEMO

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

<h2>#5 Row Level Security For Suppliers</h2>

- In Postgres, we can limit access to certain row data using a policy
- We'll use our "suppliers" tenant and create a `supplier_data` table
- We'll verify that suppliers can only access their own data

DEMO

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

<h2>#6 Partitioned Tables</h2>

- The `orders` table will grow very large, it's for all suppliers, let's partition it
- Partitioned tables are a way to break up massive tables. Each smaller table can be queried and modified faster than one jumbo table.
- Our partitioned table uses a CPK (`supplier_id`, `id`)
- Partitions can run vacuum in parallel

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

## Why partition the table?

- Increase maintenance workers for vacuum, monitor parallel workers
- Opens up "detachment" (`detach concurrently`) of unneeded tenant data, less resource intensive than deleting rows
- When suppliers leave the platform, we can automatically detach and archive their data

DEMO

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

## Warnings #1 of 3: RLS Performance

- RLS adds performance overhead. Dian Fay: Row level security pitfalls<sup><a href="#footnote-1-2">2</a></sup> Compare your query execution plans without policies (and their functions) to understand how much overhead is added.

---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

## Warnings #2 of 3: Trigger overhead performance

- Imagine 50K Inserts/second, trigger functions add commit latency, there's index maintenance, WAL activity, this might be a scalability problem
- Could mitigate with a partitioned table and append-mostly pattern, and minimal indexes and constraints
- Otherwise: Likely need to move to async approach e.g. logical replication, CDC etc. (beyond this scope)


---
<style scoped>
section {
  color:#fff;
  background-color: var(--theme-mistake-1);
}
a { color: #fff; }
</style>
<div class="top-bar">
  <div class="inactive">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="active">Optimizing</div>
</div>

## Warnings #3 of 3: Partitioning still limited to single instance

- Requires a big row data migration to get row data into partitioned table
- Benefits: can perform vacuum on partitions concurrently
- Operations like adding indexes or constraints can be faster on partitions vs. jumbo table
- Downside: can still breach CPU, memory, and IOPS instance resource limits, for that may need sharded solution (See: SaaS on Rails on PostgreSQL<sup><a href="#footnote-1-3">3</a></sup>)

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

✉️ Newsletter [pgrailsbook.com](pgrailsbook.com)
🦋 [@andyatkinson.com](https://bsky.app/profile/andyatkinson.com)
💼 Consulting [Refined Pages, LLC](refinedpages.com)

---
<style scoped>
section li, section li a { 
  color: #fff; 
  font-size:20px;
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
1-1,wiki.postgresql.org/wiki/Contributor_Gifts
1-2,di.nmfay.com/rls-performance
1-3,andyatkinson.com/blog/2024/07/13/SaaS-on-Rails-on-PostgreSQL-POSETTE-2024-andrew-atkinson
}}
-->

<div class='footnote'><ul class='two-column-list'><li id='footnote-1-1'>
  1. <a href='https://wiki.postgresql.org/wiki/Contributor_Gifts'>wiki.postgresql.org/wiki/Contributor_Gifts</a>
</li>
<li id='footnote-1-2'>
  2. <a href='https://di.nmfay.com/rls-performance'>di.nmfay.com/rls-performance</a>
</li>
</ul></div>