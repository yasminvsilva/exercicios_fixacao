USE cursores;

-- Exercício 01:

DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero VARCHAR(100))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE total INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE n_titulo VARCHAR(255);
    
    DECLARE cursor_lpg CURSOR FOR
    SELECT titulo
    FROM Livro
    WHERE id_genero = (SELECT id FROM Genero WHERE nome_genero = genero);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cursor_lpg;
    
    livros_loop: LOOP
        FETCH cursor_lpg INTO n_titulo;
        IF done = 1 THEN
            LEAVE livros_loop;
        END IF;
        
        SET total = total + 1;
    END LOOP;
    
    CLOSE cursor_lpg;
    
    RETURN total;
END;
//
DELIMITER ;

SELECT total_livros_por_genero('Romance') AS livros;

-- Exercício 02:

DELIMITER //
CREATE FUNCTION listar_livros_por_autor(nome VARCHAR(100), sobrenome VARCHAR(100))
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE lista TEXT DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE lTitulo VARCHAR(200);
    
    DECLARE cursor_llpn CURSOR FOR
    SELECT l.titulo
    FROM Livro l
    INNER JOIN Livro_Autor la ON l.id = la.id_livro
    INNER JOIN Autor a ON la.id_autor = a.id
    WHERE a.primeiro_nome = nome AND a.ultimo_nome = sobrenome;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cursor_llpn;
    
    cursor_llpn_loop : LOOP
		FETCH cursor_llpn INTO lTitulo;
        
        IF done = 1 THEN
			LEAVE cursor_llpn_loop;
		END IF;
        
        SET lista = CONCAT(lista, lTitulo, ', ');
	END LOOP;
    
    CLOSE cursor_llpn;
    
    SET lista = SUBSTRING(lista, 1, LENGTH(lista) - 2);
    
    RETURN lista;
END;
//
DELIMITER ;

SELECT listar_livros_por_autor('Ana', 'Lima') AS autor_livros;

-- Exercício 03:

DELIMITER //
CREATE FUNCTION atualizar_resumos()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE id_livro_n INT;
    DECLARE resumo_n TEXT;
    
    DECLARE cursor_atualizar CURSOR FOR
    SELECT id, resumo FROM Livro;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cursor_atualizar;
    
    cursor_att_loop: LOOP
		FETCH cursor_atualizar INTO id_livro_n, resumo_n;
        
        IF done = 1 THEN
			LEAVE cursor_att_loop;
		END IF;
        
        SET resumo_n = CONCAT(resumo_n, ' Este é um excelente livro!');
        
        UPDATE Livro SET resumo = resumo_n WHERE id = id_livro_n;
	END LOOP;
    
    CLOSE cursor_atualizar;

    RETURN 1;
END;
//
DELIMITER ;

SELECT atualizar_resumos();
SELECT resumo FROM Livro;

-- Exercício 04:

DELIMITER //
CREATE FUNCTION media_livros_por_editora() 
RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livros_total INT DEFAULT 0;
    DECLARE editoras_total INT DEFAULT 0;
    DECLARE media DECIMAL(10,2) DEFAULT 0.00;
    DECLARE id_editora_n INT;
    DECLARE livros_editora INT;

	DECLARE cursor_livros CURSOR FOR
	SELECT COUNT(id) FROM Livro WHERE id_editora = id_editora_n;

    DECLARE cursor_media CURSOR FOR
    SELECT id FROM Editora;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cursor_media;

    media_loop: LOOP
        FETCH cursor_media INTO id_editora_n;

        IF done = 1 THEN
            LEAVE media_loop;
        END IF;

        OPEN cursor_livros;
        FETCH cursor_livros INTO livros_editora;
        CLOSE cursor_livros;

        SET livros_total = livros_total + livros_editora;
        SET editoras_total = editoras_total + 1;
    END LOOP;
    
    IF editoras_total > 0 THEN
        SET media = livros_total / editoras_total;
    END IF;

    CLOSE cursor_media;

    RETURN media;
END;
//
DELIMITER ;

SELECT media_livros_por_editora() AS media;

-- Exercício 05:

DELIMITER //
CREATE FUNCTION autores_sem_livros()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE a_sem_livros TEXT DEFAULT '';

    DECLARE cursor_autores CURSOR FOR
    SELECT CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome_autor
    FROM Autor
    WHERE id NOT IN (SELECT DISTINCT id_autor FROM Livro_Autor);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cursor_autores;

    autor_loop: LOOP
        FETCH cursor_autores INTO a_sem_livros;

        IF done = 1 THEN
            LEAVE autor_loop;
        END IF;

        IF a_sem_livros != '' THEN
            SET a_sem_livros = CONCAT(a_sem_livros);
        END IF;
    END LOOP;

    CLOSE cursor_autores;

    RETURN a_sem_livros;
END;
//
DELIMITER ;

SELECT autores_sem_livros() AS autor_sem_livro;

-- Adicionei um autor sem livro na base de dados para esse exercício funcionar.