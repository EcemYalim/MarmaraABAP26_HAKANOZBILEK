CLASS zcl_123456789_rest_client_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS gc_base_url TYPE string VALUE 'https://petstore.swagger.io/v2'.

    DATA mv_bearer_token TYPE string.

    METHODS:
      run_demo
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out,

      create_http_client
        IMPORTING
          iv_url           TYPE string
        RETURNING
          VALUE(ro_client) TYPE REF TO if_web_http_client,

      execute_request
        IMPORTING
          iv_method      TYPE string
          iv_url         TYPE string
          iv_body        TYPE string OPTIONAL
          iv_contenttype TYPE string DEFAULT 'application/json'
          iv_bearer      TYPE string OPTIONAL
        RETURNING
          VALUE(rv_text) TYPE string,

      add_auth_header
        IMPORTING
          io_request TYPE REF TO if_web_http_request
          iv_bearer  TYPE string OPTIONAL,

      build_user_json
        IMPORTING
          iv_id          TYPE i
          iv_username    TYPE string
          iv_firstname   TYPE string
          iv_lastname    TYPE string
          iv_email       TYPE string
          iv_password    TYPE string
          iv_phone       TYPE string
          iv_status      TYPE i
        RETURNING
          VALUE(rv_json) TYPE string,

      build_pet_json
        IMPORTING
          iv_id          TYPE i
          iv_name        TYPE string
          iv_status      TYPE string
          iv_cat_id      TYPE i
          iv_cat_name    TYPE string
        RETURNING
          VALUE(rv_json) TYPE string,

      build_order_json
        IMPORTING
          iv_id          TYPE i
          iv_pet_id      TYPE i
          iv_quantity    TYPE i
          iv_status      TYPE string
          iv_complete    TYPE abap_bool
        RETURNING
          VALUE(rv_json) TYPE string.
ENDCLASS.



CLASS zcl_123456789_rest_client_01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    run_demo( io_out = out ).
  ENDMETHOD.

  METHOD run_demo.
    DATA lv_text TYPE string.

    "---------------------------------------------
    " 1) USER CREATE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'POST'
      iv_url    = gc_base_url && '/user'
      iv_body   = build_user_json(
                    iv_id        = 1001
                    iv_username  = 'hakan_demo'
                    iv_firstname = 'Hakan'
                    iv_lastname  = 'blk'
                    iv_email     = 'hakan.demo@example.com'
                    iv_password  = 'Abc12345!'
                    iv_phone     = '5550001111'
                    iv_status    = 1 ) ).
    io_out->write( |CREATE USER => { lv_text }| ).

    "---------------------------------------------
    " 2) LOGIN
    "    Petstore demo login typically returns a token-like text.
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'GET'
      iv_url    = gc_base_url && '/user/login?username=hakan_demo&password=Abc12345!' ).
    mv_bearer_token = lv_text.
    io_out->write( |LOGIN => { lv_text }| ).

    "---------------------------------------------
    " 3) GET USER
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'GET'
      iv_url    = gc_base_url && '/user/hakan_demo'
      iv_bearer = mv_bearer_token ).
    io_out->write( |GET USER => { lv_text }| ).

    "---------------------------------------------
    " 4) UPDATE USER
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'PUT'
      iv_url    = gc_base_url && '/user/hakan_demo'
      iv_body   = build_user_json(
                    iv_id        = 1001
                    iv_username  = 'hakan_demo'
                    iv_firstname = 'HakanUpdated'
                    iv_lastname  = 'blk'
                    iv_email     = 'hakan.updated@example.com'
                    iv_password  = 'Abc12345!'
                    iv_phone     = '5559998888'
                    iv_status    = 1 )
      iv_bearer = mv_bearer_token ).
    io_out->write( |UPDATE USER => { lv_text }| ).

    "---------------------------------------------
    " 5) PET CREATE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'POST'
      iv_url    = gc_base_url && '/pet'
      iv_body   = build_pet_json(
                    iv_id       = 2001
                    iv_name     = 'Karabas'
                    iv_status   = 'available'
                    iv_cat_id   = 1
                    iv_cat_name = 'dog' )
      iv_bearer = mv_bearer_token ).
    io_out->write( |CREATE PET => { lv_text }| ).

    "---------------------------------------------
    " 6) PET READ
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'GET'
      iv_url    = gc_base_url && '/pet/2001'
      iv_bearer = mv_bearer_token ).
    io_out->write( |GET PET => { lv_text }| ).

    "---------------------------------------------
    " 7) PET UPDATE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'PUT'
      iv_url    = gc_base_url && '/pet'
      iv_body   = build_pet_json(
                    iv_id       = 2001
                    iv_name     = 'KarabasUpdated'
                    iv_status   = 'pending'
                    iv_cat_id   = 1
                    iv_cat_name = 'dog' )
      iv_bearer = mv_bearer_token ).
    io_out->write( |UPDATE PET => { lv_text }| ).

    "---------------------------------------------
    " 8) STORE ORDER CREATE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'POST'
      iv_url    = gc_base_url && '/store/order'
      iv_body   = build_order_json(
                    iv_id       = 3001
                    iv_pet_id   = 2001
                    iv_quantity = 1
                    iv_status   = 'placed'
                    iv_complete = abap_true )
      iv_bearer = mv_bearer_token ).
    io_out->write( |CREATE ORDER => { lv_text }| ).

    "---------------------------------------------
    " 9) STORE ORDER READ
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'GET'
      iv_url    = gc_base_url && '/store/order/3001'
      iv_bearer = mv_bearer_token ).
    io_out->write( |GET ORDER => { lv_text }| ).

    "---------------------------------------------
    " 10) PET DELETE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'DELETE'
      iv_url    = gc_base_url && '/pet/2001'
      iv_bearer = mv_bearer_token ).
    io_out->write( |DELETE PET => { lv_text }| ).

    "---------------------------------------------
    " 11) ORDER DELETE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'DELETE'
      iv_url    = gc_base_url && '/store/order/3001'
      iv_bearer = mv_bearer_token ).
    io_out->write( |DELETE ORDER => { lv_text }| ).

    "---------------------------------------------
    " 12) USER DELETE
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'DELETE'
      iv_url    = gc_base_url && '/user/hakan_demo'
      iv_bearer = mv_bearer_token ).
    io_out->write( |DELETE USER => { lv_text }| ).

    "---------------------------------------------
    " 13) LOGOUT
    "---------------------------------------------
    lv_text = execute_request(
      iv_method = 'GET'
      iv_url    = gc_base_url && '/user/logout' ).
    io_out->write( |LOGOUT => { lv_text }| ).

  ENDMETHOD.

  METHOD create_http_client.
    ro_client = cl_web_http_client_manager=>create_by_http_destination(
                  cl_http_destination_provider=>create_by_url( i_url = iv_url ) ).
  ENDMETHOD.

  METHOD add_auth_header.
    IF iv_bearer IS NOT INITIAL.
      io_request->set_header_field(
        i_name  = 'Authorization'
        i_value = |Bearer { iv_bearer }| ).
    ENDIF.
  ENDMETHOD.

  METHOD execute_request.
    TRY.
        DATA(lo_client) = create_http_client( iv_url = iv_url ).
        DATA(lo_request) = lo_client->get_http_request( ).

        lo_request->set_header_field(
          i_name  = 'Content-Type'
          i_value = iv_contenttype ).

        add_auth_header(
          io_request = lo_request
          iv_bearer  = iv_bearer ).

        IF iv_body IS NOT INITIAL.
          lo_request->set_text( iv_body ).
        ENDIF.

        DATA(lo_response) = lo_client->execute(
                              i_method = COND #( WHEN iv_method = 'GET'    THEN if_web_http_client=>get
                                                 WHEN iv_method = 'POST'   THEN if_web_http_client=>post
                                                 WHEN iv_method = 'PUT'    THEN if_web_http_client=>put
                                                 WHEN iv_method = 'DELETE' THEN if_web_http_client=>delete
                                                 WHEN iv_method = 'PATCH'  THEN if_web_http_client=>patch
                                                 ELSE if_web_http_client=>get ) ).

        DATA(ls_status) = lo_response->get_status( ).
        rv_text = |HTTP { ls_status-code } { ls_status-reason } | &&
                  |{ lo_response->get_text( ) }|.

      CATCH cx_web_http_client_error INTO DATA(lx_http).
        rv_text = lx_http->get_text( ).
      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        rv_text = lx_dest->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD build_user_json.

    rv_json =
      '{' &&
      '"id": ' && iv_id && ',' &&
      '"username": "' && iv_username && '",' &&
      '"firstName": "' && iv_firstname && '",' &&
      '"lastName": "' && iv_lastname && '",' &&
      '"email": "' && iv_email && '",' &&
      '"password": "' && iv_password && '",' &&
      '"phone": "' && iv_phone && '",' &&
      '"userStatus": ' && iv_status &&
      '}'.

  ENDMETHOD.

  METHOD build_pet_json.

    rv_json =
      '{' &&
      '"id": ' && iv_id && ',' &&
      '"category": {' &&
          '"id": ' && iv_cat_id && ',' &&
          '"name": "' && iv_cat_name && '"' &&
      '},' &&
      '"name": "' && iv_name && '",' &&
      '"photoUrls": ["string"],' &&
      '"tags": [{"id": 1, "name": "friendly"}],' &&
      '"status": "' && iv_status && '"' &&
      '}'.

  ENDMETHOD.

  METHOD build_order_json.

    DATA lv_complete TYPE string.

    lv_complete = COND string(
                    WHEN iv_complete = abap_true THEN 'true'
                    ELSE 'false' ).

    rv_json =
      '{' &&
      '"id": ' && iv_id && ',' &&
      '"petId": ' && iv_pet_id && ',' &&
      '"quantity": ' && iv_quantity && ',' &&
      '"shipDate": "2026-04-17T15:25:46.310Z",' &&
      '"status": "' && iv_status && '",' &&
      '"complete": ' && lv_complete &&
      '}'.

  ENDMETHOD.
ENDCLASS.
