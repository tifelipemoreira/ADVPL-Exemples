#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "rwmake.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ VLDE1    ¦ Autor ¦ Felipe Moreira        ¦ Data ¦ 29/10/19 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ VALIDAÇÕES VARIADAS MODULO FINANCEIRO TABELA SE1           ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ CICOPAL                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function VLDTIP(cE1_tipo,nOpc)

	Local xRet := " "

	IF nOpc == 1  //teste se chamada é da x3_when

		If cE1_tipo = ('RA') .OR. cE1_tipo = ('PA') .OR. cE1_tipo = ('CH')  // se tipo RA.PA.CH

			xRetl := .F.
		Else
			xRetl := .T.
		EndIf

	ElseIf nOpc == 2

		If cE1_tipo = "RA"
			xRetl := "11210001"

		ElseIF cE1_TIPO = "CH"
			xRetl := "11110009"
		Else
			xRetl := " "

		EndIF
	ElseIf nOpc == 3 // essa situação é para quando retornar da E2.

		If cE1_TIPO = "PA"
			xRetl := "21230001"
		Else
			xRetl := " "
		EndIF
	ElseIf nOpc == 4 // essa situação é para quando retornar da E2.

		If cE1_TIPO = "PA"
			xRetl := .F.
		Else
			xRetl := .T.
		EndIF
	EndIF

Return xRetl

