SELECT ---dimensions-------------
	fact.FVIL_VESSEL_INV_SK
      ,fact.FVIL_DIVISION_SK
      ,fact.FVIL_SUPPLIER_SK
      ,fact.FVIL_ACCOUNT_SK
      ,fact.FVIL_PROC_ITEM_TYPE_SK
      ,fact.FVIL_INVOICE_DATE_SK
      ,fact.FVIL_INVOICE_LINE_NO
      ,fact.FVIL_VESSEL_PO_SK
      ,fact.FVIL_VESSEL_SK
      ,fact.FVIL_CURRENCY_SK
	   ---measures------------------
      ,FVIL_INVOICE_LINE_CURR_AMT
      ,FVIL_INVOICE_LINE_BASE_AMT
      ,FVIL_INVOICE_LINE_CURR_CAD_AMT
      ,FVIL_INVOICE_LINE_USD_AMT
      ,FVIL_INVOICE_LINE_EUR_AMT
FROM dw.FACT_VESSEL_INVOICE_LINES fact
JOIN dw.DIM_VESSEL_INVOICE_HEADER inv
	ON inv.VESSEL_INV_SK = fact.FVIL_VESSEL_INV_SK 
JOIN dw.DIM_REGION reg
	ON reg.REGION_SK = fact.FVIL_DIVISION_SK
JOIN dw.DIM_CONTACT_SHIPSURE supp
	ON supp.CONTACT_SS_SK = fact.FVIL_SUPPLIER_SK
JOIN dw.DIM_ACCOUNT_SHIPSURE acc
	ON acc.ACCOUNT_SS_SK = fact.FVIL_ACCOUNT_SK
JOIN dw.DIM_PROCUREMENT_ITEM_TYPE itemtype
	ON itemtype.PROC_ITEM_TYPE_SK = fact.FVIL_PROC_ITEM_TYPE_SK
JOIN dw.DIM_VESSEL_PO_HEADER po
	ON po.VESSEL_PO_SK = fact.FVIL_VESSEL_PO_SK
JOIN dw.DIM_VESSEL_SHIPSURE ves
	ON ves.VESSEL_SS_SK = fact.FVIL_VESSEL_SK
JOIN dw.DIM_CURRENCY curr
	ON curr.CURRENCY_SK = fact.FVIL_CURRENCY_SK
WHERE fact.FVIL_INVOICE_DATE_SK
	BETWEEN CAST(CONVERT(char(8), getdate()-91,112) as int) -- filter on a primary key to reduce query execution time (last 90 days since yesterday)
	AND CAST(CONVERT(char(8), getdate()-1,112) as int)