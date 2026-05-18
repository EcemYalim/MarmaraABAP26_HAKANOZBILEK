*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

INTERFACE i_rest_client.
  TYPES:
    BEGIN OF ty_user,
      id         TYPE string,
      username   TYPE string,
      firstname  TYPE string,
      lastname   TYPE string,
      email      TYPE string,
      password   TYPE string,
      phone      TYPE string,
      userstatus TYPE i,
    END OF ty_user.
ENDINTERFACE.


*--------------------------------------------------------------------*
CLASS lcl_rest_client DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS:
      get_user_from_rest
        IMPORTING
          iv_username    TYPE string
        RETURNING
          VALUE(rs_user) TYPE i_rest_client=>ty_user.

  PRIVATE SECTION.
    DATA mo_out TYPE REF TO if_oo_adt_classrun_out.

    CONSTANTS gc_base_url TYPE string VALUE
      'https://petstore.swagger.io/v2'.

ENDCLASS.

*--------------------------------------------------------------------*
* LOCAL CLASS - EML SERVICE
*--------------------------------------------------------------------*
CLASS lcl_eml_service DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS:
      save_user
        IMPORTING
          is_user TYPE i_rest_client=>ty_user.

  PRIVATE SECTION.
    DATA mo_out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.

*--------------------------------------------------------------------*
* IMPLEMENTATION - REST CLIENT
*--------------------------------------------------------------------*
CLASS lcl_rest_client IMPLEMENTATION.

  METHOD constructor.
    mo_out = io_out.
  ENDMETHOD.

  METHOD get_user_from_rest.

    TRY.

        DATA(lo_client) =
          cl_web_http_client_manager=>create_by_http_destination(
            cl_http_destination_provider=>create_by_url(
              gc_base_url &&
              '/user/' &&
              iv_username ) ).

        DATA(lo_response) =
          lo_client->execute(
            if_web_http_client=>get ).

        DATA(lv_json) =
          lo_response->get_text( ).

        /ui2/cl_json=>deserialize(
          EXPORTING
            json = lv_json
          CHANGING
            data = rs_user ).

      CATCH cx_root INTO DATA(lx).

        mo_out->write(
          |REST ERROR: { lx->get_text( ) }| ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
* IMPLEMENTATION - EML SERVICE
*--------------------------------------------------------------------*
CLASS lcl_eml_service IMPLEMENTATION.

  METHOD constructor.
    mo_out = io_out.
  ENDMETHOD.

  METHOD save_user.

    MODIFY ENTITIES OF zr_usr_123456789
      ENTITY ZrUsr123456789

      CREATE FIELDS (
        id
        username
        firstname
        lastname
        email
        password
        phone
        userstatus
      )

      WITH VALUE #(
        (
          %cid       = 'USER001'
          id         = is_user-id
          username   = is_user-username
          firstname  = is_user-firstname
          lastname   = is_user-lastname
          email      = is_user-email
          password   = is_user-password
          phone      = is_user-phone
          userstatus = is_user-userstatus
        )
      )

      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported)
      MAPPED DATA(lt_mapped).

    IF lt_failed IS INITIAL.

      COMMIT ENTITIES.

      mo_out->write(
        'EML INSERT SUCCESSFUL' ).

    ELSE.

      mo_out->write(
        'EML INSERT FAILED' ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
