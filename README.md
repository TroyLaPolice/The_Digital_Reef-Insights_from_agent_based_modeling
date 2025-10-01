# The Digital Reef: Informing coral restoration through insights from agent-based modeling

This repository contains a forward-time, individual-based simulation of coral hybridization and mortality. It is designed to model the population dynamics of three species: **Acropora cervicornis**, **Acropora palmata**, and their hybrid **Acropora prolifera**. The simulation also tracks the introgression of beneficial alleles conferring heat resistance.

---

## Table of Contents

1. [Overview](#overview)
2. [Key Biological Concepts](#key-biological-concepts)
3. [Simulation Structure](#simulation-structure)
4. [Variables and Parameters](#variables-and-parameters)
5. [Movement and Dispersal](#movement-and-dispersal)
6. [Reproduction](#reproduction)
   - [Sexual Reproduction](#sexual-reproduction)
   - [Clonal Reproduction](#clonal-reproduction)
7. [Mortality and Bleaching](#mortality-and-bleaching)
8. [Population Sampling and Output](#population-sampling-and-output)
9. [Visualization and Color Schemes](#visualization-and-color-schemes)
10. [Example Code Snippets](#example-code-snippets)
11. [Flowcharts](#flowcharts)

---

## Overview

This simulation models:
- Spatially explicit dispersal of larvae
- Hybridization between parental coral species
- Clonal reproduction via fragmentation
- Mortality influenced by genotype and bleaching events
- Tracking of ancestry and beneficial alleles over time

It is implemented as an **SLiM-like forward-time individual-based simulation**, with the ability to output statistics per year and every 20 years for ancestry sampling.

---

## Key Biological Concepts

1. **Species and Hybridization**
   - `cervicornis` (A. cervicornis) and `palmata` (A. palmata) are parental species.
   - `prolifera` (A. prolifera) is a hybrid species resulting from crosses between the parentals.
   - Hybrid and backcross classes are tracked using `species_loci`.

2. **Larval Dispersal**
   - Larvae disperse based on a 2D multivariate normal distribution.
   - Settlement depends on local density (competition) and habitat suitability.

3. **Bleaching and Mortality**
   - Climate-driven bleaching increases over time.
   - Mortality is genotype-dependent, reflecting heat-resistance alleles.
   - Different genetic models: additive, dominant, recessive.

4. **Clonal Reproduction**
   - Fragments reproduce clonally, simulating stochastic fragmentation.
   - Age reduction reflects resource allocation to fragments.

---

## Simulation Structure

The simulation is structured in three phases:

1. **Early()** – Mortality events and bleaching logic.
2. **Late()** – Outputs, ancestry sampling, and year-end population stats.
3. **Reproduction** – Larval dispersal, sexual and clonal reproduction, hybrid determination.

---

## Variables and Parameters

| Variable | Description | Biological Interpretation |
|----------|-------------|--------------------------|
| `individual.z` | Phenotype: 0 = cervicornis, 1 = palmata, 2 = prolifera | Allows classification of species for hybridization and mortality |
| `m1` | Mutations tracking parental ancestry | Used to compute proportion of parental alleles in hybrids |
| `m2` | Speciation loci | Determines species of offspring based on thresholds |
| `m3` | Beneficial heat-resistance alleles | Reduces bleaching mortality depending on genetic model |
| `SDX`, `SDY` | Standard deviations for larval movement | Controls dispersal distance in X/Y coordinates |
| `clone_rate` | Probability of clonal reproduction | Reflects stochastic fragmentation rate |
| `parentalK`, `proK` | Carrying capacities for parental and hybrid species | Local density limits settlement success |
| `other_species_compete` | Competition factor from heterospecific neighbors | Determines how interspecific competition reduces settlement |
| `heat_resistant_mortality_modifier` | Proportional reduction in mortality due to beneficial allele | Simulates protective effect of heat-resistance alleles |
| `bleaching_rate` | Probability of bleaching each year | Increases over time to simulate climate change |
| `mut_type` | Genetic model for heat resistance: 0 = additive, 1 = dominant, 2 = recessive | Influences how allele count affects mortality |

---

## Movement and Dispersal

Larvae move according to a multivariate normal distribution around the parent’s location.

```r
coordinate_matrix = rmvnorm(1, c(meanX, meanY), matrix(c(SDX^2, 0, 0, SDY^2), nrow=2))
coordinates = c(coordinate_matrix[0], coordinate_matrix[1])
newPos = individual.spatialPosition + coordinates
```

- `p1.pointInBounds(newPos)` ensures larvae remain in the simulation grid.
- Settlement success is also influenced by local density and habitat suitability.

**Biological reasoning:** This simulates realistic coral larval dispersal with limited range and density-dependent settlement.

---

## Reproduction

### Sexual Reproduction

1. Offspring inherit a mix of parental alleles.
2. Species of offspring determined based on `species_loci`:
   - >= 162: palmata
   - <= 18: cervicornis
   - otherwise: prolifera (hybrid)

3. Survival probability is species-specific and may be scaled for F2 hybrids.

```r
if (species_loci >= 162)
    offspring.z = 1
else if (species_loci <= 18)
    offspring.z = 0
else
    offspring.z = 2
```

**Biological interpretation:** Thresholds allow classification of hybrids and backcrosses, reflecting partial introgression.

### Clonal Reproduction

- Occurs stochastically after age 2.
- Offspring is a partial clone with age set to 2.
- Dispersal follows a smaller SD (`clonal_SDX`, `clonal_SDY`).

```r
if (rbinom(1, 1, clone_rate) == 1) {
    offspring = subpop.addCloned(individual)
    offspring.age = 2
}
```

**Biological interpretation:** Models fragmentation, a common asexual reproduction method in corals.

---

## Mortality and Bleaching

### Dynamic Bleaching Simulation

- Bleaching probability increases by 4% each year.
- If bleaching occurs, mortality is scaled by genotype:

```r
if (mut_type == 0) { # additive
    new_mortality_rate = mortality_rate * (1 - heat_resistant_mortality_modifier)^ind.countOfMutationsOfType(m3)
} else if (mut_type == 1) { # dominant
    new_mortality_rate = ifelse(ind.countOfMutationsOfType(m3) >= 1, mortality_rate*(1 - heat_resistant_mortality_modifier), mortality_rate)
} else { # recessive
    new_mortality_rate = ifelse(ind.countOfMutationsOfType(m3) == 2, mortality_rate*(1 - heat_resistant_mortality_modifier), mortality_rate)
}
```

- Survival is sampled probabilistically.
- Non-survivors have `fitnessScaling = 0`.

**Biological interpretation:** Heat-resistance alleles reduce mortality in a manner consistent with dominance or additivity.

### Simple Mortality

If bleaching is disabled, each individual experiences base adult mortality.

---

## Population Sampling and Output

### Every 20 years

- Sample up to 1000 individuals for ancestry tracking.
- Outputs include species, proportion of parental alleles, spatial position, and age.

### Every year

- Counts pure parental, backcross, F1, F2, and hybrid individuals.
- Outputs population statistics including species ratios and introgressed beneficial alleles.

```r
output_string = paste(sim.cycle, pop_size, num_palmata, num_cervicornis, num_prolifera, ratio,
                        cervicornis_ancestry_palmata, palmata_ancestry_cervicornis,
                        palmata_ancestry_prolifera, cervicornis_ancestry_prolifera,
                        beneficial_in_pro, beneficial_in_pal, beneficial_in_cer, bleaching_rate, sep=",")
writeFile(wd + output_stats_file_name, output_string, append=T)
```

**Biological interpretation:** Enables tracking of hybridization dynamics, introgression, and population composition over time.

---

## Visualization and Color Schemes

- **Discrete colors**: cervicornis = red, palmata = blue, prolifera = green.
- **Gradient colors**: represent proportion of parental alleles.

```r
offspring.color = if (Color_scheme == 1) {
    if (offspring.z == 0) "red" else if (offspring.z == 1) "blue" else "green"
} else {
    ancestry = offspring.countOfMutationsOfType(m1) / (sim.chromosome.lastPosition * 2 + 2)
    offspring.color = rgb2color(hsv2rgb(c(0.6, 1.0, ancestry)))
}
```

---

## Example Code Snippets

**Hybrid determination:**

```r
species_loci = offspring.countOfMutationsOfType(m2)
if (species_loci >= 162) offspring.z = 1
else if (species_loci <= 18) offspring.z = 0
else offspring.z = 2
```

**Bleaching mortality:**

```r
bleaching_prob = c(bleaching_rate, 1 - bleaching_rate)
bleaching_year = sample(c(0,1), 1, weights=bleaching_prob)
if (bleaching_year == 0) apply_bleaching_mortality()
```

---

## Flowcharts

### Larval Dispersal & Settlement

```text
[Parent Coral] -> [Larval Production] -> [Dispersal via mvnorm] -> [Check Bounds & Habitat Suitability] -> [Check Local Density vs K] -> [Settle Successfully or Die]
```

### Mortality

```text
[Individual] -> [Is it Bleaching Year?] -> Yes: [Calculate Genotype-Specific Mortality] -> [Random Survival] -> Alive or Dead
                          -> No: [Base Mortality] -> [Random Survival] -> Alive or Dead
```

### Clonal Reproduction

```text
[Parent Age > 2?] -> Yes: [Randomly Decide Fragmentation] -> [Generate Clonal Offspring] -> [Disperse & Settle] -> [Reduce Parent Age]
                          -> No: [No Cloning]
```

---

This simulation allows detailed exploration of coral hybridization dynamics, bleaching effects, and the spread of beneficial alleles under changing climate conditions. Outputs can be used to generate figures, analyze introgression, and study population persistence under stress.

```

