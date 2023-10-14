CREATE DATABASE aula_funcao;
USE aula_funcao;

-- 1. FUNÇÕES DE STRING:

-- A)
CREATE TABLE nomes (
	nome VARCHAR(100)
);

INSERT INTO nomes (nome) VALUES
('Roberta'),
('Roberto'),
('Maria Clara'),
('João');

-- B)
SELECT UPPER(nome) AS nm_maiusculo FROM nomes;

-- C)
SELECT nome, LENGTH(nome) AS nm_tamanho FROM nomes;

-- D)
SELECT
	CASE
		WHEN nome LIKE '%O' THEN CONCAT('Sr. ', nome)
        ELSE CONCAT('Sra. ', nome)
	END AS nm_formal
FROM nomes;

-- 2. FUNÇÕES NUMÉRICAS:

-- A)
CREATE TABLE produtos (
	produto VARCHAR(100),
    preco DECIMAL(10, 2),
    quantidade INT
);

INSERT INTO produtos VALUES
('Air Fryer', 349.34, 40),
('Bateria', 2501.16, 75),
('Celular', 1280.26, 0),
('Guitarra', 612.99, 120),
('Mochila', 129.87, 150);

-- B)
SELECT produto, ROUND(preco, 2) AS arredondado FROM produtos;

-- C)
SELECT produto, ABS(quantidade) AS qtd_absoluta FROM produtos;

-- D)
SELECT AVG(preco) AS pmedia FROM produtos;

-- 3. FUNÇÕES DE DATA:

-- A)
CREATE TABLE eventos (
	data_evento DATETIME
);

INSERT INTO eventos VALUES
('1956-10-05 18:30:10'),
('1974-05-16 08:42:49'),
('2008-08-19 23:25:53'),
('2010-09-28 19:20:09');

-- B)
INSERT INTO eventos (data_evento) VALUES
(now());

SELECT * FROM eventos;

-- C)
SELECT DATEDIFF ('2010-10-20' , '2006-06-30') AS diferenca_dias;

-- D)
SELECT DAYNAME('2006-05-30') AS dia_semana;

-- 4. FUNÇÕES DE CONTROLE DE FLUXO:

-- A)
SELECT produto, quantidade,
	IF (quantidade > 0, 'Em estoque', 'Fora de estoque') AS estoque
FROM produtos;

-- B)
SELECT produto, preco,
	CASE
		WHEN preco <= 300.00 THEN 'Barato'
        WHEN preco > 300.00 AND preco <= 1000.00 THEN 'Médio'
        ELSE 'Caro'
	END AS ctg_preco
FROM produtos;

-- 5. FUNÇÃO PERSONALIZADA:

-- A)
DELIMITER //
CREATE FUNCTION valor_total (preco DECIMAL(10, 2), quantidade INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
	DECLARE total FLOAT;
    SELECT preco * quantidade INTO total;
   
    RETURN total;
END;
//
DELIMITER ;

SELECT valor_total (20.00, 10) AS total;

-- B)
SELECT produto, preco, quantidade, valor_total(preco, quantidade) AS total
FROM produtos;

-- 6. FUNÇÕES DE AGREGAÇÃO:

-- A)
SELECT COUNT(produto) AS qtd_produtos FROM produtos;

-- B)
SELECT MAX(preco) AS produto_caro FROM produtos;

-- C)
SELECT MIN(preco) AS produto_barato FROM produtos;

-- D)
SELECT SUM(IF(quantidade > 0, preco * quantidade, 0)) AS soma_produtos 
FROM produtos;

-- 7. CRIANDO FUNÇÕES:

-- A)
DELIMITER //
CREATE FUNCTION n_fatorial (numero INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE fatorial INT;
    SET fatorial = 1;
    
    WHILE numero > 0 DO
		SET fatorial = fatorial * numero;
        SET numero = numero - 1;
	END WHILE;
    
    RETURN fatorial;
END;
//
DELIMITER ;

SELECT n_fatorial(3);

-- B)
DELIMITER //
CREATE FUNCTION exponencial (base INT, expoente INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE resultado INT;
    SET resultado = 1;

	WHILE expoente > 0 DO
		SET resultado = resultado * base;
        SET expoente = expoente - 1;
	END WHILE;

    RETURN resultado;
END;
//
DELIMITER ;

SELECT exponencial(2, 3);

-- C)
DELIMITER //
CREATE FUNCTION palindromo(palavra VARCHAR(100))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE p_tamanho INT;
	DECLARE contador INT;
    DECLARE p_revertida VARCHAR(100);
    
    SET p_tamanho = LENGTH(palavra);
    SET contador = p_tamanho;
    SET p_revertida = '';
    
    WHILE contador > 0 DO
		SET p_revertida = CONCAT(p_revertida, SUBSTRING(palavra, contador, 1));
        SET contador = contador - 1;
	END WHILE;
    
    IF palavra = p_revertida THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END;
//
DELIMITER ;

SELECT palindromo('Arara') AS palindromo;