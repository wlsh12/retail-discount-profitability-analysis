SELECT COUNT(*) AS total_rows
FROM public.samplesuperstore;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'samplesuperstore'
ORDER BY ordinal_position;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'samplesuperstore'
  AND column_name IN ('Order Date', 'Ship Date', 'Sales', 'Quantity', 'Discount', 'Profit')
ORDER BY ordinal_position;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT "Row ID") AS duplicate_row_ids,
    COUNT(*) FILTER (
        WHERE "Order Date" IS NULL OR TRIM("Order Date") = ''
    ) AS missing_order_dates,
    COUNT(*) FILTER (WHERE "Sales" IS NULL) AS missing_sales,
    COUNT(*) FILTER (WHERE "Profit" IS NULL) AS missing_profit,
    COUNT(*) FILTER (WHERE "Discount" IS NULL) AS missing_discount
FROM public.samplesuperstore;

CREATE OR REPLACE VIEW public.superstore_clean AS
SELECT
    "Row ID" AS row_id,
    "Order ID" AS order_id,
    TO_DATE("Order Date", 'MM/DD/YYYY') AS order_date,
    TO_DATE("Ship Date", 'MM/DD/YYYY') AS ship_date,
    "Customer ID" AS customer_id,
    "Region" AS region,
    "Category" AS category,
    "Sub-Category" AS sub_category,
    "Product ID" AS product_id,
    "Product Name" AS product_name,
    "Sales"::numeric AS sales,
    "Quantity" AS quantity,
    "Discount"::numeric AS discount_rate,
    "Profit"::numeric AS profit
    FROM public.samplesuperstore;
    
SELECT
    COUNT(*) AS total_rows,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(*) FILTER (
        WHERE order_date IS NULL OR ship_date IS NULL
    ) AS missing_dates
FROM public.superstore_clean;

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100 * SUM(profit) / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
GROUP BY category
ORDER BY total_sales DESC;

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100 * SUM(profit) / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
WHERE category = 'Furniture'
GROUP BY sub_category
ORDER BY total_profit ASC;

SELECT
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate <= 0.20 THEN '>0–20%'
        WHEN discount_rate <= 0.40 THEN '>20–40%'
        ELSE '>40%'
    END AS discount_group,
    COUNT(*) AS transaction_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM public.superstore_clean
WHERE category = 'Furniture'
GROUP BY 1
ORDER BY MIN(discount_rate);

SELECT
    sub_category,
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate <= 0.20 THEN '>0–20%'
        WHEN discount_rate <= 0.40 THEN '>20–40%'
        ELSE '>40%'
    END AS discount_group,
    COUNT(*) AS sales_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM public.superstore_clean
WHERE sub_category IN ('Tables', 'Bookcases')
GROUP BY sub_category, discount_group
ORDER BY sub_category, MIN(discount_rate);

SELECT
    sub_category,
    region,
    COUNT(*) AS sales_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100 * SUM(profit) / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
WHERE sub_category IN ('Tables', 'Bookcases')
GROUP BY sub_category, region
ORDER BY total_profit ASC;

SELECT
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate <= 0.20 THEN '>0–20%'
        WHEN discount_rate <= 0.40 THEN '>20–40%'
        ELSE '>40%'
    END AS discount_group,
    COUNT(*) AS sales_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM public.superstore_clean
WHERE sub_category = 'Tables'
  AND region = 'East'
GROUP BY discount_group
ORDER BY MIN(discount_rate);