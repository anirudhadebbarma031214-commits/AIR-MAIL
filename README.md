# AIR MAIL ✉️

**A clean, modern email workspace by ANI STUDIO.**

Website: https://anirudhadebbarma031214-commits.github.io/AIR-MAIL/

## Connected features
- Supabase email/password sign-up and sign-in
- Private per-user message storage in Supabase Postgres
- Row Level Security (RLS) policies to restrict messages to their owner
- Inbox, Starred, Sent, Drafts, Spam and Trash navigation
- Search, compose, open/read, star and move-to-Trash actions
- Secure Supabase Edge Function for outbound delivery through Resend (requires provider secrets and a verified sender domain)
- Responsive dark navy / cyan interface

## Important limitation: not yet a full email provider
AIR MAIL is now connected to Supabase Auth and its database. Outbound delivery is wired to a secure Supabase Edge Function using Resend, but it will not send until you configure the required provider secrets and verify your sender domain. Incoming external email is not configured. Do not use AIR MAIL for important or private real-world correspondence yet.

To enable outbound delivery, create a Resend account, verify a domain you own, and set RESEND_API_KEY plus AIR_MAIL_FROM as Supabase Edge Function secrets. For a complete email service, AIR MAIL still needs inbound email routing and processing, abuse/rate-limit controls, account recovery, monitoring and privacy policies. Never put Supabase secret/service-role keys or email-provider secrets in browser JavaScript or this public repository.

## Supabase project
The site uses the project's public URL and publishable key in browser code. Publishable keys are designed for frontend use when RLS and least-privilege policies are configured. The database table is `public.air_mail_messages`. The SQL in `supabase/schema.sql` documents the table and policies already applied to the connected project.

## Publish with GitHub Pages
The repository includes a GitHub Actions deployment workflow. In repository **Settings → Pages**, set **Source** to **GitHub Actions**. Then open the **Actions** tab and wait for the Pages workflow to succeed.

AIR MAIL is an independent project and is not affiliated with Google or Gmail.
