-- DROP PROCEDURE sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(70),
		IN Ihash varchar(77)
    )
	BEGIN
		SELECT COUNT(*) AS login, IFNULL(nick,0) AS nick,  IFNULL(id,0) AS id, IFNULL(access,0) AS access, cod_local, cod_regiao FROM tb_usuario WHERE email COLLATE utf8_general_ci = Iemail COLLATE utf8_general_ci AND  hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
	END $$
DELIMITER ;

CALL sp_login("talescd@gmail.com","L,$@)6zDJh,T$^6rh)8Tz@B=`&j0t:~D+N5X?b(l2v<#F-P7ZAd*n4x>%H/R9¨­f,p6z@'J1T;^$h");

 DROP PROCEDURE sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iid int(11),
		IN Iemail varchar(70),
		IN Ihash varchar(77),
		IN Inick varchar(15),
		IN Icod_local int(11),
        IN Icod_regiao int(11)

    )
	BEGIN
    
		SET @edit = (SELECT COUNT(*) FROM tb_usuario WHERE id=Iid);
        
		IF(@edit) THEN
			UPDATE tb_usuario SET email=Iemail, nick=Inick, hash=Ihash, cod_local=Icod_local, cod_regiao=Icod_regiao WHERE id=Iid;
			SELECT 1 AS OK;
		ELSE
			SET @qtd_before = (SELECT COUNT(*) FROM tb_usuario);
			INSERT INTO tb_usuario (email,hash,nick,cod_local,cod_regiao) VALUES (Iemail,Ihash,Inick,Icod_local,Icod_regiao);
			IF((SELECT COUNT(*) FROM tb_usuario) > @qtd_before) THEN
				SELECT 1 AS OK;
			ELSE
				SELECT 0 AS OK;
			END IF;
        END IF;

	END $$
DELIMITER ;

 DROP PROCEDURE sp_Doit;
DELIMITER $$
	CREATE PROCEDURE sp_Doit(
		IN Ihash varchar(77),
        IN Imodal int(11),
		IN Iserie int(11),
		IN Ilance int(11)
    )
	BEGIN
    
		SET @id_call = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		
		INSERT INTO tb_doit (id_owner,id_modal,serie,lance) VALUES ( @id_call,Imodal,Iserie,Ilance);
		SELECT * FROM tb_doit WHERE id_modal=Imodal AND id_owner = @id_call 
			AND dia >= CURDATE() - INTERVAL 21 DAY - (IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))
			AND dia <= CURDATE() + (6 - IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))
			ORDER BY dia DESC;
	END $$
DELIMITER ;

DROP PROCEDURE sp_addModal;
DELIMITER $$
	CREATE PROCEDURE sp_addModal(
		IN Ihash varchar(77),
        IN Imodal VARCHAR(15)
    )
	BEGIN
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
		SET @new_id = (SELECT IFNULL(MAX(id),0)+1 FROM tb_modal WHERE id_user = @id_call);
        
        IF(@id_call > 0)THEN
			INSERT INTO tb_modal (id,id_user,nome) VALUES (@new_id,@id_call,Imodal);
			SELECT * FROM tb_modal WHERE id_user=@id_call;
		END IF;
	END $$
DELIMITER ;

DROP PROCEDURE sp_overClear;
DELIMITER $$
	CREATE PROCEDURE sp_overClear(
		IN Ihash varchar(77)
    )
	BEGIN
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
        
        IF(@id_call > 0)THEN
			DELETE FROM tb_doit WHERE dia< CURDATE() - INTERVAL 28 DAY AND id_owner=@id_call;
		END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_addMyModal;
DELIMITER $$
	CREATE PROCEDURE sp_addMyModal(
        IN Ihash VARCHAR(77),
        IN Imodal VARCHAR(15),
        IN Iserie int(11),
        IN Ilance int(11)
    )
	BEGIN		
        SET @id_call = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET @has = (SELECT COUNT(*) FROM tb_my_modal WHERE id_user = @id_call AND id_modal = Imodal);
    
		IF(@has)THEN
			DELETE FROM tb_my_modal WHERE id_user = @id_call AND id_modal = Imodal;
        ELSE
			INSERT INTO tb_my_modal (id_user,id_modal,serie,lance) VALUES(@id_call,Imodal,Iserie,Ilance);
        END IF;
        
        SELECT * FROM tb_my_modal WHERE id_user = @id_call;
        
	END $$
DELIMITER ;

 DROP PROCEDURE sp_viewDoit;
DELIMITER $$
	CREATE PROCEDURE sp_viewDoit(
		IN Ihash varchar(77),
        IN Imodal int(11)
    )
	BEGIN
    
		SET @id_call = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
				
		SELECT * FROM tb_doit WHERE id_modal=Imodal AND id_owner = @id_call 
			AND dia >= CURDATE() - INTERVAL (21 +  (IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))) DAY
			AND dia <= CURDATE() +  INTERVAL(7 - IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0)) DAY
			ORDER BY dia DESC;
	END $$
DELIMITER ;

DROP PROCEDURE sp_viewModal;
DELIMITER $$
	CREATE PROCEDURE sp_viewModal(
		IN Ihash varchar(77),
		IN allmodal boolean
    )
	BEGIN    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
        IF(@id_call>0)THEN
			IF(allmodal)THEN
				SELECT * FROM tb_modal WHERE id_user = @id_call;
			ELSE
				SELECT MODAL.* 
				FROM tb_modal AS MODAL
				INNER JOIN tb_my_modal AS MYMOD
				ON MODAL.id=MYMOD.id_modal
                AND MODAL.id_user = MYMOD.id_user
				AND MYMOD.id_user = @id_call;
			END IF;
        END IF;
	END $$
DELIMITER ;

SELECT MODAL.* 
            FROM tb_modal AS MODAL
            INNER JOIN tb_my_modal AS MYMOD
            ON MODAL.id=MYMOD.id_modal
            AND MYMOD.id_user = 1;