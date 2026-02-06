create or replace function rpc_delete_play (play_id uuid) RETURNS void as $$
#variable_conflict use_column
DECLARE
  p_play_id uuid := play_id;
BEGIN
  delete from lines
  using acts
  where acts.id = lines.act_id and acts.play_id = p_play_id;

  delete from scenes
  using acts
  where acts.id = scenes.act_id and acts.play_id = p_play_id;

  delete from acts
  where play_id = p_play_id;

  delete from plays
  where id = p_play_id;

END;
$$ LANGUAGE plpgsql;
