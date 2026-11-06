-- 搬入現有資料。先把下面的電郵改成你在 Supabase 建立的帳號電郵，再按 Run。
with me as (select id from auth.users where email = 'you@example.com')
insert into public.items (user_id, coll, id, data)
select me.id, v.coll, v.id, v.data::jsonb
from me, (values
  ('tasks', 'gymverse', '{"id":"gymverse","text":"把 GymVerse 的動作清單或紀錄截圖傳給 Claude","date":"2026-11-06","done":false,"createdAt":"2026-11-06T02:30:00Z"}'),
  ('projects', 'personal-app', '{"id":"personal-app","name":"個人 App","createdAt":"2026-11-06T02:30:00Z","milestones":[{"id":"m1","text":"輪班日曆和訓練紀錄","done":true},{"id":"m2","text":"待辦清單","done":true},{"id":"m3","text":"專案進度","done":true},{"id":"m4","text":"在 iPhone 試用 2–4 週","done":false},{"id":"m5","text":"決定是否做成可離線的獨立 PWA","done":false}]}')
) as v(coll, id, data)
on conflict (user_id, coll, id) do nothing
returning coll, id;
