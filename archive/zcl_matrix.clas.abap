CLASS zcl_matrix DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS matrix_row
      IMPORTING
        string        TYPE string
        index         TYPE i
      RETURNING
        VALUE(result) TYPE integertab.
    METHODS matrix_column
      IMPORTING
        string        TYPE string
        index         TYPE i
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS build_matrix
      IMPORTING
        i_string   TYPE string
      EXPORTING
        ev_columns TYPE i
        ev_rows TYPE i
        et_matrix  TYPE string_table.

ENDCLASS.

CLASS zcl_matrix IMPLEMENTATION.
  METHOD build_matrix.
    DATA(lv_string_wo_nl) = replace( val = i_string sub = `\n` with = ` ` occ = 0 ).
    ev_rows = count( val = i_string sub = `\n` ) + 1.
    ev_columns  = COND i( LET lv_qty_values =
                             count( val = lv_string_wo_nl sub = ` `
                             len = COND i( LET lv_pos_nl = find( val = i_string sub = `\n` ) IN
                                           WHEN lv_pos_nl <= 0 THEN strlen( i_string )
                                           ELSE lv_pos_nl + 1 ) ) IN

                          WHEN lv_qty_values <= 0 THEN 1 ELSE lv_qty_values ) .
    SPLIT lv_string_wo_nl AT ` ` INTO TABLE et_matrix .
  ENDMETHOD.

  METHOD matrix_row.
    build_matrix(
          EXPORTING
            i_string = string
          IMPORTING
            ev_columns = DATA(lv_columns)
            et_matrix  = DATA(lt_matrix) ).

    result = VALUE #( LET lv_start = ( index - 1 ) * lv_columns + 1 IN
                      FOR i = lv_start UNTIL i > lv_start + lv_columns - 1 ( lt_matrix[ i ] ) ).
  ENDMETHOD.

  METHOD matrix_column.
    build_matrix(
          EXPORTING
            i_string = string
          IMPORTING
            ev_rows = DATA(lv_rows)
            ev_columns = DATA(lv_colums)
            et_matrix  = DATA(lt_matrix) ).

    result = VALUE #( FOR i = 0 UNTIL i = lv_rows ( lt_matrix[ index + i * lv_colums ] ) ).
  ENDMETHOD.
ENDCLASS.