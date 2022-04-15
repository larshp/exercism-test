CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS annotate
      IMPORTING
        !input        TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.
ENDCLASS.

CLASS zcl_minesweeper IMPLEMENTATION.
  METHOD annotate.
    LOOP AT input INTO DATA(input_row).
      DATA(output_row) = ``.
      DO strlen( input_row ) TIMES.
        DATA(input_char) = substring( val = input_row off = sy-index - 1 len = 1 ).
        IF input_char = ` `.
          DATA(mines_found) = 0.
          DATA(current_char_row) = sy-tabix.
          DATA(current_char_pos) = sy-index - 1.
          DO 3 TIMES. "Iterate => Upper row then current row then row below
            DATA(row_pos) = current_char_row + sy-index - 2.
            DO 3 TIMES. "Iterate => Left character position then center then right
              DATA(char_pos) = current_char_pos + sy-index - 2.
              TRY .
                  DATA(content) = input[ row_pos ].
                  mines_found += COND #( WHEN content+char_pos(1) = '*' THEN 1 ).
                CATCH cx_root.
              ENDTRY.
            ENDDO.
          ENDDO.
          DATA(output_char) = COND #( WHEN mines_found > 0
                                      THEN condense( CONV string( mines_found ) ) ).
        ELSE.
          output_char = input_char.
        ENDIF.
        output_row = |{ output_row }{ COND #( WHEN output_char IS INITIAL THEN ` `
                                              ELSE output_char ) }|.
      ENDDO.
      APPEND output_row TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.