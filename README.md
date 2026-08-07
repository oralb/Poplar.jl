# Poplar.jl

[![Build Status](https://github.com/junhyukjeon/Poplar.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/junhyukjeon/Poplar.jl/actions/workflows/CI.yml?query=branch%3Amaster)

## Overview

Poplar.jl is a comprehensive Julia package for modeling Poplar tree growth and development. It simulates physiological processes including photosynthesis, respiration, biomass allocation, and phenological development, integrated with environmental conditions and silvicultural management practices.

Built on top of the [Cropbox](https://github.com/cropbox/Cropbox.jl) modeling framework, Poplar.jl provides a systems-level approach to understand and predict Poplar tree performance under different environmental and management scenarios.

## Features

Poplar.jl includes modules for simulating:

- **Atmosphere**: Environmental conditions including temperature, radiation, and humidity
- **Calendar**: Time and phenological date tracking
- **Morphology**: Tree structural development and organ growth
- **Phenology**: Development stages and seasonal progression
- **Physiology**: Photosynthesis, respiration, and carbon allocation
- **Rhizosphere**: Root growth and soil water interactions
- **Silviculture**: Management practices and interventions
- **Configuration**: Model parameters and settings

## Installation

Add Poplar.jl to your Julia environment:

```julia
using Pkg
Pkg.add(url="https://github.com/junhyukjeon/Poplar.jl")
```

Or in the Pkg REPL:

```julia
pkg> add https://github.com/junhyukjeon/Poplar.jl
```

## Requirements

- Julia 1.0 or later
- [Cropbox](https://github.com/cropbox/Cropbox.jl) >= 0.3
- [CSV.jl](https://github.com/JuliaData/CSV.jl)
- [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)
- [TimeZones.jl](https://github.com/JuliaTime/TimeZones.jl)

## Basic Usage

```julia
using Poplar
using TimeZones

# Load weather data
weather = Poplar.loadwea(Poplar.datapath("2007.wea"), tz"Asia/Seoul")
CUH = Poplar.loadwea(Poplar.datapath("CUH.wea"), tz"America/Los_Angeles")

# Create and run a model
model = Poplar.Model(; weather=weather)
# Run simulations as needed
```

## Model Structure

The main `Model` system integrates the following components:
- Atmosphere
- Calendar
- Morphology
- Phenology
- Physiology
- Rhizosphere
- Silviculture
- Controller

Each component models specific aspects of Poplar tree physiology and environmental interactions.

## Documentation

For detailed documentation on individual modules and model parameters, refer to the source code in the `src/` directory. Each module contains detailed comments explaining the physiological processes being modeled.

## Data

Sample weather data files are included in the `data/` directory:
- `2007.wea`: Weather data for Asia/Seoul timezone
- `CUH.wea`: Weather data for America/Los_Angeles timezone

## License

Poplar.jl is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Developed by Jun Hyuk Jeon

## Citation

If you use Poplar.jl in your research, please cite it appropriately.

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/junhyukjeon/Poplar.jl).
