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

    LOOP AT initial_numbers REFERENCE INTO DATA(initial_number).
      TRY.
          DATA(aggregated) = REF #( aggregated_data[ group = initial_number->group ] ).

        CATCH cx_sy_itab_line_not_found.
          INSERT INITIAL LINE INTO TABLE aggregated_data REFERENCE INTO aggregated.
          aggregated->group = initial_number->group.
          aggregated->min = initial_number->number.
          aggregated->max = initial_number->number.
          aggregated->average = initial_number->number.
      ENDTRY.

      aggregated->count = aggregated->count + 1.
      aggregated->sum = aggregated->sum + initial_number->number.
      aggregated->min = COND #( WHEN initial_number->number < aggregated->min
                                  THEN initial_number->number
                                ELSE aggregated->min ).

      aggregated->max = COND #( WHEN initial_number->number > aggregated->max
                                  THEN initial_number->number
                                ELSE aggregated->max ).

      CLEAR aggregated.
    ENDLOOP.

    LOOP AT aggregated_data REFERENCE INTO aggregated.
      aggregated->average = aggregated->sum / aggregated->count.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.