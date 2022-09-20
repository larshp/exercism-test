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

    DATA icount TYPE i.
    TYPES: BEGIN OF group_type,
             group TYPE group,
             size  TYPE i,
           END OF group_type,
           group_types TYPE STANDARD TABLE OF group_type WITH EMPTY KEY.
    DATA temp_numbers TYPE initial_numbers.
    temp_numbers[] = initial_numbers[].
    SORT temp_numbers BY group ASCENDING.
    DATA last_group TYPE c.
    DATA group_numbers TYPE group_types.
    LOOP AT temp_numbers INTO DATA(initial_number).
      IF last_group <> initial_number-group.
        APPEND INITIAL LINE TO group_numbers  ASSIGNING FIELD-SYMBOL(<group_number>).
        <group_number>-group = initial_number-group.
        <group_number>-size = 1.
      ELSE.
        <group_number>-size += 1.
      ENDIF.
      last_group = initial_number-group.
    ENDLOOP.

    LOOP AT group_numbers INTO DATA(group_number).
      APPEND INITIAL LINE TO aggregated_data ASSIGNING FIELD-SYMBOL(<aggregated_data>).
      <aggregated_data>-group = group_number-group.
      <aggregated_data>-count = group_number-size.
      icount = 0.
      LOOP AT temp_numbers INTO DATA(ls_member) WHERE group = group_number-group.
        <aggregated_data>-sum += ls_member-number.
        IF icount = 0.
          <aggregated_data>-min = <aggregated_data>-max = ls_member-number.
        ELSE.
          <aggregated_data>-min = COND i( WHEN ls_member-number < <aggregated_data>-min THEN ls_member-number ELSE <aggregated_data>-min ).
          <aggregated_data>-max = COND i( WHEN ls_member-number > <aggregated_data>-max THEN ls_member-number ELSE <aggregated_data>-max ).
        ENDIF.
        icount += 1.
      ENDLOOP.
      <aggregated_data>-average = <aggregated_data>-sum / <aggregated_data>-count.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.