# 2D Structural Finite Element Solver (MATLAB)

## Overview
This project implements a modular 2D finite element analysis (FEA) solver for truss structures in MATLAB. It computes nodal displacements, internal forces, stresses, and safety factors, and includes parametric studies for structural design evaluation.

The solver has been validated against analytical solutions for simple truss configurations.

It demonstrates both:
- numerical implementation of finite element methods  
- engineering interpretation of results, including failure prediction and design insight  

---

## Features

- Global stiffness matrix assembly  
- Boundary condition handling  
- Nodal displacement solution  
- Element force and stress calculation  
- Safety factor evaluation  
- Stress visualization (tension vs compression)  
- Critical element identification  

### Parametric Studies
- Cross-sectional area vs safety factor  
- Load magnitude vs safety factor  

---

## Assumptions

- Linear elastic material behavior  
- Small deformations  
- Axial-only truss elements (no bending or shear)  
- Static loading conditions  

---

## Results

### Stress Distribution
![Stress](images/stressPlot.png)

- Red = tension  
- Blue = compression  
- Critical members identified via minimum safety factor  

---

### Area Parametric Study
![Area Study](images/areaStudyPlot.png)

Safety factor increases linearly with cross-sectional area.

Key relationship:  
σ = N / A  
→ Safety Factor ∝ Area  

**Insight:** Increasing cross-sectional area directly improves structural safety.

---

### Load Parametric Study
![Load Study](images/loadStudyPlot.png)

Safety factor decreases as load increases.

The structure reaches failure at approximately:

**Maximum load factor ≈ 2.2× original load**

Key relationship:  
Safety Factor ∝ 1 / Load  

**Insight:** The structure can safely carry approximately 2.2× the original load before reaching failure, defining its maximum allowable load capacity.

---

## Validation

The solver results were verified against analytical solutions for simple truss systems, showing strong agreement in member forces and reaction forces.

---

## Key Engineering Insights

- Structural safety is proportional to cross-sectional area  
- Structural capacity is inversely proportional to applied load  
- Internal forces are influenced by geometry, not just external loads  
- Critical elements govern overall structural failure  

---

## How to Run

Run the main solver:

runTrussSolver

Run parametric studies:

parametricAreaStudy  
parametricLoadStudy  

---

## Project Structure

runTrussSolver.m — Main execution script  

defineProblem.m — Geometry and material definition  
buildSystem.m — Stiffness matrix assembly  
solveTruss.m — System solution  
computeReactions.m — Reaction force calculation  
postProcess.m — Stress and force calculations  
computeSafetyFactor.m — Safety factor evaluation  
plotTruss.m — Visualization  
printResults.m — Output formatting  

parametricAreaStudy.m — Area sensitivity analysis  
parametricLoadStudy.m — Load capacity analysis  

images/ — Result visualizations  

---

## Future Work

- Add beam/frame elements (bending and rotational DOFs)  
- Extend to 3D structural analysis  
- Implement nonlinear material behavior  
- Add dynamic loading capabilities  

---

## Summary

This project demonstrates a complete structural analysis workflow:

1. Model definition  
2. Finite element solution  
3. Stress and safety evaluation  
4. Design exploration through parametric studies  

It serves as both a computational tool and a demonstration of engineering decision-making.
