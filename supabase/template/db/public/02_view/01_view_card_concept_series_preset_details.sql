create or replace view public.view_card_concept_series_preset_details
with
    (security_invoker = on) as
select
    p.id,
    p.title,
    p.description,
    p.author_id,
    (
        select
            COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'id',
                        c.code_id,
                        'suit',
                        jsonb_build_object(
                            'id',
                            ci.suit_id,
                            'name',
                            s.name,
                            'value',
                            s.value
                        ),
                        'number',
                        jsonb_build_object(
                            'id',
                            ci.number_id,
                            'name',
                            n.name,
                            'value',
                            n.value
                        )
                    )
                ),
                '[]'::jsonb
            )
        from
            card_concept_series_preset_codes c
            inner join card_codes ci on ci.id = c.code_id
            inner join card_suits s on s.id = ci.suit_id
            inner join card_numbers n on n.id = ci.number_id
        where
            c.preset_id = p.id
    ) as codes
from
    card_concept_series_presets p;
