DROP PROCEDURE IF EXISTS ifProc1;
DELIMITER $$
CREATE PROCEDURE ifProc1()
BEGIN
	IF 100 = 100 THEN
		SELECT '100은 100과 같습니다.';
        END IF;
	END $$
    DELIMITER ;
CALL ifProc1();

DROP PROCEDURE IF EXISTS ifProc2;
DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE myNum INT;
    SET myNum = 200;
    IF myNum = 100 THEN
		SELECT '100입니다.';
	ELSE
		SELECT '100이 아닙니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc2();

DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE debutDate DATE;
    DECLARE curDate DATE;
    DECLARE days INT;
    SELECT debut_date INTO debutDate
		FROM market_db.member
        WHERE mem_id = 'APN';
	SET curDATE = current_date();
    SET days = datediff(curDATE,debutDate);
    
    IF (days/365) >= 5 THEN
		SELECT CONCAT('데뷔한 지',days,'일이나 지났습니다. 핑순이들 축하합니다!');
	ELSE
		SELECT '데뷔한 지' +  days + '일밖에 안되었네요. 핑순이들 화이팅~';
	END IF;
END $$
DELIMITER ;
CALL ifProc3();

DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 88;
    
    CASE
		WHEN point>= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		WHEN point >= 50 THEN
			SET credit = 'F';
	END CASE;
    SELECT CONCAT('취득점수 ==>',point),CONCAT('학점==>',credit);
END $$
DELIMITER ;
CALL caseProc();

SELECT mem_id, SUM(price*amount) "총구매액"
	FROM buy
	GROUP BY mem_id;
    
SELECT mem_id,SUM(price*amount) "총구매액"
	FROM buy
    GROUP BY mem_id
	ORDER BY SUM(price*amount) DESC;
    
SELECT B.mem_id, M.mem_name,
		SUM(price*amount) "총구매액"
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY B.mem_id
    ORDER BY SUM(price*amount) DESC;

SELECT M.mem_id, M.mem_name,
		SUM(price*amount) "총구매액"
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;
    

SELECT M.mem_id, M.mem_name, SUM(price*amount) "총구매액",
	CASE
		WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
        WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
        WHEN (SUM(price*amount) >= 1) THEN '일반고객'
        ELSE '유령고객'
	END "회원등급"
	FROM buy B
		RIGHT OUTER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price * amount) DESC;

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
    
    WHILE (i<=100) DO
		SET hap = hap + i;
        SET i = i+1;
	END WHILE;
    SELECT '1부터 100까지의 합 ==>' , hap;
END $$
DELIMITER ;
CALL whileProc();


DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0 ;
    
    myWhile:
    WHILE (i<=100) DO
		IF (i%4 = 0) THEN
			SET i=i+1;
            ITERATE myWhile;
		END IF;
        SET hap = hap + i;
        IF (hap>1000) THEN
			LEAVE myWhile;
		END IF;
        SET i = i+1;
	END WHILE;
    
    SELECT '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 ==>', hap;
END $$
DELIMITER ;
CALL whileProc2();

USE market_db;
PREPARE myQuery FROM 'SELECT * FROM member WHERE mem_id = "BLK"';
EXECUTE myQuery;
DEALLOCATE PREPARE myQuery;

DROP TABLE IF EXISTS gate_table;
CREATE TABLE gate_table (id INT AUTO_INCREMENT PRIMARY KEY, entry_time DATETIME);

SET @curDate = current_timestamp();

PREPARE myQuery FROM 'INSERT INTO gate_table VALUES(NULL,?)';
EXECUTE myQuery USING @curDate;
DEALLOCATE PREPARE myQuery;

SELECT * FROM gate_table;