## Simple API service to get the data from the database and return it as a JSON object

from flask import Flask, jsonify, request
from flask_cors import CORS

import json
import sqlite3

app = Flask(__name__)
CORS(app)

## create the database if it doesn't exist
conn = sqlite3.connect('database.db')

@app.route('/')
def index():
    return jsonify({'message': 'Hello, World!'}), 200

@app.route('/recreate-sql-table')
def recreate_sql_table():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('DROP TABLE IF EXISTS players')
    """
    
        CREATE TABLE IF NOT EXISTS 'players' (
            'steamid' TEXT NOT NULL PRIMARY KEY,
            'money' INTEGER NOT NULL DEFAULT 1000,
            'level' INTEGER NOT NULL DEFAULT 1,
            'xp' INTEGER NOT NULL DEFAULT 0,
            'xp_needed' INTEGER NOT NULL DEFAULT 100,
            'lastseen' INTEGER NOT NULL DEFAULT 0,
            'playtime' INTEGER NOT NULL DEFAULT 0,
        );

    """
    c.execute('CREATE TABLE IF NOT EXISTS players (steamid TEXT NOT NULL PRIMARY KEY, money INTEGER NOT NULL DEFAULT 1000, level INTEGER NOT NULL DEFAULT 1, xp INTEGER NOT NULL DEFAULT 0, xp_needed INTEGER NOT NULL DEFAULT 100, lastseen INTEGER NOT NULL DEFAULT 0, playtime INTEGER NOT NULL DEFAULT 0)')
    conn.commit()
    conn.close()
    return jsonify({'message': 'Table recreated'}), 200

## wipe the databse rows
@app.route('/wipe')
def wipe():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('DELETE FROM players')
    conn.commit()
    conn.close()
    return jsonify({'message': 'Database wiped'}), 200

## get all players from the database
@app.route('/players')
def get_players():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('SELECT * FROM players')
    players = c.fetchall()
    conn.close()
    return jsonify(players), 200

@app.route('/player/<steamid>/create', methods=['POST'])
def create_player(steamid):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('INSERT INTO players (steamid) VALUES (?)', (steamid,))
    conn.commit()
    conn.close()
    return get_player(steamid)

## get player/{steamid} data from the database
@app.route('/player/<steamid>')
def get_player(steamid):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('SELECT * FROM players WHERE steamid = ?', (steamid,))
    player = c.fetchone()
    conn.close()
    if player is None:
        return jsonify({'error': 'Player not found', 'code': '2'}), 404
    else:
        return jsonify(player), 200
    
@app.route('/player/<steamid>/set', methods=['POST'])
def set_player_var(steamid):
    var = request.json['var']
    value = request.json['value']
    conn = sqlite3.connect('database.db')
    c = conn.cursor()

    # Ensure 'var' is a valid column name to avoid SQL injection
    if var in ['money', 'level', 'xp', 'xp_needed', 'lastseen', 'playtime']:
        query = f'UPDATE players SET {var} = ? WHERE steamid = ?'
        c.execute(query, (value, steamid))
        conn.commit()
    else:
        return "Invalid column name", 400

    conn.close()
    return get_player(steamid)

@app.route('/player/<steamid>/save', methods=['POST'])
def save_player(steamid):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('UPDATE players SET money = ?, level = ?, xp = ?, lastseen = ?, playtime = ? WHERE steamid = ?', (request.json['money'], request.json['level'], request.json['xp'], request.json['lastseen'], request.json['playtime'], steamid))
    conn.commit()
    conn.close()
    return get_player(steamid)

## top 20 players by money per page
@app.route('/top/money/<page>')
def get_top_money(page):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('SELECT * FROM players ORDER BY money DESC LIMIT 20 OFFSET ?', (int(page) * 20,))
    players = c.fetchall()
    conn.close()
    return jsonify(players), 200

@app.route("/create/fake/<amount>")
def create_fake(amount):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    for i in range(30, 30 + int(amount)):
        c.execute('INSERT INTO players (steamid) VALUES (?)', (i,))
        c.execute('UPDATE players SET money = ?, level = ?, xp = ?, lastseen = ?, playtime = ? WHERE steamid = ?', (i, i, i, i, i, i))
    conn.commit()
    conn.close()
    return jsonify({'message': 'Created fake players'}), 200

## run the app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)



    
