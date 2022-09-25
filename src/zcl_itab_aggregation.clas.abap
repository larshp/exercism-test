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

    LOOP AT initial_numbers ASSIGNING FIELD-SYMBOL(<fs_ini_numbers>).
      IF line_exists( aggregated_data[ group = <fs_ini_numbers>-group ] ).
        aggregated_data[ group = <fs_ini_numbers>-group ]-count = aggregated_data[ group = <fs_ini_numbers>-group ]-count + 1.
        aggregated_data[ group = <fs_ini_numbers>-group ]-sum = aggregated_data[ group =
            <fs_ini_numbers>-group ]-sum + <fs_ini_numbers>-number.
        aggregated_data[ group = <fs_ini_numbers>-group ]-min = COND #(
          WHEN <fs_ini_numbers>-number < aggregated_data[ group = <fs_ini_numbers>-group ]-min 
          THEN <fs_ini_numbers>-number
          ELSE aggregated_data[ group = <fs_ini_numbers>-group ]-min
          ).
        aggregated_data[ group = <fs_ini_numbers>-group ]-max = COND #(
          WHEN <fs_ini_numbers>-number > aggregated_data[ group = <fs_ini_numbers>-group ]-max 
          THEN <fs_ini_numbers>-number
          ELSE aggregated_data[ group = <fs_ini_numbers>-group ]-max
          ).
      ELSE.
        INSERT VALUE #(
          group = <fs_ini_numbers>-group
          count = 1
          sum = <fs_ini_numbers>-number
          min = <fs_ini_numbers>-number
          max = <fs_ini_numbers>-number
        ) INTO TABLE aggregated_data.
      ENDIF.
    ENDLOOP.
    LOOP AT aggregated_data ASSIGNING FIELD-SYMBOL(<fs_agg_data>).
      <fs_agg_data>-average = <fs_agg_data>-sum / <fs_agg_data>-count.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.