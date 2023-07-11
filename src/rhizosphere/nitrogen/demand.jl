@system NitrogenDemand begin
        # NITROGEN DEMAND CALCULATION

    # Nitrogen mobilization rate. Not sure what the numerical values represent.
    # NMOBR is mining rate as a fraction of the maximum rate, NMOBMX
    NMOBR(NVSMOD, NMOBMX, TDUMX) => begin
        NMOBMX * TDUMX2 * (1.0 + 0.5*(1.0 - SWFAC)) *
        (1.0 + 0.3 * (1.0 - NSTRES)) * (NVSMOB + (1 - NVSMOB) *
        max(XPOD, DXR57^2))
    end ~ track

    # Potential nitrogen mined. Nitrogen mobilization rate * N mined from each organ.
    # Get rid of shell?
    NMINEP(NMOBR, WNRLF, WNRST, WNRRT, WNRSH) => begin
        NMOBR * (WNRLF + WNRST + WNRRT + WNRSH)
    end

    C_demand_rep => 0 ~ preserve

    CAVTOT => 0 ~ preserve

    # Entire GPP will be dedicated to vegetative tissue because reproductive tissue
    # is not included in the model currently.
    C_demand_veg(GPP) => GPP ~ track

    

    # N demand for reproduction.
    # Reproduction is not a part of the model at the moment
    # so I am setting it as 0.
    NDMREP => 0 ~ preserve

    AGRVG => begin
        AGRLF * FRLF + AGRRT * FRRT + AGRSTEM * FRSTM + AGRSTR
    end ~ track

    AGRVG2 => begin
        AGRVG + (FRLF * PROLFI + FRRT * PRORTI + FRSTM * PROSTI)
    end ~ track

    NDMVEG = 

    # N required for vegetative growth.
    # CDMVEG / AGRVG2 is for conversion of CH2O mass to vegetative tissue mass.
    # 
    NDMVEG(CDMVEG, AGRVG2, FRML, FNINL, FRSTM, FNINS, FRRT, FNINR) => begin
        (CDMVEG / AGRVG2) * (FRLF * FNINL + FRSTM * FNINS + FRRT * FNINR)
    end ~ track

    # NDMREP is 0 currently so NDMNEW is the same as NDMVEG.
    NDMNEW(NDMREP, NDMVEG) => NDMREP + NDMVEG ~ track

    # Minimum leaf protein composition after N mining.
    PROLFF

    # CROPGRO has two different calculations based on phenological phase.
    # This model does not include reproductive phase at the moment and only uses one
    # calculation. In CROPGRO, nitrogen content is higher in the tissue during later stages
    # of the reproductive cycle.
    NVSTL(PROLFR) => PROLFR * 0.16 ~ track
    NVSTS(PROSTR) => PROSTR * 0.16 ~ track
    NVSTR(PRORTR) => PRORTR * 0.16 ~ track

    # storage tissue???
    NVSTSR(PROSSR) => PROSRF * 0.16 ~ track

    #

    # Available CH2O after reprductive growth
    # (so all CH2O because there is no reproductive growth at the moment)
    CNOLD(PGAVL, CDMREP) => begin
        PGAVL - CDMREP
    end(min=0)

    question_mark => CNOLD / RNO3C * 0.16 ~ track

    # Nitrogen demand for old tissue. Not sure where the value 0.16 comes from.
    NDMOLD(WTLF, SLDOT, WCRLF, PROLFR) => begin
        max(0, (WTLF - SLFDOR - WCRLF) * PROLFT * 0.16 - WTNST) +
        max(0, (STMWT - SDDOT - WCRST) * PROSTR * 0.16 - WTNST) +
        max(0, (STRWT - SSRDOT - WCRSR) * PROSSR * 0.16 - WTNSR)
    end(max=question_mark)

    # Total nitrogen demand.
    NDMTOT(NDMREP, NDMVEG, NDMOLD) => begin
        NDMREP + NDMVEG + NDMOLD
    end

    # Maximum fraction of N to leaf
    leaf_N_fraction_max

    # Maximum fraction of N to stem
    stem_N_fraction_max

    # Maximum fraction of N to root
    root_N_fraction_max

    # specific leaf area factor?
    # TPHFAC()
end