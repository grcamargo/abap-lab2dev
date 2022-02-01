FUNCTION ZFM_VALIDA_PESSOA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_CPF) TYPE  ZCONTA-CLIENTE
*"  EXPORTING
*"     REFERENCE(EX_INVALID_USER) TYPE  FLAG
*"----------------------------------------------------------------------

SELECT *
  FROM ZPESSOA
  INTO TABLE @DATA(LT_PESSOA)
  WHERE CPF = @IM_CPF.

IF NOT LINE_EXISTS( LT_PESSOA[ 1 ] ) .
  EX_INVALID_USER = 'X'.
ENDIF.

ENDFUNCTION.
