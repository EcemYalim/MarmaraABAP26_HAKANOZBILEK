CLASS zcl_123456789_eml_tcon_process DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_eml_tcon_process IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    lcl_connection_eml=>insert_data( ).
*    lcl_connection_eml=>read_data( ).
    lcl_connection_eml=>update_data( ).
*    lcl_connection_eml=>delete_data( ).

    out->write( 'CRUD operations completed.' ).

  ENDMETHOD.

ENDCLASS.
