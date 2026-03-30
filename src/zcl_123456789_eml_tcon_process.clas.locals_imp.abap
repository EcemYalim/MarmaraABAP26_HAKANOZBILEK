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

    DATA: lt_create TYPE TABLE FOR CREATE zr_tcon_123456789.

    lt_create = VALUE #(
        ( %cid        = 'C1'
          Carrid      = 'LH'
          Connid      = '0400'
          AirportFrom = 'FRA'
          CityFrom    = 'Frankfurt'
          CountryFrom = 'DE'
          AirportTo   = 'JFK'
          CityTo      = 'New York'
          CountryTo   = 'US' )

        ( %cid        = 'C2'
          Carrid      = 'TK'
          Connid      = '1923'
          AirportFrom = 'IST'
          CityFrom    = 'Istanbul'
          CountryFrom = 'TR'
          AirportTo   = 'CDG'
          CityTo      = 'Paris'
          CountryTo   = 'FR' )

        ( %cid        = 'C3'
          Carrid      = 'AA'
          Connid      = '0010'
          AirportFrom = 'LHR'
          CityFrom    = 'London'
          CountryFrom = 'GB'
          AirportTo   = 'SFO'
          CityTo      = 'San Francisco'
          CountryTo   = 'US' )
    ).

    MODIFY ENTITIES OF zr_tcon_123456789
      ENTITY ZrTcon123456789
        CREATE FIELDS (
                 Carrid
                 Connid
                 AirportFrom
                 CityFrom
                 CountryFrom
                 AirportTo
                 CityTo
                 CountryTo
               ) WITH lt_create
*      MAPPED   DATA(ls_mapped)
      FAILED   DATA(ls_failed).
*      REPORTED DATA(ls_reported).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.


*--------------------------------------------------
* READ
*--------------------------------------------------
  METHOD read_data.

    DATA read_keys   TYPE TABLE FOR READ IMPORT zr_tcon_123456789.
    DATA connections TYPE TABLE FOR READ RESULT zr_tcon_123456789.

    read_keys = VALUE #( ( uuid = '763C8701C43C1FE18B81EA2062B34DE0' ) ).


    READ ENTITIES OF zr_tcon_123456789
      ENTITY ZrTcon123456789
      ALL FIELDS
      WITH CORRESPONDING #( read_keys  )
      RESULT connections.

  ENDMETHOD.



*--------------------------------------------------
* UPDATE
*--------------------------------------------------
  METHOD update_data.

    DATA lt_update TYPE TABLE FOR UPDATE zr_tcon_123456789.

    SELECT uuid
      FROM ztcon_123456789
      where uuid = '167A341893551FD18AEDB31959984F8C'
      INTO TABLE @DATA(lt_keys)
      UP TO 1 ROWS.

    LOOP AT lt_keys INTO DATA(ls_key).

      lt_update = VALUE #(
        (
          uuid = ls_key-uuid
          CityTo = 'Paris'
          %control-CityTo = if_abap_behv=>mk-on
        )
      ).

    ENDLOOP.

    MODIFY ENTITIES OF zr_tcon_123456789
      ENTITY ZrTcon123456789
      UPDATE FROM lt_update
      FAILED   DATA(ls_failed).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.



*--------------------------------------------------
* DELETE
*--------------------------------------------------
  METHOD delete_data.

    DATA lt_delete TYPE TABLE FOR DELETE zr_tcon_123456789.

    lt_delete = VALUE #( ( uuid = '763C8701C43C1FE18B8156AF50422DE0' ) ).

    MODIFY ENTITIES OF zr_tcon_123456789
      ENTITY ZrTcon123456789
      DELETE FROM lt_delete
      FAILED   DATA(ls_failed).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
