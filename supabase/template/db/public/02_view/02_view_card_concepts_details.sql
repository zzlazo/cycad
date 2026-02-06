CREATE OR REPLACE VIEW public.view_card_concepts_details
WITH
    (security_invoker = on) AS
SELECT
    cc.id,
    cc.series_id,
    jsonb_build_object(
        'id',
        cc.code_id,
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
    ) AS code,
    COALESCE(cc.concept, ''::text) AS concept,
    cc.author_id,
    cc.sort_order
FROM
    card_concepts cc
    INNER JOIN card_codes ci ON ci.id = cc.code_id
    INNER JOIN card_suits s ON s.id = ci.suit_id
    INNER JOIN card_numbers n ON n.id = ci.number_id
ORDER BY
    cc.series_id ASC,
    cc.sort_order ASC;
