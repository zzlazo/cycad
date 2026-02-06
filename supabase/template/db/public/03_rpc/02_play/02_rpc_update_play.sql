create or replace function rpc_update_play (title text, play_id uuid) RETURNS void as $$
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_title ALIAS FOR title;
  p_play_id ALIAS FOR play_id;
BEGIN
  update plays set
  title = p_title,
  updated_at = current_utc_time;

END;
$$ LANGUAGE plpgsql;
