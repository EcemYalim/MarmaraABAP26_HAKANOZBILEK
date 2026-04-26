CLASS zcl_123456789_vehicle_demo_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_vehicle_demo_2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lo_vehicle TYPE REF TO zcl_vehicle.

    SELECT SINGLE *
         FROM ztvhc_123456789
         WHERE id = '1'
         INTO @DATA(ls_data).

    CASE ls_data-type.

      WHEN 'CAR'.
        lo_vehicle  = NEW zcl_car(
           iv_brand = CONV #( ls_data-brand )
           iv_model = CONV #( ls_data-model )
           iv_doors = ls_data-doors ).

      WHEN 'TRUCK'.
        lo_vehicle = NEW zcl_truck(
          iv_brand = CONV #( ls_data-brand )
          iv_model = CONV #( ls_data-model )
          iv_capacity = ls_data-capacity ).

      WHEN 'BUS'.
        lo_vehicle = NEW zcl_bus(
          iv_brand = CONV #( ls_data-brand )
          iv_model = CONV #( ls_data-model )
          iv_passengers = ls_data-passengers ).

      WHEN 'MOTORCYCLE'.
        lo_vehicle = NEW zcl_motorcycle(
          iv_brand = CONV #( ls_data-brand )
          iv_model = CONV #( ls_data-model )
          iv_engine_cc = ls_data-engine_cc ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
