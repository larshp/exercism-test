CLASS zcl_kindergarten_garden DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS plants
      IMPORTING
        diagram        TYPE string
        student        TYPE string
      RETURNING
        VALUE(results) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA students TYPE string_table.

    METHODS get_plant_name
      IMPORTING code              TYPE c
      RETURNING VALUE(plant_name) TYPE string.
    DATA gv_code TYPE c.
    DATA gv_students TYPE string_table.
    DATA gv_plant_amount TYPE i.
ENDCLASS.


CLASS zcl_kindergarten_garden IMPLEMENTATION.
  METHOD constructor.
    gv_students = VALUE #( ( |Alice| ) ( |Bob| ) ( |Charlie| ) ( |David| ) ( |Eve| ) ( |Fred| )
                    ( |Ginny| ) ( |Harriet| ) ( |Ileana| ) ( |Joseph| ) ( |Kincaid| ) ( |Larry| ) ).
    gv_plant_amount = 2.
  ENDMETHOD.

  METHOD get_plant_name.
    gv_code = code.
    TRANSLATE gv_code TO UPPER CASE.
    plant_name = SWITCH #( gv_code WHEN 'V' THEN 'violets'
                                WHEN 'R' THEN 'radishes'
                                WHEN 'C' THEN 'clover'
                                WHEN 'G' THEN 'grass'
                          ).
  ENDMETHOD.

  METHOD plants.
    SPLIT diagram AT '\n' INTO TABLE DATA(window_rows).
    DATA(offset) = ( line_index( gv_students[ table_line = student ] ) - 1 ) * 2.
    results = REDUCE string_table( INIT s = VALUE string_table( )
                                   FOR r IN window_rows
                                   FOR p = 0 WHILE p < gv_plant_amount
                                   NEXT s = VALUE string_table(
                                          BASE s
                                          ( get_plant_name( substring( val = r off = offset + p len = 1 ) ) )
                                  )
              ).

  ENDMETHOD.
ENDCLASS.