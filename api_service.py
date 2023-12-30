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

@app.route('/player/create/<steamid>', methods=['POST'])
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
def set_player_var(player, var, value):
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('UPDATE players SET ' + var + ' = ? WHERE steamid = ?', (value, player['steamid']))
    conn.commit()
    conn.close()



## run the app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)



    
