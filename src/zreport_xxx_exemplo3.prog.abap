*&---------------------------------------------------------------------*
*& Report ZREPORT_XXX_EXEMPLO3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREPORT_XXX_EXEMPLO3.


PARAMETER: P_ELEM TYPE INT4.

DATA VG_SAIDA TYPE INT4.

CALL FUNCTION 'ZFUNCAO_XX_EXEMPLO2'
  EXPORTING
    I_ENTRADA     = P_ELEM
  IMPORTING
    E_SAIDA       = VG_SAIDA
  EXCEPTIONS
    INVALID_INPUT = 1
    OTHERS        = 2.

IF SY-SUBRC <> 0.
  WRITE 'ERRO'.
ENDIF.

WRITE VG_SAIDA.
