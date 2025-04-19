--1 - Receita, leads, conversão e ticket médio mês a mês						
-- mês	leads (#)	vendas (#)	receita (k, R$)	conversão (%)	ticket médio (k, R$)	


                              -- 1 mês leads (#)

SELECT * FROM sales.funnel;

SELECT * FROM sales.products; 

SELECT 
     date_trunc('month', visit_page_date)::date AS visit_page_month,
	 
	COUNT(*) AS visit_page_count
	
FROM sales.funnel
GROUP BY visit_page_month
ORDER BY visit_page_month; 

                              -- 2 vendas (#)

SELECT 
     date_trunc('month', fun.paid_date)::date AS paid_month,
	 COUNT(fun.paid_date) AS paid_count, 
	 SUM(pro.price * (1 + fun.discount)) AS receita
FROM sales.funnel AS fun
LEFT JOIN sales.products AS pro
     ON fun.product_id = pro.product_id
	 WHERE fun.paid_date IS NOT NULL 
	 GROUP BY paid_month
	 ORDER BY paid_month DESC;

-- PRICE = 51000 x ( 1 + 0.34 ) = TOTAL DA VENDA = 
SUM(pro.price * (1 + fun.discount)) AS receita





