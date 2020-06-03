-- Criando a base de dados
CREATE DATABASE projeto_loja_informatica
-- Entrando no banco
USE projeto_loja_informatica
-- Criando o schema dbo
CREATE SCHEMA dbo

--DROP DATABASE projeto_loja_informatica  (Reemplementar)

-- Começar a ORGANIZAR AS TABELAS:
CREATE TABLE dbo.endereco(
	IDEnderco TINYINT
        CONSTRAINT PK_IDEndereco PRIMARY KEY IDENTITY,
	estado CHAR(2) NOT NULL
        CONSTRAINT CK_Estado CHECK (estado LIKE '[A-Z][A-Z]'),
	cidade VARCHAR(20) NOT NULL,
	cep VARCHAR(12),
	bairro VARCHAR(15),
	rua VARCHAR(15),
	numero SMALLINT,
	tipo VARCHAR(10)
)

-- Criando a tabela Cliente Fisico
CREATE TABLE dbo.cliente_fisico(
	IDCliente_fisico TINYINT
        CONSTRAINT PK_IDCliente_fisico PRIMARY KEY IDENTITY,
	sexo CHAR(1) NOT NULL
	    CONSTRAINT CK_Sexo CHECK (sexo IN ('F','M')),
	data_nasc DATE,
	rg VARCHAR(12) NOT NULL
	    CONSTRAINT UN_Rg_Cf UNIQUE,
	cpf VARCHAR(15) NOT NULL
	    CONSTRAINT UN_Cpf_Cf UNIQUE,
)
-- ARRUMAR OS INSERTS COM AS DATAS DE NASCIMENTO...

-- Criando a tabela Cliente Juridico
CREATE TABLE dbo.cliente_juridico(
	IDCliente_juridico TINYINT
	    CONSTRAINT PK_IDCliente_juridico PRIMARY KEY IDENTITY(20,1),
	cnpj VARCHAR(15) NOT NULL
	    CONSTRAINT UN_Cnpj_Cj UNIQUE,
	razao_social VARCHAR(30),
	data_abertura DATE,
	estado_de_funcionamento VARCHAR(30),
	ramo VARCHAR(50),
	descricao VARCHAR(40)
 )

-- Criando a tabela Cliente
CREATE TABLE dbo.cliente(
  	IDCliente TINYINT
  	    CONSTRAINT PK_IDCliente PRIMARY KEY IDENTITY,
  	nome VARCHAR(40) NOT NULL,
  	email VARCHAR(20),
	telefone VARCHAR(12),
    ID_Endereco TINYINT,
	    CONSTRAINT FK_EnderecoCl FOREIGN KEY (ID_Endereco) REFERENCES  endereco  (IDEnderco),
	ID_PF TINYINT,
	    CONSTRAINT FK_PF FOREIGN KEY (ID_PF) REFERENCES cliente_fisico (IDCliente_fisico),
	ID_PJ TINYINT,
	    CONSTRAINT FK_PJ FOREIGN KEY (ID_PJ) REFERENCES cliente_juridico (IDCliente_juridico)
)

-- Criando tabela departamento
CREATE TABLE dbo.dept_funcionario(
	IDDept_Funcioanrio CHAR(3)
	    CONSTRAINT PK_IDDepartamento PRIMARY KEY
        CHECK (IDDept_Funcioanrio LIKE '[A-Z][A-Z][A-Z]'),
	nome VARCHAR(15) NOT NULL,
	descricao VARCHAR(30)
)
-- INSERINDO REGISTRO (TESTANDO..)
INSERT INTO dept_funcionario VALUES ('TI0','INSFRAESTRUTURA', 'TI na area de infraestrutura ') -- ERRO
INSERT INTO dept_funcionario VALUES ('TIF','INSFRAESTRUTURA', 'TI na area de infraestrutura ') -- PEGO

-- Criando tabela Funcionario ( AJUSTAR OS INSERTs )
CREATE TABLE dbo.funcionario(
	IDFuncionario TINYINT
	    CONSTRAINT PK_Funcionario PRIMARY KEY IDENTITY,
	nome VARCHAR(40) NOT NULL,
  	email VARCHAR(20),
	celular VARCHAR(12),
	sexo CHAR(1) NOT NULL
	    CONSTRAINT CK_Sexo_Fc CHECK (sexo IN ('F','M')),
	rg VARCHAR(12) NOT NULL
	    CONSTRAINT UN_Rg_Fc UNIQUE,
	cpf VARCHAR(15) NOT NULL
	    CONSTRAINT UN_Cpf_Fc UNIQUE,
	salario MONEY,
    data_nasc DATE,
	-- VENDEDOR
	meta NUMERIC(4,2),
	participacao_vendas NUMERIC(4,2),
	-- PROGRAMADOR
	area_de_atuacao VARCHAR(30),
	tipo_de_servico VARCHAR(30),
	ID_DepartamentoFc CHAR(3) NOT NULL,
	CONSTRAINT FK_DepartamentoFc FOREIGN KEY (ID_DepartamentoFc) REFERENCES dbo.dept_funcionario (IDDept_Funcioanrio),
)

-- Criando a tabela de Endereço para Funcionario
CREATE TABLE dbo.endereco_funcionario(
    ID_FuncionarioEF TINYINT NOT NULL,
    ID_EnderecoEF TINYINT NOT NULL,
    CONSTRAINT PK_Funcionario_Endereco PRIMARY KEY (ID_FuncionarioEF,ID_EnderecoEF),
    CONSTRAINT Fk_FuncionarioEF FOREIGN KEY (ID_FuncionarioEF) REFERENCES dbo.funcionario (IDFuncionario),
    CONSTRAINT FK_EnderecoEF FOREIGN KEY (ID_EnderecoEF) REFERENCES dbo.endereco (IDEnderco)
)

-- Criando tabela pedido
CREATE TABLE dbo.pedido(
	IDPedido TINYINT
	    CONSTRAINT PK_Pedido PRIMARY KEY IDENTITY(10,1),
	data_do_pedido datetime NOT NULL,
	data_da_entrega datetime NOT NULL,
	tipo VARCHAR(15) NOT NULL
	    CONSTRAINT CK_tipo_pedido check (tipo in ('online','presencial')),
	estado VARCHAR(30)
	    CONSTRAINT CK_estado_pedido CHECK (estado IN('enviado','entregue','para enviar')),
	ID_ClienteCl tinyint,
	    CONSTRAINT FK_Cliente FOREIGN KEY (ID_ClienteCl) REFERENCES dbo.cliente (IDCliente),
	ID_VendedorFc TINYINT,
	    CONSTRAINT FK_Vendedor FOREIGN KEY (ID_VendedorFc) REFERENCES dbo.funcionario (IDFuncionario)
)

-- Criando tabela pagamento
CREATE TABLE dbo.pagamento(
    IDPagamento TINYINT
        CONSTRAINT PK_IDPagamento PRIMARY KEY IDENTITY(30,1),
    tipo_pagamento VARCHAR(20) NOT NULL
        CONSTRAINT CK_tipo_pagamento CHECK(tipo_pagamento IN ('Credito','Debito','Boleto')),
    estado_pagamento VARCHAR(30)
        CONSTRAINT CK_estado_pagamento CHECK (estado_pagamento IN ('Em espera','Feito','Nao efetuado')),
    parcelas TINYINT NOT NULL,
    ID_PedidoPg TINYINT NOT NULL,
    CONSTRAINT FK_PedidoPg FOREIGN KEY (ID_PedidoPg) REFERENCES dbo.pedido (IDPedido)
)

-- Criando tabela fornecedor
CREATE TABLE dbo.fornecedor(
    IDFornecedor TINYINT
        CONSTRAINT PK_IDFornecedor PRIMARY KEY IDENTITY,
    nome VARCHAR(40) NOT NULL,
    cnpj VARCHAR(15) NOT NULL
        CONSTRAINT UN_Cnpj_Fn UNIQUE,
    tipo_Fn VARCHAR(30)
        CONSTRAINT CK_Tipo_Fn CHECK (tipo_Fn IN ('Frete', 'Produto')),
    descricao    VARCHAR(50),
    ID_EnderecoFn  TINYINT,
    CONSTRAINT FK_EnderecoFn FOREIGN KEY (ID_EnderecoFn) REFERENCES dbo.endereco (IDEnderco)
)

--Criando a tabela departamento de produtos (Dept_produto)
CREATE TABLE dbo.dept_produto(
    IDDept_produto CHAR(3)
        CONSTRAINT PK_IDDept_produto PRIMARY KEY
        CONSTRAINT CK_Dept_produto CHECK (IDDept_produto LIKE'[A-Z][A-Z][A-Z]'),
    nome VARCHAR(30) NOT NULL,
    desricao VARCHAR(40),
)

-- Criando a tabela produto
CREATE TABLE dbo.produto(
    IDProduto TINYINT
        CONSTRAINT PK_IDProduto PRIMARY KEY IDENTITY(100,1),
    nome VARCHAR(30) NOT NULL,
    descricao VARCHAR(40),
    marca VARCHAR(30),
    valor smallmoney NOT NULL,
    estoque smallint NOT NULL,
    ID_Dept_produto CHAR(3) NOT NULL
    CONSTRAINT CK_Produto_Dept CHECK (ID_Dept_produto LIKE'[A-Z][A-Z][A-Z]'),
    CONSTRAINT FK_Dept_Produto FOREIGN KEY (ID_Dept_produto) REFERENCES dbo.dept_produto (IDDept_produto)
)

-- Criando a tabela produto pedido
CREATE TABLE dbo.produto_pedido(
   ID_ProdutoPP TINYINT NOT NULL,
   ID_PedidoPP TINYINT NOT NULL,
   Quantidade SMALLINT NOT NULL,
   CONSTRAINT PK_Produto_Pedido PRIMARY KEY (ID_ProdutoPP,ID_PedidoPP),
   CONSTRAINT FK_Produto_PP FOREIGN KEY (ID_ProdutoPP) REFERENCES dbo.produto (IDProduto),
   CONSTRAINT FK_Pedido_PP FOREIGN KEY (ID_PedidoPP) REFERENCES dbo.pedido (IDPedido)
)

-- Criando a tabela da relção de produto e fornecedor
CREATE TABLE dbo.produto_fornecedor(
    ID_FornecedorPF TINYINT NOT NULL ,
    ID_ProdutoPF TINYINT NOT NULL,
    CONSTRAINT PK_Produto_Fornecedor PRIMARY KEY (ID_FornecedorPF,ID_ProdutoPF),
    CONSTRAINT FK_FornecedorPF FOREIGN KEY (ID_FornecedorPF) REFERENCES dbo.fornecedor (IDFornecedor),
    CONSTRAINT FK_ProdutoPF FOREIGN KEY (ID_ProdutoPF) REFERENCES dbo.produto (IDProduto)
)

-- Criando a tabela frete
CREATE TABLE dbo.frete(
    IDFrete TINYINT
        CONSTRAINT PK_IDFrete PRIMARY KEY IDENTITY(10,1),
    data_de_saida DATETIME NOT NULL,
    previsao_de_entrega DATETIME NOT NULL,
    valor SMALLMONEY NOT NULL,
    ID_FornecedorFt TINYINT NOT NULL,
    CONSTRAINT FK_FornecdorFt FOREIGN KEY (ID_FornecedorFt) REFERENCES dbo.fornecedor (IDFornecedor),
    ID_PedidoFt TINYINT NOT NULL,
    CONSTRAINT FK_PedidoFt FOREIGN KEY (ID_PedidoFt) REFERENCES dbo.pedido (IDPedido)
)

-- FINALIZADO CODIGO ESTRUTURAL DA DATABSE

-- ALIMENTO O BANCO DE DADOS

-- INSERINDO ENDEREÇOS
-- ENDEREÇOS DE CLIENTES:
INSERT INTO endereco(ESTADO, CIDADE, CEP, BAIRRO, RUA, NUMERO, TIPO) VALUES ('PB','cabedelo', '58310015', 'Centro', 'Campina da Vila', 185, null)
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('SP','sao paulo', '78400208', 'Centro', 'Rua nova', 105, 'apt')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('RJ','niteroi', '34200208', 'Centro', 'duque de sa', 10, 'apt')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB', 'Joao Pessoa', '20190420', 'bairro dos est','Parana', 123, 'residencia')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB', 'cabedelo', '20190310', 'Intermares','Rua Niel Castro', 12, 'apt')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB', 'Joao Pessoa', '20898326', 'Centro','Rua Pedro Alves', 103, NULL)
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','Campina Grande','31097835','Centro', 'Av. Palmeiras',421,'apt')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','Joao Pessoa','20180322','Ipes','R. Candido',NULL,'predio')

-- ENDEREÇO DE FUNCIONARIOS
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PE','Recife','70555004','Centro','Pedro Almeida',1200,'residencia')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PE', 'Refice','70555004','Centro','Castro Rui',135,'residencia')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','Cabedelo','58310020','Monte Castelo','Agusto Firmo P.',154,'residencia')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','Joao Pessao','54030897','Geisel','Carlos Pinho',569,'apt')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','Campina Grande','30400265','Centro','Alfredo Frio',1089,NULL)

-- ENDEREÇO DE FORNCEDORES
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PE','Olinda','97854320','Ponta de Mato','Pedro Camelo',101,NULL)
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','CABELO','52398671','Intermares','Mar Vermelho',451,'predio')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('PB','João Pessoa','57410652','Pedra Fina','Paulo Augusto',47,'predio')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('SP','São Caetano','47852639','Jose Guedes','Alto Porto',121,'predio')
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('RJ','Macae','57896421','João Pescador','Silva Pontes',401,NULL)
INSERT INTO endereco (estado, cidade, cep, bairro, rua, numero, tipo) VALUES ('RJ','Rio de Janeiro','52496873','Rio Branco','Carlos Santos',1381,'predio')

-- INSERNIDO CLIENTES FISICOS
INSERT INTO cliente_fisico (sexo, data_nasc, rg, cpf) VALUES ('M','20-05-1979','123456789','12345678912')
INSERT INTO cliente_fisico (sexo, data_nasc, rg, cpf) VALUES ('F','12-03-1989','123421423','12353122349')
INSERT INTO cliente_fisico (sexo, data_nasc, rg, cpf) VALUES ('M','09-09-1992','123444512','12334509834')
INSERT INTO cliente_fisico (sexo, data_nasc, rg, cpf) VALUES ('F','24-05-1980','123786312','12365489084')
INSERT INTO cliente_fisico (sexo, data_nasc, rg, cpf) VALUES ('M','13-01-1966','082937143','82789347383')

-- INSERNIDO CLIENTES JURIDICOS
INSERT INTO cliente_juridico (cnpj, razao_social, data_abertura, estado_de_funcionamento, ramo, descricao) VALUES ('12345678921', 'restaurante popular', '20-05-1869','ativo','alimentacao', 'Venda de comidas populares')
INSERT INTO cliente_juridico (cnpj, razao_social, data_abertura, estado_de_funcionamento, ramo, descricao) VALUES ('12456409809', 'auto peças Carlos', '23-01-1959','Ativo', 'mequanica automoveis', 'Mecanica de automaveis em geral')
INSERT INTO cliente_juridico (cnpj, razao_social, data_abertura, estado_de_funcionamento, ramo, descricao) VALUES ('10938374913', 'prefeitura Joao Pessoa', '21-12-2009','ativo','governamental', 'Orgão governamental')
INSERT INTO cliente_juridico (cnpj, razao_social, data_abertura, estado_de_funcionamento, ramo, descricao) VALUES ('32450987590', 'Hotel Passe Bem','14-08-2017', 'inativo','hospedagem', 'Serviço de hotelaria e Turismo')

-- INSERNIDO CLIENTES
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Darcilene Xavier','Darci@hotmail.com','839872653',6,2,NULL)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Sandrinho', 'sandro@gmail.com', '839822114435', 1, 1, NULL)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Oficina do Carlos', 'carlos@hotmail.com', '12344598700',3, NULL, 23)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Prefeitura João Pessoa','sec_pb@gov.com','8331240965',4,NULL,20)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Restaurante Popular','rest_pop@hotmail.com','83934902311',7, NULL,22)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Camila Silva','cami_21@hotmail.com','83986538540',9,5,NULL)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Roberto Martins','robert_@hotmail.com','34980124365',2,3,NULL)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Marcio Alves','marcio15@gmail.com','83987123580',7,4,NULL)
INSERT INTO cliente (nome, email, telefone, ID_Endereco, ID_PF, ID_PJ) VALUES ('Hotel Passe Bem','passebem@hotmail.com','83981732441',11,NULL,21)

-- INSERINDO Departamento
INSERT INTO dept_funcionario (IDDept_Funcioanrio, nome, descricao) VALUES ('TIF','INSFRAESTRUTURA', 'TI na area de infraestrutura ')
INSERT INTO dept_funcionario (IDDept_Funcioanrio, nome, descricao) VALUES ('TID', 'DESENVOLIMENTO', 'TI na area de desenvolvimento')
INSERT INTO dept_funcionario (IDDept_Funcioanrio, nome, descricao) VALUES ('VED', 'VENDAS', 'Departamento de vendas')
INSERT INTO dept_funcionario (IDDept_Funcioanrio, nome, descricao) VALUES ('COL', 'Compras', 'Compras e Logistica')
INSERT INTO dept_funcionario (IDDept_Funcioanrio, nome, descricao) VALUES ('BIG','BIG DATA','Engenharia de dados')

-- INSERINDO Funcionario
INSERT INTO funcionario (nome, email, celular, sexo, rg, cpf, salario, data_nasc, meta, participacao_vendas, area_de_atuacao, tipo_de_servico, ID_DepartamentoFc)
VALUES ('Alessandro', 'alessandro@gmail.com','83981423980','M','123445566','12344455512',3500.00,'21-03-1983',NULL,NULL,'Programdor', 'Desenvolvimento de Software','TID')

INSERT INTO funcionario (nome, email, celular, sexo, rg, cpf, salario, data_nasc, meta, participacao_vendas, area_de_atuacao, tipo_de_servico, ID_DepartamentoFc)
VALUES ('Marcos', 'marcos@yahoo.com', '83912344321','M','124345678','1243256711',1500.00,'25-06-1993',0.50,0.10,NULL,NULL,'VED')

INSERT INTO funcionario (nome, email, celular, sexo, rg, cpf, salario, data_nasc, meta, participacao_vendas, area_de_atuacao, tipo_de_servico, ID_DepartamentoFc)
VALUES ('Leandro', 'leandro007@yahoo.com', '83912312561','M','1242134568','1436256089',2400.00,'18-02-1998',NULL,NULL,NULL,NULL,'COL')

INSERT INTO funcionario (nome, email, celular, sexo, rg, cpf, salario, data_nasc, meta, participacao_vendas, area_de_atuacao, tipo_de_servico, ID_DepartamentoFc)
VALUES ('Jefferson', 'Jeff@gmail.com', '8398890140','M','236890478','1436706711',2300.00,'20-12-2000',0.60,0.30,NULL,NULL,'VED')

INSERT INTO funcionario (nome, email, celular, sexo, rg, cpf, salario, data_nasc, meta, participacao_vendas, area_de_atuacao, tipo_de_servico, ID_DepartamentoFc)
VALUES ('Tania Soares','tan_soares@yahoo.com','8493428977','F','112798345','55437809145',3200.00,'10-07-1975',NULL,NULL,'Programador','Big Data','BIG')

-- INSERINDO Funcionario_Endereco
INSERT INTO endereco_funcionario (ID_FuncionarioEF, ID_EnderecoEF) VALUES (2,12)
INSERT INTO endereco_funcionario (ID_FuncionarioEF, ID_EnderecoEF) VALUES (4,13)
INSERT INTO endereco_funcionario (ID_FuncionarioEF, ID_EnderecoEF) VALUES (1,5)
INSERT INTO endereco_funcionario (ID_FuncionarioEF, ID_EnderecoEF) VALUES (3,8)
INSERT INTO endereco_funcionario (ID_FuncionarioEF, ID_EnderecoEF) VALUES (5,10)

-- INSERINDO Departamentos de Produtos
INSERT INTO dept_produto (IDDept_produto, nome, desricao) VALUES ('GAM','Games','Jogos e acessorios')
INSERT INTO dept_produto (IDDept_produto, nome, desricao) VALUES ('ESC','OFFICE','acessorios de escritorio')
INSERT INTO dept_produto (IDDept_produto, nome, desricao) VALUES ('SEV','Servidores','Departamento p/ Servidores')
INSERT INTO dept_produto (IDDept_produto, nome, desricao) VALUES ('CEL', 'Celulares', 'Departamento p/ Celulares')

-- INSERINDO Fornecedor
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('SONY','1234556778','produto','jogos e consoles',18)
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('LogTech','1320569848','produto','acessorios & games',14)
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('Multilaser','198837840','produto','Fornecedor de produtos em geral',15)
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('Logistica Inova','1345707892','frete','Logistica e Frete', 20) -- erro
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('Log Security','1834096721','frete','Serviço de Entrega',17)
INSERT INTO fornecedor (nome, cnpj, tipo_Fn, descricao, ID_EnderecoFn) VALUES ('Motorola','1234689301','produto','Celular',19)

-- INSERINDO Produto
INSERT INTO produto (nome, descricao, marca, valor, estoque, ID_Dept_produto) VALUES ('Playstation 4','Console gamer','Sony',3200.00,5,'GAM')
INSERT INTO produto (nome, descricao, marca, valor, estoque, ID_Dept_produto) VALUES ('Mouse Wi-fi', 'Acessorio PC','Multilaser',64.90,12,'ESC')
INSERT INTO produto (nome, descricao, marca, valor, estoque, ID_Dept_produto) VALUES ('Notebook AXG','Notebook Gamer','Multilaser',2459.00,10,'GAM')
INSERT INTO produto (nome, descricao, marca, valor, estoque, ID_Dept_produto) VALUES ('Servidor M37', 'Servidor p/ Internet', 'Multilaser',2890.00,4,'SEV')
INSERT INTO produto (nome, descricao, marca, valor, estoque, ID_Dept_produto) VALUES ('Moto G8', 'SmartPhone','Motorola',1200,15,'CEL')

-- INSERINDO Produto_Fornecedor
INSERT INTO produto_fornecedor (ID_FornecedorPF, ID_ProdutoPF) VALUES (1,100)
INSERT INTO produto_fornecedor (ID_FornecedorPF, ID_ProdutoPF) VALUES (2,101)
INSERT INTO produto_fornecedor (ID_FornecedorPF, ID_ProdutoPF) VALUES (3,102)
INSERT INTO produto_fornecedor (ID_FornecedorPF, ID_ProdutoPF) VALUES (3,103)
INSERT INTO produto_fornecedor (ID_FornecedorPF, ID_ProdutoPF) VALUES (6,104)

-- INSERINDO Pedidos (INSERIDO) * Posso fazer uma consulta para mostrar o valor do pedido!
INSERT INTO pedido (data_do_pedido, data_da_entrega, tipo, estado, ID_ClienteCl, ID_VendedorFc) VALUES ('13-05-2020','20-05-2020','online','entregue',2,NULL) -- PS4
INSERT INTO pedido (data_do_pedido, data_da_entrega, tipo, estado, ID_ClienteCl, ID_VendedorFc) VALUES ('20-05-2020', '26-05-2020','presencial','enviado',1,2) -- Mouse x2 *ID do vendedor erro:4
INSERT INTO pedido (data_do_pedido, data_da_entrega, tipo, estado, ID_ClienteCl, ID_VendedorFc) VALUES ('24-05-2020', '02-06-2020','online','para enviar',7,NULL)  -- Cell + Note
INSERT INTO pedido (data_do_pedido, data_da_entrega, tipo, estado, ID_ClienteCl, ID_VendedorFc) VALUES ('20-05-2020', '10-06-2020','presencial','enviado',1,4)  -- ps4 + cell

--INSERINDO Produto_Pedido (INSERIDO) (N:N) 'ID_Produto ,ID_Pedido, Quantidade'
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (100,14,1)
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (101,15,2)
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (102,16,1)
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (104,16,1)
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (100,17,1)
INSERT INTO produto_pedido (ID_ProdutoPP, ID_PedidoPP, Quantidade) VALUES (104,17,1)

--INSERINDO Pagamento (INSERIDO)
INSERT INTO pagamento (tipo_pagamento, estado_pagamento, parcelas, ID_PedidoPg) VALUES ('Boleto','Feito',8,14)
INSERT INTO pagamento (tipo_pagamento, estado_pagamento, parcelas, ID_PedidoPg) VALUES ('Credito','Em espera',2,15)
INSERT INTO pagamento (tipo_pagamento, estado_pagamento, parcelas, ID_PedidoPg) VALUES ('Debito','Nao efetuado',0,16)
INSERT INTO pagamento (tipo_pagamento, estado_pagamento, parcelas, ID_PedidoPg) VALUES ('Boleto','Feito',12,17)

-- INSERINDO Frete (INSERIDO)
INSERT INTO frete (data_de_saida, previsao_de_entrega, valor, ID_FornecedorFt, ID_PedidoFt) VALUES ('15-05-2020','19-05-2020',56.90,5,14)
INSERT INTO frete (data_de_saida, previsao_de_entrega, valor, ID_FornecedorFt, ID_PedidoFt) VALUES ('25-05-2020','01-06-2020',80.50,8,16)
