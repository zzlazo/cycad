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
  INSERT INTO lines
  VALUES (current_utc_time, p_sort_order, p_content, v_user_id, p_line_id, p_act_id, p_scene_id, current_utc_time);

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = p_act_id;

  UPDATE acts set
  updated_at = current_utc_time
  where id = p_act_id;

  if p_scene_id IS NOT NULL THEN
    UPDATE scenes set
    updated_at = current_utc_time
    where id = p_scene_id;
  END IF;
END;
$$ LANGUAGE plpgsql;
