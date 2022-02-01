*&---------------------------------------------------------------------*
*& Include          Z_CALCS
*&---------------------------------------------------------------------*
FORM CALC_FIBONACCI USING P_ELEM.
  DATA: VL_A TYPE INT8 VALUE 0,
        VL_B TYPE INT8 VALUE 1,
        VL_N TYPE INT8.

  VL_N = P_ELEM - 2.

  CASE P_ELEM.
    WHEN 1.
      VG_SAIDA_FIB = VL_A.
    WHEN 2.
      VG_SAIDA_FIB = VL_B.
    WHEN OTHERS.
      IF P_ELEM > 100.
        RAISE OVERFLOW.
      ENDIF.
      DO VL_N TIMES.
        VG_SAIDA_FIB = VL_A + VL_B.
        VL_A = VL_B.
        VL_B = VG_SAIDA_FIB.
      ENDDO.
  ENDCASE.

ENDFORM.
