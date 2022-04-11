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
        VALUE(cipher_text) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS translate IMPORTING input            TYPE string
                                local_dictionary TYPE string
                      RETURNING VALUE(result)    TYPE string.
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.
  METHOD translate.
    result = REDUCE string( INIT str TYPE string
                  FOR i = 0 UNTIL i = strlen( input )
                  NEXT str = |{ str }{
                    COND #( LET  current_char       = to_upper( input+i(1) )
                                 foreign_dictionary = reverse( local_dictionary ) IN
                    WHEN local_dictionary   CS current_char
                    THEN to_lower( foreign_dictionary+sy-fdpos(1) )
                    WHEN '0123456789' CS current_char
                    THEN current_char ) }| ).
  ENDMETHOD.
  METHOD decode.
    plain_text = translate( input             = cipher_text
                            local_dictionary  = reverse( sy-abcde ) ).
  ENDMETHOD.

  METHOD encode.
    cipher_text = translate( input            = plain_text
                             local_dictionary = CONV #( sy-abcde ) ).
    REPLACE ALL OCCURRENCES OF REGEX `.{5}` IN cipher_text WITH |$& |.
    SHIFT cipher_text RIGHT DELETING TRAILING ` `.
    CONDENSE cipher_text.
  ENDMETHOD.
ENDCLASS.