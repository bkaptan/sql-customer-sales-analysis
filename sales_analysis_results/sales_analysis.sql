USE [avansas-sales]
GO

select * from dbo.Customers
select * from dbo.Products
select top 10 * from dbo.Sales

---------------------------------------------------------------------------------------

-- Toplam harcaması, tüm müşterilerin ortalamasının üzerinde olan müşterileri bul


-- Önce müşteri bazı toplam harcamaları bulurum, sonrasında da tüm müşterilerin ortalaması ile bunları karşılaştırırım:

-- SUBQUERY İLE: 
select 
	c.CustomerID,
	c.CustomerName,
	sum(s.NetSales) as CustomersTotalSpending
from dbo.Customers c
inner join dbo.Sales s
on s.CustomerID = c.CustomerID
group by c.CustomerID, c.CustomerName
having sum(s.NetSales) > -- CustomerTotalSpending'i tüm müşterilerin ortalamasından büyük karşılaştırması yapılır
(
	select avg(CustomerToTal) as CustomersAvgSpending -- tüm müşterilerin toplam harcama ortalaması:
	from 
	(
		select 
			sum(NetSales) as CustomerToTal
		from dbo.Sales
		group by CustomerID
	) t
);



-- CTE İLE:
with CustomerSpents as ( -- müşteri bazlı toplam harcamalar
	select 
		CustomerID,
		sum(NetSales) as CustomersTotalSpending
	from dbo.Sales
	group by CustomerID
),

CustomersAvgSpent as (	-- tüm müşterilerin ortalama harcaması
	select
		avg(CustomersTotalSpending) as AVGCustomerSpent
	from CustomerSpents
)

select
	c.CustomerID,
	c.CustomerName,
	cs1.CustomersTotalSpending,
	cs2.AVGCustomerSpent
from CustomerSpents cs1
inner join dbo.Customers c on c.CustomerID = cs1.CustomerID
cross join CustomersAvgSpent cs2
where cs1.CustomersTotalSpending > cs2.AVGCustomerSpent

---------------------------------------------------------------------------------------


-- En pahalı ürünün satıldığı satışları listele

-- önce en pahalı ürünü bulurum sonra içinde bu ürün olan siparişlere bakarım

-- SUBQUERY İLE:
select
	s.ProductID,
	p.ProductName,
	p.UnitPrice,
	s.NetSales,
	s.OrderDate
from dbo.Sales s
inner join dbo.Products p
on p.ProductID = s.SalesID
where p.UnitPrice = 
	(
		select max(UnitPrice) as MostExpensiveProduct
		from dbo.Products
	)


-- CTE İLE:
with MaxPrice as (
	select
		max(UnitPrice) as MostExpensiveProductPrice
	from dbo.Products
)

select
	s.ProductID,
	p.ProductName,
	p.UnitPrice,
	s.NetSales,
	s.OrderDate
from dbo.Sales s
inner join dbo.Products p
on p.ProductID = s.ProductID
cross join MaxPrice m
where p.UnitPrice = m.MostExpensiveProductPrice


---------------------------------------------------------------------------------------

select * from dbo.Customers
select * from dbo.Products
select top 10 * from dbo.Sales

-- Hiç satış yapmamış ürünleri bul

-- SUBQUERY İLE:
select
	ProductID,
	ProductName
from dbo.Products
where ProductID NOT IN ( -- dbo.Sales tablosunda hiç olmayan ProductID, satışı olmayan ürün demektir
	select distinct ProductID
	from dbo.Sales
)


---------------------------------------------------------------------------------------

-- CTE İLE ÖRNEK SENARYOLAR:

-- Müşteri bazlı toplam satış, toplam adet ve ortalama sepet tutarı

-- önce her müşterinin toplam sipariş sayısını, toplam satışını, toplam adetini bulalım:
with CustomerSales as (
	select
		CustomerID,
		count(distinct SalesID) as OrderCount,
		sum(NetSales) as TotalNetSales,
		sum(Quantity) as TotalQuantity
	from dbo.Sales
	group by CustomerID
)
-- ve buraya bir de her müşterinin ortalama sepet tutarını hesaplayalım:
select
	c.CustomerID, 
	cs.OrderCount, 
	cs.TotalNetSales,
	cs.TotalQuantity,
	(cs.TotalNetSales * 1.0 / cs.TotalQuantity)  as CustomerAvgOrderValue
from CustomerSales cs
inner join dbo.Customers c
on c.CustomerID = cs.CustomerID

---------------------------------------------------------------------------------------

-- Kategori bazında toplam satış ve kategorinin genel satış içindeki payı (%)


-- önce her kategorideki toplam satışı bulalım:
with CategorySales as (
	select
		p.Category,
		sum(s.NetSales) as TotalCategorySale
	from dbo.Sales s
	inner join dbo.Products p
	on p.ProductID = s.ProductID
	group by p.Category
),
-- sonra genel total satışı bulup, 
TotalSale as (
	select sum(TotalCategorySale) as AllTotalSale
	from CategorySales 
)
-- bu kategorinin buna oranını hesaplayalım:
select
	Category,
	TotalCategorySale, 
	AllTotalSale, 
	(TotalCategorySale * 100.0 / AllTotalSale) as RatePercentage
from CategorySales ct
cross join TotalSale ts

---------------------------------------------------------------------------------------


-- Her müşteri için en çok harcama yaptığı ürünü bul.

-- önce müşterilerin ürün bazında yaptığı harcamaları bulalım:
with CustomerProductSales as (
	select
		CustomerID,
		ProductID,
		sum(NetSales) as TotalSpent
	from dbo.Sales s
	group by CustomerID, ProductID
),

-- sonra bir sıralama ölçüsü belirleyip en çok harcama için:
RankedProducts as (
	select
		*,
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY TotalSpent DESC) as row_num
	from CustomerProductSales
)
select
	c.CustomerName,
	p.ProductName,
	rp.TotalSpent
from RankedProducts rp
inner join dbo.Customers c
on c.CustomerID = rp.CustomerID
inner join dbo.Products p
on p.ProductID = rp.ProductID
where row_num = 1
order by c.CustomerName
---------------------------------------------------------------------------------------


-- !! Şimdi gerçekten şirkette çalışıyormuşsun gibi SQL alıştırmaları hazırlıyorum.
-- !! Bunlar ad-hoc, gerçekçi, ekiplerden birebir gelebilecek sorular olacak.

-- SATIŞ EKİBİ (Sales Team)
-- KOLAY SEVİYE

-- Bugüne kadar toplam ciro ne kadar?
select sum(NetSales) as TotalRevenue
from dbo.Sales


-- Toplam sipariş sayısı kaç?
select distinct count(SalesID)
from dbo.Sales


-- En çok satış yapan ilk 10 ürün hangileri?
with top_10_product as ( -- önce her ürünün toplam satış sayısını bulurum:
	select top 10
		ProductID,
		sum(NetSales) as TotalSales
	from dbo.Sales
	group by ProductID
	order by sum(NetSales) desc
)
select -- sonra buradan da "ProductName" e gitmek için join yaparım:
	p.ProductID,
	p.ProductName,
	t.TotalSales
from dbo.Products p
inner join top_10_product t
on t.ProductID = p.ProductID



-- Dün yapılan satışların toplam tutarı nedir? (Veri setindeki son tarih 2025-12-31 olduğu için "dünü": 2025-12-30 olarak aldım)
select round(sum(NetSales), 2) as Yesterday_Sales_Amount
from dbo.Sales
where OrderDate = '2025-12-30'


-- Son 30 günde hiç satış yapmayan ürünler var mı? 
select
	p.ProductID,
	p.ProductName
from dbo.Products p
left join dbo.Sales s
	on s.ProductID = p.ProductID 
	and s.OrderDate between '2025-12-01' and '2025-12-31'
where s.ProductID is null -- (Yokmuş, son 30 günde her ürün en az 1 kere satılmış)



-- ORTA SEVİYE

-- Aylık bazda toplam satış trendini getir.
select
	YEAR(OrderDate) as Year,
	MONTH(OrderDate) as Month,
	sum(NetSales) as TotalSales
from dbo.Sales
group by YEAR(OrderDate), MONTH(OrderDate)
order by Year, Month


-- Her müşteri için toplam harcama tutarını hesapla.
select 
	CustomerID,
	sum(NetSales) as TotalSpending
from dbo.Sales
group by CustomerID
order by TotalSpending desc


-- Son 3 ayda satışları düşen ürünleri listele.
with ProductMonthlySales as ( -- önce her ürünün her aydaki toplam satışını hesaplarım:
	select
		ProductID,
		YEAR(OrderDate) as Year,
		MONTH(OrderDate) as Month,
		sum(NetSales) as SalesAmount
	from dbo.Sales
	group by ProductID, YEAR(OrderDate), MONTH(OrderDate)
),
Lagged as ( -- sonra bu bilgileir kullanarak LAG() fonksiyonu ile bir önceki ayların karşılaştırmasını yaparım:
	select	*,
			LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY Year, Month) as PrevMonthSales
	from ProductMonthlySales
)
select 
	distinct ProductID
from Lagged
where SalesAmount < PrevMonthSales -- o ayki satışı önceki aydan düşük olan ürünler


-- Şehir bazında toplam satış tutarlarını getir.
select
	c.City,
	sum(s.NetSales) as TotalSales
from dbo.Sales s
inner join dbo.Customers c
	on c.CustomerID = s.CustomerID
group by c.City
order by TotalSales desc


-- Ortalama sipariş tutarı (AOV) zaman içinde nasıl değişmiş?
select
	YEAR(OrderDate) as Year,
	MONTH(OrderDate) as Month,
	avg(NetSales) as AvgSalesAmount
from dbo.Sales
group by YEAR(OrderDate), MONTH(OrderDate)
order by YEAR(OrderDate), MONTH(OrderDate)

---------------------------------------------------------------------------------------


-- İLERİ SEVİYE

-- !! Her ay için en çok satan ürün hangisi?
with MonthlyProductSales as ( -- önce her ürünün her ayki satışını bulurum:
	select
		ProductID,
		YEAR(OrderDate) as Year,
		MONTH(OrderDate) as Month,
		sum(NetSales) as TotalSales
	from dbo.Sales
	group by ProductID, YEAR(OrderDate), MONTH(OrderDate)
),
Ranked as ( -- sonra bu satışları ay bazında satış sırasına koyarım:
	select	 *,
			RANK() OVER(PARTITION BY Year, Month ORDER BY TotalSales DESC) AS rnk
	from MonthlyProductSales
)
select * from Ranked
where rnk = 1


-- !! Son 7 günün ortalamasına göre bugünkü satışlar anormal mi? (Bugünki satış olarak veri setindeki son günü baz aldım)
with DailySales as ( -- önce günlük satışları bulurum:
	select
		CAST(OrderDate as DATE) as SalesDate,
		sum(NetSales) as DailyTotal
	from dbo.Sales
	group by CAST(OrderDate as DATE)
)
select -- sonra bu günlük satışları kullanarak son 7 gün satış ortalaması ile, bugünün satışlarını karşılaştırırım:
	SalesDate,
	DailyTotal,
	AVG(DailyTotal) OVER(ORDER BY SalesDate ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as Last7daysAvg
from DailySales



-- Her müşteri için ilk satın alma tarihi ve son satın alma tarihi.
select
	CustomerID,
	min(cast(OrderDate as DATE)) as FirstOrderDate,
	max(cast(OrderDate as DATE)) as LastOrderDate
from dbo.Sales
group by CustomerID
order by CustomerID



-- Satışların %80’ini oluşturan ürünleri (Pareto) bul.
with ProductSales as ( -- önce her ürünün satışlarını bulurum:
	select
		ProductID,
		sum(NetSales) as TotalSales
	from dbo.Sales
	group by ProductID
),
Cumulative as ( -- sonra running total ve grand total'ı bulurum ki ana sorgumda bunları %80 olarak karşılaştırabileyim:
	select	*,
			sum(TotalSales) over(order by TotalSales desc) as RunningTotal,
			sum(TotalSales) over() as GrandTotal
	from ProductSales
)
select * -- ana sorgumda da bunları karşılaştırırım:
from Cumulative
where RunningTotal <= GrandTotal * 0.8



-- Günlük satışlara göre hareketli ortalama (moving average) hesapla.
with DailySales as ( -- önce her günün satışlarını bulurum
	select
		CAST(OrderDate as DATE) as SalesDate,
		sum(NetSales) as DailyTotal
	from dbo.Sales
	group by CAST(OrderDate as DATE)
)
select -- sonra da mevcut satır ve önceki 6 satır verileri ile AVG(DailyTotal) hesaplarım
	SalesDate,
	DailyTotal,
	AVG(DailyTotal) OVER(ORDER BY SalesDate  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as MovingAvg
from DailySales



---------------------------------------------------------------------------------------



-- Finans Ekibi
-- KOLAY SEVİYE


-- Toplam net satış tutarı nedir?
select	sum(NetSales) from dbo.Sales

-- Ürün kategorisi bazında toplam ciro.
select
	p.Category,
	sum(s.NetSales) as TotalRevenue
from dbo.Sales s
inner join dbo.Products p
	on p.ProductID = s.ProductID
group by p.Category
order by TotalRevenue desc


-- En pahalı ürün hangisi?
select top 1
	ProductID,
	UnitPrice
from dbo.Sales
group by ProductID, UnitPrice
order by UnitPrice desc


-- Hiç satılmamış ürünler var mı?
select
	p.ProductID,
	p.ProductName
from dbo.Products p
left join dbo.Sales s
	on s.ProductID = p.ProductID 
where s.ProductID IS NULL -- yokmuş, her ürün en az 1 kere satılmış yani


-- En çok gelir getiren müşteri kim?

select top 1  -- her müşterinin "toplam" NetSales'ını bulurum:
	CustomerID,
	sum(NetSales) as TotalSpending
from dbo.Sales
group by CustomerID
order by TotalSpending desc


---------------------------------------------------------------------------------------

-- !! ORTA SEVİYE

-- Aylık gelir raporu oluştur.
select
	YEAR(CAST(OrderDate AS DATE)) as Year,
	MONTH(CAST(OrderDate AS DATE)) as Month,
	SUM(NetSales) as TotalRevenue
from dbo.Sales
group by YEAR(CAST(OrderDate AS DATE)), MONTH(CAST(OrderDate AS DATE))
order by Year, Month


-- Kategori bazında ortalama ürün fiyatı.
select
	Category,
	AVG(UnitPrice) as AvgProductPrice
from dbo.Products
group by Category
order by AvgProductPrice desc


-- Her müşteri için ortalama sipariş tutarı.
select
	CustomerID,
	AVG(NetSales) as AvgOrderValue
from dbo.Sales
group by CustomerID
order by AvgOrderValue desc


-- Son 1 yıldaki en yüksek gelirli ay hangisi?
select top 1
	YEAR(CAST(OrderDate AS DATE)) as Year,
	MONTH(CAST(OrderDate AS DATE)) as Month,
	SUM(NetSales) as TotalRevenue
from dbo.Sales
where OrderDate between '2025-01-01' and '2025-12-31'
group by YEAR(CAST(OrderDate AS DATE)), MONTH(CAST(OrderDate AS DATE))
order by TotalRevenue desc



-- Şehir bazında müşteri başına düşen ortalama gelir.
with CityRevenue as ( -- önce her şehirdeki toplam NetSales'i bulurum:
	select
		c.City,
		SUM(s.NetSales) as TotalRevenue
	from dbo.Sales s
	inner join dbo.Customers c
		on c.CustomerID = s.CustomerID
	group by c.City
),
CityCustomerCount as ( -- sonra her şehirdeki toplam müşteri sayısını bulurum:
	select 
		City,
		COUNT(DISTINCT CustomerID) as CustomerCount
	from dbo.Customers
	group by City
)
-- sonra da bu CTE'leri oranlarım:
select
	c1.City,
	c2.CustomerCount,
	c1.TotalRevenue,
	(c1.TotalRevenue * 1.0 / c2.CustomerCount)  as RevenuePerCustomer
from CityRevenue c1
inner join CityCustomerCount c2
	on c1.City = c2.City
	

---------------------------------------------------------------------------------------

-- !! İLERİ SEVİYE

-- Her kategori için en pahalı ürün.
with RankedProducts as ( -- önce kategorideki her ürünün fiyatını ranke koyarım:
	select
		Category,
		ProductID,
		ProductName,
		UnitPrice,
		RANK() OVER(PARTITION BY Category ORDER BY UnitPrice DESC) as rnk
	from dbo.Products
)
select	* -- sonra burada rank'i 1 olan en pahalıdır diyip onu getiririm:
from RankedProducts
where rnk = 1


-- Toplam satışın %50’sini oluşturan müşteri grubunu bul.
with CustomerRevenue as (  -- önce her müşterinin toplam satışını bulurum:
	select
		CustomerID,
		sum(NetSales) as TotalRevenue
	from dbo.Sales
	group by CustomerID
),
Cumulative as ( -- sonra Running Total ve Grand Total Sales'i bulurum:
	select
		*,
		sum(TotalRevenue) over(order by TotalRevenue desc) as RunningTotal,
		sum(TotalRevenue) over() as GrandTotal
	from CustomerRevenue
)
select * -- sonra da oranı kurgularım:
from Cumulative
where RunningTotal <= GrandTotal * 0.5



-- !!! Aylık gelirde ay-ay büyüme oranı hesapla.
with MonthlyRevenue as ( -- önce her ayın toplam NetSales'ini bulurum:
	select
		YEAR(CAST(OrderDate AS DATE)) as Year,
		MONTH(CAST(OrderDate AS DATE)) as Month,
		SUM(NetSales) as Revenue
	from dbo.Sales
	group by YEAR(CAST(OrderDate AS DATE)), MONTH(CAST(OrderDate AS DATE))
),
Growth as ( -- sonra bir önceki satırdaki veri ile LAG() kullanarak "PrevMonthRevenue" bulurum:
	select 
		*,
		LAG(Revenue) OVER (ORDER BY Year, Month) as PrevMonthRevenue
	from MonthlyRevenue
)
select -- sonra da o ay ile Prev Monht arasındaki Revenue farkının oranını bulurum:
	*,
	ROUND((Revenue - PrevMonthRevenue) * 100.0 / PrevMonthRevenue, 2)  as GrowthPercentage
from Growth



-- Tek seferlik alışveriş yapan müşterileri tespit et.
select CustomerID  -- her müşterinin yaptığı alışverişi sayısını sayarım, 1'e eşit olanları getiririm:
from dbo.Sales
group by CustomerID
having (count(SalesID) = 1)



-- !! Geliri sürekli düşen kategorileri zaman bazında analiz et.
with CategoryRevenue as ( -- önce her kategorinin her aydaki toplam NetSales'ini bulurum:
	select
		p.Category,
		YEAR(CAST(s.OrderDate AS DATE)) as Year,
		MONTH(CAST(s.OrderDate AS DATE)) as Month,
		SUM(s.NetSales) as Revenue
	from dbo.Sales s
	inner join dbo.Products p
		on p.ProductID = s.ProductID
	group by p.Category, YEAR(CAST(s.OrderDate AS DATE)), MONTH(CAST(s.OrderDate AS DATE))
),
PrevMonthCategoryRevenue as (  -- sonra bir önceki aydaki gelirlerine bakarım bu Category'lerin:
	select
		*,
		LAG(Revenue) OVER(PARTITION BY Category ORDER BY Year, Month) as PrevRevenue
	from CategoryRevenue
)
select *  -- sonra da Revenue değeri PrevRevenue'den küçük olan var mı getiririm:
from PrevMonthCategoryRevenue
where Revenue < PrevRevenue


---------------------------------------------------------------------------------------

-- Reklam / Pazarlama Ekibi
-- KOLAY SEVİYE

-- Toplam müşteri sayısı kaç?
select count(distinct CustomerID)
from dbo.Customers


-- En çok müşterisi olan şehir hangisi?
select
	City,
	count(distinct CustomerID) as CustomerCount
from dbo.Customers
group by City
order by CustomerCount desc


-- En çok satılan (adet olarak) ürün kategorisi nedir?
select
	p.Category,
	count(s.SalesID) as OrderCount
from dbo.Sales s
inner join dbo.Products p
	on p.ProductID = s.ProductID
group by p.Category
order by OrderCount desc


-- Son 1 ayda kazanılan yeni müşteri sayısı. (bunu veri setindeki son ayın bir önceki ile farkı olarak düşün)
with MonthlyCustomerCount as (  -- önce her aydaki toplam eşsiz müşteri sayısını bulalım: 
	select
		YEAR(CAST(OrderDate AS DATE)) AS Year,
		MONTH(CAST(OrderDate AS DATE)) AS Month,
		COUNT(DISTINCT CustomerID)  AS CustomerCount
	from dbo.Sales
	group by YEAR(CAST(OrderDate AS DATE)), MONTH(CAST(OrderDate AS DATE))
),
-- sonra bir önceki ay ile verilerini getirelim:
Prev as (
	select
		*,
		LAG(CustomerCount) OVER(ORDER BY Year, Month) as PrevMonthCustomerCount
	from MonthlyCustomerCount
)
select -- bu durumda veri setimizdeki son ay olan 2025-12 ayında bir önceki aya göre +2 yeni müşterimiz olmuş
	*,
	(CustomerCount - PrevMonthCustomerCount)  as CustomerDifference
from Prev



-- En az satış yapan ürünler hangileri?
select top 10
	p.ProductID,
	p.ProductName,
	sum(s.NetSales) as TotalSales
from dbo.Sales s
inner join dbo.Products p
	on p.ProductID = s.ProductID
group by p.ProductID, p.ProductName
order by TotalSales


---------------------------------------------------------------------------------------

-- ORTA SEVİYE

-- Ay bazında yeni müşteri kazanımı.MoM müşteri artışı ne kadar?
WITH MonthlyNewCustomers AS (  -- önce her ay kaç yeni müşteri "signup" olmuş onu bulurum:
    SELECT
        YEAR(SignupDate) AS Year,
        MONTH(SignupDate) AS Month,
        COUNT(*) AS NewCustomerCount
    FROM dbo.Customers
    GROUP BY YEAR(SignupDate), MONTH(SignupDate)
)
SELECT -- sonra bir önceki ay ile bunları karşılaştırırım:
    Year,
    Month,
    NewCustomerCount,
    LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS PrevMonthCount,
    NewCustomerCount - LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS MoM_Difference
FROM MonthlyNewCustomers
ORDER BY Year, Month;



-- İlk alışverişte en çok tercih edilen ürünler.
with FirstOrders as (  -- önce her müşterinin ilk alışveriş tarihini bulurum:
	select 
		CustomerID,
		MIN(CAST(OrderDate AS DATE)) AS FirstOrderDate
	from dbo.Sales
	group by CustomerID
)
-- sonra buradaki ürünleri çeşitliliğine bakarım:(top 3 ürün uygun bence)
select top 3
	p.ProductName,
	COUNT(*) as FirstPurchaseCount
from dbo.Sales s
inner join FirstOrders fo
	on s.CustomerID = fo.CustomerID
	and s.OrderDate = fo.FirstOrderDate -- FirstOrderDate, Sales table'daki OrderDate ile eşleşmeli!
inner join dbo.Products p
	on p.ProductID = s.ProductID
group by p.ProductID, p.ProductName
order by FirstPurchaseCount desc



-- Müşterilerin tekrar satın alma oranı.
with CustomerOrderCount as ( -- önce her müşterinin kaç adet farklı satın alması var onu bulurum:
	select
		CustomerID,
		COUNT(*) AS OrderCount
	from dbo.Sales
	group by CustomerID
)
select -- sonra da bunu toplam order'a oranlarım
	SUM(CASE WHEN OrderCount > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
from CustomerOrderCount



-- Son 6 ayda müşteri sayısı artan şehirler.
with MonthlyCustomerCount as ( -- önce her şehrin her aydaki (son 6 ay) toplam müşteri sayısını bulalım:
	select
		City,
		MONTH(CAST(SignupDate AS DATE)) AS Month,
		COUNT(CustomerID) AS CustomerCount
	from dbo.Customers
	where SignupDate >= DATEADD(MONTH, -6, '2024-04-15') -- veri setindeki son tarihten 6 ay öncesine kadar
	group by City, MONTH(CAST(SignupDate AS DATE))
),
Lagged as (  -- sonra bu veriler arasında bir önceki satır verileri ile karşılaştırma yaparım:
	select	
		*,
		LAG(CustomerCount) OVER(PARTITION BY City ORDER BY Month) as PrevMonthCount
	from MonthlyCustomerCount
)
select *-- sonra da 'CustomerCount'u bir önceki ay olan 'PrevMonthCount'tan fazla olanlar koşulunu koyarım:
from Lagged
where CustomerCount > PrevMonthCount
	



-- Kategori bazında müşteri başına gelir (revenue).
with CategoryRevenue as ( -- önce her Category için her Customer'ın CustomerCategoryRevenue'sını bulurum:
	select
		p.Category,
		s.CustomerID,
		SUM(s.NetSales) AS CustomerCategoryRevenue
	from dbo.Sales s
	inner join dbo.Products p
		on p.ProductID = s.ProductID
	group by p.Category, s.CustomerID
)
select -- sonra da bu CustomerCategoryRevenue ortalamasını alarak Category bazında gruplarım:
	Category,
	AVG(CustomerCategoryRevenue) AS AvgRevenuePerCustomer
from CategoryRevenue
group by Category



---------------------------------------------------------------------------------------

-- İLERİ SEVİYE

-- Churn riski olan müşterileri tespit et
-- (ör: son 90 gündür alışveriş yapmayanlar).

select  -- müşterinin son alışveriş tarihini bul, son 90 gün ile karşılaştır:
	CustomerID,
	MAX(OrderDate) AS CustomerLastOrderDate
from dbo.Sales
group by CustomerID
having MAX(OrderDate) < DATEADD(DAY, -90, GETDATE())



-- !! İlk alışverişten sonra tekrar alışveriş yapma süresi analizi.
with RankedOrders as (  -- her müşterinin tüm alışverilerini sıraya koyarım, sonra da row_num 1 ve 2 olanlar arasında geçen süreyi kontrol ederim:
	select
		CustomerID,
		OrderDate,
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) AS row_num
	from dbo.Sales
)
select
	r1.CustomerID,
	r1.OrderDate as FirstOrder,
	r2.OrderDate as SecondOrder,
	DATEDIFF(DAY, r1.OrderDate, r2.OrderDate) as DayBetween
from RankedOrders r1
inner join RankedOrders r2
	on r1.CustomerID = r2.CustomerID
where r1.row_num = 1 and r2.row_num = 2



-- !! En kârlı müşteri segmentlerini belirle.
with CustomerRevenue as (  -- önce her müşterinin toplam revenue'sını bulurum:
	select
		CustomerID,
		SUM(NetSales) as TotalRevenue
	from dbo.Sales
	group by CustomerID
),
Segmented as (  -- sonra bu Revenue'ları CASE WHEN ile segmentlere ayırırım:
	select  *,
		case 
			when TotalRevenue >= 6000000 then 'High'
			when TotalRevenue >= 4000000 then 'Medium'
			else 'Low'
		end as Segment
	from CustomerRevenue
)
select -- sonra da Segmentleri total segment revenue'sına göre sıralayıp getiririm:
	Segment,
	count(*) as SegmentCustomerCount,
	sum(TotalRevenue) as SegmentRevenue
from Segmented
group by Segment
order by SegmentRevenue desc



-- Müşterileri harcama düzeyine göre segmentle (Low / Medium / High).
with CustomerRevenue as (  -- önce her müşterinin harcamalarını bulurum:
	select
		CustomerID,
		SUM(NetSales) as CustomerTotalSpent
	from dbo.Sales
	group by CustomerID
)
select  -- sonra da bu harcamaları segmentlere ayırırım:
	*,
	case
		when CustomerTotalSpent >= 6000000 then 'High'
		when CustomerTotalSpent >= 4000000 then 'Medium'
		else 'Low'
	end as Segment
from CustomerRevenue
order by CustomerTotalSpent desc


---------------------------------------------------------------------------------------


-- !! DATA / BI EKİBİ (Bonus – Mülakat Seviyesi)
-- İleri / Challenge

-- Her ay için top 3 ürün (window function).
with MonthlyTopProducts as (  -- önce her ay satılan ürünleri ve toplam getirilerini bulalım:
	select
		YEAR(CAST(s.OrderDate AS DATE)) as Year,
		MONTH(CAST(s.OrderDate AS DATE)) as Month,
		p.ProductName,
		SUM(s.NetSales) as Revenue
	from dbo.Sales s
	inner join dbo.Products p
		on p.ProductID = s.ProductID
	group by YEAR(CAST(s.OrderDate AS DATE)), MONTH(CAST(s.OrderDate AS DATE)), p.ProductName
),
RowNumbered as (  -- sonra da bunları row number ile sıralayalım:
	select
		*,
		ROW_NUMBER() OVER(PARTITION BY Year, Month ORDER BY Revenue DESC) as row_num
	from MonthlyTopProducts
)
select * -- sonra da top 3'ü getirelim:
from RowNumbered
where row_num <=3 



-- Her müşteri için ilk satın alma tutarı vs son satın alma tutarı.
with CustomerOrders as ( -- önce müşterlerin aldıkları orderları sıraya koyarımki ilk ve son orderları belirleyebileyim:
	select
		CustomerID,
		OrderDate,
		NetSales,
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) as rn_first,
		ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) as rn_last
	from dbo.Sales
)
select  -- sonra da burada her iki row_num için de 1 olanları alırım
	c.CustomerID,
	MAX(CASE WHEN co.rn_first = 1 THEN NetSales END) AS FirstOrderAmount,
	MAX(CASE WHEN co.rn_last = 1 THEN NetSales END) AS SecondOrderAmount
from CustomerOrders co
inner join dbo.Customers c
	on c.CustomerID = co.CustomerID
group by c.CustomerID
order by c.CustomerID



-- Günlük satışlara göre outlier günleri tespit et. (Normalden aşırı yüksek satış olan günleri bulmak.)
with DailySales as ( -- önce günlük satışları bulurum:
	select 
		CAST(OrderDate AS DATE) AS OrderDate,
		ROUND(SUM(NetSales), 2) AS DailyTotalSale
	from dbo.Sales
	group by OrderDate
),
Stat as ( -- sonra outlier(aykırı değerler) için temel alabileceğim avg ve standev'ı bulurum:
	select
		AVG(DailyTotalSale) as AvgRevenue,
		STDEV(DailyTotalSale) as StdRevenue
	from DailySales
)
select -- sonra da bu statlar temelinde günlük satışı fazla olan günleri bulurum:
	CAST(d.OrderDate AS DATE) AS OrderDate,
	d.DailyTotalSale
from DailySales d
cross join Stat s
where d.DailyTotalSale > s.AvgRevenue + (2 * s.StdRevenue) -- Revenue > Ortalama + (2 * StdDev) -- (Bu gerçek BI analitiğinde kullanılan yöntemlerden biri)
order by d.DailyTotalSale desc



-- Aynı gün birden fazla sipariş veren müşterileri bul.
select -- her müşteri için her gün kaç adet sipariş verdiklerini bulurum:
	CustomerID,
	CAST(OrderDate AS DATE) AS OrderDate,
 	COUNT(SalesID) AS OrderCount
from dbo.Sales
group by CustomerID, OrderDate
having COUNT(SalesID) > 1
order by OrderCount desc


---------------------------------------------------------------------------------------