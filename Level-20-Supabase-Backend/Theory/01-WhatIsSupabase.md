# What is Supabase?

Supabase is a **Backend-as-a-Service** on top of **PostgreSQL**.

## Pieces you will use

| Piece | Job |
|-------|-----|
| Auth | Sign up / sign in / sessions (JWT) |
| Database | Real SQL tables |
| RLS | Security rules *inside* Postgres |
| Storage | Files (images) |
| Realtime | Listen to row changes |

## Big idea

Your Flutter app uses the **anon key** only. Safety comes from **RLS policies**, not from hiding the key.

## Analogy

Firebase Firestore = filing cabinets of documents.  
Supabase = spreadsheet tables with locks on each row.
