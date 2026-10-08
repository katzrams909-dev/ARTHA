# ARTHA v2 P08 — Setup Quality Validation

Target: `pine/v2/ARTHA_V2_P08_Setup_Quality_Scoring.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P07 eligibility behavior remains unchanged.

## Eligibility independence

- [ ] REV eligible count is unchanged versus P07 on identical settings/data.
- [ ] CONT eligible count is unchanged versus P07.
- [ ] a low quality score does not suppress an eligible marker.
- [ ] changing grade thresholds does not change setup eligibility.

## Score bounds

For every scored setup:

- [ ] total is 0–100;
- [ ] displacement is 0–30;
- [ ] structure is 0–20;
- [ ] POI is 0–20;
- [ ] mitigation is 0–15;
- [ ] context is 0–15;
- [ ] displayed total equals component sum.

## REV scoring

Compare examples with different liquidity tiers:

- [ ] Tier 1 receives 15 context points;
- [ ] Tier 2 receives 12;
- [ ] Tier 3 receives 8;
- [ ] Tier 4 receives 4.

Compare internal/external CHoCH/MSS examples and verify structure points.

## CONT scoring

- [ ] external BOS receives 20 structural points;
- [ ] internal BOS receives 15;
- [ ] aligned internal + external trend receives 15 context points;
- [ ] external-only alignment receives 11.

## POI scoring

- [ ] OB/BB = 20;
- [ ] FVG/IFVG structural provenance bonus is applied correctly;
- [ ] active bound POI mitigation is used at the eligibility bar.

## Grades

With default thresholds:

- [ ] >=85 = A;
- [ ] 75–84 = B;
- [ ] 65–74 = C;
- [ ] <65 = D.

## Reload stability

After chart reload:

- [ ] eligibility bars are unchanged from P07;
- [ ] quality totals and grades remain on the same historical events;
- [ ] breakdown components remain identical.

## Exit gate

Do not add a minimum-score eligibility gate.

After P08 is validated, the next layer may consume score as ranking/context while preserving the binary eligibility contract.
