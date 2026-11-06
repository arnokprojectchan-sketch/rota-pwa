-- 輪班手帳：貼到 Supabase 的 SQL Editor，按 Run 一次即可。
create table if not exists public.items (
  user_id    uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  coll       text        not null check (coll in ('sessions','tasks','projects','overrides','config')),
  id         text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, coll, id)
);

-- Row Level Security：每個帳號只能讀寫自己的資料
alter table public.items enable row level security;

drop policy if exists "own rows select" on public.items;
drop policy if exists "own rows insert" on public.items;
drop policy if exists "own rows update" on public.items;
drop policy if exists "own rows delete" on public.items;

create policy "own rows select" on public.items for select to authenticated using ((select auth.uid()) = user_id);
create policy "own rows insert" on public.items for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "own rows update" on public.items for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "own rows delete" on public.items for delete to authenticated using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.items to authenticated;
