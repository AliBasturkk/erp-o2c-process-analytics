WITH SurecSureleri AS (
SELECT
	f.order_id,
	c.customer_name,
	c.customer_segment,
	c.payment_terms_days,
	f.order_amount,
	f.cancellation_status,
	-- Süreç Aþamalarý (Saat Cinsinden Bekleme Süreleri)
        DATEDIFF(hour, f.order_date, f.credit_approved_date) AS onay_suresi_saat,
        DATEDIFF(hour, f.credit_approved_date, f.warehouse_picked_date) AS depo_hazirlik_saat,
        DATEDIFF(hour, f.warehouse_picked_date, f.shipped_date) AS lojistik_sevk_saat,
        DATEDIFF(hour, f.shipped_date, f.invoiced_date) AS faturalama_saat,
        -- Uçtan Uca Teslimat Süresi (Sipariþten Müþteriye Sevk Edilene Kadar - Gün)
        CAST(DATEDIFF(hour, f.order_date, f.shipped_date) / 24.0 AS DECIMAL(10,1)) AS teslimat_lead_time_gun,
        -- Tahsilat Performansý (Vade Aþýmý - Gün)
        DATEDIFF(day, f.invoiced_date, f.payment_received_date) AS gerceklesen_vade_gun
FROM fact_order_processing f
INNER JOIN dim_customers c ON f.customer_id = c.customer_id
WHERE f.cancellation_status = 'Completed'
)
SELECT 
	order_id,
	customer_name,
	order_amount,
	teslimat_lead_time_gun,
	-- Bekleme Süreleri (Saat)
    onay_suresi_saat,
    depo_hazirlik_saat,
    lojistik_sevk_saat,
    faturalama_saat,
	-- SLA Ýhlal Bayraklarý (Breach Flags: 1 = Gecikme Var, 0 = Zamanýnda)
    CASE WHEN onay_suresi_saat > 24 THEN 1 ELSE 0 END AS finans_sla_asimi,
    CASE WHEN depo_hazirlik_saat > 48 THEN 1 ELSE 0 END AS depo_sla_asimi,
    CASE WHEN lojistik_sevk_saat > 72 THEN 1 ELSE 0 END AS lojistik_sla_asimi,
    CASE WHEN faturalama_saat > 24 THEN 1 ELSE 0 END AS muhasebe_sla_asimi,
    -- Nakit Akýþý / Tahsilat Analizi
    payment_terms_days AS sozlesme_vadesi,
    gerceklesen_vade_gun,
    (gerceklesen_vade_gun - payment_terms_days) AS vade_gecikme_gun,
    CASE WHEN gerceklesen_vade_gun > payment_terms_days THEN 1 ELSE 0 END AS tahsilat_gecikti_flag
FROM SurecSureleri