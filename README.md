# AIR MAIL ✉️

**A clean, modern email workspace by ANI STUDIO.**

Live site (after enabling GitHub Pages): https://anirudhadebbarma031214-commits.github.io/AIR-MAIL/

## Current build
- Responsive dark navy / cyan email interface
- Inbox, Starred, Sent, Drafts, Spam and Trash navigation
- Search through messages
- Compose preview messages and move them to Trash
- Sample messages and locally saved preview data

## Important: preview, not real email yet
This repository currently contains a front-end preview. Messages are stored in the current browser only. The “Send preview” action does **not** deliver email. The sample `.example` and `.test` addresses are not real mailboxes.

A real email service requires secure account authentication, a database with per-user access rules, an outbound email provider, inbound email routing/processing, domain ownership and DNS records (MX, SPF, DKIM, and DMARC). Never put service-role keys or email-provider secrets in browser JavaScript or a public repository.

## Publish with GitHub Pages
1. Open the repository **Settings**.
2. Select **Pages** in the left sidebar.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Select branch `main` and folder `/ (root)`, then click **Save**.
5. Wait for the Pages deployment to finish, then open the URL above.

## Next steps for real mail
1. Add authentication and a database (for example, Supabase) with strict per-user row-level security.
2. Add a server-side function for outbound mail using a verified domain and email provider.
3. Configure inbound email routing and safely process incoming messages.
4. Add account recovery, spam controls, rate limits, abuse monitoring and privacy policies.
5. Test with private test accounts before public launch.

AIR MAIL is an independent project and is not affiliated with Google or Gmail.
