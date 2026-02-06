create or replace function rpc_check_exist_series_play (id integer) returns boolean as $$
declare
p_id integer := id;
begin
  return exists (
    select 1
    from plays
    where series_id = p_id
  );
end;
$$ language plpgsql;
