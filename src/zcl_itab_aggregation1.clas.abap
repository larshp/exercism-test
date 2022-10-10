CLASS zcl_itab_aggregation1 DEFINITION
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



CLASS zcl_itab_aggregation1 IMPLEMENTATION.
  METHOD perform_aggregation.
    LOOP AT initial_numbers REFERENCE INTO DATA(lr_initial_numbers)
          GROUP BY ( key   = lr_initial_numbers->group
                     count = GROUP SIZE )
          REFERENCE INTO DATA(group_key).

      APPEND INITIAL LINE TO aggregated_data REFERENCE INTO DATA(lr_aggregated_data).
      lr_aggregated_data->group = group_key->key.
      lr_aggregated_data->count = group_key->count.
      lr_aggregated_data->min = 999999.

      LOOP AT GROUP group_key REFERENCE INTO DATA(lr_item).
        lr_aggregated_data->sum = lr_aggregated_data->sum + lr_item->number.

        lr_aggregated_data->min = nmin( val1 = lr_aggregated_data->min
                                        val2 = lr_item->number ).
        lr_aggregated_data->max = nmax( val1 = lr_aggregated_data->max
                                        val2 = lr_item->number ).
      ENDLOOP.
      lr_aggregated_data->average = lr_aggregated_data->sum / lr_aggregated_data->count.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.