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

    aggregated_data =  VALUE aggregated_data( BASE aggregated_data
                                              FOR GROUPS ls_group OF ls_numgrp IN initial_numbers
                                                  GROUP BY ( group = ls_numgrp-group  count = GROUP SIZE )
                                                   ASCENDING
                                            ( REDUCE aggregated_data_type(
                                              INIT ls_agr_data = VALUE aggregated_data_type( )
                                               FOR ls_grp_data IN GROUP ls_group
                                              NEXT ls_agr_data = VALUE #(
                                                                      group = ls_group-group
                                                                      count = ls_group-count
                                                                      sum = REDUCE i( INIT lv_sum = 0
                                                                                       FOR lv_cal_sum IN GROUP ls_group
                                                                                      NEXT lv_sum = lv_sum + lv_cal_sum-number )
                                                                      max = REDUCE i( INIT lv_max = 0
                                                                                       FOR lv_max_num IN GROUP ls_group
                                                                                      NEXT lv_max = nmax( val1 = lv_max
                                                                                                          val2 = lv_max_num-number ) )
                                                                      min = REDUCE i( INIT lv_min = 101
                                                                                       FOR lv_min_num IN GROUP ls_group
                                                                                      NEXT lv_min = nmin( val1 = lv_min
                                                                                                          val2 = lv_min_num-number ) )
                                                                      average = ls_agr_data-sum / ls_agr_data-count
                                                                     )

                                           ) ) ).

  ENDMETHOD.
ENDCLASS.