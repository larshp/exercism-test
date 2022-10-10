CLASS zcl_itab_aggregation2 DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.

    TYPES:
      BEGIN OF initial_numbers_type,
        group       TYPE group,
        number      TYPE i,
      END OF initial_numbers_type,
      initial_numbers TYPE STANDARD TABLE OF initial_numbers_type
        WITH EMPTY KEY.

    TYPES:
      BEGIN OF aggregated_data_type,
        group   TYPE group,
        count   TYPE i,
        sum     TYPE i,
        min     TYPE i,
        max     TYPE i,
        average TYPE f,
      END OF aggregated_data_type,
      aggregated_data TYPE STANDARD TABLE OF aggregated_data_type
        WITH EMPTY KEY.

    METHODS:
      perform_aggregation
        IMPORTING
          initial_numbers        TYPE initial_numbers
        RETURNING
          VALUE(aggregated_data) TYPE aggregated_data.
ENDCLASS.

CLASS zcl_itab_aggregation2 IMPLEMENTATION.

  METHOD perform_aggregation.
    DATA:
      lv_row_count       TYPE i,
      lv_current_group   TYPE group VALUE space,
      lr_initial_numbers TYPE REF TO initial_numbers_type,
      wa_initial_numbers TYPE initial_numbers_type,
      wa_aggregated_data TYPE aggregated_data_type.

    lv_row_count = lines( initial_numbers ).

    CASE lv_row_count.
      WHEN 0.
        aggregated_data = VALUE #( ).
      WHEN 1.
        READ TABLE initial_numbers INDEX 1 INTO wa_initial_numbers.
        IF sy-subrc = 0.
          wa_aggregated_data-group = wa_initial_numbers-group.
          wa_aggregated_data-count = 1.
          wa_aggregated_data-sum = wa_initial_numbers-number.
          wa_aggregated_data-min = wa_initial_numbers-number.
          wa_aggregated_data-max = wa_initial_numbers-number.
          wa_aggregated_data-average =
            wa_aggregated_data-sum / wa_aggregated_data-count.
          APPEND wa_aggregated_data TO aggregated_data.
          CLEAR wa_aggregated_data.
        ELSE.
          aggregated_data = VALUE #( ).
        ENDIF.
      WHEN OTHERS.
        " Sort table ascending on GROUP field
        SORT initial_numbers BY group ASCENDING.
        " Initialize flags
        lv_current_group = space.
        " Read multi-line table
        LOOP AT initial_numbers REFERENCE INTO lr_initial_numbers.
          IF lr_initial_numbers->group NE lv_current_group.
            " Group change occurred ...
            IF lv_current_group NE space.
              " Skip write on initial record
              wa_aggregated_data-average =
                wa_aggregated_data-sum / wa_aggregated_data-count.
              APPEND wa_aggregated_data TO aggregated_data.
              CLEAR wa_aggregated_data.
            ENDIF.
            " Initialize new group
            lv_current_group = lr_initial_numbers->group.
            wa_aggregated_data-group = lr_initial_numbers->group.
            wa_aggregated_data-count = 1.
            wa_aggregated_data-sum = lr_initial_numbers->number.
            wa_aggregated_data-min = lr_initial_numbers->number.
            wa_aggregated_data-max = lr_initial_numbers->number.
          ELSE.
            " Same group, simply accumulate values
            wa_aggregated_data-count = wa_aggregated_data-count + 1.
            wa_aggregated_data-sum =
              wa_aggregated_data-sum + lr_initial_numbers->number.
            IF wa_aggregated_data-min GT lr_initial_numbers->number.
              wa_aggregated_data-min = lr_initial_numbers->number.
            ENDIF.
            IF wa_aggregated_data-max LT lr_initial_numbers->number.
              wa_aggregated_data-max = lr_initial_numbers->number.
            ENDIF.
          ENDIF.
        ENDLOOP.
        " Ensure final record is written
        wa_aggregated_data-average = wa_aggregated_data-sum / wa_aggregated_data-count.
        APPEND wa_aggregated_data TO aggregated_data.
        CLEAR wa_aggregated_data.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.