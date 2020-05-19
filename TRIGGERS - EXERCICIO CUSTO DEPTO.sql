CREATE DATABASE extriggers01
GO
USE extriggers01
 

 
CREATE TABLE depto(
codigo INT not null,
nome VARCHAR(100),
total_salarios DECIMAL(7,2)
PRIMARY KEY(codigo))
 
CREATE TABLE funcionario(
id INT NOT NULL,
nome VARCHAR(100),
salario DECIMAL(7,2),
depto INT NOT NULL
PRIMARY KEY(id)
FOREIGN KEY (depto) REFERENCES depto(codigo))
 

 
INSERT INTO depto (codigo, nome) VALUES
(1,'RH'),
(2,'DTI')
 
 SELECT * FROM depto
SELECT * FROM funcionario
SELECT * FROM servico

 CREATE PROCEDURE sp_mudarcustodpto(@codDpto INT , @valor DECIMAL(7,2))
 AS
	DECLARE @valorAnterior DECIMAL(9,2)

	IF((SELECT depto.total_salarios FROM depto WHERE depto.codigo = @codDpto) is null)
	BEGIN 
		UPDATE depto SET depto.total_salarios = @valor FROM depto WHERE depto.codigo = @codDpto
	END
	ELSE
	BEGIN
		UPDATE depto SET depto.total_salarios = (depto.total_salarios+@valor) FROM depto WHERE depto.codigo = @codDpto
	END
 

 CREATE TRIGGER t_inserevalornodepto ON funcionario 
 FOR INSERT 
 AS
 BEGIN
	DECLARE @valor DECIMAL(7,2),
			@coddpto INT

	SELECT @coddpto = depto , @valor = salario from inserted

	EXEC sp_mudarcustodpto @coddpto, @valor
END

CREATE TRIGGER t_deletavalornodedpto ON funcionario
FOR DELETE
AS
 BEGIN
	DECLARE @valor DECIMAL(7,2),
			@coddpto INT

	SELECT @coddpto = depto , @valor = (salario*-1) from inserted

	EXEC sp_mudarcustodpto @coddpto, @valor
END

CREATE TRIGGER t_alteravalordepto ON funcionario
FOR UPDATE
AS
BEGIN
	DECLARE @valorNovo DECIMAL(7,2),
			@valorVelho DECIMAL(7,2),
			@valor DECIMAL(7,2),
			@deptoNovo INT,
			@deptoVelho INT

	SELECT @valorNovo = salario , @deptoNovo = depto FROM inserted
	SELECT @valorVelho = salario , @deptoVelho = depto FROM deleted

	IF(@deptoNovo = @deptoVelho)
	BEGIN
		SET @valor = @valorNovo-@valorVelho
		EXEC sp_mudarcustodpto @deptoNovo,@valor
	END
	ELSE
	BEGIN
		SET @valorVelho = @valorVelho*-1
		EXEC sp_mudarcustodpto @deptoNovo,@valorNovo
		EXEC sp_mudarcustodpto @deptoVelho,@valorVelho
	END
END


INSERT INTO funcionario VALUES
(1, 'Fulano', 1537.89,2)
INSERT INTO funcionario VALUES
(2, 'Cicrano', 2894.44, 1)
INSERT INTO funcionario VALUES
(3, 'Beltrano', 984.69, 1)
INSERT INTO funcionario VALUES
(4, 'Tirano', 2487.18, 2)


UPDATE funcionario SET salario = salario*0.95 WHERE id =  1
UPDATE funcionario SET salario = salario*1.05 WHERE id =  3
UPDATE funcionario SET depto = 2 WHERE id =3

SELECT * FROM depto
SELECT * FROM funcionario