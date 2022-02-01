class ZCL_ZGATEWAY_MATERIAIS_DPC_EXT definition
  public
  inheriting from ZCL_ZGATEWAY_MATERIAIS_DPC
  create public .

public section.
protected section.

  methods MATERIALSET_CREATE_ENTITY
    redefinition .
  methods MATERIALSET_GET_ENTITY
    redefinition .
  methods MATERIALSET_GET_ENTITYSET
    redefinition .
  methods MATERIALSET_UPDATE_ENTITY
    redefinition .
  methods MATERIALSET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGATEWAY_MATERIAIS_DPC_EXT IMPLEMENTATION.


  METHOD materialset_create_entity.
    DATA: entry_data  LIKE er_entity,
          ls_material TYPE zmateriais.

* Quando você recebe por meio de requisão HTTP,
*uma informação como um registro de tabela, você
*Consegue telo pelo metódgo read_entry_data
    io_data_provider->read_entry_data(
      IMPORTING
        es_data = entry_data
    ).

    MOVE-CORRESPONDING entry_data TO ls_material.

    ls_material-criadopor = sy-uname.
    ls_material-ultimamod = sy-datum.
    ls_material-modificadopor = ''.
    ls_material-mandt = sy-mandt.

    INSERT zmateriais FROM ls_material.

    MOVE-CORRESPONDING ls_material TO er_entity.

  ENDMETHOD.


  METHOD materialset_delete_entity.
    DATA: ls_materiais TYPE zmateriais,
          lv_codmat    TYPE zmateriais-codmat.

    DATA(keys) = io_tech_request_context->get_keys( ).

* Realizar a leitura do campo chave CODMAT,
* da Nossa entidade
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
    WITH KEY name = 'CODMAT'.
    IF <key> IS ASSIGNED.
      lv_codmat = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    DELETE FROM zmateriais
    WHERE codmat = lv_codmat.

    IF sy-subrc IS NOT INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type   = 'E' "Você pode delclarar o typo de erro
        iv_msg_id     = '1' "O Id do typo de erro
        iv_msg_number = '1' "e o número
        iv_msg_v1     = 'Erro ao deletar. Material : ' && lv_codmat && ' é invalido.' ).


*      Excpetion com mensagem
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

  ENDMETHOD.


  method MATERIALSET_GET_ENTITY.
    DATA: ls_materiais  TYPE zmateriais,
          lv_codmat     TYPE zmateriais-codmat.

* recebe a chaves que fora passadas,
* que chegam na classe io_tech_request_context keys
    DATA(keys) = io_tech_request_context->get_keys( ).

* Realizar a leitura do campo chave CODMAT,
* da Nossa entidade
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
    WITH KEY name = 'CODMAT'.
    IF <key> IS ASSIGNED.
      lv_codmat = <key>-value.
    ELSE.
* Caso a requisição HTTP, não tenha passado a chave
* incorreta retorna um erro
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zmateriais
      INTO @ls_materiais
      WHERE CODMAT = @lv_codmat.

    MOVE-CORRESPONDING ls_materiais TO er_entity.
  endmethod.


  METHOD materialset_get_entityset.
    DATA: lt_materiais  TYPE STANDARD TABLE OF zmateriais.

    SELECT *
      FROM zmateriais
      INTO TABLE @lt_materiais.

    MOVE-CORRESPONDING lt_materiais TO et_entityset.
  ENDMETHOD.


  METHOD materialset_update_entity.
    DATA: ls_material TYPE zmateriais,
          lv_codmat   TYPE zmateriais-codmat,
          entry_data  LIKE er_entity.

    DATA(keys) = io_tech_request_context->get_keys( ).

* Realizar a leitura do campo chave CODMAT,
* da Nossa entidade
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
    WITH KEY name = 'CODMAT'.
    IF <key> IS ASSIGNED.
      lv_codmat = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.


* Quando você recebe por meio de requisão HTTP,
*uma informação como um registro de tabela, você
*Consegue telo pelo metódgo read_entry_data
    io_data_provider->read_entry_data(
      IMPORTING
        es_data = entry_data
    ).

    MOVE-CORRESPONDING entry_data TO ls_material.

    ls_material-modificadopor = sy-uname.
    ls_material-ultimamod = sy-datum.

    UPDATE zmateriais
      SET descricao = @ls_material-descricao,
          activate = @ls_material-activate,
          grpmat = @ls_material-grpmat,
          modificadopor = @ls_material-modificadopor,
          ultimamod = @ls_material-ultimamod
      WHERE codmat = @lv_codmat.

    MOVE-CORRESPONDING ls_material TO er_entity.

  endmethod.
ENDCLASS.
