CLASS zcl_scrabble_score DEFINITION PUBLIC .

  PUBLIC SECTION.
    METHODS: score
               IMPORTING input         TYPE string OPTIONAL
               RETURNING VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_scores,
             letters(10)    TYPE c,
             score          TYPE i,
           END  OF ty_scores.
    DATA: defined_scores TYPE STANDARD TABLE OF ty_scores.
    DATA: def_score  TYPE ty_scores.

ENDCLASS.

CLASS zcl_scrabble_score IMPLEMENTATION.

  METHOD score.

    DATA(word) = to_upper( input ).
    result  = ( count_any_of( val = word  sub = `AEIOULNRST` ) * 1 ).
    result += ( count_any_of( val = word  sub = `DG`         ) * 2 ).
    result += ( count_any_of( val = word  sub = `BCMP`       ) * 3 ).
    result += ( count_any_of( val = word  sub = `FHVWY`      ) * 4 ).
    result += ( count_any_of( val = word  sub = `K`          ) * 5 ).
    result += ( count_any_of( val = word  sub = `JX`         ) * 8 ).
    result += ( count_any_of( val = word  sub = `QZ`         ) * 10 ).

  ENDMETHOD.

ENDCLASS.