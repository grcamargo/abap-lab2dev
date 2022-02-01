*&---------------------------------------------------------------------*
*& Report ZREPORT_32_TREINAMENTO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREPORT_32_TREINAMENTO.

*-------------------------------------------------------------*
* Declarações
*-------------------------------------------------------------*
TYPES: BEGIN OF T_PARCIAL,
         T_AIR_ID      TYPE BAPISFLKEY-AIRLINEID,
         T_AIR_NOME    TYPE BAPISFLDAT-AIRLINE,
         T_PRC_PARCIAL TYPE BAPISFLDAT-PRICE,
       END OF T_PARCIAL.

TABLES: BAPISFLKEY, BAPISFLDRA.

PARAMETERS: P_TEST   TYPE CHAR1,
            P_STOTAL TYPE CHAR1.

DATA: GT_RETURN  TYPE TABLE OF BAPIRET2,
      WA_RETURN  TYPE BAPIRET2,
      GT_FLYLIST TYPE TABLE OF BAPISFLDAT,
      WA_FLYLIST TYPE BAPISFLDAT.

*-------------------------------------------------------------*
* Select Options
*-------------------------------------------------------------*

PARAMETERS P_ID   TYPE BAPISFLKEY-AIRLINEID.
SELECT-OPTIONS: S_DATE FOR BAPISFLDRA-LOW,
                S_ID FOR BAPISFLKEY-AIRLINEID.

SELECTION-SCREEN BEGIN OF BLOCK TIPO_EXIB WITH FRAME.
PARAMETERS: R1 RADIOBUTTON GROUP RAD DEFAULT 'X',
            R2 RADIOBUTTON GROUP RAD,
            R3 RADIOBUTTON GROUP RAD.
SELECTION-SCREEN END OF BLOCK TIPO_EXIB.


*LOOP AT P_ID.
*  WRITE P_ID. "não vai imprimir tudo, vai imprimir só os registros que tem oq tiver no select
*ENDLOOP.

*-------------------------------------------------------------*
INITIALIZATION.
*-------------------------------------------------------------*
  P_TEST = 'X'.
*---------------------------------------------------------------------*
START-OF-SELECTION.
*---------------------------------------------------------------------*
  PERFORM GET_DADOS_VOO.
*---------------------------------------------------------------------*
END-OF-SELECTION.
*---------------------------------------------------------------------*
  IF R1 = 'X'.
    PERFORM EXIBE_LISTA_VOO.
  ELSEIF R2 = 'X'.
    PERFORM EXIBE_LISTA_VOO_ALV.
  ELSEIF R3 = 'X'.
    PERFORM EXIBE_VIA_SELECT.
  ENDIF.

*---------------------------------------------------------------------*
*Formulários
*---------------------------------------------------------------------*

FORM GET_DADOS_VOO.
  CALL FUNCTION 'BAPI_FLIGHT_GETLIST'
    EXPORTING
      AIRLINE     = P_ID
*     DESTINATION_FROM       =
*     DESTINATION_TO         =
*     MAX_ROWS    =
    TABLES
      DATE_RANGE  = S_DATE
*     EXTENSION_IN           =
      FLIGHT_LIST = GT_FLYLIST
*     EXTENSION_OUT          =
      RETURN      = GT_RETURN.

ENDFORM.

FORM EXIBE_LISTA_VOO.
  DATA: LV_TOTAL     TYPE BAPISFLDAT-PRICE,
        LV_SUB_TOTAL TYPE TABLE OF T_PARCIAL.

  IF P_TEST IS NOT INITIAL.
    FORMAT COLOR COL_HEADING ON.
    WRITE /'Parâmetro "teste" foi preenchido com sucesso.'.
    WRITE /.
    FORMAT COLOR COL_HEADING OFF.
    WRITE SY-ULINE.
  ENDIF.

  LOOP AT GT_FLYLIST INTO WA_FLYLIST.
    WRITE:/ SY-VLINE,
            WA_FLYLIST-AIRLINEID,
            SY-VLINE,
            WA_FLYLIST-AIRLINE,
            SY-VLINE,
            WA_FLYLIST-CONNECTID,
            SY-VLINE,
            WA_FLYLIST-FLIGHTDATE,
            SY-VLINE,
            WA_FLYLIST-AIRPORTFR,
            SY-VLINE,
            WA_FLYLIST-CITYFROM,
            SY-VLINE,
            WA_FLYLIST-AIRPORTTO,
            SY-VLINE,
            WA_FLYLIST-CITYTO,
            SY-VLINE,
            WA_FLYLIST-DEPTIME,
            SY-VLINE,
            WA_FLYLIST-ARRTIME,
            SY-VLINE,
            WA_FLYLIST-ARRDATE,
            SY-VLINE,
            WA_FLYLIST-PRICE,
            SY-VLINE,
            WA_FLYLIST-CURR,
            SY-VLINE,
            WA_FLYLIST-CURR_ISO,
            SY-VLINE.

    LV_TOTAL = LV_TOTAL + WA_FLYLIST-PRICE.

  ENDLOOP.

  IF P_STOTAL IS NOT INITIAL.
    PERFORM CALC_EXIB_SUB.
  ENDIF.


  FORMAT COLOR COL_NEGATIVE ON.
  WRITE: /, SY-ULINE,'Total: USD $', LV_TOTAL, /, SY-ULINE.
  FORMAT COLOR COL_NEGATIVE OFF.


ENDFORM.

FORM EXIBE_LISTA_VOO_ALV.

  CONSTANTS C_TABLE TYPE DD02L-TABNAME VALUE 'BAPISFLDAT'.

  DATA: LT_FIELDCAT TYPE LVC_T_FCAT,
        WA_LAYOUT   TYPE LVC_S_LAYO.

* Ajusta layout
  WA_LAYOUT-ZEBRA      = 'X'.

* Obtém estrutura do report
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      I_STRUCTURE_NAME       = C_TABLE
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.

* Exibe report
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      IS_LAYOUT_LVC   = WA_LAYOUT
      IT_FIELDCAT_LVC = LT_FIELDCAT
    TABLES
      T_OUTTAB        = GT_FLYLIST
    EXCEPTIONS
      PROGRAM_ERROR   = 1
      OTHERS          = 2.


ENDFORM.

FORM CALC_EXIB_SUB.
  WRITE: /,
         SY-ULINE,
         'Sub Totais:',
         /,
         SY-ULINE.

ENDFORM.

FORM EXIBE_VIA_SELECT.
*  DATA LT_SFLIGHTS2 LIKE SFLIGHTS2 OCCURS 0 WITH HEADER LINE.
  DATA LT_SFLIGHTS2 TYPE TABLE OF SFLIGHTS2.

  WRITE: /, 'exibido via select', /.

  SELECT *
    FROM SFLIGHTS2 INTO TABLE LT_SFLIGHTS2
    WHERE CARRID IN S_ID
    AND FLDATE IN S_DATE.

ENDFORM.
