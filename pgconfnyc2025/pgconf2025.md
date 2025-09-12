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
- I helped manage a dozen PostgreSQL instances for a web app
- Instances were set up at different times, initially all "shared", then single-customer split outs
- Some were very over-provisioned (over spending), others very under-provisioned (performance problems)
- On instances, mix of users, permissions, schema objects, tables, indexes

How could we do it better next time?

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
- Web developer for 20 years, 15 w/ Ruby on Rails, 10 primarily PostgreSQL
- Book author: High Performance PostgreSQL for Rails (2024)
- Received a PostgreSQL Contributor Coin Gift in 2024!<sup><a href="#footnote-1-1">1</a></sup>

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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<div style="display: flex; gap: 2rem;">
  <div style="flex: 1; margin: -30px px; border-radius: 5px;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class='list-item mistake-1'>Single Big DB</div></li>
      <li><div class='list-item mistake-2'>Composite Primary Keys</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none;margin:10px 10px 10px 10px;padding:0;">
      <li><div class="list-item mistake-3">Tenant Data Logs</div></li>
      <li><div class="list-item mistake-4">Tenant Query Logs</div></li>
    </ul>
  </div>

  <div style="flex: 1; padding: 1rem; border-radius: 8px; list-style-type: none; color:#000;">
    <ul style="list-style-type:none; margin:10px 10px 10px 10px;padding:0;">
    <li><div class="list-item mistake-5">Row Level Security</div></li>
    <li><div class="list-item mistake-6">Partitioned Orders</div></li>
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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Our Multi-tenant design</h2>

- Single Postgres schema, single Postgres database
- Table: `suppliers` (The tenant)
- Table: `customers`
- Table: `orders` (FK `supplier_id`, FK `customer_id`)

Barebones e-commerce use case: Customers places orders for items from suppliers

---

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│     Server instance (Postgres 18, X CPUs, X Memory, etc.)       │
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

## Cost-efficient design

- Same server, same database, same (single) schema
- Suppliers are the tenant, and they're stored in a `suppliers` table, their is identified with a `supplier_id` column
- Distribute the supplier identifier column (`supplier_id`) on every table for simple queries and indexing (this means some denormalization)
- Use `bigint` data type. 4 bytes too few. 16 bytes UUID v4 size and randomness is not desirable for space and performance unless 100% needed.

---

# Why `supplier_id` on every table?

- Easy identification
- Less complex queries to parse, plan, execute (one less `JOIN`)
- Use multicolumn indexes with the `supplier_id` column
- Easier row data movement: e.g. copying tenant data to a lower environment or demo environment

---

# Demos

- `github.com/ andyatkinson/ presentations / pass2024 / README.md`
- Boot a Docker Postgres 18 Beta 3 instance
- Run: `sh create_db.sh`

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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Primary Keys</h2>

- Primary key type decisions: UUID or integer (sequences)
- Single integers, or multiple values (composite primary keys)
- Let's use `bigint` (8 bytes) for all tables
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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
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
  <div class="active">Starting up</div>
  <div class="inactive">Learning</div>
  <div class="inactive">Optimizing</div>
</div>

<h2>Tenant Data Logs</h2>

- "Data": Inserts, updates, and deletes
- Create a Suppliers `supplier_data_changes` table
- Trigger-based system, probably not recommended at a certain TPS (transactions per second) scale, e.g. 500


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

<h2>Tenant Query Logs</h2>

- We have pg_stat_statements (PGSS) for all queries
- PGSS is not scoped to a tenant
- We can make our own query logs table, scoped to tenants

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

<h2>Row Level Security</h2>

- In Postgres, we can limit access to certain rows using a policy

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

<h2>Partitioned Tables</h2>

- Our e-commerce tenant may have a big `orders` table, let's partition it
- Partitioned tables are a way to break up massive tables into chunks, so each chunk can be queried faster or chunks can be managed better
- Our partitioned table uses a CPK (`supplier_id`, `id`)
- Let's enable parallel vacuum

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

<h2>Configs</h2>

- Increase maintenance workers for vacuum, monitor parallel workers
- Automate archival and detachment of aged-out partitions for the tenant tables
- Automate detachment for "churned" customers


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
1-1,wiki.postgresql.org/wiki/Contributor_Gifts
}}
-->