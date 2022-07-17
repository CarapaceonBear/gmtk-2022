![splash](/repo_pics/splash.png)

# Nervous Dice
GMTK game jam submission

## The Game
This is a solo-made game, made for the GTMK game jam 2022. The prompt for this year's jam was "Roll of the Dice". I made the it in Godot, and I made 3d assets in blender.

The game involves placing randomly rolled dice in a grid. However, when you placed each die, all vertically and horizontally adjacent dice will re-roll. Your score is the total of all dice.

This is my first game-jam, and I have limited game-dev experience. I'm really happy with my game, simple as it is. Seeing a small project through to completion has been a great experience.

![screenshot](/repo_pics/screnshot.png)

## Live link
You can play the game on itch.io [here](https://carapaceonbear.itch.io/nervous-dice)

## Log
I went into the game-jam planning to make a 2d game, since those are always easier. However, the idea I hit on right away involved literal dice. It's not satisfying to roll dice unless you are seeing them rotate, so I had to make the game in 3d.

Taking inspiration from a previous experiment, I had a collider following the mouse along a 2d plane, aligned to the camera. Interactable elements had a corresponding area on this plane. This is how I got mouse input in the 3d space.

![bts](/repo_pics/bts.png)

When dice land on the table, they determine their face-up value based on their rotation. The values for the whole grid are checked after every move, as sometimes the dice take a little too long to settle, and their value isn't read in time.

Adding sound to the game was new for me, but Godot makes this very simple. Exporting and uploading the project were similarly new and easy.

I'm satisfied with the end result of my game, and really happy to have taken part in the game-jam.
