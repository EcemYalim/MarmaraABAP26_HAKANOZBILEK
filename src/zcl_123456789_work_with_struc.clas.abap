CLASS zcl_123456789_work_with_struc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_123456789_work_with_struc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF st_connection,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.

    TYPES: BEGIN OF st_connection_short,
             DepartureAirport   TYPE /dmo/airport_from_id,
             DestinationAirport TYPE /dmo/airport_to_id,
           END OF st_connection_short.

    TYPES: BEGIN OF st_connection_multi,
             airport_from_id    TYPE /dmo/airport_from_id,
             airport_to_id      TYPE /dmo/airport_to_id,
             carrier_name       TYPE /dmo/carrier_name,
             DepartureAirport   TYPE /dmo/airport_from_id,
             DestinationAirport TYPE /dmo/airport_to_id,
           END OF st_connection_multi.

    DATA: connection       TYPE st_connection,
          connection_short TYPE st_connection_short,
          connection_multi TYPE st_connection_multi.

    DATA connection_full TYPE /DMO/I_Connection.
* Example 1: Correspondence between FIELDS and INTO
**********************************************************************
    SELECT SINGLE
       FROM /DMO/I_Connection
     FIELDS DepartureAirport, DestinationAirport, \_Airline-Name
      WHERE AirlineID = 'LH'
        AND ConnectionID = '0400'
       INTO @connection.

* Example 2: FIELDS *
**********************************************************************
    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS *
     WHERE AirlineID = 'LH'
       AND ConnectionID = '0400'
      INTO @connection_full.

* Example 3: INTO CORRESPONDING FIELDS
**********************************************************************
    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS *
     WHERE AirlineID    = 'LH'
       AND ConnectionID = '0400'
      INTO CORRESPONDING FIELDS OF @connection_short.


* Example 4: Alias Names for Fields
**********************************************************************

    CLEAR connection.

    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport AS airport_from_id,
           \_Airline-Name   AS carrier_name
     WHERE AirlineID    = 'LH'
       AND ConnectionID = '0400'
      INTO CORRESPONDING FIELDS OF @connection.


* Example 5: Inline Declaration
**********************************************************************
    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport,
           DestinationAirport AS ArrivalAirport,
           \_Airline-Name     AS carrier_name
     WHERE AirlineID    = 'LH'
       AND ConnectionID = '0400'
      INTO @DATA(connection_inline).

* Example 6: Joins
**********************************************************************
    SELECT SINGLE
      FROM (  /dmo/connection AS c
      LEFT OUTER JOIN /dmo/airport AS f
        ON c~airport_from_id = f~airport_id )
      LEFT OUTER JOIN /dmo/airport AS t
        ON c~airport_to_id = t~airport_id
    FIELDS c~airport_from_id, c~airport_to_id,
           f~name AS airport_from_name, t~name AS airport_to_name
     WHERE c~carrier_id    = 'LH'
       AND c~connection_id = '0400'
      INTO @DATA(connection_join).


* Example 7: Corresponding
**********************************************************************
    connection_multi = CORRESPONDING #( connection ).
    connection_multi-DepartureAirport   = connection_short-DepartureAirport.
    connection_multi-DestinationAirport = connection_short-DestinationAirport.

  ENDMETHOD.
ENDCLASS.
