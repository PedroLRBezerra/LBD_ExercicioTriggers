CREATE DATABASE Aula_Cursores
GO
USE Aula_Cursores

CREATE TABLE curso(
codigo INT NOT NULL,
nome VARCHAR(MAX) NOT NULL,
duracao INT NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE disciplinas(
cod INT NOT NULL,
nome VARCHAR(MAX) NOT NULL,
carga_horaria INT NOT NULL
PRIMARY KEY (cod)
)

CREATE TABLE disciplina_curso(
cod_dis  INT NOT NULL,
cod_curso INT NOT NULL
PRIMARY KEY (cod_dis,cod_curso),
FOREIGN KEY (cod_dis) REFERENCES disciplinas(cod),
FOREIGN KEY (cod_curso) REFERENCES curso (codigo)
)

INSERT INTO curso VALUES
(0,'Análise e desenvolvemento de sistemas',2880),
(1,'Logistica',2880),
(2,'Polimeros',2880),
(3,'Comércio Exterior',2600),
(4,'Gest?o Empresarial',2600)

INSERT INTO disciplinas VALUES
(1,'Algoritmos',80),
(2,'Administraç?o',80),
(3,'Laboratório de Hardware',40),
(4,'Pesquisa Operacional',80),
(5,'Física I',80),
(6,'Fisico quimica',80),
(7,'Comércio Exterior',80),
(8,'Fundamentos de Marketing',80),
(9,'Informática',40),
(10,'Sistemas de Informaç?o',80)

INSERT INTO disciplina_curso VALUES
(1,0),
(2,0),
(2,1),
(2,3),
(2,4),
(3,0),
(4,1),
(5,2),
(6,2),
(7,1),
(7,3),
(8,1),
(8,4),
(9,1),
(9,3),
(10,0),
(10,4)

SELECT *FROM curso
SELECT *FROM disciplinas
SELECT *FROM disciplina_curso

CREATE FUNCTION fn_TeinoCursor(@cod_curso INT)
RETURNS @tabela_Cursor TABLE(
cod_Disciplina INT,
Nome_disciplina VARCHAR(MAX),
Carga_Horaria_disciplina INT,
nome_curso VARCHAR(MAX)
)
AS
 BEGIN
	DECLARE	 @cod_disc INT,
			 @nome_disc VARCHAR(MAX),
			@carga INT,
			@nome_curso VARCHAR(MAX),
			@cod_c int
			



   DECLARE cursor_busca CURSOR FOR SELECT cod_dis,cod_curso FROM disciplina_curso


   OPEN cursor_busca
   FETCH NEXT FROM cursor_busca INTO @cod_disc,@cod_c
   --VERIFICAR SE HOUVE REGISTRO
    WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @nome_disc=disciplinas.nome, @carga = disciplinas.carga_horaria, @nome_curso=curso.nome FROM disciplinas,curso
		WHERE @cod_disc = disciplinas.cod AND  @cod_c = @cod_curso

		 INSERT INTO @tabela_Cursor VALUES 
	  (@cod_disc,@nome_disc,@carga,@nome_curso)

	 FETCH NEXT FROM cursor_busca INTO @cod_disc,@cod_c
	END
	CLOSE cursor_busca
    DEALLOCATE cursor_busca
    RETURN
END

SELECT*FROM dbo.fn_TeinoCursor(0)