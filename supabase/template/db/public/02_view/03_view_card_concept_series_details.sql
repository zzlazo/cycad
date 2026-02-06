create or replace view public.view_card_concept_series_details
with
    (security_invoker = on) as
select
    jsonb_build_object(
        'id',
        s.id,
        'title',
        s.title,
        'updated_at',
        s.updated_at
    ) as overview,
    (
        select
            COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'id',
                        cc.id,
                        'series_id',
                        cc.series_id,
                        'code',
                        cc.code,
                        'concept',
                        cc.concept,
                        'author_id',
                        cc.author_id
                    )
                    order by
                        cc.sort_order
                ),
                '[]'::jsonb
            )
        from
            view_card_concepts_details cc
        where
            cc.series_id = s.id
    ) as concepts,
    s.author_id
from
    card_concept_series s
