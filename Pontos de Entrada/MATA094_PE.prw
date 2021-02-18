#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#INCLUDE "TOPCONN.CH"

//Pe Desenvolvido por FELIPE Moreira para Grupo Cicopal
//Ajuste Graccho
User Function MATA094 ()
    Local aParam := PARAMIXB
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    Local nLinha := 0
    Local nQtdLinhas := 0
    Local cMsg := ""
    Local nOp
    Local xRet

    If (aParam <> NIL)
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)

        nOpc := oObj:GetOperation() // PEGA A OPERA��O

        If (cIdPonto == "MODELPOS")
            //Chamada na valida��o total do modelo.
        ElseIf (cIdPonto == "MODELVLDACTIVE")
            xRet := .T.
            //Chamada na ativa��o do modelo de dados."
        ElseIf (cIdPonto == "FORMPOS")
            // Chamada na valida��o total do formul�rio.
        ElseIf (cIdPonto =="FORMLINEPRE")
            //Chamada na pr� valida��o da linha do formul�rio.

        ElseIf (cIdPonto =="FORMLINEPOS")

            // Chamada na valida��o da linha do formul�rio.
        ElseIf (cIdPonto =="MODELCOMMITTTS")
            //Chamada ap�s a grava��o total do modelo e dentro da transa��o

            cXorigem := GetComputerName()

            If  Empty(cXorigem)
                cXorigem += "Nao identificado"
            EndIF

            If RecLock('SCR',.F.)

                SCR->CR_XORIGEM := cXorigem +' IP: ' + GetClientIP()
                SCR->CR_XHRAPRV  := rtrim(substr(time(),1,5))
                SCR->CR_XDTAPRV :=  ddatabase
                SCR->(MsUnlock())

            Endif

        ElseIf (cIdPonto =="MODELCOMMITNTTS")

        ElseIf (cIdPonto =="FORMCOMMITTTSPRE")
            //Chamada ap�s a grava��o da tabela do formul�rio

        ElseIf (cIdPonto =="FORMCOMMITTTSPOS")

            //Chamada ap�s a grava��o da tabela do formul�rio
        ElseIf (cIdPonto =="MODELCANCEL")

        ElseIf (cIdPonto =="BUTTONBAR")

        EndIf

    EndIf
    xRet := .T.
Return (xRet)
