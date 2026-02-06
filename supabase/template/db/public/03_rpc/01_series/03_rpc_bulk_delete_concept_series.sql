create or replace function rpc_bulk_delete_concept_series (id_list int[]) returns void as $$
begin
    delete from card_concepts 
    where card_concepts.series_id = ANY(rpc_bulk_delete_concept_series.id_list);

    delete from card_concept_series 
    where card_concept_series.id = ANY(rpc_bulk_delete_concept_series.id_list);
end;
$$ language plpgsql;
