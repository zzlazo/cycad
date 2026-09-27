-- デモ用データ。v_email をサインイン済みユーザーのメールアドレスに書き換えて実行する。
-- アプリと同じ形のデータにするため、作成はできるだけ RPC を通す。
do $demo$
declare
  v_email text := 'you@example.com';
  v_user_id uuid;
  v_travel_id uuid;
  v_refactoring_id uuid;
  v_play_id uuid := gen_random_uuid();
  v_act1_id uuid := gen_random_uuid();
  v_act2_id uuid := gen_random_uuid();
  v_act3_id uuid := gen_random_uuid();
  v_act_json jsonb;
  v_scene_id uuid;
  v_scene record;
  v_line text;
  v_line_order int;
begin
  select id into v_user_id from auth.users where email = v_email;
  if v_user_id is null then
    raise exception 'user not found: %', v_email;
  end if;

  -- RPC は auth.uid() で作成者を決めるため、対象ユーザーとして振る舞う
  perform set_config('request.jwt.claims', json_build_object('sub', v_user_id)::text, true);

  if exists (select 1 from card_concept_series where author_id = v_user_id and title in ('旅行英会話', 'リファクタリング演習')) then
    raise exception 'demo data already exists for %', v_email;
  end if;

  -- スートをカテゴリとして使い、数字が大きいほど難しくなるように並べる
  -- card_suits.id の振り方は環境によって異なるため、スートは value で引く
  v_travel_id := rpc_create_series(
    title => '旅行英会話',
    concepts => (
      select jsonb_agg(
        jsonb_build_object('code', jsonb_build_object('id', cc.id), 'concept', w.concept)
        order by cs.position, cn.value
      )
      from (values
        ('spade', array['空港', 'ホテル', 'レストラン', 'カフェ', '駅', 'タクシー', 'ショッピングモール', '美術館', '薬局', '銀行', '病院', '警察署', '大使館']),
        ('heart', array['道に迷った', '注文と違う料理が来た', 'Wi-Fi がつながらない', '小銭がない', '予約が見つからない', '電車に乗り遅れた', '荷物が出てこない', 'クレジットカードが使えない', '体調が悪い', '財布をなくした', 'フライトが欠航した', 'パスポートをなくした', '事故に巻き込まれた']),
        ('diamond', array['店員', '受付スタッフ', '通りすがりの人', '駅員', 'タクシー運転手', '同じツアーの旅行者', 'ホテルの支配人', '子ども連れの家族', '早口な人', '英語が苦手な人', '怒っている人', '警察官', '医師']),
        ('club', array['自由に話す', 'ジェスチャーあり', 'メモを見てもよい', 'ゆっくり話す', '丁寧な表現で', '30秒以内で', '3文以上で', '質問を2つ入れる', '相手の言葉を言い換えて確認する', 'ジェスチャーなし', '知らない単語を使わずに', '冗談を1つ入れる', '1分間止まらずに'])
      ) as s(suit, concepts)
      cross join lateral unnest(s.concepts) with ordinality as w(concept, number_value)
      inner join card_suits cs on cs.value = s.suit
      inner join card_numbers cn on cn.value = w.number_value
      inner join card_codes cc on cc.suit_id = cs.id and cc.number_id = cn.id
    )
  );

  -- 1〜10 のプリセット（40枚）で作り、52枚のシリーズとの違いを見せる
  v_refactoring_id := rpc_create_series(
    title => 'リファクタリング演習',
    concepts => (
      select jsonb_agg(
        jsonb_build_object('code', jsonb_build_object('id', cc.id), 'concept', w.concept)
        order by cs.position, cn.value
      )
      from (values
        ('spade', array['マジックナンバー', '長すぎる関数', '重複したコード', '深いネスト', '長い引数リスト', 'フラグ引数', '神クラス', '変更の分散', '機能の横恋慕', 'データの群れ']),
        ('heart', array['変数の抽出', '早期リターン', '定数の導入', '関数の抽出', '関数名の変更', '引数オブジェクトの導入', '関数の移動', 'クラスの抽出', 'ポリモーフィズムによる条件分岐の置き換え', '委譲の隠蔽']),
        ('diamond', array['制限なし', 'テストを先に書く', '10分以内', '3ステップ以内', '公開 API を変えない', '1ステップごとにコミット', '新しいクラスを作らない', '行数を増やさない', 'IDE の自動リファクタリングなし', '口頭で説明しながら']),
        ('club', array['バリデーション', '日付計算', '料金計算', 'CSV 出力', 'ログ出力', '認証', '在庫管理', '通知送信', '検索条件の組み立て', '注文確定'])
      ) as s(suit, concepts)
      cross join lateral unnest(s.concepts) with ordinality as w(concept, number_value)
      inner join card_suits cs on cs.value = s.suit
      inner join card_numbers cn on cn.value = w.number_value
      inner join card_codes cc on cc.suit_id = cs.id and cc.number_id = cn.id
    )
  );

  perform rpc_create_play(play_id => v_play_id, title => 'ハワイ旅行の準備', series_id => v_travel_id);

  -- アクト1: 書き込み済み。完成形を見せるため、各スートから1枚ずつ選んで1つの場面にする
  v_act_json := rpc_create_act(act_id => v_act1_id, play_id => v_play_id, sort_order => 1, title => '第1回 空港でのトラブル');
  perform rpc_update_line(
    line_id => (select key::uuid from jsonb_object_keys(v_act_json -> 'lines') as key limit 1),
    content => '今日のテーマ: 到着ロビーでのトラブル対応。最初の一言を迷わず出す。'
  );

  for v_scene in
    select * from (values
      (1, 'spade',   1, array['到着ロビーのバゲージクレームで待っている想定。']),
      (2, 'heart',   7, array['My suitcase hasn''t come out yet. Could you check where it is?', 'Here is my claim tag. もすぐ出せるようにしておく。']),
      (3, 'diamond', 2, array['カウンターのスタッフに話しかける。Excuse me から入るのを忘れない。']),
      (4, 'club',    6, array['1回目は45秒かかった。2回目で28秒。'])
    ) as t(sort_order, suit, number_value, lines)
  loop
    v_scene_id := gen_random_uuid();
    insert into scenes (id, act_id, sort_order, concept_id, author_id)
    select v_scene_id, v_act1_id, v_scene.sort_order, c.id, v_user_id
    from card_concepts c
    inner join card_codes cc on cc.id = c.code_id
    inner join card_suits cs on cs.id = cc.suit_id
    inner join card_numbers cn on cn.id = cc.number_id
    where c.series_id = v_travel_id and cs.value = v_scene.suit and cn.value = v_scene.number_value;

    v_line_order := 1;
    foreach v_line in array v_scene.lines loop
      perform rpc_create_line(line_id => gen_random_uuid(), content => v_line, sort_order => v_line_order, act_id => v_act1_id, scene_id => v_scene_id);
      v_line_order := v_line_order + 1;
    end loop;
  end loop;

  -- アクト2: カードを引いただけで、まだ書き込んでいない状態
  perform rpc_create_act(act_id => v_act2_id, play_id => v_play_id, sort_order => 2, title => '第2回 ランダム練習');
  perform rpc_pull_scene_list(act_id => v_act2_id, scene_length => 4);

  -- アクト3: 作成直後の状態。閲覧者に「カードを引く」を試してもらう
  perform rpc_create_act(act_id => v_act3_id, play_id => v_play_id, sort_order => 3, title => '第3回');
end
$demo$;
