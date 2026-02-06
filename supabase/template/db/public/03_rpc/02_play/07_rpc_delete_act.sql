create or replace function rpc_delete_act (act_id uuid) RETURNS void as $$
#variable_conflict use_column
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_act_id uuid := act_id;
BEGIN
  delete from lines
  where act_id = p_act_id;

  delete from scenes
  using acts
  where acts.id = scenes.act_id and acts.id = p_act_id;

  UPDATE plays set
  updated_at = current_utc_time
  from acts
  where acts.play_id = plays.id and acts.id = p_act_id;

  delete from acts
  where id = p_act_id;



END;
$$ LANGUAGE plpgsql;
