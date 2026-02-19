# The Digital Reef: Informing coral restoration through insights from agent-based modeling

This repository contains a forward-time, individual-based simulation of coral hybridization and mortality. It is designed to model the population dynamics of three species: *Acropora cervicornis*, *Acropora palmata*, and their hybrid *Acropora prolifera*. The simulation also tracks the introgression of beneficial alleles conferring heat resistance.

---

## Table of Contents

1. [Overview](#overview)
2. [Simulation Structure](#simulation-structure)
3. [Variables and Parameters](#variables-and-parameters)
4. [Movement and Dispersal](#movement-and-dispersal)
5. [Reproduction](#reproduction)
   - [Sexual Reproduction](#sexual-reproduction)
   - [Clonal Reproduction](#clonal-reproduction)
6. [Mortality and Bleaching](#mortality-and-bleaching)
7. [Population Sampling and Output](#population-sampling-and-output)

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

## Simulation Structure

The simulation is structured in three phases:

1. **Early()** – Mortality events and bleaching logic.
2. **Late()** – Outputs, ancestry sampling, and year-end population stats.
3. **Reproduction** – Larval dispersal, sexual and clonal reproduction, hybrid determination.

---

## Variables and Parameters

| Category                  | Variable                            | Default   | Description                                                                                      | Units / Notes                |
| ------------------------- | ----------------------------------- | --------- | ------------------------------------------------------------------------------------------------ | ---------------------------- |
| **Bleaching**             | `bleaching_rate`                    | 0.167     | Starting annual probability of bleaching; increases over time during the simulation.             | probability (0–1)            |
| **Bleaching**             | `bleaching_simulation`              | 0         | Enables dynamic bleaching logic (1 = on, 0 = off).                                               | boolean                      |
| **Density / Competition** | `other_species_compete`             | 0.0       | Degree of heterospecific competition. 1 = full competition, 0 = independent niches.              | unitless                     |
| **Density / Competition** | `parentalK`                         | 262 / DS  | Carrying capacity for parental species used in density dependence.                               | individuals per km² (scaled) |
| **Density / Competition** | `proK`                              | derived   | Carrying capacity for *A. prolifera*; depends on `parentalK`, `other_species_compete`, and `DS`. | individuals per km²          |
| **Density / Competition** | `S`                                 | 1         | Spatial competition distance.                                                                    | km                           |
| **Genetics**              | `m1`                                | —         | Neutral marker tracking parental ancestry (e.g., palmata ancestry).                              | mutation type                |
| **Genetics**              | `m2`                                | —         | Speciation loci used to classify offspring species.                                              | mutation type                |
| **Genetics**              | `m3`                                | —         | Beneficial allele type used to test introgression effects.                                       | mutation type                |
| **Mortality / Bleaching** | `base_adult_mortality_rate`         | 0.01      | Baseline annual adult mortality in non-bleaching years.                                          | probability                  |
| **Mortality / Bleaching** | `heat_resistant_mortality_modifier` | 0.5       | Proportional reduction in mortality when beneficial allele is expressed.                         | multiplier                   |
| **Mortality / Bleaching** | `mortality_rate_elevation`          | 2         | Multiplier applied to mortality during bleaching years.                                          | multiplier                   |
| **Mortality / Bleaching** | `mut_type`                          | 0         | Genetic model for beneficial allele: 0 = additive, 1 = dominant, 2 = recessive.                  | categorical                  |
| **Movement / Dispersal**  | `MD`                                | 0.6       | Maximum mating distance.                                                                         | km                           |
| **Movement / Dispersal**  | `SDX`                               | 10        | Larval dispersal standard deviation (X axis).                                                    | km                           |
| **Movement / Dispersal**  | `SDY`                               | 10        | Larval dispersal standard deviation (Y axis).                                                    | km                           |
| **Movement / Dispersal**  | `clonal_SDX`                        | 0.5       | Clonal fragment dispersal SD (X axis).                                                           | km                           |
| **Movement / Dispersal**  | `clonal_SDY`                        | 0.5       | Clonal fragment dispersal SD (Y axis).                                                           | km                           |
| **Movement / Dispersal**  | `meanX`                             | 0         | Mean dispersal offset in X.                                                                      | km                           |
| **Movement / Dispersal**  | `meanY`                             | 0         | Mean dispersal offset in Y.                                                                      | km                           |
| **Reproduction**          | `clone_rate`                        | 0.02      | Probability of clonal reproduction via fragmentation.                                            | probability                  |
| **Reproduction**          | `gamma`                             | 1.0       | Down-weighting factor for prolifera sperm success.                                               | multiplier                   |
| **Reproduction**          | `cer_csp`                           | 0.03      | Conspecific sperm preference for cervicornis eggs.                                               | probability                  |
| **Reproduction**          | `pal_csp`                           | 0.333     | Conspecific sperm preference for palmata eggs.                                                   | probability                  |
| **Reproduction**          | `success_cer`                       | 0.01      | Fertilization success for cervicornis × cervicornis crosses.                                     | probability                  |
| **Reproduction**          | `success_pal`                       | 0.01      | Fertilization success for palmata × palmata crosses.                                             | probability                  |
| **Reproduction**          | `success_pro`                       | 0.01      | Fertilization success for mixed or hybrid crosses.                                               | probability                  |
| **Reproduction**          | `F2_success_scale`                  | 1         | Scaling factor modifying F2 hybrid success.                                                      | multiplier                   |
| **Reproduction**          | `initial_ratio`                     | 0.5       | Initial fraction of the population that is palmata.                                              | proportion                   |
| **Run / Scaling**         | `DS`                                | 5         | Downscaling factor controlling population size and carrying capacity.                            | unitless                     |
| **Run / Scaling**         | `SN`                                | derived   | Initial population size (`SN / DS`).                                                         | individuals                  |
| **Run / Scaling**         | `output_name`                       | "run1"    | Prefix used for output files.                                                                    | string                       |
| **Run / Scaling**         | `wd`                                | user path | Working directory for maps and outputs.                                                          | path                         |
| **Spatial Maps**          | `map_style`                         | 0         | Map selection (0 = simple, 2 = custom).                                  | categorical                  |
| **Spatial Maps**          | `map_size_length`                   | 12.964    | Landscape length.                                                                                | km                           |
| **Spatial Maps**          | `map_size_width`                    | 8.96      | Landscape width.                                                                                 | km                           |
| **Spatial Maps**          | `random_initial_settle`             | 1         | Whether initial individuals are randomly placed.                                                 | boolean                      |
| **Visualization**         | `Color_scheme`                      | 1         | Coloring mode (0 = genomic, 1 = phenotypic).                                                     | categorical                  |
| **Files**                 | `custom_map_filename`               | 0         | Filename for user-supplied habitat map.                                                          | string                       |
| **Files**                 | `file_extention`                    | ".png"    | File extension for map images.                                                                   | string                       |

---

### Notes

* All spatial distances are in **kilometers**.
* `proK` is computed dynamically and will change if `parentalK`, `other_species_compete`, or `DS` are modified.
* Setting `bleaching_simulation = 0` disables genotype-dependent bleaching mortality.
* Population size and density are strongly affected by the downscaling parameter `DS`.

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
   - species_loci >= 162: palmata
   - species_loci <= 18: cervicornis
   - otherwise: prolifera (hybrid)

4. Survival probability is species-specific and may be scaled for F2 hybrids.

```r
if (species_loci >= 162)
    offspring.z = 1
else if (species_loci <= 18)
    offspring.z = 0
else
    offspring.z = 2
```

**Biological interpretation:** Thresholds allow classification of hybrids and backcrosses.

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
