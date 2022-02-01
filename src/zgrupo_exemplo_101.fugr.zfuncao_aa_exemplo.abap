FUNCTION ZFUNCAO_AA_EXEMPLO.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ELEMENTO) TYPE  INT8
*"  EXPORTING
*"     REFERENCE(E_SAIDA_FIB) TYPE  INT8
*"  EXCEPTIONS
*"      OVERFLOW
*"----------------------------------------------------------------------


  PERFORM CALC_FIBONACCI USING I_ELEMENTO.

  E_SAIDA_FIB = VG_SAIDA_FIB.

ENDFUNCTION.
