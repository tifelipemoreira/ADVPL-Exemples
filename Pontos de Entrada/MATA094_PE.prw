#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#INCLUDE "TOPCONN.CH"

//Pe Desenvolvido por FELIPE Moreira para Grupo Cicopal

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

        nOpc := oObj:GetOperation() // PEGA A OPERAÇÃO

        If (cIdPonto == "MODELPOS")
            //Chamada na validação total do modelo.
        ElseIf (cIdPonto == "MODELVLDACTIVE")
            xRet := .T.
            //Chamada na ativação do modelo de dados."
        ElseIf (cIdPonto == "FORMPOS")
            // Chamada na validação total do formulário.
        ElseIf (cIdPonto =="FORMLINEPRE")
            //Chamada na pré validação da linha do formulário.

        ElseIf (cIdPonto =="FORMLINEPOS")

            // Chamada na validação da linha do formulário.
        ElseIf (cIdPonto =="MODELCOMMITTTS")
            //Chamada após a gravação total do modelo e dentro da transação

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
            //Chamada após a gravação da tabela do formulário

        ElseIf (cIdPonto =="FORMCOMMITTTSPOS")

            //Chamada após a gravação da tabela do formulário
        ElseIf (cIdPonto =="MODELCANCEL")

        ElseIf (cIdPonto =="BUTTONBAR")

        EndIf

    EndIf
    xRet := .T.
Return (xRet)
