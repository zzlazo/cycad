CREATE OR REPLACE FUNCTION rpc_update_series (id int, title text, concepts jsonb) RETURNS void AS $$
DECLARE
  current_utc_time timestamp := now() at time zone 'utc';
  p_id ALIAS FOR id;
  p_title ALIAS FOR title;
  v_user_id UUID := auth.uid();
BEGIN
  UPDATE card_concept_series AS s
  SET title = p_title,
      updated_at = current_utc_time
  WHERE s.id = p_id;

  DELETE FROM card_concepts WHERE series_id = p_id;

  INSERT INTO card_concepts (series_id, code_id, concept, author_id, created_at, updated_at)
  SELECT 
    p_id, 
    ((elem -> 'code') ->> 'id')::int, 
    (elem ->> 'concept'),            
    v_user_id, 
    current_utc_time, 
    current_utc_time
  FROM jsonb_array_elements(concepts) AS elem;
END;
$$ LANGUAGE plpgsql;
