FUNCTION zfm_criar_conta.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CH_CONTA) TYPE  ZCONTA
*"----------------------------------------------------------------------
  SELECT MAX( conta )
    FROM zconta
    INTO @DATA(ls_max_conta).

  ls_max_conta = ls_max_conta + 1.

  ch_conta-conta = ls_max_conta.

  INSERT zconta FROM ch_conta.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE 'Erro ao criar conta!' TYPE 'E'.
  ENDIF.




ENDFUNCTION.
