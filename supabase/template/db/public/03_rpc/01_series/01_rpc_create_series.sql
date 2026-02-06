CREATE OR REPLACE FUNCTION rpc_create_series (title text, concepts jsonb) RETURNS integer AS $$
DECLARE
  new_series_id int;
  current_utc_time timestamp := now() at time zone 'utc';
  p_title text := title;
  v_user_id UUID := auth.uid();
BEGIN
  INSERT INTO card_concept_series (title, author_id, created_at, updated_at)
  VALUES (p_title, v_user_id, current_utc_time, current_utc_time)
  RETURNING id INTO new_series_id;

  INSERT INTO card_concepts (series_id, code_id, concept, author_id, created_at, updated_at)
  SELECT 
    new_series_id, 
    ((elem -> 'code') ->> 'id')::int, 
    (elem ->> 'concept'),            
    v_user_id, 
    current_utc_time, 
    current_utc_time
  FROM jsonb_array_elements(concepts) AS elem;

  RETURN new_series_id;

END;
$$ LANGUAGE plpgsql;
