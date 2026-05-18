CLASS zcl_123456789_oo_per_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_oo_per_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    lcl_person_eml=>insert_data( ).

    out->write( 'Personel eklendi!' ).

  ENDMETHOD.
ENDCLASS.
