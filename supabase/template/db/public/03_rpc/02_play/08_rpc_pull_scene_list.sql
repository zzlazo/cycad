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

  -- lines の RLS は親の scenes が自分のものかを確かめる。同じ文の CTE で入れた行はその確認から見えないため、文を分ける
  insert into scenes (id, act_id, sort_order, author_id, concept_id, created_at)
  select gen_random_uuid(), p_act_id, (row_number() over())+1, v_user_id, r.id, current_utc_time
  from (
    select c.id
    from view_card_concepts_details c
    inner join plays p on p.series_id = c.series_id
    inner join acts a on a.play_id = p.id
    where a.id = p_act_id
    order by random()
    limit p_scene_length
  ) r;

  insert into lines (id, act_id, scene_id, sort_order, content, created_at, author_id)
  select gen_random_uuid(), p_act_id, s.id, 1, '', current_utc_time, v_user_id
  from scenes s
  where s.act_id = p_act_id;

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
        from lines l
        where l.scene_id = s.id
      ),
      'concept', jsonb_build_object(
        'id', s.concept_id,
        'code', c.code,
        'concept', c.concept
      )
  ) order by s.sort_order) into result_json
  from scenes s
  inner join view_card_concepts_details c on c.id = s.concept_id
  where s.act_id = p_act_id;

  return result_json;

END;
$$ LANGUAGE plpgsql;
