*&---------------------------------------------------------------------*
*& Report Z_TREINAMENTO_FUNC_FIB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TREINAMENTO_FUNC_FIB.

PARAMETER: P_ELEM TYPE INT8.

DATA VG_SAIDA TYPE INT8.

CALL FUNCTION 'ZFUNCAO_AA_EXEMPLO'
  EXPORTING
    I_ELEMENTO  = P_ELEM
  IMPORTING
    E_SAIDA_FIB = VG_SAIDA
  EXCEPTIONS
    OVERFLOW    = 1
    OTHERS      = 2.
IF SY-SUBRC <> 0.
  MESSAGE 'Overflow!' TYPE 'A'.
ENDIF.

WRITE VG_SAIDA.
