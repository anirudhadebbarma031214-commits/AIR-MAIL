-- AIR MAIL's Supabase message-storage schema.
-- This schema stores private app messages. It does NOT send or receive external email.
create table if not exists public.air_mail_messages (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  sender_email text not null,
  recipient_email text not null,
  subject text not null default '' check (char_length(subject) <= 300),
  body text not null default '' check (char_length(body) <= 50000),
  folder text not null default 'Inbox'
    check (folder in ('Inbox','Sent','Drafts','Spam','Trash')),
  is_starred boolean not null default false,
  is_read boolean not null default false,
  created_at timestamptz not null default now(),
  check (char_length(sender_email) <= 320),
  check (char_length(recipient_email) <= 320)
);
create index if not exists air_mail_messages_owner_folder_created_idx
  on public.air_mail_messages (owner_id, folder, created_at desc);
create index if not exists air_mail_messages_owner_starred_idx
  on public.air_mail_messages (owner_id, is_starred) where is_starred = true;
alter table public.air_mail_messages enable row level security;
grant select, insert, update, delete on public.air_mail_messages to authenticated;

drop policy if exists "Users can read their own AIR MAIL messages" on public.air_mail_messages;
create policy "Users can read their own AIR MAIL messages"
  on public.air_mail_messages for select to authenticated
  using ((select auth.uid()) = owner_id and coalesce((select auth.jwt()->>'is_anonymous'),'false') <> 'true');
drop policy if exists "Users can insert their own AIR MAIL messages" on public.air_mail_messages;
create policy "Users can insert their own AIR MAIL messages"
  on public.air_mail_messages for insert to authenticated
  with check ((select auth.uid()) = owner_id and coalesce((select auth.jwt()->>'is_anonymous'),'false') <> 'true');
drop policy if exists "Users can update their own AIR MAIL messages" on public.air_mail_messages;
create policy "Users can update their own AIR MAIL messages"
  on public.air_mail_messages for update to authenticated
  using ((select auth.uid()) = owner_id and coalesce((select auth.jwt()->>'is_anonymous'),'false') <> 'true')
  with check ((select auth.uid()) = owner_id and coalesce((select auth.jwt()->>'is_anonymous'),'false') <> 'true');
drop policy if exists "Users can delete their own AIR MAIL messages" on public.air_mail_messages;
create policy "Users can delete their own AIR MAIL messages"
  on public.air_mail_messages for delete to authenticated
  using ((select auth.uid()) = owner_id and coalesce((select auth.jwt()->>'is_anonymous'),'false') <> 'true');
