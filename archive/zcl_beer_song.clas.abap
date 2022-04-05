CLASS zcl_beer_song DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS recite
      IMPORTING
        !initial_bottles_count TYPE i
        !take_down_count       TYPE i
      RETURNING
        VALUE(result)          TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_beer_song IMPLEMENTATION.
  METHOD recite.
    DATA(i) = initial_bottles_count.
    WHILE i GT initial_bottles_count - take_down_count AND i > 0.
      IF i = 1.
        APPEND LINES OF VALUE string_table(
        ( |1 bottle of beer on the wall, 1 bottle of beer.| )
        ( |Take it down and pass it around, no more bottles of beer on the wall.| ) ( ) )
        TO result.
      ELSE.
        APPEND LINES OF VALUE string_table(
         ( condense( |{ i } bottles of beer on the wall, { i } bottles of beer.| ) )
         ( condense( |Take one down and pass it around, { i - 1 } {
          COND #( WHEN i = 2 THEN `bottle` ELSE `bottles` ) } of beer on the wall.| ) ) ( ) )
        TO result.
      ENDIF.
      i -= 1.
    ENDWHILE.
    IF i = 0 AND initial_bottles_count <> take_down_count.
      APPEND LINES OF VALUE string_table(
      ( |No more bottles of beer on the wall, no more bottles of beer.| )
      ( |Go to the store and buy some more, 99 bottles of beer on the wall.| ) )
      TO result.
    ELSE.
      DELETE result INDEX lines( result ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.