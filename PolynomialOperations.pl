%Alexander Obeid Guzmán, 155805
%Brandon Francisco Hernández Troncoso, 154328
%Rodrigo Castillo Gómez, 168114



%combina(i,i,o) o combina(0,i,i) o combina(i,o,i) o combina(i,i,i) o
% combina(o,o,i)
combina([],Lista,Lista):-!.
combina([X|Lista1],Lista2,[X|Lista3]):-
    combina(Lista1, Lista2, Lista3).

%rellena(0,i,o)
%crea una lista con los ceros necesarios para el polinomio requerido
%0 es un contador que indica fin de la recursión.
rellena(0,Entrada,Salida):-
    combina(Entrada,[],Salida),!.
rellena(Count,Entrada,Salida):-
    combina(Entrada,[0],Aux),
    Count2 is Count -1,
    rellena(Count2,Aux,Salida).

%creaPol(i,i,o)
%crea una lista con el coeficiente en el grado necesario.
creaPol(Coef,Grado,Polinomio):-
    combina([],[Coef],Aux),
    rellena(Grado,Aux,Polinomio).

%grado(i,o)
% determina el grado de un polinomio contando la cantidad de elementos
% en la lista
grado([],-1).
grado([_|Pol],Grado):-
    grado(Pol,Grad), Grado is Grad+1.

%suma(i,i,o)
% suma los coeficientes de dos polinomios pol1 y pol2 y regresa el
% polinomio resultante Res
suma([],[],[]):-!.

% verifica si pol1 es de mayor grado que pol2, de ser asi itera sobre
% pol1 y trata de hacer la suma con la cola de pol1 + pol2
suma([X|Pol1],[Y|Pol2],[X|Res]):-
    grado([X|Pol1],Grado1),
    grado([Y|Pol2],Grado2),
    Grado1>Grado2,
    suma(Pol1,[Y|Pol2],Res),
    !.

% verifica si pol2 es de mayor grado que pol1, de ser así itera sobre
% pol2 y trata de hacer la suma con la cola de pol2 + pol1
suma([X|Pol1],[Y|Pol2],[Y|Res]):-
    grado([X|Pol1],Grado1),
    grado([Y|Pol2],Grado2),
    Grado1<Grado2,
    suma([X|Pol1],Pol2,Res),
    !.

% dado que ni grado1>grado2 ni grado2>grado1 se sabe que grado1 = grado2
% así que se suman los coeficientes y se agregan al pol Res.
% Posteriormente, se itera sobre ambos polinomios.
suma([X|Pol1],[Y|Pol2],[Z|Res]):-
    Z is X+Y,
    suma(Pol1,Pol2,Res),
    !.

%resta(i,i,o)
% resta los coeficientes de dos polinomios pol1 y pol2 y regresa el
% polinomio resultante Res
resta([],[],[]):-!.

% verifica que el grado de pol1 sea mayor que el de pol2, de ser así se
% agrega el coeficiente de pol1 al resultante y se itera sobre pol1.
% Luego, se intenta restar la cola de pol1 con pol2.
resta([X|Pol1],[Y|Pol2],[X|Res]):-
    grado([X|Pol1],Grado1),
    grado([Y|Pol2],Grado2),
    Grado1>Grado2,
    resta(Pol1,[Y|Pol2],Res),
    !.

% verifica que el grado de pol2 sea mayor que el de pol1, de ser así se
% agrega el negativo del coeficiente de pol2 al resultante y se itera
% sobre pol2. Luego, se intenta restar pol1 con la cola de pol2.
resta([X|Pol1],[Y|Pol2],[Aux|Res]):-
    grado([X|Pol1],Grado1),
    grado([Y|Pol2],Grado2),
    Grado1<Grado2,
    Aux is -Y,
    resta([X|Pol1],Pol2,Res),
    !.

% dado que el grado de pol1 y pol2 es igual se restan los coeficientes
% de ambos y se agregan al resultante, se itera sobre ambos polinomios.
resta([X|Pol1],[Y|Pol2],[Z|Res]):-
    Z is X-Y,
    resta(Pol1,Pol2,Res),
    !.

%derivada(i,o)
% multiplica los coeficientes por su grado y reduce el grado del
% polinomio resultante por 1.

% si se manda a llamar la derivada con Grado = 0 se detiene la
% ejecución, pues ya se tiene la derivada completa.
derivada(_,0,[]):-!.

% dado un polinomio Pol y un grado Grado se multiplican y se agrega al
% polinomio Res, se reduce el grado (a manera de contador) y se vuelve a
% llamar con el nuevo grado
derivada([X|Pol],Grado,[Z|Res]):-
    Z is X*Grado,
    Grad2 is Grado-1,
    derivada(Pol,Grad2,Res).

% llamada inicial a la función. Obtiene el grado del polinomio y manda a
% llamar a la función con ese grado.
derivada([X|Pol],Res):-
         grado([X|Pol],Grado),
         derivada([X|Pol],Grado,Res).

%evalua(i,i,o)
%sustituye la x del polinomio y obtiene el resultado numérico

% cuando el polinomio ya se terminó de iterar se asigna el valor de Aux
% a Resp y concluye.
evalua([],_,Aux,Resp):-
    Resp is Aux,!.

% Siguiendo la regla de Horner se toma el acumulado y se multiplica por
% el entero evaluado y se suma el siguiente coeficiente y se vuelve a
% llamar con el nuevo acumulado
evalua([X|Polinomio], Donde, Acumula, Resp):-
    Aux is Acumula*Donde + X,
    evalua(Polinomio,Donde,Aux,Resp),!.

% llamada inicial a la función donde Donde es el entero en el cual se va
% a evaluar el polinomio. Se manda a llamar nuevamente, ahora con
% Acumula = 0
evalua([X|Polinomio],Donde,Resp):-
    evalua([X|Polinomio],Donde,0,Resp).


%toString(i)
%Escribe el polinomio como función de X.

%En caso de mandar el pol = 0, únicamente se escribe 0.
toString([0]):-
    write("0"),!.

% Llamada inicial a la función, se agrega una bandera para indicar que
% es la primera llamada y se instancía el string resultante
toString(Pol):-
    toString(Pol,1,""),
    !.

% Ya que se terminó de iterar sobre el pol, se despliega el String
% construido
toString([],String):-
    write(String),
    !.

% cuando un coeficiente del polinomio es 0 se itera sobre el polinomio
% sin modificar el string y se vuelve a llamar
toString([0|Pol],String):-
    toString(Pol,String),
    !.

% Se verifica que el coeficiente sea mayor o igual a 1 y que el
% grado es 0, es decir únicamente se debe agregar el entero al string.
% Se itera sobr el polinomio y se vuelve a llamar
toString([X|Pol],String):-
    X>=1,
    grado([X|Pol],Grado),
    Grado=:=0,
    string_concat(String," + ",Sub1),
    string_concat(Sub1,X,Sub2),
    toString(Pol,Sub2),
    !.

% Se verifica que el coeficiente sea menor o igual a 1 y que el
% grado es 0, es decir únicamente se debe agregar un - y el entero
% (multiplicado por menos 1) al string. Se itera sobr el polinomio y se
% vuelve a llamar
toString([X|Pol],String):-
    X=<1,
    grado([X|Pol],Grado),
    Grado=:=0,
    Z is X*(-1),
    string_concat(String," - ",Sub1),
    string_concat(Sub1,Z, Sub2),
    toString(Pol,Sub2),
    !.

% Se verifica que el coeficiente sea mayor a 1 y que el grado no sea
% uno, así que se agrega el coeficiente x^ el grado y + al string. Se
% itera sobre el polinomio y se vuelve a llamar
toString([X|Pol],String):-
    X>1,
    grado([X|Pol],Grado),
    Grado=\=1,
    string_concat(String," + ",Sub1),
    string_concat(Sub1,X,Sub2),
    string_concat(Sub2,"x^",Sub3),
    string_concat(Sub3,Grado,Sub4),
    toString(Pol,Sub4),
    !.

% Se verifica que el coeficiente sea mayor a 1 y que el grado sea
% 1, así que se agrega el coeficiente x y + al string. Se
% itera sobre el polinomio y se vuelve a llamar
toString([X|Pol],String):-
    X>1,
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String," + ",Sub1),
    string_concat(Sub1,X,Sub2),
    string_concat(Sub2,"x",Sub3),
    toString(Pol,Sub3),
    !.

% Se verifica que el coeficiente sea menor a -1 y que el grado no sea
% 1, así que se agrega - el coeficiente(multiplicado por -1) x^grado
% al string. Se itera sobre el polinomio y se vuelve a llamar
toString([X|Pol],String):-
    X<(-1),
    grado([X|Pol],Grado),
    Grado=\=1,
    Z is X*(-1),
    string_concat(String," - ",Sub1),
    string_concat(Sub1,Z,Sub2),
    string_concat(Sub2,"x^",Sub3),
    string_concat(Sub3,Grado,Sub4),
    toString(Pol,Sub4),
    !.

% Se verifica que el coeficiente sea menor a -1 y que el grado sea
% 1, así que se agrega - el coeficiente(multiplicado por -1) x
% al string. Se itera sobre el polinomio y se vuelve a llamar
toString([X|Pol],String):-
    X<(-1),
    grado([X|Pol],Grado),
    Grado=:=1,
    Z is X*(-1),
    string_concat(String," - ",Sub1),
    string_concat(Sub1,Z,Sub2),
    string_concat(Sub2,"x",Sub3),
    toString(Pol,Sub3),
    !.

% Se verifica que el coeficiente sea igual a 1 y que el grado no sea
% 1, así que se agrega + x^grado al string. Se itera sobre el polinomio
% y se vuelve a llamar
toString([X|Pol],String):-
    X=:=1,
    grado([X|Pol],Grado),
    Grado=\=1,
    string_concat(String," + ",Sub1),
    string_concat(Sub1,"x^",Sub2),
    string_concat(Sub2,Grado,Sub3),
    toString(Pol,Sub3),
    !.

% Se verifica que el coeficiente sea igual a 1 y que el grado sea
% 1, así que se agrega + x al string. Se itera sobre el polinomio
% y se vuelve a llamar
toString([X|Pol],String):-
    X=:=1,
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String," + ",Sub1),
    string_concat(Sub1,"x",Sub2),
    toString(Pol,Sub2),
    !.

% Se verifica que el coeficiente sea igual a -1 y que el grado no sea
% 1, así que se agrega - x^grado al string. Se itera sobre el polinomio
% y se vuelve a llamar
toString([X|Pol],String):-
    X=:=(-1),
    grado([X|Pol],Grado),
    Grado=\=1,
    string_concat(String," - ",Sub1),
    string_concat(Sub1,"x^",Sub2),
    string_concat(Sub2,Grado,Sub3),
    toString(Pol,Sub3),
    !.

% Se verifica que el coeficiente sea igual a -1 y que el grado sea
% 1, así que se agrega - x al string. Se itera sobre el polinomio
% y se vuelve a llamar
toString([X|Pol],String):-
    X=:=(-1),
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String," - ",Sub1),
    string_concat(Sub1,"x",Sub2),
    toString(Pol,Sub2),
    !.

%verifica que si el primer elemento es 0 y nada más 0, se imprima 0
toString([0|[]],1,_):-
    write("0"),
    !.

% En la primera llamada a la función se verifica que el coeficiente no
% sea 1 o -1 y el grado mayor a 1, así que se agrega el coeficiente
% x^Grado
% se itera y se vuelve a llamar
toString([X|Pol],1,String):-
    X=\=1,
    X=\=(-1),
    grado([X|Pol],Grado),
    Grado>1,
    string_concat(String,X,Sub1),
    string_concat(Sub1,"x^",Sub2),
    string_concat(Sub2,Grado,Sub3),
    toString(Pol,Sub3),
    !.

% En la primera llamada a la función se verifica que el coeficiente no
% sea 1 o -1 y el grado es 1, así que se agrega x^Grado al string
% se itera y se vuelve a llamar
toString([X|Pol],1,String):-
    X=\=1,
    X=\=(-1),
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String,X,Sub1),
    string_concat(Sub1,"x",Sub2),
    toString(Pol,Sub2),
    !.

% En la primera llamada a la función se verifica que el coeficiente sea 1
% y el grado mayor a 1, así que se agrega coeficiente x^Grado al string
% se itera y se vuelve a llamar
toString([X|Pol],1,String):-
    X=:=1,
    grado([X|Pol],Grado),
    Grado>1,
    string_concat(String,"x^",Sub1),
    string_concat(Sub1,Grado,Sub2),
    toString(Pol,Sub2),
    !.

% En la primera llamada a la función se verifica que el coeficiente sea
% -1 y el grado mayor a 1, así que se agrega coeficiente x^Grado al
% string se itera y se vuelve a llamar
toString([X|Pol],1,String):-
    X=:=(-1),
    grado([X|Pol],Grado),
    Grado>1,
    string_concat(String,"-x^",Sub1),
    string_concat(Sub1,Grado,Sub2),
    toString(Pol,Sub2),
    !.

% En la primera llamada a la función se verifica que el coeficiente sea 1
% y el grado sea 1, así que se agrega x al string
% se itera y se vuelve a llamar
toString([X|Pol],1,String):-
    X=:=1,
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String,"x",Sub1),
    toString(Pol,Sub1),
    !.

% En la primera llamada a la función se verifica que el coeficiente sea
% -1 y el grado sea 1, así que se agrega -x al string se itera y se
% vuelve a llamar
toString([X|Pol],1,String):-
    X=:=(-1),
    grado([X|Pol],Grado),
    Grado=:=1,
    string_concat(String,"-x",Sub1),
    toString(Pol,Sub1),
    !.

%parcial no es un método que deba de utilizar el usuario.
%si se terminó de iterar sobre pol2, entonces la parcial está terminada.
parcial(_,[],Aux,Resp):-
    combina(Aux,[],Resp),!.

% se determina el nuevo coeficiente multiplicando los coefs de pol1 y
% pol2, el grado del nuevo polinomio se determina sumando el grado de
% ambos polinomio, se crea un polinomio de dicho grado y se suma con el
% acumulado. Se itera sobre pol2 y se manda a llamar a parcial de nuevo.
parcial([X|P1],[Y|P2],Acum,Resp):-
    Z is X*Y,
    grado([X|P1],Grado1),
    grado([Y|P2],Grado2),
    Grado is Grado1 + Grado2,
    creaPol(Z,Grado,Aux),
    suma(Aux,Acum,Aux2),
    parcial([X|P1],P2,Aux2,Resp).

%multiplicación(i,i,o)
%toma dos polinomios como entrada y los multiplica

% si se terminó de iterar sobre pol1, entonces terminó la multipliación
% y se regresa la respuesta.
multiplicacion([],_,Acum,Resp):-
    combina(Acum,[],Resp).

% se manda a llamar a parcial, con acumulado 0 (que multiplicará e
% iterará sobre pol2), el resultado se suma con el acumulado, se itera
% sobre pol1 y se manda a llamar.
multiplicacion([X|P1],[Y|P2],Acum,Resp):-
    parcial([X|P1],[Y|P2],[0],Aux),
    suma(Aux,Acum,Aux2),
    multiplicacion(P1,[Y|P2],Aux2,Resp).

%llamada inicial
%instancia el acumulado = 0 y llama de nuevo
multiplicacion([X|P1],[Y|P2],Resp):-
    multiplicacion([X|P1],[Y|P2],[0],Resp).

% arregla un glitch que agregaba dos 0s al componer dos polinomios, no
% debe ser utilizada por el usuario
quitaCeros([_,_|Pol],Resp):-
    combina(Pol,[],Resp).

%composicion(i,i,o)
% compone dos polinomios basándose en la regla de Horner y entrega el
% resultado

%si se terminó de iterar sobre pol1, terminó la función.
composicion([],_,Acum,Resp):-
    combina(Acum,[],Aux),
    quitaCeros(Aux,Resp).

% crea un polinomio de grado 0 con coeficiente X, se multiplica el
% acumulado por pol2 y se suma el resultado con el polinomio creado. Se
% itera sobre pol1 y se manda a llamar
composicion([X|Pol1],[Z|Pol2],Acum,Resp):-
    creaPol(X,0,Aux1),
    multiplicacion(Acum,[Z|Pol2],Aux2),
    suma(Aux2,Aux1,Aux3),
    composicion(Pol1,[Z|Pol2],Aux3,Resp).

% Primera llamda a la función, instancia un acumulado en 0 y se manda a
% llamar
composicion([X|Pol1],[Z|Pol2],Resp):-
    composicion([X|Pol1],[Z|Pol2],[0],Resp).


% método que ejecuta las llamadas necesarias para mostrar el
% comportamiento esperado.
%
% Comportamiento esperado:
/*************************************************************************
 *  zero(x)     = 0
 *  p(x)        = 4x^3 + 3x^2 + 2x + 1
 *  q(x)        = 3x^2 + 5
 *  p(x) + q(x) = 4x^3 + 6x^2 + 2x + 6
 *  p(x) * q(x) = 12x^5 + 9x^4 + 26x^3 + 18x^2 + 10x + 5
 *  p(q(x))     = 108x^6 + 567x^4 + 996x^2 + 586
 *  0 - p(x)    = -4x^3 - 3x^2 - 2x - 1
 *  p(3)        = 142
 *  p'(x)       = 12x^2 + 6x + 2
 *  p''(x)      = 24x + 6
 *
 *************************************************************************/
main:-
    creaPol(0,0,Cero),
    creaPol(4,3,P1),creaPol(3,2,P2),creaPol(2,1,P3),creaPol(1,0,P4),suma(P1,P2,Aux1),suma(Aux1,P3,Aux2),suma(Aux2,P4,P),
    creaPol(3,2,Q1),creaPol(5,0,Q2),suma(Q1,Q2,Q),
    suma(P,Q,Suma),
    multiplicacion(P,Q,Multi),
    composicion(P,Q,Comp),
    resta(Cero,P,Resta),
    evalua(P,3,Eval),
    derivada(P,Pprima),
    derivada(Pprima,Pbiprima),
    write("zero(x)     = "), toString(Cero),nl,
    write("p(x)        = "), toString(P),nl,
    write("q(x)        = "),  toString(Q),nl,
    write("p(x) + q(x) = "),  toString(Suma),nl,
    write("p(x) * q(x) = "),  toString(Multi),nl,
    write("p(q(x))     = "), toString(Comp),nl,
    write("0 - p(x)    = "),  toString(Resta),nl,
    write("p(3)        = "), write(Eval),nl,
    write("p'(x)       = "), toString(Pprima),nl,
    write("p''(x)      = "), toString(Pbiprima).
