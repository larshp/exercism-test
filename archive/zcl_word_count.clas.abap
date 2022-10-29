CLASS zcl_word_count DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF return_structure,
        word  TYPE string,
        count TYPE i,
      END OF return_structure,
      return_table TYPE STANDARD TABLE OF return_structure WITH KEY word.
    METHODS count_words
      IMPORTING
        !phrase       TYPE string
      RETURNING
        VALUE(result) TYPE return_table .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_word_count IMPLEMENTATION.

  METHOD count_words.
    DATA(string) = replace( val = to_lower( phrase ) sub = `'` with = `` occ = 0 ).
    string = replace( val = string sub = `\t` with = ` ` occ = 0 ).
    string = replace( val = string sub = `\n` with = ` ` occ = 0 ).
    string = condense( replace( val = string regex = `[^a-z0-9]` with = ` ` occ = 0 ) ).

    DO.
      TRY.
          DATA(substring) = segment( val = string
                            index = sy-index
                            sep = ` ` ).
          TRY.
              DATA(single_count) = REF #( result[ word = substring ]-count ).
              single_count->* += 1.
            CATCH cx_sy_itab_line_not_found.
              APPEND VALUE #( word = substring  count = 1 ) TO result.
          ENDTRY.

        CATCH cx_sy_strg_par_val.
          EXIT.
      ENDTRY.
    ENDDO.

  ENDMETHOD.
ENDCLASS.