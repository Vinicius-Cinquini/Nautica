---- Banco de Dados do Departamento Náutico do Iate Clube Jardim Guanabara -----
---- Vinicius Mascarenhas
---- Dezembro/2017


--------------------------------------------------------------------------------
----------------------------- CRIAÇÃO DAS TABELAS ------------------------------
--------------------------------------------------------------------------------

create table associados
(
    matricula varchar (10) not null,
    nome varchar (60) not null,
    ultimo_pagamento date, --not null
    email varchar (40),
    endereco varchar (100), -- not null,
    cep varchar (8), -- not null,
   
    primary key (matricula)
);

create table telefones
(
    associado varchar (10) not null,
    ddd varchar (2),
    telefone varchar (15) not null,
   
    primary key (associado, telefone),
    foreign key (associado) references associados(matricula)
);

create table areas
(
    nome varchar (20) not null,
   
    primary key (nome)
);

create table embarcacoes
(
    nome varchar (30) not null,
    tipo varchar (30), --not null,
    matricula varchar (10) not null,
    marinheiro varchar (60),
    --area varchar (20) not null,
    tamanho int,
    boca number,
    calado number,
    peso int,
    n_motores int,
    marca_motores varchar (30),
    combustivel varchar (9),
   
    primary key (nome),
    foreign key (tipo) references tiposDeEmbarcacoes(nome),
    foreign key (matricula) references associados(matricula),
    --foreign key (area) references areas(nome),
   
    constraint VerificarCombustivel check
    (
      combustivel='Gasolina' or
      combustivel='Diesel'
    )
);

create sequence alocacaoDeVagas;

create table localizacao
(
    alocacao int,
    embarcacao varchar (30) not null,
    area varchar (20) not null,
    vaga int,
   
    primary key (alocacao),
    foreign key (area) references areas(nome),
    foreign key (embarcacao) references embarcacoes(nome)
);

create table vagasPorPier
(
  pier varchar (20) not null,
  nVagas int not null,
  comprimento int not null, -- pés
  largura number not null, -- metros
  
  primary key (pier),
  foreign key (pier) references areas(nome)
);

create table tiposDeEmbarcacoes
(
    nome varchar (30) not null,
   
    primary key (nome)
);

create table vagas
(
  pier varchar (20) not null,
  vaga int not null,
  proprietario varchar (10),
  embarcacao varchar (30),

  primary key (pier, vaga),
  foreign key (proprietario) references associados(matricula),
  foreign key (embarcacao) references embarcacoes(nome)
);

--------------------------------------------------------------------------------
----------------------- POPULAÇÃO DAS TABELAS DE LOOKUP ------------------------
--------------------------------------------------------------------------------

insert into areas (nome) values ('Pier A');
insert into areas (nome) values ('Pier B');
insert into areas (nome) values ('Pier C');
--insert into areas (nome) values ('Pier D'); -- ???
insert into areas (nome) values ('Pier E');
insert into areas (nome) values ('Pier F');
insert into areas (nome) values ('Pier G');
insert into areas (nome) values ('Galpão I');
insert into areas (nome) values ('Galpão II');
insert into areas (nome) values ('Galpão III');
insert into areas (nome) values ('Pátio');
insert into areas (nome) values ('Saiu a passeio');
insert into areas (nome) values ('Retirada do clube');
insert into areas (nome) values ('Desconhecida');
insert into areas (nome) values ('Cabide');

insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier A', 19, 51, 5.0); -- Diferença entre esquerdo e direito!
insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier B', 30, 40, 4.0);
insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier C', 26, 40, 4.0);
--insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier D', 0, 0, 0); -- Não existe esse pier?
insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier E', 18, 51, 5.0);
insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier F', 30, 40, 4.0);
insert into vagasPorPier (pier, nVagas, comprimento, largura) values ('Pier G', 19, 40, 4.0);

insert into tiposDeEmbarcacoes (nome) values ('Veleiro');
insert into tiposDeEmbarcacoes (nome) values ('Lancha');
insert into tiposDeEmbarcacoes (nome) values ('Jet-ski');
insert into tiposDeEmbarcacoes (nome) values ('Saveiro');
insert into tiposDeEmbarcacoes (nome) values ('Traineira');
insert into tiposDeEmbarcacoes (nome) values ('Escuna');

--------------------------------------------------------------------------------
----------- TESTES DE INTEGRIDADE REFERENCIAL, DE DADOS E DE DOMÍNIO -----------
--------------------------------------------------------------------------------

-- Testando erro de inserção no tipo de embarcação.
-- 'Bote' não é um tipo de acordo com a tabela tiposDeEmbarcacoes, portanto TEM que dar erro.
insert into embarcacoes (nome, tipo, matricula, marinheiro, tamanho, boca, calado, peso, n_motores, marca_motores, combustivel)
values ('Eight Oceans', 'Bote', '1141', 'Luiz', 55, 4.2, 1.9, 24000, 1, 'Mercedes Benz', 'Diesel');

-- Testando erro de inserção no combustível.
-- 'Álcool' não é um valor autorizado pela restrição verificarCombustivel, portanto TEM que dar erro.
insert into embarcacoes (nome, tipo, matricula, marinheiro,tamanho, boca, calado, peso, n_motores, marca_motores, combustivel)
values ('Nine Oceans', 'Escuna', '1141', 'Luiz', 55, 4.2, 1.9, 24000, 1, 'Mercedes Benz', 'Álcool');

-- Testando erro de inserção na matrícula de associado.
-- '1142' não é uma matrícula registrada na tabela associados, portanto TEM que dar erro.
insert into embarcacoes (nome, tipo, matricula, marinheiro, tamanho, boca, calado, peso, n_motores, marca_motores, combustivel)
values ('Ten Oceans', 'Jet-ski', '1142', null, null, null, null, null, null, null, null);

--------------------------------------------------------------------------------
--------------- POPULAÇÃO DAS TABELAS COM OS DADOS DO MUNDO REAL ---------------
--------------------------------------------------------------------------------

insert into associados (nome, matricula) values ('Jaime Luis Patricio Fernandes','1718');
insert into associados (nome, matricula) values ('Pedro Rangel da Silva Filho','-7');
insert into associados (nome, matricula) values ('Alex Marlon Leandro de Souza','300054');
insert into associados (nome, matricula) values ('Eduardo Costa dos Santos','300048');
insert into associados (nome, matricula) values ('João Bernardo G. Aversa','300340');
insert into associados (nome, matricula) values ('Edson Fernandes Mascarenhas','1141');
insert into associados (nome, matricula) values ('Wagner Luiz Pereira Lima','205766');
insert into associados (nome, matricula) values ('Hans Stefan Schelble','600046');
insert into associados (nome, matricula) values ('Antonio Carlos Fernandes Dias','1011');
insert into associados (nome, matricula) values ('Jaime Maltz','300085');
insert into associados (nome, matricula) values ('Ricardo Valente Carneiro Dias','300318');
insert into associados (nome, matricula) values ('ICJG','-1');
insert into associados (nome, matricula) values ('Hatisaburo Masuda','1837');
insert into associados (nome, matricula) values ('Fernando Antonio Holanda Ramos','1769');
insert into associados (nome, matricula) values ('Sergio Martins Xavier','1419');
insert into associados (nome, matricula) values ('Fabiano Gomes Delfino','300420');
insert into associados (nome, matricula) values ('Antenor Alves de Magalhães','700032');
insert into associados (nome, matricula) values ('Luiz Antonio Fernandes de Andrade','2074');
insert into associados (nome, matricula) values ('Jaime Luiz Patricio Fernandes','1718');
insert into associados (nome, matricula) values ('Rosane Delgado Cortes','1199');
insert into associados (nome, matricula) values ('Fernando Dias Garcia','300166');
insert into associados (nome, matricula) values ('Leonard Werner R. Von Adamovich','2274');
insert into associados (nome, matricula) values ('Daniel Melo T. de Souza','300329');
insert into associados (nome, matricula) values ('Pedro Souza da Silva','700061');
insert into associados (nome, matricula) values ('Marcus Vinicius G. de Moraes Correa','50139');
insert into associados (nome, matricula) values ('Ronaldo Barbosa Nunes','205734');
insert into associados (nome, matricula) values ('Gunther Georg Schuh','1776');
insert into associados (nome, matricula) values ('Adriano savastano de Sant´anna','300179');
insert into associados (nome, matricula) values ('José Eduardo da Silva Berrezo','300333');
insert into associados (nome, matricula) values ('Rafael Silva Crispim','300210');
insert into associados (nome, matricula) values ('César Vallaperde','2287');
insert into associados (nome, matricula) values ('Marcio José Alves Lavouras','205199');
insert into associados (nome, matricula) values ('Paulo Cesar Fonseca Viana','300001');
insert into associados (nome, matricula) values ('Mauricio Sapoznikow','300058');
insert into associados (nome, matricula) values ('Edilson josé Dutra','300139');
insert into associados (nome, matricula) values ('Rodrigo Motta da Silva','300459');
insert into associados (nome, matricula) values ('Décio Magioli Maia','1016');
insert into associados (nome, matricula) values ('Milos Moreira Vohryzek','300034');
insert into associados (nome, matricula) values ('Alexandre Bender de Frias','1308');
insert into associados (nome, matricula) values ('Joaquim Saveira dos Reis','6582');
insert into associados (nome, matricula) values ('Ricardo Valente Carneiro Dias','300318');
insert into associados (nome, matricula) values ('Mauro Eduardo Ramos Brugger','1621');
insert into associados (nome, matricula) values ('Sidney Cesar Silva Guerra','300093');
insert into associados (nome, matricula) values ('Edmundo Roberto dos Santos Costa','1666');
insert into associados (nome, matricula) values ('Eduardo Alves da S. de Paula Camargo','300153');
insert into associados (nome, matricula) values ('Luiz Mario M. de Resende','50018');
insert into associados (nome, matricula) values ('Jaime Maltz','300085');
insert into associados (nome, matricula) values ('Wagner  Montes','-2');
insert into associados (nome, matricula) values ('Norton Cerveira Maia','50028');
insert into associados (nome, matricula) values ('Mauricio Martinez Gaspar','400244');
insert into associados (nome, matricula) values ('Gilson da Silva Soares','2070');
insert into associados (nome, matricula) values ('Ricardo Riberio Romano','400054');
insert into associados (nome, matricula) values ('Agostinho teixeira ','1612');
insert into associados (nome, matricula) values ('Rolf Riegger Junior','300201');
insert into associados (nome, matricula) values ('Fernando Antonio Holanda Ramos','1769');
insert into associados (nome, matricula) values ('Otto Rodrigues','449');
insert into associados (nome, matricula) values ('Carlos Augusto Samary da Silva','204311');
insert into associados (nome, matricula) values ('Rodolfo Dias Bella','400293');
insert into associados (nome, matricula) values ('José Carlos Piolli Jr.','400213');
insert into associados (nome, matricula) values ('Carlos Albino Sigilião Trravessa','300046');
insert into associados (nome, matricula) values ('Muricy Domingues Junior','300080');
insert into associados (nome, matricula) values ('Sergio Antonio Olilveira da Silva','300168');
insert into associados (nome, matricula) values ('Luis Fernando de Souza Pinto Teixeira','300206');
insert into associados (nome, matricula) values ('Luiz Claudio Cunha Gonzaga','600262');
insert into associados (nome, matricula) values ('Aloísio Joaquim da Silva ','300374');
insert into associados (nome, matricula) values ('Leandro Lima Pimentel','2913');
insert into associados (nome, matricula) values ('Flávio Farah Falcão','381');
insert into associados (nome, matricula) values ('Paulo Batista Matias','600054');
insert into associados (nome, matricula) values ('Paulo Cesar Costa Oliveira','1134');
insert into associados (nome, matricula) values ('Ricardo Valente Carneiro Dias','300318');
insert into associados (nome, matricula) values ('Wilson Peireira dos Santos ','200769');
insert into associados (nome, matricula) values ('Fernando P. dos Santos Filho','204065');
insert into associados (nome, matricula) values ('Fabiano Narduchi de Paula','400052');
insert into associados (nome, matricula) values ('Marcelo da Costa Dominguez','300021');
insert into associados (nome, matricula) values ('Roberto Francisco souza Oliveira','300147');
insert into associados (nome, matricula) values ('Bruno José Cerqueira Souza','300160');
insert into associados (nome, matricula) values ('João Maria da Cruz Ferreira ','300025');
insert into associados (nome, matricula) values ('Dionysio da Costa Amaro Junior','300143');
insert into associados (nome, matricula) values ('Luiz Faustino junior','300028');
insert into associados (nome, matricula) values ('José Carlos R. Baima','300159');
insert into associados (nome, matricula) values ('Carlos Antonio P. C. guedes','2209');
insert into associados (nome, matricula) values ('Antonio Carlos de barros Neiva','700152');
insert into associados (nome, matricula) values ('José Leonardo Teixeira de Carvalho','50125');
insert into associados (nome, matricula) values ('Cilon Ting','300056');
insert into associados (nome, matricula) values ('Jean Claude Marie G. Schotte','400101');
insert into associados (nome, matricula) values ('Roberto Jardim Mascarenhas','50141');
insert into associados (nome, matricula) values ('Gilberto Paes França','204517');
insert into associados (nome, matricula) values ('Felipe Koeller R. Vieira','400271');
insert into associados (nome, matricula) values ('Renato Sérgio Mazzei ','300082');
insert into associados (nome, matricula) values ('Bruno José Cerqueira Souza','300160');
insert into associados (nome, matricula) values ('Gustavo Pereira Vaitsman','400282');
insert into associados (nome, matricula) values ('Francisco Antonio Mendes Filho','700008');
insert into associados (nome, matricula) values ('Edmundo Roberto dos Santos Costa','1666');
insert into associados (nome, matricula) values ('Sandoval Borges de O. Filho','300042');
insert into associados (nome, matricula) values ('Jorge Monteiro Lins ','641');
insert into associados (nome, matricula) values ('Isabel Cristina Machado Leal','864');
insert into associados (nome, matricula) values ('José Ferreira da Silva Filho','1851');
insert into associados (nome, matricula) values ('Marli Nascimento Espindola ','2833');
insert into associados (nome, matricula) values ('Francisco Antonio Mendes Filho','700008');
insert into associados (nome, matricula) values ('Roberto Simões Ferreira','1084');
insert into associados (nome, matricula) values ('José Ferreira David ','1784');
insert into associados (nome, matricula) values ('Rodrigo Araujo Severo de barros','104973');
insert into associados (nome, matricula) values ('Antenor Alves de Magalhães','700032');
insert into associados (nome, matricula) values ('Claudio de Carvalho Rangel','700048');
insert into associados (nome, matricula) values ('Marcio José Frahia','300035');
insert into associados (nome, matricula) values ('Wilton Barbosa Pinho','300306');
insert into associados (nome, matricula) values ('Edson Fernandes Mascarenhas','1141');
insert into associados (nome, matricula) values ('João de Deus Moreira Dopazio','3084');
insert into associados (nome, matricula) values ('Jonas da Mata Ribeiro','205330');
insert into associados (nome, matricula) values ('Moises Bengaly','400063');
insert into associados (nome, matricula) values ('Arthur Nunes Guimarães ','300069');
insert into associados (nome, matricula) values ('Alex Arruda ','300433');
insert into associados (nome, matricula) values ('Pedro Luan Rocha Roca Ortega','700166');
insert into associados (nome, matricula) values ('João Barbosa Orlandine','2089');
insert into associados (nome, matricula) values ('José Frenk','-3');
insert into associados (nome, matricula) values ('Rui Jorge Meireles Cardoso','700040');
insert into associados (nome, matricula) values ('Cacau Cotta','-4');
insert into associados (nome, matricula) values ('Marcos Morgen de Campos ','300045');
insert into associados (nome, matricula) values ('Carlos R. F. da Silva','300036');
insert into associados (nome, matricula) values ('Paulo Cesar Perri Celli','300027');
insert into associados (nome, matricula) values ('Leonardo Ponse da Motta','300224');
insert into associados (nome, matricula) values ('Robison Miguel do Nascimento','300218');
insert into associados (nome, matricula) values ('Tirso Alexandrino P. de Melo','300202');
insert into associados (nome, matricula) values ('Bruno Matos Bonorino','300165');
insert into associados (nome, matricula) values ('Paulo Cesar Costa Oliveira','1134');
insert into associados (nome, matricula) values ('Anselmo Suhett de Almeida','300155');
insert into associados (nome, matricula) values ('Luis Fernando F. de Oliveira ','300411');
insert into associados (nome, matricula) values ('Flávia de Oliveira Teixeira','1612');
insert into associados (nome, matricula) values ('Jorge Burlamaque Soares','300088');
insert into associados (nome, matricula) values ('Mauro Martins da Costa ','1878');
insert into associados (nome, matricula) values ('Jaques Antonio M. Di Calafiiori','801087');
insert into associados (nome, matricula) values ('Luiz Eduardo Piovani Luz Pimenta','300065');
insert into associados (nome, matricula) values ('Miguel Arcanjo Filho','300214');
insert into associados (nome, matricula) values ('Marcio José Alves Lavouras','205199');
insert into associados (nome, matricula) values ('Edson Fernandes Mascarenhas','1141');
insert into associados (nome, matricula) values ('Marcos Lopes Dias','700036');
insert into associados (nome, matricula) values ('Alessandro Serra Ramos','300310');
insert into associados (nome, matricula) values ('Sergio Alves de Oliveira','300083');
insert into associados (nome, matricula) values ('Carlos Levin Zloczower','2269');
insert into associados (nome, matricula) values ('Silvano de Souza Santos','300266');
insert into associados (nome, matricula) values ('Fabio Rocha da Silva ','400136');
insert into associados (nome, matricula) values ('Julio Cesar da Gama Apolinário','600065');
insert into associados (nome, matricula) values ('Leandro Gozalez Lima de Souza','300418');
insert into associados (nome, matricula) values ('Rodrigo Araujo Severo de barros','104973');
insert into associados (nome, matricula) values ('Cellio Bernardo Pinheiro','483');
insert into associados (nome, matricula) values ('Alex Marlon Leandro de Souza','300054');
insert into associados (nome, matricula) values ('UFRJ','-5');
insert into associados (nome, matricula) values ('Hans Guenther Dogs','101670');
insert into associados (nome, matricula) values ('Fernando Cardoso de Araujo','576');
insert into associados (nome, matricula) values ('Marcius da Silva Almeida','700149');
insert into associados (nome, matricula) values ('Carlos Levin Zloczower','2269');
insert into associados (nome, matricula) values ('UFRJ','-5');
insert into associados (nome, matricula) values ('Daniel Carneiro Ferreira Alves','100053');
insert into associados (nome, matricula) values ('Hans Guenther Dogs','101670');
insert into associados (nome, matricula) values ('Marcos dos Santos Teixeira','300238');
insert into associados (nome, matricula) values ('Helio Capella Velasco','1345');
insert into associados (nome, matricula) values ('Claudio Cesar de Medeiros ','2620');
insert into associados (nome, matricula) values ('Cesar Carneiro Duarte Feliciano','300288');
insert into associados (nome, matricula) values ('José Antunes Rodrigues Ferreira','787');
insert into associados (nome, matricula) values ('Maximiliano Moreno Lima','300241');
insert into associados (nome, matricula) values ('César Vallaperde','2287');
insert into associados (nome, matricula) values ('Randolpho Allemand Froes','300315');
insert into associados (nome, matricula) values ('Marcus Vinicius Deritos Grego','2741');
insert into associados (nome, matricula) values ('Ricardo Valente Carneiro Dias','3000318');
insert into associados (nome, matricula) values ('Carlos Henrique G. Siestrup','1451');
insert into associados (nome, matricula) values ('Carlos Henrique G. Siestrup','1451');
insert into associados (nome, matricula) values ('Paulo Roberto Santos de Oliveira','300055');
insert into associados (nome, matricula) values ('Marcelino Taveira Miranda ','650');
insert into associados (nome, matricula) values ('Hans Guenther Dogs','101670');
insert into associados (nome, matricula) values ('Fabio Pinto Coelho','300397');
insert into associados (nome, matricula) values ('Leandro Botelho de Queiroz','300402');
insert into associados (nome, matricula) values ('Jaime Bosges Stor','1611');
insert into associados (nome, matricula) values ('Ivan Vianna Teixeira','1487');
insert into associados (nome, matricula) values ('Nilo Gerbasse','-6');

insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Antonio', 'Cabide', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Décio', 'Cabide', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Tangarth II', 'Cabide', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Meia  Noite III', 'Cabide', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Flamar II', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Mad Dog', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Alcova', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Les Must', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Freendom Bay Rio', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Meia Noite 2', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Master Ship II', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Aleric', 'Galpão I', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Som das Águas', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Arruaça V', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Velasco´s I', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Lis', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Z Z', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Flalaine', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Druida', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Estrela do Mar XII', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Anah', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Mareada I', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Vegas II', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Jane Cat', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Guanabara Mar', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Catarinas', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Nonoca', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sylvia J', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Renatinha V', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Vida Dura', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Aversa', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Scriba', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Ildamar II', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Garça Ceumar - Luige', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Mangalui', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Calan', 'Galpão II', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Machado', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Beirute', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Letisiem', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Su Necy I', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Gabriell', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Jadis', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Astronic', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'El Cid', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Pescare', 'Galpão III', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Fafner', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Plano B', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Icthus', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sky Nalhas', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Becca', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Alin', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Winner III', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Diver Boat', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Saudade é Essa', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Miaketi', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Fram II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Marjos III', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Bib´s', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Orlugara', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Luiza 2000', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Big Boss I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Brinquedo', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Winner', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Marra-Cash', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Hidroshow', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Nabileque', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Dona Carla', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Elithimar', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Belinha', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Lero 5', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sy Cat', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Tiara I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Zuca Mar', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'MG Special', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Scooby´s', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Johnny Boy', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Lumabemel', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Santo Grau', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Caridade', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Angriff', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Caipirinha II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Juniba 3', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Kamanga', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Robalão XX', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'LF Junior', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Don Vitto', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Marbeth', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Pansy', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Mambanegra', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Partisan', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Green', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Aventureiro II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Aruí', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sexy Boy', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Carlos I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sunset Brasil II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Grand Champ Enzo', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Arie', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Electra IV', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Dr. Dos Mares', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Cariado II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Kike', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Keep Calm III', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'El Campeador', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Marokau', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sniper', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Brac I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Guapo', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sol e Brisa', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Crispim I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Rosa dos mares', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Uaian', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Seven', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'No Stress', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sunset I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Wind Kiss', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Allzira I', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Dr. Dias', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Barão Vermelho', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Haeven', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Zig', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Yuti das Águas', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Star Fish', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Balada Carioca', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Opos II', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Dona Madame', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Jabulani 2A', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Fishionado', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Nathy e Kathy', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Siri da Ilha', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Gabiluxa', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Guto', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Andaluz', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Schnit´s', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Blue Moon Rio', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Punisher 2', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Bravo', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Liberdade', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Ortergas', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Xumbinho', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Ouromar', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sizigia', 'Pátio', null);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Capitain Morgan', 'Pier A', 4);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Tethys', 'Pier A', 2);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Fish Hunter I', 'Pier A', 4);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'French Kiss', 'Pier B', 11);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Surf Adventure', 'Pier B', 12);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'As Marujas', 'Pier B', 18);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Miss Carol', 'Pier B', 24);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Seven Oceans', 'Pier B', 29);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, '25 de Janeiro', 'Pier B', 5);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Wally I', 'Pier B', 5);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Tucunaré', 'Pier B', 9);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Teimosia I', 'Pier B', 1);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Teimosia I', 'Pier B', 2);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Cabeça de Vento', 'Pier C', 10);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'O Maestro', 'Pier C', 12);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'magio I', 'Pier C', 14);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Saba de Ar', 'Pier C', 17);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Maionese', 'Pier C', 18);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Lady Ruth', 'Pier C', 2);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Show X', 'Pier C', 2);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Magia 200', 'Pier C', 22);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Hawk III', 'Pier C', 24);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sexy Girl', 'Pier C', 24);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Só Faraway', 'Pier C', 25);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'De Frias', 'Pier C', 26);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Spirit Sport Fishing', 'Pier C', 4);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Catavento X', 'Pier C', 6);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Tuna IX', 'Pier C', 7);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Kiwimar', 'Pier C', 9);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Claudia the Eagle V', 'Pier C', 15);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sagapo IV', 'Pier E', 2);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Sagapo IV', 'Pier E', 3);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Netuno Ultraleve', 'Pier F', 30);
insert into localizacao (alocacao, embarcacao, area, vaga) values (alocacaoDeVagas.nextval, 'Lundu', 'Pier F', 5);

insert into embarcacoes (nome, tamanho, matricula) values ('tangarth II', 24, '-7');
insert into embarcacoes (nome, tamanho, matricula) values ('Calan', 17, '-6');
insert into embarcacoes (nome, tamanho, matricula) values ('Sizigia', 20, '-5');
insert into embarcacoes (nome, tamanho, matricula) values ('Tethys', 32, '-5');
insert into embarcacoes (nome, tamanho, matricula) values ('Pescare', 31, '-4');
insert into embarcacoes (nome, tamanho, matricula) values ('Ouromar', 22, '-3');
insert into embarcacoes (nome, tamanho, matricula) values ('El Cid', 44, '-2');
insert into embarcacoes (nome, tamanho, matricula) values ('Aleric', 16, '-1');
insert into embarcacoes (nome, tamanho, matricula) values ('Hawk III', 33, '381');
insert into embarcacoes (nome, tamanho, matricula) values ('Fafner', 20, '449');
insert into embarcacoes (nome, tamanho, matricula) values ('Som das Águas', 26, '483');
insert into embarcacoes (nome, tamanho, matricula) values ('Tucunaré', 32, '576');
insert into embarcacoes (nome, tamanho, matricula) values ('magio I', 33, '641');
insert into embarcacoes (nome, tamanho, matricula) values ('Plano B', 27, '650');
insert into embarcacoes (nome, tamanho, matricula) values ('25 de Janeiro', 40, '787');
insert into embarcacoes (nome, tamanho, matricula) values ('Machado', 30, '864');
insert into embarcacoes (nome, tamanho, matricula) values ('Antonio', 14, '1011');
insert into embarcacoes (nome, tamanho, matricula) values ('Décio', 14, '1016');
insert into embarcacoes (nome, tamanho, matricula) values ('Mad Dog', 22, '1084');
insert into embarcacoes (nome, tamanho, matricula) values ('Icthus', 27, '1134');
insert into embarcacoes (nome, tamanho, matricula) values ('Sky Nalhas', 23, '1134');
insert into embarcacoes (nome, tamanho, matricula) values ('Arruaça V', 14, '1141');
insert into embarcacoes (nome, tamanho, matricula) values ('Netuno Ultraleve', 38, '1141');
insert into embarcacoes (nome, tamanho, matricula) values ('Seven Oceans', 44, '1141');
insert into embarcacoes (nome, tamanho, matricula) values ('Becca', 22, '1199');
insert into embarcacoes (nome, tamanho, matricula) values ('De Frias', 41, '1308');
insert into embarcacoes (nome, tamanho, matricula) values ('Velasco´s I', 22, '1345');
insert into embarcacoes (nome, tamanho, matricula) values ('Alin', 16, '1419');
insert into embarcacoes (nome, tamanho, matricula) values ('Winner III', 14, '1451');
insert into embarcacoes (nome, tamanho, matricula) values ('Diver Boat', 27, '1451');
insert into embarcacoes (nome, tamanho, matricula) values ('Lis', 26, '1487');
insert into embarcacoes (nome, tamanho, matricula) values ('Z Z', 16, '1611');
insert into embarcacoes (nome, tamanho, matricula) values ('Flalaine', 22, '1612');
insert into embarcacoes (nome, tamanho, matricula) values ('Saudade é Essa', 17, '1612');
insert into embarcacoes (nome, tamanho, matricula) values ('Druida', 17, '1621');
insert into embarcacoes (nome, tamanho, matricula) values ('Estrela do Mar XII', 27, '1666');
insert into embarcacoes (nome, tamanho, matricula) values ('Miaketi', 27, '1666');
insert into embarcacoes (nome, tamanho, matricula) values ('As Marujas', 38, '1718');
insert into embarcacoes (nome, tamanho, matricula) values ('Beirute', 38, '1718');
insert into embarcacoes (nome, tamanho, matricula) values ('Alcova', 22, '1769');
insert into embarcacoes (nome, tamanho, matricula) values ('Fram II', 32, '1769');
insert into embarcacoes (nome, tamanho, matricula) values ('Capitain Morgan', 48, '1776');
insert into embarcacoes (nome, tamanho, matricula) values ('Marjos III', 24, '1784');
insert into embarcacoes (nome, tamanho, matricula) values ('Anah', 14, '1837');
insert into embarcacoes (nome, tamanho, matricula) values ('Mareada I', 27, '1851');
insert into embarcacoes (nome, tamanho, matricula) values ('Só Faraway', 35, '1878');
insert into embarcacoes (nome, tamanho, matricula) values ('Flamar II', 33, '2070');
insert into embarcacoes (nome, tamanho, matricula) values ('Bib´s', 16, '2074');
insert into embarcacoes (nome, tamanho, matricula) values ('Orlugara', 27, '2089');
insert into embarcacoes (nome, tamanho, matricula) values ('Luiza 2000', 17, '2209');
insert into embarcacoes (nome, tamanho, matricula) values ('Sexy Girl', 38, '2269');
insert into embarcacoes (nome, tamanho, matricula) values ('Tuna IX', 31, '2269');
insert into embarcacoes (nome, tamanho, matricula) values ('Big Boss I', 20, '2274');
insert into embarcacoes (nome, tamanho, matricula) values ('Claudia the Eagle V', 40, '2287');
insert into embarcacoes (nome, tamanho, matricula) values ('Brinquedo', 29, '2287');
insert into embarcacoes (nome, tamanho, matricula) values ('Vegas II', 23, '2620');
insert into embarcacoes (nome, tamanho, matricula) values ('Winner', 22, '2741');
insert into embarcacoes (nome, tamanho, matricula) values ('Marra-Cash', 26, '2833');
insert into embarcacoes (nome, tamanho, matricula) values ('Hidroshow', 28, '2913');
insert into embarcacoes (nome, tamanho, matricula) values ('Nabileque', 20, '3084');
insert into embarcacoes (nome, tamanho, matricula) values ('Dona Carla', 27, '6582');
insert into embarcacoes (nome, tamanho, matricula) values ('Elithimar', 19, '50018');
insert into embarcacoes (nome, tamanho, matricula) values ('Fish Hunter I', 50, '50028');
insert into embarcacoes (nome, tamanho, matricula) values ('Lady Ruth', 32, '50125');
insert into embarcacoes (nome, tamanho, matricula) values ('Belinha', 21, '50139');
insert into embarcacoes (nome, tamanho, matricula) values ('Lero 5', 17, '50141');
insert into embarcacoes (nome, tamanho, matricula) values ('Tangarth II', 14, '100053');
insert into embarcacoes (nome, tamanho, matricula) values ('Sy Cat', 23, '101670');
insert into embarcacoes (nome, tamanho, matricula) values ('Tiara I', 27, '101670');
insert into embarcacoes (nome, tamanho, matricula) values ('Zuca Mar', 23, '101670');
insert into embarcacoes (nome, tamanho, matricula) values ('MG Special', 14, '104973');
insert into embarcacoes (nome, tamanho, matricula) values ('Scooby´s', 19, '104973');
insert into embarcacoes (nome, tamanho, matricula) values ('Johnny Boy', 26, '200769');
insert into embarcacoes (nome, tamanho, matricula) values ('Jane Cat', 23, '204065');
insert into embarcacoes (nome, tamanho, matricula) values ('Guanabara Mar', 29, '204311');
insert into embarcacoes (nome, tamanho, matricula) values ('Lumabemel', 23, '204517');
insert into embarcacoes (nome, tamanho, matricula) values ('Catarinas', 27, '205199');
insert into embarcacoes (nome, tamanho, matricula) values ('Santo Grau', 23, '205199');
insert into embarcacoes (nome, tamanho, matricula) values ('Nonoca', 23, '205330');
insert into embarcacoes (nome, tamanho, matricula) values ('Caridade', 17, '205734');
insert into embarcacoes (nome, tamanho, matricula) values ('Angriff', 23, '205766');
insert into embarcacoes (nome, tamanho, matricula) values ('Caipirinha II', 28, '300001');
insert into embarcacoes (nome, tamanho, matricula) values ('Juniba 3', 26, '300021');
insert into embarcacoes (nome, tamanho, matricula) values ('Kamanga', 22, '300025');
insert into embarcacoes (nome, tamanho, matricula) values ('Robalão XX', 20, '300027');
insert into embarcacoes (nome, tamanho, matricula) values ('LF Junior', 29, '300028');
insert into embarcacoes (nome, tamanho, matricula) values ('Don Vitto', 29, '300034');
insert into embarcacoes (nome, tamanho, matricula) values ('Marbeth', 23, '300035');
insert into embarcacoes (nome, tamanho, matricula) values ('Pansy', 22, '300036');
insert into embarcacoes (nome, tamanho, matricula) values ('Mambanegra', 27, '300042');
insert into embarcacoes (nome, tamanho, matricula) values ('Partisan', 24, '300045');
insert into embarcacoes (nome, tamanho, matricula) values ('Green', 31, '300046');
insert into embarcacoes (nome, tamanho, matricula) values ('Aventureiro II', 25, '300048');
insert into embarcacoes (nome, tamanho, matricula) values ('Aruí', 24, '300054');
insert into embarcacoes (nome, tamanho, matricula) values ('Sagapo IV', 33, '300054');
insert into embarcacoes (nome, tamanho, matricula) values ('Sexy Boy', 28, '300055');
insert into embarcacoes (nome, tamanho, matricula) values ('Letisiem', 37, '300056');
insert into embarcacoes (nome, tamanho, matricula) values ('Carlos I', 21, '300058');
insert into embarcacoes (nome, tamanho, matricula) values ('Sunset Brasil II', 29, '300065');
insert into embarcacoes (nome, tamanho, matricula) values ('O Maestro', 38, '300069');
insert into embarcacoes (nome, tamanho, matricula) values ('Grand Champ Enzo', 26, '300080');
insert into embarcacoes (nome, tamanho, matricula) values ('Miss Carol', 29, '300082');
insert into embarcacoes (nome, tamanho, matricula) values ('Su Necy I', 38, '300083');
insert into embarcacoes (nome, tamanho, matricula) values ('Arie', 22, '300085');
insert into embarcacoes (nome, tamanho, matricula) values ('Electra IV', 26, '300085');
insert into embarcacoes (nome, tamanho, matricula) values ('Sylvia J', 24, '300088');
insert into embarcacoes (nome, tamanho, matricula) values ('Dr. Dos Mares', 21, '300093');
insert into embarcacoes (nome, tamanho, matricula) values ('Cariado II', 14, '300139');
insert into embarcacoes (nome, tamanho, matricula) values ('Kike', 27, '300143');
insert into embarcacoes (nome, tamanho, matricula) values ('Keep Calm III', 22, '300147');
insert into embarcacoes (nome, tamanho, matricula) values ('El Campeador', 26, '300153');
insert into embarcacoes (nome, tamanho, matricula) values ('Spirit Sport Fishing', 35, '300155');
insert into embarcacoes (nome, tamanho, matricula) values ('Lundu', 27, '300159');
insert into embarcacoes (nome, tamanho, matricula) values ('Kiwimar', 33, '300160');
insert into embarcacoes (nome, tamanho, matricula) values ('Marokau', 22, '300160');
insert into embarcacoes (nome, tamanho, matricula) values ('Sniper', 26, '300165');
insert into embarcacoes (nome, tamanho, matricula) values ('Brac I', 22, '300166');
insert into embarcacoes (nome, tamanho, matricula) values ('Guapo', 26, '300168');
insert into embarcacoes (nome, tamanho, matricula) values ('Catavento X', 35, '300179');
insert into embarcacoes (nome, tamanho, matricula) values ('French Kiss', 32, '300201');
insert into embarcacoes (nome, tamanho, matricula) values ('Sol e Brisa', 24, '300202');
insert into embarcacoes (nome, tamanho, matricula) values ('Gabriell', 22, '300206');
insert into embarcacoes (nome, tamanho, matricula) values ('Crispim I', 23, '300210');
insert into embarcacoes (nome, tamanho, matricula) values ('Saba de Ar', 29, '300214');
insert into embarcacoes (nome, tamanho, matricula) values ('Rosa dos mares', 22, '300218');
insert into embarcacoes (nome, tamanho, matricula) values ('Renatinha V', 19, '300224');
insert into embarcacoes (nome, tamanho, matricula) values ('Uaian', 24, '300238');
insert into embarcacoes (nome, tamanho, matricula) values ('Wally I', 26, '300241');
insert into embarcacoes (nome, tamanho, matricula) values ('Seven', 21, '300266');
insert into embarcacoes (nome, tamanho, matricula) values ('Vida Dura', 29, '300288');
insert into embarcacoes (nome, tamanho, matricula) values ('No Stress', 29, '300306');
insert into embarcacoes (nome, tamanho, matricula) values ('Sunset I', 26, '300310');
insert into embarcacoes (nome, tamanho, matricula) values ('Wind Kiss', 21, '300315');
insert into embarcacoes (nome, tamanho, matricula) values ('Allzira I', 20, '300318');
insert into embarcacoes (nome, tamanho, matricula) values ('Dr. Dias', 19, '300318');
insert into embarcacoes (nome, tamanho, matricula) values ('Jadis', 30, '300318');
insert into embarcacoes (nome, tamanho, matricula) values ('Barão Vermelho', 21, '300329');
insert into embarcacoes (nome, tamanho, matricula) values ('Cabeça de Vento', 32, '300333');
insert into embarcacoes (nome, tamanho, matricula) values ('Aversa', 24, '300340');
insert into embarcacoes (nome, tamanho, matricula) values ('Haeven', 26, '300374');
insert into embarcacoes (nome, tamanho, matricula) values ('Zig', 23, '300397');
insert into embarcacoes (nome, tamanho, matricula) values ('Yuti das Águas', 19, '300402');
insert into embarcacoes (nome, tamanho, matricula) values ('Scriba', 23, '300411');
insert into embarcacoes (nome, tamanho, matricula) values ('Star Fish', 27, '300418');
insert into embarcacoes (nome, tamanho, matricula) values ('Balada Carioca', 27, '300420');
insert into embarcacoes (nome, tamanho, matricula) values ('Opos II', 23, '300433');
insert into embarcacoes (nome, tamanho, matricula) values ('Dona Madame', 19, '300459');
insert into embarcacoes (nome, tamanho, matricula) values ('Jabulani 2A', 23, '400052');
insert into embarcacoes (nome, tamanho, matricula) values ('Fishionado', 15, '400054');
insert into embarcacoes (nome, tamanho, matricula) values ('Nathy e Kathy', 26, '400063');
insert into embarcacoes (nome, tamanho, matricula) values ('Les Must', 22, '400101');
insert into embarcacoes (nome, tamanho, matricula) values ('Siri da Ilha', 17, '400136');
insert into embarcacoes (nome, tamanho, matricula) values ('Gabiluxa', 28, '400213');
insert into embarcacoes (nome, tamanho, matricula) values ('Freendom Bay Rio', 22, '400244');
insert into embarcacoes (nome, tamanho, matricula) values ('Maionese', 31, '400271');
insert into embarcacoes (nome, tamanho, matricula) values ('Magia 200', 31, '400282');
insert into embarcacoes (nome, tamanho, matricula) values ('Guto', 14, '400293');
insert into embarcacoes (nome, tamanho, matricula) values ('Andaluz', 19, '600046');
insert into embarcacoes (nome, tamanho, matricula) values ('Ildamar II', 28, '600054');
insert into embarcacoes (nome, tamanho, matricula) values ('Schnit´s', 26, '600065');
insert into embarcacoes (nome, tamanho, matricula) values ('Garça Ceumar - Luige', 16, '600262');
insert into embarcacoes (nome, tamanho, matricula) values ('Meia Noite 2', 22, '700008');
insert into embarcacoes (nome, tamanho, matricula) values ('Meia  Noite III', 14, '700008');
insert into embarcacoes (nome, tamanho, matricula) values ('Blue Moon Rio', 30, '700032');
insert into embarcacoes (nome, tamanho, matricula) values ('Master Ship II', 21, '700032');
insert into embarcacoes (nome, tamanho, matricula) values ('Show X', 35, '700036');
insert into embarcacoes (nome, tamanho, matricula) values ('Punisher 2', 26, '700040');
insert into embarcacoes (nome, tamanho, matricula) values ('Mangalui', 20, '700048');
insert into embarcacoes (nome, tamanho, matricula) values ('Bravo', 21, '700061');
insert into embarcacoes (nome, tamanho, matricula) values ('Teimosia I', 31, '700149');
insert into embarcacoes (nome, tamanho, matricula) values ('Liberdade', 19, '700152');
insert into embarcacoes (nome, tamanho, matricula) values ('Ortergas', 26, '700166');
insert into embarcacoes (nome, tamanho, matricula) values ('Surf Adventure', 30, '801087');
insert into embarcacoes (nome, tamanho, matricula) values ('Xumbinho', 14, '3000318');
update embarcacoes
  set tipo = 'Veleiro', marinheiro = 'Luiz', boca = 4.2, calado = 1.9, peso = 24000,
  n_motores = 1, marca_motores = 'Mercedes Benz', combustivel = 'Gasolina'
where nome = 'Seven Oceans';

insert into telefones (associado, ddd, telefone) values ('1718', '21', '9962 -16583');
insert into telefones (associado, ddd, telefone) values ('-7', null, 'S/COBRANÇA');
insert into telefones (associado, ddd, telefone) values ('300054', '21', '2435-7385');
insert into telefones (associado, ddd, telefone) values ('300048', '21', '9991-87383');
insert into telefones (associado, ddd, telefone) values ('300340', '21', '9998-91661');
insert into telefones (associado, ddd, telefone) values ('1141', '21', '2466-2001');
insert into telefones (associado, ddd, telefone) values ('1141', '21', '99781-1940');
insert into telefones (associado, ddd, telefone) values ('205766', '21', '9970-22925');
insert into telefones (associado, ddd, telefone) values ('600046', null, 'S/COBRANÇA');
insert into telefones (associado, ddd, telefone) values ('1011', null, 'Retomado');
insert into telefones (associado, ddd, telefone) values ('300085', '21', '9998-48964');
insert into telefones (associado, ddd, telefone) values ('300318', '21', '9964-66113');
insert into telefones (associado, ddd, telefone) values ('-1', null, '*');
insert into telefones (associado, ddd, telefone) values ('1837', '21', '3396-9034');
insert into telefones (associado, ddd, telefone) values ('1769', '21', '9987-70237');
insert into telefones (associado, ddd, telefone) values ('1419', '21', '3393-4648');
insert into telefones (associado, ddd, telefone) values ('300420', '21', '9642-93730');
insert into telefones (associado, ddd, telefone) values ('700032', '21', '9816-59151');
insert into telefones (associado, ddd, telefone) values ('2074', '21', '2224-5051');
insert into telefones (associado, ddd, telefone) values ('1718', '21', '9962-31658');
insert into telefones (associado, ddd, telefone) values ('1199', '21', '3393-6041');
insert into telefones (associado, ddd, telefone) values ('300166', '21', '9998-79919');
insert into telefones (associado, ddd, telefone) values ('2274', '21', '3353-3331');
insert into telefones (associado, ddd, telefone) values ('300329', '21', '9767-68438');
insert into telefones (associado, ddd, telefone) values ('700061', '21', '9998-59885');
insert into telefones (associado, ddd, telefone) values ('50139', null, '*');
insert into telefones (associado, ddd, telefone) values ('205734', '21', '3393-5087');
insert into telefones (associado, ddd, telefone) values ('1776', '21', '9816-29433');
insert into telefones (associado, ddd, telefone) values ('300179', '21', '3489-7309');
insert into telefones (associado, ddd, telefone) values ('300333', '21', '9921-63464');
insert into telefones (associado, ddd, telefone) values ('300210', '21', '9804-15080');
insert into telefones (associado, ddd, telefone) values ('2287', '21', '9918-57879');
insert into telefones (associado, ddd, telefone) values ('205199', '21', '9922-26600');
insert into telefones (associado, ddd, telefone) values ('300001', '21', '9912-21772');
insert into telefones (associado, ddd, telefone) values ('300058', '21', '9999-42619');
insert into telefones (associado, ddd, telefone) values ('300139', '21', '3393-8977');
insert into telefones (associado, ddd, telefone) values ('300459', '21', '9795-68177');
insert into telefones (associado, ddd, telefone) values ('1016', '21', '9812-15461');
insert into telefones (associado, ddd, telefone) values ('300034', '21', '9812-75145');
insert into telefones (associado, ddd, telefone) values ('1308', '21', '9998-40139');
insert into telefones (associado, ddd, telefone) values ('6582', '21', '9819-96842');
insert into telefones (associado, ddd, telefone) values ('300318', '21', '9964-66113');
insert into telefones (associado, ddd, telefone) values ('1621', '21', '9998-79847');
insert into telefones (associado, ddd, telefone) values ('300093', '21', '9999-68927');
insert into telefones (associado, ddd, telefone) values ('1666', '21', '9997-67481');
insert into telefones (associado, ddd, telefone) values ('300153', '21', '9740-59530');
insert into telefones (associado, ddd, telefone) values ('50018', '21', '9879-50930');
insert into telefones (associado, ddd, telefone) values ('300085', '21', '9998-48964');
insert into telefones (associado, ddd, telefone) values ('-2', null, '*');
insert into telefones (associado, ddd, telefone) values ('50028', '21', '9958-43685');
insert into telefones (associado, ddd, telefone) values ('400244', '21', '9976-67427');
insert into telefones (associado, ddd, telefone) values ('2070', '21', '9826-00154');
insert into telefones (associado, ddd, telefone) values ('400054', '21', '9644-59671');
insert into telefones (associado, ddd, telefone) values ('1612', '21', '9998-23902');
insert into telefones (associado, ddd, telefone) values ('300201', '21', '9885-58678');
insert into telefones (associado, ddd, telefone) values ('1769', '21', '9987-70237');
insert into telefones (associado, ddd, telefone) values ('449', '22', '2243-6219');
insert into telefones (associado, ddd, telefone) values ('204311', '21', '2466-1266');
insert into telefones (associado, ddd, telefone) values ('400293', '21', '9884-80705');
insert into telefones (associado, ddd, telefone) values ('400213', '21', '9956-74325');
insert into telefones (associado, ddd, telefone) values ('300046', '21', '99617-3480');
insert into telefones (associado, ddd, telefone) values ('300080', '21', '99973-7363');
insert into telefones (associado, ddd, telefone) values ('300168', '21', '9890-23535');
insert into telefones (associado, ddd, telefone) values ('300206', '21', '7832-7428');
insert into telefones (associado, ddd, telefone) values ('600262', '21', '9686-56102');
insert into telefones (associado, ddd, telefone) values ('300374', '21', '9812-22228');
insert into telefones (associado, ddd, telefone) values ('2913', '21', '3393-2562');
insert into telefones (associado, ddd, telefone) values ('381', '21', '9835-37511');
insert into telefones (associado, ddd, telefone) values ('600054', '21', '9998-35408');
insert into telefones (associado, ddd, telefone) values ('1134', '21', '9962-13020');
insert into telefones (associado, ddd, telefone) values ('300318', '21', '9964-66113');
insert into telefones (associado, ddd, telefone) values ('200769', '21', '9998-31382');
insert into telefones (associado, ddd, telefone) values ('204065', '21', '99193-9031');
insert into telefones (associado, ddd, telefone) values ('400052', '21', '9862-44503');
insert into telefones (associado, ddd, telefone) values ('300021', '21', '9867-12610');
insert into telefones (associado, ddd, telefone) values ('300147', '21', '9964-60991');
insert into telefones (associado, ddd, telefone) values ('300160', '21', '9956-62878');
insert into telefones (associado, ddd, telefone) values ('300025', '21', '9998-68490');
insert into telefones (associado, ddd, telefone) values ('300143', '21', '9881-46731');
insert into telefones (associado, ddd, telefone) values ('300028', '21', '2264-7443');
insert into telefones (associado, ddd, telefone) values ('300159', '21', '9832-06131');
insert into telefones (associado, ddd, telefone) values ('2209', '21', '9649-55629');
insert into telefones (associado, ddd, telefone) values ('700152', '21', '9877-75848');
insert into telefones (associado, ddd, telefone) values ('50125', '21', '9923-43303');
insert into telefones (associado, ddd, telefone) values ('300056', '21', '9889-21515');
insert into telefones (associado, ddd, telefone) values ('400101', '21', '9874-20040');
insert into telefones (associado, ddd, telefone) values ('50141', '21', '9811-43875');
insert into telefones (associado, ddd, telefone) values ('204517', '21', '9868-16771');
insert into telefones (associado, ddd, telefone) values ('400271', '21', '9811-25134');
insert into telefones (associado, ddd, telefone) values ('300082', '19', '9850-21282');
insert into telefones (associado, ddd, telefone) values ('300160', '21', '9956-62878');
insert into telefones (associado, ddd, telefone) values ('400282', '21', '9883-72016');
insert into telefones (associado, ddd, telefone) values ('700008', '21', '9979-72572');
insert into telefones (associado, ddd, telefone) values ('1666', '21', '9997-67481');
insert into telefones (associado, ddd, telefone) values ('300042', '21', '9813-38789');
insert into telefones (associado, ddd, telefone) values ('641', '21', '9941-39999');
insert into telefones (associado, ddd, telefone) values ('864', '21', '2462-3211');
insert into telefones (associado, ddd, telefone) values ('1851', '21', '3396-4329');
insert into telefones (associado, ddd, telefone) values ('2833', '21', '9997-20722');
insert into telefones (associado, ddd, telefone) values ('700008', '21', '9979-72572');
insert into telefones (associado, ddd, telefone) values ('1084', '21', '9970-44215');
insert into telefones (associado, ddd, telefone) values ('1784', '21', '2463-7887');
insert into telefones (associado, ddd, telefone) values ('104973', '21', '3186-1053');
insert into telefones (associado, ddd, telefone) values ('700032', '21', '9816-59151');
insert into telefones (associado, ddd, telefone) values ('700048', '21', '9965-72133');
insert into telefones (associado, ddd, telefone) values ('300035', '21', '9975-14928');
insert into telefones (associado, ddd, telefone) values ('300306', '21', '9640-60069');
insert into telefones (associado, ddd, telefone) values ('1141', '21', '2466-2001');
insert into telefones (associado, ddd, telefone) values ('3084', '21', '9972-0257');
insert into telefones (associado, ddd, telefone) values ('205330', '21', '7803-0405');
insert into telefones (associado, ddd, telefone) values ('400063', '21', '9921-30484');
insert into telefones (associado, ddd, telefone) values ('300069', '21', '9976-68238');
insert into telefones (associado, ddd, telefone) values ('300433', '21', '9888-19323');
insert into telefones (associado, ddd, telefone) values ('700166', '21', '9998-42402');
insert into telefones (associado, ddd, telefone) values ('2089', '21', '9994-55038');
insert into telefones (associado, ddd, telefone) values ('-3', null, '*');
insert into telefones (associado, ddd, telefone) values ('700040', '21', '9813-82929');
insert into telefones (associado, ddd, telefone) values ('-4', null, '*');
insert into telefones (associado, ddd, telefone) values ('300045', '21', '9991-50041');
insert into telefones (associado, ddd, telefone) values ('300036', '21', '3473-0262');
insert into telefones (associado, ddd, telefone) values ('300027', '21', '9997-46047');
insert into telefones (associado, ddd, telefone) values ('300224', '21', '9999-78499');
insert into telefones (associado, ddd, telefone) values ('300218', '21', '9699-75385');
insert into telefones (associado, ddd, telefone) values ('300202', '21', '9978-92161');
insert into telefones (associado, ddd, telefone) values ('300165', '21', '7812-4551');
insert into telefones (associado, ddd, telefone) values ('1134', '21', '9962-13020');
insert into telefones (associado, ddd, telefone) values ('300155', '21', '9995-26547');
insert into telefones (associado, ddd, telefone) values ('300411', '21', '9888-01649');
insert into telefones (associado, ddd, telefone) values ('1612', '21', '9998-23902');
insert into telefones (associado, ddd, telefone) values ('300088', '21', '9997-20038');
insert into telefones (associado, ddd, telefone) values ('1878', '21', '7815-4757');
insert into telefones (associado, ddd, telefone) values ('801087', '21', '2495-2194');
insert into telefones (associado, ddd, telefone) values ('300065', '21', '9966-99791');
insert into telefones (associado, ddd, telefone) values ('300214', '21', '9983-40644');
insert into telefones (associado, ddd, telefone) values ('205199', '21', '9922-26600');
insert into telefones (associado, ddd, telefone) values ('1141', '21', '2466-2001');
insert into telefones (associado, ddd, telefone) values ('700036', '21', '7896-2245');
insert into telefones (associado, ddd, telefone) values ('300310', '21', '9640-71981');
insert into telefones (associado, ddd, telefone) values ('300083', '21', '9989-77890');
insert into telefones (associado, ddd, telefone) values ('2269', '21', '9916-54455');
insert into telefones (associado, ddd, telefone) values ('300266', '21', '9649-72450');
insert into telefones (associado, ddd, telefone) values ('400136', '21', '9643-69903');
insert into telefones (associado, ddd, telefone) values ('600065', '21', '9996-33120');
insert into telefones (associado, ddd, telefone) values ('300418', '21', '9817-46363');
insert into telefones (associado, ddd, telefone) values ('104973', '21', '3186-1053');
insert into telefones (associado, ddd, telefone) values ('483', '21', '3393-1483');
insert into telefones (associado, ddd, telefone) values ('300054', '21', '2435-7385');
insert into telefones (associado, ddd, telefone) values ('-5', null, '*');
insert into telefones (associado, ddd, telefone) values ('101670', '21', '2239-2889');
insert into telefones (associado, ddd, telefone) values ('576', '21', '2466-2686');
insert into telefones (associado, ddd, telefone) values ('700149', '21', '3396-2634');
insert into telefones (associado, ddd, telefone) values ('2269', '21', '9916-54455');
insert into telefones (associado, ddd, telefone) values ('-5', null, '*');
insert into telefones (associado, ddd, telefone) values ('100053', '21', '2466-1228');
insert into telefones (associado, ddd, telefone) values ('101670', '21', '2676-1276');
insert into telefones (associado, ddd, telefone) values ('300238', '21', '9996-21553');
insert into telefones (associado, ddd, telefone) values ('1345', '21', '9886-77477');
insert into telefones (associado, ddd, telefone) values ('2620', '21', '3396-3940');
insert into telefones (associado, ddd, telefone) values ('300288', '21', '9798-49933');
insert into telefones (associado, ddd, telefone) values ('787', '21', '9998-53970');
insert into telefones (associado, ddd, telefone) values ('300241', '21', '9999-93297');
insert into telefones (associado, ddd, telefone) values ('2287', '21', '9918-57879');
insert into telefones (associado, ddd, telefone) values ('300315', '21', '9811-44822');
insert into telefones (associado, ddd, telefone) values ('2741', '21', '9876-26469');
insert into telefones (associado, ddd, telefone) values ('3000318', '21', '9964-66113');
insert into telefones (associado, ddd, telefone) values ('1451', '21', '9961-45761');
insert into telefones (associado, ddd, telefone) values ('1451', '21', '9961-45761');
insert into telefones (associado, ddd, telefone) values ('300055', '21', '9995-45679');
insert into telefones (associado, ddd, telefone) values ('650', '21', '9642-57447');
insert into telefones (associado, ddd, telefone) values ('101670', '21', '2676-1276');
insert into telefones (associado, ddd, telefone) values ('300397', '21', '9969-71827');
insert into telefones (associado, ddd, telefone) values ('300402', '21', '9976-11226');
insert into telefones (associado, ddd, telefone) values ('1611', '21', '3396-1181');
insert into telefones (associado, ddd, telefone) values ('1487', null, '*');
insert into telefones (associado, ddd, telefone) values ('-6', '21', '2468-3000');

insert into vagas (pier, vaga, proprietario, embarcacao) values ('Pier C', 11, '1141', 'Seven Oceans');
insert into vagas (pier, vaga, proprietario, embarcacao) values ('Pier C', 16, '1141', null);
insert into vagas (pier, vaga, proprietario) values ('Pier C', 17, '1141');
insert into vagas (pier, vaga, proprietario) values ('Pier C', 18, '1141');

--------------------------------------------------------------------------------
------------------------------- CONSULTAS ÚTEIS --------------------------------
--------------------------------------------------------------------------------

-- Embarcação, Tamanho em pés, Área, Vaga, Proprietário e Matrícula, ordenada por embarcação
select e.nome as EMBARCAÇÃO, e.tamanho as "TAMANHO (PÉS)", ' ' as " ", l.area as ÁREA, l.vaga, ' ' as "  ", a.nome as PROPRIETÁRIO, e.matricula as MATRÍCULA
from embarcacoes e, associados a, localizacao l
where e.matricula = a.matricula and l.embarcacao = e.nome
order by e.nome;

-- Mesma consulta que a anterior, porém ordenada por proprietário
select a.nome as PROPRIETÁRIO, e.matricula as MATRÍCULA, e.nome as EMBARCAÇÃO, e.tamanho as "TAMANHO (PÉS)", ' ' as " ", l.area as ÁREA, l.vaga
from embarcacoes e, associados a, localizacao l
where e.matricula = a.matricula and l.embarcacao = e.nome
order by a.nome;

-- Matrícula, Nome, DDD e Telefone de todos os associados, incluindo múltiplos telefones
select t.associado as MATRÍCULA, a.nome as ASSOCIADO, t.ddd, t.telefone
from associados a join telefones t
on a.matricula = t.associado
order by a.nome;

-- Associados que não têm matrícula cadastrada (beneméritos, talvez?)
select matricula as MATRÍCULA, nome as ASSOCIADO
from associados 
where length(matricula) < 3
order by matricula asc;

-- Todas as embarcações com nome, tamanho e área/vaga, de UM MESMO associado, não múltiplos
select e.nome as EMBARCAÇÃO, e.tamanho as "TAMANHO (PÉS)", ' ' AS " ", l.area as ÁREA, l.vaga, ' ' as "  ", a.nome as PROPRIETÁRIO, a.matricula as MATRÍCULA
from embarcacoes e, associados a, localizacao l
where e.matricula = a.matricula
and a.nome = 'Edson Fernandes Mascarenhas'
and l.embarcacao = e.nome;

-- Vagas na marina pertencentes a associados, com nome e matrícula
select p.pier, p.vaga, ' ' as " ", a.nome as PROPRIETÁRIO, ' ' as "  ", a.matricula as MATRÍCULA
from propriedadeSobreVagas p, associados a
where p.proprietario = a.matricula;

-- OS DADOS DE DATA DE ÚLTIMO PAGAMENTO AINDA NÃO CONSTAM DESTE BANCO DE DADOS.

-- Associados que estão devendo há x dias, tal que 30 <= x < 180
select * from associados a
where (SYSDATE - a.ultimo_pagamento >=30)
and (SYSDATE - a.ultimo_pagamento < 180);

-- Associados que estão devendo há 180 dias ou mais
select * from associados a
where SYSDATE - a.ultimo_pagamento >= 180;

-- Associados que estão devendo há 60 dias ou mais
select *
from embarcacoes e, associados a
where SYSDATE - a.ultimo_pagamento >= 60
and e.matricula = a.matricula;

-- Consultas fundamentais de cada tabela
select * from areas; -- Não existe Pier D?
select * from associados;
select * from embarcacoes;
select * from localizacao order by embarcacao;
select * from propriedadeSobreVagas;
select * from telefones;
select * from tiposDeEmbarcacoes;
select * from vagasPorPier;

--------------------------------------------------------------------------------
--------------------------- CRIAÇÃO DE VISUALIZAÇÕES ---------------------------
--------------------------------------------------------------------------------

create view embarcacoes_e_proprietarios
as select e.nome as EMBARCAÇÃO, e.tamanho as "TAMANHO (PÉS)", ' ' as " ", l.area as ÁREA, l.vaga, ' ' as "  ", a.nome as PROPRIETÁRIO, e.matricula as MATRÍCULA
from embarcacoes e, associados a, localizacao l
where e.matricula = a.matricula and l.embarcacao = e.nome
order by e.nome;

create view proprietarios_e_embarcacoes
as select a.nome as PROPRIETÁRIO, e.matricula as MATRÍCULA, e.nome as EMBARCAÇÃO, e.tamanho as "TAMANHO (PÉS)", ' ' as " ", l.area as ÁREA, l.vaga
from embarcacoes e, associados a, localizacao l
where e.matricula = a.matricula and l.embarcacao = e.nome
order by a.nome;

create view associados_e_telefones
as select t.associado as MATRÍCULA, a.nome as ASSOCIADO, t.ddd, t.telefone
from associados a join telefones t
on a.matricula = t.associado
order by a.nome;

create view associados_sem_matricula
as select matricula as MATRÍCULA, nome as ASSOCIADO
from associados 
where length(matricula) < 3
order by matricula asc;

create view vagasPropEmb
as select v.pier, v.vaga, ' ' as " ", a.nome as "PROPRIETÁRIO DA VAGA", ' ' as "  ", a.matricula as MATRÍCULA, l.embarcacao as EMBARCAÇÃO
from vagas v, associados a, localizacao l
where v.proprietario = a.matricula
and l.area = v.pier
and l.vaga = v.vaga;

select * from vagasPropEmb;

drop view VagasProp;
create view vagasProp
as select v.pier, v.vaga, ' ' as " ", a.nome as "PROPRIETÁRIO DA VAGA", ' ' as "  ", v.proprietario as MATRÍCULA
from vagas v, associados a
where v.proprietario = a.matricula;
select * from vagasProp;

select * from embarcacoes_e_proprietarios;
select * from proprietarios_e_embarcacoes;
select * from associados_e_telefones;
select * from associados_sem_matricula;
select * from vagasPropEmb;
select embarcacao as EMBARCAÇÃO, area as ÁREA, vaga from localizacao order by embarcacao;
select * from vagas;
select * from areas;

commit;