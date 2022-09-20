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

    LOOP AT initial_numbers ASSIGNING FIELD-SYMBOL(<number>)
    GROUP BY ( group = <number>-group
               count = GROUP SIZE )
    ASSIGNING FIELD-SYMBOL(<groups>).

      INSERT VALUE #( group = <groups>-group
count = <groups>-count
) INTO TABLE aggregated_data REFERENCE INTO DATA(aggregated_data_row).

      LOOP AT GROUP <groups> ASSIGNING FIELD-SYMBOL(<group>).
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.