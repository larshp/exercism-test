CLASS zcl_hamming DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS hamming_distance
      IMPORTING
        first_strand  TYPE string
        second_strand TYPE string
      RETURNING
        VALUE(result) TYPE i
      RAISING
        cx_parameter_invalid.
ENDCLASS.

CLASS zcl_hamming IMPLEMENTATION.

  METHOD hamming_distance.
    IF strlen( first_strand ) <> strlen( second_strand ).
      RAISE EXCEPTION NEW cx_parameter_invalid( ).
    ENDIF.
    result = COND #(
      WHEN first_strand IS INITIAL AND second_strand IS INITIAL THEN 0
      ELSE REDUCE i( INIT d TYPE i FOR i = 0 UNTIL i = strlen( first_strand )
                     NEXT d += COND #( WHEN first_strand+i(1) <> second_strand+i(1) THEN 1 ) ) ).
  ENDMETHOD.

ENDCLASS.