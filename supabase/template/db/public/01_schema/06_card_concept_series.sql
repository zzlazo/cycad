create table public.card_concept_series (
    id uuid not null default gen_random_uuid(),
    created_at timestamp with time zone not null default (now() at time zone 'utc'),
    title text not null default '',
    author_id uuid not null,
    updated_at timestamp with time zone not null default (now() at time zone 'utc'),
    constraint card_concept_series_pkey primary key (id),
    constraint card_concept_series_author_id_fkey foreign KEY (author_id) references auth.users (id)
);

ALTER TABLE "public"."card_concept_series" ENABLE ROW LEVEL SECURITY;

create policy "Owner can manage own rows" on public.card_concept_series
    for all to authenticated
    using (author_id = (select auth.uid()))
    with check (author_id = (select auth.uid()));
