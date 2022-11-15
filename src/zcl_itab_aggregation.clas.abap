CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.

    aggregated_data = REDUCE aggregated_data(
      INIT aggregated = VALUE aggregated_data( )
           data = VALUE aggregated_data_type( )
      FOR GROUPS <group_key> OF <wa> IN initial_numbers
        GROUP BY <wa>-group ASCENDING
      NEXT data = VALUE #(
             group = <group_key>
             count = REDUCE i( INIT count = 0
                     FOR m IN GROUP <group_key>
                     NEXT count += 1 )
             sum = REDUCE i( INIT sum = 0
                     FOR m IN GROUP <group_key>
                     NEXT sum += m-number )
             max = REDUCE i( INIT max = 0
                     FOR m IN GROUP <group_key>
                     NEXT max = nmax( val1 = max
                                      val2 = m-number ) )
             min = REDUCE i( INIT min = 1000000000
                     FOR m IN GROUP <group_key>
                     NEXT min = nmin( val1 = min
                                      val2 = m-number ) )
             average = data-sum / data-count )
           aggregated = VALUE #( BASE aggregated ( data ) ) ).

  ENDMETHOD.

ENDCLASS.