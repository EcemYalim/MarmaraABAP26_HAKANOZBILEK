*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


INTERFACE zif_shipping_option.

  TYPES:
    BEGIN OF ty_request,
      destination_country    TYPE string,
      weight_kg              TYPE p LENGTH 8 DECIMALS 2,
      distance_km            TYPE i,
      fragile                TYPE abap_bool,
      temperature_controlled TYPE abap_bool,
    END OF ty_request.

  TYPES ty_fee TYPE p LENGTH 8 DECIMALS 2.


  METHODS calculate_fee
    IMPORTING
      is_request    TYPE ty_request
    RETURNING
      VALUE(rv_fee) TYPE ty_fee.

  METHODS get_code
    RETURNING
      VALUE(rv_code) TYPE string.

  METHODS get_name
    RETURNING
      VALUE(rv_name) TYPE string.

ENDINTERFACE.


CLASS zcl_shipping_ground DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_shipping_option.
ENDCLASS.

CLASS zcl_shipping_ground IMPLEMENTATION.

  METHOD zif_shipping_option~calculate_fee.
    rv_fee = 25 + ( is_request-weight_kg * 4 ).

    IF is_request-distance_km > 500.
      rv_fee = rv_fee + 10.
    ENDIF.

    IF is_request-fragile = abap_true.
      rv_fee = rv_fee + 8.
    ENDIF.
  ENDMETHOD.

  METHOD zif_shipping_option~get_code.
    rv_code = 'GROUND'.
  ENDMETHOD.

  METHOD zif_shipping_option~get_name.
    rv_name = 'Ground Shipping'.
  ENDMETHOD.

ENDCLASS.


CLASS zcl_shipping_express DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_shipping_option.
ENDCLASS.

CLASS zcl_shipping_express IMPLEMENTATION.

  METHOD zif_shipping_option~calculate_fee.

    rv_fee = 45 + ( is_request-weight_kg * 6 ).

    IF is_request-distance_km > 500.
      rv_fee = rv_fee + 15.
    ENDIF.

    IF is_request-fragile = abap_true.
      rv_fee = rv_fee + 12.
    ENDIF.

    IF is_request-temperature_controlled = abap_true.
      rv_fee = rv_fee + 5.
    ENDIF.
  ENDMETHOD.

  METHOD zif_shipping_option~get_code.
    rv_code = 'EXPRESS'.
  ENDMETHOD.

  METHOD zif_shipping_option~get_name.
    rv_name = 'Express Shipping'.
  ENDMETHOD.

ENDCLASS.


CLASS zcl_shipping_cold DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_shipping_option.
ENDCLASS.

CLASS zcl_shipping_cold IMPLEMENTATION.

  METHOD zif_shipping_option~calculate_fee.

    rv_fee = 60 + ( is_request-weight_kg * 5 ).

    IF is_request-distance_km > 500.
      rv_fee = rv_fee + 12.
    ENDIF.

    IF is_request-fragile = abap_true.
      rv_fee = rv_fee + 15.
    ENDIF.

    IF is_request-temperature_controlled = abap_true.
      rv_fee = rv_fee + 20.
    ELSE.
      rv_fee = rv_fee + 35.
    ENDIF.
  ENDMETHOD.

  METHOD zif_shipping_option~get_code.
    rv_code = 'COLD'.
  ENDMETHOD.

  METHOD zif_shipping_option~get_name.
    rv_name = 'Cold Chain Shipping'.
  ENDMETHOD.

ENDCLASS.
