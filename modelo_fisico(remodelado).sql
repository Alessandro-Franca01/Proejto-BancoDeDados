CREATE DATABASE projeto_teste

-- Funcionando sem pedir senha!!!

-- IMPLEMENTAÇAO FISICA DO BANCO DE DADOS
-- ESSE ARQUIVO ESTA PEDINDO A SENHA, PARA DESBLOQUEAR PARA CADA COMANDO NO TERMINAL
-- Ultima atualização 21-05-2020

CREATE DATABASE projeto_banco_de_dados

USE projeto_banco_de_dados

CREATE SCHEMA dbo

-- ESTRUTURA DAS TABELAS DO BANCO DE DADOS
-- USANDO O SCHEMA

CREATE TABLE dbo.endereco(
	IDEnderco TINYINT PRIMARY KEY IDENTITY,
	estado CHAR(2) NOT NULL,
	cidade VARCHAR(20) NOT NULL,
	cep VARCHAR(12),
	bairro VARCHAR(15),
	rua VARCHAR(15),
	numero SMALLINT,
	tipo VARCHAR(10)
)

CREATE TABLE dbo.cliente_fisico(
	IDCliente_fisico TINYINT PRIMARY KEY IDENTITY,
	sexo CHAR(1) NOT NULL,
	rg VARCHAR(12) NOT NULL UNIQUE,
	cpf VARCHAR(15) NOT NULL UNIQUE,
)

CREATE TABLE dbo.cliente_juridico(
	IDCliente_juridico TINYINT PRIMARY KEY IDENTITY(20,1),
	cnpj VARCHAR(15) NOT NULL UNIQUE,
	razao_social VARCHAR(30),
	estado_de_funcionamento VARCHAR(30),
	ramo VARCHAR(50),
	descricao VARCHAR(40)
 )

CREATE TABLE dbo.cliente(
  	IDCliente TINYINT PRIMARY KEY IDENTITY,
  	nome VARCHAR(40) NOT NULL,
  	email VARCHAR(20),
	telefone VARCHAR(12),
	-- Aqui ainda tem tres foreign keys
	ID_Endereco TINYINT,
	CONSTRAINT FK_idEndereco FOREIGN KEY (ID_Endereco) REFERENCES  endereco  (IDEnderco),
	ID_PF TINYINT,
	CONSTRAINT FK_idPF FOREIGN KEY (ID_PF) REFERENCES cliente_fisico (IDCliente_fisico),
	ID_PJ TINYINT,
	CONSTRAINT FK_idPJ FOREIGN KEY (ID_PJ) REFERENCES cliente_juridico (IDCliente_juridico)
	)

CREATE TABLE dbo.endereco_cliente( --NEW TESTE 21/05/2020 "FUNCIONOU!!!"
    ID_Cliente TINYINT NOT NULL,
    ID_Endereco TINYINT NOT NULL,
    CONSTRAINT PK_idCliente_END PRIMARY KEY (ID_Cliente,ID_Endereco),
    CONSTRAINT Fk_idCLiente_END FOREIGN KEY (ID_Cliente) REFERENCES dbo.cliente (IDCliente), -- Errei o nome!
    CONSTRAINT FK_idEndereco_Cl FOREIGN KEY (ID_Endereco) REFERENCES dbo.endereco (IDEnderco)
)


CREATE TABLE dbo.departamento(
	IDDepartamento CHAR(3) PRIMARY KEY,
	nome VARCHAR(15) NOT NULL,
	descricao VARCHAR(30)
)

CREATE TABLE dbo.funcionario(
	IDFuncionario TINYINT PRIMARY KEY IDENTITY,
	nome VARCHAR(40) NOT NULL,
  	email VARCHAR(20),
	celular VARCHAR(12),
	sexo CHAR(1) NOT NULL,
	rg VARCHAR(12) NOT NULL UNIQUE,
	cpf VARCHAR(15) NOT NULL UNIQUE,
	-- VENDEDOR
	meta NUMERIC(4,2),
	participacao_vendas NUMERIC(4,2),
	-- PROGRAMADOR
	area_de_atuacao VARCHAR(30),
	tipo_de_servico VARCHAR(30),
	ID_Departamento CHAR(3) NOT NULL,
	CONSTRAINT FK_idDepartamento FOREIGN KEY (ID_Departamento) REFERENCES dbo.departamento (IDDepartamento),
)

CREATE TABLE dbo.endereco_funcionario(
    ID_Funcionario TINYINT NOT NULL,
    ID_Endereco_FC TINYINT NOT NULL,
    CONSTRAINT PK_idFunc_END PRIMARY KEY (ID_Funcionario,ID_Endereco_FC),
    CONSTRAINT Fk_idFunc_END FOREIGN KEY (ID_Funcionario) REFERENCES dbo.funcionario (IDFuncionario),
    CONSTRAINT FK_idEndereco_FC FOREIGN KEY (ID_Endereco_FC) REFERENCES dbo.endereco (IDEnderco)
)

CREATE TABLE dbo.pedido(
	IDPedido tinyint Primary key identity(10,1),
	data_pedido datetime NOT NULL,
	data_entrega datetime NOT NULL,
	tipo varchar(15) check (tipo in ('online','presencial')) not null,
	valor smallmoney not null,
	estado VARCHAR(30) CHECK (estado IN('enviado','entregue','para enviar')),
	ID_Cliente tinyint,
	CONSTRAINT FK_idCliente FOREIGN KEY (ID_Cliente) REFERENCES dbo.cliente (IDCliente),
	ID_Vendedor TINYINT, -- PODE RECEBER VALOR NULL
	CONSTRAINT FK_idVendedor FOREIGN KEY (ID_Vendedor) REFERENCES dbo.funcionario (IDFuncionario)
)
-- Alterando a tabela pedido coluna 'ESTADO' para CHECK
--ALTER TABLE pedido ADD estado VARCHAR(30) CHECK (estado IN('enviado','entregue','para enviar')),

CREATE TABLE dbo.pagamento(
    IDPagamento TINYINT PRIMARY KEY IDENTITY(30,1),
    tipo VARCHAR(20) CHECK (tipo IN ('Credito','Debito','Boleto')),
    estado VARCHAR(30) CHECK (estado IN ('Em espera','Feito','Nao efetuado')),
    parcelas TINYINT,
    ID_Pedido TINYINT NOT NULL,
    CONSTRAINT FK_idPedido_PG FOREIGN KEY (ID_Pedido) REFERENCES dbo.pedido (IDPedido)
)

CREATE TABLE dbo.fornecedor(
    IDFornecedor TINYINT PRIMARY KEY IDENTITY,
    nome VARCHAR(40) NOT NULL,
    cnpj VARCHAR(15) NOT NULL UNIQUE,
    tipo VARCHAR(30) CHECK (tipo IN ('Frete','Produto')),
    descricao VARCHAR(50),
    ID_Endereco TINYINT,
    CONSTRAINT FK_idEndereco_Forn FOREIGN KEY (ID_Endereco) REFERENCES  dbo.endereco  (IDEnderco)
)

CREATE TABLE dbo.dept_produto(
    IDDept_produto CHAR(3) PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    desricao VARCHAR(40),
)

CREATE TABLE dbo.produto(
    IDProduto TINYINT PRIMARY KEY IDENTITY(100,1),
    nome VARCHAR(30) NOT NULL,
    descricao VARCHAR(40),
    marca VARCHAR(30),
    valor smallmoney NOT NULL,
    estoque smallint NOT NULL,
    ID_Dept_prodt CHAR(3) NOT NULL,
    CONSTRAINT FK_idDepT_Prodt FOREIGN KEY (ID_Dept_prodt) REFERENCES dbo.dept_produto (IDDept_produto)
)

CREATE TABLE dbo.produto_pedido(
   ID_Produto TINYINT NOT NULL,
   ID_Pedido TINYINT NOT NULL, -- MESMO NOME, MAS EM OUTRA TABELA...
   Quantidade SMALLINT NOT NULL,
   CONSTRAINT PK_Prodt_Pedido PRIMARY KEY (ID_Produto,ID_Pedido),
   CONSTRAINT FK_idProdut_Ped FOREIGN KEY (ID_Produto) REFERENCES dbo.produto (IDProduto),
   CONSTRAINT FK_idPedido_Prodt FOREIGN KEY (ID_Pedido) REFERENCES dbo.pedido (IDPedido)
)

CREATE TABLE dbo.produto_fornecedor( -- (N,N)
    ID_Fornecedor TINYINT NOT NULL ,
    ID_Produto TINYINT NOT NULL,
    CONSTRAINT  PK_Fornc_Prodt PRIMARY KEY (ID_Fornecedor,ID_Produto),
    CONSTRAINT FK_idFornc_Prodt FOREIGN KEY (ID_Fornecedor) REFERENCES dbo.fornecedor (IDFornecedor),
    CONSTRAINT FK_idProdt_FC FOREIGN KEY (ID_Produto) REFERENCES dbo.produto (IDProduto)
)

CREATE TABLE dbo.frete(
    IDFrete TINYINT PRIMARY KEY IDENTITY(10,1),
    data_saida DATETIME NOT NULL,
    data_entrega DATETIME NOT NULL,
    valor SMALLMONEY NOT NULL,
    distancia REAL,
    ID_Fornecedor TINYINT NOT NULL,
    CONSTRAINT FK_idFornecdor_Fr FOREIGN KEY (ID_Fornecedor) REFERENCES dbo.fornecedor (IDFornecedor),
    ID_Pedido TINYINT NOT NULL,
    CONSTRAINT FK_idPedido_Fr FOREIGN KEY (ID_Pedido) REFERENCES dbo.pedido (IDPedido)
)

-- FEITA TODAS AS TABELAS (DE ACORDO COM O MODELO LÓGICO)

-- OBS: a tabela ENDERECO_CLIENTE nao aparece no schema e nao estou inserirndo nela!

-- INSERINDO ENDEREÇOS
-- ENDEREÇOS DE CLIENTES:
INSERT INTO endereco VALUES ('PB','cabedelo', '58310015', 'Centro', 'Campina da Vila', 185, null) --ok
INSERT INTO endereco VALUES ('SP','sao paulo', '78400208', 'Centro', 'Rua nova', 105, 'apt') -- ok
INSERT INTO endereco VALUES ('RJ','niteroi', '34200208', 'Centro', 'duque de sa', 10, 'apt') -- ok
INSERT INTO endereco VALUES ('PB', 'Joao Pessoa', '20190420', 'bairro dos est','Parana', 123, 'residencia')
INSERT INTO endereco VALUES ('PB', 'cabedelo', '20190310', 'Intermares','Rua Niel Castro', 12, 'apt') -- ok
INSERT INTO endereco VALUES ('PB', 'Joao Pessoa', '20898326', 'Centro','Rua Pedro Alves', 103, NULL) -- ok
INSERT INTO endereco VALUES ('PB','Campina Grande','31097835','Centro', 'Av. Palmeiras',421,'apt') -- ok
INSERT INTO endereco VALUES ('PB','Joao Pessoa','20180322','Ipes','R. Candido',NULL,'predio') -- ok

-- ENDEREÇO DE FUNCIONARIOS
INSERT INTO endereco VALUES ('PE','Recife','70555004','Centro','Pedro Almeida',1200,'residencia') -- OK
INSERT INTO endereco VALUES ('PE', 'Refice','70555004','Centro','Castro Rui',135,'residencia') -- OK
INSERT INTO endereco VALUES ('PB','Cabedelo','58310020','Monte Castelo','Agusto Firmo P.',154,'residencia') -- OK
INSERT INTO endereco VALUES ('PB','Joao Pessao','54030897','Geisel','Carlos Pinho',569,'apt') -- OK
INSERT INTO endereco VALUES ('PB','Campina Grande','30400265','Centro','Alfredo Frio',1089,NULL) --OK

-- Ajeitando uns registros
UPDATE endereco SET tipo = 'residencia' WHERE estado ='PE'
UPDATE endereco SET estado = 'PB' WHERE estado ='RB'
SELECT * FROM endereco

-- INSERNIDO CLIENTES FISICOS  (INSERIDO)
INSERT INTO cliente_fisico VALUES ('M','123456789','12345678912') -- ok
INSERT INTO cliente_fisico VALUES ('F','123421423','123531223498') -- ok
INSERT INTO cliente_fisico VALUES ('M','123444512','12334509834') -- ok
INSERT INTO cliente_fisico VALUES ('F','123786312','12365489084') -- ok
INSERT INTO cliente_fisico VALUES ('M','082937143','82789347383') -- ok


-- INSERNIDO CLIENTES JURIDICOS (INSERIDO)
INSERT INTO cliente_juridico VALUES ('12345678921', 'restaurante popular', 'ativo','alimentacao', null) --ok
INSERT INTO cliente_juridico VALUES ('12456409809', 'auto peças Carlos', 'Ativo', 'mequanica automoveis', null) --ok
INSERT INTO cliente_juridico VALUES ('10938374913', 'prefeitura Joao Pessoa', 'ativo','governamental', null) -- ok
INSERT INTO cliente_juridico VALUES ('32450987590', 'Hotel Passe Bem', 'inativo','hospedagem', null) -- ok

-- INSERNIDO CLIENTES
INSERT INTO cliente VALUES ('Darcilene Xavier','Darci@hotmail.com','839872653',6,2,NULL)
INSERT INTO cliente VALUES ('Sandrinho', 'sandro@gmail.com', '839822114435', 1, 1, null)
INSERT INTO cliente VALUES ('Oficina do Carlos', 'carlos@hotmail.com', '12344598700',3, null, 23)
INSERT INTO cliente VALUES ('Prefeitura João Pessoa','sec_pb@gov.com','8331240965',4,NULL,20)
INSERT INTO cliente VALUES ('Restaurante Popular','rest_pop@hotmail.com','83934902311',7, NULL,22)
INSERT INTO cliente VALUES ('Camila Silva','cami_21@hotmail.com','83986538540',9,5,NULL)
INSERT INTO cliente VALUES ('Roberto Martins','robert_@hotmail.com','34980124365',2,3,NULL)
INSERT INTO cliente VALUES ('Marcio Alves','marcio15@gmail.com','83987123580',7,6,NULL)
INSERT INTO cliente VALUES ('Hotel Passe Bem','passebem@hotmail.com','83981732441',11,NULL,21)

-- Arrumando a casa (Da uma olhada como altera o registro 'Update/Delete/Alter')
DELETE cliente WHERE IDCliente = 3

-- INSERINDO Departamento  (INSERIDO)
INSERT INTO departamento VALUES ('TIF','INSFRAESTRUTURA', 'TI na area de infraestrutura ')
INSERT INTO departamento VALUES ('TID', 'DESENVOLIMENTO', 'TI na area de desenvolvimento')
INSERT INTO departamento VALUES ('VED', 'VENDAS', 'Departamento de vendas')
INSERT INTO departamento VALUES ('C&L', 'Compras', 'Compras e Logistica')
INSERT INTO departamento VALUES ('BIG','BIG DATA','Engenharia de dados')
--INSERT INTO departamento VALUES ('VED', 'VENDAS', 'Departamento de vendas')  -- Depois faço esse registro!!

-- INSERINDO Funcionario (INSERIDO)
INSERT INTO funcionario VALUES ('Alessandro', 'alessandro@gmail.com','83981423980','M','123445566','12344455512',
                                NULL,NULL,'Programdor', 'Desenvolvimento de Software','TID') -- OK
INSERT INTO funcionario VALUES ('Marcos', 'marcos@yahoo.com', '83912344321','M','124345678','1243256711',0.50,0.10,
                                NULL,NULL,'VED') -- ok
INSERT INTO funcionario VALUES ('Leandro', 'leandro007@yahoo.com', '83912312561','M','1242134568','1436256089',NULL,NULL,
                                NULL,NULL,'C&L') -- ok
INSERT INTO funcionario VALUES ('Jefferson', 'Jeff@gmail.com', '8398890140','M','236890478','1436706711',0.60,0.30,
                                NULL,NULL,'VED') -- OK
INSERT INTO funcionario VALUES ('Tania Soares','tan_soares@yahoo.com','8493428977','M','112798345','55437809145',NULL,NULL,
                                'Programador','Big Data','BIG') -- OK

-- INSERINDO Funcionario_Endereco  (INSERIDO) * FUNCIONANDO!!!
INSERT INTO endereco_funcionario VALUES (4,12)
INSERT INTO endereco_funcionario VALUES (7,13)
INSERT INTO endereco_funcionario VALUES (3,14)
INSERT INTO endereco_funcionario VALUES (6,15)
INSERT INTO endereco_funcionario VALUES (9,16)

-- INSERINDO Departamentos de Produtos (INSERIDOS)
INSERT INTO dept_produto VALUES ('GAM','Games','Jogos e acessorios')
INSERT INTO dept_produto VALUES ('ESC','OFFICE','acessorios de escritorio')
INSERT INTO dept_produto VALUES ('SEV','Servidores','Departamento p/ Servidores')
INSERT INTO dept_produto VALUES ('CEL', 'Celulares', 'Departamento p/ Celulares')

-- INSERINDO Fornecedor (INSERIDOS) * Falta colocar os endereços!!!
INSERT INTO fornecedor VALUES ('SONY','1234556778','produto','jogos e consoles',NULL)
INSERT INTO fornecedor VALUES ('LogTech','1320569848','produto','acessorios & games',NULL)
INSERT INTO fornecedor VALUES ('Multilaser','198837840','produto','Fornecedor de produtos em geral',NULL)
INSERT INTO fornecedor VALUES ('Logistica Inova','1345707892','frete','Logistica e Frete', NULL)
INSERT INTO fornecedor VALUES ('Log Security','1834096721','frete','Serviço de Entrega',NULL)
INSERT INTO fornecedor VALUES ('Motorola','1234689301','produto','Celular',NULL)

-- INSERINDO Produto
INSERT INTO produto VALUES ('Playstation 4','Console gamer','Sony',3200.00,5,'GAM')
INSERT INTO produto VALUES ('Mouse Wi-fi', 'Acessorio PC','Multilaser',64.90,12,'ESC')
INSERT INTO produto VALUES ('Notebook AXG','Notebook Gamer','Multilaser',2459.00,10,'GAM')
INSERT INTO produto VALUES ('Servidor M37', 'Servidor p/ Internet', 'Multilaser',2890.00,4,'SEV')
INSERT INTO produto VALUES ('Moto G8', 'SmartPhone','Motorola',1200,15,'CEL')

-- INSERINDO Produto_Fornecedor (N:N) *Só está faltando essa tabela kkkk
INSERT INTO produto_fornecedor VALUES (1,101)
INSERT INTO produto_fornecedor VALUES (2,102)
INSERT INTO produto_fornecedor VALUES (2,103)
INSERT INTO produto_fornecedor VALUES (2,104)
INSERT INTO produto_fornecedor VALUES (5,105)

-- INSERINDO Pedidos (INSERIDO)
INSERT INTO pedido VALUES ('13-05-2020','20-05-2020','online',3200.00,2,NULL,'entregue') -- PS4
INSERT INTO pedido VALUES ('20-05-2020', '26-05-2020','presencial',129.80,1,3,'enviado') -- Mouse x2
INSERT INTO pedido VALUES ('24-05-2020', '02-06-2020','online',3659.00,7,NULL,'para enviar')  -- Cell + Note

--INSERINDO Produto_Pedido (INSERIDO) (N:N) 'ID_Produto ,ID_Pedido, Quantidade'
INSERT INTO produto_pedido VALUES (101,12,1)
INSERT INTO produto_pedido VALUES (102,13,2)
INSERT INTO produto_pedido VALUES (103,14,1)
INSERT INTO produto_pedido VALUES (105,14,1)

--INSERINDO Pagamento (INSERIDO)
INSERT INTO pagamento VALUES ('Boleto','Feito',8,12)
INSERT INTO pagamento VALUES ('Credito','Em espera',2,13)
INSERT INTO pagamento VALUES ('Debito','Nao efetuado',0,14)

-- INSERINDO Frete (INSERIDO)
INSERT INTO frete VALUES ('15-05-2020','19-05-2020',56.90,4,12)
INSERT INTO frete VALUES ('20-05-2020','25-05-2020',43.50,4,13)
INSERT INTO frete VALUES ('25-05-2020','01-06-2020',80.50,3,14)

SELECT * FROM fornecedor
SELECT * FROM pedido
SELECT * FROM frete

-- ALTERANDO TABELA frete
ALTER TABLE frete DROP COLUMN distancia

-- CONSULTANDO TABELAS
SELECT * FROM endereco
SELECT * FROM cliente_fisico
SELECT * FROM cliente_juridico
SELECT * FROM cliente
SELECT * FROM departamento
SELECT * FROM funcionario
SELECT * FROM pedido
SELECT * FROM produto
SELECT * FROM fornecedor
SELECT * FROM frete
SELECT * FROM dept_produto

-- FINALMENTE O BANCO FOI ALIMENTADO!!!!

-- FAZER CONSULTA DE UM CLIENTE COM TODOS OS SEUS DADOS REGISTRADOS, SEM ENDEREÇO  "Clientes Fisicos"
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico

-- FAZER A CONSULTA DE TODOS OS DADOS INCLUINDO ENDEREÇO (FUNIONANDO) "Clientes Fisicos"
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco

-- FAZER CONSULTA COM A RELAÇAO FORNECEDOR E PRODUTO
SELECT p.nome AS produto, p.valor, p.descricao, f.nome AS fornecedor, f.cnpj
FROM produto p INNER JOIN  produto_fornecedor pf ON p.IDProduto = pf.ID_Produto
INNER JOIN fornecedor f on pf.ID_Fornecedor = f.IDFornecedor

-- FAZER UMA CONSULTA COM OS FUNCIONARIOS E SEUS ENDEREÇOS
SELECT f.nome, f.cpf, f.email, f.sexo, e.estado, e.cidade, e.rua, e.tipo
FROM funcionario f INNER JOIN endereco_funcionario ef ON F.IDFuncionario = ef.ID_Funcionario
INNER JOIN endereco e ON E.IDEnderco = ef.ID_Endereco_FC
