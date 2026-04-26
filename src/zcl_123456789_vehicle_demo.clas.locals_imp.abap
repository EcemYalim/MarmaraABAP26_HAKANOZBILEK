*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zcl_vehicle DEFINITION
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_brand TYPE string
          iv_model TYPE string,

      get_description
        RETURNING VALUE(rv_desc) TYPE string,

      get_type
        RETURNING VALUE(rv_type) TYPE string.

  PROTECTED SECTION.
    DATA mv_brand TYPE string.
    DATA mv_model TYPE string.

ENDCLASS.

CLASS zcl_vehicle IMPLEMENTATION.

  METHOD constructor.
    mv_brand = iv_brand.
    mv_model = iv_model.
  ENDMETHOD.

  METHOD get_description.
    rv_desc = |Vehicle { mv_brand } { mv_model }|.
  ENDMETHOD.

  METHOD get_type.
    rv_type = 'VEHICLE'.
  ENDMETHOD.

ENDCLASS.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

CLASS zcl_car DEFINITION
  INHERITING FROM zcl_vehicle.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          iv_brand TYPE string
          iv_model TYPE string
          iv_doors TYPE i,

      get_description REDEFINITION,
      get_type REDEFINITION.

  PRIVATE SECTION.
    DATA mv_doors TYPE i.

ENDCLASS.


CLASS zcl_car IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_brand = iv_brand iv_model = iv_model ).
    mv_doors = iv_doors.
  ENDMETHOD.

  METHOD get_description.
    RETURN |Car { mv_brand } { mv_model } - Doors: { mv_doors }|.
  ENDMETHOD.

  METHOD get_type.
    RETURN 'CAR'.
  ENDMETHOD.

ENDCLASS.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

CLASS zcl_truck DEFINITION
  INHERITING FROM zcl_vehicle.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          iv_brand    TYPE string
          iv_model    TYPE string
          iv_capacity TYPE i,

      get_description REDEFINITION,
      get_type REDEFINITION.

  PRIVATE SECTION.
    DATA mv_capacity TYPE i.

ENDCLASS.


CLASS zcl_truck IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_brand = iv_brand iv_model = iv_model ).
    mv_capacity = iv_capacity.
  ENDMETHOD.

  METHOD get_description.
    RETURN |Truck { mv_brand } { mv_model } - Capacity: { mv_capacity }|.
  ENDMETHOD.

  METHOD get_type.
    RETURN 'TRUCK'.
  ENDMETHOD.

ENDCLASS.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


CLASS zcl_bus DEFINITION
  INHERITING FROM zcl_vehicle.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_brand      TYPE string
          iv_model      TYPE string
          iv_passengers TYPE i,

      get_description REDEFINITION,
      get_type REDEFINITION.

  PRIVATE SECTION.
    DATA mv_passengers TYPE i.

ENDCLASS.


CLASS zcl_bus IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_brand = iv_brand iv_model = iv_model ).
    mv_passengers = iv_passengers.
  ENDMETHOD.

  METHOD get_description.
    RETURN |Bus { mv_brand } { mv_model } - Passengers: { mv_passengers }|.
  ENDMETHOD.

  METHOD get_type.
    RETURN 'BUS'.
  ENDMETHOD.

ENDCLASS.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


CLASS zcl_motorcycle DEFINITION
  INHERITING FROM zcl_vehicle.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_brand     TYPE string
          iv_model     TYPE string
          iv_engine_cc TYPE i,

      get_description REDEFINITION,
      get_type REDEFINITION.

  PRIVATE SECTION.
    DATA mv_engine_cc TYPE i.

ENDCLASS.


CLASS zcl_motorcycle IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_brand = iv_brand iv_model = iv_model ).
    mv_engine_cc = iv_engine_cc.
  ENDMETHOD.

  METHOD get_description.
    RETURN |Motorcycle { mv_brand } { mv_model } - Engine: { mv_engine_cc }cc|.
  ENDMETHOD.

  METHOD get_type.
    RETURN 'MOTORCYCLE'.
  ENDMETHOD.

ENDCLASS.
