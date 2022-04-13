CLASS zcl_prime_factors DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS factors
      IMPORTING
        input         TYPE int8
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_prime_factors IMPLEMENTATION.
  METHOD factors.
    " add solution here
    DATA(l_divi) = 2.
    DATA(remains) = input.
    while remains gt 1.
       if remains mod l_divi eq 0.
         result = value #( base result ( l_divi )  ).
         remains = remains / l_divi.
       else.
         l_divi = l_divi + switch #( l_divi when 2 then 1 else 2 ).
       endif.
    endwhile.
  ENDMETHOD.

ENDCLASS.