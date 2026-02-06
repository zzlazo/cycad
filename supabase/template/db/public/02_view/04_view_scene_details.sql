create or replace view public.view_scene_details
with
    (security_invoker = on) as
select
    s.id,
    s.act_id,
    s.sort_order,
    jsonb_build_object(
        'id',
        s.concept_id,
        'code',
        cc.code,
        'concept',
        cc.concept,
        'sort_order',
        cc.sort_order
    ) as concept,
    (
        select
            COALESCE(
                jsonb_object_agg(
                    sl.id,
                    jsonb_build_object(
                        'id',
                        sl.id,
                        'content',
                        sl.content,
                        'act_id',
                        sl.act_id,
                        'scene_id',
                        s.id,
                        'sort_order',
                        sl.sort_order
                    )
                    order by
                        sl.sort_order
                ),
                '[]'::jsonb
            )
        from
            lines sl
        where
            sl.scene_id = s.id
    ) as lines,
    s.author_id
from
    scenes s
    left join public.view_card_concepts_details cc on cc.id = s.concept_id
order by
    s.sort_order;
