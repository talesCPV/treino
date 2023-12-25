 SELECT * FROM vw_ranking;


 
 DROP VIEW vw_ranking;
-- CREATE VIEW vw_ranking AS
	SELECT USR.id, USR.nick,
    (SELECT IFNULL(ROUND(AVG(saque),2),0)FROM tb_ranking WHERE id_avaliado=USR.id) AS SAQUE,
    (SELECT IFNULL(ROUND(AVG(passe),2),0)FROM tb_ranking WHERE id_avaliado=USR.id) AS PASSE,
    (SELECT IFNULL(ROUND(AVG(ataque),2),0)FROM tb_ranking WHERE id_avaliado=USR.id) AS ATAQUE,
    (SELECT IFNULL(ROUND(AVG(levanta),2),0)FROM tb_ranking WHERE id_avaliado=USR.id) AS LEVANTA
	FROM tb_usuario AS USR;
        

SELECT CURDATE() - INTERVAL 21 DAY - WEEKDAY(CURDATE()) - 1;
SELECT CURDATE() + (7 - WEEKDAY(CURDATE()) - 1);



SELECT * FROM tb_doit WHERE id_modal=1 AND id_owner = 1 AND dia BETWEEN (CURDATE() - INTERVAL 21 DAY - WEEKDAY(CURDATE()) - 1) AND CURDATE() ORDER BY dia DESC;


SELECT WEEKDAY(CURDATE());