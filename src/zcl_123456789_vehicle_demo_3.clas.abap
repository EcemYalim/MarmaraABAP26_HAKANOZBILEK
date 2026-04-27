CLASS zcl_123456789_vehicle_demo_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_vehicle_demo_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_create TYPE TABLE FOR CREATE zr_vhc_123456789.

    lt_create = VALUE #(

      ( %cid = 'V1'
        id = 1
        type = 'CAR'
        brand = 'BMW'
        model = '320'
        doors = 4
        capacity = 0
        passengers = 0
        enginecc = 0 )

      ( %cid = 'V2'
        id = 2
        type = 'TRUCK'
        brand = 'Volvo'
        model = 'FH16'
        doors = 0
        capacity = 25
        passengers = 0
        enginecc = 0 )

      ( %cid = 'V3'
        id = 3
        type = 'BUS'
        brand = 'Mercedes'
        model = 'Tourismo'
        doors = 0
        capacity = 0
        passengers = 50
        enginecc = 0 )

      ( %cid = 'V4'
        id = 4
        type = 'MOTORCYCLE'
        brand = 'Yamaha'
        model = 'R1'
        doors = 0
        capacity = 0
        passengers = 0
        enginecc = 1000 )

    ).

    MODIFY ENTITIES OF zr_vhc_123456789
      ENTITY ZrVhc123456789
        CREATE FIELDS (
          id
          type
          brand
          model
          doors
          capacity
          passengers
          enginecc
        )
        WITH lt_create
      FAILED DATA(ls_failed).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
