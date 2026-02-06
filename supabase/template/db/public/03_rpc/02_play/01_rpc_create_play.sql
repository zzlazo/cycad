create or replace function rpc_create_play (play_id uuid, title text, series_id integer) RETURNS void as $$
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_id ALIAS for play_id;
  p_title ALIAS FOR title;
  p_series_id ALIAS FOR series_id;
  v_user_id UUID := auth.uid();
BEGIN
  INSERT INTO plays (id, title, author_id, created_at, updated_at, series_id)
  VALUES (p_id, p_title, v_user_id, current_utc_time, current_utc_time, p_series_id);

END;
$$ LANGUAGE plpgsql;
