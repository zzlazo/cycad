create table public.scenes (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    concept_id uuid not null,
    author_id uuid not null,
    sort_order smallint not null,
    act_id uuid not null,
    id uuid not null default gen_random_uuid(),
    constraint scenes_pkey primary key (id),
    constraint scenes_act_id_fkey foreign KEY (act_id) references acts (id),
    constraint scenes_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint scenes_concept_id_fkey foreign KEY (concept_id) references card_concepts (id)
);

ALTER TABLE "public"."scenes" ENABLE ROW LEVEL SECURITY;

-- 外部キーの検査は RLS を通らないため、他人のアクトやコンセプトを参照できないよう親の所有者も確かめる
create policy "Owner can manage own rows" on public.scenes
    for all to authenticated
    using (author_id = (select auth.uid()))
    with check (
        author_id = (select auth.uid())
        and exists (select 1 from public.acts a where a.id = scenes.act_id and a.author_id = (select auth.uid()))
        and exists (select 1 from public.card_concepts c where c.id = scenes.concept_id and c.author_id = (select auth.uid()))
    );
