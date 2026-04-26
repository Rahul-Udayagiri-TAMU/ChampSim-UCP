# ChampSim – UCP Cache Partitioning Project

This repository is a fork of the official ChampSim simulator and was used for a course project on shared LLC management and cache partitioning.

## Project Goal
Implement and evaluate a **UCP-style adaptive cache partitioning policy** in ChampSim, and compare it against:
- shared LLC with **LRU**
- **static way partitioning**

## Project Flow
1. Baseline shared LLC with LRU
2. Static way partitioning
3. Adaptive UCP-style partitioning with utility monitoring and periodic repartitioning
4. Single-core LLC sensitivity study
5. Two-core evaluation under 16-way and 8-way LLC settings

## Main Outcome
The study showed that adaptive partitioning helps most on workload pairs with clear differences in cache utility, while static partitioning can be competitive on some mixes.

Original ChampSim project: https://github.com/ChampSim/ChampSim
