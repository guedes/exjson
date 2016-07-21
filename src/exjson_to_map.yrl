% Grammar for the JSON specification with yecc

% Copyright (C) 2012-2016 Dickson S. Guedes

Nonterminals
    root
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
    ':' ',' '-' '+'
    string
    integer
    float
    atom
    .

Rootsymbol root.

Nonassoc 10 object.

root ->   '$empty' :
	#{}.
root ->
  object: '$1'.
root ->
  array: '$1'.

object ->
	    '{' '}' :
	    #{ }.
object ->
	    '{' members '}' :
	    build_object('$2').

members ->
	    pair :
	    maps:from_list(['$1']).
members ->
	    pair ',' members :
	    maps:merge(maps:from_list(['$1']),'$3').
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
	    ['$1'].
elements ->
	    value ',' elements :
	    ['$1'|'$3'].
value ->
	    string :
	    unicode:characters_to_binary(extract_value('$1')).
value ->
	    integer :
	    extract_value('$1').
value ->
	    float :
	    extract_value('$1').

value ->
	    '-' integer :
	    -1 * extract_value('$2').
value ->
	    '-' float :
	    -1 * extract_value('$2').

value ->
	    '+' integer :
	    extract_value('$2').
value ->
	    '+' float :
	    extract_value('$2').

value ->
	    object :
	    build_object('$1').
value ->
	    array :
	    '$1'.
value ->
	    atom :
	    build_atom('$1').

Erlang code.
extract_value({_,_,Value}) -> Value.

build_object([L]) when is_list(L) -> L;
build_object(T) when is_tuple(T)  -> maps:from_list([ T ]);
build_object(Any) -> Any.

build_pair(K, V) -> { unicode:characters_to_binary(extract_value(K)), V }.

build_atom({_, _, A}) -> build_atom(A);
build_atom(A) when A == true; A == false ; A == nil -> A;
build_atom(null) -> nil;
build_atom(A) -> atom_to_binary(A, utf8).
