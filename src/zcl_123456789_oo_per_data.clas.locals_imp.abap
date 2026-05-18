*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_person_eml DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      insert_data.

ENDCLASS.



CLASS lcl_person_eml IMPLEMENTATION.

  METHOD insert_data.

    DATA lt_create TYPE TABLE FOR CREATE zr_per_123456789.

    lt_create = VALUE #(
      (
        %cid      = 'P1'
        uname     = 'AAYDIN'
        firstname = 'Ali'
        lastname  = 'Aydın'
        birthdate = '19900101'
      )
      (
        %cid      = 'P2'
        uname     = 'SYILMAZ'
        firstname = 'Sinan'
        lastname  = 'Yilmaz'
        birthdate = '19850512'
      )
      (
        %cid      = 'P3'
        uname     = 'AKAYA'
        firstname = 'Ayse'
        lastname  = 'Kaya'
        birthdate = '19951230'
      )
    ).

    MODIFY ENTITIES OF zr_per_123456789
      ENTITY ZrPer123456789
        CREATE FIELDS (
          Uname
          Firstname
          Lastname
          Birthdate
        ) WITH lt_create
        FAILED DATA(ls_failed).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


