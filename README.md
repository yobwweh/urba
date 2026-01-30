#  Urba - Idle City Manager

Urba est un jeu de gestion urbaine "Idle" (incrémental) conçu pour offrir des performances extrêmes grâce à une architecture hybride. Le moteur de calcul économique est entièrement déporté dans Rust, garantissant une précision et une fluidité totale même avec des milliers de transactions par seconde.

## Créateur
Développé par Yoboué N'guessan Armel Constant /Yobwweh Expertise : Flutter & Rust Integration

##  Concept Technique
Le projet repose sur le principe de la séparation des responsabilités (Separation of Concerns) via une interface FFI (Foreign Function Interface) :

Le Moteur (Rust) : Effectue les calculs de revenus, gère les paliers de succès et les calculs exponentiels de niveaux en un seul appel vectorisé pour économiser la batterie et le processeur.

L'Interface (Flutter) : Utilise la puissance de GetX pour une réactivité immédiate de l'interface utilisateur et une gestion d'état simplifiée.

La Persistance : Système de sauvegarde hybride stockant l'état du jeu en local via JSON pour une reprise instantanée.

##  Fonctionnalités implémentées
-  **Calcul Vectorisé** : Rust traite l'ensemble des propriétés en un seul appel pour une performance maximale.
-  **Système de Revenus** : Calcul en temps réel du profit généré par chaque bâtiment.
-  **Progression** : Système de niveaux d'amélioration et multiplicateurs de prestige.
-  **Sauvegarde Persistante** : Utilisation de `shared_preferences` et JSON pour conserver l'état du jeu.
-  **Gains Hors-ligne** : Calcul automatique des profits générés pendant l'absence du joueur.

##  Stack Technique
- **Framework** : Flutter
- **Langage Système** : Rust
- **Bridge** : flutter_rust_bridge
- **Gestion d'état** : GetX
- **Stockage** : SharedPreferences

##  Roadmap de Développement Massive
- **Phase 1** : Fondations & Moteur Core (Terminée)
- [x] **Architecture Hybride** : Mise en place du pont flutter_rust_bridge.

- [x] **Moteur Vectorisé** : Calcul des revenus groupés en Rust pour éviter la latence FFI.

- [x] **Logique Exponentielle** : Implémentation des courbes de coûts et de gains en Rust.

- [x] **Persistance** : Système de sauvegarde locale via JSON et SharedPreferences.

 - **Phase 2** : Expérience Utilisateur (UI/UX)
- [ ] **Dashboard Réactif** : Affichage de la balance avec animation de compteur (Ticker).

- [ ] **Composants Dynamiques** : Cartes de propriétés avec barres de progression de production.

- [ ] **Feed-back Visuel** : Effets de particules lors de l'achat ou de l'upgrade.

- [ ] **Dark/Light Mode** : Thème urbain adaptatif avec Material 3.

 - **Phase 3** : Profondeur du Gameplay (Logiciel Rust)
- [ ] **Managers & Automatisation** : Recrutement de PNJs (gérés en Rust) qui achètent automatiquement des upgrades.

- [ ] **Arbre de Compétences** : Système de recherche pour débloquer de nouveaux types de bâtiments.

- [ ] **Système de Prestige (Soft Reset)** : Mécanique pour recommencer avec un multiplicateur "Héritage" permanent.

- [ ] **Événements Aléatoires** : Moteur de probabilités en Rust pour des crises économiques ou des booms de croissance.

 - **Phase 4** : Statistiques & Analyse
- [ ] **Graphiques de Performance** : Visualisation de l'évolution de la richesse sur 24h (via la bibliothèque fl_chart).

- [ ] **Calculateur de Rentabilité** : Indicateur Rust affichant le "Temps de retour sur investissement" (ROI) pour chaque bâtiment.

- [ ] **Journal d'Activité** : Historique des derniers achats et succès débloqués.

 - **Phase 5** : Connectivité & Social
- [ ] **Cloud Save** : Synchronisation de la sauvegarde locale avec Firebase ou Supabase.

- [ ] **Leaderboards Mondiaux** : Classement des plus gros empires financiers.

- [ ] **Marché entre Joueurs** : Système d'échange de ressources ou de boosts (Prestige partagé).

 - **Phase 6** : Optimisation & Robustesse
- [ ] **Multi-threading Rust** : Utilisation de Rayon en Rust pour paralléliser les calculs si le nombre de propriétés devient massif.

- [ ] **Tests Unitaires Croisés** : Tests en Rust pour la logique mathématique et tests Widget en Flutter.

- [ ] **CI/CD Pipeline** : Automatisation de la compilation Rust/Flutter via GitHub Actions.

 - **Phase 7** : Polissage & Monétisation
- [ ] **Système de Boutique** : Achats in-app pour des boosts de temps ou des skins de ville.

- [ ] **Publicités Récompensées** : Doublement des gains hors-ligne contre visionnage d'une pub.

- [ ] **Localisation** : Traduction complète en 10+ langues.

##  Installation & Développement
1. S'assurer d'avoir **Flutter** et **Rust** installés.
2. Installer les dépendances :
   ```bash
   flutter pub get
   ```
3. Générer le pont (bridge) entre Rust et Flutter :
   ```bash
   flutter_rust_bridge_codegen generate
   ```
4. Lancer l'application :
   ```bash
   flutter run
   ```
