CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text TYPE string
      RETURNING
        VALUE(plain_text)  TYPE string .
    METHODS encode
      IMPORTING
        plain_text        TYPE string
      RETURNING
        VALUE(cipher_text) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD decode.
    plain_text =  translate( val = |{ condense( val = to_lower( cipher_text ) from = ` ,.:;` to = `` )  }|
                              from = |{ reverse( to_lower( sy-abcde ) ) && `0123456789` }|
                              to = |{ to_lower( sy-abcde ) && `0123456789` }|
                               ).
  ENDMETHOD.

  METHOD encode.
    cipher_text =  translate( val = |{ condense( val = to_lower( plain_text ) from = ` ,.:;` to = `` )  }|
                              from = |{ to_lower( sy-abcde ) && `0123456789` }|
                              to = |{ reverse( to_lower( sy-abcde ) ) && `0123456789` }| ).
    cipher_text = REDUCE string( LET txt_len = strlen( cipher_text ) IN
                            INIT text = `` offset = 0 sep = ``
                            FOR i = 1 UNTIL i > round( val = ( txt_len / 5 ) dec = 0 mode = cl_abap_math=>round_up )
                            NEXT text = text && sep &&
                                       substring( val = cipher_text off = offset
                                       len = nmin( val1 = 5
                                                   val2 = txt_len - offset )
                                                )
                                 sep = ` ` offset = i * 5 ).

  ENDMETHOD.

ENDCLASS.