-- Cyan Panda Tool v2.7 — Supabase schema + pg_cron
-- Chạy 1 lần trong Supabase SQL Editor.

create table if not exists fans (
  id bigint generated always as identity primary key,
  username text unique not null,
  display_name text, call_as text, intimacy int default 5,
  time_slot text, ai_style text, notes text,
  country text, category text, vip boolean default false, priority text default 'vừa',
  created_at timestamptz default now()
);
create table if not exists messages (
  id bigint generated always as identity primary key,
  fan_username text, direction text, content text,
  created_at timestamptz default now()
);
create table if not exists accounts (
  id bigint generated always as identity primary key,
  type text, username text, meta jsonb default '{}',
  created_at timestamptz default now()
);
create table if not exists logs (
  id bigint generated always as identity primary key,
  action text, result text, code text, message text,
  created_at timestamptz default now()
);
create table if not exists queue (
  id bigint generated always as identity primary key,
  fan_username text, content text, status text default 'pending',
  created_at timestamptz default now()
);

-- Bật RLS + policy mở cho anon (tool cá nhân 1 người dùng; muốn chặt hơn thì thêm auth sau)
alter table fans enable row level security;
alter table messages enable row level security;
alter table accounts enable row level security;
alter table logs enable row level security;
alter table queue enable row level security;
do $$ declare t text; begin
  foreach t in array array['fans','messages','accounts','logs','queue'] loop
    execute format('create policy "panda_all" on %I for all using (true) with check (true)', t);
  end loop;
end $$;

-- pg_cron (cần bật extension pg_cron + pg_net trong Dashboard > Database > Extensions)
select cron.schedule('panda-keepalive', '*/5 * * * *',
  $$ select net.http_post('https://YOUR-PROJECT.functions.supabase.co/panda-keepalive') $$);
select cron.schedule('daily-learn', '0 2 * * *',
  $$ select net.http_post('https://YOUR-PROJECT.functions.supabase.co/panda-daily-learn') $$);
select cron.schedule('scan-private', '0 */3 * * *',
  $$ select net.http_post('https://YOUR-PROJECT.functions.supabase.co/scan-private') $$);
