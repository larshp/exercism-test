CLASS zcl_nth_prime DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS prime IMPORTING input    TYPE i
                      RETURNING VALUE(result) TYPE i
                      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_nth_prime IMPLEMENTATION.
  METHOD prime.
    DATA: lv_found          TYPE abap_bool,
          lv_number_to_test TYPE i,
          lv_divisor        TYPE i,
          lt_prime_numbers  TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    IF input = 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
    lv_number_to_test = 1.
    WHILE lines( lt_prime_numbers ) < input.
      lv_number_to_test = lv_number_to_test + 1.
      lv_divisor = 2.
      lv_found = abap_false.
      WHILE lv_divisor < lv_number_to_test  AND  lv_found = abap_false.
        IF lv_number_to_test MOD lv_divisor = 0 AND lv_number_to_test <> lv_divisor.
          lv_found = abap_true.
        ENDIF.
        lv_divisor = lv_divisor + 1.
      ENDWHILE.
      IF lv_found = abap_false.
        APPEND lv_number_to_test TO lt_prime_numbers.
      ENDIF.
    ENDWHILE.
    result = VALUE i( lt_prime_numbers[ input ] OPTIONAL ).
  ENDMETHOD.
ENDCLASS.