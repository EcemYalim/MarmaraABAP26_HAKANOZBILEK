CLASS zcl_123456789_vehicle_demo_4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_vehicle_demo_4 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA:
      lt_insert TYPE TABLE OF zvhc_123456789.

    DELETE FROM zvhc_123456789.

    DATA lv_ts TYPE timestampl.
    GET TIME STAMP FIELD lv_ts.

*---------------------------------------------------------------------*
* 1. INSERT DATA
*---------------------------------------------------------------------*
    lt_insert = VALUE #(

      ( client = sy-mandt
        id = 1
        type = 'CAR'
        brand = 'BMW'
        model = '320'
        doors = 4
        capacity = 0
        passengers = 0
        engine_cc = 0
        local_created_by = sy-uname
        local_created_at = lv_ts )

      ( client = sy-mandt
        id = 2
        type = 'TRUCK'
        brand = 'Volvo'
        model = 'FH16'
        doors = 0
        capacity = 25
        passengers = 0
        engine_cc = 0
        local_created_by = sy-uname
        local_created_at = lv_ts )

      ( client = sy-mandt
        id = 3
        type = 'BUS'
        brand = 'Mercedes'
        model = 'Tourismo'
        doors = 0
        capacity = 0
        passengers = 50
        engine_cc = 0
        local_created_by = sy-uname
        local_created_at = lv_ts )

      ( client = sy-mandt
        id = 4
        type = 'MOTORCYCLE'
        brand = 'Yamaha'
        model = 'R1'
        doors = 0
        capacity = 0
        passengers = 0
        engine_cc = 1000
        local_created_by = sy-uname
        local_created_at = lv_ts )

    ).

    INSERT zvhc_123456789 FROM TABLE @lt_insert.

    out->write( 'DATA INSERTED' ).

  ENDMETHOD.
ENDCLASS.
