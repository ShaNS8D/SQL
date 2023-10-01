-- Задание 2
-- Название и продолжительность самого длительного трека
SELECT name_track, duration
FROM Track
ORDER BY duration DESC
LIMIT 1;

-- Название треков, продолжительность которых не менее 3,5 минут
SELECT name_track, duration
FROM Track
WHERE duration >= '3:30'
ORDER BY duration DESC

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT name_collection
FROM Songbook
WHERE (year_release >= '2018-01-01') AND (year_release <= '2020-12-31')

-- Исполнители, чьё имя состоит из одного слова
SELECT name_artist
FROM Artist
WHERE NOT name_artist LIKE '% %'

-- Название треков, которые содержат слово «мой» или «my»
SELECT name_track
FROM Track
WHERE LOWER(name_track) LIKE '%мой%'


-- Задание 3
-- Количество исполнителей в каждом жанре
SELECT g.name_genre, COUNT(name_artist)
FROM Genre AS g
LEFT JOIN ArtistGenre AS ag ON g.id = ag.genre_id
LEFT JOIN Artist AS ar ON ag.artist_id = ar.id
GROUP BY g.name_genre
ORDER BY COUNT(ar.id) DESC

-- Количество треков, вошедших в альбомы 2019–2020 годов
SELECT t.name_track, a.year_release
FROM Album AS a
LEFT JOIN Track AS t ON t.album_id = a.id
WHERE (a.year_release >= '2019-01-01') AND (a.year_release <= '2020-12-31')

-- Средняя продолжительность треков по каждому альбому
SELECT a.name_album, AVG(t.duration)
FROM Album AS a
LEFT JOIN Track AS t ON t.album_id = a.id
GROUP BY a.name_album
ORDER BY AVG(t.duration)

-- Все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT ar.name_artist
FROM Artist AS ar
WHERE ar.name_artist NOT IN (
    SELECT DISTINCT ar.name_artist
    FROM Artist AS ar
    LEFT JOIN ArtistAlbum AS aral ON ar.id = aral.artist_id
    LEFT JOIN Album AS al ON al.id = aral.album_id
    WHERE (al.year_release >= '2020-01-01') AND (al.year_release <= '2020-12-31')
)
ORDER BY ar.name_artist

-- Названия сборников, в которых присутствует конкретный исполнитель (Ночные снайперы)
SELECT DISTINCT son.name_collection
FROM Songbook AS son
LEFT JOIN CollectionTrack AS ct ON son.id = ct.collection_id
LEFT JOIN Track AS t ON t.id = ct.track_id
LEFT JOIN Album AS al ON al.id = t.album_id
LEFT JOIN ArtistAlbum AS aral ON aral.album_id = al.id
LEFT JOIN Artist AS ar ON ar.id = aral.artist_id
WHERE ar.name_artist LIKE '%Ночные снайперы%'
ORDER BY son.name_collection