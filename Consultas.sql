-- CONSULTAS

-- 1° Pesquisar Cliente Fisico, exibindo todos os dados incluindo o endereço
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco
WHERE cf.cpf ='12345678912'

-- 2° Pesquisar Funcionario, exibindo todos os dados incluindo o Endereço e Departamento
SELECT f.nome, f.cpf, f.email, f.sexo, e.estado, e.cidade, e.rua, e.tipo, d.nome AS departamento
FROM funcionario f INNER JOIN endereco_funcionario ef ON F.IDFuncionario = ef.ID_FuncionarioEF
INNER JOIN endereco e ON E.IDEnderco = ef.ID_EnderecoEF INNER JOIN dept_funcionario d
ON d.IDDept_Funcioanrio = f.ID_DepartamentoFc

--3° FAZER CONSULTA DE QUAIS PRODUTOS É FORNECIDO POR UM FORNECEDOR
SELECT p.nome AS produto, p.valor, p.descricao, f.nome AS fornecedor, f.cnpj
FROM produto p INNER JOIN  produto_fornecedor pf ON p.IDProduto = pf.ID_ProdutoPF
INNER JOIN fornecedor f on pf.ID_FornecedorPF = f.IDFornecedor WHERE f.nome = 'Multilaser'

-- 4° Consultar todos os pedidos de um determinado produto
SELECT pe.IDPedido,  pe.tipo ,pe.estado, pe.data_do_pedido, pe.data_da_entrega,
pp.Quantidade, po.valor AS valor_prduto, po.nome FROM pedido pe INNER JOIN
produto_pedido pp ON pe.IDPedido = pp.ID_PedidoPP
INNER JOIN produto po ON po.IDProduto = pp.ID_ProdutoPP WHERE ID_ProdutoPP = 101

-- 5° Media de idade e a quantidade total dos meus clientes fisicos
SELECT AVG(YEAR(getdate()) - YEAR(cf.data_nasc)) AS media_idade, COUNT(c.nome) AS Total_Clientes
FROM cliente c INNER JOIN cliente_fisico cf ON c.ID_PF = cf.IDCliente_fisico

-- 6° Consultar todos os pedidos feitos em um periodo determinado (OK)
SELECT c.nome AS Cliente,pe.data_do_pedido AS data_do_pedido, pe.data_da_entrega AS data_de_entrega, pe.tipo AS Tipo_do_Pedido,
c.email, c.telefone FROM pedido pe INNER JOIN cliente c ON c.IDCliente = pe.ID_ClienteCl
WHERE pe.data_do_pedido BETWEEN '01-05-2020' AND '20-05-2020'

--7° Contar quantos funcionarios tem por departamento e a soma dos salarios
SELECT df.nome AS Departamento, SUM(f.salario) AS soma_salario, COUNT(f.IDFuncionario) AS Funcionarios
FROM funcionario f INNER JOIN dept_funcionario df on f.ID_DepartamentoFc = df.IDDept_Funcioanrio
GROUP BY df.nome

-- 8° Consultar os dados dos produtos de um pedido
SELECT ((pp.Quantidade)*(p.valor)) AS Valores_pagos, pp.Quantidade, pp.ID_ProdutoPP, p.nome, p.marca
FROM produto_pedido pp INNER JOIN produto p on pp.ID_ProdutoPP = p.IDProduto WHERE pp.ID_PedidoPP = 15

-- 9° Valor total de um pedido
SELECT SUM((pp.Quantidade)*(p.valor)) AS Total_do_pedido
FROM produto_pedido pp INNER JOIN produto p on pp.ID_ProdutoPP = p.IDProduto WHERE pp.ID_PedidoPP = 14

-- 10° Consultar todos os pedidos feitos por um Cliente Fisico/Juridico especifo (produtos, frete)
SELECT c.nome AS Cliente, pe.data_do_pedido, pe.data_da_entrega,p.nome AS Nome, p.valor AS Valor
FROM pedido pe INNER JOIN cliente c ON c.IDCliente = pe.ID_ClienteCl INNER JOIN produto_pedido pp
ON pp.ID_PedidoPP = pe.IDPedido INNER JOIN produto p ON p.IDProduto = pp.ID_ProdutoPP
WHERE c.nome = 'Darcilene Xavier'

