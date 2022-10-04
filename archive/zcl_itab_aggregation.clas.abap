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
    if lines( initial_numbers ) gt 0.
      data(last_grp) = ' '.
      data(zwerg) = value aggregated_data_type( min = 200 ).
      data(sorted) = initial_numbers.
      sort sorted by group.
      else.
        return.
      endif.
      loop at value initial_numbers( base sorted ( group = ' ' ) )
          assigning field-symbol(<grp>).
          if <grp>-group ne last_grp and last_grp ne space.
             zwerg-group = last_grp.
             zwerg-average = zwerg-sum / zwerg-count.
             append zwerg to aggregated_data.
             zwerg = value #( min = 200 ).
          endif.
           last_grp = <grp>-group.
           zwerg-sum =  zwerg-sum + <grp>-number.
           zwerg-count = zwerg-count + 1.
           zwerg-min = nmin( val1 = zwerg-min val2 = <grp>-number ).
           zwerg-max = nmax( val1 = zwerg-max val2 = <grp>-number ).
      endloop.

  ENDMETHOD.

ENDCLASS.