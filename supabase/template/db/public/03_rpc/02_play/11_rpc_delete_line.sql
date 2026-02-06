create or replace function rpc_delete_line (line_id uuid) RETURNS void as $$
#variable_conflict use_column
DECLARE
  p_line_id uuid := line_id;
  update_act_id uuid;
  update_scene_id uuid;
  v_user_id UUID := auth.uid();
  current_utc_time timestamp := now() at time zone 'utc';
BEGIN
  delete from lines
  where id = p_line_id
  RETURNING act_id, scene_id INTO update_act_id, update_scene_id;

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = update_act_id;

  UPDATE acts set
  updated_at = current_utc_time
  where id = update_act_id;

  if update_scene_id IS NOT NULL THEN
    UPDATE scenes set
    updated_at = current_utc_time
    where id = update_scene_id;
  END IF;

END;
$$ LANGUAGE plpgsql;
