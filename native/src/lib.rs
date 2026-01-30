mod frb_generated;
use flutter_rust_bridge::frb;

#[derive(Clone)]
#[frb]
pub struct PropertyData {
    pub base_income: f64,
    pub quantity: i32,
    pub level: i32,
}

#[frb]
pub struct Achievement {
    pub id: String,
    pub title: String,
    pub is_unlocked: bool,
}

/// Calcule le revenu total par seconde
#[frb]
pub fn calculate_total_income(properties: Vec<PropertyData>, global_prestige: f64) -> f64 {
    let total_base: f64 = properties.iter()
        .map(|p| {
            // Bonus de 10% par niveau : Revenu * Qté * (1.10 ^ Niveau)
            let level_multiplier = 1.10_f64.powi(p.level);
            p.base_income * (p.quantity as f64) * level_multiplier
        })
        .sum();
    
    total_base * global_prestige
}

/// Calcule les gains accumulés pendant l'absence du joueur
#[frb]
pub fn calculate_offline_earnings(
    properties: Vec<PropertyData>, 
    global_prestige: f64, 
    seconds_away: i64
) -> f64 {
    let income_per_sec = calculate_total_income(properties, global_prestige);
    income_per_sec * (seconds_away as f64)
}

/// Analyse l'état du jeu pour débloquer des succès
#[frb]
pub fn check_achievements(properties: Vec<PropertyData>, total_balance: f64) -> Vec<Achievement> {
    let mut achievements = Vec::new();
    let total_buildings: i32 = properties.iter().map(|p| p.quantity).sum();

    achievements.push(Achievement {
        id: "millionaire".to_string(),
        title: "Millionnaire !".to_string(),
        is_unlocked: total_balance >= 1_000_000.0,
    });

    achievements.push(Achievement {
        id: "real_estate_tycoon".to_string(),
        title: "Magnat de l'immobilier".to_string(),
        is_unlocked: total_buildings >= 100,
    });

    achievements
}