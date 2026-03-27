# 🗄️ Avansas SQL Sales Analysis

Bu proje, **gerçek dünya iş senaryolarını taklit eden end-to-end bir SQL analiz çalışmasıdır**.  
Amacı, satış, müşteri ve ürün verilerini kullanarak farklı departmanların (Satış, Pazarlama, Müşteri İlişkileri, Data/BI) ihtiyaç duyduğu analizleri SQL ile gerçekleştirmektir.

Proje, **data analyst pozisyonlarında karşılaşılabilecek gerçek iş sorularına** odaklanarak, teknik SQL becerilerini ve **analitik düşünme yeteneğini** bir arada sergilemektedir.

---

## 🎯 Proje Hedefi

İşletmelerde farklı ekipler, kararlarını veri ile desteklemek için analytics ekibinden sıklıkla SQL sorguları talep ederler. Bu proje, aşağıdaki gerçek senaryoları simüle eder:

* **Satış Ekibi**: Günlük satış performansı, top ürünler, aylık trendler
* **Pazarlama Ekibi**: Kategori analizi, müşteri segmentasyonu, kampanya performansı
* **Müşteri İlişkileri**: Churn analizi, müşteri davranışları, tekrar satın alma oranları
* **Data/BI Ekibi**: İleri seviye window functions, outlier detection, cohort analysis

Her bir soru için:
- İş gereksinimi net şekilde tanımlanmıştır
- Analitik düşünce süreci yorum satırlarıyla açıklanmıştır
- Optimize edilmiş SQL sorguları geliştirilmiştir

---

## 📂 Dataset Açıklaması

Projede kullanılan veri seti, bir ofis malzemeleri şirketi (Avansas) senaryosuna dayanmaktadır ve 3 ana tablodan oluşmaktadır.

### **Sales Table** (50,000+ kayıt)
Satış işlemlerinin detaylı kayıtları:
- `SalesID`: Benzersiz satış kimliği
- `OrderDate`: Sipariş tarihi
- `CustomerID`: Müşteri kimliği (foreign key)
- `ProductID`: Ürün kimliği (foreign key)
- `Quantity`: Satış adedi
- `UnitPrice`: Birim fiyat
- `DiscountRate`: İndirim oranı
- `NetSales`: Net satış tutarı
- `OrderChannel`: Satış kanalı (Web, Mobile, Sales Rep)

### **Customers Table** (400+ müşteri)
Müşteri profil bilgileri:
- `CustomerID`: Benzersiz müşteri kimliği
- `CustomerName`: Müşteri adı
- `CustomerType`: Müşteri tipi (B2B, KOBİ, Kurumsal)
- `Sector`: Sektör (IT, Eğitim, Lojistik, Ofis, Sağlık)
- `City`: Şehir
- `Region`: Bölge
- `SignupDate`: Kayıt tarihi
- `IsActive`: Aktiflik durumu

### **Products Table** (150+ ürün)
Ürün kataloğu bilgileri:
- `ProductID`: Benzersiz ürün kimliği
- `ProductName`: Ürün adı
- `Category`: Ana kategori
- `SubCategory`: Alt kategori
- `Brand`: Marka
- `UnitCost`: Birim maliyet
- `UnitPrice`: Birim satış fiyatı
- `IsActive`: Katalog durumu

---

## 🧠 Kullanılan SQL Teknikleri & Metodolojiler

Bu proje, SQL yetkinliğini farklı seviyelerde göstermek üzere tasarlanmıştır:

### **Temel SQL Kavramları**
- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
- `JOIN` operations (INNER, LEFT, CROSS)
- Aggregate Functions (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)
- Date Functions (`YEAR`, `MONTH`, `DATEADD`, `DATEDIFF`)

### **İleri Seviye Teknikler**
- **Common Table Expressions (CTEs)**: Karmaşık sorguların modüler hale getirilmesi
- **Window Functions**: 
  - `ROW_NUMBER()`: Sıralama ve ranking
  - `RANK()`, `DENSE_RANK()`: Performans sıralamaları
  - `LAG()`, `LEAD()`: Zaman serisi analizleri (MoM, YoY)
- **Subqueries**: İç içe sorgular ve filtreleme
- **CASE WHEN**: Müşteri segmentasyonu ve kategorizasyon
- **Statistical Functions**: `STDEV()` ile outlier detection

### **Gerçek İş Problemlerine Çözümler**
- **Cohort Analysis**: İlk alışveriş davranışı analizi
- **Churn Prediction**: Son 90 gün aktivite kontrolü
- **Customer Segmentation**: RFM benzeri segmentasyon mantığı
- **Trend Analysis**: Aylık bazda growth tracking
- **Performance Ranking**: Top N ürün/müşteri analizleri

---

## 📊 İş Senaryoları & Analiz Kategorileri

Projede toplam **60+ SQL sorgusu** 4 farklı departman perspektifinden hazırlanmıştır:

### 🔵 **Satış Ekibi (Sales Team)**
**Kolay Seviye:**
- Toplam ciro hesaplama
- Günlük/aylık satış trendleri
- Top 10 ürün analizi
- Dün yapılan satışlar

**Orta Seviye:**
- Aylık bazda satış karşılaştırmaları
- Müşteri başına ortalama harcama
- Kategori performans analizi
- İndirim etkisi analizi

**İleri Seviye:**
- Outlier detection (normalden yüksek satış günleri)
- Kanal bazlı performans (Web vs Mobile vs Sales Rep)
- Haftalık/aylık satış patternleri

### 🟢 **Pazarlama Ekibi (Marketing Team)**
**Kolay Seviye:**
- Kategori bazlı toplam satış
- En çok satan markalar
- Bölge bazlı satış dağılımı

**Orta Seviye:**
- Kategori bazlı müşteri başına gelir
- İndirimli satışların toplam içindeki payı
- Yeni müşteri kazanım trendleri (MoM)

**İleri Seviye:**
- Top 3 ürün analizi (her ay için window function ile)
- İlk alışverişte en çok tercih edilen ürünler
- Müşteri segmentasyonu (Low/Medium/High)

### 🟠 **Müşteri İlişkileri (Customer Success)**
**Kolay Seviye:**
- Aktif müşteri sayısı
- Şehir bazlı müşteri dağılımı
- En az satış yapan ürünler

**Orta Seviye:**
- Tekrar satın alma oranı
- İlk ve son alışveriş tutarı karşılaştırması
- Son 6 ayda müşteri sayısı artan şehirler

**İleri Seviye:**
- Churn riski analizi (90+ gün inaktif müşteriler)
- İlk alışverişten sonra tekrar alışveriş süresi
- En kârlı müşteri segmentleri

### 🔴 **Data/BI Ekibi (Advanced Analytics)**
**Challenge Seviye:**
- Her ay için top 3 ürün (window functions)
- Günlük satışlara göre outlier tespiti (statistical analysis)
- Aynı gün birden fazla sipariş veren müşteriler
- Zaman serisi analizleri (LAG/LEAD kullanımı)

---

## 💡 Key Insights & Öğrenilenler

Bu proje boyunca aşağıdaki analitik beceriler geliştirilmiştir:

✅ **Teknik SQL Yetkinlikleri:**
- CTEs ve window functions ile karmaşık sorguların basitleştirilmesi
- Join stratejilerinin optimizasyonu
- Performance-aware query yazımı

✅ **Analitik Düşünme:**
- İş problemlerini SQL sorgularına çevirme
- Veriyi anlamlı segmentlere ayırma
- Edge case'leri düşünme (NULL kontrolü, tarih filtreleri)

✅ **İş Anlayışı:**
- Departman bazlı farklı KPI ihtiyaçlarını anlama
- Self-service analytics yaklaşımı
- Stakeholder perspektifinden soru formüle etme

---

## 🛠️ Kullanılan Araçlar & Teknolojiler

- **SQL Server (T-SQL)**
- **Database**: Microsoft SQL Server Management Studio (SSMS)
- **Version Control**: Git & GitHub
- **Data Analysis Concepts**: CTEs, Window Functions, Statistical Analysis

---

## 📁 Repository Yapısı

```
avansas-sql-analysis/
│
├── data/
│   ├── Customers.csv
│   ├── Products.csv
│   └── Sales.csv
│
├── queries/
│   └── avansas_sales_analysis.sql
│
├── images/
│   └── (Query screenshots - isteğe bağlı)
│
└── README.md
```

---

## 🚀 Nasıl Kullanılır?

1. **Database Setup:**
   ```sql
   CREATE DATABASE [avansas-sales]
   GO
   ```

2. **Import Data:**
   - CSV dosyalarını SSMS'e import edin
   - Tablolar: `Customers`, `Products`, `Sales`

3. **Run Queries:**
   - `queries/avansas_sales_analysis.sql` dosyasını açın
   - İlgilendiğiniz analiz kategorisine gidin
   - Sorguları çalıştırın ve sonuçları inceleyin

---

## 📈 Örnek Analizler

### Örnek 1: Müşteri Segmentasyonu
```sql
-- Müşterileri harcama düzeyine göre segmentle (Low / Medium / High)
WITH CustomerRevenue AS (
    SELECT
        CustomerID,
        SUM(NetSales) AS CustomerTotalSpent
    FROM dbo.Sales
    GROUP BY CustomerID
)
SELECT
    *,
    CASE
        WHEN CustomerTotalSpent >= 6000000 THEN 'High'
        WHEN CustomerTotalSpent >= 4000000 THEN 'Medium'
        ELSE 'Low'
    END AS Segment
FROM CustomerRevenue
ORDER BY CustomerTotalSpent DESC
```

### Örnek 2: Aylık Yeni Müşteri Kazanımı (MoM)
```sql
WITH MonthlyNewCustomers AS (
    SELECT
        YEAR(SignupDate) AS Year,
        MONTH(SignupDate) AS Month,
        COUNT(*) AS NewCustomerCount
    FROM dbo.Customers
    GROUP BY YEAR(SignupDate), MONTH(SignupDate)
)
SELECT
    Year,
    Month,
    NewCustomerCount,
    LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS PrevMonthCount,
    NewCustomerCount - LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS MoM_Difference
FROM MonthlyNewCustomers
ORDER BY Year, Month
```

---

## 🎓 Kimler İçin Uygun?

Bu proje özellikle şu kişiler için faydalıdır:
- **Data Analyst** pozisyonlarına hazırlanan adaylar
- SQL becerilerini gerçek senaryolarla test etmek isteyenler
- Business intelligence ve analytics alanında kariyer yapmak isteyenler
- SQL interview hazırlığı yapan adaylar

---

---

# 🗄️ Avansas SQL Sales Analysis

This project is an **end-to-end SQL analysis study simulating real-world business scenarios**.  
The goal is to perform analyses required by different departments (Sales, Marketing, Customer Success, Data/BI) using sales, customer, and product data through SQL.

The project focuses on **real business questions encountered in data analyst positions**, showcasing both technical SQL skills and **analytical thinking ability**.

---

## 🎯 Project Goal

In businesses, different teams frequently request SQL queries from analytics teams to support their decisions with data. This project simulates the following real scenarios:

* **Sales Team**: Daily sales performance, top products, monthly trends
* **Marketing Team**: Category analysis, customer segmentation, campaign performance
* **Customer Success**: Churn analysis, customer behaviors, repeat purchase rates
* **Data/BI Team**: Advanced window functions, outlier detection, cohort analysis

For each question:
- Business requirements are clearly defined
- Analytical thinking process is explained with comments
- Optimized SQL queries are developed

---

## 📂 Dataset Description

The dataset used in the project is based on an office supplies company (Avansas) scenario and consists of 3 main tables.

### **Sales Table** (50,000+ records)
Detailed records of sales transactions:
- `SalesID`: Unique sale identifier
- `OrderDate`: Order date
- `CustomerID`: Customer identifier (foreign key)
- `ProductID`: Product identifier (foreign key)
- `Quantity`: Sales quantity
- `UnitPrice`: Unit price
- `DiscountRate`: Discount rate
- `NetSales`: Net sales amount
- `OrderChannel`: Sales channel (Web, Mobile, Sales Rep)

### **Customers Table** (400+ customers)
Customer profile information:
- `CustomerID`: Unique customer identifier
- `CustomerName`: Customer name
- `CustomerType`: Customer type (B2B, SME, Corporate)
- `Sector`: Sector (IT, Education, Logistics, Office, Healthcare)
- `City`: City
- `Region`: Region
- `SignupDate`: Registration date
- `IsActive`: Active status

### **Products Table** (150+ products)
Product catalog information:
- `ProductID`: Unique product identifier
- `ProductName`: Product name
- `Category`: Main category
- `SubCategory`: Subcategory
- `Brand`: Brand
- `UnitCost`: Unit cost
- `UnitPrice`: Unit selling price
- `IsActive`: Catalog status

---

## 🧠 SQL Techniques & Methodologies Used

This project is designed to demonstrate SQL proficiency at different levels:

### **Fundamental SQL Concepts**
- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
- `JOIN` operations (INNER, LEFT, CROSS)
- Aggregate Functions (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)
- Date Functions (`YEAR`, `MONTH`, `DATEADD`, `DATEDIFF`)

### **Advanced Techniques**
- **Common Table Expressions (CTEs)**: Modularizing complex queries
- **Window Functions**: 
  - `ROW_NUMBER()`: Sorting and ranking
  - `RANK()`, `DENSE_RANK()`: Performance rankings
  - `LAG()`, `LEAD()`: Time series analyses (MoM, YoY)
- **Subqueries**: Nested queries and filtering
- **CASE WHEN**: Customer segmentation and categorization
- **Statistical Functions**: Outlier detection with `STDEV()`

### **Solutions to Real Business Problems**
- **Cohort Analysis**: First purchase behavior analysis
- **Churn Prediction**: Last 90 days activity check
- **Customer Segmentation**: RFM-like segmentation logic
- **Trend Analysis**: Monthly growth tracking
- **Performance Ranking**: Top N product/customer analyses

---

## 📊 Business Scenarios & Analysis Categories

The project includes **60+ SQL queries** prepared from 4 different departmental perspectives:

### 🔵 **Sales Team**
**Easy Level:**
- Total revenue calculation
- Daily/monthly sales trends
- Top 10 product analysis
- Yesterday's sales

**Medium Level:**
- Monthly sales comparisons
- Average spending per customer
- Category performance analysis
- Discount impact analysis

**Advanced Level:**
- Outlier detection (abnormally high sales days)
- Channel-based performance (Web vs Mobile vs Sales Rep)
- Weekly/monthly sales patterns

### 🟢 **Marketing Team**
**Easy Level:**
- Category-based total sales
- Best-selling brands
- Regional sales distribution

**Medium Level:**
- Revenue per customer by category
- Percentage of discounted sales
- New customer acquisition trends (MoM)

**Advanced Level:**
- Top 3 product analysis (window function for each month)
- Most preferred products in first purchase
- Customer segmentation (Low/Medium/High)

### 🟠 **Customer Success**
**Easy Level:**
- Active customer count
- Customer distribution by city
- Least selling products

**Medium Level:**
- Repeat purchase rate
- First vs last purchase amount comparison
- Cities with increasing customer count in last 6 months

**Advanced Level:**
- Churn risk analysis (90+ days inactive customers)
- Time between first and second purchase
- Most profitable customer segments

### 🔴 **Data/BI Team (Advanced Analytics)**
**Challenge Level:**
- Top 3 products for each month (window functions)
- Outlier detection in daily sales (statistical analysis)
- Customers placing multiple orders on the same day
- Time series analyses (LAG/LEAD usage)

---

## 💡 Key Insights & Learnings

The following analytical skills were developed throughout this project:

✅ **Technical SQL Competencies:**
- Simplifying complex queries with CTEs and window functions
- Join strategy optimization
- Performance-aware query writing

✅ **Analytical Thinking:**
- Translating business problems into SQL queries
- Segmenting data into meaningful groups
- Considering edge cases (NULL checks, date filters)

✅ **Business Understanding:**
- Understanding different KPI needs by department
- Self-service analytics approach
- Formulating questions from stakeholder perspective

---

## 🛠️ Tools & Technologies Used

- **SQL Server (T-SQL)**
- **Database**: Microsoft SQL Server Management Studio (SSMS)
- **Version Control**: Git & GitHub
- **Data Analysis Concepts**: CTEs, Window Functions, Statistical Analysis

---

## 📁 Repository Structure

```
avansas-sql-analysis/
│
├── data/
│   ├── Customers.csv
│   ├── Products.csv
│   └── Sales.csv
│
├── queries/
│   └── avansas_sales_analysis.sql
│
├── images/
│   └── (Query screenshots - optional)
│
└── README.md
```

---

## 🚀 How to Use

1. **Database Setup:**
   ```sql
   CREATE DATABASE [avansas-sales]
   GO
   ```

2. **Import Data:**
   - Import CSV files into SSMS
   - Tables: `Customers`, `Products`, `Sales`

3. **Run Queries:**
   - Open `queries/avansas_sales_analysis.sql`
   - Navigate to the analysis category you're interested in
   - Run queries and examine results

---

## 📈 Sample Analyses

### Example 1: Customer Segmentation
```sql
-- Segment customers by spending level (Low / Medium / High)
WITH CustomerRevenue AS (
    SELECT
        CustomerID,
        SUM(NetSales) AS CustomerTotalSpent
    FROM dbo.Sales
    GROUP BY CustomerID
)
SELECT
    *,
    CASE
        WHEN CustomerTotalSpent >= 6000000 THEN 'High'
        WHEN CustomerTotalSpent >= 4000000 THEN 'Medium'
        ELSE 'Low'
    END AS Segment
FROM CustomerRevenue
ORDER BY CustomerTotalSpent DESC
```

### Example 2: Monthly New Customer Acquisition (MoM)
```sql
WITH MonthlyNewCustomers AS (
    SELECT
        YEAR(SignupDate) AS Year,
        MONTH(SignupDate) AS Month,
        COUNT(*) AS NewCustomerCount
    FROM dbo.Customers
    GROUP BY YEAR(SignupDate), MONTH(SignupDate)
)
SELECT
    Year,
    Month,
    NewCustomerCount,
    LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS PrevMonthCount,
    NewCustomerCount - LAG(NewCustomerCount) OVER (ORDER BY Year, Month) AS MoM_Difference
FROM MonthlyNewCustomers
ORDER BY Year, Month
```

---

## 🎓 Who Is This For?

This project is especially useful for:
- Candidates preparing for **Data Analyst** positions
- Those wanting to test SQL skills with real scenarios
- People pursuing careers in business intelligence and analytics
- Candidates preparing for SQL interviews

---

## 📫 Contact & Portfolio

- **LinkedIn**: [Your LinkedIn Profile]
- **GitHub**: [Your GitHub Profile]
- **Portfolio**: [Your Portfolio Website]

---

**⭐ If you find this project helpful, please give it a star!**
