-- AIR MAIL starter schema for Supabase PostgreSQL.
-- Apply only after creating a Supabase project and enabling Auth.
-- This table stores app message metadata/content; it does not deliver email by itself.

create table if not exists public.mail_messages (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  folder text not null default 'Inbox'
    check (folder in ('Inbox','Sent','Drafts','Spam','Trash','Starred')),
  sender_address text,
  recipient_address text,
  subject text not null default '',
  body_text text not null default '',
  is_read boolean not null default false,
  is_starred boolean not null default false,
  received_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.mail_messages enable row level security;

drop policy if exists "Users can read their own mail" on public.mail_messages;
create policy "Users can read their own mail"
  on public.mail_messages for select
  to authenticated using (auth.uid() = owner_id);

drop policy if exists "Users can insert their own mail" on public.mail_messages;
create policy "Users can insert their own mail"
  on public.mail_messages for insert
  to authenticated with check (auth.uid() = owner_id);

drop policy if exists "Users can update their own mail" on public.mail_messages;
create policy "Users can update their own mail"
  on public.mail_messages for update
  to authenticated using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

drop policy if exists "Users can delete their own mail" on public.mail_messages;
create policy "Users can delete their own mail"
  on public.mail_messages for delete
  to authenticated using (auth.uid() = owner_id);
