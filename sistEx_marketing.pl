% ==============================================================================
% BLOQUE 1: HECHOS DEL DOMINIO (CAMPAÑAS DE MARKETING)
% ==============================================================================

% estrategia(Nombre, Categoria).
estrategia(marketing_contenidos_organico, organica).
estrategia(campana_social_ads, pagada).
estrategia(marketing_influencers, colaborativa).
estrategia(estrategia_video_viral, organica).
estrategia(publicidad_busqueda_sem, pagada).
estrategia(email_marketing_fidelizacion, directa).

% requisito_de(Estrategia, Evidencia).
requisito_de(marketing_contenidos_organico, presupuesto_bajo).
requisito_de(marketing_contenidos_organico, audiencia_busca_informacion).

requisito_de(campana_social_ads, resultado_inmediato).
requisito_de(campana_social_ads, publico_visual_segmentado).

requisito_de(marketing_influencers, buscar_credibilidad_rapida).
requisito_de(marketing_influencers, audiencia_joven_activa).

requisito_de(estrategia_video_viral, contenido_altamente_compartible).
requisito_de(estrategia_video_viral, prioridad_alcance_masivo).

requisito_de(publicidad_busqueda_sem, alta_intencion_compra).
requisito_de(publicidad_busqueda_sem, competencia_fuerte_en_google).

requisito_de(email_marketing_fidelizacion, base_de_contactos_existente).
requisito_de(email_marketing_fidelizacion, objetivo_retencion_audiencia).

% plan_accion(Estrategia, TextoRecomendacion).
plan_accion(marketing_contenidos_organico, 'Publicar articulos SEO, tutoriales y recursos descargables para atraer trafico constante.').
plan_accion(campana_social_ads, 'Configurar anuncios pagados en Meta Ads y TikTok Ads segmentados por intereses.').
plan_accion(marketing_influencers, 'Colaborar con micro-influencers de tu nicho para demostraciones y resenas autenticas.').
plan_accion(estrategia_video_viral, 'Crear reels y videos cortos en TikTok apoyandose en tendencias y audios populares.').
plan_accion(publicidad_busqueda_sem, 'Invertir en campanas de Google Ads orientadas a palabras clave de intencion transaccional.').
plan_accion(email_marketing_fidelizacion, 'Disenar secuencias automaticas de nutricion de leads con ofertas exclusivas.').

% pregunta(Evidencia, TextoPregunta).
pregunta(presupuesto_bajo, 'Cuenta con un presupuesto publicitario bajo o nulo?').
pregunta(audiencia_busca_informacion, 'Su audiencia busca educarse o resolver dudas antes de comprar?').
pregunta(resultado_inmediato, 'Necesita generar alcance y conversiones de forma inmediata?').
pregunta(publico_visual_segmentado, 'Su publico objetivo consume contenido visual y esta claramente segmentado?').
pregunta(buscar_credibilidad_rapida, 'Necesita transferir confianza y credibilidad de terceros hacia su marca?').
pregunta(audiencia_joven_activa, 'Su cliente ideal es un publico joven y activo en redes sociales?').
pregunta(contenido_altamente_compartible, 'Tiene capacidad de producir contenido visual entretenido y altamente compartible?').
pregunta(prioridad_alcance_masivo, 'Su objetivo principal es maximizar la difusion de marca a gran escala?').
pregunta(alta_intencion_compra, 'Su audiencia ya tiene intencion clara de comprar y busca activamente proveedores?').
pregunta(competencia_fuerte_en_google, 'Existe alta competencia posicionada en los resultados de busqueda de Google?').
pregunta(base_de_contactos_existente, 'Ya posee una lista o base de datos con correos de clientes y prospectos?').
pregunta(objetivo_retencion_audiencia, 'Su enfoque primordial es fidelizar clientes recurrentes mas que atraer nuevos?').

% ==============================================================================
% BLOQUE 2: REGLAS DEL DOMINIO
% ==============================================================================

% R1 (Conjunción): Deduce si dos estrategias pertenecen a la misma categoría (evita duplicados con @<).
estrategias_afines(E1, E2) :-
    estrategia(E1, Categoria),
    estrategia(E2, Categoria),
    E1 @< E2.

% R2 (Disyunción con múltiples cláusulas): Deduce si una estrategia exige desembolso financiero directo.
requiere_inversion_directa(E) :- 
    estrategia(E, pagada).
requiere_inversion_directa(E) :- 
    estrategia(E, colaborativa).

% R3 (Negación \+): Deduce si un requisito es exclusivo de una sola estrategia.
requisito_exclusivo(Req, Estrategia) :-
    requisito_de(Estrategia, Req),
    \+ (requisito_de(Otra, Req), Otra \= Estrategia).

% R4 (Diagnóstico determinista / Cuantificación universal): Confirma la estrategia si todos sus requisitos están observados.
campana_viable(Observados, Estrategia) :-
    estrategia(Estrategia, _),
    forall(requisito_de(Estrategia, Req), member(Req, Observados)).

% R5 (Conteo y agregación): Deduce el número total de evidencias asociadas a una estrategia.
numero_requisitos(Estrategia, Total) :-
    estrategia(Estrategia, _),
    findall(Req, requisito_de(Estrategia, Req), Lista),
    length(Lista, Total).

% R6 (Viabilidad Parcial / Cuantificación existencial): Al menos un requisito coincide.
posible(Observados, Estrategia) :-
    estrategia(Estrategia, _),
    requisito_de(Estrategia, Req),
    member(Req, Observados).


% ==============================================================================
% BLOQUE 3: MOTOR DE INFERENCIA INTERACTIVO
% ==============================================================================

:- dynamic si/1, no/1.

diagnosticar :-
    limpiar,
    (   hipotesis(E)
    ->  plan_accion(E, Recomendacion),
        format('~nEstrategia recomendada: ~w~nPlan de accion: ~w~n', [E, Recomendacion])
    ;   format('~nNo se encontro una estrategia optima con los criterios suministrados. Revalua tus objetivos comerciales.~n')
    ),
    limpiar.

hipotesis(E) :-
    estrategia(E, _),
    forall(requisito_de(E, Req), verificar(Req)).

verificar(Req) :-
    si(Req), !.
verificar(Req) :-
    no(Req), !, fail.
verificar(Req) :-
    preguntar(Req).

preguntar(Req) :-
    pregunta(Req, Texto),
    format('~w (si/no): ', [Texto]),
    read(Respuesta),
    (   Respuesta == si
    ->  assertz(si(Req))
    ;   assertz(no(Req)), fail
    ).

limpiar :-
    retractall(si(_)),
    retractall(no(_)).
