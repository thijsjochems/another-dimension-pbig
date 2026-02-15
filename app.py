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
# TEAM NAME GENERATION
# ==========================================

POWERBI_TERMS = {
    'A': ['Analytics', 'Aggregation', 'Append', 'API', 'Azure'],
    'B': ['BI', 'Bookmark', 'Button', 'Budget', 'Batch', 'Binary', 'Barchart'],
    'C': ['Column', 'Calculated', 'Card', 'Cluster', 'Composite', 'Cache', 'Chart', 'Code'],
    'D': ['DAX', 'Dashboard', 'Dataflow', 'Drill', 'Dimension', 'Data', 'Database', 'Download', 'Datamodel'],
    'E': ['ETL', 'Extract', 'Excel', 'Export', 'Expression'],
    'F': ['Filter', 'Fact', 'Field', 'Forecast', 'Format', 'Formula', 'Function'],
    'G': ['Gateway', 'Gauge', 'Grain', 'Graph', 'Grid'],
    'I': ['Insight', 'Import', 'Index', 'Integration'],
    'J': ['Join', 'JSON'],
    'K': ['KPI', 'Kernel'],
    'L': ['Lakehouse', 'Load', 'Layer', 'Legend', 'Link'],
    'M': ['Measure', 'Model', 'Matrix', 'M-code', 'Merge', 'Metric', 'Migration'],
    'P': ['Power Query', 'Parameter', 'Partition', 'Publish', 'Pipeline', 'Pivot', 'Python'],
    'Q': ['Query', 'Q&A', 'Queue'],
    'R': ['Report', 'Row', 'Relationship', 'Refresh', 'RLS', 'Ribbon', 'Range'],
    'S': ['Slicer', 'Star Schema', 'Snapshot', 'Sync', 'Schema', 'Script', 'SQL', 'Storage', 'Stream'],
    'T': ['Table', 'Tooltip', 'Template', 'Trend', 'Transform', 'Transpose', 'Trigger'],
    'V': ['Visual', 'Variable', 'View', 'Validate', 'Value'],
    'W': ['Workspace', 'Waterfall', 'Warehouse', 'Workflow'],
    'Y': ['YAML', 'Year'],
    'Z': ['Zoom']
}

ALLITERATIVE_WORDS = {
    'A': ['Aces', 'Admirals', 'Agents', 'Alligators', 'Alphas', 'Ambassadors', 'Anchors', 'Angels', 'Archers', 'Architects', 'Armada', 'Artists', 'Assassins', 'Astronauts', 'Athletes', 'Atoms', 'Avengers', 'Aviators'],
    'B': ['Badgers', 'Bandits', 'Barracudas', 'Bears', 'Beavers', 'Bees', 'Berserkers', 'Bison', 'Blazers', 'Blizzards', 'Bombers', 'Boosters', 'Bosses', 'Brawlers', 'Breakers', 'Builders', 'Bulls', 'Bullets', 'Buffalos'],
    'C': ['Captains', 'Cardinals', 'Centurions', 'Champions', 'Chargers', 'Cheetahs', 'Chiefs', 'Cobras', 'Collectors', 'Commanders', 'Comets', 'Conquerors', 'Corsairs', 'Cougars', 'Cowboys', 'Crackers', 'Creators', 'Crew', 'Crusaders', 'Crushers', 'Cyclones'],
    'D': ['Daredevils', 'Dashers', 'Defenders', 'Demons', 'Designers', 'Destroyers', 'Detectives', 'Diamonds', 'Diggers', 'Dolphins', 'Dragons', 'Drillers', 'Drivers', 'Drones', 'Dynamos', 'Dynamite'],
    'E': ['Eagles', 'Echoes', 'Editors', 'Elites', 'Emperors', 'Enforcers', 'Engineers', 'Enigmas', 'Explorers', 'Experts', 'Express'],
    'F': ['Falcons', 'Fighters', 'Firebirds', 'Flames', 'Flyers', 'Forces', 'Foxes', 'Frenzy', 'Fusion'],
    'G': ['Galaxies', 'Gamers', 'Generals', 'Geniuses', 'Ghosts', 'Giants', 'Gladiators', 'Goblins', 'Grizzlies', 'Guardians', 'Gurus', 'Gunslingers'],
    'I': ['Icons', 'Infernos', 'Innovators', 'Inspectors', 'Invaders', 'Inventors', 'Investigators', 'Ironclads'],
    'J': ['Jaguars', 'Jets', 'Jokers', 'Juggernauts', 'Jumpers'],
    'K': ['Kamikazes', 'Keepers', 'Kings', 'Knights', 'Koalas', 'Komodos'],
    'L': ['Lancers', 'Leaders', 'Legends', 'Leopards', 'Lions', 'Lobos', 'Locusts', 'Lords', 'Lynx'],
    'M': ['Mages', 'Magnates', 'Mammoths', 'Mambas', 'Mavericks', 'Magicians', 'Masters', 'Meteors', 'Miners', 'Monarchs', 'Monsters', 'Movers', 'Mustangs'],
    'P': ['Paladins', 'Pandas', 'Panthers', 'Patriots', 'Penguins', 'Phantoms', 'Phoenixes', 'Pilots', 'Pioneers', 'Pirates', 'Predators', 'Prowlers', 'Pumas', 'Pythons'],
    'Q': ['Quakes', 'Queens', 'Questers', 'Quicksilvers'],
    'R': ['Raiders', 'Rangers', 'Raptors', 'Ravens', 'Rebels', 'Reapers', 'Rhinos', 'Riders', 'Rivals', 'Rockets', 'Rogues', 'Rulers', 'Runners'],
    'S': ['Sabres', 'Samurai', 'Savages', 'Scorpions', 'Scouts', 'Sentinels', 'Serpents', 'Shadows', 'Sharks', 'Shooters', 'Slayers', 'Snipers', 'Soldiers', 'Spartans', 'Speedsters', 'Spiders', 'Spirits', 'Stallions', 'Storms', 'Strikers', 'Summoners'],
    'T': ['Tacticians', 'Talons', 'Templars', 'Terrors', 'Thunders', 'Tigers', 'Titans', 'Tornadoes', 'Trackers', 'Trailblazers', 'Tribes', 'Trojans', 'Troopers', 'Tycoons'],
    'V': ['Valkyries', 'Vampires', 'Vanguards', 'Velociraptors', 'Venoms', 'Veterans', 'Victors', 'Vikings', 'Vipers', 'Virtuosos', 'Voyagers', 'Vultures'],
    'W': ['Warriors', 'Wasps', 'Watchers', 'Waves', 'Whalers', 'Wildcats', 'Winds', 'Wingmen', 'Wizards', 'Wolves', 'Wranglers'],
    'Y': ['Yankees', 'Yetis'],
    'Z': ['Zealots', 'Zephyrs', 'Zombies', 'Zulus']
}

def generate_unique_team_name(max_attempts=10):
    """
    Generate a unique alliterative team name
    Format: [PowerBI Term] [Alliterative Word]
    Example: "DAX Dragons", "Query Quicksilvers"
    
    Checks database to ensure uniqueness WITHIN TODAY
    Names reset daily - same name can be reused on different days
    If duplicates after max_attempts, adds random number
    """
    # Get start of today (00:00:00) for date filtering
    today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    
    for attempt in range(max_attempts):
        # Pick random letter that has both terms and words
        available_letters = set(POWERBI_TERMS.keys()) & set(ALLITERATIVE_WORDS.keys())
        letter = random.choice(list(available_letters))
        
        # Generate name
        term = random.choice(POWERBI_TERMS[letter])
        word = random.choice(ALLITERATIVE_WORDS[letter])
        team_name = f"{term} {word}"
        
        # Check if name already exists in games created TODAY
        # Filter by created_at >= today 00:00:00
        existing = supabase.table('games').select('id').eq('player_name', team_name).gte('created_at', today_start.isoformat()).execute()
        
        if not existing.data:
            # Name is unique for today!
            return team_name
    
    # If we get here, we've tried max_attempts times without finding unique name
    # Fallback: add random number
    letter = random.choice(list(available_letters))
    term = random.choice(POWERBI_TERMS[letter])
    word = random.choice(ALLITERATIVE_WORDS[letter])
    random_num = random.randint(10, 99)
    
    return f"{term} {word} #{random_num}"

# ==========================================
# HELPER FUNCTIONS
# ==========================================

def generate_session_code():
    """Generate a unique 6-character session code"""
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

def get_nfc_mapping(nfc_code):
    """
    Map NFC code to database entity
    Supports both nfc_code (legacy) and nfc_codes (array) columns
    Returns: dict with 'type' and 'data' or None
    """
    # Check personen - support both single code and array
    result = supabase.table('personen').select('*').or_(f'nfc_code.eq.{nfc_code},nfc_codes.cs.["{nfc_code}"]').execute()
    if result.data:
        return {'type': 'persoon', 'data': result.data[0]}
    
    # Check wapens
    result = supabase.table('wapens').select('*').or_(f'nfc_code.eq.{nfc_code},nfc_codes.cs.["{nfc_code}"]').execute()
    if result.data:
        return {'type': 'wapen', 'data': result.data[0]}
    
    # Check locaties
    result = supabase.table('locaties').select('*').or_(f'nfc_code.eq.{nfc_code},nfc_codes.cs.["{nfc_code}"]').execute()
    if result.data:
        return {'type': 'locatie', 'data': result.data[0]}
    
    # Check agents
    result = supabase.table('agents').select('*').or_(f'nfc_code.eq.{nfc_code},nfc_codes.cs.["{nfc_code}"]').execute()
    if result.data:
        return {'type': 'agent', 'data': result.data[0]}
    
    # Check special codes
    result = supabase.table('special_nfc_codes').select('*').or_(f'nfc_code.eq.{nfc_code},nfc_codes.cs.["{nfc_code}"]').execute()
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

@app.route('/killed-test')
def killed_test():
    """Test page for KILLED effect variations"""
    return render_template('killed-test.html')

@app.route('/team-reveal/<session_code>')
def team_reveal(session_code):
    """Team name reveal page with slot machine animation"""
    # Get the actual team name from the game session
    result = supabase.table('games').select('player_name').eq('session_code', session_code).execute()
    
    if result.data and result.data[0]['player_name']:
        team_name = result.data[0]['player_name'].upper()
    else:
        # Fallback if session not found
        team_name = "THE MYSTERY TEAM"
    
    return render_template('team-reveal.html', team_name=team_name)

@app.route('/game')
def game():
    """Murder Mystery game page"""
    return render_template('game.html')

@app.route('/leaderboard')
def leaderboard_page():
    """Leaderboard page"""
    return render_template('leaderboard.html')

@app.route('/powerbi-portfolio')
def powerbi_portfolio():
    """Power BI Portfolio page"""
    return render_template('powerbi-portfolio.html')

@app.route('/powerbi-training')
def powerbi_training():
    """Power BI Training page"""
    return render_template('powerbi-training.html')

@app.route('/ai-automation')
def ai_automation():
    """AI Automation page"""
    return render_template('ai-automation.html')

@app.route('/ai-training')
def ai_training():
    """AI Training page"""
    return render_template('ai-training.html')

@app.route('/names')
def names():
    """Names split text page"""
    return render_template('names.html')

@app.route('/contact')
def contact_form():
    """Contact form page"""
    return render_template('contact-form.html')

@app.route('/api/contact/submit', methods=['POST'])
def submit_contact():
    """Handle contact form submission and save to Supabase"""
    try:
        data = request.get_json()
        
        # Validate required fields
        if not data.get('naam') or not data.get('bedrijf') or not data.get('email'):
            return jsonify({'success': False, 'message': 'Naam, bedrijf en email zijn verplicht'}), 400
        
        # Insert into Supabase contacts table
        contact_data = {
            'naam': data.get('naam'),
            'bedrijf': data.get('bedrijf'),
            'email': data.get('email'),
            'telefoon': data.get('telefoon'),
            'interesse_powerbi_training': data.get('interesse_powerbi_training', False),
            'interesse_powerbi_rapportage': data.get('interesse_powerbi_rapportage', False),
            'interesse_ai_training': data.get('interesse_ai_training', False),
            'interesse_ai_automation': data.get('interesse_ai_automation', False),
            'interesse_samenwerken': data.get('interesse_samenwerken', False),
            'interesse_overig': data.get('interesse_overig'),
            'bron': 'beurs_qr'
        }
        
        # Insert into Supabase
        result = supabase.table('contacts').insert(contact_data).execute()
        
        return jsonify({
            'success': True, 
            'message': 'Bedankt! We nemen snel contact op.'
        })
        
    except Exception as e:
        print(f"Error submitting contact form: {e}")
        return jsonify({
            'success': False, 
            'message': 'Er ging iets fout. Probeer het opnieuw.'
        }), 500

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
        'data': entity_data,  # Include full data object
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

@app.route('/api/game/cleanup', methods=['POST'])
def cleanup_active_games():
    """
    Cleanup all active scenarios and games
    Called when returning to homepage to ensure clean state
    """
    try:
        # Set all active scenarios to inactive
        supabase.table('scenarios').update({
            'active': False,
            'started_at': None
        }).eq('active', True).execute()
        
        # Optionally also mark incomplete games as abandoned
        # (but keep completed games intact for leaderboard)
        supabase.table('games').update({
            'status': 'abandoned'
        }).eq('status', 'active').execute()
        
        return jsonify({
            'success': True,
            'message': 'Active games cleaned up'
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/game/session/<session_code>', methods=['GET'])
def get_game_session(session_code):
    """
    Get game details by session code
    Used when continuing an existing game session
    """
    try:
        # Get game by session code
        game_result = supabase.table('games').select('*').eq('session_code', session_code).execute()
        
        if not game_result.data:
            return jsonify({'error': 'Session not found'}), 404
        
        game = game_result.data[0]
        
        # Get scenario details
        scenario_result = supabase.table('scenarios').select('*').eq('id', game['scenario_id']).execute()
        
        if not scenario_result.data:
            return jsonify({'error': 'Scenario not found'}), 404
        
        scenario = scenario_result.data[0]
        
        return jsonify({
            'success': True,
            'game_id': game['id'],
            'session_code': session_code,
            'team_name': game.get('player_name', 'Team'),
            'scenario_id': scenario['id'],
            'scenario': scenario['beschrijving'],
            'situatie_beschrijving': scenario.get('situatie_beschrijving', '')
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

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
    
    # Get all inactive scenarios that are not archived
    scenarios = supabase.table('scenarios').select('*').eq('active', False).eq('archive_flag', 0).execute()
    
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
    team_name = generate_unique_team_name()
    
    game = supabase.table('games').insert({
        'session_code': session_code,
        'scenario_id': scenario['id'],
        'player_name': team_name,
        'start_time': datetime.utcnow().isoformat(),
        'status': 'active'  # Mark as active for Edge Function auto-detect
    }).execute()
    
    # Return scenario beschrijving
    return jsonify({
        'success': True,
        'game_id': game.data[0]['id'],
        'session_code': session_code,
        'team_name': team_name,
        'scenario_id': scenario['id'],
        'scenario': scenario['beschrijving'],
        'situatie_beschrijving': scenario.get('situatie_beschrijving', ''),
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
    """Get top 10 fastest times + laatste sessie (ONLY from today)"""
    # Get start of today (00:00:00) for date filtering
    today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    
    # Get top 10 from TODAY only
    leaderboard = supabase.table('games').select('id, player_name, total_time_seconds, end_time').eq('completed', True).gte('created_at', today_start.isoformat()).order('total_time_seconds', desc=False).limit(15).execute()
    
    # Get laatste sessie (most recent from TODAY)
    latest = supabase.table('games').select('id, player_name, total_time_seconds, end_time').eq('completed', True).gte('created_at', today_start.isoformat()).order('end_time', desc=True).limit(1).execute()
    
    formatted = []
    latest_game_id = latest.data[0]['id'] if latest.data else None
    
    for idx, game in enumerate(leaderboard.data, 1):
        formatted.append({
            'rank': idx,
            'game_id': game['id'],
            'player_name': game.get('player_name', 'Anoniem'),
            'total_time': f"{game['total_time_seconds'] // 60:02d}:{game['total_time_seconds'] % 60:02d}",
            'total_time_seconds': game['total_time_seconds'],
            'completed_at': game['end_time'],
            'is_latest': game['id'] == latest_game_id
        })
    
    # Check if latest game is in top 10
    latest_in_top10 = any(g['is_latest'] for g in formatted)
    
    response = {
        'success': True, 
        'leaderboard': formatted,
        'latest_game': None
    }
    
    # If latest game is NOT in top 10, add it separately
    if not latest_in_top10 and latest.data:
        lg = latest.data[0]
        response['latest_game'] = {
            'game_id': lg['id'],
            'player_name': lg.get('player_name', 'Anoniem'),
            'total_time': f"{lg['total_time_seconds'] // 60:02d}:{lg['total_time_seconds'] % 60:02d}",
            'total_time_seconds': lg['total_time_seconds'],
            'completed_at': lg['end_time']
        }
    
    return jsonify(response)

# ==========================================
# RUN APP
# ==========================================

if __name__ == '__main__':
    print("🚀 Power BI Murder Mystery starting...")
    print(f"📊 Supabase URL: {supabase_url}")
    # Enable debug mode and auto-reload for development
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=True)
