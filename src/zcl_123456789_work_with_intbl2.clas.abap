CLASS zcl_123456789_work_with_intbl2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_work_with_intbl2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF st_airport,
             airportid TYPE /dmo/airport_id,
             name      TYPE /dmo/airport_name,
           END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                          WITH NON-UNIQUE KEY airportid.

    DATA airports TYPE tt_airports.

* Example 1: Structured Variables in SELECT SINGLE ... INTO ...
**********************************************************************
    DATA airport_full TYPE /DMO/I_Airport.
    SELECT SINGLE
      FROM /DMO/I_Airport
    FIELDS AirportID, Name, City, CountryCode
     WHERE City = 'Zurich'
      INTO @airport_full.


* Example 2: Internal Tables in SELECT ... INTO TABLE ...
**********************************************************************
    DATA airports_full TYPE STANDARD TABLE OF /DMO/I_Airport
                            WITH NON-UNIQUE KEY AirportID.

    SELECT
      FROM /DMO/I_Airport
    FIELDS airportid, Name, City, CountryCode
     WHERE City = 'London'
      INTO TABLE @airports_full.


* Example 3: FIELDS * and INTO CORRESPONDING FIELDS OF TABLE
**********************************************************************
    SELECT
      FROM /DMO/I_Airport
    FIELDS *
     WHERE City = 'London'
      INTO CORRESPONDING FIELDS OF TABLE @airports.

* Example 4: Inline Declaration
**********************************************************************
    SELECT
      FROM /DMO/I_airport
    FIELDS AirportID, Name AS AirportName
     WHERE City = 'London'
     INTO TABLE @DATA(airports_inline).

** Example 4: ORDER BY and DISTINCT
***********************************************************************
    SELECT
      FROM /DMO/I_Airport
    FIELDS DISTINCT CountryCode
     ORDER BY CountryCode
     INTO TABLE @DATA(countryCodes).


* Example 5: UNION (ALL)
**********************************************************************
    SELECT FROM /DMO/I_Carrier
           FIELDS 'Airline' AS type, AirlineID AS Id, Name
           WHERE CurrencyCode = 'GBP'

    UNION ALL

    SELECT FROM /DMO/I_Airport
           FIELDS 'Airport' AS type, AirportID AS Id,  Name
           WHERE City = 'London'
    INTO TABLE @DATA(names).

  ENDMETHOD.
ENDCLASS.
