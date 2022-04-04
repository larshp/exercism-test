CLASS zcl_kindergarten_garden DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS plants
      IMPORTING
        diagram        TYPE string
        student        TYPE string
      RETURNING
        VALUE(results) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA students TYPE string_table.
ENDCLASS.
CLASS zcl_kindergarten_garden IMPLEMENTATION.
  METHOD plants.
    SPLIT diagram AT `\n` INTO TABLE DATA(lt_plants).
    DATA(lv_first_pos) = COND i( WHEN sy-abcde CS student+0(1) THEN sy-fdpos * 2 ).
    DO 2 TIMES.
      APPEND LINES OF VALUE string_table(
        FOR i = 0 UNTIL i = 2 (
         SWITCH #( substring( val = lt_plants[ sy-index ] off = lv_first_pos + i len = 1 )
          WHEN 'C' THEN 'clover'
          WHEN 'G' THEN 'grass'
          WHEN 'R' THEN 'radishes'
          WHEN 'V' THEN 'violets' ) ) ) TO results.
    ENDDO.
  ENDMETHOD.
ENDCLASS.