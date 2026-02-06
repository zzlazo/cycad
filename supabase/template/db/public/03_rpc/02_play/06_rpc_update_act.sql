create or replace function rpc_update_act (title text, act_id uuid) RETURNS void as $$
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_title text := title;
  p_act_id uuid := act_id;
BEGIN
  update acts set
  title = p_title,
  updated_at = current_utc_time
  where id = p_act_id;

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = p_act_id;

END;
$$ LANGUAGE plpgsql;
