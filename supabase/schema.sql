-- ─────────────────────────────────────────────
--  PocketHero – Supabase Schema
--  Run this in the Supabase SQL editor.
-- ─────────────────────────────────────────────

-- 1. Profiles ─────────────────────────────────
create table public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  email text,
  created_at timestamptz default now() not null
);

alter table public.profiles enable row level security;

create policy "Users can read own profile" on public.profiles
  for select using (auth.uid() = id);
create policy "Users can insert own profile" on public.profiles
  for insert with check (auth.uid() = id);
create policy "Users can update own profile" on public.profiles
  for update using (auth.uid() = id);

-- 2. Transactions ─────────────────────────────
create table public.transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  title text not null,
  amount decimal(12,2) not null check (amount > 0),
  category text not null,
  is_income boolean not null default false,
  note text,
  created_at timestamptz default now() not null
);

alter table public.transactions enable row level security;

create policy "Users can manage own transactions" on public.transactions
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 3. Budget limits ────────────────────────────
create table public.budget_limits (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  monthly_limit decimal(12,2) not null default 3000,
  month int not null check (month between 1 and 12),
  year int not null,
  created_at timestamptz default now() not null,
  unique(user_id, month, year)
);

alter table public.budget_limits enable row level security;

create policy "Users can manage own budgets" on public.budget_limits
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. Savings goals ────────────────────────────
create table public.savings_goals (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  target_amount decimal(12,2) not null check (target_amount > 0),
  current_amount decimal(12,2) not null default 0 check (current_amount >= 0),
  deadline date,
  created_at timestamptz default now() not null
);

alter table public.savings_goals enable row level security;

create policy "Users can manage own goals" on public.savings_goals
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 5. Gamification ─────────────────────────────
create table public.user_gamification (
  user_id uuid references auth.users(id) on delete cascade primary key,
  xp int not null default 0 check (xp >= 0),
  streak_days int not null default 0 check (streak_days >= 0),
  last_logged_at date,
  unlocked_achievement_ids text[] not null default '{}',
  created_at timestamptz default now() not null
);

alter table public.user_gamification enable row level security;

create policy "Users can manage own gamification" on public.user_gamification
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 6. Auto-create profile + gamification row on signup ──
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.email
  );
  insert into public.user_gamification (user_id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
