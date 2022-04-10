CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS annotate
        IMPORTING
          !input        TYPE string_table
        RETURNING
          VALUE(result) TYPE string_table.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_minesweeper IMPLEMENTATION.

  METHOD annotate.
    FIELD-SYMBOLS <other_line> TYPE string.
    FIELD-SYMBOLS <current_line> TYPE string.
    result = input.
*   Working from each mine outwards - adding 1 to each adjacent field that is not a mine
    LOOP AT result ASSIGNING <current_line>.
      CHECK <current_line> CA '*'.
      DATA(current_row) = sy-tabix.
*     start one row up
      DO strlen( <current_line> ) TIMES.
        DATA(row) = current_row - 1.
        DATA(current_off) = sy-index - 1.
        CHECK substring( val = <current_line> off = current_off len = 1 ) EQ '*'.
        DO 3 TIMES.
*         for each row, start one character to the left from current
          DATA(off) = current_off - 1.
*         "one row up, same row and one row down - if row exists
          READ TABLE result INDEX row ASSIGNING <other_line>.
          IF sy-subrc EQ 0.
            DO 3 TIMES.
*             except current character
              IF row NE current_row OR off NE current_off.
*               check bounds by catching exception
                TRY.
*                 Expecting to throw exception, when offset out of bounds. 
                    DATA(current_field) = substring( val = <other_line> off = off len = 1 ).                       "<<<<<
                    IF current_field NE '*'.
                      DATA(cn_mines) = CONV i( substring( val = <other_line> off = off len = 1 ) ).                "<<<<<
                      cn_mines = cn_mines + 1.
                      <other_line> = replace( val = <other_line> off = off len = 1 with = |{ cn_mines }| ).        "<<<<<
                    ENDIF.
                  CATCH cx_sy_range_out_of_bounds.
*                  out of bounds - nothing to do
                ENDTRY.
              ENDIF.
              off = off + 1.
            ENDDO.
          ENDIF.
*         row does not exist - try the next
          row = row + 1.
        ENDDO.
      ENDDO.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.