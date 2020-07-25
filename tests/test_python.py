import momemta


def main():
    # Restrict logging to "error" level
    momemta.set_log_level(momemta.log_level.error)

    momemta_cfg = momemta.ConfigurationReader("path_to_config.lua")
    momemta_computer = momemta.MoMEMta(momemta_cfg.freeze())

    # px, py, pz, E
    p1 = [10, 20, 30, 200]
    p2 = [-10, 20, -30, 200]

    ## Using ROOT 4-vectors is also possible
    # import ROOT
    # LorentzVector = ROOT.Math.LorentzVector(ROOT.Math.PxPyPzE4D("double"))
    # p1 = LorentzVector(10, 20, 30, 200)
    # p2 = LorentzVector(-10, 20, -30, 200)

    result = momemta_computer.computeWeights([p1, p2])
    print(f"Weight: {result[0][0]} +- {result[0][1]}")


if __name__ == "__main__":
    main()
