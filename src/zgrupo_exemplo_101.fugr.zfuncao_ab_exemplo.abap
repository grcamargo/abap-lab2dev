FUNCTION ZFUNCAO_AB_EXEMPLO.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ELEMENTO) TYPE  INT8
*"  EXPORTING
*"     REFERENCE(E_SAIDA_FIB) TYPE  INT8
*"  EXCEPTIONS
*"      OVERFLOW
*"----------------------------------------------------------------------


  DATA: VL_A TYPE INT8 VALUE 0,
        VL_B TYPE INT8 VALUE 1,
        VL_N TYPE INT8.

  VL_N = I_ELEMENTO - 2.

  CASE I_ELEMENTO.
    WHEN 1.
      E_SAIDA_FIB = VL_A.
    WHEN 2.
      E_SAIDA_FIB = VL_B.
    WHEN OTHERS.
      IF I_ELEMENTO > 100.
        RAISE OVERFLOW.
      ENDIF.

      DO VL_N TIMES.
        E_SAIDA_FIB = VL_A + VL_B.
        VL_A = VL_B.
        VL_B = E_SAIDA_FIB.

      ENDDO.
  ENDCASE.


ENDFUNCTION.
