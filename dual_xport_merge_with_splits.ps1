﻿cd c:\export

del *.xlsx
del *.csv

Set-ExecutionPolicy AllSigned
#Connection Strings

$Database = "xxxxxxxx"
$Start= ((Get-Date).AddDays(-7)).ToString("MM-dd-yyyy")
$End= ((Get-Date).AddDays(-1)).ToString("MM-dd-yyyy")
$Server = "xxxxxxxxx"
$AttachmentPath = "C:\TPR.csv"

# Clear Hash Table

clear $objTable_TPR
clear $objTable_Sales
clear $objTable_Regular

#Create HQ data files

\\xxxxxxxxx\instore\hqpm\hqpm /user xxxxxxx /password xxx /menu XXXXXXXXwithaddedfields4101 "SendTo File=c:\HQ_4101.csv, Close" /Exit | Out-Null
\\xxxxxxxxx\instore\hqpm\hqpm /user xxxxxxx /password xxx /menu XXXXXXXXwithaddedfields4110 "SendTo File=c:\HQ_4110.csv, Close" /Exit | Out-Null
\\xxxxxxxxx\instore\hqpm\hqpm /user xxxxxxx /password xxx /menu XXXXXXXXwithaddedfields4117 "SendTo File=c:\HQ_4117.csv, Close" /Exit | Out-Null

# Connect to SQL and query data, extract data to SQL Adapter
$SqlQuery = "SELECT (CASE WHEN b.store_number IN (102, 104, 105, 106, 115, 118, 120, 207, 208, 209) THEN 4101 WHEN b.store_number IN (110, 114) 
                      THEN 4110 WHEN b.store_number IN (111, 112, 513, 116, 117, 119) THEN 4117 END) AS Zone, a.upc, SUM(b.retail_dollars) AS Sales, SUM(b.TONAGE) AS TONAGE, SUM(b.quantity) AS Quantity
Into #TPR
FROM       xxxxxxxx.dbo.item_master AS a INNER JOIN
           xxxxxxxx.dbo.item_xxxxxxxx AS b ON a.item_id = b.item_id
WHERE     (a.minor_department IN ('01', '02', '03', '04', '05', '06', '08', '09', '11', '12', '13', '14', '15')) AND (b.xxxxxxxx_date BETWEEN '05/04/2012' AND '05/10/2012') AND (a.item_status <> 'Discontinued') AND 
                      (b.store_number <> 'CMPNY') AND (a.minor_category IN ('001100', '001102', '001104', '001105', '001106', '001107', '002101', '003100', '003101', '010110', '011101', 
                      '014100', '014101', '020101', '020102', '020103', '020104', '020105', '020106', '020107', '020108', '021100', '021102', '021103', '021104', '021105', '021106', 
                      '023100', '037101', '050101', '050102', '050103', '050104', '050105', '050107', '051100', '051101', '051102', '051103', '052100', '052101', '052102', '052103', 
                      '052104', '052105', '053100', '053101', '053102', '054100', '054101', '054102', '055000', '055100', '055101', '056100', '056101', '056103', '056104', '057100', 
                      '057101', '057102', '057103', '058100', '058101', '058102', '058103', '059100', '059101', '059102', '059103', '060100', '060101', '060102', '060103', '060104', 
                      '060105', '060106', '062100', '062101', '062102', '064100', '064101', '064102', '064103', '064104', '064105', '064106', '064107', '064108', '064109', '064110', 
                      '070100', '070102', '070103', '070104', '071100', '071101', '071102', '071103', '072100', '072101', '073101', '073102', '073103', '073104', '073105', '073108', 
                      '073109', '073110', '075101', '075102', '077100', '077101', '077102', '077103', '077104', '077105', '078100', '078101', '079100', '079101', '080100', '080101', 
                      '101100', '101101', '104100', '104101', '110100', '110101', '110102', '110103', '110200', '116100', '116101', '116102', '116103', '131101', '131104', '137100', 
                      '137102', '137103', '137104', '140101', '140102', '144100', '150104', '150107', '150200', '150203', '160100', '160101', '160102', '170100', '170101', '170102', 
                      '170103', '170104', '170105', '170106', '170107', '170108', '170109', '180101', '180102', '180103', '180104', '180105', '180106', '180107', '180108', '188101', 
                      '190100', '190101', '190102', '190103', '195100', '195102', '195103', '195104', '199100', '199101', '250100', '250200', '250202', '250300', '253100', '253101', 
                      '253103', '253105', '255101', '255102', '255103', '255104', '256100', '256101', '256102', '256104', '256105', '258100', '258101', '258102', '264100', '264101', 
                      '264102', '265101', '265102', '265103', '265104', '266100', '271101', '278100', '278101', '278102', '280100', '280101', '280102', '280105', '280106', '280107', 
                      '280110', '280111', '280112', '280113', '280201', '280202', '280204', '280205', '300100', '300101', '300102', '310100', '310101', '310102', '310103', '320100', 
                      '320101', '320102', '320105', '330100', '330101', '330103', '330106', '340100', '340101', '340102', '340103', '350100', '350102', '360100', '360101', '370100', 
                      '370101', '370102', '370103', '370104', '411101', '411102', '411103', '411104', '411105', '411106', '411107', '411108', '411109', '411110', '411111', '411112', 
                      '411113', '412100', '412106', '412108', '413100', '413101', '413102', '413103', '413104', '413105', '413106', '413107', '413108', '413110', '413111', '413112', 
                      '413113', '413114', '413115', '413116', '413119', '413300', '413310', '413311', '413312', '413313', '414100', '414101', '414102', '414103', '414104', '414105', 
                      '414108', '414200', '415100', '415101', '415102', '415103', '415104', '415107', '415108', '415109', '415110', '415111', '415112', '415113', '475103', '530100', 
                      '530101', '530102', '530103', '530104', '530105', '530106', '530107', '530108', '530109', '530110', '530111', '530200', '530201', '530202', '570100', '570101', 
                      '570102', '570103', '580101', '580102', '580103', '580104', '580110', '580111', '580112', '620100', '620101', '620102', '620103', '620104', '620105', '620106', 
                      '620107', '620108', '630100', '630101', '630102', '650100', '650101', '650102', '650103', '650104', '650105', '680103', '680104', '690100', '690101', '690102', 
                      '690103', '690104', '720100', '720101', '750100', '750101', '750102', '750103', '750104', '750105', '790100', '790101', '790103', '790106', '790114', '790115', 
                      '790119', '810101', '810102', '810103', '830100', '830101', '830102', '830103', '830104', '900100', '900101', '900102', '900103', '900104', '900105', '900106', 
                      '900107', '900108', '900109', '900110', '900111', '900112', '901100', '901101', '902100', '902101', '903100', '903101', '903102', '903103', '903104', '904100', 
                      '904101', '904102', '904103', '904104', '904105', '904106', '905100', '905101', '905102', '905103', '905104', '905105', '909100', '909101', '909102', '911100', 
                      '911101', '911104', '912100', '912101', '912102', '913100', '913101', '913102', '913103', '913106', '914101', '914102', '914103', '914104', '914105', '920100', 
                      '920101', '920102', '920103', '920104', '920105', '920106', '920107', '920108', '920109', '920110', '920111', '921100', '923100', '923101', '923102', '923103', 
                      '923104', '923105', '923106', '923107', '924100', '924101', '924102', '924103', '924104', '935100', '935101', '935102', '935103', '935104', '935105', '950000', 
                      '950100', '950101', '950102', '950103', '957100', '957201', '957202', '957204', '958100', '958101', '961100', '961101', '961102', '961103', '961104', '961105', 
                      '961106', '961107', '961108', '961109', '970100', '520100', '520101'))
and xxxxxxxx_ID IN (1,2,4)
					  GROUP BY store_number, upc
					  
select zone, upc, 
Sum (Sales) as TPR_Sales,
Sum (TONAGE) as TPR_TONAGE,
Sum (Quantity) as TPR_Quantity
from #TPR GROUP BY zone, upc
order by UPC"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;Integrated Security = True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
$nRecs | Out-Null

#Populate Hash Table

$objTable_TPR = $DataSet.Tables[0]

#Export Hash Table to CSV File

$objTable_TPR | Export-CSV -NoTypeInformation $AttachmentPath

#create date variable

$date = Get-Date -format "yyyyMMdd"

$grouped_TPR_Test1_4101=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4101}|  group UPC -AsHashTable -AsString 
Import-Csv c:\HQ_4101.csv  | foreach{
	$Sales=($grouped_TPR_Test1_4101."$($_.UPC)" | foreach {$_.TPR_Sales}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name SALES -Value $Sales -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_4101.csv

$grouped_TPR_Test1_4110=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4110}|  group UPC -AsHashTable -AsString 
Import-Csv c:\HQ_4110.csv  | foreach{
	$Sales=($grouped_TPR_Test1_4110."$($_.UPC)" | foreach {$_.TPR_Sales}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name SALES -Value $Sales -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_4110.csv

$grouped_TPR_Test1_4117=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4117}|  group UPC -AsHashTable -AsString 
Import-Csv c:\HQ_4117.csv  | foreach{
	$Sales=($grouped_TPR_Test1_4117."$($_.UPC)" | foreach {$_.TPR_Sales}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name SALES -Value $Sales -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_4117.csv
 
$grouped_TPR_Test1_4101.Clear() 
$grouped_TPR_Test1_4110.Clear() 
$grouped_TPR_Test1_4117.Clear() 

#del HQ_4*.csv

$grouped_TPR_Test2_4101=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4101}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_4101.csv | foreach{
	$TONAGE=($grouped_TPR_Test2_4101."$($_.UPC)" | foreach {$_.TPR_TONAGE}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name TONAGE -Value $TONAGE -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_TONAGE_4101.csv
 
 $grouped_TPR_Test2_4110=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4110}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_4110.csv | foreach{
	$TONAGE=($grouped_TPR_Test2_4110."$($_.UPC)" | foreach {$_.TPR_TONAGE}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name TONAGE -Value $TONAGE -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_TONAGE_4110.csv
 
 $grouped_TPR_Test2_4117=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4117}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_4117.csv | foreach{
	$TONAGE=($grouped_TPR_Test2_4117."$($_.UPC)" | foreach {$_.TPR_TONAGE}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name TONAGE -Value $TONAGE -PassThru 
 } | Export-Csv -NoTypeInformation c:\HQ_TPR_sales_TONAGE_4117.csv
 
$grouped_TPR_Test2_4101.Clear() 
$grouped_TPR_Test2_4110.Clear() 
$grouped_TPR_Test2_4117.Clear() 
 
 $grouped_TPR_Test3_4101=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4101}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_TONAGE_4101.csv | foreach{
	$Quantity=($grouped_TPR_Test3_4101."$($_.UPC)" | foreach {$_.TPR_Quantity}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name QUANTITY -Value $Quantity -PassThru 
 } | Export-Csv -NoTypeInformation "c:\XXXXXXXX_105_4101_1.csv"
 
 $grouped_TPR_Test3_4110=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4110}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_TONAGE_4110.csv | foreach{
	$Quantity=($grouped_TPR_Test3_4110."$($_.UPC)" | foreach {$_.TPR_Quantity}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name QUANTITY -Value $Quantity -PassThru 
 } | Export-Csv -NoTypeInformation "c:\XXXXXXXX_114_4110_1.csv"
 
 $grouped_TPR_Test3_4117=Import-Csv c:\TPR.csv |WHERE-OBJECT {$_.Zone -eq 4117}|  group UPC -AsHashTable -AsString
Import-Csv c:\HQ_TPR_sales_TONAGE_4117.csv | foreach{
	$Quantity=($grouped_TPR_Test3_4117."$($_.UPC)" | foreach {$_.TPR_Quantity}) -join ","
	 $_ | Add-Member -MemberType NoteProperty -Name QUANTITY -Value $Quantity -PassThru 
 } | Export-Csv -NoTypeInformation "c:\XXXXXXXX_117_4117_1.csv"
 
$grouped_TPR_Test3_4101.Clear() 
$grouped_TPR_Test3_4110.Clear() 
$grouped_TPR_Test3_4117.Clear() 
 
 #Split columns for category_name / subcategory_name and  category_id / subcategory_id
 
 import-csv c:\XXXXXXXX_105_4101_1.csv | ForEach-Object {
    $_.Sub_Category_Name,$tempCAT1=$_.Sub_Category_Name -split "-",2
    $_.Sub_Category_ID,$tempID1=$_.Sub_Category_ID -split " ",2
    $_ | Select-Object  UPC, Product_Desc, Size, UUOM, @{ expression={$_.Sub_Category_Name}; label='Category_Name' }, @{Name="Sub_Category_Name";Expression={$tempCAT1}},  @{ expression={($_.Sub_Category_ID).Substring(0,3)}; label='Category_ID'}, @{ expression={($_.Sub_Category_ID).Substring(3,3)}; label='Sub_Category_ID'}, Vendor, Vendor_ID, "Reg Pr Mult", Base_Price, "Sale Pr Mult", Promo_Price, Promo_Start_Date, Promo_End_Date, "TPR Pr Mult", TPR_Price, TPR_Start_Date, TPR_End_Date, Zone_Price_Strategy, PRICE_ASSOCIATION_CODE, IP_PRICE_METHOD, SALE_IP_RETAIL_DISCOUNT, SALE_RETAIL_DISC_FLAG, tpr_IP_RETAIL_DISCOUNT, TPR_RETAIL_DISC_FLAG, Dept., "Dept Desc", SALES, TONAGE, QUANTITY
} | export-csv  -NoTypeInformation c:\XXXXXXXX_105_4101.csv

import-csv c:\XXXXXXXX_114_4110_1.csv | ForEach-Object {
    $_.Sub_Category_Name,$tempCAT2=$_.Sub_Category_Name -split "-",2
    $_.Sub_Category_ID,$tempID2=$_.Sub_Category_ID -split " ",2
    $_ | Select-Object  UPC, Product_Desc, Size, UUOM, @{ expression={$_.Sub_Category_Name}; label='Category_Name' }, @{Name="Sub_Category_Name";Expression={$tempCAT2}},  @{ expression={($_.Sub_Category_ID).Substring(0,3)}; label='Category_ID'}, @{ expression={($_.Sub_Category_ID).Substring(3,3)}; label='Sub_Category_ID'}, Vendor, Vendor_ID, "Reg Pr Mult", Base_Price, "Sale Pr Mult", Promo_Price, Promo_Start_Date, Promo_End_Date, "TPR Pr Mult", TPR_Price, TPR_Start_Date, TPR_End_Date, Zone_Price_Strategy, PRICE_ASSOCIATION_CODE, IP_PRICE_METHOD, SALE_IP_RETAIL_DISCOUNT, SALE_RETAIL_DISC_FLAG, tpr_IP_RETAIL_DISCOUNT, TPR_RETAIL_DISC_FLAG, Dept., "Dept Desc", SALES, TONAGE, QUANTITY
} | export-csv  -NoTypeInformation c:\XXXXXXXX_114_4110.csv

import-csv c:\XXXXXXXX_117_4117_1.csv | ForEach-Object {
    $_.Sub_Category_Name,$tempCAT3=$_.Sub_Category_Name -split "-",2
    $_.Sub_Category_ID,$tempID3=$_.Sub_Category_ID -split " ",2
    $_ | Select-Object  UPC, Product_Desc, Size, UUOM, @{ expression={$_.Sub_Category_Name}; label='Category_Name' }, @{Name="Sub_Category_Name";Expression={$tempCAT3}},  @{ expression={($_.Sub_Category_ID).Substring(0,3)}; label='Category_ID'}, @{ expression={($_.Sub_Category_ID).Substring(3,3)}; label='Sub_Category_ID'}, Vendor, Vendor_ID, "Reg Pr Mult", Base_Price, "Sale Pr Mult", Promo_Price, Promo_Start_Date, Promo_End_Date, "TPR Pr Mult", TPR_Price, TPR_Start_Date, TPR_End_Date, Zone_Price_Strategy, PRICE_ASSOCIATION_CODE, IP_PRICE_METHOD, SALE_IP_RETAIL_DISCOUNT, SALE_RETAIL_DISC_FLAG, tpr_IP_RETAIL_DISCOUNT, TPR_RETAIL_DISC_FLAG, Dept., "Dept Desc", SALES, TONAGE, QUANTITY
} | export-csv  -NoTypeInformation c:\XXXXXXXX_117_4117.csv

exit
