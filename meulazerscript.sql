CREATE TABLE USUARIO(
	ID_USUARIO_PK SERIAL PRIMARY KEY,
	NOME_USUARIO VARCHAR(70),
	CPF_US VARCHAR (11) UNIQUE,
	RUA_US VARCHAR(30),
	ESTADO_US VARCHAR(2),
	CIDADE_US VARCHAR(30),
	CEP_US VARCHAR(8),
	EMAIL_US VARCHAR(30),
	TELEFONE_US VARCHAR(8),
	CELULAR_US VARCHAR(15),
	PONTOS_US INTEGER,
	SEXO_US CHAR,
	DATA_NASC DATE NOT NULL
)

-----------------------------------------------------------------------------------------------

CREATE TABLE PROMOTOR(
	NOME_PROMOTOR VARCHAR(70),
	ID_PROMOTOR SERIAL PRIMARY KEY,
	ID_USUARIO_FK INTEGER,
	CNPJ VARCHAR (14) UNIQUE,
	PONTOS_PROM INTEGER,
	FOREIGN KEY (ID_USUARIO_FK) REFERENCES USUARIO(ID_USUARIO_PK) ON DELETE CASCADE
)



-----------------------------------------------------------------------------------------------

CREATE TABLE PARTICIPANTE(
	ID_PARTICIPANTE SERIAL PRIMARY KEY,
	ID_USUARIO_FK INTEGER,
	FOREIGN KEY (ID_USUARIO_FK) REFERENCES USUARIO(ID_USUARIO_PK) ON DELETE CASCADE
)


-----------------------------------------------------------------------------------------------

CREATE TABLE EVENTO(
	DATA_INICIO_EVENTO DATE NOT NULL,
	DATA_FIM_EVENTO DATE,
	DESCRICAO_EVENTO VARCHAR(255),
	NOME_EVENTO VARCHAR(80),
	ID_EVENTO SERIAL PRIMARY KEY
)



-----------------------------------------------------------------------------------------------

CREATE TABLE ATIVIDADE(
	TIPO_ATV VARCHAR(15),
	DATA_ATV DATE NOT NULL,
	HORARIO_ATV TIME,
	RUA_ATV VARCHAR(30),
	ESTADO_ATV VARCHAR(2),
	CIDADE_ATV VARCHAR(30),
	NOME_ATV VARCHAR(30),
	DESCRICAO_ATV VARCHAR(255),
	ID_ATIVIDADE SERIAL PRIMARY KEY	
)


-----------------------------------------------------------------------------------------------

CREATE TABLE PATROCINADOR_SEC(
	NOME_PATRO VARCHAR(30),
	RUA_PATRO VARCHAR(30),
	ESTADO_PATRO VARCHAR(2),
	CIDADE_PATRO VARCHAR(30),
	CEP_PATRO VARCHAR(8),
	EMAIL_PATRO VARCHAR(30),
	TELEFONE_PATRO VARCHAR(8),
	CELULAR_PATRO VARCHAR(15),
	ID_EVENTO_FK INTEGER,
	ID_PATRO SERIAL,
	FOREIGN KEY (ID_EVENTO_FK) REFERENCES EVENTO(ID_EVENTO),
	CONSTRAINT PATRO_PK PRIMARY KEY (ID_EVENTO_FK, ID_PATRO)  
)


-----------------------------------------------------------------------------------------------
--RELAÇÃO

CREATE TABLE ATIVIDADE_EVENTO(
	ID_EVENTO_FK INTEGER,
	ID_ATIVIDADE_FK INTEGER,
	FOREIGN KEY (ID_EVENTO_FK) REFERENCES EVENTO(ID_EVENTO),
	FOREIGN KEY (ID_ATIVIDADE_FK) REFERENCES ATIVIDADE(ID_ATIVIDADE)
)


-----------------------------------------------------------------------------------------------

CREATE TABLE ORGANIZA_EVENTO(
	ID_PROMOTOR_FK INTEGER,
	ID_EVENTO_FK INTEGER,
	DATA_INICIO_ORG DATE,
	DATA_FIM_ORG DATE,
	GASTO_ORG INTEGER,
	PTS_GERADOS_ORG INTEGER,
	FOREIGN KEY (ID_PROMOTOR_FK) REFERENCES PROMOTOR(ID_PROMOTOR),
	FOREIGN KEY (ID_EVENTO_FK) REFERENCES EVENTO(ID_EVENTO)
)

-----------------------------------------------------------------------------------------------

CREATE TABLE PARTICIPA_EVENTO(
	ID_PARTICIPANTE_FK INTEGER,
	ID_EVENTO_FK INTEGER,
	DATA_INICIO_PART DATE,
	DATA_FIM_PART DATE,
	PTS_GERADOS_PART INTEGER,
	FOREIGN KEY (ID_PARTICIPANTE_FK) REFERENCES PARTICIPANTE(ID_PARTICIPANTE),
	FOREIGN KEY (ID_EVENTO_FK) REFERENCES EVENTO(ID_EVENTO)
)

--------------------------- VIEWS -----------------------

create view eventos_na_cidade as 
	select * from atividade


---

create view eventos_por_cidade as
  	select * from atividade

----

create view eventos_Por_dia as
select data_inicio_evento as dia, nome_patro as patrocinador, cidade_patro as cidade, estado_patro as estado, descricao_evento as evento, telefone_patro as telefone 
from patrocinador_sec join evento on id_evento = id_evento_fk

----

create view descricao_evento as
select descricao_atv, tipo_atv, horario_atv, cidade_atv, nome_atv
from atividade

------

create view tipo_atividade_cidade as
select tipo_atv, count(tipo_atv), cidade_atv
from atividade
group by tipo_atv, cidade_atv


--------

create view organizador_patrocinador as
select nome_usuario, nome_patro 
from usuario u, promotor p, organiza_evento oe, evento e, patrocinador_sec ps
where u.id_usuario_pk = p.id_usuario_fk and p.id_promotor = oe.id_promotor_fk and oe.id_evento_fk = ps.id_evento_fk and oe.id_evento_fk = e.id_evento  



------

create view usuario_promotor_evento as
select nome_usuario, nome_promotor,  descricao_evento  
from promotor join organiza_evento on id_promotor = id_promotor_fk join evento on id_evento = id_evento_fk join usuario on id_usuario_pk = id_usuario_fk


-------


create view gasto_medio as
select u.nome_usuario as promotor, avg(oe.gasto_org) as gasto_medio
from organiza_evento oe, promotor p, usuario u 
where oe.id_promotor_fk = p.id_promotor and p.id_usuario_fk = u.id_usuario_pk
group by nome_usuario


--------

create view nro_participantes_evento as
select descricao_evento, count(*) as participantes
from participa_evento join evento on id_evento = id_evento_fk
group by descricao_evento
where descricao_evento = input_descricao_evento


-------

CREATE VIEW genero_evento as
select descricao_evento, sexo_us, count(sexo_us)
from participa_evento join evento on id_evento = id_evento_fk join usuario on id_participante_fk = id_usuario_pk 
group by sexo_us, descricao_evento


