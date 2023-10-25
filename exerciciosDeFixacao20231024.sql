-- 1
CREATE TRIGGER nv_cliente AFTER INSERT ON Clientes
	FOR EACH ROW 
    INSERT INTO Auditoria(mensagem, data_hora)
    VALUES ('Novo cliente adicionado.', NOW());
    
INSERT INTO Clientes(nome)
VALUES ('João'), ('Liz');

SELECT * FROM Auditoria;

-- 2
CREATE TRIGGER dlt_cliente BEFORE DELETE ON Clientes
	FOR EACH ROW
    INSERT INTO Auditoria(mensagem)
    VALUES ('Houve uma tentativa de exclusão de cliente.');

DELETE FROM Clientes WHERE nome = 'João';

SELECT * FROM Auditoria;

-- 3 
CREATE TRIGGER upt_cliente AFTER UPDATE ON Clientes
	FOR EACH ROW
    INSERT INTO Auditoria(mensagem)
    VALUES (CONCAT('Nome antigo: ', OLD.nome, ' // Nome novo: ', NEW.nome));
    
UPDATE Clientes SET nome = 'Mônica' WHERE nome = 'Liz';

SELECT * FROM Auditoria;

-- 4
DELIMITER //
CREATE TRIGGER invalidacao BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
	IF NEW.nome = '' OR NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Atualização inválida. Certifique-se de inserir um nome válido.';
        
        INSERT INTO Auditoria(mensagem)
        VALUES ('Uma tentativa de atualização com nome nulo ou com uma string vazia foi feita.');
	END IF;
END;
//
DELIMITER ;

UPDATE Clientes SET nome = '' WHERE nome = 'Mônica';

SELECT * FROM Auditoria;

-- Não consegui fazer com que a mensagem apareça em auditoria, só impedir que a atualização aconteça.

-- 5
DELIMITER //
CREATE TRIGGER pedidos_produto AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
	UPDATE Produtos SET estoque = estoque - NEW.quantidade;
    
    IF (SELECT estoque FROM Produtos WHERE id = NEW.produto_id) < 5 THEN
		INSERT INTO Auditoria(mensagem)
        VALUES ('O estoque do produto ficou abaixo de 5 unidades.');
	END IF;
END;
//
DELIMITER ;

INSERT INTO Produtos (nome, estoque)
VALUES ('Gloss', 10);

INSERT INTO Pedidos (produto_id, quantidade)
VALUES (1, 6);

SELECT * FROM Auditoria;