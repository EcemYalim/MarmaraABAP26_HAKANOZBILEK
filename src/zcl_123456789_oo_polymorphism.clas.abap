CLASS zcl_123456789_oo_polymorphism DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_123456789_oo_polymorphism IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TYPES:
      BEGIN OF ty_quote,
        option_code TYPE string,
        option_name TYPE string,
        fee         TYPE zif_shipping_option=>ty_fee,
      END OF ty_quote.

    DATA lt_quotes TYPE STANDARD TABLE OF ty_quote WITH EMPTY KEY.

    " 1. Talep Verisi (Request)
    DATA(ls_request) = VALUE zif_shipping_option=>ty_request(
      destination_country    = 'TR'
      weight_kg              = '12.50'
      distance_km            = 540
      fragile                = abap_true
      temperature_controlled = abap_true
    ).

    " 2. Ortak bir liste üzerinde farklı nesneleri topluyoruz.
    DATA lt_shipping_options TYPE STANDARD TABLE OF REF TO zif_shipping_option.

    lt_shipping_options = VALUE #(
      ( NEW zcl_shipping_ground( ) )
      ( NEW zcl_shipping_express( ) )
      ( NEW zcl_shipping_cold( ) )
    ).

    " 3. Döngü dönerken lo_option hangi nesneye (Ground, Express, Cold) aitse
    " arka planda otomatik olarak onun hesaplama metodunu çağırır.
    LOOP AT lt_shipping_options INTO DATA(lo_option).
      APPEND VALUE ty_quote(
        option_code = lo_option->get_code( )
        option_name = lo_option->get_name( )
        fee         = lo_option->calculate_fee( ls_request )
      ) TO lt_quotes.
    ENDLOOP.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    LOOP AT lt_quotes INTO DATA(ls_quote).
      out->write( |{ ls_quote-option_code } / { ls_quote-option_name } / Fee : { ls_quote-fee }| ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
