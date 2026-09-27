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

  with inserted_act as (
    INSERT INTO acts (id, play_id, title, sort_order, author_id, created_at, updated_at)
    VALUES (p_act_id, p_play_id, p_title, p_sort_order, v_user_id, current_utc_time, current_utc_time)
    returning id, title, play_id, sort_order, updated_at
  ),
  inserted_line as (
    INSERT INTO lines (id, act_id, scene_id, sort_order, content, author_id, created_at, updated_at)
    VALUES (gen_random_uuid(), p_act_id, null, 1, '', v_user_id, current_utc_time, current_utc_time)
    returning id, content, act_id, scene_id, sort_order
  )
  SELECT jsonb_build_object(
    'overview', to_jsonb(a),
    'lines', (
      select jsonb_object_agg(
        l.id, to_jsonb(l)
      )
      from inserted_line l
      where l.scene_id is null
    ),
    'scenes', '{}'::jsonb
  )
  INTO result_json
  from inserted_act a;

  RETURN result_json;

END;
$function$;
