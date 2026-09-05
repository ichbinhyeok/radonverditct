param(
    [string]$OutputDirectory = "radon_md/reports/seo-acquisition-system-2026-09-05",
    [string]$AsOfDate = "2026-09-05"
)

$ErrorActionPreference = "Stop"
$resolvedOutput = Join-Path (Get-Location) $OutputDirectory
New-Item -ItemType Directory -Force -Path $resolvedOutput | Out-Null

$families = @(
    @{ Name="test-duration"; Journey="test-setup"; Volume="1K-10K"; Serp="government+inspectors"; Risk="medium"; Tier="A"; Target="/guides/short-term-vs-long-term-radon-test"; Queries=@("how long does a radon test take","how long is a radon test","radon test duration","how many days for radon test","48 hour radon test","how long to leave radon test kit","short term radon test length","long term radon test length","how long for radon test results","radon test turnaround time") },
    @{ Name="system-maintenance"; Journey="system-owner"; Volume="100-1K"; Serp="epa+contractors"; Risk="low"; Tier="A"; Target="/guides/radon-mitigation-system-maintenance"; Queries=@("radon mitigation system maintenance","radon system maintenance","radon system maintenance checklist","how to maintain radon mitigation system","does radon mitigation system need maintenance","radon system annual maintenance","radon mitigation inspection checklist","radon system service schedule","how often check radon system","radon mitigation upkeep") },
    @{ Name="manometer"; Journey="system-owner"; Volume="100-1K"; Serp="contractors+forums"; Risk="low"; Tier="A"; Target="/guides/radon-manometer-reading"; Queries=@("radon manometer reading","how to read radon manometer","radon manometer normal reading","radon manometer zero","radon manometer levels equal","radon u tube reading","what should radon manometer read","radon gauge reading","radon manometer changed","radon manometer fluid level") },
    @{ Name="fan-noise"; Journey="system-owner"; Volume="100-1K"; Serp="contractors+forums+video"; Risk="low"; Tier="A"; Target="/guides/radon-fan-noise"; Queries=@("radon fan noise","radon fan making noise","loud radon fan","radon fan humming","radon fan rattling","radon pipe gurgling","radon fan vibration","radon fan suddenly loud","is radon fan noise normal","radon mitigation fan noise in house") },
    @{ Name="fan-life"; Journey="system-owner"; Volume="100-1K"; Serp="epa+contractors"; Risk="low"; Tier="A"; Target="/guides/how-long-do-radon-fans-last"; Queries=@("how long do radon fans last","radon fan lifespan","radon mitigation fan life","when to replace radon fan","how often replace radon fan","radon fan warranty length","old radon fan","radon fan replacement signs","radon system lifespan","does radon mitigation system expire") },
    @{ Name="placement"; Journey="test-setup"; Volume="10-100"; Serp="government+manufacturers+forums"; Risk="low"; Tier="B"; Target="/guides/where-to-place-radon-test"; Queries=@("where to place radon test","where to put radon test kit","best place for radon detector","radon test basement or first floor","where to test radon in house","radon test placement height","can radon test sit on floor","radon detector placement bedroom","radon test lowest lived in level","where not to place radon test") },
    @{ Name="closed-house"; Journey="test-conditions"; Volume="10-100"; Serp="government+inspectors"; Risk="low"; Tier="B"; Target="/guides/radon-closed-house-conditions"; Queries=@("radon closed house conditions","closed house conditions radon test","12 hours before radon test","radon test windows closed","radon test doors closed","radon test hvac settings","can air conditioner run during radon test","ceiling fan during radon test","dehumidifier during radon test","whole house fan during radon test") },
    @{ Name="windows"; Journey="test-conditions"; Volume="0-100"; Serp="inspectors+forums"; Risk="low"; Tier="B"; Target="/guides/can-you-open-windows-during-radon-test"; Queries=@("can you open windows during radon test","window opened during radon test","how long windows closed before radon test","can windows be open before radon test","radon test with windows open","does opening windows affect radon test","door open during radon test","normal entry exit radon test","forgot to close windows radon test","will open window invalidate radon test") },
    @{ Name="occupancy"; Journey="test-conditions"; Volume="0-100"; Serp="inspectors+forums"; Risk="low"; Tier="B"; Target="/guides/can-you-live-in-house-during-radon-test"; Queries=@("can you live in house during radon test","can i stay home during radon test","can you sleep in house during radon test","what can you do during radon test","can i cook during radon test","can i shower during radon test","can pets stay during radon test","can people enter during radon test","normal living during radon test","do you leave house for radon test") },
    @{ Name="weather"; Journey="test-conditions"; Volume="0-100"; Serp="state-guides+forums"; Risk="medium"; Tier="B"; Target="/guides/radon-test-during-rain-or-storm"; Queries=@("radon test during rain","radon test during storm","does rain affect radon test","high winds during radon test","bad weather radon test","snow during radon test","severe weather radon testing","can you test radon when raining","weather affect radon readings","delay radon test for storm") },
    @{ Name="season"; Journey="test-setup"; Volume="10-100"; Serp="government+publishers"; Risk="medium"; Tier="B"; Target="/guides/best-time-of-year-to-test-for-radon"; Queries=@("best time of year to test for radon","best season for radon test","radon test winter or summer","can you test radon in summer","should i test radon in winter","seasonal radon levels","radon levels higher in winter","when should i test for radon","year round radon testing","cold weather radon test") },
    @{ Name="device-choice"; Journey="device-choice"; Volume="1K-10K"; Serp="publishers+manufacturers+shopping"; Risk="high"; Tier="B"; Target="/guides/charcoal-vs-digital-radon-test"; Queries=@("charcoal vs digital radon test","radon test kit vs monitor","radon detector vs test kit","digital radon monitor vs charcoal","short term kit vs continuous monitor","which radon test should i use","mail in radon test vs monitor","passive vs active radon test","alpha track vs digital radon monitor","reusable radon detector vs test kit") },
    @{ Name="expired-kit"; Journey="test-handling"; Volume="0-100"; Serp="labs+state-guides"; Risk="low"; Tier="B"; Target="/guides/expired-radon-test-kit"; Queries=@("expired radon test kit","can i use expired radon test kit","do radon test kits expire","radon kit expiration date","old radon test kit still good","expired charcoal radon test","radon test kit shelf life","unused radon kit expiration","radon test kit storage","replace expired radon kit") },
    @{ Name="moved-device"; Journey="test-handling"; Volume="0-100"; Serp="protocols+forums"; Risk="medium"; Tier="B"; Target="/guides/radon-test-moved-or-tampered"; Queries=@("radon test moved","radon test tampered with","device unplugged during radon test","radon monitor moved during test","radon test disturbed","covered radon test device","power outage during radon test","radon test interference","someone opened radon test","is moved radon test valid") },
    @{ Name="mail-kit"; Journey="test-handling"; Volume="0-100"; Serp="labs+local-programs"; Risk="low"; Tier="B"; Target="/guides/how-to-mail-radon-test-kit"; Queries=@("how to mail radon test kit","where to send radon test kit","radon test return shipping","how fast mail radon test","radon kit lab deadline","seal radon test kit","radon test kit postage","lost radon return envelope","track radon test kit shipment","radon lab turnaround after mailing") },
    @{ Name="apartment"; Journey="test-setup"; Volume="10-100"; Serp="government+renters"; Risk="medium"; Tier="B"; Target="/guides/radon-testing-in-apartments"; Queries=@("radon testing in apartments","how to test apartment for radon","radon detector in apartment","radon test high rise apartment","where to place radon test in apartment","can renters test for radon","landlord radon test","radon in basement apartment","radon test condo","lowest level within apartment unit") },
    @{ Name="validity"; Journey="test-handling"; Volume="100-1K"; Serp="labs+inspectors+forums"; Risk="medium"; Tier="B"; Target="/guides/is-my-radon-test-valid"; Queries=@("is my radon test valid","invalid radon test","radon test validity","what invalidates radon test","radon test quality control","radon test too short","radon test exposed too long","radon test wrong location","radon test conditions not met","should i redo radon test") },
    @{ Name="retest"; Journey="result"; Volume="100-1K"; Serp="epa+cdc+state-guides"; Risk="high"; Tier="B"; Target="/guides/when-to-retest-for-radon"; Queries=@("when to retest for radon","how often test for radon","should i retest radon","radon retest frequency","second radon test","confirm high radon result","retest after low radon result","retest radon after moving","retest radon after home changes","how soon can i retest radon") },
    @{ Name="after-renovation"; Journey="retest"; Volume="0-100"; Serp="cdc+contractors"; Risk="medium"; Tier="B"; Target="/guides/radon-test-after-renovation"; Queries=@("radon test after renovation","retest radon after remodel","radon after basement finishing","test radon after new windows","radon after hvac replacement","radon test before renovation","radon after waterproofing","radon after sump pump work","radon after air sealing","radon test after foundation repair") },
    @{ Name="after-mitigation"; Journey="system-owner"; Volume="0-100"; Serp="epa+standards+contractors"; Risk="high"; Tier="B"; Target="/guides/radon-test-after-mitigation"; Queries=@("radon test after mitigation","when to test after radon mitigation","post mitigation radon test","how soon retest after radon system installed","radon test after fan replacement","verify radon mitigation system","post mitigation test location","independent radon test after mitigation","radon still high after mitigation","retest after radon system repair") }
)

$queryRows = [System.Collections.Generic.List[object]]::new()
$queryId = 1
foreach ($family in $families) {
    foreach ($query in $family.Queries) {
        $queryRows.Add([pscustomobject]@{
            query_id = "Q{0:D3}" -f $queryId
            query = $query
            family = $family.Name
            journey = $family.Journey
            volume_band = $family.Volume
            serp_class = $family.Serp
            ymyl_risk = $family.Risk
            tier = $family.Tier
            target_url = $family.Target
            evidence = if ($family.Tier -eq "A") { "planner+serp-sample" } else { "serp-sample+workflow" }
        })
        $queryId++
    }
}

if ($queryRows.Count -ne 200) { throw "Expected 200 query rows, found $($queryRows.Count)." }
$queryRows | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $resolvedOutput "query-universe-200.csv")

$portfolioCsv = @'
priority,primary_query,target_url,action,release_gate,reason
1,how long does a radon test take,/guides/short-term-vs-long-term-radon-test,LIVE_NOW,index+impressions,largest winnable procedural band
2,radon mitigation system maintenance,/guides/radon-mitigation-system-maintenance,LIVE_NOW,index+impressions,high commercial-adjacent bid and weak mixed SERP
3,radon manometer reading,/guides/radon-manometer-reading,LIVE_NOW,index+impressions,specific task with thin contractor results
4,radon fan noise,/guides/radon-fan-noise,LIVE_NOW,index+impressions,forum-heavy SERP and legacy domain signal
5,how long do radon fans last,/guides/how-long-do-radon-fans-last,LIVE_NOW,index+impressions,confirmed demand and EPA source anchor
6,where to place radon test,/guides/where-to-place-radon-test,LIVE_SUPPORT,index+query-match,current GSC impressions
7,radon closed house conditions,/guides/radon-closed-house-conditions,LIVE_SUPPORT,index+query-match,protocol support
8,is my radon test valid,/guides/is-my-radon-test-valid,LIVE_SUPPORT,index+query-match,high-anxiety task fit
9,when to retest for radon,/guides/when-to-retest-for-radon,LIVE_SUPPORT,index+query-match,result bridge
10,radon test after mitigation,/guides/radon-test-after-mitigation,LIVE_SUPPORT,index+query-match,system-owner bridge
11,can you open windows during radon test,/guides/can-you-open-windows-during-radon-test,LIVE_SUPPORT,impressions in 60 days,zero-band support
12,can you live in house during radon test,/guides/can-you-live-in-house-during-radon-test,LIVE_SUPPORT,impressions in 60 days,zero-band support
13,radon test during rain,/guides/radon-test-during-rain-or-storm,LIVE_SUPPORT,impressions in 60 days,fragmented state guidance
14,best time of year to test for radon,/guides/best-time-of-year-to-test-for-radon,LIVE_SUPPORT,impressions in 60 days,seasonal question
15,charcoal vs digital radon test,/guides/charcoal-vs-digital-radon-test,LIVE_SUPPORT,impressions in 60 days,device-choice bridge without best claim
16,expired radon test kit,/guides/expired-radon-test-kit,LIVE_SUPPORT,impressions in 60 days,lab-specific task
17,radon test moved,/guides/radon-test-moved-or-tampered,LIVE_SUPPORT,impressions in 60 days,validity incident
18,how to mail radon test kit,/guides/how-to-mail-radon-test-kit,LIVE_SUPPORT,impressions in 60 days,completion task
19,radon testing in apartments,/guides/radon-testing-in-apartments,LIVE_SUPPORT,impressions in 60 days,narrow occupancy fit
20,radon test after renovation,/guides/radon-test-after-renovation,LIVE_SUPPORT,impressions in 60 days,CDC-backed retest trigger
21,how to test for radon at home,/guides/how-to-test-for-radon,LIVE_PILLAR,index+query-match,source-bounded five-step workflow implemented
22,radon test planner,/radon-test-planner,LIVE_TOOL,index+usage,protocol workflow moat
23,radon test results,/radon-test-result-meaning,LIVE_TOOL,index+usage,test-type and procedure-aware interpreter implemented
24,radon levels chart,/radon-test-result-meaning,MERGE_QUERY,no second URL,avoid result cannibalization
25,radon levels by county,/radon-levels,KEEP_HUB,12 county cohort healthy,official-data navigation only
26,radon monitor spikes,/guides/radon-monitor-spikes,BUILD_AFTER_SIGNAL,50 impressions in adjacent family,forum-heavy unmet task
27,two radon tests different results,/guides/two-radon-tests-disagree,BUILD_AFTER_SIGNAL,50 impressions in adjacent family,measurement uncertainty workflow
28,radon fan stopped working,/guides/radon-fan-stopped,BUILD_AFTER_SIGNAL,maintenance cluster top20,safety-bounded task
29,radon system alarm,/guides/radon-system-alarm,BUILD_AFTER_SIGNAL,maintenance cluster top20,clear incident intent
30,radon pipe gurgling,/guides/radon-fan-noise,MERGE_QUERY,no separate URL,noise page already handles it
31,radon manometer fluid level,/guides/radon-manometer-reading,MERGE_QUERY,no separate URL,baseline page handles it
32,radon fan replacement cost,/guides/radon-fan-replacement-cost,BUILD_AFTER_SIGNAL,fan-life top20,commercial adjacent
33,radon test basement or first floor,/guides/where-to-place-radon-test,MERGE_QUERY,no separate URL,placement decision branch
34,hvac during radon test,/guides/radon-closed-house-conditions,MERGE_QUERY,no separate URL,closed-house subquestion
35,dehumidifier during radon test,/guides/radon-closed-house-conditions,MERGE_QUERY,no separate URL,avoid thin page
36,radon test kit vs monitor,/guides/charcoal-vs-digital-radon-test,MERGE_QUERY,no second URL,device choice canonical
37,best radon test kit,/guides/best-radon-test-kit,HOLD,hands-on evidence required,do not fake product testing
38,radon detector,/guides/radon-detector,HOLD,authority and product evidence required,head term too difficult now
39,radon mitigation cost,/radon-mitigation-cost,HOLD,defensible model required,retired estimates cannot return unchanged
40,radon mitigation services near me,/radon-mitigation-services,HOLD,provider inventory required,service intent cannot be met
'@
$portfolioPath = Join-Path $resolvedOutput "page-portfolio-40.csv"
$portfolioCsv.Trim() | Set-Content -Encoding utf8 $portfolioPath

$countyEvidence = @(
    "florida/marion-county","new-jersey/gloucester-county","pennsylvania/indiana-county",
    "vermont/rutland-county","new-york/ulster-county","new-york/schenectady-county",
    "idaho/fremont-county","virginia/falls-church-city","virginia/powhatan-county",
    "colorado/broomfield-county","new-mexico/bernalillo-county","california/los-angeles-county"
)
$countyEvidenceSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$countyEvidence)
$counties = Get-Content -Raw "src/main/resources/data/geo_counties.json" | ConvertFrom-Json
$migrationRows = [System.Collections.Generic.List[object]]::new()
foreach ($county in $counties) {
    $key = "$($county.state_slug)/$($county.county_slug)"
    $keepLevels = $countyEvidenceSet.Contains($key)
    $migrationRows.Add([pscustomobject]@{
        source_url = "/radon-levels/$key"
        disposition = if ($keepLevels) { "KEEP_200" } else { "GONE_410" }
        target_url = if ($keepLevels) { "/radon-levels/$key" } else { "" }
        reason = if ($keepLevels) { "controlled evidence cohort" } else { "no unique search evidence in controlled cohort" }
    })
    $migrationRows.Add([pscustomobject]@{
        source_url = "/radon-mitigation-cost/$key"
        disposition = "GONE_410"
        target_url = ""
        reason = "modeled local cost surface retired"
    })
}
foreach ($stateSlug in ($counties.state_slug | Sort-Object -Unique)) {
    $migrationRows.Add([pscustomobject]@{source_url="/radon-levels/$stateSlug";disposition="GONE_410";target_url="";reason="state hub retired"})
    $migrationRows.Add([pscustomobject]@{source_url="/radon-mitigation-cost/$stateSlug";disposition="GONE_410";target_url="";reason="modeled state cost hub retired"})
}
$migrationRows.Add([pscustomobject]@{source_url="/guides/radon-fan-noise-troubleshooting";disposition="REDIRECT_301";target_url="/guides/radon-fan-noise";reason="same intent and safer replacement"})
$migrationRows.Add([pscustomobject]@{source_url="/client-action-plan";disposition="REDIRECT_301";target_url="/plan";reason="canonical product path"})
$migrationRows | Sort-Object source_url | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $resolvedOutput "legacy-url-migration-manifest.csv")

$summary = [pscustomobject]@{
    generated_at = $AsOfDate
    query_count = $queryRows.Count
    family_count = $families.Count
    portfolio_count = (Import-Csv $portfolioPath).Count
    legacy_route_count = $migrationRows.Count
    keep_200_count = ($migrationRows | Where-Object disposition -eq "KEEP_200").Count
    redirect_301_count = ($migrationRows | Where-Object disposition -eq "REDIRECT_301").Count
    gone_410_count = ($migrationRows | Where-Object disposition -eq "GONE_410").Count
}
$summary | ConvertTo-Json | Set-Content -Encoding utf8 (Join-Path $resolvedOutput "generation-summary.json")
$summary
