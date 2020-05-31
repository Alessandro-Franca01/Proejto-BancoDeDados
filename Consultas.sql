-- Codigo das consultas ao banco (total 10 )

-- 1° Pesquisar Cliente Fisico, exibindo todos os dados incluindo o endereço (OK)
-- Usar um WHERE para pesquisar pelo "cpf" da pessoa ( Dentro do programa posso entrar com cpf ou cnpj)
SELECT c.nome, c.email, c.telefone, cf.rg, cf.sexo, cf.cpf, e.estado, e.cidade ,e.bairro FROM cliente c
INNER JOIN cliente_fisico cf on c.ID_PF = cf.IDCliente_fisico INNER JOIN endereco e ON c.ID_Endereco = e.IDEnderco
WHERE cf.cpf ='12345678912'

-- 2° Pesquisar Funcionario, exibindo todos os dados incluindo o endereço (OK)
SELECT f.nome, f.cpf, f.email, f.sexo, e.estado, e.cidade, e.rua, e.tipo, d.nome AS departamento
FROM funcionario f INNER JOIN endereco_funcionario ef ON F.IDFuncionario = ef.ID_Funcionario
INNER JOIN endereco e ON E.IDEnderco = ef.ID_Endereco_FC INNER JOIN departamento d
ON d.IDDepartamento = f.ID_Departamento

-- 3° FAZER CONSULTA DE QUAIS PRODUTOS É FORNECIDO POR UM FORNECEDOR (OK)
SELECT p.nome AS produto, p.valor, p.descricao, f.nome AS fornecedor, f.cnpj
FROM produto p INNER JOIN  produto_fornecedor pf ON p.IDProduto = pf.ID_Produto
INNER JOIN fornecedor f on pf.ID_Fornecedor = f.IDFornecedor WHERE f.nome = 'Multilaser'

-- Ver o gasto com salarios bases de todos os funcionarios (A TERMINAR AINDA)
SELECT SUM(f.salario) AS soma_dos_salarios FROM funcionario f

-- 4° Consultar todos os pedidos de um determinado produto: FUNCIONANDO 
SELECT pe.IDPedido,  pe.tipo ,pe.estado, pe.valor, pe.data_pedido, pe.data_entrega,
    pp.Quantidade, po.valor AS valor_prduto, po.nome FROM pedido pe INNER JOIN
    produto_pedido pp ON pe.IDPedido = pp.ID_Pedido
    INNER JOIN produto po ON po.IDProduto = pp.ID_Produto WHERE ID_Produto = 101

