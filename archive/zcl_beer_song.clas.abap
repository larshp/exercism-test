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


    result = VALUE string_table(
      FOR i = 0 UNTIL i = take_down_count
      (
         COND string(
         LET current_count = initial_bottles_count - i
             new_count = current_count - 1
          IN
          WHEN current_count = 1 THEN |{ current_count } bottle of beer on the wall, { current_count } bottle of beer.|
          WHEN new_count <= 0 THEN |No more bottles of beer on the wall, no more bottles of beer.|
          ELSE  |{ current_count } bottles of beer on the wall, { current_count } bottles of beer.|
          )
      )
      (
         COND string(
         LET current_count = initial_bottles_count - i
             new_count = current_count - 1
          IN
          WHEN current_count = 2 THEN |Take one down and pass it around, 1 bottle of beer on the wall.|
          WHEN current_count = 1 THEN |Take it down and pass it around, no more bottles of beer on the wall.|
          WHEN new_count <= 0 THEN |Go to the store and buy some more, 99 bottles of beer on the wall.|
          ELSE |Take one down and pass it around, { new_count } bottles of beer on the wall.|
          )
      )
      ( ||
      )
    ).
    DELETE result INDEX lines( result ).

  ENDMETHOD.
ENDCLASS.