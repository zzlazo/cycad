CREATE OR REPLACE FUNCTION public.rpc_create_act (
    act_id uuid,
    play_id uuid,
    sort_order integer,
    title text
) RETURNS jsonb LANGUAGE plpgsql AS $function$
#variable_conflict use_column
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_act_id uuid := act_id;
  p_play_id uuid := play_id;
  p_sort_order integer := sort_order;
  v_user_id UUID := auth.uid();
  result_json jsonb;
  p_title text := title;
BEGIN
  
  UPDATE plays set
  updated_at = current_utc_time
  where id = p_play_id;

  -- lines の RLS は親の acts が自分のものかを確かめる。同じ文の CTE で入れた行はその確認から見えないため、文を分ける
  INSERT INTO acts (id, play_id, title, sort_order, author_id, created_at, updated_at)
  VALUES (p_act_id, p_play_id, p_title, p_sort_order, v_user_id, current_utc_time, current_utc_time);

  INSERT INTO lines (id, act_id, scene_id, sort_order, content, author_id, created_at, updated_at)
  VALUES (gen_random_uuid(), p_act_id, null, 1, '', v_user_id, current_utc_time, current_utc_time);

  SELECT jsonb_build_object(
    'overview', (
      select to_jsonb(a)
      from (select id, title, play_id, sort_order, updated_at from acts where id = p_act_id) a
    ),
    'lines', (
      select jsonb_object_agg(
        l.id, to_jsonb(l)
      )
      from (select id, content, act_id, scene_id, sort_order from lines where act_id = p_act_id and scene_id is null) l
    ),
    'scenes', '{}'::jsonb
  )
  INTO result_json;

  RETURN result_json;

END;
$function$;
