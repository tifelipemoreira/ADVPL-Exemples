#include 'topconn.ch'

// Relatório PCP para Excel FELIPE Moreira

User Function RelPCP
    Local aPergs := {}
    Local aRet := {}
    aAdd( aPergs ,{1,"Da data Passagem 1: ",STOD(''),"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Ate a data Passagem 1: ",dDataBase,"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Da data Passagem 2: ",STOD(''),"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Ate a data Passagem 2: ",dDataBase,"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Da data Passagem CD: ",STOD(''),"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Ate a data Passagem CD: ",dDataBase,"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"OP: ",Space(15),"",'',"SC2",'',100,.F.})
    aAdd( aPergs ,{1,"DUN: ",Space(15),"",'',"",'',100,.F.})
    aAdd( aPergs ,{1,"Lote: ",Space(15),"",'',"",'',100,.F.})
    aAdd( aPergs ,{1,"Validade: ",STOD(''),"",'',,'',40,.F.})
    aAdd( aPergs ,{1,"Produto: ",Space(15),"",'',"",'',100,.F.})
    If ParamBox(aPergs ,"Relatorio Passagens Producao",aRet)
        LjMsgRun( "Gerando o relatório, aguarde...", , {|| bProc(aRet) } )
    EndIf
Return
Static Function bProc(aRet)
    Local cQry := " "
    Local aExcel := {}
    Local aHeader := {}
    cQry += " SELECT ZP2.ZP2_FILIAL FILIAL, SB1.B1_XDUN DUN, ZP2.ZP2_OP OP,SC2.C2_EMISSAO DTOP, ZP2.ZP2_PRODUT PRODUTO, SB1.B1_DESC DESCRICAO"
    cQry += " , ZP2.ZP2_ID ID, ZP2.ZP2_NUMSEQ NUMSEQ"
    //cQry += " , CC.CC, CC.DESC_CC, ZP2.ZP2_QUANT QUANTIDADE, ZP2.ZP2_QUANT* SB1.B1_PESO PESOl"
    cQry += " , CTT.CTT_CUSTO CC, CTT.CTT_DESC01 DESC_CC, ZP2.ZP2_QUANT QUANTIDADE, ZP2.ZP2_QUANT* SB1.B1_PESO PESOl"
    cQry += " , SUBSTR(AP.PASSAGEM_1,1,8) DTPASS1, SUBSTR(AP.PASSAGEM_1,9,8) HRPASS1"
    cQry += " , CASE WHEN ZP2_STATUS IN ('1','3') THEN SUBSTR(AP.PASSAGEM_2,1,8) ELSE '        ' END DTPASS2"
    cQry += " , CASE WHEN ZP2_STATUS IN ('1','3') THEN SUBSTR(AP.PASSAGEM_2,9,8) ELSE '        ' END HRPASS2"
    cQry += " , CASE WHEN ZP2_STATUS = '3' THEN SUBSTR(AP.PASSAGEM_CD,1,8) ELSE '        ' END DTPASSCD"
    cQry += " , CASE WHEN ZP2_STATUS = '3' THEN SUBSTR(AP.PASSAGEM_CD,9,8) ELSE '        ' END HRPASSCD"
    cQry += " , ZP2.ZP2_LOTE LOTE, ZP2.ZP2_VALIDA VALIDADE, SC2.C2_LOCAL ARMAZEM"
    cQry += " FROM "+RetSqlName("ZP2")+" ZP2"
    cQry += " INNER JOIN "+RetSqlName("SC2")+" SC2 ON SC2.D_E_L_E_T_ = ' ' AND SC2.C2_FILIAL = ZP2.ZP2_FILIAL AND SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD = ZP2.ZP2_OP"
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = ZP2.ZP2_PRODUT"
    cQry += " LEFT JOIN "+RetSqlName("CTT")+" CTT ON CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT.CTT_CUSTO = SB1.B1_CC"
    // cQry += " LEFT JOIN ("
    // cQry += " 	SELECT SG1.G1_FILIAL FILIAL, SG1.G1_COD PRODUTO, MAX(CTT.CTT_CUSTO) CC, MAX(CTT.CTT_DESC01) DESC_CC"
    // cQry += " 	FROM "+RetSqlName("SG1")+" SG1"
    // cQry += " 	INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SG1.G1_COMP AND B1_TIPO = 'MO'"
    // cQry += " 	INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT.D_E_L_E_T_ = ' ' AND SUBSTR(CTT.CTT_FILIAL,1,4) = SUBSTR(SG1.G1_FILIAL,1,4) AND RTRIM(CTT.CTT_CUSTO) = SUBSTR(SG1.G1_COMP,3,5)"
    // cQry += " 	WHERE SG1.D_E_L_E_T_ = ' '"
    // cQry += " 	GROUP BY SG1.G1_FILIAL, SG1.G1_COD"
    // cQry += " ) CC ON CC.FILIAL = ZP2.ZP2_FILIAL AND CC.PRODUTO = ZP2.ZP2_PRODUT"
    cQry += " LEFT JOIN ("
    cQry += " 	SELECT FILIAL, ID, MAX(PASSAGEM_1) PASSAGEM_1, MAX(PASSAGEM_2) PASSAGEM_2, MAX(PASSAGEM_CD) PASSAGEM_CD"
    cQry += " 	FROM (	"
    cQry += " 		SELECT FILIAL, ID, STATUS"
    cQry += " 		,COALESCE(CASE STATUS WHEN '0' THEN DATAHORA ELSE '' END, '                ') PASSAGEM_1"
    cQry += " 		,COALESCE(CASE STATUS WHEN '1' THEN DATAHORA ELSE '' END, '                ') PASSAGEM_2"
    cQry += " 		,COALESCE(CASE STATUS WHEN '3' THEN DATAHORA ELSE '' END, '                ') PASSAGEM_CD"
    cQry += " 		FROM ("
    cQry += " 			SELECT ZP3.ZP3_FILIAL FILIAL, ZP3.ZP3_ID ID, ZP3.ZP3_STATUS STATUS, MAX(ZP3.ZP3_DATA||ZP3.ZP3_HORA) DATAHORA"
    cQry += " 			FROM "+RetSqlName("ZP3")+" ZP3"
    cQry += " 			WHERE ZP3.D_E_L_E_T_ = ' '"
    cQry += " 			GROUP BY ZP3.ZP3_FILIAL, ZP3.ZP3_ID, ZP3.ZP3_STATUS"
    cQry += " 		) A"
    cQry += " 	) B"
    cQry += " 	GROUP BY FILIAL, ID"
    cQry += " ) AP ON AP.FILIAL = ZP2.ZP2_FILIAL AND AP.ID = ZP2.ZP2_ID"
    cQry += " WHERE ZP2.D_E_L_E_T_ = ' '"
    cQry += " AND ZP2.ZP2_FILIAL = '"+xFilial("ZP2")+"'"
    cQry += " AND SUBSTR(AP.PASSAGEM_1,1,8) BETWEEN '"+DTOS(aRet[1])+"' AND '"+DTOS(aRet[2])+"'"
    cQry += " AND SUBSTR(AP.PASSAGEM_2,1,8) BETWEEN '"+DTOS(aRet[3])+"' AND '"+DTOS(aRet[4])+"'"
    cQry += " AND SUBSTR(AP.PASSAGEM_CD,1,8) BETWEEN '"+DTOS(aRet[5])+"' AND '"+DTOS(aRet[6])+"'"
    If Len(AllTrim(aRet[7])) > 0
        cQry += " AND ZP2.ZP2_OP = '"+AllTrim(aRet[7])+"'"
    EndIf
    If Len(AllTrim(aRet[8])) > 0
        cQry += " AND SB1.B1_XDUN = '"+AllTrim(aRet[8])+"'"
    EndIf
    If Len(AllTrim(aRet[9])) > 0
        cQry += " AND ZP2.ZP2_LOTE = '"+AllTrim(aRet[9])+"'"
    EndIf
    If !Empty(aRet[10])
        cQry += " AND ZP2.ZP2_VALIDA = '"+DToS(aRet[10])+"'"
    EndIf
    If Len(AllTrim(aRet[11])) > 0
        cQry += " AND ZP2.ZP2_PRODUT = '"+AllTrim(aRet[11])+"'"
    EndIf
    cQry += " AND ZP2.ZP2_STATUS BETWEEN '0' AND '3'"
    cQry += " ORDER BY SUBSTR(AP.PASSAGEM_1,1,8), SUBSTR(AP.PASSAGEM_1,9,8)"
    TcQuery cQry New Alias "QRYPCP"
    TcSetField("QRYPCP","DTOP","D",8,0)
    TcSetField("QRYPCP","DTPASS1","D",8,0)
    TcSetField("QRYPCP","DTPASS2","D",8,0)
    TcSetField("QRYPCP","DTPASSCD","D",8,0)
    TcSetField("QRYPCP","VALIDADE","D",8,0)

    While !QRYPCP->(EOF())
        aAdd(aExcel, {FILIAL, "P"+ID, NUMSEQ, DUN, OP,DTOP, PRODUTO, DESCRICAO, CC, DESC_CC, QUANTIDADE, PESOL, DTPASS1, HRPASS1, DTPASS2, HRPASS2, DTPASSCD, HRPASSCD, LOTE, VALIDADE, ARMAZEM, ' '})
        QRYPCP->(dbSkip())
    EndDo
    QRYPCP->(dbCloseArea())

    IF Len(aExcel) > 0
        aAdd(aHeader,{"Filial"	        ,"@!",06,0,"","","C","","","",""})
        aAdd(aHeader,{"ID"		        ,"@!",10,0,"","","C","","","",""})
        aAdd(aHeader,{"Num.Seq."        ,"@!",06,0,"","","C","","","",""})
        aAdd(aHeader,{"DUN"		        ,"@!",15,0,"","","C","","","",""})
        aAdd(aHeader,{"OP"		        ,"@!",15,0,"","","C","","","",""})
        aAdd(aHeader,{"Data OP"	        ,"  ",08,0,"","","D","","","",""})
        aAdd(aHeader,{"Produto"	    	,"@!",15,0,"","","C","","","",""})
        aAdd(aHeader,{"Descricao"	    ,"@!",60,0,"","","C","","","",""})
        aAdd(aHeader,{"CC"              ,"@!",15,0,"","","C","","","",""})
        aAdd(aHeader,{"Descricao CC"	,"@!",60,0,"","","C","","","",""})
        aAdd(aHeader,{"Quantidade"      ,"@E 999,999,999.99",12,2,"","","N","","","",""})
        aAdd(aHeader,{"Peso Liquido"	,"@E 999,999,999.99",12,2,"","","N","","","",""})
        aAdd(aHeader,{"Data Passagem 1"	,"  ",08,0,"","","D","","","",""})
        aAdd(aHeader,{"Hora Passagem 1"	,"@!",08,0,"","","C","","","",""})
        aAdd(aHeader,{"Data Passagem 2"	,"  ",08,0,"","","D","","","",""})
        aAdd(aHeader,{"Hora Passagem 2"	,"@!",08,0,"","","C","","","",""})
        aAdd(aHeader,{"Data Passagem CD","  ",08,0,"","","D","","","",""})
        aAdd(aHeader,{"Hora Passagem CD","@!",08,0,"","","C","","","",""})
        aAdd(aHeader,{"Lote"		    ,"@!",09,0,"","","C","","","",""})
        aAdd(aHeader,{"Validade"	    ,"  ",08,0,"","","D","","","",""})
        aAdd(aHeader,{"Armazem"		    ,"@!",02,0,"","","C","","","",""})
        aAdd(aHeader,{""		    ,"@!",02,0,"","","C","","","",""})
        DlgToExcel({{"GETDADOS","Relatorio Passagens Producao",aHeader,aExcel}})
    Else
        MsgStop("Nao ha dados")
    EndIf
Return

