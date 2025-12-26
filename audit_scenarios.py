"""
Scenario Audit Script
Fetches all scenarios from Supabase and creates comprehensive quality audit
"""

import os
from dotenv import load_dotenv
from supabase import create_client, Client
from datetime import datetime

# Load environment variables
load_dotenv()

# Initialize Supabase client
supabase_url = os.getenv("SUPABASE_URL")
supabase_key = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(supabase_url, supabase_key)

def fetch_all_scenarios():
    """Fetch all scenarios with joins to personen, wapens, locaties"""
    try:
        response = supabase.table("scenarios").select(
            "id, naam, beschrijving, "
            "personen:persoon_id(naam), "
            "wapens:wapen_id(naam), "
            "locaties:locatie_id(naam)"
        ).execute()
        
        return response.data
    except Exception as e:
        print(f"Error fetching scenarios: {e}")
        return []

def score_scenario(scenario):
    """
    Score scenario on 5 criteria (1-5 stars each)
    Returns dict with scores and analysis
    """
    scores = {
        'realisme': 0,
        'logica': 0,
        'techniek': 0,
        'speelbaarheid': 0,
        'storytelling': 0,
        'issues': []
    }
    
    naam = scenario.get('naam', '')
    beschrijving = scenario.get('beschrijving', '')
    persoon = scenario.get('personen', {}).get('naam', 'ONBEKEND') if scenario.get('personen') else 'ONBEKEND'
    wapen = scenario.get('wapens', {}).get('naam', 'ONBEKEND') if scenario.get('wapens') else 'ONBEKEND'
    locatie = scenario.get('locaties', {}).get('naam', 'ONBEKEND') if scenario.get('locaties') else 'ONBEKEND'
    
    # REALISME: Would a Power BI pro recognize this?
    realisme_keywords = {
        'hoog': ['vrijdag', 'haast', 'deploy', 'productie', 'urgent', 'deadline', 'test', 'merge', 'pull request', 'excel', 'hardcoded', 'pad', 'onedrive'],
        'medium': ['update', 'wijzig', 'verander', 'refresh', 'import', 'query'],
        'laag': ['opzet', 'expres', 'sabotage', 'bewust']
    }
    
    beschrijving_lower = beschrijving.lower()
    if any(kw in beschrijving_lower for kw in realisme_keywords['laag']):
        scores['realisme'] = 1
        scores['issues'].append("Scenario lijkt geforceerd of kunstmatig (sabotage-gedrag)")
    elif any(kw in beschrijving_lower for kw in realisme_keywords['hoog']):
        scores['realisme'] = 5
    elif any(kw in beschrijving_lower for kw in realisme_keywords['medium']):
        scores['realisme'] = 3
    else:
        scores['realisme'] = 2
        scores['issues'].append("Scenario mist herkenbare Power BI situatie details")
    
    # LOGICA: Person → Action → Weapon → Location causal chain
    person_weapon_logic = {
        'Developer': ['Many-to-Many Relatie', 'Hardcoded Pad', 'Hidden Slicer', 'Dubbele Records in DIM Table'],
        'Data Analyst': ['Many-to-Many Relatie', 'Hidden Slicer', 'Dubbele Records in DIM Table', 'Budgetten Niet Geüpdatet'],
        'Financial Controller': ['Hardcoded Pad', 'Budgetten Niet Geüpdatet'],
        'IT Admin': ['Hardcoded Pad', 'Dubbele Records in DIM Table'],
        'Business Intelligence Lead': ['Many-to-Many Relatie', 'Hidden Slicer'],
        'Stagiair': ['Dubbele Records in DIM Table', 'Hidden Slicer'],
        'Product Owner': ['Budgetten Niet Geüpdatet'],
        'Data Engineer': ['Many-to-Many Relatie', 'Dubbele Records in DIM Table', 'Hardcoded Pad']
    }
    
    if persoon in person_weapon_logic:
        if wapen in person_weapon_logic[persoon]:
            scores['logica'] = 5
        else:
            scores['logica'] = 2
            scores['issues'].append(f"{persoon} zou normaal niet {wapen} veroorzaken")
    else:
        scores['logica'] = 3
        scores['issues'].append(f"Persoon '{persoon}' niet in standaard rollen")
    
    # TECHNIEK: Can the weapon really result from this action?
    technical_accuracy = {
        'Many-to-Many Relatie': ['join', 'merge', 'relatie', 'model', 'query', 'database'],
        'Hidden Slicer': ['slicer', 'filter', 'selectie', 'verberg', 'publish', 'rapport'],
        'Dubbele Records in DIM Table': ['import', 'records', 'duplicate', 'dim', 'dimensie', 'query', 'sql'],
        'Hardcoded Pad': ['pad', 'path', 'bestand', 'excel', 'onedrive', 'lokaal', 'hardcode'],
        'Budgetten Niet Geüpdatet': ['budget', 'excel', 'update', 'refresh', 'bestand', 'cijfer']
    }
    
    if wapen in technical_accuracy:
        keywords = technical_accuracy[wapen]
        if any(kw in beschrijving_lower for kw in keywords):
            scores['techniek'] = 5
        else:
            scores['techniek'] = 2
            scores['issues'].append(f"Beschrijving mist technische details over hoe {wapen} ontstaat")
    else:
        scores['techniek'] = 1
        scores['issues'].append(f"Wapen '{wapen}' niet herkend")
    
    # SPEELBAARHEID: Can 3 agents give different perspectives?
    beschrijving_length = len(beschrijving)
    if beschrijving_length > 300:
        scores['speelbaarheid'] = 5
    elif beschrijving_length > 150:
        scores['speelbaarheid'] = 4
    elif beschrijving_length > 80:
        scores['speelbaarheid'] = 3
    else:
        scores['speelbaarheid'] = 2
        scores['issues'].append("Beschrijving te kort voor 3 verschillende agent perspectieven")
    
    # Check for timing/planning elements
    timing_keywords = ['vrijdag', 'maandag', 'ochtend', 'middag', 'voor de meeting', 'na de', 'deadline', 'urgent']
    if any(kw in beschrijving_lower for kw in timing_keywords):
        scores['speelbaarheid'] = min(5, scores['speelbaarheid'] + 1)
    
    # STORYTELLING: Coherent narrative with human behavior
    human_behavior_keywords = ['vergat', 'haast', 'snel', 'geen tijd', 'dacht', 'aannam', 'per ongeluk', 'niet geweten', 'miscommunicatie']
    story_structure = ['omdat', 'daarom', 'waardoor', 'resulter', 'leid', 'veroorzaak']
    
    has_human_behavior = any(kw in beschrijving_lower for kw in human_behavior_keywords)
    has_story_structure = any(kw in beschrijving_lower for kw in story_structure)
    
    if has_human_behavior and has_story_structure:
        scores['storytelling'] = 5
    elif has_human_behavior or has_story_structure:
        scores['storytelling'] = 3
    else:
        scores['storytelling'] = 2
        scores['issues'].append("Mist menselijk gedrag en/of causale verhaalstructuur")
    
    # Calculate total score (average)
    total = sum([scores['realisme'], scores['logica'], scores['techniek'], scores['speelbaarheid'], scores['storytelling']]) / 5
    scores['total'] = round(total, 1)
    
    # Determine verdict
    if scores['total'] >= 4.0:
        scores['verdict'] = 'KEEP'
    elif scores['total'] >= 2.0:
        scores['verdict'] = 'REWRITE'
    else:
        scores['verdict'] = 'DELETE'
    
    return scores

def generate_audit_report(scenarios):
    """Generate comprehensive markdown audit report"""
    
    report = f"""# 🔍 Scenario Audit Report
**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  
**Total Scenarios:** {len(scenarios)}

---

## 📊 Summary Table

| ID | Naam | Persoon | Wapen | Locatie | R | L | T | S | ST | Total | Verdict |
|----|------|---------|-------|---------|---|---|---|---|----|----|---------|
"""
    
    detailed_analyses = []
    keep_count = 0
    rewrite_count = 0
    delete_count = 0
    
    for scenario in scenarios:
        sid = scenario.get('id')
        naam = scenario.get('naam', 'UNNAMED')
        beschrijving = scenario.get('beschrijving', '')
        persoon = scenario.get('personen', {}).get('naam', 'MISSING') if scenario.get('personen') else 'MISSING'
        wapen = scenario.get('wapens', {}).get('naam', 'MISSING') if scenario.get('wapens') else 'MISSING'
        locatie = scenario.get('locaties', {}).get('naam', 'MISSING') if scenario.get('locaties') else 'MISSING'
        
        # Score the scenario
        scores = score_scenario(scenario)
        
        # Add to summary table
        report += f"| {sid} | {naam[:30]} | {persoon[:15]} | {wapen[:20]} | {locatie[:15]} | "
        report += f"{scores['realisme']} | {scores['logica']} | {scores['techniek']} | "
        report += f"{scores['speelbaarheid']} | {scores['storytelling']} | "
        report += f"**{scores['total']}** | **{scores['verdict']}** |\n"
        
        # Count verdicts
        if scores['verdict'] == 'KEEP':
            keep_count += 1
        elif scores['verdict'] == 'REWRITE':
            rewrite_count += 1
        else:
            delete_count += 1
        
        # Create detailed analysis
        stars_r = '⭐' * scores['realisme']
        stars_l = '⭐' * scores['logica']
        stars_t = '⭐' * scores['techniek']
        stars_s = '⭐' * scores['speelbaarheid']
        stars_st = '⭐' * scores['storytelling']
        
        verdict_emoji = '✅' if scores['verdict'] == 'KEEP' else ('⚠️' if scores['verdict'] == 'REWRITE' else '❌')
        
        detailed = f"""
---

### {verdict_emoji} Scenario {sid}: {naam}

**Combinatie:**
- **Persoon:** {persoon}
- **Wapen:** {wapen}
- **Locatie:** {locatie}

**Beschrijving:**
> {beschrijving}

**Scores:**
- **Realisme:** {stars_r} ({scores['realisme']}/5)
- **Logica:** {stars_l} ({scores['logica']}/5)
- **Techniek:** {stars_t} ({scores['techniek']}/5)
- **Speelbaarheid:** {stars_s} ({scores['speelbaarheid']}/5)
- **Storytelling:** {stars_st} ({scores['storytelling']}/5)

**Total Score:** {scores['total']}/5  
**Verdict:** **{scores['verdict']}**

"""
        
        if scores['issues']:
            detailed += "**Issues:**\n"
            for issue in scores['issues']:
                detailed += f"- {issue}\n"
        
        if scores['verdict'] == 'REWRITE':
            detailed += "\n**Rewrite Suggestions:**\n"
            if scores['realisme'] < 4:
                detailed += "- Add more recognizable Power BI context (deadlines, testing, deployment)\n"
            if scores['logica'] < 4:
                detailed += "- Strengthen causal chain: person → reason → action → weapon\n"
            if scores['techniek'] < 4:
                detailed += "- Add technical details about how the weapon emerges\n"
            if scores['speelbaarheid'] < 4:
                detailed += "- Expand story with timing/planning details for agent perspectives\n"
            if scores['storytelling'] < 4:
                detailed += "- Add human behavior elements (forgot, rushed, miscommunication)\n"
        
        detailed_analyses.append(detailed)
    
    # Add summary stats
    report += f"\n**Legend:** R=Realisme, L=Logica, T=Techniek, S=Speelbaarheid, ST=Storytelling\n\n"
    
    report += f"""
---

## 📈 Summary Statistics

- ✅ **KEEP:** {keep_count} scenarios (≥4.0 stars)
- ⚠️ **REWRITE:** {rewrite_count} scenarios (2.0-3.9 stars)
- ❌ **DELETE:** {delete_count} scenarios (<2.0 stars)

**Target:** 12-15 high-quality scenarios

---

## 📋 Detailed Analyses

"""
    
    # Add all detailed analyses
    for analysis in detailed_analyses:
        report += analysis
    
    # Add final recommendations
    report += """
---

## 🎯 Final Recommendations

### Immediate Actions:
"""
    
    if delete_count > 0:
        report += f"1. **DELETE {delete_count} weak scenarios** (score < 2.0)\n"
    
    if rewrite_count > 0:
        report += f"2. **REWRITE {rewrite_count} scenarios** using SCENARIO_CRITERIA.md guidelines\n"
    
    report += f"3. **KEEP {keep_count} strong scenarios** as-is\n"
    
    target_scenarios = 12
    current_strong = keep_count
    
    if current_strong < target_scenarios:
        needed = target_scenarios - current_strong
        report += f"\n### Gap Analysis:\n"
        report += f"- Current strong scenarios: {current_strong}\n"
        report += f"- Target: {target_scenarios}-15\n"
        report += f"- **Need to create/fix: {needed} more scenarios**\n"
    
    report += """
### Quality Checklist per Scenario:
- [ ] Recognizable Power BI situation
- [ ] Logical causal chain (person → action → weapon → location)
- [ ] Technical accuracy (weapon can truly result from action)
- [ ] Playable (3 agents can give different perspectives)
- [ ] Human behavior (unintentional mistakes, miscommunication)

### Focus Areas for Rewrites:
1. **Strengthen Causality:** Make person → weapon connection more explicit
2. **Add Technical Details:** Explain HOW the weapon emerges technically
3. **Humanize:** Add time pressure, miscommunication, assumptions
4. **Expand Context:** Add timing, planning, who saw what when
5. **Test Playability:** Can agents give hints without revealing answer?

---

*Report generated by audit_scenarios.py*
"""
    
    return report

def main():
    print("🔍 Starting scenario audit...")
    print(f"📡 Connecting to Supabase: {supabase_url}")
    
    # Fetch all scenarios
    scenarios = fetch_all_scenarios()
    print(f"✅ Fetched {len(scenarios)} scenarios\n")
    
    if not scenarios:
        print("❌ No scenarios found or error occurred")
        return
    
    # Generate audit report
    print("📊 Analyzing scenarios...")
    report = generate_audit_report(scenarios)
    
    # Save report
    output_file = "SCENARIO_AUDIT_REPORT.md"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"✅ Audit report saved to: {output_file}")
    print("\n" + "="*60)
    print("📋 PREVIEW:")
    print("="*60)
    print(report[:2000] + "\n...\n(see full report in file)")

if __name__ == "__main__":
    main()
