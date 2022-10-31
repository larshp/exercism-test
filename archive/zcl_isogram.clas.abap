CLASS zcl_isogram DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS is_isogram
      IMPORTING
        VALUE(phrase)        TYPE string
      RETURNING
        VALUE(result) TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_isogram IMPLEMENTATION.

  METHOD is_isogram.
    result = abap_true.
    phrase = to_lower( phrase ).

    DO strlen( phrase ) TIMES.
      DATA(letter) = phrase(1).
      phrase = shift_left( val = phrase places = 1 ).
      
      IF letter EQ space
      OR letter EQ '-'.
        CONTINUE.
      ENDIF.

      IF find( val = phrase sub = letter ) GT 0.
        result = abap_false.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.