# BLASTEROIDS
#### Video Demo:  <URL HERE>
#### Description: A simple asteroid shooting game written in Lua on the LÖVE framework.

<br>

# Overview
BLASTEROIDS is a 2D shooting game written on the LÖVE framework for Lua. In BLASTEROIDS, the player navigates a spaceship through an asteroid field while blowing up asteroids with your laser. The game features powerups that upgrade the spaceship's laser and restores its HP, as well as a level progression system that makes the asteroids faster and stronger as the game progresses.

<br>

# Program Structure

## main.lua

**main.lua** is the game's entry point and contains three main functions specific to the LÖVE framework: `love.load()`, `love.update(dt)`, and `love.draw()`. 

`love.load()` defines global gameplay constants as discrete variables or as tables of values. These constants set the basic terms of the gameplay throughout the program. Examples include the maximum level a player can reach and the number of points needed to reach each level; the rates at which enemies spawn into the game based on the player's level; the likelihood of a given enemy spawning based on the player's level; and the rate of fire of the player's weapon. 

`love.load()` also calls the function `startGame()`, which initializes empty tables to be dynamically populated with game objects including the player's ship, enemies, powerups, laser beams, graphical effects, popup text, and the heads-up display. Subsequent calls to `startgame()` clear all the game objects in preparation for starting a new game.

The game's classes draw from these values as needed to initialize each new instance of such classes. Grouping them together at the start of **main.lua** helps us to tweak gameplay during playtesting. `love.load()` also sets the keyboard keys used to play the game.

`love.update(dt)` forks depending on the current value of `gameState`, which includes four mutually exclusive states: `play`, `pause`, `menu`, and `gameover`. The main gameplay loop runs in the `play` fork. Each call to `love.update(dt)` where `gameState.play == true` executes the following steps:

1. Move the player's ship. When a movement key is pressed, the ship rapidly accelerates along the x- and y-axes until its top speed is reached. When all movement keys are released, the ship gradually deccelerates to a stop.

2. Decrement the laser's cooldown timer (i.e., the time until the player can fire again) and shoot the laser if the cooldown timer has expired. Each time the player upgrades the laser by collecting a powerup, the cooldown timer gets slightly shorter and the laser's damage increases.

3. Check if the player's score is such that the player should level up, which triggers changes to the enemies' speeds and spawn rates. 

4. Update the `spawn` object. `Spawn` is a special class responsible for spawning enemies and powerups, implemented in **spawn.lua**. The `spawn` object adds new instances of `Enemy` and `Powerup` to the global object tables `enemyList` and `powerupList`, respectively, in accordance with the global lists of spawn rates. From levels 1-4, the only enemy that spawns is the brown meteor. At level 5, a stronger grey meteor starts spawning at a rate that is initially 20% and gradually scales up to 50% at the highest level. 

5. Move the enemies onscreen; "kill" an enemy if it is offscreen or its HP is zero; check enemies' collision with the player (and reduce the player's HP and destroy the enemy if a collision occurs); and remove dead enemies from `enemyList`.

6. Move the lasers onscreen; check lasers' collision with enemies; "kill" a laser if it is offscreen; and remove dead lasers from `weaponList`.

7. Move the powerups onscreen; check powerups' collision with the player; "kill" a powerup if it is offscreen; and remove dead powerups from `powerupList`.

8. Update various graphical effects and notifications that have been triggered onscreen by gameplay (e.g., each time an asteroid is destroyed, an explosion is rendered and the number of points is briefly displayed); remove effects and notifications that have finished from `gfxList` and `notifyList`, respectively.

9. Check if the player has died, in which case, `gameState.gameover` is set to `true` and the other states are set to `false`.

Note that many of the above tasks are performed via calls to other functions, including the class methods located in the other source files.

Finally, `love.draw()` iterates over the global object tables of lasers, enemies, graphics, powerups, player, notifications and the HUD, and draws each to the screen.

The mechanics of the various game objects are implemented in separate source files:

### enemies.lua

### gfx.lua

### hud.lua

### notify.lua

### player.lua

### powerups.lua

### spawn.lua

### weapons.lua

<br>

## devConsole.lua

Pressing the assigned key (by default, the backwards apostrophe above the "tab" key) brings up an onscreen `DevConsole` that displays certain gameplay variables. This is useful for debugging and balancing gameplay during playtesting. For example, `DevConsole` displays the laser's rate of fire and damage per hit, which increases throughout the game as the player collects powerups.

<br>

# Credits
All original project content is copyright (c) 2023 Anton Ziajka.

LOVE is copyright (c) 2006-2023 LOVE Development Team. See [licensing information](https://github.com/love2d/love/blob/main/license.txt).

The "classic.lua" library is copyright (c) 2014, rxi. See [licensing information](https://github.com/rxi/classic/blob/master/LICENSE).

Graphics by [Kenney Vleugels](www.kenney.nl). Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). 

Special thanks to Sheepolution's tutorial series, [How to LÖVE](https://sheepolution.com/learn/book/contents).