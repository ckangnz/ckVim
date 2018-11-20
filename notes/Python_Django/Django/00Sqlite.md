# Sqlite Commands

## Start by with this command in Django project
```bash
python manage.py dbshell
```

### List tables
```sqlite
.tables
SELECT tbl_name FROM sqlite_master WHERE type = 'table';
```

### Contents of tables
```sql
.header on
.mode column
.width 10,20,10
SELECT * FROM table_name;
SELECT col1, col2, col3 FROM table_name;
```

### Update table
```sql
UPDATE table_name
SET col1 = value1, col2 = value2 ….
WHERE [condition] // ID = 3;
```

