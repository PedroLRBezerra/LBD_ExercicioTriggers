CREATE DATABASE Aula8a_Exercicios_Triggers_Funcions
go
USE Aula8a_Exercicios_Triggers_Funcions

CREATE TABLE times(
codigo INT NOT NULL PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
sigla CHAR(3) NOT NULL
)

CREATE TABLE jogos(
timeA INT NOT NULL,
timeB INT NOT NULL,
golsA INT ,
golsB INT,
dia date not null,
PRIMARY KEY(timeA,timeB,dia)
FOREIGN KEY (timeA) REFERENCES times(codigo),
FOREIGN KEY (timeB) REFERENCES times(codigo)
)



CREATE TABLE campeonato(
nomeTime INT NOT NULL PRIMARY KEY,
jogos int NOT NULL,
vitorias int  NOT NULL,
empates int NOT NULL,
derrotas INT NOT NULL,
golsPro INT NOT NULL,
golsContra INT NOT NULL)


CREATE TRIGGER t_inserecampeonato ON times
FOR INSERT
AS
BEGIN
	DECLARE @cod int
	SELECT @cod = codigo FROM inserted
	INSERT INTO campeonato values (@cod,0,0,0,0,0,0)
END

insert times Values 
(1,'Barcelona','BAR')
insert times Values 
(2,'Celta de Vigo','CEL')
insert times Values 
(3,'Málaga','MAL')
insert times Values 
(4,'Real Madrid','RMA')

select * from times
select * from  campeonato

CREATE TRIGGER t_atttabelacampeonato ON jogos
FOR INSERT, UPDATE 
AS
BEGIN
	DECLARE @codA int,
			@codB int,
			@golsA int,
			@golsB int

			SELECT @codA = timeA, @codB = timeB , @golsA = golsA , @golsB = golsB FROM inserted

			if(((@golsA is not null) AND (@golsB is not null)))
			BEGIN
				IF(@golsA >@golsB)
				BEGIN
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsA), golsContra = (campeonato.golsContra + @golsB) , vitorias = (campeonato.vitorias + 1) WHERE campeonato.nomeTime = @codA
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsB), golsContra = (campeonato.golsContra + @golsA) , derrotas = (campeonato.derrotas + 1) WHERE campeonato.nomeTime = @codB
				END
				ELSE IF(@golsA<@golsb)
				BEGIN 
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsA), golsContra = (campeonato.golsContra + @golsB) , derrotas = (campeonato.derrotas + 1) WHERE campeonato.nomeTime = @codA
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsB), golsContra = (campeonato.golsContra + @golsA) , vitorias = (campeonato.vitorias + 1) WHERE campeonato.nomeTime = @codB	
				END
				ELSE
				BEGIN
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsA), golsContra = (campeonato.golsContra + @golsB) , empates = (campeonato.empates + 1) WHERE campeonato.nomeTime = @codA
					UPDATE campeonato SET jogos = (campeonato.jogos + 1) , golsPro = (campeonato.golsPro + @golsB), golsContra = (campeonato.golsContra + @golsA) , empates = (campeonato.empates + 1) WHERE campeonato.nomeTime = @codB
				END
			END
END

select * from jogos
select * from campeonato

insert into jogos(timeA,timeB,dia) values
(1,2,'22/04/2013 15:00')
insert into jogos(timeA,timeB,golsA,dia) values
(1,3,5,'29/04/2013 15:00')
insert into jogos(timeA,timeB,golsB,dia) values
(1,4,3,'29/04/2013 15:00')
insert into jogos values
(2,1,2,2,'25/04/2013 15:00')
insert into jogos values
(2,3,0,1,'02/04/2013 15:00')
insert into jogos values
(2,4,1,2,'25/04/2013 15:00')
insert into jogos values
(3,1,1,3,'25/04/2013 15:00')
insert into jogos values
(3,2,1,1,'15/05/2013 15:00')
insert into jogos values
(3,4,3,2,'18/05/2013 15:00')
insert into jogos values
(4,1,2,1,'23/05/2013 15:00')
insert into jogos values
(4,2,2,0,'27/05/2013 15:00')
insert into jogos values
(4,3,6,2,'31/05/2013 15:00')


update  jogos  set golsA = 3 , golsB = 1 where timeA=1 and timeB=2 and dia = '22/04/2013 15:00'
update  jogos  set golsA = 4 , golsB = 1 where timeA=1 and timeB=3 and dia = '29/04/2013 15:00'
update  jogos  set golsA = 2 , golsB = 2 where timeA=1 and timeB=4 and dia = '29/04/2013 15:00'

CREATE FUNCTION fn_campeonato()
RETURNS @tabela TABLE(
Sigla_Time Char(3),
Jogos int,
Vitorias int , 
Empates int, 
Derrotas int, 
GolsPro int ,
GolsContra int,
Pontos int)
AS
BEGIN
	INSERT @tabela ( Jogos,Vitorias,Empates,Derrotas,GolsPro,GolsContra,Sigla_Time ) select campeonato.jogos, vitorias,empates,derrotas,golsPro,golsContra, times.sigla from campeonato,times where campeonato.nome=times.codigo
	update @tabela set Pontos  = (Vitorias *3)+ Empates
	RETURN
END

SELECT * FROM dbo.fn_campeonato()
