SELECT
    dep.nome AS "Nome Departamento",
    COUNT(emp.matr) AS QuantidadeEmpregados,
    ROUND(AVG(tsalario.salario - tdescontos.descontos), 2) AS "Media Salarial",
    MAX(tsalario.salario - tdescontos.descontos) AS "Maior Salario",
    MIN(tsalario.salario - tdescontos.descontos) AS "Menor Salario"
FROM
    departamento dep
    INNER JOIN empregado emp ON dep.cod_dep = emp.lotacao
    INNER JOIN (
        SELECT
            emp.matr,
            COALESCE(SUM(v.valor), 0) AS salario
        FROM
            empregado emp
            LEFT JOIN emp_venc ON emp.matr = emp_venc.matr
            LEFT JOIN vencimento v ON emp_venc.cod_venc = v.cod_venc
        GROUP BY
            emp.matr
    ) AS tsalario ON emp.matr = tsalario.matr
    INNER JOIN (
        SELECT
            emp.matr,
            COALESCE(SUM(desconto.valor), 0) AS descontos
        FROM
            empregado emp
            LEFT JOIN emp_desc ON emp.matr = emp_desc.matr
            LEFT JOIN desconto ON emp_desc.cod_desc = desconto.cod_desc
        GROUP BY
            emp.matr
    ) AS tdescontos ON emp.matr = tdescontos.matr
GROUP BY
    dep.cod_dep,
    dep.nome
ORDER BY
    "Media Salarial" DESC;
