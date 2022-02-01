FUNCTION ZFM_PROCURA_PESSOA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_CLIENTE) TYPE  ZCONTA-CLIENTE
*"----------------------------------------------------------------------
DATA: lt_return TYPE TABLE OF DDSHRETVAL.

SELECT CPF, NOME
  FROM ZPESSOA
  INTO TABLE @DATA(lt_values).

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CPF'    " Name of field in VALUE_TAB
      value_org       = 'S'        " Value return: C: cell by cell, S: structured
    TABLES
      value_tab       = lt_values  " Table of values: entries cell by cell
      return_tab      = lt_return  " Return the selected value
    EXCEPTIONS
      parameter_error = 1          " Incorrect parameter
      no_values_found = 2          " No values found
      OTHERS          = 3.

IF line_exists( lt_return[ 1 ] ).
  EX_CLIENTE = lt_return[ 1 ]-fieldval.
ENDIF.


ENDFUNCTION.
