*&---------------------------------------------------------------------*
*& Report ZP001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zp001.

DATA ls_conta TYPE zconta.

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE TEXT-001.
PARAMETERS:
  p_conta TYPE zconta-conta NO-DISPLAY,
  p_tipo  TYPE zconta-tipo OBLIGATORY,
  p_cli   TYPE zconta-cliente OBLIGATORY,
*          p_saldo TYPE zconta-saldo,
  p_ger   TYPE zconta-gerente OBLIGATORY,
*          p_dt_ab TYPE zconta-dt_abertura,
  p_ativa TYPE zconta-ativa DEFAULT 'X'.
*          p_moeda TYPE zconta-moeda.
SELECTION-SCREEN END OF BLOCK part1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_cli.
  CALL FUNCTION 'ZFM_PROCURA_PESSOA'
    IMPORTING
      ex_cliente = p_cli.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ger.
  CALL FUNCTION 'ZFM_PROCURA_PESSOA'
    IMPORTING
      ex_cliente = p_ger.


START-OF-SELECTION.

  ls_conta-cliente = p_cli.
  ls_conta-ativa = p_ativa.
  ls_conta-conta = p_conta.
  ls_conta-dt_abertura = sy-datum.
  ls_conta-gerente = p_ger.
  ls_conta-moeda = 'BRL'.
  ls_conta-saldo = 0.
  ls_conta-tipo = p_tipo.

  CALL FUNCTION 'ZFM_VALIDA_CONTA'
    EXPORTING
      im_conta       = ls_conta.

  CALL FUNCTION 'ZFM_CRIAR_CONTA'
    CHANGING
      ch_conta       = ls_conta.

  CONCATENATE 'Conta:' ls_conta-conta 'criada com sucesso!' INTO DATA(lv_text) SEPARATED BY space.

  IF sy-subrc = 0.
    MESSAGE lv_text TYPE 'S'.
  ENDIF.
