# Source and replicate data for Figures 2–9

This collection contains the numerical data underlying Figures 2–9 of the Caribbean *Acropora* population-simulation study. It includes **42 comma-separated value (CSV) files**: one figure-level source-data file and one simulation-replicate file for each of 21 figure panels. The modeled taxa are *Acropora palmata*, *A. cervicornis*, and their hybrid *A. prolifera*.

## File organization

Files follow the naming convention:

- `Figure_<panel>_source_data.csv` — the summarized means and plotting coordinates for the named panel.
- `Figure_<panel>_replicate_data.csv` — the per-simulation values used to calculate those summaries.

For example, `Figure_2A_source_data.csv` contains the stacked-bar summaries for Figure 2A, whereas `Figure_2A_replicate_data.csv` retains the species proportions of the individual simulation replicates contributing to those bars.

The complete set is:

| Figure panel | Quantity represented | Experimental factor(s) varied | Source-data file | Replicate-data file |
|---|---|---|---|---|
| 2A | Species proportions | `gamma_n` | `Figure_2A_source_data.csv` | `Figure_2A_replicate_data.csv` |
| 2B | Heterospecific ancestry | `gamma_n` | `Figure_2B_source_data.csv` | `Figure_2B_replicate_data.csv` |
| 2C | Species proportions | `cer_csp_n` | `Figure_2C_source_data.csv` | `Figure_2C_replicate_data.csv` |
| 2D | Heterospecific ancestry | `cer_csp_n` | `Figure_2D_source_data.csv` | `Figure_2D_replicate_data.csv` |
| 2E | Species proportions | `F2_success_scale_n` | `Figure_2E_source_data.csv` | `Figure_2E_replicate_data.csv` |
| 2F | Heterospecific ancestry | `F2_success_scale_n` | `Figure_2F_source_data.csv` | `Figure_2F_replicate_data.csv` |
| 2G | Species proportions | `success_pro_n` | `Figure_2G_source_data.csv` | `Figure_2G_replicate_data.csv` |
| 2H | Heterospecific ancestry | `success_pro_n` | `Figure_2H_source_data.csv` | `Figure_2H_replicate_data.csv` |
| 3A | Species proportions | `initial_palmata_n` | `Figure_3A_source_data.csv` | `Figure_3A_replicate_data.csv` |
| 3B | Heterospecific ancestry | `initial_palmata_n` | `Figure_3B_source_data.csv` | `Figure_3B_replicate_data.csv` |
| 3C | Species proportions | `other_species_compete_n` | `Figure_3C_source_data.csv` | `Figure_3C_replicate_data.csv` |
| 3D | Heterospecific ancestry | `other_species_compete_n` | `Figure_3D_source_data.csv` | `Figure_3D_replicate_data.csv` |
| 4 | Species proportions | `initial_palmata_n` × `other_species_compete_n` | `Figure_4_source_data.csv` | `Figure_4_replicate_data.csv` |
| 5A | Species proportions | `starting_number_n` | `Figure_5A_source_data.csv` | `Figure_5A_replicate_data.csv` |
| 5B | Heterospecific ancestry | `starting_number_n` | `Figure_5B_source_data.csv` | `Figure_5B_replicate_data.csv` |
| 6A | Species proportions | `heat_resistant_mortality_modifier_n` | `Figure_6A_source_data.csv` | `Figure_6A_replicate_data.csv` |
| 6B | Heterospecific ancestry | `heat_resistant_mortality_modifier_n` | `Figure_6B_source_data.csv` | `Figure_6B_replicate_data.csv` |
| 6C | Mean beneficial-allele copies | `heat_resistant_mortality_modifier_n` | `Figure_6C_source_data.csv` | `Figure_6C_replicate_data.csv` |
| 7 | Species proportions | `other_species_compete_n` × `heat_resistant_mortality_modifier_n` | `Figure_7_source_data.csv` | `Figure_7_replicate_data.csv` |
| 8 | Mean beneficial-allele copies | `other_species_compete_n` × `heat_resistant_mortality_modifier_n` | `Figure_8_source_data.csv` | `Figure_8_replicate_data.csv` |
| 9 | Mean beneficial-allele copies | `mutation_type_n` × `heat_resistant_mortality_modifier_n` | `Figure_9_source_data.csv` | `Figure_9_replicate_data.csv` |

Only experimental factors varying within each panel are retained as parameter columns; parameters fixed for that panel are not repeated in its CSVs.

## What the measurements mean

**Species proportions (stacked-bar panels).** For each simulation replicate and model year, the number of individuals of each species is divided by the combined number of *A. palmata*, *A. cervicornis*, and *A. prolifera* individuals in that replicate. These replicate-level proportions are then averaged by model year and experimental treatment. The bar panels report years **1, 250, 500, 750, and 1,000**. Values are fractions (0–1), although the plotted axes may display them as percentages.

**Heterospecific ancestry (line panels).** The per-replicate values describe the fraction of ancestry from the other parental species in each focal parental species. `cervicornis_ancestry_in_palmata` is *A. cervicornis* ancestry within *A. palmata*; `palmata_ancestry_in_cervicornis` is *A. palmata* ancestry within *A. cervicornis*. The `species` column in the corresponding source-data file identifies the **recipient/focal species**, not the ancestry donor. These trajectories span model years **1–1,000**.

**Beneficial-allele copies (Figures 6C, 8, and 9).** The simulation reports the mean number of copies of the modeled beneficial allele within each species for each replicate and model year. The figure-level CSVs summarize those replicate-level means. This is not the total number of allele copies summed over all individuals. Trajectories span model years **1–1,000**.

## Column definitions

The precise column set varies with the type of panel.

| Column | Definition |
|---|---|
| `Year` | Model year; annual observations are indexed 1–1,000. |
| `Rep` | Identifier of an independent simulation replicate within an experimental treatment. Present in replicate-data files only. |
| `species` | The modeled species associated with the row. |
| `species_proportion` | Proportion of the three-species total in one replicate (stacked-bar replicate data). |
| `mean_species_proportion` | Arithmetic mean of replicate-level species proportions. |
| `ancestry_measure` | Direction-specific variable identifying the ancestry donor and recipient in ancestry replicate data. |
| `heterospecific_ancestry` | Direction-specific ancestry fraction for one replicate. |
| `mean_heterospecific_ancestry` | Mean ancestry fraction across contributing replicates. |
| `beneficial_allele_copies` | Species-specific mean allele-copy value reported for one replicate. |
| `mean_beneficial_allele_copies` | Mean of the replicate-level beneficial-allele-copy values. |
| `two_sd` | Two times the sample standard deviation across simulation replicates, calculated separately for each treatment, year, and species/ancestry measurement. |
| `ribbon_lower`, `ribbon_upper` | Mean minus/plus `two_sd`, respectively; numerical coordinates underlying uncertainty ribbons. Bounds are not necessarily clipped to visible plotting limits. |
| `bar_segment_lower`, `bar_segment_upper` | Lower and upper coordinates of a species segment within a stacked bar. |
| `error_bar_lower_displayed`, `error_bar_upper_displayed` | Lower and upper coordinates of the error bar as drawn. Error bars are centered on the stacked segment and restricted to its boundaries. |
| `Total_palmata`, `Total_cervicornis`, `Total_prolifera` | Numbers of individuals of each species in that replicate and year; retained for Figures 8 and 9 to document presence/absence rules. |
| `mean_species_abundance` | Mean abundance across replicates of the species identified by `species`. |
| `min_total_prolifera` | Minimum *A. prolifera* abundance across contributing replicates at the corresponding treatment and year. |
| `displayed` | Whether the plotted mean and ribbon are shown after species-presence rules are applied. `FALSE` corresponds to a masked (missing) figure-level summary, not deletion of replicate observations. |

### Experimental-factor columns

`gamma_n` varies the gamma treatment; `cer_csp_n` varies the CSP treatment; `F2_success_scale_n` varies the F2-success scaling treatment; and `success_pro_n` varies the postzygotic-success treatment. `initial_palmata_n` is the initial fraction of *A. palmata*, `other_species_compete_n` is the niche-overlap/competition setting, `starting_number_n` is the initial population-number setting, and `heat_resistant_mortality_modifier_n` specifies the mortality-reduction treatment. These columns retain the numerical values used in the simulations; see the study Methods for their biological parameterization.

`mutation_type_n` specifies the mutation-inheritance treatment. The numerical values of the experimental factors correspond to those used in the study.

## Replicate structure and uncertainty

Each `Rep` is an independent stochastic simulation; individual corals within a replicate are **not** treated as independent replicates for the figure-level standard deviations. `two_sd` is a descriptive dispersion measure, **not** a standard error or a 95% confidence interval. Means and SDs are calculated from the nonmissing replicate values available for a given treatment, species/measure, and year.

For the beneficial-allele plots, a species may be intentionally omitted from the visualization when its abundance-based display condition is not met. In Figure 6C, the *A. prolifera* summary is masked whenever any contributing replicate has zero *A. prolifera* individuals. In Figures 8–9, the same *A. prolifera* condition applies, and any species with zero mean abundance is also masked. The `displayed`, abundance, and replicate-value columns document these decisions; **unmasked replicate-level values remain available** even where a line is not drawn.

These files contain analyzed figure data, not the full raw simulation outputs or complete records of all simulated individuals.
