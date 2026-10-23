# 🐼 Cyan Panda Tool

Tool quản lý fan TikTok của CYAN — bản **v3.0**.
Chạy tại: https://nameerrorcantnotfind.github.io/cyan-pandatool/
Verified `bUQOGRMp7lPCfbDy3jV0mn5iTOaNM7Wy`

## Chạy ngay (không cần build)

Bản này là **single-file**: chỉ cần `index.html` + `callback.html`.
Mở thẳng `index.html` bằng trình duyệt là dùng được (dữ liệu lưu localStorage).
Nếu đã có project Supabase: vào tab **Kết nối → Supabase**, dán URL + Anon Key để bật đồng bộ thật.

## Đẩy lên GitHub (ghi nhớ version bằng Git)

```bash
cd cyan-panda-tool
git init
git add .
git commit -m "Cyan Panda Tool v2.7"
git branch -M main
git remote add origin https://github.com/nameerrorcantnotfind/cyan-pandatool.git
git push -u origin main
```

Sau đó vào repo → **Settings → Pages → Deploy from a branch → main / (root) → Save**.
Mỗi lần nâng version: sửa code → `git add . && git commit -m "v2.8: ..."` → `git push` — GitHub tự lưu toàn bộ lịch sử version.

## Deploy Backend Supabase (1 lần)

1. Tạo project tại supabase.com → **SQL Editor** → chạy `supabase/schema.sql`.
2. Deploy Edge Functions:
   ```bash
   supabase functions deploy panda-keepalive
   supabase functions deploy tiktok-proxy
   supabase functions deploy panda-daily-learn
   supabase functions deploy scan-private
   ```
3. **Edge Functions → Secrets**: thêm `TIKTOK_CLIENT_KEY=sbaw7zo3lbxb8g9ih1` và
   `TIKTOK_CLIENT_SECRET=<secret thật>` (secret KHÔNG bao giờ để trong code/FE).
4. Thay `YOUR-PROJECT` trong phần pg_cron của `schema.sql` bằng ref project của bạn rồi chạy lại đoạn cron.

## Lỗi non_sandbox_target

Tài khoản TikTok dùng để đăng nhập chưa nằm trong Sandbox Target users:
developers.tiktok.com → App (key sbaw7…) → **Sandbox → Target users → Add @username của bạn → Save** → đợi 1 phút → đăng nhập lại.

## Changelog

- **v3.0 (24/10/2026)** — Theo review của CYAN trên v2.9: **QR nhúng sẵn trong file** (vẽ offline, hết lỗi không hiện mã);
  header gọn — số version thành nút **▾ mở menu changelog** từng bản; thêm nút **🔴 Chức năng Live** (khi bật: dừng rep,
  vẫn quét realtime, đọc tin trong khoảng ngày chọn để học); **bảng fan lọc theo thời gian tin nhắn gần nhất** + sắp xếp
  mới nhất lên đầu + cột Tin gần nhất; **gộp Fan Mới vào tab Fan** (quét 3 tiêu chí: <5 tin/7 ngày, đã gửi chưa rep,
  follow chưa/đã chấp nhận) và bỏ tab riêng; **bỏ thêm fan thủ công** — fan chỉ đến từ tin nhắn, danh mục mặc định
  *Chưa phân loại* chỉnh tay qua modal Sửa, **thân mật do AI đánh giá**; **Log Realtime lên đầu tab Inbox** + lọc theo
  danh mục/thời gian + bấm dòng log mở hội thoại + tắt realtime thì **quét chu kỳ 30s/60s/3p/5p**; **Panda Sleep Mode**
  (tự ngủ sau 5 phút không hoạt động, banner 💤, đánh thức đồng bộ tin mới, SUP_001 INFO); **Đào tạo AI theo fan đã chọn**
  (sắp xếp theo độ gần + danh mục), **Học lại +7 ngày** (30→37), gói học **văn vở/chơi chữ/troll/thả thính**, bảng tài
  liệu **Đã phân tích · Đã học · Đã lưu DB**; Kết Nối thêm **Lấy link + Kiểm tra đăng nhập**, card **Supabase • SUP_001**
  và **AI Multi-Flow 6 providers** (mỗi AI một nhóm user), bỏ đăng nhập đơn giản.

- **v2.9 (23/10/2026)** — Theo bản quét thiếu của CYAN: thêm **Chờ duyệt AI** (DM mới → AI sinh 3 gợi ý theo xưng hô/style →
  Duyệt/Sửa/Từ chối → đã duyệt có 10s để Hủy, banner đen 🐼 đếm ngược, MSG_001/QUEUE_001); **5 danh mục đúng màu gốc**
  (VIP vàng, Ưu tiên xanh lá, Fan nhí cyan, Bỏ qua xám, Fan mới hồng); Đào Tạo AI về đúng gốc (fetch 30 ngày cố định,
  progress step 15/150ms, AI_003 phân tích xưng hô, LIC_002 auto bump version); **tab Kết Nối thay mới hoàn toàn**:
  bỏ Google login / TikTok thường / multi-account / link + code thủ công → chỉ còn Quét QR (modal QR từ link authorize,
  state cyan_panda_qr) + Đăng nhập đơn giản (tiktok_simple, ghi chú) + Client Config (Check Client SYS_001/ERR_001,
  Save LIC_001 vào supa_cfg + accounts). Footer thêm OFFICIAL DOMAIN.

- **v2.8 (23/10/2026)** — Gộp đủ chức năng v2.6.1 (từ file V2-09 của CYAN) + yêu cầu mới: 5 tab chính (Quản Lý Fan / Inbox /
  Fan Mới / Đào Tạo AI / Kết Nối) + 2 tab phụ (Câu Chuyện & Ký Ức / Test Logs & Deploy). Lọc fan đa chiều (VIP, ưu tiên
  cao/vừa/thấp, thân mật 1–10, khung giờ Sáng/Chiều/Tối/Khuya, search); field vip:boolean + priority + badge vàng;
  modal Thêm/Sửa/Xóa fan (khóa 🔒 @username); lọc tin nhắn theo 7/15/30/90 ngày ở Inbox + slider ngày ở Đào Tạo AI;
  WHO 2 panel + batch nhóm (Nhóm 1: 3 người…); preset gửi (WHO / VIP+Ưu tiên cao / tất cả trừ Bỏ qua) + bảng status
  per-user (MSG_001); log realtime đúng 4 dòng mẫu 🍀 + max-h 140px; Fan Mới quét + tự thêm; Memory DB tăng dần
  (MEM_001) + Câu chuyện theo ngày + bảng tình huống + heatmap 0–24h + word cloud + emotion timeline; tài liệu dạy AI
  (panda_docs_db_v261); AI Multi-Flow mẫu style (AI_003); token: kiểm tra/làm mới (LIC_101), test gửi tin (API_002),
  lấy thông tin mới nhất (TIK_002); lưu key/secret theo @username (LIC_002). DB: panda_ai_db_v261 + panda_docs_db_v261
  + supa_cfg + panda_real_token_v262 + panda_google_v262. Đủ 11 code gốc 261 + TOKEN_EXCHANGE/TIK_LOGIN_SUCCESS/INBOX_FETCH/API_002.
  Đồng thời có bản Artifact cùng tên trong Muse để dùng trực tiếp (dữ liệu lưu phía server của artifact).
- **v2.7 (23/10/2026)** — Bỏ overlay chặn khi chuyển tab (thay bằng badge 🔒 nhỏ); gắn sẵn Official Sandbox Key
  `sbaw7zo3lbxb8g9ih1`; hộp hướng dẫn fix `non_sandbox_target`; tạo link đăng nhập TikTok thật + đổi code → token;
  callback.html hứng code từ Redirect URI; Supabase runtime config ngay trong tool; full BE source (schema + 4 Edge Functions + pg_cron).
- **v2.6.1** — FIX WHO bulk + AUTO AI + TikTok lock (bản gốc của CYAN).
