CLASS zcl_123456789_open_sql_v2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_123456789_open_sql_v2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*---------------------------------------------------------------------*
* DATA PREPARATION
*---------------------------------------------------------------------*
    DATA:
      lt_insert TYPE TABLE OF z123456789_t_emp.
    DELETE FROM z123456789_t_emp.
*---------------------------------------------------------------------*
* 1. INSERT DATA
*---------------------------------------------------------------------*
    lt_insert = VALUE #(
      ( emp_id = '0000000001' name = 'Ali'   currency = 'TRY' unit = 'PC'
      amount = '1000.01' quantity = 10 )
      ( emp_id = '0000000002' name = 'Veli'  currency = 'TRY' unit = 'PC'
      amount = '2000.45' quantity = 20 )
      ( emp_id = '0000000003' name = 'Ayse'  currency = 'USD' unit = 'KG'
      amount = '5000.55' quantity = 5 )
      ( emp_id = '0000000004' name = 'John'  currency = 'EUR' unit = 'KG'
      amount = '7000.00' quantity = 7 )
      ( emp_id = '0000000005' name = 'Ahmet' currency = 'TRY' unit = 'PC'
      amount = '3000.99' quantity = 15 )
    ).

    INSERT z123456789_t_emp FROM TABLE @lt_insert.
    out->write( 'DATA INSERTED' ).

*---------------------------------------------------------------------*
* 2. NUMERIC FUNCTIONS
* İşlem: ABS (Mutlak değer), CEIL (Yukarı), FLOOR (Aşağı) ve ROUND (Hassas yuvarlama) kullanır.
*---------------------------------------------------------------------*
    SELECT emp_id,
           abs( amount )            AS abs_val,
           ceil( amount )           AS ceil_val,
           floor( amount )          AS floor_val,
           round( amount, 0 )       AS round_val,
           round( amount, 1 )       AS round_val2,
           round( amount, 2 )       AS round_val3
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_num).

*---------------------------------------------------------------------*
* 3. STRING FUNCTIONS (FULL)
* İşlem: Birleştirme (CONCAT), Parçalama (SUBSTRING), Büyük/Küçük harf ve Karakter doldurma (LPAD/RPAD).
*---------------------------------------------------------------------*
    SELECT emp_id,
           concat( name, '_EMP' )         AS c1,
           substring( name, 1, 2 )        AS sub,
           length( name )                 AS len,
           upper( name )                  AS upper,
           lower( name )                  AS lower,
           lpad( name, 10, '*' )          AS lpad,
           rpad( name, 10, '*' )          AS rpad,
           replace( name, 'A', 'X' )      AS repl
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_str).

*---------------------------------------------------------------------*
* 4. COMPLEX CASE
* İşlem: Amount değerine göre her çalışana dinamik bir kategori atar.
*---------------------------------------------------------------------*
    SELECT emp_id,
           CASE
             WHEN amount > 6000 THEN 'VERY HIGH'
             WHEN amount BETWEEN 3000 AND 6000 THEN 'HIGH'
             WHEN amount BETWEEN 1000 AND 3000 THEN 'MEDIUM'
             ELSE 'LOW'
           END AS category
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_case).

*---------------------------------------------------------------------*
* 5. AGGREGATE ADVANCED
* İşlem: Para birimine (Currency) göre gruplama yapar ve HAVING ile sonuçları filtreler.
*---------------------------------------------------------------------*
    SELECT currency,
           COUNT( * )     AS cnt,
           SUM( amount )  AS total,
           MAX( amount )  AS max,
           MIN( amount )  AS min,
           AVG( amount )  AS avg
      FROM z123456789_t_emp
      GROUP BY currency
      HAVING COUNT(*) > 0
      INTO TABLE @DATA(lt_agg).

*---------------------------------------------------------------------*
* 6. UNION / UNION ALL
* İşlem: UNION ALL mükerrer kayıtları silmezken, UNION (yalnız kullanıldığında) siler.
*---------------------------------------------------------------------*
    SELECT emp_id FROM z123456789_t_emp
    UNION ALL
    SELECT emp_id FROM z123456789_t_emp
    INTO TABLE @DATA(lt_union).

*---------------------------------------------------------------------*
* 7. ORDER + OFFSET + FETCH
* İşlem: Maaşa göre sıralar, 1. satırı atlar (OFFSET) ve sonraki 3 satırı getirir.
*---------------------------------------------------------------------*
    SELECT *
      FROM z123456789_t_emp
      ORDER BY amount DESCENDING
      INTO TABLE @DATA(lt_page)
      UP TO 3 ROWS OFFSET 1.

*---------------------------------------------------------------------*
* 8. DYNAMIC WHERE
* İşlem: lv_where değişkenindeki metni SQL motoruna filtre olarak sunar.
*---------------------------------------------------------------------*
    DATA(lv_where) = `amount > 2000`.

    SELECT *
      FROM z123456789_t_emp
      WHERE (lv_where)
            INTO TABLE @DATA(lt_dyn).


*---------------------------------------------------------------------*
* 9. ARITHMETIC EXPRESSIONS IN SELECT
* İşlem: Amount ve Quantity çarpılarak "Toplam Stok Değeri" hesaplanır.
*---------------------------------------------------------------------*
    SELECT emp_id,
           amount,
           quantity,
           ( amount * quantity ) AS total_stock_value
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_calc).

*---------------------------------------------------------------------*
* 10. CONCAT_WITH_SPACE FUNCTION
* İşlem: 'ID:' sabitini ve emp_id değerini aralarında 1 boşlukla birleştirir.
*---------------------------------------------------------------------*
    SELECT emp_id,
           concat_with_space( 'ID:', emp_id, 1 ) AS id_label
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_concat_space).

*---------------------------------------------------------------------*
* 11. SELECT DISTINCT (UNIQUE RECORDS)
* İşlem: Tablodaki tekrar eden satırları tekilleştirmek.
*        Tabloda kaç farklı para birimi (Currency) kullanıldığını getirir.
*---------------------------------------------------------------------*
    SELECT DISTINCT currency
      FROM z123456789_t_emp
      INTO TABLE @DATA(lt_distinct).

*---------------------------------------------------------------------*
* 12. BETWEEN OPERATOR (NEW SYNTAX)
* İşlem: Maaşı 2000 ile 5000 (dahil) arasında olanları seçer.
*---------------------------------------------------------------------*
    SELECT *
      FROM z123456789_t_emp
      WHERE amount BETWEEN 2000 AND 5000
      INTO TABLE @DATA(lt_between).

*---------------------------------------------------------------------*
* 13. LIKE PATTERN MATCHING
* İşlem: İsmi 'A' harfi ile başlayan çalışanları getirir.
*---------------------------------------------------------------------*
    SELECT *
      FROM z123456789_t_emp
      WHERE name LIKE 'A%'
      INTO TABLE @DATA(lt_like).

*---------------------------------------------------------------------*
* 14. IN OPERATOR WITH LIST
* İşlem: Sadece TRY veya USD olan kayıtları filtreler.
*---------------------------------------------------------------------*
    SELECT *
      FROM z123456789_t_emp
      WHERE currency IN ( 'TRY', 'USD' )
      INTO TABLE @DATA(lt_in).



    out->write( 'SQL Queries Executed.' ).

  ENDMETHOD.

ENDCLASS.
