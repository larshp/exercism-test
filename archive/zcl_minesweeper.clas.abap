CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: ty_char1 TYPE c LENGTH 1.

    METHODS annotate
      IMPORTING
        !input        TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.

    METHODS one_if_cell_is_a_star
      IMPORTING
        !row          TYPE i
        !column       TYPE i
      RETURNING
        VALUE(result) TYPE i.

    METHODS read_cell
      IMPORTING
        !row          TYPE i
        !column       TYPE i
      RETURNING
        VALUE(result) TYPE string.

    METHODS change_cell
      IMPORTING
        !row    TYPE i
        !column TYPE i
        !value  TYPE ty_char1.

    DATA: input TYPE string_table.

ENDCLASS.

CLASS zcl_minesweeper IMPLEMENTATION.

  METHOD annotate.
    TYPES: ty_integers TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    me->input = input.

    TRY.

        DATA(rows) = VALUE ty_integers( FOR i = 1 WHILE i <= lines( input ) ( i ) ).
        DATA(count_columns) = strlen( input[ 1 ] ).
        DATA(columns) = VALUE ty_integers( FOR j = 1 WHILE j <= count_columns ( j ) ).

        LOOP AT rows INTO DATA(row).
          LOOP AT columns INTO DATA(column).
            IF read_cell( row = row column = column ) = ` `.
              DATA(count_adjacent_mines) = one_if_cell_is_a_star( row = row - 1 column = column - 1 )
                                         + one_if_cell_is_a_star( row = row - 1 column = column )
                                         + one_if_cell_is_a_star( row = row - 1 column = column + 1 )
                                         + one_if_cell_is_a_star( row = row     column = column - 1 )
                                         + one_if_cell_is_a_star( row = row     column = column + 1 )
                                         + one_if_cell_is_a_star( row = row + 1 column = column - 1 )
                                         + one_if_cell_is_a_star( row = row + 1 column = column )
                                         + one_if_cell_is_a_star( row = row + 1 column = column + 1 ).
              IF count_adjacent_mines > 0.
                change_cell( row = row column = column value = |{ count_adjacent_mines }| ).
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDLOOP.

      CATCH cx_root INTO DATA(error).
        " invalid grid
        ASSERT 1 = 1. " debug helper
    ENDTRY.

    result = me->input.

  ENDMETHOD.

  METHOD one_if_cell_is_a_star.

    IF read_cell( row = row column = column ) = '*'.
      result = 1.
    ELSE.
      result = 0.
    ENDIF.

  ENDMETHOD.

  METHOD read_cell.

    IF row < 1 OR row > lines( input )
        OR column < 1 OR column > strlen( input[ row ] ).
      result = ` `.
    ELSE.
      result = substring( val = input[ row ] off = column - 1 len = 1 ).
    ENDIF.

  ENDMETHOD.

  METHOD change_cell.

    ASSIGN input[ row ] TO FIELD-SYMBOL(<line>).
    <line> = substring( val = <line> len = column - 1 )
          && value
          && substring( val = <line> off = column len = strlen( <line> ) - column ).

  ENDMETHOD.

ENDCLASS.