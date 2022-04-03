CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS annotate
      IMPORTING
        !input        TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.
  PRIVATE SECTION.
    DATA: input_tab TYPE string_table.
    METHODS mine_found IMPORTING row           TYPE i
                                 offset        TYPE i
                       RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS zcl_minesweeper IMPLEMENTATION.
  METHOD annotate.
    input_tab = input.
    LOOP AT input INTO DATA(input_row).
      DATA(output_row) = ``.
      DO strlen( input_row ) TIMES.
        DATA(input_char) = substring( val = input_row off = sy-index - 1 len = 1 ).
        IF input_char = ` `.
          DATA(mines_found) = REDUCE i( INIT m TYPE i
                                      FOR  i  = sy-tabix - 1 UNTIL i = sy-tabix + 2
                                      FOR  j  = sy-index - 2 UNTIL j = sy-index + 1
                                      NEXT m += COND #( WHEN mine_found( row = i offset = j ) THEN 1 ) ).
          DATA(output_char) = COND char1( WHEN mines_found > 0
                                          THEN condense( CONV string( mines_found ) ) ).
        ELSE.
          output_char = input_char.
        ENDIF.
        output_row = |{ output_row }{ COND #( WHEN output_char IS INITIAL THEN ` ` ELSE output_char ) }|.
      ENDDO.
      APPEND output_row TO result.
    ENDLOOP.
  ENDMETHOD.
  METHOD mine_found.
    TRY .
        result = xsdbool( substring( val = VALUE #( input_tab[ row ] ) off = offset len = 1 ) = `*` ).
      CATCH cx_sy_itab_line_not_found  cx_sy_range_out_of_bounds.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.