CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text       TYPE string
      RETURNING
        VALUE(plain_text) TYPE string .
    METHODS encode
      IMPORTING
        plain_text         TYPE string
      RETURNING
        VALUE(cipher_text) TYPE   string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES char1 TYPE c LENGTH 1.
    TYPES float3 TYPE p DECIMALS 1 LENGTH 5.
    METHODS convert_string_to_lower_case
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
    METHODS convert_string_to_upper_case
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
    METHODS get_value_of_character
      IMPORTING
        input         TYPE c
      RETURNING
        VALUE(result) TYPE i .
    METHODS get_character_of_value
      IMPORTING
        input         TYPE i
      RETURNING
        VALUE(result) TYPE char1.
    METHODS rotate_letter
      IMPORTING
        letter_to_rotate TYPE char1
      RETURNING
        VALUE(result)    TYPE char1.
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD decode.
    DATA(upper_case_text) = convert_string_to_upper_case( cipher_text ).
    DO strlen( upper_case_text ) TIMES.
*      CHECK .
      DATA(offset)          = sy-index - 1.
      DATA(plain_character) = rotate_letter( substring( val = upper_case_text  off = offset  len = 1 ) ).
      plain_text            = |{ plain_text }{ plain_character }|.
    ENDDO.
    plain_text = convert_string_to_lower_case( plain_text ).
  ENDMETHOD.

  METHOD encode.
    DATA(upper_case_text) = convert_string_to_upper_case( plain_text ).
    DATA(rotate_5)         = 0.
    DO strlen( upper_case_text ) TIMES.
      DATA(offset)           = sy-index - 1.
      DATA(cipher_character) = rotate_letter( letter_to_rotate = substring( val = upper_case_text  off = offset  len = 1 ) ).
      CHECK cipher_character NE space.
      rotate_5               = COND #( WHEN rotate_5 = 5
                                         THEN 1
                                         ELSE rotate_5 + 1 ).
      cipher_text            = COND #( WHEN rotate_5 EQ 1 AND sy-index NE 1
                                         THEN |{ cipher_text } { cipher_character }|
                                         ELSE |{ cipher_text }{ cipher_character }| ).
    ENDDO.
    cipher_text = convert_string_to_lower_case( cipher_text ).
  ENDMETHOD.



  METHOD rotate_letter.
    IF letter_to_rotate EQ space.
      result = space.
      RETURN.
    ENDIF.
    IF letter_to_rotate CA '0123456789'.
      result = letter_to_rotate.
      RETURN.
    ENDIF.
    DATA(plain_character_value)  = get_value_of_character( letter_to_rotate  ).
    DATA(cipher_character_value) = 26 - plain_character_value + 1.
    cipher_character_value       = COND #( WHEN cipher_character_value GE 1
                                             THEN cipher_character_value
                                             ELSE 26 - cipher_character_value  ).
    result                       = get_character_of_value( cipher_character_value ).
  ENDMETHOD.



  METHOD convert_string_to_lower_case.
    result = input.
    TRANSLATE result TO LOWER CASE.
  ENDMETHOD.


  METHOD convert_string_to_upper_case.
    result = input.
    TRANSLATE result TO UPPER CASE.
  ENDMETHOD.


  METHOD get_value_of_character.
    DO 26 TIMES.
      DATA(offset) = sy-index - 1.
      IF sy-abcde+offset(1) EQ input.
        result = sy-index.
        RETURN.
      ENDIF.
    ENDDO.
  ENDMETHOD.


  METHOD get_character_of_value.
    CHECK input NE 0 AND input LE 26.
    DATA(offset) = input - 1.
    result = sy-abcde+offset(1).
  ENDMETHOD.

ENDCLASS.