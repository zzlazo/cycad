# Cycad Server

## Setup

### Setup Supabase Instance
First, create a new project on [Supabase](https://supabase.com/). Once your project is ready, obtain your project credentials.

### Environment Variables
Copy your Supabase URL and Key into the app's configuration file.

Create (or update) `app/.env`:
```properties
SUPABASE_URL=
SUPABASE_KEY=
```

### Initialize Database

1. Execute the SQL files located in `template/db/public/` in numeric order based on their filenames (e.g., 01_..., 02_...).

2. Configure RLS: Ensure you configure the RLS (Row Level Security) policies for each table to match your security requirements and access control preferences.
