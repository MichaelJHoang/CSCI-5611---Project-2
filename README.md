# CSCI 5611 - Project 2: Physically-Based Animation with PDEs
### Jeffrey Jia | jiaxx215 and Jon-Michael Hoang | hoang339

## Controls

Camera:<br>
    - WASD - Move the camera up, down, left, right on the xz-plane<br>
    - Q/E - Rotate the camera counterclockwise/clockwise about the y-axis<br>
    - C - Move the camera down along the y-axis<br>
    - SPACEBAR - Move the camera up along the y-axis<br>
    - R - Reset camera position

Ball:
    - Arrow Keys - Move the ball up, down, left, right on the xz-plane<br>
    - Y + Up Arrow - Move the ball up along y axis<br>
    - Y + Down Arrow - Move the ball down along y axis

**NOTE: The camera's cframe is independent of the ball's cframe, vice versa. What this means is that if the camera is moved in some arbitrary fashion and you start to move the ball, the ball would move in respect to the world and not the camera (e.g. left arrow key to move left means the ball will move left in respect to the world, but would probably move "right" in camera view)**

Simulation:
    - G - Pause/Unpause simulation


## Implementation features

**A quick note: Our cloth is based on a mixture of polyester-like and feathersilk-like materials, which results in a cloth that is somewhat airy**

- Cloth Simulation (50 + 20)
    - The cloth mesh is comprised of an NxM array of vertices connected to form and act as cloth. Initially they were all multiple ropes, but were connected horizontally to fulfill cloth simulation standards.
    - The cloth can interact with the ball. When the ball partially moves through the cloth, the cloth will fall and rest on the ball.

- Air Drag for Cloth (10)
    - The cloth, as it falls, falls down slowly due to the air drag implementation based off of the inclass assignment's rope demo.

- 3D Implementation & Rendering (20)
    - The cloth, ball, and camera exist in 3D space, able to render at 60 FPS. For controls, see above.

- User Interaction (10)
    - Moving the ball with the arrow keys allows you to move the cloth as you go through it.
    - LEFT CLICK to also pull on the cloth

- Realistic Speed (10)
    - We referenced tissue paper for its speeds, in addition to having a gravitational constant of 9.81 m/s^2

- Ripping/Tearing (10)
    - NOT IMPLEMENTED

- Continuum Water Simulation (20)
    - ~~We simulated water in 1D. The simulation is independent of the cloth simulation and can be found under the Water_Simulation Directory~~

## Tools Used

- Processing
- Java programming language


## Difficulties encountered

The cloth simulation was pretty straightforward, but when it came to the water simulation, we
were super stumped because of some array indices kept getting NaN values and we [still] don't know what is causing it.

We also tried to add shaders to the cloth, however, for some reason shaders just straight up doesn't work in the environment, be it attached to the cloth or on some random cube created in the world.

## Video

[Video Link](https://youtube.com/)

## Art contest submission
[Art Submission Link](https://imgur.com/)
