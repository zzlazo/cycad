create or replace function rpc_create_line (
    line_id uuid,
    content text,
    sort_order integer,
    act_id uuid,
    scene_id uuid DEFAULT NULL
) RETURNS void as $$
DECLARE
  p_content text := content;
  p_line_id uuid := line_id;
  p_scene_id uuid := scene_id;
  p_act_id uuid := act_id;
  p_sort_order integer := sort_order;
  v_user_id UUID := auth.uid();
  current_utc_time timestamp := now() at time zone 'utc';
BEGIN
  INSERT INTO lines (id, act_id, scene_id, sort_order, content, author_id, created_at, updated_at)
  VALUES (p_line_id, p_act_id, p_scene_id, p_sort_order, p_content, v_user_id, current_utc_time, current_utc_time);

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = p_act_id;

  UPDATE acts set
  updated_at = current_utc_time
  where id = p_act_id;
END;
$$ LANGUAGE plpgsql;
