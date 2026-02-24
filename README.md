# The Digital Reef: Informing coral restoration through insights from agent-based modeling

This repository contains a forward-time, individual-based simulation of coral hybridization and mortality. It is designed to model the population dynamics of three species: *Acropora cervicornis*, *Acropora palmata*, and their hybrid *Acropora prolifera*. The simulation also tracks the introgression of beneficial alleles conferring heat resistance.

---

## Table of Contents

1. [Overview](#overview)
2. [Variables and Parameters](#variables-and-parameters)
3. [Simulation Structure](#simulation-structure)
4. [Movement and Dispersal](#movement-and-dispersal)
5. [Reproduction](#reproduction)
   * [Sexual Reproduction](#sexual-reproduction)
   * [Clonal Reproduction](#clonal-reproduction)
6. [Mortality and Bleaching](#mortality-and-bleaching)
   * [Baseline Mortality](#baseline-mortality)
   * [Bleaching Dynamics](#bleaching-dynamics)
   * [Genetic Models of Resistance](#genetic-models-of-resistance)
7. [Population Sampling and Output](#population-sampling-and-output)
   * [Annual Output](#annual-output)
   * [20-year Ancestry Sampling](#20-year-ancestry-sampling)

---

## Overview

This simulation models:
- Spatially explicit dispersal of larvae
- Hybridization between parental coral species
- Clonal reproduction via fragmentation
- Mortality influenced by genotype and bleaching events
- Tracking of ancestry and beneficial alleles over time

It is implemented as an **SLiM forward-time individual-based simulation**, with the ability to output statistics per year and every 20 years for ancestry sampling.


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
| **Run / Scaling**         | `DS`                                | 1         | Downscaling factor controlling population size and carrying capacity.                            | unitless                     |
| **Run / Scaling**         | `SN`                                | derived   | Initial population size (`SN / DS`).                                                         | individuals                  |
| **Run / Scaling**         | `output_name`                       | "run1"    | Prefix used for output files.                                                                    | string                       |
| **Run / Scaling**         | `wd`                                | user path | Working directory for maps and outputs.                                                          | path                         |
| **Spatial Maps**          | `map_style`                         | 0         | Map selection (0 = simple, 2 = custom).                                  | categorical                  |
| **Spatial Maps**          | `map_size_length`                   | 12.964    | Landscape length.                                                                                | km                           |
| **Spatial Maps**          | `map_size_width`                    | 8.96      | Landscape width.                                                                                 | km                           |
| **Spatial Maps**          | `random_initial_settle`             | 1         | Whether initial individuals are randomly placed.                                                 | boolean                      |
| **Visualization**         | `Color_scheme`                      | 1         | Coloring mode for GUI (0 = genomic, 1 = phenotypic).                                                     | categorical                  |
| **Files**                 | `custom_map_filename`               | simple_map         | Filename for user-supplied habitat map.                                                          | string                       |
| **Files**                 | `file_extention`                    | ".png"    | File extension for map images.                                                                   | string                       |

---

### Notes

* All spatial distances are in **kilometers**.
* `proK` is computed dynamically and will change if `parentalK`, `other_species_compete`, or `DS` are modified.
* Setting `bleaching_simulation = 0` disables genotype-dependent bleaching mortality.
* Population size and density are strongly affected by the downscaling parameter `DS`.

---

## Simulation Structure

The simulation follows a **nonWF, forward-time life cycle** implemented in SLiM. Each yearly time step proceeds in the following order:

1. **Early() — Mortality and bleaching**

   * Applies baseline adult mortality.
   * If bleaching is enabled, mortality is elevated and may be reduced by beneficial alleles (`m3`) depending on the specified genetic model (`mut_type`).
   * Individuals that do not survive have `fitnessScaling = 0`.

2. **Reproduction — Sexual and clonal production of offspring**

   * Mature individuals may reproduce sexually with nearby mates within distance `MD`.
   * Fertilization success depends on species pairing and conspecific sperm preference.
   * Offspring species identity is determined from speciation loci (`m2`).
   * Individuals age ≥ 2 may also reproduce clonally with probability `clone_rate`.

3. **Late() — Density dependence and outputs**

   * Density-dependent settlement is applied using local competition within radius `S`.
   * Population statistics are written annually.
   * Every 20 years, individuals are sampled for ancestry and spatial output.

---

## Movement and Dispersal

Larval dispersal is modeled as a **bivariate normal displacement** around the parent colony:

```r
coordinate_matrix = rmvnorm(1, c(meanX, meanY),
                            matrix(c(SDX^2, 0, 0, SDY^2), nrow=2))
newPos = individual.spatialPosition + coordinates
```

### Key mechanics

* Dispersal is **isotropic but parameterized separately** in X and Y if isotropic distirubtion is not desired.
* The mean displacement is typically zero (`meanX = meanY = 0`).
* Settlement is only allowed if the location is inside the habitat:

```r
p1.pointInBounds(newPos)
```

### Density-dependent settlement

After dispersal, successful establishment depends on:

* Local crowding within radius `S`
* Species-specific carrying capacities (`parentalK`, `proK`)
* Cross-species competition scaled by `other_species_compete`

**Interpretation:** Larvae disperse broadly but recruitment is locally limited by crowding and niche overlap.

---

## Reproduction

### Sexual reproduction

Sexual reproduction occurs between nearby colonies within mating distance `MD`.

#### Fertilization success

Cross success depends on species identity:

* `success_cer` — cervicornis × cervicornis
* `success_pal` — palmata × palmata
* `success_pro` — mixed or hybrid crosses

Eggs also exhibit **conspecific sperm precidence**:

* `cer_csp`
* `pal_csp`

The parameter `gamma` optionally down-weights prolifera sperm success.

---

### Species determination via speciation loci

Offspring species identity is determined by counting `m2` mutations:

**Interpretation**

* Low counts → cervicornis ancestry
* High counts → palmata ancestry
* Intermediate counts → hybrids/backcrosses

This creates a **continuous introgression spectrum** rather than discrete hybrid classes.

---

### Clonal reproduction

Individuals age ≥ 2 may fragment clonally:

Clonal offspring:

* inherit the full genome
* are placed using a **shorter-distance dispersal kernel**

**Biological meaning:** Represents storm fragmentation and local reattachment.

---

## Mortality and Bleaching

### Baseline mortality

Each year, adults experience:

```
base_adult_mortality_rate
```

If bleaching is disabled, this is the only mortality source.

---

### Bleaching dynamics

When `bleaching_simulation = 1`:

* Annual bleaching probability starts at `bleaching_rate`
* Bleaching probability increases
* During bleaching years:

  * mortality is multiplied by `mortality_rate_elevation`
  * beneficial alleles (`m3`) may reduce mortality

---

### Genetic models of resistance
The effect of beneficial alleles depends on `mut_type`.

#### Additive (0)
Each copy reduces mortality multiplicatively:

#### Dominant (1)
Any copy confers protection.

#### Recessive (2)
Two copies required for protection.

---

**Important interpretation:**
The model allows beneficial alleles to introgress through hybridization and alter survival under climate stress.

---

## Population Sampling and Output

### Annual output

Each year the model records:

* total population size
* species counts
* hybrid ratios
* ancestry introgression metrics
* counts of beneficial alleles by species
* current bleaching probability

This enables tracking of **eco-evolutionary dynamics through time**.

---

### 20-year ancestry sampling

Every 20 years, up to 1000 individuals are sampled and written to file with:

* species identity (`z`)
* spatial coordinates
* age
* parental ancestry proportions

**Purpose:** Enables spatial and genomic analysis of introgression patterns.

---
