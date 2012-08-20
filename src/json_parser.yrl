% Grammar for the JSON specification with yecc
% Copyright (C) 2012 Dickson S. Guedes

Nonterminals
    object
    members
    pair
    array
    elements
    value
    .

Terminals
    '{' '}'
    '[' ']'
    ':' ','
    string
    integer
    atom
    .

Rootsymbol object.

Nonassoc 10 object.
Nonassoc 20 value.
Nonassoc 30 array.

object ->   '$empty' :
	    [].
object ->
	    '{' '}' :
	    [].
object ->
	    '{' members '}' :
	    build_object('$2').
object ->
        array :
        '$1'.
members ->
	    pair :
	    '$1'.
members ->
	    pair ',' members :
	    ['$1'] ++ lists:flatten(['$3']).
pair ->
	    string ':' value :
	    build_pair('$1','$3').

array ->
	    '[' ']' :
	    [].
array ->
	    '[' elements ']' :
	    '$2'.
elements ->
	    value :
	    '$1'.
elements ->
	    value ',' elements :
	    ['$1'] ++ ['$3'].
value ->
	    string :
	    list_to_binary(extract_value('$1')).
value ->
	    integer :
	    extract_value('$1').
value ->
	    object :
	    build_object('$1').
value ->
	    array :
	    lists:flatten('$1').
value ->
	    atom :
	    build_atom('$1').

Erlang code.
extract_value({_,_,Value}) -> Value.

build_object([L]) when is_list(L) -> L;
build_object(T) when is_tuple(T)  -> [ T ];
build_object(Any) -> Any.

build_pair(K, V) -> { list_to_binary(extract_value(K)), V }.

build_atom({_, _, A}) -> build_atom(A);
build_atom(A) when A == true; A == false ; A == nil -> A;
build_atom(null) -> nil;
build_atom(A) -> atom_to_binary(A, utf8).
