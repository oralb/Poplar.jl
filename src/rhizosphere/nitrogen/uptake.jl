# N_demand_total is required.
@system NitrogenUptake begin

    

    # scale down uptake if not enough CH2O
    CH2O_uptake

    # PARAMETERS

    # Nitrate uptake per unit root length
    NO3_per_length ~ preserve(parameter)

    # Ammonium uptake per unit root length
    NO4_per_length ~ preserve(parameter)


    RNO3C ~ preserve

    RNH4C ~ preserve

    # I have no idea what BD is
    FAC => 10 / (BD * DLAYR) ~ preserve

    NO3_extractable(NO3_soil, FAC) => NO3_soil / FAC ~ track

    NH4_extractable(NH4_soil, FAC) => NH4_soil / FAC ~ track

    # The N_senescence should go into N_demand calculation in the first place?
    N_demand_crop(N_demand_total, N_senescence) => begin
        N_demand_total - N_senescence * 10 # Why * 10?
    end(max=N_uptake_total)

    # Potential NH4 availability factor from CROPGRO.
    # Not sure why 0.04 and below is 0.
    NH4_factor(NH4) => begin
        f = 1 - exp(-0.08 * NH4)
        f < 0.04 ? 0 : f
    end ~ track(max=1)

    # Poptential NO3 availability factor from CROPGRO.
    # Not sure why 0.04 and below is 0.
    NO3_factor(NO3) => begin
        f = 1 - exp(-0.08 * NH4)
        f < 0.04 ? 0 : f
    end ~ track(max=1)

    # Relative drought factor from CROPGRO. Used for N_uptake_conversion_factor.
    # Not sure why minimum is 0.1.
    drought_factor(ASW, min_ASW, field_capacity) => begin
        if ASW > field_capacity
            2.0 - (ASW - field_capacity) / (max_ASW - field_capacity)
        else
            2*((ASW - min_ASW) / (field_capacity - min_ASW))
        end
    end ~ track(min=0, max=1) 

    # Nitrogen uptake conversion factor.
    # How much kg/ha of nitrogen for mg/cm of nitrogen (root)?
    N_uptake_conversion_factor(RLV, drought_factor, soil_depth) => begin
        RLV * sqrt(drought_factor) * soil_depth
    end ~ track

    # Nitrate uptake potential
    NO3_uptake_potential(N_uptake_conversion_factor, NO3_factor, RTNO3) => begin
        N_uptake_conversion_factor * NO3_factor * RTNO3
    end(min=0)

    # Ammonium uptake potential
    NH4_uptake_potential(N_uptake_conversion_factor, NH4_factor, RTNH4) => begin
        N_uptake_conversion_factor * NH4_factor * RTNH4
    end(min=0)

    # Total nitrogen uptake potential in a day
    N_uptake_potential(NO3_uptake_potential, NH4_uptake_potential) => begin
        NO3_uptake_potential + NH4_uptake_potential
    end

    NO3_respiration_cost(NO3_uptake_potential) => begin
        (NO3_uptake_potential/10) / 0.16 * RNO3C
        # Why divide by 10?
    end

    NH4_respiration_cost(NH4_uptake_potential) => begin
        (NH4_uptake_potential/10) / 0.16 * RNH4C
        # Why divide by 10?
    end

    # Demand vs. uptake fraction.
    # Max set to 1 as nitrogen uptake cannot be greater than what is available.
    N_uptake_fraction(N_demand, N_uptake_potential) => begin
        N_demand / N_uptake_potential
    end ~ track(max=1)

    # Actual NO3 uptake based on N uptake fraction.
    NO3_uptake(NO3_uptake_potential, N_uptake_fraction) => begin
        NO3_uptake_potential * N_uptake_fraction
    end ~ track(max=NO3_up_max)

    # Actual NO3 uptake based on N uptake fraction.
    NH4_uptake(NH4_uptake_potential, N_uptake_fraction) => begin
        NH4_uptake_potential * N_uptake_fraction
    end ~ track(max=NH4_up_max)

    # Amount of NO3 that stays in soil
    NO3_min(KG2PPM) => 0.25 / KG2PPM ~ preserve(parameter)

    # Minimum NH4 uptake from soil
    NO3_up_max(NO3_soil, NO3_min) => NO3 - NO3_min ~ preserve(parameter)

    # Amount of NH4 that stays in soil
    NH4_min(KG2PPM) => 0.5 / KG2PPM

    # Maximum NH4 uptake from soil
    NH4_up_max(NH4_soil, NH4_min) => NH4 - NH4_min ~ preserve(parameter)

    # Total extractable ammonium in soil
    NH4_soil

    # Total extractable nitrate in soil
    NO3_soil


    N_uptake_total => begin
        NO3_uptake + NH4_uptake
    end
    
end