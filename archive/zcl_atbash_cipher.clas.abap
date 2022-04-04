CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text       TYPE string
      RETURNING
        VALUE(plain_text) TYPE string.
    METHODS constructor.
    METHODS encode
      IMPORTING
        plain_text         TYPE string
      RETURNING
        VALUE(cipher_text) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA plain_latin   TYPE string.
    DATA atbash_cipher TYPE string.

    METHODS conv_to_target_character_set
      IMPORTING
        text               TYPE string
        from_character_set TYPE string
        to_character_set   TYPE string
      RETURNING
        VALUE(result)      TYPE string.
ENDCLASS.


CLASS zcl_atbash_cipher IMPLEMENTATION.
  METHOD constructor.
    plain_latin = to_lower( sy-abcde ).
    atbash_cipher = to_lower( reverse( sy-abcde ) ).
  ENDMETHOD.

  METHOD decode.
    DATA(input) = to_lower( cipher_text ).

    plain_text = conv_to_target_character_set(
                     text               = input
                     from_character_set = atbash_cipher
                     to_character_set   = plain_latin ).
  ENDMETHOD.

  METHOD conv_to_target_character_set.
    DATA(input_text) = text.
    CONDENSE input_text NO-GAPS.
    DO strlen( input_text ) TIMES.
      DATA(alphabet) = substring(
                           val = input_text
                           off = sy-index - 1
                           len = 1 ).

      result = result &&
                    COND #(
                      WHEN alphabet CO '0123456789' THEN alphabet
                      ELSE substring( val = to_character_set
                                      off = find( val = from_character_set sub = alphabet )
                                      len = 1 ) ).
    ENDDO.
    CONDENSE result.
  ENDMETHOD.

  METHOD encode.
    DATA(input) = replace(
                      val   = to_lower( plain_text )
                      regex = `[^a-z0-9]` ##REGEX_POSIX
                      with  = space
                      occ   = 0 ).

    DATA(ungrouped_cipher_text) = conv_to_target_character_set(
                                      text               = input
                                      from_character_set = plain_latin
                                      to_character_set   = atbash_cipher ).

    DO strlen( ungrouped_cipher_text ) TIMES.
      cipher_text = COND #(
                      LET c = substring(
                                  val = ungrouped_cipher_text
                                  off = sy-index - 1
                                  len = 1 ) IN
                      WHEN sy-index MOD 5 = 0 THEN cipher_text && c && ` `
                      ELSE cipher_text && c ).
    ENDDO.
    CONDENSE cipher_text.
  ENDMETHOD.
ENDCLASS.