create table public.lines (
    created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    sort_order smallint not null,
    content text not null default '',
    author_id uuid not null,
    id uuid not null default gen_random_uuid(),
    act_id uuid not null default gen_random_uuid(),
    scene_id uuid null,
    updated_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'),
    constraint lines_pkey primary key (id),
    constraint lines_act_id_fkey foreign KEY (act_id) references acts (id),
    constraint lines_author_id_fkey foreign KEY (author_id) references auth.users (id),
    constraint lines_scene_id_fkey foreign KEY (scene_id) references scenes (id)
);

ALTER TABLE "public"."lines" ENABLE ROW LEVEL SECURITY;
