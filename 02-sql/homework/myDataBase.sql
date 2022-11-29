1. __Birthyear__

Buscá todas las películas filmadas en el año que naciste.

SELECT * FROM movies WHERE year=1985;

2. __1982__

SELECT COUNT (*) FROM movies WHERE year=1982;

Cuantas películas hay en la DB que sean del año 1982?

3. __Stacktors__

Buscá actores que tengan el substring `stack` en su apellido.

SELECT * FROM actors WHERE last_name LIKE '%stack%';

4. __Fame Name Game__

Buscá los 10 nombres y apellidos más populares entre los actores. Cuantos actores tienen cada uno de esos nombres y apellidos?

> Esta consulta puede involucrar múltiples queries.

SELECT first_name, last_name, COUNT (*) as Total
   ...> FROM actors
   ...> GROUP BY LOWER(first_name), LOWER(last_name)
   ...> ORDER BY total DESC
   ...> LIMIT 10;

5. __Prolific__

Listá el top 100 de actores más activos junto con el número de roles que haya realizado.

select a.first_name, a.last_name, count (*) as total
from actors as a
join roles as r
on a.id = r.actor_id
group by a.id
order by total desc
limit 100;

6. __Bottom of the Barrel__

Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.

select genre, count(*) as total
from movies_genres
group by genre
order by total;

7. __Braveheart__

Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.

select a.first_name, a.last_name
from actors as a
join roles as r on a.id = r.actor_id
join movies as m on r.movie_id = m.id
where m.name = "Braveheart" and m.year = 1995 
order by a.last_name, a.first_name;


8. __Leap Noir__

Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. Todo ordenado por el nombre de la película.

select d.first_name, d.last_name, m.name, m.year
from directors as d
join movies_directors as md on d.id = md.director_id
join movies as m on m.id = md.movie_id
join movies_genres as mg on m.id = mg.movie_id
where mg.genre = 'Film-Noir' and m.year % 4 = 0
order by m.name;


9. __° Bacon__

Listá todos los actores que hayan trabajado con _Kevin Bacon_ en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.

select a.first_name, a.last_name, m.name
from actors as a
join roles as r on a.id = r.actor_id
join movies as m on r.movie_id = m.id
join movies_genres as mg on m.id = mg.movie_id
where mg.genre = 'Drama'
and m.id in (
  select m.id
  from movies as m
  join roles as r on m.id = r.movie_id
  join actors as a on r.actor_id = a.id
  where a.first_name = 'Kevin' and a.last_name = 'Bacon'
  )
  and (a.first_name || a.last_name != 'KevinBacon');


## Índices

En el shell de sqlite, si usas el comando `.schema` en la tabla `actors` vas a ver que en la creación de la tabla se incluyeron:

```
CREATE INDEX "actors_idx_first_name" ON "actors" ("first_name");
CREATE INDEX "actors_idx_last_name" ON "actors" ("last_name");
```
10. __Immortal Actors__

Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?

select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year < 1900

select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year > 2000

select *
from actors
where id in (
  select r.actor_id
  from roles as r
  join movies as m on r.movie_id = m.id
  where m.year < 1900
) and
id in (
  select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year > 2000
);


11. __Busy Filming__

Buscá actores que actuaron en cinco o más roles en la misma película después del año 1990. Noten que los ROLES pueden tener duplicados ocasionales, sobre los cuales no estamos interesados: queremos actores que hayan tenido cinco o más roles DISTINTOS (DISTINCT cough cough) en la misma película. Escribí un query que retorne los nombres del actor, el título de la película y el número de roles (siempre debería ser > 5).

select a.first_name, a.last_name, count(DISTINCT(r.role)) as total
from actors as a
join roles as r on a.id = r.actor_id
join movies as m on m.id = r.movie_id
where m.year > 1990
group by r.movie_id, r.actor_id
having total >5;




12. __♀__

Para cada año, contá el número de películas en ese años que _sólo_ tuvieron actrices femeninas.

TIP: Podrías necesitar sub-queries. Lee más sobre sub-queries [acá](http://www.tutorialspoint.com/sqlite/sqlite_sub_queries.htm).

select movies.year, count (*) as total
from movies
where movies.id not in (
  select roles.movie_id
  from roles
  join actors on actors.id = roles.actor_id
  where actors.gender = 'M'

)
group by movies.year
order by movies.year desc;