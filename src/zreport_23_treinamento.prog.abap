*&---------------------------------------------------------------------*
*& Report ZREPORT_99_TREINAMENTO
*&---------------------------------------------------------------------*
REPORT zreport_99_treinamento.

*-------------------------------------------------------------*
* Declarações
*-------------------------------------------------------------*
TABLES: bapisflkey, bapisfldra.

DATA: gt_flight_list TYPE TABLE OF bapisfldat,
      wa_flight_list TYPE bapisfldat,

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
  PERFORM seleciona_dados.

*-------------------------------------------------------------*
END-OF-SELECTION.
*-------------------------------------------------------------*
  PERFORM exibe_lista.


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
  DATA lv_total TYPE bapisfldat-price.

  LOOP AT gt_flight_list INTO wa_flight_list.
    WRITE:/ wa_flight_list-airlineid,
            wa_flight_list-airline,
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

    lv_total = lv_total + wa_flight_list-price.
  ENDLOOP.

  WRITE:/ 'Total:', lv_total.

ENDFORM.
