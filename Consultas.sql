-- Fazendo as consultas no banco total 10 (usar minimo 2 tabelas)

-- 1° Pesquisar Cliente Fisico, exibindo todos os dados incluindo o endereço
-- Usar um WHERE para pesquisar pelo "cpf" da pessoa
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco

-- 2° Pesquisar Cliente Juridico, exibindo todos os dados incluindo o endereço
-- Usar um WHERE para pesquisar pelo "cnpj" da pessoa
SELECT c.IDCliente AS ID, c.nome, c.email, c.telefone, cj.cnpj, cj.razao_social, cj.ramo,
cj.estado_de_funcionamento, e.estado, e.cidade, e.rua
FROM cliente c INNER JOIN cliente_juridico cj ON c.ID_PJ = cj.IDCliente_juridico INNER JOIN endereco e ON
c.ID_Endereco = e.IDEnderco

-- Consulta qualquer cliente inserindo o cpf ou cnpj
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco

-- 3° Pesquisar Funcionario, exibindo todos os dados incluindo o endereço
-- Usar um WHERE para pesquisar pelo "cpf" da pessoa
SELECT f.nome, f.cpf, f.email, f.sexo, e.estado, e.cidade, e.rua, e.tipo, d.nome AS departamento
FROM funcionario f INNER JOIN endereco_funcionario ef ON F.IDFuncionario = ef.ID_Funcionario
INNER JOIN endereco e ON E.IDEnderco = ef.ID_Endereco_FC INNER JOIN departamento d
ON d.IDDepartamento = f.ID_Departamento

-- FAZER CONSULTA COM A RELAÇAO FORNECEDOR E PRODUTO
SELECT p.nome AS produto, p.valor, p.descricao, f.nome AS fornecedor, f.cnpj
FROM produto p INNER JOIN  produto_fornecedor pf ON p.IDProduto = pf.ID_Produto
INNER JOIN fornecedor f on pf.ID_Fornecedor = f.IDFornecedor

-- Ver o gasto com salarios bases de todos os funcionarios
SELECT SUM(f.salario) AS soma_dos_salarios,  FROM funcionario f

-- Tenho que dá uma olhada nos meu codigos fontes sobre consultas!!!
