# Zig-MD
A Basic Molecular Dynamics Engine in Zig, built for personal education purposes.

Very obvious disclaimer: I made this for myself to learn Zig and some fundamental MD stuff, and also to try my best to explain it.

### Motivations:
I was not overly thrilled at using MD simulations and yet not *truly* understanding what goes on under the hood. 

And I was also bored of only using python all of the time.

### Resources Used:
- The [GROMACS Reference Manual](https://manual.gromacs.org/2024.2/reference-manual/introduction.html)
- The [Zig Language Reference](https://ziglang.org/documentation/master/)

### Workflow:
For the general order-of-operations, I followed Frenkel's book and the GROMACS manual (as it is the engine I am most familiar with).

I used Claude 3.5 Sonnet from Anthropic - not to write code (it was important I did that myself), but to answer questions: Why do we need to use pointers in low level languages? Does it actually matter if MD integrators are not reversible?

At the end of each "part", I dipped into the GROMACS & molly.jl source code to understand how production-ready MD engines handle the concepts I had just tackled.

## To-Do
### Part 1
- [ ] Particles as objects with parameters
- [ ] System creator, populate the box with however many particles
- [ ] Velocity-verlet integrator algorithm
- [ ] File i/o (.xyz format?)

### Part 2: Non-Bonded Interactions
- [ ] Lennard-Jones interactions
- [ ] Electrostatic interactions


### Part 3: Thermostats and Barostats
- [ ] Thermostat (simple? modern?)
- [ ] Barostat (")

#### Part ??: 
- [ ] bonded interactions
- [ ] gro and xtc reader/writer