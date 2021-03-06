% Tomado de http://www.swi-prolog.org/pldoc/man?section=clpfd-sudoku
:- use_module(library(clpfd)).

/*
 * Verificar que:
 * * Há 9 linhas;
 * * Cada linha possui mesmo comprimento de 9;
 * * Cada elemento está entre 1 e 9;
 * * Em cada linha, todos os elementos são distintos;
 * * Em cada coluna, todos os elementos são distintos;
 * * Blocos 3x3 são válidos;
 * Detalhes linha por linha podem ser vistos no relatório
 */
sudoku(Rows) :-
        length(Rows, 9), maplist(same_length(Rows), Rows),
        append(Rows, Vs), Vs ins 1..9,
        maplist(all_distinct, Rows),
        transpose(Rows, Columns),
        maplist(all_distinct, Columns),
        Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
        blocks(As, Bs, Cs),
        blocks(Ds, Es, Fs),
        blocks(Gs, Hs, Is).

/*
 * Utilizamos recursão para verificar os blocos. Para cada trio de linhas recebido, extrai-se as 3 primeiras
 * colunas da cabeça da lista e verifica-se se todos os elementos são distintos, continuando a recursão no
 * restante da linha. A recursão acaba se não houver mais elementos na linha.
 */
blocks([], [], []).
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
        all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
        blocks(Ns1, Ns2, Ns3).

% Casos de teste
% Válido
problem(1, [[_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,_,8,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9]]).

% Inválido (elemento fora de 1..9)
problem(2, [[_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,_,10,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9]]).

% Inválido (sem soluções)
problem(3, [[_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,2,8,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9]]).

% Inválido (múltiplas soluções)
problem(4, [[_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_]]).

% Inválido (múltiplas soluções)
problem(5, [[_,8,_,_,_,9,7,4,3],
            [_,5,_,_,_,8,_,1,_],
            [_,1,_,_,_,_,_,_,_],
            [8,_,_,_,_,5,_,_,_],
            [_,_,_,8,9,4,_,_,_],
            [_,_,_,3,_,_,_,_,6],
            [_,_,_,_,_,_,_,7,_],
            [_,3,_,5,_,_,_,8,_],
            [9,7,2,4,_,_,_,5,_]]).

% Inválido (2 soluções)
problem(6, [[_,3,9,_,_,_,1,2,_],
            [_,_,_,9,_,7,_,_,_],
            [8,_,_,4,_,1,_,_,6],
            [_,4,2,_,_,_,7,9,_],
            [_,_,_,_,_,_,_,_,_],
            [_,9,1,_,_,_,5,4,_],
            [5,_,_,1,_,9,_,_,3],
            [_,_,_,8,_,5,_,_,_],
            [_,1,4,_,_,_,8,7,_]]).

% Válido
problem(7, [[_,_,_,2,6,_,7,_,1],
            [6,8,_,_,7,_,_,9,_],
            [1,9,_,_,_,4,5,_,_],
            [8,2,_,1,_,_,_,4,_],
            [_,_,4,6,_,2,9,_,_],
            [_,5,_,_,_,3,_,2,8],
            [_,_,9,3,_,_,_,7,4],
            [_,4,_,_,5,_,_,3,6],
            [7,_,3,_,1,8,_,_,_]]).

% Válido
problem(8, [[1,_,_,_,_,7,_,9,_],
            [_,3,_,_,2,_,_,_,8],
            [_,_,9,6,_,_,5,_,_],
            [_,_,5,3,_,_,9,_,_],
            [_,1,_,_,8,_,_,_,2],
            [6,_,_,_,_,4,_,_,_],
            [3,_,_,_,_,_,_,1,_],
            [_,4,_,_,_,_,_,_,7],
            [_,_,7,_,_,_,3,_,_]]).
