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

    LOOP AT initial_numbers INTO DATA(number)
        GROUP BY number-group
        ASSIGNING FIELD-SYMBOL(<group>).

      DATA(group_members) = VALUE initial_numbers( FOR member IN GROUP <group> ( member ) ).

      aggregated_data = VALUE #( BASE aggregated_data
                               ( group = group_members[ 1 ]-group
                                 count = lines( group_members )
                                 sum = REDUCE i( INIT s = 0 FOR g IN group_members NEXT s = s + g-number )
                                 min = REDUCE i( INIT min = 1000000 FOR g IN group_members NEXT min = COND #( WHEN g-number < min THEN g-number ELSE min ) )
                                 max = REDUCE i( INIT max = 0 FOR g IN group_members NEXT max = COND #( WHEN g-number > max THEN g-number ELSE max ) )
                                 average = REDUCE i( INIT s = 0 FOR g IN group_members NEXT s = s + g-number ) / lines( group_members )
                                 ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.