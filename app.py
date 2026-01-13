"""
Power BI Murder Mystery - Flask Backend
Main application file
"""

from flask import Flask, render_template, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import os
from supabase import create_client, Client
import random
import string
from datetime import datetime

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
CORS(app)

# Initialize Supabase client
supabase_url = os.getenv('SUPABASE_URL')
supabase_key = os.getenv('SUPABASE_KEY')

if not supabase_url or not supabase_key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env file")

supabase: Client = create_client(supabase_url, supabase_key)

# ==========================================
# HELPER FUNCTIONS
# ==========================================

def generate_session_code():
    """Generate a unique 6-character session code"""
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

def get_nfc_mapping(nfc_code):
    """
    Map NFC code to database entity
    Returns: dict with 'type' and 'id' or None
    """
    # Check personen
    result = supabase.table('personen').select('*').eq('nfc_code', nfc_code).execute()
    if result.data:
        return {'type': 'persoon', 'data': result.data[0]}
    
    # Check wapens
    result = supabase.table('wapens').select('*').eq('nfc_code', nfc_code).execute()
    if result.data:
        return {'type': 'wapen', 'data': result.data[0]}
    
    # Check locaties
    result = supabase.table('locaties').select('*').eq('nfc_code', nfc_code).execute()
    if result.data:
        return {'type': 'locatie', 'data': result.data[0]}
    
    # Check agents
    result = supabase.table('agents').select('*').eq('nfc_code', nfc_code).execute()
    if result.data:
        return {'type': 'agent', 'data': result.data[0]}
    
    # Check special codes
    result = supabase.table('special_nfc_codes').select('*').eq('nfc_code', nfc_code).execute()
    if result.data:
        return {'type': 'special', 'data': result.data[0]}
    
    return None

# ==========================================
# ROUTES - Homepage
# ==========================================

@app.route('/')
def index():
    """Homepage with 4 main buttons"""
    return render_template('index.html')

@app.route('/game')
def game():
    """Murder Mystery game page"""
    return render_template('game.html')

@app.route('/leaderboard')
def leaderboard_page():
    """Leaderboard page"""
    return render_template('leaderboard.html')

# ==========================================
# ROUTES - NFC Scan Handler
# ==========================================

@app.route('/api/game/scan', methods=['POST'])
def handle_scan():
    """
    Handle NFC scan input
    Receives NFC code and returns appropriate action
    """
    data = request.json
    nfc_code = data.get('nfc_code')
    game_id = data.get('game_id')
    
    if not nfc_code:
        return jsonify({'error': 'No NFC code provided'}), 400
    
    # Map NFC code to entity
    mapping = get_nfc_mapping(nfc_code)
    
    if not mapping:
        return jsonify({'error': 'Unknown NFC code'}), 404
    
    entity_type = mapping['type']
    entity_data = mapping['data']
    
    response = {
        'success': True,
        'type': entity_type,
        'name': entity_data.get('naam') or entity_data.get('name', ''),
        'nfc_code': nfc_code,
        'bio': entity_data.get('bio', ''),
    }
    
    # Add code_type for special codes
    if entity_type == 'special':
        response['code_type'] = entity_data.get('code_type', '')
    
    return jsonify(response)

# ==========================================
# ROUTES - Game Start
# ==========================================

@app.route('/api/game/start', methods=['POST'])
def start_game():
    """
    Start a new game
    1. Check if there's an active game (only 1 allowed)
    2. Select a random inactive scenario
    3. Mark it as active
    4. Create a new game record
    """
    # Check for active scenario
    active = supabase.table('scenarios').select('*').eq('active', True).execute()
    
    if active.data:
        return jsonify({
            'error': 'Game already in progress',
            'message': 'Er is al een spel bezig. Vraag de standhouder om het spel te stoppen.'
        }), 409
    
    # Get all inactive scenarios
    scenarios = supabase.table('scenarios').select('*').eq('active', False).execute()
    
    if not scenarios.data:
        return jsonify({'error': 'No scenarios available'}), 500
    
    # Pick random scenario
    scenario = random.choice(scenarios.data)
    
    # Mark as active
    supabase.table('scenarios').update({
        'active': True,
        'started_at': datetime.utcnow().isoformat()
    }).eq('id', scenario['id']).execute()
    
    # Create game record
    session_code = generate_session_code()
    
    game = supabase.table('games').insert({
        'session_code': session_code,
        'scenario_id': scenario['id'],
        'start_time': datetime.utcnow().isoformat(),
        'status': 'active'  # Mark as active for Edge Function auto-detect
    }).execute()
    
    # Return scenario beschrijving
    return jsonify({
        'success': True,
        'game_id': game.data[0]['id'],
        'session_code': session_code,
        'scenario_id': scenario['id'],
        'scenario': scenario['beschrijving'],
        'message': 'Spel gestart! Los de moord op het Power BI Dashboard op.'
    })

# ==========================================
# ROUTES - Game State
# ==========================================

@app.route('/api/game/current', methods=['GET'])
def get_current_game():
    """Get current active game state"""
    # Get active scenario
    active = supabase.table('active_scenario').select('*').execute()
    
    if not active.data:
        return jsonify({'active': False})
    
    scenario = active.data[0]
    
    # Get current game
    game = supabase.table('games').select('*').eq('scenario_id', scenario['scenario_id']).eq('completed', False).eq('aborted', False).order('created_at', desc=True).limit(1).execute()
    
    if not game.data:
        return jsonify({'active': False})
    
    return jsonify({
        'active': True,
        'game': game.data[0],
        'scenario': scenario
    })

# ==========================================
# ROUTES - Game Actions
# ==========================================

@app.route('/api/game/answer', methods=['POST'])
def submit_answer():
    """
    Submit WHO/WAARMEE/WAAR answer
    Only validates when all 3 are filled
    """
    data = request.json
    game_id = data.get('game_id')
    answer_type = data.get('type')  # 'persoon', 'wapen', 'locatie'
    value = data.get('value')
    
    # Get game and scenario
    game = supabase.table('games').select('*, scenarios(*)').eq('id', game_id).single().execute()
    
    if not game.data:
        return jsonify({'success': False, 'message': 'Game not found'}), 404
    
    scenario = game.data['scenarios']
    
    # Update game with answer (don't validate yet)
    update_field = f'{answer_type}_answer'
    supabase.table('games').update({update_field: value}).eq('id', game_id).execute()
    
    # Check if all three are now filled
    current_who = game.data.get('persoon_answer') or (value if answer_type == 'persoon' else None)
    current_waarmee = game.data.get('wapen_answer') or (value if answer_type == 'wapen' else None)
    current_waar = game.data.get('locatie_answer') or (value if answer_type == 'locatie' else None)
    
    all_filled = current_who and current_waarmee and current_waar
    
    if not all_filled:
        # Not all filled yet, just confirm this answer was recorded
        return jsonify({
            'success': True,
            'recorded': True,
            'all_filled': False,
            'message': f'{value} genoteerd'
        })
    
    # All 3 filled! Now validate
    correct_persoon = supabase.table('personen').select('*').eq('id', scenario['persoon_id']).single().execute()
    correct_wapen = supabase.table('wapens').select('*').eq('id', scenario['wapen_id']).single().execute()
    correct_locatie = supabase.table('locaties').select('*').eq('id', scenario['locatie_id']).single().execute()
    
    all_correct = (
        current_who == correct_persoon.data['naam'] and
        current_waarmee == correct_wapen.data['naam'] and
        current_waar == correct_locatie.data['naam']
    )
    
    if all_correct:
        # WINNER!
        start_time = datetime.fromisoformat(game.data['start_time'].replace('Z', ''))
        end_time = datetime.utcnow()
        elapsed = int((end_time - start_time).total_seconds())
        total = elapsed + game.data.get('penalty_seconds', 0)
        
        supabase.table('games').update({
            'completed': True,
            'end_time': end_time.isoformat(),
            'total_time_seconds': total,
            'status': 'completed'
        }).eq('id', game_id).execute()
        
        # Deactivate scenario
        supabase.table('scenarios').update({'active': False}).eq('id', scenario['id']).execute()
        
        minutes = total // 60
        seconds = total % 60
        return jsonify({
            'success': True,
            'correct': True,
            'all_filled': True,
            'completed': True,
            'total_time': f'{minutes:02d}:{seconds:02d}'
        })
    else:
        # WRONG! Add penalty and clear all answers
        current_penalty = game.data.get('penalty_seconds', 0)
        supabase.table('games').update({
            'penalty_seconds': current_penalty + 15,
            'persoon_answer': None,
            'wapen_answer': None,
            'locatie_answer': None
        }).eq('id', game_id).execute()
        
        return jsonify({
            'success': True,
            'correct': False,
            'all_filled': True,
            'message': 'Helaas! Niet de juiste combinatie. +15 seconden. Probeer opnieuw!'
        })

@app.route('/api/game/scan-answer', methods=['POST'])
def scan_answer():
    """
    Handle scanning of WHO/WHAT/WHERE
    Validates order and checks if correct
    """
    data = request.json
    category = data.get('category')  # 'persoon', 'wapen', 'locatie'
    nfc_code = data.get('nfc_code')
    
    # Get current game
    current = get_current_game().json
    
    if not current['active']:
        return jsonify({'error': 'No active game'}), 400
    
    game = current['game']
    scenario = current['scenario']
    
    # Map NFC code
    mapping = get_nfc_mapping(nfc_code)
    
    if not mapping or mapping['type'] != category:
        return jsonify({
            'success': False,
            'message': f'Verkeerde categorie! Je moet een {category} scannen.'
        })
    
    scanned_id = mapping['data']['id']
    correct_id = scenario[f'{category}_id']
    
    # Check if correct
    if scanned_id == correct_id:
        return jsonify({
            'success': True,
            'correct': True,
            'message': f'Correct! {mapping["data"]["naam"]} gescand.'
        })
    else:
        # Add penalty
        supabase.table('games').update({
            'penalty_seconds': game['penalty_seconds'] + 15
        }).eq('id', game['id']).execute()
        
        return jsonify({
            'success': True,
            'correct': False,
            'message': f'Fout! +15 seconden straftijd. {mapping["data"]["naam"]} is niet de dader/wapen/locatie.'
        })

@app.route('/api/game/complete', methods=['POST'])
def complete_game():
    """
    Complete the game when all three are correct
    """
    current = get_current_game().json
    
    if not current['active']:
        return jsonify({'error': 'No active game'}), 400
    
    game = current['game']
    scenario_id = game['scenario_id']
    
    # Calculate total time
    start_time = datetime.fromisoformat(game['start_time'].replace('Z', '+00:00'))
    end_time = datetime.utcnow()
    elapsed_seconds = int((end_time - start_time).total_seconds())
    total_time = elapsed_seconds + game['penalty_seconds']
    
    # Update game
    supabase.table('games').update({
        'completed': True,
        'end_time': end_time.isoformat(),
        'total_time_seconds': total_time
    }).eq('id', game['id']).execute()
    
    # Deactivate scenario
    supabase.table('scenarios').update({
        'active': False
    }).eq('id', scenario_id).execute()
    
    return jsonify({
        'success': True,
        'session_code': game['session_code'],
        'total_time': total_time,
        'penalty_seconds': game['penalty_seconds'],
        'elapsed_seconds': elapsed_seconds
    })

@app.route('/api/game/exit', methods=['POST'])
def exit_game():
    """
    Exit/abort current game (standhouder pasje)
    """
    data = request.json
    game_id = data.get('game_id')
    
    if not game_id:
        # Try to find active game
        active = supabase.table('scenarios').select('id').eq('active', True).execute()
        if active.data:
            scenario_id = active.data[0]['id']
            games = supabase.table('games').select('*').eq('scenario_id', scenario_id).eq('completed', False).eq('aborted', False).execute()
            if games.data:
                game_id = games.data[0]['id']
    
    if not game_id:
        return jsonify({'success': False, 'message': 'No active game'}), 404
    
    # Get game
    game = supabase.table('games').select('*').eq('id', game_id).single().execute()
    
    if not game.data:
        return jsonify({'success': False, 'message': 'Game not found'}), 404
    
    scenario_id = game.data['scenario_id']
    
    # Update game as aborted
    supabase.table('games').update({
        'aborted': True,
        'end_time': datetime.utcnow().isoformat(),
        'status': 'abandoned'
    }).eq('id', game_id).execute()
    
    # Deactivate scenario
    supabase.table('scenarios').update({
        'active': False
    }).eq('id', scenario_id).execute()
    
    return jsonify({'success': True, 'message': 'Game stopped'})

@app.route('/api/game/force-reset', methods=['POST'])
def force_reset_all():
    """Emergency reset - clear all active scenarios and abort all games"""
    try:
        # Deactivate all scenarios
        supabase.table('scenarios').update({
            'active': False,
            'started_at': None
        }).neq('id', 0).execute()  # Update all
        
        # Abort all incomplete games
        supabase.table('games').update({
            'aborted': True,
            'end_time': datetime.utcnow().isoformat(),
            'status': 'abandoned'
        }).eq('completed', False).eq('aborted', False).execute()
        
        return jsonify({'success': True, 'message': 'All games reset'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

# ==========================================
# ROUTES - Agent Hints
# ==========================================

@app.route('/api/agent/hint', methods=['GET'])
def get_agent_hint():
    """
    Get hint context for agent chat
    Used by n8n to get AI prompt context
    """
    agent_nfc = request.args.get('agent_nfc')
    game_id = request.args.get('game_id')
    
    # Get game
    game = supabase.table('games').select('*').eq('id', game_id).single().execute()
    
    # Get agent
    agent = get_nfc_mapping(agent_nfc)
    if not agent or agent['type'] != 'agent':
        return jsonify({'error': 'Invalid agent'}), 400
    
    agent_id = agent['data']['id']
    
    # Get hint for this scenario + agent
    hint = supabase.table('scenario_hints').select('*').eq('scenario_id', scenario_id).eq('agent_id', agent_id).execute()
    
    if not hint.data:
        return jsonify({'error': 'No hint available'}), 404
    
    return jsonify({
        'agent': agent['data'],
        'hint_context': hint.data[0]['hint_context'],
        'alibi_info': hint.data[0].get('alibi_info')
    })

# ==========================================
# ROUTES - Leaderboard
# ==========================================

@app.route('/api/leaderboard', methods=['GET'])
def get_leaderboard():
    """Get top 10 fastest times"""
    leaderboard = supabase.table('games').select('*, scenarios(naam)').eq('completed', True).order('total_time_seconds', desc=False).limit(10).execute()
    
    formatted = []
    for game in leaderboard.data:
        formatted.append({
            'player_name': game.get('player_name', 'Anoniem'),
            'total_time': f"{game['total_time_seconds'] // 60:02d}:{game['total_time_seconds'] % 60:02d}",
            'completed_at': game['end_time'],
            'scenario_name': game['scenarios']['naam'] if game.get('scenarios') else 'Unknown'
        })
    
    return jsonify({'success': True, 'leaderboard': formatted})

# ==========================================
# RUN APP
# ==========================================

if __name__ == '__main__':
    print("🚀 Power BI Murder Mystery starting...")
    print(f"📊 Supabase URL: {supabase_url}")
    # Disable debug mode and reloader to avoid import issues with pyiceberg on Python 3.13
    app.run(debug=False, host='0.0.0.0', port=5000, use_reloader=False)
