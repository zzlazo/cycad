create table public.acts (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    title text not null default '',
    sort_order smallint not null,
    author_id uuid not null,
    updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    id uuid not null default gen_random_uuid(),
    play_id uuid not null default gen_random_uuid(),
    constraint acts_pkey primary key (id),
    constraint acts_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint acts_play_id_fkey foreign KEY (play_id) references plays (id)
);

ALTER TABLE "public"."acts" ENABLE ROW LEVEL SECURITY;
