create or replace function rpc_pull_scene_list (act_id uuid, scene_length integer) RETURNS jsonb as $$
#variable_conflict use_column
DECLARE
  p_act_id uuid := act_id;
  p_scene_length integer := scene_length;
  v_user_id UUID := auth.uid();
  current_utc_time timestamp := now() at time zone 'utc';
  result_json jsonb;
BEGIN
  delete from lines
  using scenes
  where lines.scene_id = scenes.id and scenes.act_id = p_act_id;

  delete from scenes
  where act_id = p_act_id;

  with random_concepts as (
    select id, code, concept
    from view_card_concepts_details
    order by random()
    limit p_scene_length
  ),
  inserted_scenes as (
        insert into scenes (id, act_id, sort_order, author_id, concept_id, created_at)
        select gen_random_uuid(), p_act_id, (row_number() over())+1, v_user_id, r.id, current_utc_time
        from random_concepts r
        returning id, act_id, sort_order, concept_id, created_at
  ),
  inserted_lines as (
    insert into lines (id, act_id, scene_id, sort_order, content, created_at, author_id)
    select gen_random_uuid(), p_act_id, s.id, 1, '', current_utc_time, v_user_id
    from inserted_scenes s
    returning id, act_id, scene_id, sort_order, content, created_at
  )
  select jsonb_agg(jsonb_build_object(
      'id', s.id,
      'sort_order', s.sort_order,
      'act_id', s.act_id,
      'lines', (
        select jsonb_object_agg(l.id, jsonb_build_object(
          'id', l.id,
          'sort_order', l.sort_order,
          'scene_id', s.id,
          'act_id', l.act_id,
          'content', l.content
        ))
        from inserted_lines l
        where l.scene_id = s.id
      ),
      'concept', jsonb_build_object(
        'id', s.concept_id,
        'code', r.code,
        'concept', r.concept
      )
  )) into result_json
  from inserted_scenes s
  inner join random_concepts r on r.id = s.concept_id;

  return result_json;

END;
$$ LANGUAGE plpgsql;
