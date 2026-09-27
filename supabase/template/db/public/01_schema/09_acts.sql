create table public.acts (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    title text not null default '',
    sort_order smallint not null,
    author_id uuid not null,
    updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    id uuid not null default gen_random_uuid(),
    play_id uuid not null,
    constraint acts_pkey primary key (id),
    constraint acts_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint acts_play_id_fkey foreign KEY (play_id) references plays (id)
);

ALTER TABLE "public"."acts" ENABLE ROW LEVEL SECURITY;

-- 外部キーの検査は RLS を通らないため、他人のプレイにぶら下げられないよう親の所有者も確かめる
create policy "Owner can manage own rows" on public.acts
    for all to authenticated
    using (author_id = (select auth.uid()))
    with check (
        author_id = (select auth.uid())
        and exists (select 1 from public.plays p where p.id = acts.play_id and p.author_id = (select auth.uid()))
    );
