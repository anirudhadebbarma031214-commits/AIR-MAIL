import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};
function reply(status: number, payload: Record<string, unknown>) {
  return new Response(JSON.stringify(payload), { status, headers: corsHeaders });
}
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return reply(405, { error: "Use POST." });
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) return reply(401, { error: "Sign in before sending mail." });
  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const publishableKey = Deno.env.get("SUPABASE_PUBLISHABLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  if (!supabaseUrl || !publishableKey) return reply(500, { error: "Server Supabase configuration is missing." });
  const supabase = createClient(supabaseUrl, publishableKey, {
    global: { headers: { Authorization: authHeader } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const token = authHeader.slice("Bearer ".length);
  const { data: userData, error: userError } = await supabase.auth.getUser(token);
  const user = userData.user;
  if (userError || !user || !user.email || user.is_anonymous) return reply(401, { error: "A confirmed, non-anonymous account is required." });
  let payload: { to?: unknown; subject?: unknown; body?: unknown };
  try { payload = await req.json(); } catch { return reply(400, { error: "Invalid JSON request." }); }
  const to = typeof payload.to === "string" ? payload.to.trim() : "";
  const subject = typeof payload.subject === "string" ? payload.subject.trim() : "";
  const body = typeof payload.body === "string" ? payload.body.trim() : "";
  if (!to || to.length > 320 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(to)) return reply(400, { error: "Enter a valid recipient email address." });
  if (subject.length > 300 || body.length < 1 || body.length > 50000) return reply(400, { error: "Subject must be 300 characters or fewer and message body must be 1–50,000 characters." });
  const resendKey = Deno.env.get("RESEND_API_KEY");
  const from = Deno.env.get("AIR_MAIL_FROM");
  if (!resendKey || !from) return reply(503, { error: "Email delivery is not configured yet. Add RESEND_API_KEY and AIR_MAIL_FROM in Supabase Edge Function secrets after verifying a sender domain in Resend." });
  const mailResponse = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { Authorization: `Bearer ${resendKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({ from, to: [to], subject: subject || "(no subject)", text: body, reply_to: user.email }),
  });
  if (!mailResponse.ok) {
    const detail = await mailResponse.text();
    console.error("Resend delivery failed:", mailResponse.status, detail.slice(0, 500));
    return reply(502, { error: "The email provider rejected this message. Check your verified sender domain and provider configuration." });
  }
  const { data: saved, error: saveError } = await supabase.from("air_mail_messages").insert({
    owner_id: user.id, sender_email: user.email, recipient_email: to, subject, body, folder: "Sent", is_read: true,
  }).select("id").single();
  if (saveError) {
    console.error("Email delivered but saving Sent record failed:", saveError.message);
    return reply(500, { delivered: true, warning: "Email was accepted by the provider, but AIR MAIL could not save it to Sent." });
  }
  const providerData = await mailResponse.json().catch(() => ({}));
  return reply(200, { ok: true, delivered: true, messageId: providerData.id ?? null, id: saved.id });
});
