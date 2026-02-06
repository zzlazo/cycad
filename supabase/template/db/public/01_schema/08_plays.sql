create table public.plays (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    title text not null default '',
    updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    series_id bigint not null,
    author_id uuid not null,
    id uuid not null default gen_random_uuid(),
    constraint plays_pkey primary key (id),
    constraint plays_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint plays_series_id_fkey foreign KEY (series_id) references card_concept_series (id)
);

ALTER TABLE "public"."plays" ENABLE ROW LEVEL SECURITY;
