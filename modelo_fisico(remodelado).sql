-- IMPLEMENTAÇAO FISICA DO BANCO DE DADOS
-- ESSE ARQUIVO ESTA PEDINDO A SENHA, PARA DESBLOQUEAR PARA CADA COMANDO NO TERMINAL
-- Ultima atualização 21-05-2020

CREATE DATABASE projeto_banco_test

USE projeto_banco_test

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
	estado VARCHAR(30),
	ID_Cliente tinyint,
	CONSTRAINT FK_idCliente FOREIGN KEY (ID_Cliente) REFERENCES dbo.cliente (IDCliente),
	ID_Vendedor TINYINT, -- PODE RECEBER VALOR NULL
	CONSTRAINT FK_idVendedor FOREIGN KEY (ID_Vendedor) REFERENCES dbo.funcionario (IDFuncionario)
)

CREATE TABLE dbo.pagamento(
    IDPagamento TINYINT PRIMARY KEY IDENTITY(30,1),
    tipo VARCHAR(20) CHECK (tipo IN ('Credito','Debito','Boleto')), --TENHO QUE ACRESCENTAR 'Especie'
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

-- AJUSTAR TODOS OS INSERTS, SEGUNDO A REMODELAGEM!!!
-- INSERINDO ENDEREÇOS (INSERIDO)
-- UNIDO COM CLIENTES:
INSERT INTO endereco VALUES ('PB','cabedelo', '58310015', 'Centro', 'Campina da Vila', 185, null) --ok
INSERT INTO endereco VALUES ('SP','sao paulo', '78400208', 'Centro', 'Rua nova', 105, 'apt') -- ok
INSERT INTO endereco VALUES ('RJ','niteroi', '34200208', 'Centro', 'duque de sa', 10, 'apt') -- ok
INSERT INTO endereco VALUES ('PB', 'Joao Pessoa', '20190420', 'bairro dos est','Parana', 123, 'residencia')
INSERT INTO endereco VALUES ('PB', 'cabedelo', '20190310', 'Intermares','Rua Niel Castro', 12, 'apt') -- ok
INSERT INTO endereco VALUES ('PB', 'Joao Pessoa', '20898326', 'Centro','Rua Pedro Alves', 103, NULL) -- ok
INSERT INTO endereco VALUES ('PB','Campina Grande','31097835','Centro', 'Av. Palmeiras',421,'apt') -- ok
INSERT INTO endereco VALUES ('PB','Joao Pessoa','20180322','Ipes','R. Candido',NULL,'predio')

-- Ajeitando uns registros
UPDATE endereco SET estado = 'PB' WHERE estado ='RB'

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

-- INSERNIDO CLIENTES (Esses registros que tem FKs tem que dá uma revisada) Proguesso: 9/9 clientes
INSERT INTO cliente VALUES ('Darcilene Xavier','Darci@hotmail.com','839872653',6,2,NULL)
INSERT INTO cliente VALUES ('Sandrinho', 'sandro@gmail.com', '839822114435', 1, 1, null)
INSERT INTO cliente VALUES ('Oficina do Carlos', 'carlos@hotmail.com', '12344598700',3, null, 23)
INSERT INTO cliente VALUES ('Prefeitura João Pessoa','sec_pb@gov.com','8331240965',4,NULL,20)
INSERT INTO cliente VALUES ('Restaurante Popular','rest_pop@hotmail.com','83934902311',7, NULL,22)
INSERT INTO cliente VALUES ('Camila Silva','cami_21@hotmail.com','83986538540',9,5,NULL)
INSERT INTO cliente VALUES ('Roberto Martins','robert_@hotmail.com','34980124365',2,3,NULL)
INSERT INTO cliente VALUES ('Marcio Alves','marcio15@gmail.com','83987123580',7,6,NULL)
INSERT INTO cliente VALUES ('Hotel Passe Bem','passebem@hotmail.com','83981732441',11,NULL,21)

SELECT * FROM cliente_fisico
SELECT * FROM cliente_juridico
SELECT * FROM endereco
SELECT * FROM cliente

-- Arrumando a casa (Da uma olhada como altera o registro 'Update/Delete/Alter')
DELETE cliente WHERE IDCliente = 3 -- Funcionou!!!

-- INSERINDO Departamento  (INSERIDO) 
INSERT INTO departamento VALUES ('TIF','INSFRAESTRUTURA', 'TI na area de infraestrutura ')
INSERT INTO departamento VALUES ('TID', 'DESENVOLIMENTO', 'TI na area de desenvolvimento')
INSERT INTO departamento VALUES ('VED', 'VENDAS', 'Departamento de vendas')
INSERT INTO departamento VALUES ('C&L', 'Compras', 'Compras e Logistica')
--INSERT INTO departamento VALUES ('VED', 'VENDAS', 'Departamento de vendas')  -- Depois faço esse registro!!

-- INSERINDO Funcionario (INSERIDO) * Inserir os registros de endereços dos funcionarios
INSERT INTO funcionario VALUES ('Alessandro', 'alessandro@gmail.com','83981423980','M','123445566','12344455512',
                                NULL,NULL,'Programdor', 'Desenvolvimento de Software','TID')
INSERT INTO funcionario VALUES ('Marcos', 'marcos@yahoo.com', '83912344321','M','124345678','1243256711',0.50,0.10,
                                NULL,NULL,'VED')
INSERT INTO funcionario VALUES ('Leandro', 'leandro007@yahoo.com', '83912312561','M','1242134568','1436256089',NULL,NULL,
                                NULL,NULL,'C&L')
INSERT INTO funcionario VALUES ('Jefferson', 'Jeff@gmail.com', '83988901402','M','236890478','1436706711',0.60,0.30,
                                NULL,NULL,'VED')


-- INSERINDO Pedidos (Tabela) #Falta completar o pedido!!
INSERT INTO pedido VALUES ('13-05-2020','20-05-2020','online',300.00,'Pronto p/ enviar',1,10)

-- INSERINDO Departamentos de Produtos
INSERT INTO dept_produto VALUES ('GAM','Games','Jogos e acessorios')
INSERT INTO dept_produto VALUES ('ESC','OFFICE','acessorios de escritorio')

-- INSERINDO Fornecedor
INSERT INTO fornecedor VALUES ('SONY','1234556778','produto','jogos e consoles',null)

-- INSERINDO Produto
INSERT INTO produto VALUES ('Playstation 4','123345512','1234345','Console de video game',3000.00,5,null,'GAM')

-- INSERINDO Produto_Fornecedor
INSERT INTO produto_fornecedor VALUES (1,100)

-- INSERINDO Frete
INSERT INTO frete VALUES ('14-05-2020','23-05-2020',65.00,400.45)


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

-- INSERINDO CLIENTES
INSERT INTO cliente VALUES ('Sandrinho', 'sandro@gmail.com', '839822114435', 1, 1, null)
INSERT INTO cliente VALUES ('Oficina do Carlos', 'carlos@hotmail.com', '12344598700',3, null, 21)

-- FAZER CONSULTA DE UM CLIENTE COM TODOS OS SEUS DADOS REGISTRADOS, SEM ENDEREÇO
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico

-- FAZER A CONSULTA DE TODOS OS DADOS INCLUINDO ENDEREÇO (FUNIONANDO)
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco

-- FAZER CONSULTA COM A RELAÇAO FORNECEDOR E PRODUTO
SELECT p.nome AS produto, p.valor, p.descricao, p.lote, f.nome AS fornecedor, f.cnpj
FROM produto p INNER JOIN  produto_fornecedor pf ON p.IDProduto = pf.ID_Produto
INNER JOIN fornecedor f on pf.ID_Fornecedor = f.IDFornecedor
