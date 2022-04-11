CLASS zcl_nth_prime DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS:
      constructor,
      prime
        IMPORTING
          input         TYPE i
        RETURNING
          VALUE(result) TYPE i
        RAISING
          cx_parameter_invalid.

  PRIVATE SECTION.
    TYPES:
      type_t_prime TYPE STANDARD TABLE OF abap_bool WITH NON-UNIQUE DEFAULT KEY.

    DATA:
      _primes TYPE type_t_prime.

    METHODS:
      _calc_primes
        IMPORTING
          iv_limit         TYPE i
        RETURNING
          VALUE(rt_primes) TYPE type_t_prime.

ENDCLASS.

CLASS zcl_nth_prime IMPLEMENTATION.
  METHOD constructor.
    _primes = _calc_primes( 151 ).
  ENDMETHOD.

  METHOD prime.
    IF input < 1.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.

    DATA(lv_count) = 0.
    LOOP AT _primes ASSIGNING FIELD-SYMBOL(<lv_prime>).
      IF <lv_prime> = abap_true.
        lv_count = lv_count + 1.
      ENDIF.
      IF lv_count = input.
        result = sy-tabix.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD _calc_primes.
    DO iv_limit TIMES.
      IF sy-index > 1.
        INSERT abap_true INTO TABLE rt_primes.
      ELSE.
        INSERT abap_false INTO TABLE rt_primes.
      ENDIF.
    ENDDO.

    DATA(lv_number) =  2.
    WHILE ( lv_number <= trunc( sqrt( iv_limit ) ) ).
      IF ( rt_primes[ lv_number ] = abap_true ).
        DATA(lv_non_primer_number) = lv_number ** 2.
        WHILE ( lv_non_primer_number <= iv_limit ).
          rt_primes[ lv_non_primer_number ] = abap_false.
          lv_non_primer_number = ( lv_number ** 2 ) + ( sy-index * lv_number ).
        ENDWHILE.
      ENDIF.
      lv_number = lv_number + 1.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.