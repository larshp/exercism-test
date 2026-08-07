CLASS zcl_rle DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS encode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

    METHODS decode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.
    TYPES:
      type_e_letter TYPE c LENGTH 1,
      type_t_letter TYPE STANDARD TABLE OF type_e_letter
                    WITH NON-UNIQUE DEFAULT KEY.

    METHODS:
      _split_in_letters
        IMPORTING
          input            TYPE string
        RETURNING
          VALUE(rt_letter) TYPE type_t_letter.

ENDCLASS.

CLASS zcl_rle IMPLEMENTATION.
  METHOD encode.
    LOOP AT _split_in_letters( input ) ASSIGNING FIELD-SYMBOL(<lv_letter>).
      AT NEW table_line.
        DATA(lv_count) = 0.
      ENDAT.
      lv_count = lv_count + 1.
      AT END OF table_line.
        DATA(lv_encoded) = COND string( WHEN lv_count = 1
                                        THEN |{ <lv_letter> WIDTH = 1 }|
                                        ELSE |{ lv_count }{ <lv_letter> WIDTH = 1 }| ).
        result = result && lv_encoded.
      ENDAT.
    ENDLOOP.
  ENDMETHOD.

  METHOD decode.
    DATA(lv_offset) = 0.
    WHILE lv_offset < strlen( input ).
      DATA(lv_decode) = ||.
      FIND REGEX '(^\d+)(\D)' IN input+lv_offset IGNORING CASE
        MATCH OFFSET DATA(lv_match_offset) MATCH LENGTH DATA(lv_match_length)
        SUBMATCHES DATA(lv_repeat) DATA(lv_letter).
      IF sy-subrc = 0.
        DO CONV i( lv_repeat ) TIMES.
          lv_decode = |{ lv_decode }{ lv_letter }|.
        ENDDO.
        result = |{ result }{ lv_decode }|.
        lv_offset = lv_offset + lv_match_offset + lv_match_length.
        CONTINUE.
      ENDIF.
      result = |{ result }{ input+lv_offset(1) }|.
      lv_offset = lv_offset + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD _split_in_letters.
    DO strlen( input ) TIMES.
      DATA(lv_offset) = sy-index - 1.
      INSERT CONV #( input+lv_offset(1) ) INTO TABLE rt_letter.
    ENDDO.
  ENDMETHOD.
ENDCLASS.