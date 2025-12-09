# PostgreSQL Commands

## Connect to PostgreSQL
```bash
# Connect to PostgreSQL inside Docker container
docker exec -it recipe_app_postgres psql -U nestuser -d recipe_app_db
```

## Connect to Database
```sql
\c recipe_app_db;
```

## Check tables
```sql
\dt
```

## Get all data from a table
```sql
SELECT * FROM categories;
```

## Insert data into table
```sql
INSERT INTO categories(category) VALUES('Lunch');
```

## Create backup
```sql
docker exec recipe_app_postgres pg_dump -U nestuser recipe_app_db > backup.sql
```

## Restore backup
```sql
docker exec -i recipe_app_postgres psql -U nestuser -d recipe_app_db < backup.sql
```

## Exit
- Exit pager: `q`
- Exit psql: `\q` or `exit`