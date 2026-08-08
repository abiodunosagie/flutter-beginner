# Postgres & Row Level Security (RLS)

## Table

```sql
create table public.todos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  is_complete boolean not null default false,
  inserted_at timestamptz not null default now()
);

alter table public.todos enable row level security;

create policy "read own" on public.todos for select to authenticated
  using (auth.uid() = user_id);

create policy "insert own" on public.todos for insert to authenticated
  with check (auth.uid() = user_id);

create policy "update own" on public.todos for update to authenticated
  using (auth.uid() = user_id);

create policy "delete own" on public.todos for delete to authenticated
  using (auth.uid() = user_id);
```

## Rules

1. Enable RLS  
2. Write policies for each action  
3. **Two-user test** always  

No policies + RLS on = nobody can read (safe default).
