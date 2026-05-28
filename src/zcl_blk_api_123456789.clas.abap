CLASS zcl_blk_api_123456789 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BLK_API_123456789 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zblk_123456789.
    COMMIT WORK.

    NEW zcl_order_service_123456789(
    )->sync_orders( ).

    out->write( 'Program finished' ).

  ENDMETHOD.
ENDCLASS.
