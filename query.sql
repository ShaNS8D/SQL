CREATE TABLE IF NOT EXISTS Artist (
	id SERIAL PRIMARY KEY,
	name_artist VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS Album (
	id SERIAL PRIMARY KEY,
	name_album VARCHAR(60) NOT NULL,
	year_release DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Songbook (
	id SERIAL PRIMARY KEY,
	name_collection VARCHAR(60) NOT NULL,
	year_release DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Genre (
	id SERIAL PRIMARY KEY,
	name_genre VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS Track (
	id SERIAL PRIMARY KEY,
	name_track VARCHAR(60) NOT NULL,
	album_id INTEGER NOT NULL,
	duration TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS ArtistGenre (
	artist_id INTEGER REFERENCES Artist(id),
	genre_id INTEGER REFERENCES Genre(id),
	CONSTRAINT pk PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE IF NOT EXISTS ArtistAlbum (
	artist_id INTEGER REFERENCES Artist(id),
	album_id INTEGER REFERENCES Album(id),
	CONSTRAINT pk PRIMARY KEY (artist_id, album_id)
);

CREATE TABLE IF NOT EXISTS CollectionTrack (
	track_id INTEGER REFERENCES Track(id),
	collection_id INTEGER REFERENCES Songbook(id),
	CONSTRAINT pk PRIMARY KEY (track_id, collection_id)
);
