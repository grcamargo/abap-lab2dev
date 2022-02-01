*&---------------------------------------------------------------------*
*& Report ZREPORT_99_TREINAMENTO
*&---------------------------------------------------------------------*
REPORT zreport_99_treinamento.

*-------------------------------------------------------------*
* Declarações
*-------------------------------------------------------------*
TABLES: bapisflkey, bapisfldra.

DATA: gt_flight_list TYPE TABLE OF zbapisfldat,
      wa_flight_list TYPE zbapisfldat,

      gt_return      TYPE TABLE OF bapiret2,
      wa_return      TYPE bapiret2.

*-------------------------------------------------------------*
* SELECT-OPTIONS
*-------------------------------------------------------------*
PARAMETERS     p_id   TYPE bapisflkey-airlineid.
SELECT-OPTIONS s_date FOR bapisfldra-low.

*-------------------------------------------------------------*
INITIALIZATION.
*-------------------------------------------------------------*

*-------------------------------------------------------------*
START-OF-SELECTION.
*-------------------------------------------------------------*

*  MESSAGE i000(zdante).
  PERFORM seleciona_dados.

*-------------------------------------------------------------*
END-OF-SELECTION.
*-------------------------------------------------------------*
*  PERFORM exibe_lista.
  PERFORM exibe_lista_alv.

*-------------------------------------------------------------*
* Forms
*-------------------------------------------------------------*
*-------------------------------------------------------------*
* FORM seleciona_dados
*-------------------------------------------------------------*
FORM seleciona_dados.
* Busca Lista de Voo
  CALL FUNCTION 'BAPI_FLIGHT_GETLIST'
    EXPORTING
      airline     = p_id
    TABLES
      date_range  = s_date
      flight_list = gt_flight_list
      return      = gt_return.

ENDFORM.

*-------------------------------------------------------------*
* FORM exibe_lista
*-------------------------------------------------------------*
FORM exibe_lista.
  DATA: lv_total       TYPE bapisfldat-price,
        lv_al_id       TYPE bapisfldat-airline,
        lv_al_subtotal TYPE bapisfldat-price.

  SORT gt_flight_list BY airlineid.

  LOOP AT gt_flight_list INTO wa_flight_list.
    " SUB-TOTAL
    IF wa_flight_list-airlineid = lv_al_id OR lv_al_id IS INITIAL.
      lv_al_subtotal = lv_al_subtotal + wa_flight_list-price.
      lv_al_id = wa_flight_list-airlineid.
    ELSE.
      WRITE: sy-uline(55), sy-vline.
      IF lv_al_subtotal < 20000.
        FORMAT COLOR COL_NEGATIVE ON.
      ELSE.
        FORMAT COLOR COL_HEADING ON.
      ENDIF.
      WRITE: 'Sub-total:', lv_al_subtotal, sy-vline.
      FORMAT COLOR OFF.
      WRITE: sy-uline(55).
      CLEAR: lv_al_id, lv_al_subtotal.
      lv_al_subtotal = lv_al_subtotal + wa_flight_list-price.
      lv_al_id = wa_flight_list-airlineid.
    ENDIF.

    WRITE:/ wa_flight_list-airlineid,
            wa_flight_list-airline(10),
            wa_flight_list-connectid,
            wa_flight_list-flightdate,
            wa_flight_list-airportfr,
            wa_flight_list-cityfrom,
            wa_flight_list-airportto,
            wa_flight_list-cityto,
            wa_flight_list-deptime,
            wa_flight_list-arrtime,
            wa_flight_list-arrdate,
            wa_flight_list-price,
            wa_flight_list-curr,
            wa_flight_list-curr_iso.
    " TOTAL
    lv_total = lv_total + wa_flight_list-price.
  ENDLOOP.

* Imprime ultimo subtotal
  WRITE: sy-uline(55), sy-vline.
  IF lv_al_subtotal < 20000.
    FORMAT COLOR COL_NEGATIVE ON.
  ELSE.
    FORMAT COLOR COL_HEADING ON.
  ENDIF.
  WRITE: 'Sub-total:', lv_al_subtotal, sy-vline.
  FORMAT COLOR OFF.
  WRITE: sy-uline(55).
  CLEAR: lv_al_id, lv_al_subtotal.

* Imprime total subtotal
  WRITE: sy-uline(55), sy-vline, 'Total:', lv_total, sy-vline, sy-uline(55).

ENDFORM.

*-------------------------------------------------------------*
* FORM exibe_lista_alv
*-------------------------------------------------------------*
FORM exibe_lista_alv.

  CONSTANTS c_table TYPE dd02l-tabname VALUE 'BAPISFLDAT'.

  DATA: lt_fieldcat TYPE lvc_t_fcat,
        wa_layout   TYPE lvc_s_layo,
        wa_fieldcat TYPE LINE OF lvc_t_fcat.

* Ajusta layout
  wa_layout-zebra      = 'X'.
*  wa_layout-edit       = 'X'.
  wa_layout-no_hgridln = 'X'.

  wa_layout-sel_mode   = 'C'.
  wa_layout-box_fname  = 'BOX'.

* Obtém estrutura do report
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = c_table
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

*  sg_fieldcat-edit = 'X'.
*  MODIFY lt_fieldcat FROM sg_fieldcat TRANSPORTING edit WHERE key IS INITIAL.

*  LOOP AT lt_fieldcat INTO wa_fieldcat.
*    wa_fieldcat-edit = 'X'.
*    MODIFY lt_fieldcat FROM wa_fieldcat INDEX sy-tabix.
*  ENDLOOP.

* Exibe report
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      is_layout_lvc            = wa_layout
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      i_callback_user_command  = 'F_USER_COMMAND'
      it_fieldcat_lvc          = lt_fieldcat
    TABLES
      t_outtab                 = gt_flight_list
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

ENDFORM.

*-------------------------------------------------------------*
* FORM f_user_command
*-------------------------------------------------------------*
FORM f_user_command USING  vl_ucomm    LIKE sy-ucomm
                           st_selfield TYPE slis_selfield.
  CASE sy-ucomm.
    WHEN 'DELE'.
      DELETE gt_flight_list WHERE box = 'X'.
      st_selfield-refresh = 'X'.

  ENDCASE.

ENDFORM.

*-------------------------------------------------------------*
* FORM f_set_pf_status
*-------------------------------------------------------------*
FORM f_set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZBARRA'.
ENDFORM.
