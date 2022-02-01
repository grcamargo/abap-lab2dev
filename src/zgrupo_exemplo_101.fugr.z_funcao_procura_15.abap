FUNCTION Z_FUNCAO_PROCURA_15.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(COUNTER) TYPE  INT4 DEFAULT 0
*"     VALUE(FUNC_REG) TYPE  INT4
*"     VALUE(CAD_REG) TYPE  INT4
*"     VALUE(PROC_REG) TYPE  INT4
*"----------------------------------------------------------------------
******************************
* Funcao procura funcionario *
* Autor: Jeivy souza Alves   *
* Data: 25/11/2021     *
******************************

  WHILE counter < 1000.
    IF cad_reg EQ proc_reg.
      func_reg = cad_reg.
    ENDIF.
    counter = counter + 1.
  ENDWHILE.

ENDFUNCTION.
