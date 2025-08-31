create schema ClinicaOdonto;

create table ClinicaOdonto.Dentista
(
    id_dentista serial primary key,
    nome_completo varchar(100) not null,
    cpf varchar(11) not null unique,
    cro varchar(15) not null unique,
    especialidade varchar(100) not null
);

create table ClinicaOdonto.Bairro (
    id_bairro serial primary key,
    nm_bairro varchar(100)
);

create table ClinicaOdonto.Cidade (
    id_cidade serial primary key,
    nm_cidade varchar(100),
    uf varchar(2)
);

create table ClinicaOdonto.Endereco (
    id_endereco serial primary key,
    logradouro varchar(150),
    id_bairro int references ClinicaOdonto.Bairro(id_bairro),
    id_cidade int references ClinicaOdonto.Cidade(id_cidade)
);

create table ClinicaOdonto.Paciente
(
    id_paciente serial primary key,
    nome_completo varchar(100) not null,
    cpf varchar(11) unique,
    data_nascimento date,
    telefone varchar(20),
    email varchar(100) unique,
	id_endereco int references ClinicaOdonto.Endereco(id_endereco)
);

create table ClinicaOdonto.Consulta
(
    id_consulta serial primary key,
    data_hora timestamp not null,
    descricao_queixa text,
    prescricao text,
    id_paciente int not null,
    id_dentista int not null,
	consulta_realizada boolean,
	
constraint fk_consulta_paciente foreign key (id_paciente)
    references ClinicaOdonto.Paciente (id_paciente)
    on update cascade on delete restrict,

constraint fk_consulta_dentista foreign key (id_dentista)
    references ClinicaOdonto.Dentista (id_dentista)
    on update cascade on delete restrict
);

create table ClinicaOdonto.Consulta_Paciente
(
	idConsulta_Paciente serial primary key,
	id_paciente int references ClinicaOdonto.Paciente(id_paciente),
    id_consulta int references ClinicaOdonto.Consulta(id_consulta)
);

alter table ClinicaOdonto.Paciente
add column historico_consulta int references ClinicaOdonto.Consulta_Paciente(idConsulta_Paciente);


create table ClinicaOdonto.Procedimento
(
    id_procedimento serial primary key,
    nome varchar(100) not null unique,
    descricao text,
    duracao_media int
);


create table ClinicaOdonto.Procedimento_Consulta
(
	idProcedimento_consulta serial primary key,
	id_procedimento int references ClinicaOdonto.Procedimento(id_procedimento),
    id_consulta int references ClinicaOdonto.Consulta(id_consulta)
);

create type semana_enum as enum ('Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado');

create table ClinicaOdonto.Horario_Dentista
(
    id_horario serial primary key,
    id_dentista int references ClinicaOdonto.Dentista(id_dentista),
    dia_semana semana_enum not null,
    hora_inicio time not null,
    hora_fim time
);

create index idx_paciente on
ClinicaOdonto.Paciente(id_paciente);

create index idx_consulta on
ClinicaOdonto.Consulta(id_consulta);

------------------------------------------------------------------------------------------------------------------

insert into ClinicaOdonto.Cidade(nm_cidade, uf)
	values('Campinas', 'SP'),
    ('Manaus', 'AM'),
    ('Florianópolis', 'SC'),
    ('Vitória', 'ES'),
    ('Belém', 'PA'),
    ('Fortaleza', 'CE'),
    ('Goiânia', 'GO'),
    ('Salvador', 'BA'),
    ('Porto Alegre', 'RS'),
    ('São Luís', 'MA');

insert into ClinicaOdonto.Bairro(nm_bairro)
	values('Cambuí'),
    ('Adrianópolis'),
    ('Trindade'),
    ('Jardim Camburi'),
    ('Umarizal'),
    ('Aldeota'),
    ('Setor Bueno'),
    ('Barra'),
    ('Moinhos de Vento'),
    ('Renascença');

insert into ClinicaOdonto.endereco(logradouro, id_bairro, id_cidade)
	values('Rua A', 1, 2),
    ('Rua B', 9, 3),
    ('Rua A', 5, 4),
    ('Rua B', 4, 5),
    ('Rua A', 2, 8),
    ('Rua B', 5, 6),
    ('Rua A', 2, 1),
    ('Rua B', 1, 7),
    ('Rua A', 6, 3),
    ('Rua B', 3, 2);

insert into ClinicaOdonto.Paciente(nome_completo, cpf, data_nascimento, telefone, email, id_endereco)
	values('Ana Beatriz Souza','11111111111', '1992-03-15', '(11)90000-0001', 'ana.souza@email.com', 1),
	('Bruno Carvalho','22222222222', '1988-07-20', '(11)90000-0002', 'bruno.carvalho@email.com', 2),
	('Carla Mendes','33333333333', '1995-01-05', '(11)90000-0003', 'carla.mendes@email.com', 3),
	('Diego Lima','44444444444', '1980-10-30', '(11)90000-0004', 'diego.lima@email.com', 4),
	('Elaine Pires','5555555555', '1999-11-11', '(11)90000-0005', 'elaine.pires@email.com', 5),
	('Felipe Andrade','66666666666', '1991-04-22', '(11)90000-0006', 'felipe.andrade@email.com', 6),
	('Gabriela Nogueira','77777777777', '1984-12-09', '(11)90000-0007', 'gabriela.nog@email.com', 7),
	('Heitor Almeida','88888888888', '1997-08-18', '(11)90000-0008', 'heitor.almeida@email.com', 8),
	('Isabela Rocha','99999999999', '2000-05-25', '(11)90000-0009', 'isabela.rocha@email.com', 9),
	('João Pedro Martins','00000000000', '1993-02-14', '(11)90000-0010', 'joao.martins@email.com', 10);

insert into ClinicaOdonto.Dentista(nome_completo, cpf, cro, especialidade)
	values('Dr. Carlos Figueiredo',  '10110110110', 'CRO-1001', 'Ortodontia'),
	('Dra. Mariana Alves','20220220220', 'CRO-1002', 'Endodontia'),
	('Dr. Pedro Ramos','30330330330', 'CRO-1003', 'Cirurgia'),
	('Dra. Lúcia Ferreira','40440440440', 'CRO-1004', 'Periodontia'),
	('Dr. Rafael Costa','50550550550', 'CRO-1005', 'Implantodontia'),
	('Dra. Sofia Batista','60660660660', 'CRO-1006', 'Clínica Geral'),
	('Dr. André Moreira','70770770770', 'CRO-1007', 'Odontopediatria'),
	('Dra. Patrícia Tavares','80880880880', 'CRO-1008', 'Radiologia'),
	('Dr. Tiago Vasconcelos','90990990990', 'CRO-1009', 'Prótese'),
	('Dra. Renata Queiroz','11122233344', 'CRO-1010', 'Estética');



insert into ClinicaOdonto.consulta(data_hora, descricao_queixa, prescricao, id_paciente, id_dentista)
	values('2025-08-05 09:00', 'Avaliação inicial', 'Escovação 3x/dia', 1, 6),
	('2025-08-06 08:30', 'Aparelho - ajuste', NULL, 2, 1),
	('2025-08-07 10:00', 'Canal molar superior', 'Analgésico por 3 dias', 3, 2),
	('2025-08-08 13:30', 'Extração de siso', 'Gelo e analgésico', 4, 3),
	('2025-08-09 15:00', 'Raspagem subgengival', NULL, 5, 4),
	('2025-08-12 11:00', 'Avaliação para implante', NULL, 6, 5),
	('2025-08-13 09:30', 'Prótese - moldagem', NULL, 7, 9),
	('2025-08-14 16:00', 'Clareamento dental', 'Gel dessensibilizante se necessário', 8, 10),
	('2025-08-15 08:15', 'Radiografia panorâmica', NULL, 9, 8),
	('2025-08-18 14:45', 'Odontopediatria - revisão', 'Higiene supervisionada', 10, 7);

insert into ClinicaOdonto.Procedimento (nome, descricao, duracao_media)
values
	('Limpeza', 'Profilaxia e polimento', 30),
	('Obturação', 'Restauração em resina', 45),
	('Canal', 'Tratamento endodôntico', 90),
	('Implante', 'Implante unitário', 120),
	('Raspagem', 'Raspagem subgengival', 60),
	('Aparelho Ortodôntico', 'Instalação de brackets', 120),
	('Extração', 'Extração simples de dente', 40),
	('Clareamento', 'Clareamento em consultório', 60),
	('Prótese', 'Confeção de prótese fixa', 120),
	('Radiografia Panorâmica', 'Exame radiográfico completo', 20);

insert into ClinicaOdonto.Procedimento_Consulta (id_consulta, id_procedimento)
values
	(1, 1),  
	(2, 6),
	(3, 3),  
	(4, 7),  
	(5, 5),  
	(6, 4),  
	(7, 9),  
	(8, 8),  
	(9, 10),
	(10, 1); 

insert into ClinicaOdonto.Horario_Dentista (id_dentista, dia_semana, hora_inicio, hora_fim)
values
	(1, 'Segunda', '09:00', '12:00'),
	(1, 'Quarta', '14:00', '18:00'),
	(2, 'Terca', '09:00', '13:00'),
	(2, 'Quinta', '13:00', '17:00'),
	(3, 'Segunda', '10:00', '13:00'),
	(3, 'Quinta', '09:00', '12:00'),
	(4, 'Terca', '14:00', '18:00'),
	(5, 'Quarta', '08:00', '12:00'),
	(6, 'Segunda', '09:00', '12:00'),
	(7, 'Quinta', '09:00', '12:00');

------------------------------------------

update ClinicaOdonto.Paciente
set nome_completo = 'Bernardo Beatriz Souza'
where nome_completo = 'Ana Beatriz Souza';

update ClinicaOdonto.Paciente
set nome_completo = 'Carlos Mendes'
where nome_completo = 'Carla Mendes';

update ClinicaOdonto.Paciente
set nome_completo = 'Bruna Carvalho'
where nome_completo = 'Bruno Carvalho';

------------------------------------------

delete from ClinicaOdonto.Horario_Dentista
where hora_fim = '18:00';

delete from ClinicaOdonto.Horario_Dentista
where hora_fim = '13:00';

delete from ClinicaOdonto.Horario_Dentista
where hora_fim = '17:00';

------------------------------------------
--1a
select den.especialidade,
count(con.id_consulta) as total
from ClinicaOdonto.Dentista den
left join ClinicaOdonto.consulta as con
on con.id_dentista = den.id_dentista
group by den.especialidade
order by total;

------------------------------------------
--2a
select den.nome_completo,
count(con.id_consulta) as total
from ClinicaOdonto.Dentista den
left join ClinicaOdonto.Consulta con
on con.id_dentista = den.id_dentista
group by den.nome_completo
order by total desc;

------------------------------------------
--3a
select pac.nome_completo,
count(con.id_consulta) as total
from ClinicaOdonto.Paciente pac
left join ClinicaOdonto.Consulta con
on con.id_paciente = pac.id_paciente
group by pac.nome_completo
order by total desc;

------------------------------------------
--4a
create view clinicaodonto.vw_consulta as
    select 
        con.id_consulta,
        pac.nome_completo as nome_paciente,
        den.nome_completo as nome_dentista,
        con.data_hora,
        proc.nome
from ClinicaOdonto.consulta as con
left join ClinicaOdonto.Paciente as pac on pac.id_paciente = con.id_consulta
left join ClinicaOdonto.Dentista as den on den.id_dentista = con.id_consulta
left join ClinicaOdonto.Procedimento as proc on pac.id_paciente = proc.id_procedimento
order by con.data_hora desc;

------------------------------------------

--5a
select avg(total_consultas) as media_por_dentista
from (SELECT COUNT(con.id_consulta) as total_consultas
from ClinicaOdonto.Dentista as den
left join ClinicaOdonto.Consulta as con on con.id_dentista = den.id_dentista
group by den.id_dentista) as subconsulta;

