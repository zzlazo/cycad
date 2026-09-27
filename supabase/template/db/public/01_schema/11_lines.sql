create table public.lines (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    sort_order smallint not null,
    content text not null default '',
    author_id uuid not null,
    id uuid not null default gen_random_uuid(),
    act_id uuid not null,
    scene_id uuid null,
    updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    constraint lines_pkey primary key (id),
    constraint lines_act_id_fkey foreign KEY (act_id) references acts (id),
    constraint lines_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint lines_scene_id_fkey foreign KEY (scene_id) references scenes (id)
);

ALTER TABLE "public"."lines" ENABLE ROW LEVEL SECURITY;

-- 外部キーの検査は RLS を通らないため、他人のアクトやシーンにぶら下げられないよう親の所有者も確かめる
create policy "Owner can manage own rows" on public.lines
    for all to authenticated
    using (author_id = (select auth.uid()))
    with check (
        author_id = (select auth.uid())
        and exists (select 1 from public.acts a where a.id = lines.act_id and a.author_id = (select auth.uid()))
        and (lines.scene_id is null or exists (select 1 from public.scenes sc where sc.id = lines.scene_id and sc.author_id = (select auth.uid())))
    );
