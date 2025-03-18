CREATE TABLE kimia_farma.kf_tabel_analisa_transaksi AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  k.branch_name,
  k.kota,
  k.provinsi, 
  k.rating AS rating_cabang, 
  t.customer_name, 
  t.product_id, 
  p.product_name, 
  p.price AS actual_price, 
  t.discount_percentage, 
  CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 and p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 and p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 and p.price <= 500000 THEN 0.25
    ELSE 0.3
  END AS persentase_gross_laba,
  (p.price - (p.price * t.discount_percentage)) AS nett_sales,
  (p.price * (1 - t.discount_percentage) * CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 and p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 and p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 and p.price <= 500000 THEN 0.25
    ELSE 0.3
  END) AS nett_profit,
  t.rating as rating_transaksi,
FROM `rakamin-kf-analytics-451907.kimia_farma.kf_final_transaction` as t
LEFT JOIN `rakamin-kf-analytics-451907.kimia_farma.kf_kantor_cabang` as k
  ON t.branch_id = k.branch_id
LEFT JOIN `rakamin-kf-analytics-451907.kimia_farma.kf_product` as p
  ON t.product_id = p.product_id
ORDER BY
  date DESC
