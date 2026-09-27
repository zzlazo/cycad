-- CREATE OR REPLACE で関数を定義し直すと search_path の設定が消えるため、RPC を変更したらこのファイルも再実行する
do $$
declare
  f regprocedure;
begin
  for f in
    select p.oid::regprocedure
    from pg_proc p
    where p.pronamespace = 'public'::regnamespace and p.proname like 'rpc\_%'
  loop
    execute format('alter function %s set search_path = public', f);
    -- auth.uid() が null の未ログイン状態では author_id の制約で失敗するだけだが、そもそも呼べないようにする
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end
$$;
