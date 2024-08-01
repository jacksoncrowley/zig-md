# Zig-MD
A Basic Molecular Dynamics Engine in Zig, built for personal education purposes.

Very obvious disclaimer: I made this for myself to learn low-level programming and some fundamental MD stuff, and also to try my best to explain it.

### Motivations:
I was not overly thrilled at using MD simulations and yet not *truly* understanding what goes on under the hood. 

And I was also bored of only using python all of the time, and haven't had any real experience coding in a low-level language, like C or Zig. I picked Zig because it seems cool.

### Resources Used:
*Will be continually updated*
#### MD:
- [Understanding Molecular Simulation](https://www.sciencedirect.com/book/9780122673511/understanding-molecular-simulation), Second Edition, by Daan Frenkel (I will buy the third edition soon enough, I don't enjoy reading the examples in fortran)
- [Computer Simulations of Liquids](https://academic.oup.com/book/27866), Second Edition, by Michael P. Allen and Dominic J. Tildesley
- The [GROMACS Reference Manual](https://manual.gromacs.org/2024.2/reference-manual/introduction.html)

#### Zig:
- The [Zig Language Reference](https://ziglang.org/documentation/master/)
- [zig.guide](https://zig.guide)
### Workflow:
For the general order-of-operations, I followed Frenkel's book and the GROMACS manual (as it is the engine I am most familiar with).

I used Claude 3.5 Sonnet from Anthropic - not to write code (it was important I did that myself), but to answer questions: Why do we need to use pointers in low level languages? Does it actually matter if MD integrators are not reversible?

At the end of each "part", I dipped into the GROMACS & molly.jl source code to understand how production-ready MD engines handle the concepts I had just tackled.

## To-Do
#### Part 1: The Engine
- [x] Particles as objects with parameters
- [x] System creator, populate the box with however many particles
- [x] Test Integrators with harmonic 2 body system
- [x] Velocity-verlet integrator algorithm
- [x] Periodic boundary conditions
- [ ] File i/o (.xyz format?)

#### Part 2: The NVE Ensemble
- [ ] Lennard-Jones interactions (currently broken)
- [ ] Sigma and epsilon

#### Part 3: The NVT Ensemble
- [ ] Thermostat (simple? modern?)

#### Part 4: The NVP Ensemble
- [ ] Barostat (")

#### Maybe one day: 
- [ ] bonded interactions
- [ ] generate random velocities with a Maxwell-Boltzmann distribution
- [ ] gro and xtc reader/writer
- [ ] Electrostatic interactions
