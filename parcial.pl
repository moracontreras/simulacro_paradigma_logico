% esPersonaje/1 nos permite saber qué personajes tendrá el juego

esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(bumi).
esPersonaje(suki).
esPersonaje(iroh).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes

esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado

elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla

controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).
controla(bumi,tierra).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).
visito(bumi,reinoTierra(baSingSe,[muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(suki,nacionDelFuego(prisionDeMaximaSeguridad,200)).

%saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.

esElAvatar(Personaje):-
    esPersonaje(Personaje),
    controlaTodosLosBasicos(Personaje).

%siempre que dice todos uso forall
%FORALL Y NOT NO SON REVERSIBLES

controlaTodosLosBasicos(Personaje):-
    forall(esElementoBasico(Elemento),controla(Personaje,Elemento)).

%un personaje noEsMaestro si no controla ningún elemento, ni básico ni avanzado

noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controla(Personaje,_)).

%un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado

esMaestroPrincipiante(Personaje):-
    esPersonaje(Personaje),
    controlaAlgunBasico(Personaje),
    not(controlaAlgunAvanzado(Personaje)).

controlaAlgunBasico(Personaje):-
    esElementoBasico(Basico),
    controla(Personaje,Basico).

controlaAlgunAvanzado(Personaje):-
    elementoAvanzadoDe(_,Elemento),
    controla(Personaje,Elemento).

%un personaje esMaestroAvanzado si controla algún elemento avanzado. 
%Es importante destacar que el avatar también es un maestro avanzado.

esMaestroAvanzado(Personaje):-
    esPersonaje(Personaje),
    controlaAlgunAvanzado(Personaje).

esMaestroAvanzado(Personaje):-
    esElAvatar(Personaje).

sigueA(PersonajeSeguido,PersonajeSeguidor):-
    esPersonaje(PersonajeSeguido),
    esPersonaje(PersonajeSeguidor),
    %forall(visito(PersonajeSeguidor,Lugar),visito(PersonajeSeguido,Lugar)),
    forall(visito(PersonajeSeguido,Lugar),visito(PersonajeSeguidor,Lugar)),
    PersonajeSeguido \= PersonajeSeguidor.

sigueA(aang,zuko).    

esDignoDeConocer(temploAire(_)).
esDignoDeConocer(tribuAgua(norte)).
esDignoDeConocer(reinoTierra(NombreLugar,Estructura)):-
    esLugar(reinoTierra(NombreLugar,Estructura)),
    not(member(muro,Estructura)).
%agrego esLugar para hacerlo inversible

esLugar(Lugar):-
    visito(_,Lugar).

esPopular(Lugar):-
    esLugar(Lugar),
    findall(Personaje,visito(Personaje,Lugar),ListaVisitantes),
    length(ListaVisitantes,CantidadVisitantes),
    CantidadVisitantes>4.

%esDignoDeConocer(Lugar):-
%not(nacionDelFuego(Lugar,_)).
%MAL, SI ME DICE QUE ALGO NO CUMPLE, SIMPLEMENTE NO LO PONGO EN LA BASE DE CONOCIMIENTOS ENTONCES ES FALSO

%esDignoDeConocer(Lugar):-
%reinoTierra(Lugar,Estructura),
%not(member(muro,Estructura)).
%MAL, EL FUNCTOR TIENE QUE IR SIEMPRE ADENTRO DE UN PREDICADO
