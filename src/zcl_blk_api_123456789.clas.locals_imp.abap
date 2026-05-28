*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zcl_auth_types_123456789 DEFINITION.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_auth_response,
        token TYPE string,
      END OF ty_auth_response.

ENDCLASS.

CLASS zcl_auth_types_123456789 IMPLEMENTATION.
ENDCLASS.

CLASS zcl_order_types_123456789 DEFINITION.
  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_order,
        user_code    TYPE string,
        order_no     TYPE string,
        order_desc   TYPE string,
        material_no  TYPE string,
        quantity     TYPE i,
        unit         TYPE string,
        price        TYPE decfloat34,
        currency     TYPE string,
        total_amount TYPE decfloat34,
      END OF ty_order.

    TYPES tt_order TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.

ENDCLASS.

CLASS zcl_http_client_123456789 DEFINITION.

  PUBLIC SECTION.

    METHODS:
      get_token
        IMPORTING
          iv_usercode     TYPE string
          iv_password     TYPE string
        RETURNING
          VALUE(rv_token) TYPE string,

      get_orders
        IMPORTING
          iv_usercode      TYPE string
          iv_token         TYPE string
          iv_skip          TYPE i
          iv_top           TYPE i
        RETURNING
          VALUE(rt_orders)
            TYPE zcl_order_types_123456789=>tt_order.

ENDCLASS.


CLASS zcl_http_client_123456789 IMPLEMENTATION.

  METHOD get_token.

    TRY.
        DATA(lo_destination) =
          cl_http_destination_provider=>create_by_url(
            'https://hakanozbilek.com'
          ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(lo_client) =
          cl_web_http_client_manager=>create_by_http_destination(
            lo_destination ).
      CATCH cx_root.
    ENDTRY.

    DATA(lo_request) = lo_client->get_http_request( ).

    lo_request->set_uri_path( '/api/auth/login' ).

    lo_request->set_header_field(
      i_name  = 'Content-Type'
      i_value = 'application/json'
    ).

    DATA(lv_body) = '{ "UserCode":"' && iv_usercode && '","password":" ' && iv_password && '" }'.

    lo_request->set_text( lv_body ).


    TRY.
        DATA(lo_response) =
          lo_client->execute(
            if_web_http_client=>post ).
      CATCH cx_root.
    ENDTRY.

    DATA(lv_json) =
      lo_response->get_text( ).

    DATA ls_auth TYPE zcl_auth_types_123456789=>ty_auth_response.

    /ui2/cl_json=>deserialize(
      EXPORTING json = lv_json
      CHANGING data = ls_auth ).

    rv_token = ls_auth-token.

  ENDMETHOD.


  METHOD get_orders.

    TRY.
        DATA(lo_destination) =
          cl_http_destination_provider=>create_by_url(
            'https://hakanozbilek.com'
          ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(lo_client) =
          cl_web_http_client_manager=>create_by_http_destination(
            lo_destination ).
      CATCH cx_root.
    ENDTRY.

    DATA(lo_request) =
      lo_client->get_http_request( ).

    lo_request->set_uri_path(
      |/api/orders/{ iv_usercode }?skip={ iv_skip }&top={ iv_top }|
    ).

    lo_request->set_header_field(
      i_name  = 'Authorization'
      i_value = |Bearer { iv_token }|
    ).

    TRY.
        DATA(lo_response) =
          lo_client->execute(
            if_web_http_client=>get ).
      CATCH cx_root.
    ENDTRY.

    DATA(lv_json) =
      lo_response->get_text( ).

    DATA lt_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_mapping = VALUE #(
      ( abap = 'USER_CODE'    json = 'userCode' )
      ( abap = 'ORDER_NO'     json = 'orderNo' )
      ( abap = 'ORDER_DESC'   json = 'orderDesc' )
      ( abap = 'MATERIAL_NO'  json = 'materialNo' )
      ( abap = 'TOTAL_AMOUNT' json = 'totalAmount' )
    ).

    /ui2/cl_json=>deserialize(
      EXPORTING
          json          = lv_json
          name_mappings = lt_mapping
      CHANGING
          data          = rt_orders ).

    DELETE rt_orders WHERE user_code IS INITIAL OR order_no IS INITIAL.

  ENDMETHOD.

ENDCLASS.



CLASS zcl_order_service_123456789 DEFINITION.

  PUBLIC SECTION.

    METHODS sync_orders.

ENDCLASS.

CLASS zcl_order_service_123456789 IMPLEMENTATION.

  METHOD sync_orders.

    DATA(lo_client) =
      NEW zcl_http_client_123456789( ).

    DATA(lv_token) =
      lo_client->get_token(
        iv_usercode = '170422012'
        iv_password = '123456'
      ).

    DATA(lv_skip) = 0.
    DATA(lv_top)  = 10.

    DO.

      DATA(lt_orders) =
        lo_client->get_orders(
          iv_usercode = '170422012'
          iv_token    = lv_token
          iv_skip     = lv_skip
          iv_top      = lv_top ).

      IF lt_orders[] IS INITIAL.
        EXIT.
      ENDIF.

      DATA lt_insert TYPE STANDARD TABLE OF zblk_123456789.

      TRY.
          lt_insert = VALUE #(
            FOR ls_order IN lt_orders
            (
              uuid         = cl_system_uuid=>create_uuid_x16_static( )
              user_code   = ls_order-user_code
              order_no    = ls_order-order_no
              order_desc  = ls_order-order_desc
              material_no = ls_order-material_no
              quantity    = ls_order-quantity
              unit        = ls_order-unit
              price       = ls_order-price
              currency    = ls_order-currency
              total_amount = ls_order-total_amount
            )
          ).

          MODIFY zblk_123456789
          FROM TABLE @lt_insert.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.

          lv_skip = lv_skip + 10.

        CATCH cx_root.
      ENDTRY.

    ENDDO.

  ENDMETHOD.

ENDCLASS.

