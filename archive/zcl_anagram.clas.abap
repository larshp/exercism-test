CLASS zcl_anagram DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS anagram
      IMPORTING
        input         TYPE string
        candidates    TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_anagram IMPLEMENTATION.

  METHOD anagram.
    LOOP AT candidates INTO DATA(candidate).
      IF strlen( candidate ) = strlen( input ) AND to_upper( candidate ) <> to_upper( input ).
        DATA(str) = candidate.
        DO strlen( input ) TIMES.
          str = COND #( WHEN str CS substring( val = input off = sy-index - 1 len = 1 )
                        THEN        replace(   val = str   off = sy-fdpos     len = 1 with = `` )
                        ELSE `THROW could be used to exit COND gracefully, but its not being accepted` ).
        ENDDO.
        IF str IS INITIAL.
          APPEND candidate TO result.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.