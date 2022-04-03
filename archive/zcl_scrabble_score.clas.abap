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
    DATA: letter(1) TYPE c,
           clen      TYPE i.

    CHECK input IS NOT INITIAL.

    defined_scores = VALUE #( ( letters = 'AEIOULNRST' score = 1 )
                       ( letters = 'DG' score = 2 )
                       ( letters = 'BCMP' score = 3 )
                       ( letters = 'FHVWY' score = 4 )
                       ( letters = 'K' score = 5 )
                       ( letters = 'JX' score = 8 )
                       ( letters = 'QZ' score = 10 ) ).

    "DESCRIBE FIELD input LENGTH DATA(clen) IN CHARACTER MODE.
    clen = strlen( input ).

    DO clen TIMES.
      letter = input+sy-index(1).  "substring( val = input off = sy-index len = 1 ).
      LOOP AT defined_scores INTO DATA(letterscore).
        FIND letter IN letterscore-letters.
        IF sy-subrc EQ 0.
          result = result + letterscore-score.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDDO.

  ENDMETHOD.

ENDCLASS.