# AIR MAIL ✉️

**A clean, modern email workspace by ANI STUDIO.**

Website: https://anirudhadebbarma031214-commits.github.io/AIR-MAIL/

## Connected features
- Supabase email/password sign-up and sign-in
- Private per-user message storage in Supabase Postgres
- Row Level Security (RLS) policies to restrict messages to their owner
- Inbox, Starred, Sent, Drafts, Spam and Trash navigation
- Search, compose, open/read, star and move-to-Trash actions
- Responsive dark navy / cyan interface

## Important limitation: not yet a full email provider
AIR MAIL is now connected to Supabase Auth and its database. Messages composed in the app are saved to the signed-in user's **Sent** folder, but are **not delivered to the recipient**. Incoming external email is not configured either. Do not use AIR MAIL for important or private real-world correspondence yet.

To become a real email service, AIR MAIL still needs a verified domain, DNS records (MX, SPF, DKIM and DMARC), an outbound email provider behind a secure server-side function, inbound email routing and processing, abuse/rate-limit controls, account recovery, monitoring and privacy policies. Never put Supabase secret/service-role keys or email-provider secrets in browser JavaScript or this public repository.

## Supabase project
The site uses the project's public URL and publishable key in browser code. Publishable keys are designed for frontend use when RLS and least-privilege policies are configured. The database table is `public.air_mail_messages`. The SQL in `supabase/schema.sql` documents the table and policies already applied to the connected project.

## Publish with GitHub Pages
The repository includes a GitHub Actions deployment workflow. In repository **Settings → Pages**, set **Source** to **GitHub Actions**. Then open the **Actions** tab and wait for the Pages workflow to succeed.

AIR MAIL is an independent project and is not affiliated with Google or Gmail.
