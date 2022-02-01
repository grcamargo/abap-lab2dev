FUNCTION zfm_valida_conta.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_CONTA) TYPE  ZCONTA
*"----------------------------------------------------------------------

  DATA lv_invalid TYPE flag.

  "Validação do Cliente.
  CALL FUNCTION 'ZFM_VALIDA_PESSOA'
    EXPORTING
      im_cpf          = im_conta-cliente
    IMPORTING
      ex_invalid_user = lv_invalid.

  IF lv_invalid IS NOT INITIAL.
    MESSAGE 'Cliente não cadastrado!' TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.

  "Validação do Gerente.
  CALL FUNCTION 'ZFM_VALIDA_PESSOA'
    EXPORTING
      im_cpf          = im_conta-gerente
    IMPORTING
      ex_invalid_user = lv_invalid.

  IF lv_invalid IS NOT INITIAL.
    MESSAGE 'Gerente não cadastrado!' TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.




ENDFUNCTION.
