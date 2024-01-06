<?php

    $query_db = array(
        "0"  => 'CALL sp_login("x00","x01");',
        "1"  => 'CALL sp_setUser("x00","x01","x02","x03",x04,x05);',
        "2"  => 'CALL sp_Doit("x00",x01,x02,x03);',
        "3"  => 'CALL sp_viewDoit("x00",x01);',
        "4"  => 'CALL sp_viewModal("x00",x01);',
        "5"  => 'CALL sp_addMyModal("x00",x01,x02,x03);',
        "6"  => 'CALL sp_addModal("x00","x01");',
        "7"  => 'SELECT * FROM vw_chart WHERE ID_USER=x00;',
        
    );

 
?>