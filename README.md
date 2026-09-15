# 🔄 ERP Order-to-Cash (O2C) Süreç & Darboğaz Analitiği

Uçtan uca kurumsal satış operasyonlarında (Order-to-Cash) departmanlar arası operasyonel darboğazları, SLA (Hizmet Seviyesi Taahhüdü) ihlallerini ve nakit akışını riske atan gecikmiş tahsilatları tespit etmek amacıyla geliştirilmiş bir Süreç Analitiği ve İş Zekası çalışmasıdır.

---

## 📌 Proje Kapsamı ve İş Problemi

Order-to-Cash (O2C); müşterinin siparişi vermesinden başlayarak finans onayı, depo hazırlığı, lojistik sevkiyat, faturalama ve nihai nakit tahsilatına kadar uzanan tüm satış döngüsünü kapsar. 

Kurumsal operasyonlarda departmanlar arası bilgi kopukluğu ve manuel onay mekanizmaları şu kritik iş problemlerine yol açar:
* **Müşteri Memnuniyetsizliği:** Sipariş teslimat sürelerinin (Lead Time) kontrolsüz uzaması ve SLA ihlalleri.
* **Tutsak Sermaye (Working Capital Tıkanıklığı):** Geciken faturalar veya vadesi geçmiş tahsilatlar sebebiyle şirket nakit döngüsünün kilitlenmesi.

Bu çalışmada, ERP işlem kayıtları üzerinden her aşamanın döngü süresi (Cycle Time) analiz edilmiş, darboğaza neden olan departmanlar ayrıştırılmış ve kök neden analizine dayalı süreç iyileştirme önerileri geliştirilmiştir.

---

## 🎯 Operasyonel Aşamalar ve SLA Hedefleri

Süreç, 5 temel aşama ve her aşama için tanımlanan resmi hizmet seviyesi taahhütleri (SLA) üzerinden izlenmektedir:

| Süreç Aşaması | Sorumlu Birim | İzlenen Milat Taşı | Hedef SLA |
| :--- | :--- | :--- | :--- |
| **Kredi Onayı** | Finans | Sipariş Girişi $\rightarrow$ Kredi Onayı | $\le$ 24 Saat |
| **Depo Toplama** | Depo / WMS | Kredi Onayı $\rightarrow$ Toplama & Paketleme | $\le$ 48 Saat |
| **Sevkiyat** | Lojistik / 3PL | Paketleme $\rightarrow$ Taşıyıcı Teslimatı | $\le$ 72 Saat |
| **Faturalama** | Muhasebe | Teslimat $\rightarrow$ e-Fatura Kesimi | $\le$ 24 Saat |
| **Tahsilat** | Finans / Tahsilat | Fatura Tarihi $\rightarrow$ Banka Girişi | Sözleşme Vadesi (Net 15 - 60 Gün) |

---

## 🔍 Temel Bulgular ve Kök Neden Analizi (Root Cause Analysis)

İncelenen operasyonel veriler sonucunda sistemde tespit edilen kritik darboğazlar ve aksiyon planları:

1. **Finans Departmanı (Kredi Onay Kuyruğu):**
   * **Bulgu:** Onay süresi 100 saate kadar çıkarak 24 saatlik SLA hedefini 4 kat aşmıştır.
   * **Kök Neden:** Kredi limiti sınırındaki işlemlerin manuel komite onayı beklemesi.
   * **Öneri:** ERP üzerinde kural tabanlı otomatik onay (Auto-Credit Approval) mimarisi kurulmalı; risk skoru düşük cariler doğrudan depoya aktarılmalıdır.

2. **Depo Operasyonları (Toplama & Paketleme):**
   * **Bulgu:** Depo hazırlık süresi 148 saate ulaşarak en yüksek iç operasyonel gecikmeyi yaratmıştır.
   * **Kök Neden:** Fiziksel stok ile sistem stoğu arasındaki tutarsızlıklar ve rafta ürün arama süreleri.
   * **Öneri:** WMS tarafında RF el terminalleriyle dinamik toplama rotalama sistemine geçilmeli ve sipariş anında hard-allocation (kesin rezervasyon) zorunlu tutulmalıdır.

3. **Lojistik & Nakliye:**
   * **Bulgu:** Sevkiyat süresi 171 saate ulaşarak taahhüt edilen 72 saatlik eşiği aşmıştır.
   * **Kök Neden:** 3PL taşeron taşıyıcıların dönemsel kapasite ve transit süre taahhütlerini yerine getirememesi.
   * **Öneri:** Taşıyıcı sözleşmelerine SLA gecikme cezaları (Penalty Clause) eklenmeli ve dinamik taşıyıcı performans puanlama panosu işletilmelidir.

4. **Nakit Akışı ve Tahsilat Sapması:**
   * **Bulgu:** Sipariş 3.2 gün gibi hızlı bir sürede müşteriye teslim edilmiş olmasına karşın, 45 günlük vadeye rağmen ödeme 83 günde tahsil edilmiştir (+38 gün vade sapması).
   * **Finansal Etki:** 140.000 TL şirket işletme sermayesi müşteride rehin kalarak nakit akışını baskılamıştır.
   * **Öneri:** Fatura vadesi öncesinde otomatik hatırlatma (Dunning) süreçleri işletilmeli, vadesi geçen carilere ERP düzeyinde yeni sipariş blokajı uygulanmalıdır.

---

## 🛠️ Kullanılan Teknolojiler

* **Veritabanı & Analitik:** Microsoft SQL Server (T-SQL)
* **İş Zekası & Raporlama:** Microsoft Power BI (DAX Modellemesi)
* **Metodoloji:** Süreç Madenciliği (Process Mining), SLA Performans Yönetimi, Kök Neden Analizi

---

## 📂 Depo Dizin Yapısı

```text
erp-o2c-process-analytics/
├── docs/
│   └── dashboard_preview.png       # Rapor görsel arşivi
├── power_bi/
│   └── o2c_control_tower.pbix      # Power BI veri modeli ve interaktif pano
├── sql/
│   ├── sla_01.sql                  # Aşama döngü süreleri ve SLA ihlal sorgusu
│   └── sla_02.sql                  # Departman bazlı özet metrik sorgusu
└── README.md                       # Proje dokümantasyonu