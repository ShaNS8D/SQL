import psycopg2


def create_table(conn):
    with conn.cursor() as cur:        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS Client(
            id SERIAL PRIMARY KEY,
            first_name VARCHAR(60) NOT NULL,
            last_name VARCHAR(60) NOT NULL,
            email VARCHAR(60) NOT NULL
        );
        """)
        cur.execute("""
        CREATE TABLE IF NOT EXISTS Phones(
            id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES Client(id),
            phone VARCHAR(12)
        );
        """)
        conn.commit()

def add_client(conn, first_name, last_name, email, phones=None):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO Client(first_name, last_name, email) VALUES(%s, %s, %s);
        """, (first_name, last_name, email))
        cur.execute("""
            SELECT id FROM Client WHERE first_name=%s AND last_name=%s;
            """, (first_name, last_name))
        client_id = cur.fetchone()[0]
        if phones:            
            cur.execute("""
            INSERT INTO Phones(client_id, phone) VALUES(%s, %s);
            """, (client_id, phones))
            conn.commit()

def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO Phones(client_id, phone) VALUES(%s, %s);
            """, (client_id, phone))
        conn.commit()

def change_client(conn, client_id, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:        
        cur.execute("""
            UPDATE Client SET first_name=%s, last_name=%s, email=%s WHERE id=%s;
            """, (first_name, last_name, email, client_id))
        cur.execute("""
            SELECT id FROM Phones WHERE client_id=%s ORDER BY id DESC LIMIT 1;
            """, (client_id, ))
        phone_id = cur.fetchone()[0]
        cur.execute("""
            UPDATE Phones SET phone=%s WHERE id=%s AND client_id=%s;
            """, (phone, phone_id, client_id))
        conn.commit()

def delete_phone(conn, client_id, phone):
    with conn.cursor() as cur:        
        cur.execute("""
            DELETE FROM phones WHERE client_id=%s AND phone=%s;
            """, (client_id, phone))
        conn.commit()

def delete_client(conn, client_id):
    with conn.cursor() as cur:
        cur.execute("""
            DELETE FROM phones WHERE client_id=%s;
            """, (client_id,))
        cur.execute("""
            DELETE FROM Client WHERE id=%s;
            """, (client_id,))

def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:
        cur.execute("""
            SELECT * FROM Client AS c JOIN Phones AS p ON c.id = p.client_id WHERE first_name=%s OR last_name=%s 
            OR email=%s OR p.phone=%s;
            """, (first_name, last_name, email, phone))
        print(cur.fetchall())


db = 'homework5'
username = 'postgres'
passw = '253553'
with psycopg2.connect(database=db, user=username, password=passw) as conn:
    create_table(conn)
    add_client(conn, 'Вася', 'Пузиков', 'puzik@mail.ru', '9215558465')
    add_client(conn, 'Толя', 'Куров', 'kirovt@mail.ru', '')

    add_phone(conn, 1, '7897897891')
    add_phone(conn, 2, '1594876321')

    change_client(conn, 2, 'Толя', 'Киров', 'kirovt@mail.ru', '1234567895')

    delete_phone(conn, 1, '7897897891')
    delete_client(conn, 2)

    find_client(conn, first_name='Вася')
    find_client(conn, last_name='Пузиков')
    find_client(conn, email='puzik@mail.ru')
    find_client(conn, phone='9215558465')

conn.close()