CLASS zcl_beer_song DEFINITION PUBLIC
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
    METHODS verse
      IMPORTING
                !i_number       TYPE i
      RETURNING VALUE(r_result) TYPE string_table.

    METHODS bottle_phrase
      IMPORTING
        !i_number              TYPE i
        !big_initial           TYPE clike DEFAULT ' '
      RETURNING VALUE(r_result) TYPE string.
ENDCLASS.



CLASS zcl_beer_song IMPLEMENTATION.

  METHOD recite.
    DATA last_wall_bottle TYPE i.
    last_wall_bottle = initial_bottles_count - take_down_count.
    result = VALUE #(
                        FOR i = initial_bottles_count THEN i - 1 WHILE i GT last_wall_bottle
                        ( LINES OF verse( i_number = i ) )
                        ( || )
                     ).
    DELETE result INDEX lines(  result ).
  ENDMETHOD.


  METHOD verse.
    APPEND |{ bottle_phrase( i_number = i_number big_initial = 'X' ) } on the wall, { bottle_phrase( i_number ) }.| TO r_result.
    IF i_number GE 2.
      APPEND |Take one down and pass it around, { bottle_phrase( i_number - 1 ) } on the wall.| TO r_result.
    ELSEIF i_number EQ 1.
      APPEND |Take it down and pass it around, { bottle_phrase( 0 ) } on the wall.| TO r_result.
    ELSE.
      APPEND |Go to the store and buy some more, { bottle_phrase( 99 ) } on the wall.| TO r_result.
    ENDIF.
  ENDMETHOD.


  METHOD bottle_phrase.

    r_result = |{ SWITCH string( i_number
                         WHEN 0 THEN |{ SWITCH #( big_initial WHEN 'X' THEN `No` ELSE `no` ) } more bottles|
                         WHEN 1 THEN |1 bottle|
                         ELSE |{ i_number } bottles|
                  ) } of beer|.

  ENDMETHOD.

ENDCLASS.