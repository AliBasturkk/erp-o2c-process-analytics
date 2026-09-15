WITH SurecAnaliz AS (
    SELECT
        DATEDIFF(hour, order_date, credit_approved_date) AS onay_saat,
        DATEDIFF(hour, credit_approved_date, warehouse_picked_date) AS depo_saat,
        DATEDIFF(hour, warehouse_picked_date, shipped_date) AS lojistik_saat,
        DATEDIFF(hour, shipped_date, invoiced_date) AS fatura_saat
    FROM fact_order_processing
    WHERE cancellation_status = 'Completed'
)
SELECT
    COUNT(*) AS toplam_tamamlanan_siparis,
    
    -- Finans Onay Metrikleri
    AVG(onay_saat) AS ort_finans_onay_saat,
    SUM(CASE WHEN onay_saat > 24 THEN 1 ELSE 0 END) AS finans_gecikme_sayisi,
    CAST(SUM(CASE WHEN onay_saat > 24 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS finans_ihlal_orani_yuzde,

    -- Depo Metrikleri
    AVG(depo_saat) AS ort_depo_saat,
    SUM(CASE WHEN depo_saat > 48 THEN 1 ELSE 0 END) AS depo_gecikme_sayisi,
    CAST(SUM(CASE WHEN depo_saat > 48 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS depo_ihlal_orani_yuzde,

    -- Lojistik Metrikleri
    AVG(lojistik_saat) AS ort_lojistik_saat,
    SUM(CASE WHEN lojistik_saat > 72 THEN 1 ELSE 0 END) AS lojistik_gecikme_sayisi,
    CAST(SUM(CASE WHEN lojistik_saat > 72 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS lojistik_ihlal_orani_yuzde,

    -- Muhasebe Metrikleri
    AVG(fatura_saat) AS ort_muhasebe_saat,
    SUM(CASE WHEN fatura_saat > 24 THEN 1 ELSE 0 END) AS muhasebe_gecikme_sayisi,
    CAST(SUM(CASE WHEN fatura_saat > 24 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS muhasebe_ihlal_orani_yuzde
FROM SurecAnaliz