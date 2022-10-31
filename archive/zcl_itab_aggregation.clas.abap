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
    " add solution here
    aggregated_data = VALUE #(
      FOR GROUPS grp OF rec IN initial_numbers
      GROUP BY ( group = rec-group cnt = GROUP SIZE )
      LET res = REDUCE aggregated_data_type( INIT tmp = VALUE aggregated_data_type( min = initial_numbers[ group = grp-group ]-number )
                FOR rec2 IN GROUP grp
                NEXT tmp-sum = tmp-sum + rec2-number
                   tmp-min = COND #( WHEN tmp-min > rec2-number THEN rec2-number ELSE tmp-min )
                   tmp-max = COND #( WHEN tmp-max < rec2-number THEN rec2-number ELSE tmp-max )
                ) IN
                ( group = grp-group
                  count = grp-cnt
                  sum = res-sum
                  min = res-min
                  max = res-max
                  average = res-sum / grp-cnt )
      ).

  ENDMETHOD.

ENDCLASS.