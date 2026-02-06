create or replace view public.view_act_details
with
    (security_invoker = on) as
select
    a.id,
    a.play_id,
    a.sort_order,
    a.author_id,
    jsonb_build_object(
        'id',
        a.id,
        'sort_order',
        a.sort_order,
        'play_id',
        a.play_id,
        'updated_at',
        a.updated_at,
        'title',
        a.title
    ) as overview,
    (
        select
            COALESCE(
                jsonb_object_agg(
                    s.id,
                    jsonb_build_object(
                        'id',
                        s.id,
                        'act_id',
                        a.id,
                        'sort_order',
                        s.sort_order,
                        'concept',
                        s.concept,
                        'lines',
                        s.lines
                    )
                    order by
                        s.sort_order
                ),
                '{}'::jsonb
            )
        from
            public.view_scene_details s
        where
            s.act_id = a.id
    ) as scenes,
    (
        select
            COALESCE(
                jsonb_object_agg(
                    al.id,
                    jsonb_build_object(
                        'id',
                        al.id,
                        'content',
                        al.content,
                        'act_id',
                        a.id,
                        'scene_id',
                        al.scene_id,
                        'sort_order',
                        al.sort_order
                    )
                    order by
                        al.sort_order
                ),
                '{}'::jsonb
            )
        from
            lines al
        where
            al.act_id = a.id
            and al.scene_id is null
    ) as lines
from
    acts a
order by
    a.sort_order;
