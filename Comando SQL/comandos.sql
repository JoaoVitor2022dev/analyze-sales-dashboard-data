--1 - Receita, leads, conversão e ticket médio mês a mês						
-- mês	leads (#)	vendas (#)		conversão (%)	ticket médio (k, R$)	

                              -- 1 mês leads (#)
							  
SELECT * FROM sales.funnel;
SELECT * FROM sales.products; 

WITH
   leads AS ( 
SELECT 
     date_trunc('month', visit_page_date)::date AS visit_page_month,
	 
	COUNT(*) AS visit_page_count
	
FROM sales.funnel
GROUP BY visit_page_month
ORDER BY visit_page_month), 

                              -- 2 vendas (#) receita (k, R$)

payments AS (SELECT 
     date_trunc('month', fun.paid_date)::date AS paid_month,
	 COUNT(fun.paid_date) AS paid_count, 
	 SUM(pro.price * (1 + fun.discount)) AS receita
FROM sales.funnel AS fun
LEFT JOIN sales.products AS pro
     ON fun.product_id = pro.product_id
	 WHERE fun.paid_date IS NOT NULL 
	 GROUP BY paid_month
	 ORDER BY paid_month DESC) 

--                                     conversão (%) ticket médio (k, R$)	

SELECT 
    leads.visit_page_month AS "mês", 
	leads.visit_page_count AS "leads (#)", 
	payments.paid_count AS "Vendas (#)", 
	(payments.receita/1000) AS "receita (k, R$)",
	(payments.paid_count::float/leads.visit_page_count::float) AS "Conversão (%)", 
	(payments.receita/payments.paid_count/1000) AS "ticket médio (k, R$)"
FROM leads 
LEFT JOIN payments 
    ON  leads.visit_page_month = paid_month; 


-- ( Query ) ESTADOS QUE MAIS VENDERAM 
-- COLUNAS: PAIS, ESTADO, VENDAS (#)


SELECT * FROM sales.funnel; 

SELECT * FROM sales.customers; 


SELECT
    'BrazIL' AS pais,
    state AS estado, 
	COUNT(paid_date) AS Numero_Vendas
	
FROM sales.funnel AS fun 
LEFT JOIN sales.customers AS cus
     ON fun.customer_id = cus.customer_id
GROUP BY state
ORDER BY Numero_Vendas DESC; 




-- (QUERY 3) MARCAS que mais venderam no mês  
-- Coluna: marca, vendas (#)

SELECT 
    pro.brand AS marca, 
	COUNT(fun.paid_date) AS "Vendas (#)"
FROM sales.funnel AS fun 
LEFT JOIN sales.products AS pro 
     ON fun.product_id = pro.product_id
WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'	 
GROUP BY marca
ORDER BY "Vendas (#)" DESC
LIMIT 5;  




-- (QUERY 3) Loja que mais venderam no mês  
-- Coluna: marca, vendas (#)

SELECT 
    sto.store_name AS loja, 
	COUNT(fun.paid_date) AS "Vendas (#)"
FROM sales.funnel AS fun 
LEFT JOIN sales.stores AS sto 
     ON fun.store_id = sto.store_id
WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'	 
GROUP BY loja
ORDER BY "Vendas (#)" DESC
LIMIT 5;  


-- Dia da semana com o maior numero de visitas ao site 
-- colunas dia_semana, dia_da_semana, visitas (#)


select 
    EXTRACT('dow', FROM visit_page_date) AS dia_semana,
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 0 THEN 'domingo'   
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 1 THEN 'segunda' 
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 2 THEN 'terça' 
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 3 THEN 'quarta' 
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 4 THEN 'quinta' 
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 5 THEN 'sexta' 
	CASE WHEN EXTRACT('dow' FROM visit_page_date) = 6 THEN 'sábado' 		
	"dia da semana ",
	 "visitas (#)"

FROM sales.funnel 
WHERE visit_page_date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY dia_semana 
ORDER BY dia_semana