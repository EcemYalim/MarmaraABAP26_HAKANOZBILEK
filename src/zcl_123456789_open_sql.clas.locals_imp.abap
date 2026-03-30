*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


*"* use this source file for the definition and implementation of
*"* local helper classes

CLASS lcl_connection_eml DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      insert_data,
      read_data,
      update_data,
      delete_data.

ENDCLASS.



CLASS lcl_connection_eml IMPLEMENTATION.
*--------------------------------------------------
* INSERT
*--------------------------------------------------
  METHOD insert_data.
    DATA: lt_insert TYPE TABLE OF ztcon_123456789.

    lt_insert = VALUE #(
        ( carrid      = 'LH'
          connid      = '0400'
          airport_from = 'FRA'
          city_from    = 'Frankfurt'
          country_from = 'DE'
          airport_to   = 'JFK'
          city_to      = 'New York'
          country_to   = 'US' ) ).

    INSERT ztcon_123456789 FROM TABLE @lt_insert.

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


*--------------------------------------------------
* READ
*--------------------------------------------------
  METHOD read_data.
    DATA: lt_result TYPE TABLE OF ztcon_123456789.

    SELECT *
      FROM ztcon_123456789
      WHERE uuid = '763C8701C43C1FE18B81EA2062B34DE0'
      INTO TABLE @lt_result.

  ENDMETHOD.



*--------------------------------------------------
* UPDATE
*--------------------------------------------------
  METHOD update_data.

    DATA: lt_update TYPE TABLE OF ztcon_123456789.

    lt_update = VALUE #(
        ( uuid     = '167A341893551FD18AEDB31959984F8C'
          city_to   = 'Paris'
          country_to = 'FR' ) ).

    UPDATE ztcon_123456789 FROM TABLE @lt_update.

*    UPDATE ztcon_123456789
*       SET city_to = 'Paris'
*     WHERE uuid = '167A341893551FD18AEDB31959984F8C'.

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.



*--------------------------------------------------
* DELETE
*--------------------------------------------------
  METHOD delete_data.
    DATA: lt_delete TYPE TABLE OF ztcon_123456789.

    lt_delete = VALUE #( ( uuid = '763C8701C43C1FE18B8156AF50422DE0' ) ).

    DELETE ztcon_123456789 FROM TABLE @lt_delete.

*    DELETE FROM ztcon_123456789 WHERE uuid = '763C8701C43C1FE18B8156AF50422DE0'.

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
