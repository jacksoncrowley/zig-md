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
- The [GROMACS Reference Manual](https://manual.gromacs.org/2024.2/reference-manual/introduction.html)

#### Zig:
- The [Zig Language Reference](https://ziglang.org/documentation/master/)
- [zig.guide](https://zig.guide)
### Workflow:
For the general order-of-operations, I followed Frenkel's book and the GROMACS manual (as it is the engine I am most familiar with).

I used Claude 3.5 Sonnet from Anthropic - not to write code (it was important I did that myself), but to answer questions: Why do we need to use pointers in low level languages? Does it actually matter if MD integrators are not reversible?

At the end of each "part", I dipped into the GROMACS & molly.jl source code to understand how production-ready MD engines handle the concepts I had just tackled.

## To-Do
- [x] Particles as objects with parameters
- [x] System creator, populate the box with however many particles
- [ ] Lennard-Jones interactions
- [ ] Velocity-verlet integrator algorithm
- [ ] Periodic boundary conditions
- [ ] File i/o (.xyz format?)
- [ ] Electrostatic interactions
- [ ] Thermostat (simple? modern?)
- [ ] Barostat (")

#### Maybe one day: 
- [ ] bonded interactions
- [ ] generate random velocities with a Maxwell-Boltzmann distribution
- [ ] gro and xtc reader/writer