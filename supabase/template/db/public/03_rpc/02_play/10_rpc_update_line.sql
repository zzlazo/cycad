create or replace function rpc_update_line (content text, line_id uuid) RETURNS void as $$
DECLARE
  p_content text := content;
  p_line_id uuid := line_id;
  update_act_id uuid;
  v_user_id UUID := auth.uid();
  current_utc_time timestamp := now() at time zone 'utc';
BEGIN
  update lines set
  content = p_content,
  updated_at = current_utc_time
  where id = p_line_id
  RETURNING act_id INTO update_act_id;

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = update_act_id;

  UPDATE acts set
  updated_at = current_utc_time
  where id = update_act_id;

END;
$$ LANGUAGE plpgsql;
