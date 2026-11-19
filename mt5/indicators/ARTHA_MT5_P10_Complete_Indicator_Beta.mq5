//+------------------------------------------------------------------+
//| ARTHA MT5 P10 - integrated indicator beta           |
//| Port reference: ARTHA TV P17.27.14.14 / 14.14N (2026-11-16)       |
//| IMPORTANT: P10 displays simulated plans, never sends orders.        |
//+------------------------------------------------------------------+
#property copyright "ARTHA"
#property version   "1.00"
#property strict
#property description "ARTHA MT5 P10 BETA: integrated structure, POIs, entries, targets, and visual trade plans. No automated orders."
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_label1  "ARTHA core"
#property indicator_type1   DRAW_NONE

enum ARTHA_DISP_MODE
{
   ARTHA_DISP_BODY_ONLY=0,
   ARTHA_DISP_BALANCED=1,
   ARTHA_DISP_STRICT=2
};

enum ARTHA_FVG_FILTER
{
   ARTHA_FVG_ALL=0,
   ARTHA_FVG_DISPLACEMENT=1,
   ARTHA_FVG_STRUCTURAL=2
};

enum ARTHA_CONFIRM_RULE
{
   ARTHA_FAVORABLE_HALF=0,
   ARTHA_BOUNDARY_RECLAIM=1,
   ARTHA_DIRECTIONAL_INSIDE=2
};

input group "01  Global"
input string InpInstanceId              = "A";    // Use a different ID for each copy on one chart
input int    InpHistoryBars             = 1200;   // Initial closed-bar history

input group "02  Confirmed structure"
input int    InpInternalPivotStrength   = 2;
input int    InpExternalPivotStrength   = 5;
input bool   InpRequireCloseBreak       = true;
input bool   InpShowInternalBreaks      = false;
input bool   InpShowExternalBreaks      = true;
input int    InpMaxStructureObjects     = 80;
input color  InpBullStructureColor      = clrLimeGreen;
input color  InpBearStructureColor      = clrTomato;

input group "02A  Liquidity sources"
input bool   InpUseInternalSwingLiq     = true;
input bool   InpUseExternalSwingLiq     = true;
input bool   InpUsePreviousDayHL        = true;
input bool   InpUsePreviousWeekHL       = true;
input bool   InpUsePreviousMonthHL      = true;
input double InpLiquidityToleranceATR   = 0.10;
input int    InpMaxLiquidityRecords     = 140;

input group "03  Displacement episodes"
input ARTHA_DISP_MODE InpDisplacementMode = ARTHA_DISP_BALANCED;
input double InpMinDispBodyATR          = 0.60;
input double InpMinDispRangeATR         = 0.90;
input double InpMinDispBodyPct          = 0.55;
input double InpMinDispCloseLocation    = 0.70;
input double InpMinBodyVsAverage        = 1.25;
input double InpMinRangeVsAverage       = 1.10;
input int    InpMinDisplacementScore    = 60;
input int    InpRelativeLookback        = 20;
input bool   InpRequirePriorRangeClose = true;
input bool   InpEnableFollowThrough    = true;
input int    InpEpisodeGapBars          = 1;
input int    InpEpisodeMaxBars          = 8;
input int    InpMaxEpisodeArchive       = 80;
input int    InpFVGProvenanceWindow     = 2;

input group "04  FVG / mitigation geometry"
input double InpMinFVGSizeATR           = 0.10;
input ARTHA_FVG_FILTER InpFVGCreationMode = ARTHA_FVG_DISPLACEMENT;
input int    InpMaxZones                = 50;
input bool   InpRetireOnFullWickFill    = true;
input bool   InpShowFVG                 = true;
input bool   InpFillFVG                 = false;  // Outlines keep candles readable
input color  InpBullFVGColor            = clrDarkSlateGray;
input color  InpBearFVGColor            = clrMaroon;
input color  InpRetiredFVGColor         = clrDimGray;

input group "05  Inversions and order blocks"
input bool   InpEnableIFVG              = true;
input bool   InpEnableOB                = true;
input bool   InpEnableBreakers          = true;
input int    InpOBSearchBars            = 8;
input bool   InpOBBodyOnly              = false;
input color  InpBullOBColor             = clrForestGreen;
input color  InpBearOBColor             = clrFireBrick;
input color  InpInversionColor          = clrMediumPurple;

input group "06  Entries and qualification"
input bool   InpEnableREV               = true;
input bool   InpEnableCONT              = true;
input bool   InpEnableEARLY             = true;
input bool   InpEnableConfirmed         = true;
input bool   InpEnableMIT               = true;
input bool   InpEnableMISS              = true;
input bool   InpEnableOTE               = true;
input int    InpMitigationPct           = 50;
input int    InpEarlyMitigationPct      = 25;
input int    InpNormalMitigationPct     = 50;
input int    InpConfirmWindowBars       = 5;
input ARTHA_CONFIRM_RULE InpMitConfirm = ARTHA_FAVORABLE_HALF;
input int    InpMinREVScore             = 75;
input int    InpMinCONTScore            = 75;
input int    InpMinEARLYScore           = 65;
input int    InpRecentBreakBars         = 15;
input int    InpRecentSweepBars         = 12;
input int    InpOTERecentBars           = 5;
input double InpOTELowRatio             = 0.62;
input double InpOTEHighRatio            = 0.79;

input group "07  Risk, targets and trade drawings"
input double InpStopBufferATR           = 0.10;
input double InpMaxStopATR              = 3.00;
input double InpTP1R                    = 1.00;
input double InpTP2R                    = 2.00;
input bool   InpShowLiquidityTP3TP4     = true;
input bool   InpShowPlans               = true;
input bool   InpShowDashboard           = true;
input bool   InpAlertOnNewSignals       = false; // Live closed bars only
input bool   InpPushOnNewSignals        = false; // Requires terminal notification setup
input int    InpMaxPlans                = 30;
input int    InpMaxSignalObjects        = 90;
input color  InpBuyRewardColor          = C'0,188,212';
input color  InpSellRewardColor         = C'156,39,176';
input color  InpRiskColor               = clrGray;
input color  InpBuySignalColor          = clrLimeGreen;
input color  InpSellSignalColor         = clrTomato;

// Output buffer intentionally has no plot. All visuals are native chart objects.
double g_hiddenBuffer[];
int    g_atrHandle       = INVALID_HANDLE;
string g_prefix          = "";
datetime g_lastClosedBar = 0;
int    g_nextZoneId      = 1;
int    g_internalTrend   = 0;
int    g_externalTrend   = 0;
int    g_barOrdinal      = 0;
int    g_nextEpisodeId   = 1;
bool   g_episodeActive   = false;

struct ArthaSwing
{
   double   price;
   datetime at;
   bool     valid;
   bool     broken;
};

struct ArthaFVG
{
   int      id;
   int      direction;  // +1 demand, -1 supply
   double   top;
   double   bottom;
   double   maxMitigationPct;
   datetime born;
   datetime firstTouch;
   bool     retired;
   int      episodeId;
   int      provenanceScore;
   bool     structureLinked;
   bool     primary;
   int      bornOrdinal;
   double   gapATR;
   string   originKind;    // FVG or OB; active flips become IFVG or BB
   int      state;         // 0 native, 1 inverse, 2 retired
   int      firstTouchOrdinal;
   int      lastSignalOrdinal;
   int      maxDepthOrdinal;
   int      retirementOrdinal;
};

struct ArthaEpisode
{
   int      id;
   int      direction;
   int      firstOrdinal;
   int      lastEventOrdinal;
   int      peakOrdinal;
   int      peakScore;
   int      eventCount;
   bool     structureLinked;
};

struct ArthaLiquidity
{
   int      id;
   int      side;           // +1 buy-side high, -1 sell-side low
   int      tier;
   double   price;
   datetime born;
   int      bornOrdinal;
   bool     active;
};

struct ArthaPlan
{
   int      id;
   int      poiId;
   int      direction;
   int      ordinal;
   datetime born;
   string   family;
   string   source;
   string   poiKind;
   int      quality;
   double   entry;
   double   stop;
   double   tp1;
   double   tp2;
   double   tp3;
   double   tp4;
   bool     hasTP3;
   bool     hasTP4;
   int      stage;
   int      state;          // 0 open, 1 target completed, 2 stop reached
   datetime closed;
};

ArthaSwing g_internalHigh, g_internalLow, g_externalHigh, g_externalLow;
ArthaFVG   g_zones[];
string     g_structureObjects[];
ArthaEpisode g_activeEpisode;
ArthaEpisode g_episodeArchive[];
ArthaLiquidity g_liquidity[];
ArthaPlan g_plans[];
string g_signalObjectNames[];
int g_nextLiquidityId=1;
int g_nextPlanId=1;
int g_lastBullBreakOrdinal=-100000;
int g_lastBearBreakOrdinal=-100000;
int g_lastBullShiftOrdinal=-100000;
int g_lastBearShiftOrdinal=-100000;
int g_lastBuySweepOrdinal=-100000;
int g_lastSellSweepOrdinal=-100000;
int g_lastOTEOrdinal=-100000;
int g_totalSignals=0;
bool g_allowLiveAlerts=false;
datetime g_lastPDTime=0;
datetime g_lastPWTime=0;
datetime g_lastPMTime=0;

string ZoneName(const int id)
{
   return g_prefix + "POI_" + IntegerToString(id);
}

string CurrentPOIKind(const ArthaFVG &z)
{
   if(z.originKind=="OB")
      return z.state==1?"BB":"OB";
   return z.state==1?"IFVG":"FVG";
}

color CurrentPOIColor(const ArthaFVG &z)
{
   if(z.state==2)
      return InpRetiredFVGColor;
   if(z.state==1)
      return InpInversionColor;
   if(z.originKind=="OB")
      return z.direction==1?InpBullOBColor:InpBearOBColor;
   return z.direction==1?InpBullFVGColor:InpBearFVGColor;
}

void ResetCore()
{
   if(StringLen(g_prefix)>0)
      ObjectsDeleteAll(0, g_prefix);
   ArrayResize(g_zones, 0);
   ArrayResize(g_structureObjects, 0);
   ArrayResize(g_episodeArchive,0);
   ArrayResize(g_liquidity,0);
   ArrayResize(g_plans,0);
   ArrayResize(g_signalObjectNames,0);
   g_nextLiquidityId=1;
   g_nextPlanId=1;
   g_lastBullBreakOrdinal=-100000;
   g_lastBearBreakOrdinal=-100000;
   g_lastBullShiftOrdinal=-100000;
   g_lastBearShiftOrdinal=-100000;
   g_lastBuySweepOrdinal=-100000;
   g_lastSellSweepOrdinal=-100000;
   g_lastOTEOrdinal=-100000;
   g_totalSignals=0;
   g_allowLiveAlerts=false;
   g_lastPDTime=0;
   g_lastPWTime=0;
   g_lastPMTime=0;
   g_barOrdinal    = 0;
   g_nextEpisodeId = 1;
   g_episodeActive = false;
   g_nextZoneId    = 1;
   g_internalTrend = 0;
   g_externalTrend = 0;
   g_lastClosedBar = 0;

   g_internalHigh.valid = false;
   g_internalLow.valid  = false;
   g_externalHigh.valid = false;
   g_externalLow.valid  = false;
   g_internalHigh.broken = false;
   g_internalLow.broken  = false;
   g_externalHigh.broken = false;
   g_externalLow.broken  = false;
}

bool IsPivotHigh(const double &prices[], const int center,
                 const int strength, const int total)
{
   if(center-strength < 1 || center+strength >= total)
      return false;
   for(int k=1; k<=strength; ++k)
      if(prices[center] <= prices[center-k] ||
         prices[center] <  prices[center+k])
         return false;
   return true;
}

bool IsPivotLow(const double &prices[], const int center,
                const int strength, const int total)
{
   if(center-strength < 1 || center+strength >= total)
      return false;
   for(int k=1; k<=strength; ++k)
      if(prices[center] >= prices[center-k] ||
         prices[center] >  prices[center+k])
         return false;
   return true;
}

void NewSwing(ArthaSwing &s, const double price, const datetime at)
{
   s.price  = price;
   s.at     = at;
   s.valid  = true;
   s.broken = false;
}

void TrackStructureObject(const string name)
{
   int n=ArraySize(g_structureObjects);
   if(n>=InpMaxStructureObjects)
   {
      ObjectDelete(0,g_structureObjects[0]);
      for(int i=1; i<n; ++i)
         g_structureObjects[i-1]=g_structureObjects[i];
      ArrayResize(g_structureObjects,n-1);
      n--;
   }
   ArrayResize(g_structureObjects,n+1);
   g_structureObjects[n]=name;
}

void DrawStructureBreak(const string scope, const int direction,
                        const string kind, const datetime swingTime,
                        const datetime eventTime, const double price)
{
   bool show=(scope=="X" ? InpShowExternalBreaks : InpShowInternalBreaks);
   if(!show)
      return;
   string name=g_prefix+"STR_"+scope+"_"+IntegerToString((long)eventTime)+"_"+
               (direction==1?"UP":"DN");
   if(!ObjectCreate(0,name,OBJ_TREND,0,swingTime,price,eventTime,price))
      return;
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_COLOR,
                    direction==1?InpBullStructureColor:InpBearStructureColor);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,scope+" "+kind+" (confirmed close)");
   TrackStructureObject(name);
}

bool CheckBreak(ArthaSwing &s, int &trend, const string scope,
                const int direction, const int shift,
                const datetime &times[], const double &closes[],
                const double &highs[], const double &lows[])
{
   if(!s.valid || s.broken)
      return false;
   bool broke=(direction==1 ?
               (InpRequireCloseBreak ? closes[shift]>s.price : highs[shift]>s.price) :
               (InpRequireCloseBreak ? closes[shift]<s.price : lows[shift]<s.price));
   if(!broke)
      return false;

   // A reversal is a CHoCH here; the Pine MSS/displacement distinction is pending.
   string kind=(trend!=0 && trend!=direction) ? "CHoCH" : "BOS";
   DrawStructureBreak(scope,direction,kind,s.at,times[shift],s.price);
   trend=direction;
   s.broken=true;
   return true;
}

int ArthaRamp(const double value,const double floorValue,
              const double targetValue,const int points)
{
   if(targetValue<=floorValue)
      return (value>=floorValue?points:0);
   if(value<floorValue)
      return 0;
   double progress=MathMin(1.0,(value-floorValue)/(targetValue-floorValue));
   return (int)MathRound(points*(0.50+0.50*progress));
}

// Displacement is causal: all comparisons and averages reference closed bars.
int EvaluateDisplacement(const int shift,const int total,const bool bullish,
                         const double &opens[],const double &highs[],
                         const double &lows[],const double &closes[],
                         const double &atr[],bool &qualified)
{
   qualified=false;
   if(shift+InpRelativeLookback+1>=total ||
      atr[shift]<=0.0 || atr[shift]==EMPTY_VALUE)
      return 0;

   double body=MathAbs(closes[shift]-opens[shift]);
   double range=MathMax(highs[shift]-lows[shift],_Point);
   bool directional=(bullish?closes[shift]>opens[shift]:
                             closes[shift]<opens[shift]);
   if(!directional)
      return 0;
   double bodyATR=body/atr[shift];
   double rangeATR=range/atr[shift];
   double efficiency=body/range;
   double location=(bullish?closes[shift]-lows[shift]:
                             highs[shift]-closes[shift])/range;

   double avgBody=0.0,avgRange=0.0;
   for(int k=shift+1;k<=shift+InpRelativeLookback;++k)
   {
      avgBody+=MathAbs(closes[k]-opens[k]);
      avgRange+=MathMax(highs[k]-lows[k],_Point);
   }
   avgBody/=InpRelativeLookback;
   avgRange/=InpRelativeLookback;
   double bodyRelative=avgBody>0.0?body/avgBody:0.0;
   double rangeRelative=avgRange>0.0?range/avgRange:0.0;

   bool priorRange=(!InpRequirePriorRangeClose) ||
                   (bullish?closes[shift]>highs[shift+1]:
                            closes[shift]<lows[shift+1]);
   bool follow=InpEnableFollowThrough &&
      (bullish?closes[shift+1]>opens[shift+1]:
               closes[shift+1]<opens[shift+1]) &&
      (bullish?closes[shift]>highs[shift+1]:
               closes[shift]<lows[shift+1]);

   int score=0;
   score+=ArthaRamp(bodyATR,InpMinDispBodyATR,
                    MathMax(InpMinDispBodyATR*1.75,InpMinDispBodyATR+0.40),25);
   score+=ArthaRamp(rangeATR,InpMinDispRangeATR,
                    MathMax(InpMinDispRangeATR*1.60,InpMinDispRangeATR+0.50),15);
   score+=ArthaRamp(efficiency,InpMinDispBodyPct,
                    MathMin(0.90,InpMinDispBodyPct+0.25),15);
   score+=ArthaRamp(location,InpMinDispCloseLocation,
                    MathMin(0.98,InpMinDispCloseLocation+0.20),15);
   score+=ArthaRamp(bodyRelative,InpMinBodyVsAverage,
                    InpMinBodyVsAverage+0.75,15);
   score+=ArthaRamp(rangeRelative,InpMinRangeVsAverage,
                    InpMinRangeVsAverage+0.60,10);
   if(follow)
      score+=5;
   score=(int)MathMin(100,score);

   if(InpDisplacementMode==ARTHA_DISP_BODY_ONLY)
      qualified=(bodyATR>=InpMinDispBodyATR);
   else if(InpDisplacementMode==ARTHA_DISP_STRICT)
      qualified=(bodyATR>=InpMinDispBodyATR*1.20 &&
         rangeATR>=InpMinDispRangeATR &&
         efficiency>=MathMin(0.95,InpMinDispBodyPct+0.05) &&
         location>=MathMin(0.99,InpMinDispCloseLocation+0.05) &&
         bodyRelative>=InpMinBodyVsAverage+0.15 &&
         rangeRelative>=InpMinRangeVsAverage+0.15 && priorRange &&
         score>=MathMax(InpMinDisplacementScore,75));
   else
      qualified=(bodyATR>=InpMinDispBodyATR &&
         rangeATR>=InpMinDispRangeATR*0.85 &&
         efficiency>=InpMinDispBodyPct &&
         location>=InpMinDispCloseLocation &&
         bodyRelative>=InpMinBodyVsAverage &&
         rangeRelative>=InpMinRangeVsAverage && priorRange &&
         score>=InpMinDisplacementScore);

   return score;
}

void ArchiveCurrentEpisode()
{
   if(!g_episodeActive)
      return;
   int n=ArraySize(g_episodeArchive);
   if(n>=InpMaxEpisodeArchive)
   {
      for(int i=1;i<n;++i)
         g_episodeArchive[i-1]=g_episodeArchive[i];
      ArrayResize(g_episodeArchive,n-1);
      n--;
   }
   ArrayResize(g_episodeArchive,n+1);
   g_episodeArchive[n]=g_activeEpisode;
   g_episodeActive=false;
}

void AdvanceEpisode(const int direction,const int score,
                    const bool bullBreak,const bool bearBreak)
{
   int ordinal=g_barOrdinal;
   if(g_episodeActive)
   {
      bool expired=(ordinal-g_activeEpisode.lastEventOrdinal>
                    InpEpisodeGapBars+1);
      bool tooLong=(ordinal-g_activeEpisode.firstOrdinal>=InpEpisodeMaxBars);
      bool opposite=(direction!=0 && direction!=g_activeEpisode.direction);
      if(expired || tooLong || opposite)
         ArchiveCurrentEpisode();
   }
   if(direction!=0)
   {
      if(!g_episodeActive)
      {
         g_activeEpisode.id=g_nextEpisodeId++;
         g_activeEpisode.direction=direction;
         g_activeEpisode.firstOrdinal=ordinal;
         g_activeEpisode.lastEventOrdinal=ordinal;
         g_activeEpisode.peakOrdinal=ordinal;
         g_activeEpisode.peakScore=score;
         g_activeEpisode.eventCount=1;
         g_activeEpisode.structureLinked=false;
         g_episodeActive=true;
      }
      else
      {
         g_activeEpisode.lastEventOrdinal=ordinal;
         g_activeEpisode.eventCount++;
         if(score>g_activeEpisode.peakScore)
         {
            g_activeEpisode.peakScore=score;
            g_activeEpisode.peakOrdinal=ordinal;
         }
      }
   }
   if(g_episodeActive &&
      (g_activeEpisode.direction==1?bullBreak:bearBreak))
      g_activeEpisode.structureLinked=true;
}

void FindEpisode(const int direction,const int ordinal,
                 int &episodeId,int &peakScore,bool &structureLinked,
                 int &peakOrdinal)
{
   episodeId=0;
   peakScore=0;
   structureLinked=false;
   peakOrdinal=ordinal;
   if(g_episodeActive &&
      g_activeEpisode.direction==direction &&
      ordinal-g_activeEpisode.lastEventOrdinal<=InpFVGProvenanceWindow)
   {
      episodeId=g_activeEpisode.id;
      peakScore=g_activeEpisode.peakScore;
      structureLinked=g_activeEpisode.structureLinked;
      peakOrdinal=g_activeEpisode.peakOrdinal;
      return;
   }
   for(int i=ArraySize(g_episodeArchive)-1;i>=0;--i)
   {
      ArthaEpisode e=g_episodeArchive[i];
      if(e.direction==direction &&
         ordinal-e.lastEventOrdinal<=InpFVGProvenanceWindow)
      {
         episodeId=e.id;
         peakScore=e.peakScore;
         structureLinked=e.structureLinked;
         peakOrdinal=e.peakOrdinal;
         return;
      }
   }
}

void AssignPrimary(const int newIndex,const int peakOrdinal)
{
   ArthaFVG newer=g_zones[newIndex];
   if(newer.episodeId<=0)
   {
      newer.primary=true;
      g_zones[newIndex]=newer;
      return;
   }
   newer.primary=true;
   for(int i=0;i<newIndex;++i)
   {
      ArthaFVG old=g_zones[i];
      if(old.episodeId!=newer.episodeId ||
         old.direction!=newer.direction || !old.primary)
         continue;
      int newDistance=(int)MathAbs(newer.bornOrdinal-peakOrdinal);
      int oldDistance=(int)MathAbs(old.bornOrdinal-peakOrdinal);
      bool better=(newDistance<oldDistance ||
                   (newDistance==oldDistance && newer.gapATR>old.gapATR));
      if(better)
      {
         old.primary=false;
         g_zones[i]=old;
      }
      else
         newer.primary=false;
      break;
   }
   g_zones[newIndex]=newer;
}

void DrawNewZone(const ArthaFVG &z, const datetime leftTime,
                 const datetime birthTime)
{
   if(!InpShowFVG)
      return;
   string name=ZoneName(z.id);
   if(!ObjectCreate(0,name,OBJ_RECTANGLE,0,leftTime,z.top,birthTime,z.bottom))
      return;
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_FILL,InpFillFVG);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_COLOR,CurrentPOIColor(z));
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,
                   StringFormat("ARTHA MT5 P10 %s #%d",CurrentPOIKind(z),z.id));
}

void SyncZone(const int index, const datetime rightTime)
{
   if(!InpShowFVG)
      return;
   ArthaFVG z=g_zones[index];
   string name=ZoneName(z.id);
   if(ObjectFind(0,name)<0)
      return;
   ObjectMove(0,name,1,rightTime,z.bottom);
   ObjectSetInteger(0,name,OBJPROP_COLOR,CurrentPOIColor(z));
   ObjectSetString(0,name,OBJPROP_TOOLTIP,
      StringFormat("ARTHA %s %s #%d | EP%d Q%d | %s / %s | Mitigation %.1f%% | %s",
                   z.direction==1?"Bull":"Bear",CurrentPOIKind(z),z.id,z.episodeId,z.provenanceScore,
                   z.episodeId==0?"ORDINARY":z.structureLinked?"STRUCTURAL":"DISPLACEMENT",
                   z.primary?"PRIMARY":"SECONDARY",z.maxMitigationPct,
                   z.retired?"Retired":"Active"));
}

void RegisterZone(const int direction,const double top,const double bottom,
                  const datetime leftTime,const datetime bornTime,
                  const int episodeId,const int peakScore,
                  const bool structureLinked,const int peakOrdinal,
                  const double gapATR,const string originKind)
{
   if(InpMaxZones<1 || top<=bottom)
      return;
   int n=ArraySize(g_zones);
   if(n>=InpMaxZones)
   {
      ObjectDelete(0,ZoneName(g_zones[0].id));
      for(int i=1; i<n; ++i)
         g_zones[i-1]=g_zones[i];
      ArrayResize(g_zones,n-1);
      n--;
   }
   ArrayResize(g_zones,n+1);
   ArthaFVG z;
   z.id=g_nextZoneId++;
   z.direction=direction;
   z.top=top;
   z.bottom=bottom;
   z.maxMitigationPct=0.0;
   z.born=bornTime;
   z.firstTouch=0;
   z.retired=false;
   z.episodeId=episodeId;
   z.provenanceScore=peakScore;
   z.structureLinked=structureLinked;
   z.primary=false;
   z.bornOrdinal=g_barOrdinal;
   z.gapATR=gapATR;
   z.originKind=originKind;
   z.state=0;
   z.firstTouchOrdinal=0;
   z.lastSignalOrdinal=-100000;
   z.maxDepthOrdinal=0;
   z.retirementOrdinal=-100000;
   g_zones[n]=z;
   AssignPrimary(n,peakOrdinal);
   DrawNewZone(g_zones[n],leftTime,bornTime);
   SyncZone(n,bornTime);
}

void UpdateZones(const int shift, const datetime &times[],
                 const double &highs[], const double &lows[],
                 const double &closes[])
{
   for(int i=0; i<ArraySize(g_zones); ++i)
   {
      ArthaFVG z=g_zones[i];
      // A zone must never react to the same bar that created it.
      if(z.retired || times[shift]<=z.born)
         continue;
      double overlap=MathMax(0.0,MathMin(highs[shift],z.top)-
                            MathMax(lows[shift],z.bottom));
      if(overlap>0.0)
      {
         double depth=100.0*overlap/MathMax(z.top-z.bottom,_Point);
         if(depth>z.maxMitigationPct)
         {
            z.maxMitigationPct=MathMin(100.0,depth);
            z.maxDepthOrdinal=g_barOrdinal;
         }
         if(z.firstTouch==0)
         {
            z.firstTouch=times[shift];
            z.firstTouchOrdinal=g_barOrdinal;
         }
      }
      bool closeInvalid=z.direction==1?closes[shift]<z.bottom:closes[shift]>z.top;
      bool wickFilled=z.direction==1?lows[shift]<=z.bottom:highs[shift]>=z.top;
      bool flipEnabled=z.originKind=="OB"?InpEnableBreakers:InpEnableIFVG;
      if(z.state==0 && closeInvalid && flipEnabled)
      {
         z.state=1;
         z.direction=-z.direction;
         z.born=times[shift];
         z.bornOrdinal=g_barOrdinal;
         z.firstTouch=0;
         z.firstTouchOrdinal=0;
         z.maxMitigationPct=0.0;
         z.maxDepthOrdinal=0;
         z.lastSignalOrdinal=-100000;
      }
      else if((z.state==1 && closeInvalid) ||
              (InpRetireOnFullWickFill && wickFilled))
      {
         z.retired=true;
         z.state=2;
         z.retirementOrdinal=g_barOrdinal;
      }
      g_zones[i]=z;
      SyncZone(i,times[shift]);
   }
}

void RegisterLiquidity(const int side,const int tier,const double price,
                       const datetime born,const double tolerance)
{
   if(price<=0.0 || price==EMPTY_VALUE)
      return;
   int n=ArraySize(g_liquidity);
   for(int i=0;i<n;++i)
      if(g_liquidity[i].active && g_liquidity[i].side==side &&
         MathAbs(g_liquidity[i].price-price)<=tolerance)
         return;
   if(n>=InpMaxLiquidityRecords)
   {
      for(int j=1;j<n;++j)
         g_liquidity[j-1]=g_liquidity[j];
      ArrayResize(g_liquidity,n-1);
      n--;
   }
   ArrayResize(g_liquidity,n+1);
   ArthaLiquidity q;
   q.id=g_nextLiquidityId++;
   q.side=side;
   q.tier=tier;
   q.price=price;
   q.born=born;
   q.bornOrdinal=g_barOrdinal;
   q.active=true;
   g_liquidity[n]=q;
}

// Always refer to the *previous completed* HTF candle at the historical time.
void RefreshPeriodLiquidity(const ENUM_TIMEFRAMES tf,const datetime at,
                            datetime &lastStamp,const int tier,
                            const double tolerance)
{
   int containing=iBarShift(_Symbol,tf,at,false);
   if(containing<0)
      return;
   int completed=containing+1;
   datetime stamp=iTime(_Symbol,tf,completed);
   if(stamp==0 || stamp==lastStamp)
      return;
   double h=iHigh(_Symbol,tf,completed);
   double l=iLow(_Symbol,tf,completed);
   if(h<=0.0 || l<=0.0 || h<=l)
      return;
   lastStamp=stamp;
   RegisterLiquidity(+1,tier,h,at,tolerance);
   RegisterLiquidity(-1,tier,l,at,tolerance);
}

void UpdateLiquidity(const int shift,const double &highs[],
                     const double &lows[],const double &closes[])
{
   for(int i=0;i<ArraySize(g_liquidity);++i)
   {
      ArthaLiquidity q=g_liquidity[i];
      if(!q.active || g_barOrdinal<=q.bornOrdinal)
         continue;
      bool passed=q.side==1?highs[shift]>q.price:lows[shift]<q.price;
      if(!passed)
         continue;
      bool reclaimed=q.side==1?closes[shift]<q.price:closes[shift]>q.price;
      if(reclaimed)
      {
         if(q.side==1)
            g_lastBuySweepOrdinal=g_barOrdinal;
         else
            g_lastSellSweepOrdinal=g_barOrdinal;
      }
      q.active=false;
      g_liquidity[i]=q;
   }
}

bool FindNextLiquidityTarget(const int direction,const double beyond,
                             const double minSeparation,double &target)
{
   target=0.0;
   double bestDistance=1.0e100;
   for(int i=0;i<ArraySize(g_liquidity);++i)
   {
      ArthaLiquidity q=g_liquidity[i];
      if(!q.active || q.side!=direction || q.tier>3)
         continue;
      double distance=direction==1?q.price-beyond:beyond-q.price;
      if(distance<minSeparation || distance>=bestDistance)
         continue;
      bestDistance=distance;
      target=q.price;
   }
   return target>0.0;
}

void MaybeRegisterOrderBlock(const int direction,const int episodeId,
                             const int score,const bool structural,
                             const int peakOrdinal,const int shift,
                             const int total,const datetime &times[],
                             const double &opens[],const double &highs[],
                             const double &lows[],const double &closes[],
                             const double atrValue)
{
   if(!InpEnableOB || !structural || episodeId<=0 || !g_episodeActive ||
      g_activeEpisode.id!=episodeId)
      return;
   for(int i=0;i<ArraySize(g_zones);++i)
      if(g_zones[i].originKind=="OB" && g_zones[i].episodeId==episodeId)
         return;

   // Origin must precede the first qualified displacement in this episode.
   int episodeShift=shift+(g_barOrdinal-g_activeEpisode.firstOrdinal);
   for(int j=episodeShift+1;j<=episodeShift+InpOBSearchBars && j<total;++j)
   {
      bool opposite=direction==1?closes[j]<opens[j]:closes[j]>opens[j];
      if(!opposite)
         continue;
      double top=InpOBBodyOnly?MathMax(opens[j],closes[j]):highs[j];
      double bottom=InpOBBodyOnly?MathMin(opens[j],closes[j]):lows[j];
      if(top<=bottom)
         return;
      RegisterZone(direction,top,bottom,times[j],times[shift],episodeId,
                   score,true,peakOrdinal,(top-bottom)/MathMax(atrValue,_Point),"OB");
      return;
   }
}

string PlanName(const int id,const string part)
{
   return g_prefix+"PLAN_"+IntegerToString(id)+"_"+part;
}

void DeletePlanObjects(const int id)
{
   string parts[]={"ENTRY","STOP","T1","T2","T3","T4","RISK","REWARD"};
   for(int i=0;i<ArraySize(parts);++i)
      ObjectDelete(0,PlanName(id,parts[i]));
}

void CreatePlanLine(const ArthaPlan &p,const string part,
                    const double level,const color c)
{
   string name=PlanName(p.id,part);
   datetime second=p.born+(datetime)PeriodSeconds(_Period);
   if(!ObjectCreate(0,name,OBJ_TREND,0,p.born,level,second,level))
      return;
   ObjectSetInteger(0,name,OBJPROP_COLOR,c);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,
      StringFormat("ARTHA P%d %s %.5f",p.id,part,level));
}

void CreatePlanBox(const ArthaPlan &p,const string part,
                   const double top,const double bottom,const color c)
{
   string name=PlanName(p.id,part);
   datetime second=p.born+(datetime)PeriodSeconds(_Period);
   if(!ObjectCreate(0,name,OBJ_RECTANGLE,0,p.born,top,second,bottom))
      return;
   ObjectSetInteger(0,name,OBJPROP_COLOR,c);
   ObjectSetInteger(0,name,OBJPROP_FILL,false);
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
}

void DrawPlan(const ArthaPlan &p,const double candleHigh,
              const double candleLow)
{
   if(!InpShowPlans)
      return;
   color reward=p.direction==1?InpBuyRewardColor:InpSellRewardColor;
   CreatePlanLine(p,"ENTRY",p.entry,clrSilver);
   CreatePlanLine(p,"STOP",p.stop,InpRiskColor);
   CreatePlanLine(p,"T1",p.tp1,reward);
   CreatePlanLine(p,"T2",p.tp2,reward);
   if(p.hasTP3 && InpShowLiquidityTP3TP4)
      CreatePlanLine(p,"T3",p.tp3,reward);
   if(p.hasTP4 && InpShowLiquidityTP3TP4)
      CreatePlanLine(p,"T4",p.tp4,reward);
   CreatePlanBox(p,"RISK",MathMax(p.entry,p.stop),MathMin(p.entry,p.stop),InpRiskColor);
   CreatePlanBox(p,"REWARD",MathMax(p.entry,p.tp2),MathMin(p.entry,p.tp2),reward);

   string name=g_prefix+"SIGNAL_"+IntegerToString(p.id);
   double y=p.direction==1?candleLow-3*_Point:candleHigh+3*_Point;
   if(ObjectCreate(0,name,OBJ_TEXT,0,p.born,y))
   {
      string tag=(p.direction==1?"BUY ":"SELL ")+p.family+" "+p.source+
                 " Q"+IntegerToString(p.quality);
      ObjectSetString(0,name,OBJPROP_TEXT,tag);
      ObjectSetInteger(0,name,OBJPROP_COLOR,
                       p.direction==1?InpBuySignalColor:InpSellSignalColor);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,
         StringFormat("%s | %s #%d | ENTRY %.5f | SL %.5f | TP1 %.5f | TP2 %.5f",
                      tag,p.poiKind,p.poiId,p.entry,p.stop,p.tp1,p.tp2));
   }
   int n=ArraySize(g_signalObjectNames);
   if(n>=InpMaxSignalObjects)
   {
      // Preserve the label of every active plan, even when the cap is hit.
      for(int j=0;j<n;++j)
      {
         int oldId=(int)StringToInteger(StringSubstr(g_signalObjectNames[j],
                                           StringLen(g_prefix+"SIGNAL_")));
         bool active=false;
         for(int k=0;k<ArraySize(g_plans);++k)
            if(g_plans[k].id==oldId && g_plans[k].state==0)
            {
               active=true;
               break;
            }
         if(active)
            continue;
         ObjectDelete(0,g_signalObjectNames[j]);
         for(int k=j+1;k<n;++k)
            g_signalObjectNames[k-1]=g_signalObjectNames[k];
         ArrayResize(g_signalObjectNames,n-1);
         n--;
         break;
      }
   }
   ArrayResize(g_signalObjectNames,n+1);
   g_signalObjectNames[n]=name;
}

void ExtendPlanObjects(const ArthaPlan &p,const datetime at)
{
   if(!InpShowPlans || at<=p.born)
      return;
   string parts[]={"ENTRY","STOP","T1","T2","T3","T4","RISK","REWARD"};
   for(int j=0;j<ArraySize(parts);++j)
   {
      string name=PlanName(p.id,parts[j]);
      if(ObjectFind(0,name)<0)
         continue;
      double level=0.0;
      if(parts[j]=="ENTRY")level=p.entry;
      else if(parts[j]=="STOP")level=p.stop;
      else if(parts[j]=="T1")level=p.tp1;
      else if(parts[j]=="T2")level=p.tp2;
      else if(parts[j]=="T3")level=p.tp3;
      else if(parts[j]=="T4")level=p.tp4;
      else if(parts[j]=="RISK")level=MathMin(p.entry,p.stop);
      else level=MathMin(p.entry,p.tp2);
      ObjectMove(0,name,1,at,level);
   }
}

void UpdatePlans(const int shift,const datetime &times[],
                 const double &highs[],const double &lows[])
{
   for(int i=0;i<ArraySize(g_plans);++i)
   {
      ArthaPlan p=g_plans[i];
      if(p.state!=0 || g_barOrdinal<=p.ordinal)
         continue;
      bool stopHit=p.direction==1?lows[shift]<=p.stop:highs[shift]>=p.stop;
      if(stopHit)
      {
         p.state=2;
         p.closed=times[shift];
      }
      else
      {
         bool t1=p.direction==1?highs[shift]>=p.tp1:lows[shift]<=p.tp1;
         bool t2=p.direction==1?highs[shift]>=p.tp2:lows[shift]<=p.tp2;
         bool t3=p.hasTP3 && (p.direction==1?highs[shift]>=p.tp3:lows[shift]<=p.tp3);
         bool t4=p.hasTP4 && (p.direction==1?highs[shift]>=p.tp4:lows[shift]<=p.tp4);
         if(t1)p.stage=(int)MathMax(p.stage,1);
         if(t2)p.stage=(int)MathMax(p.stage,2);
         if(t3)p.stage=(int)MathMax(p.stage,3);
         if(t4)p.stage=(int)MathMax(p.stage,4);
         bool finished=(p.hasTP4?t4:p.hasTP3?t3:t2);
         if(finished)
         {
            p.state=1;
            p.closed=times[shift];
         }
      }
      ExtendPlanObjects(p,times[shift]);
      g_plans[i]=p;
   }
}

void UpdateDashboard()
{
   if(!InpShowDashboard)
      return;
   string name=g_prefix+"DASHBOARD";
   if(ObjectFind(0,name)<0)
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   int active=0;
   for(int i=0;i<ArraySize(g_plans);++i)
      if(g_plans[i].state==0)active++;
   string state="NONE";
   if(ArraySize(g_plans)>0)
   {
      ArthaPlan p=g_plans[ArraySize(g_plans)-1];
      state=p.family+" "+p.source+" "+(p.direction==1?"BUY":"SELL")+
            " P"+IntegerToString(p.id)+" Q"+IntegerToString(p.quality);
   }
   ObjectSetString(0,name,OBJPROP_TEXT,
      "ARTHA MT5 P10 BETA | "+IntegerToString(active)+" OPEN | "+state);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,18);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,22);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrSilver);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
}

bool BullCandleConfirmed(const int dir,const int shift,
                         const double &opens[],const double &highs[],
                         const double &lows[],const double &closes[])
{
   double span=MathMax(highs[shift]-lows[shift],_Point);
   double loc=dir==1?(closes[shift]-lows[shift])/span:
                       (highs[shift]-closes[shift])/span;
   return (dir==1?closes[shift]>opens[shift]:closes[shift]<opens[shift]) &&
          loc>=0.55;
}

bool MitigationConfirmed(const ArthaFVG &z,const int shift,
                         const double &opens[],const double &highs[],
                         const double &lows[],const double &closes[])
{
   double mid=(z.top+z.bottom)*0.5;
   bool directional=BullCandleConfirmed(z.direction,shift,opens,highs,lows,closes);
   if(InpMitConfirm==ARTHA_BOUNDARY_RECLAIM)
      return z.direction==1?(closes[shift]>opens[shift] && closes[shift]>z.top):
                            (closes[shift]<opens[shift] && closes[shift]<z.bottom);
   if(InpMitConfirm==ARTHA_DIRECTIONAL_INSIDE)
      return directional && (z.direction==1?closes[shift]>=z.bottom:
                                            closes[shift]<=z.top);
   return directional && (z.direction==1?closes[shift]>=mid:closes[shift]<=mid);
}

bool IdentifyFamily(const int direction,string &family)
{
   bool recentShift=direction==1?
      g_barOrdinal-g_lastBullShiftOrdinal<=InpRecentBreakBars:
      g_barOrdinal-g_lastBearShiftOrdinal<=InpRecentBreakBars;
   bool recentSweep=direction==1?
      g_barOrdinal-g_lastSellSweepOrdinal<=InpRecentSweepBars:
      g_barOrdinal-g_lastBuySweepOrdinal<=InpRecentSweepBars;
   bool currentTrend=(g_externalTrend==direction);
   bool recentBOS=direction==1?
      g_barOrdinal-g_lastBullBreakOrdinal<=InpRecentBreakBars:
      g_barOrdinal-g_lastBearBreakOrdinal<=InpRecentBreakBars;
   if(InpEnableREV && recentShift && recentSweep)
   {
      family="REV";
      return true;
   }
   if(InpEnableCONT && currentTrend && recentBOS)
   {
      family="CONT";
      return true;
   }
   return false;
}

int QualityOf(const ArthaFVG &z,const string family,const string source)
{
   int quality=(int)MathRound(MathMin(100,z.provenanceScore)*0.30);
   quality+=(family=="REV"?18:20);
   quality+=(z.originKind=="OB"?20:z.state==1?16:14);
   if(z.structureLinked)quality+=4;
   if(z.maxMitigationPct<=25.0)quality+=15;
   else if(z.maxMitigationPct<=50.0)quality+=13;
   else if(z.maxMitigationPct<=75.0)quality+=9;
   else if(z.maxMitigationPct<100.0)quality+=5;
   if(family=="CONT")quality+=15;
   else quality+=((g_barOrdinal-g_lastSellSweepOrdinal<=InpRecentSweepBars ||
                   g_barOrdinal-g_lastBuySweepOrdinal<=InpRecentSweepBars)?15:0);
   if(source=="EARLY")quality-=5;
   return (int)MathMax(0,MathMin(100,quality));
}

bool TryCreatePlan(const ArthaFVG &z,const string family,
                   const string source,const int quality,
                   const int shift,const datetime &times[],
                   const double &highs[],const double &lows[],
                   const double &closes[],const double atrValue)
{
   int required=source=="EARLY"?InpMinEARLYScore:
                family=="REV"?InpMinREVScore:InpMinCONTScore;
   if(quality<required || atrValue<=0.0 || atrValue==EMPTY_VALUE)
      return false;
   double entry=closes[shift];
   double edge=z.direction==1?z.bottom:z.top;
   if(z.direction==1)
   {
      if(g_externalLow.valid && g_externalLow.price<entry)
         edge=MathMin(edge,g_externalLow.price);
   }
   else if(g_externalHigh.valid && g_externalHigh.price>entry)
      edge=MathMax(edge,g_externalHigh.price);
   double stop=edge-z.direction*InpStopBufferATR*atrValue;
   double risk=z.direction*(entry-stop);
   if(risk<=_Point || risk>InpMaxStopATR*atrValue)
      return false;

   ArthaPlan p;
   p.id=g_nextPlanId++;
   p.poiId=z.id;
   p.direction=z.direction;
   p.ordinal=g_barOrdinal;
   p.born=times[shift];
   p.family=family;
   p.source=source;
   p.poiKind=z.originKind=="OTE"?"OTE":CurrentPOIKind(z);
   p.quality=quality;
   p.entry=entry;
   p.stop=stop;
   p.tp1=entry+z.direction*risk*InpTP1R;
   p.tp2=entry+z.direction*risk*InpTP2R;
   p.tp3=0.0;
   p.tp4=0.0;
   p.hasTP3=InpShowLiquidityTP3TP4 &&
      FindNextLiquidityTarget(z.direction,p.tp2,0.20*atrValue,p.tp3);
   p.hasTP4=p.hasTP3 && InpShowLiquidityTP3TP4 &&
      FindNextLiquidityTarget(z.direction,p.tp3,0.20*atrValue,p.tp4);
   p.stage=0;
   p.state=0;
   p.closed=0;
   int n=ArraySize(g_plans);
   if(n>=InpMaxPlans)
   {
      // Only prune completed/stopped plans. Active plans never expire.
      for(int j=0;j<n;++j)
      {
         if(g_plans[j].state==0)
            continue;
         DeletePlanObjects(g_plans[j].id);
         for(int k=j+1;k<n;++k)
            g_plans[k-1]=g_plans[k];
         ArrayResize(g_plans,n-1);
         n--;
         break;
      }
   }
   ArrayResize(g_plans,n+1);
   g_plans[n]=p;
   g_totalSignals++;
   DrawPlan(p,highs[shift],lows[shift]);
   if(g_allowLiveAlerts && (InpAlertOnNewSignals || InpPushOnNewSignals))
   {
      string notice=StringFormat("ARTHA MT5 %s %s %s Q%d | %s %s | Entry %.5f SL %.5f",
                     p.direction==1?"BUY":"SELL",p.family,p.source,p.quality,
                     _Symbol,EnumToString(_Period),p.entry,p.stop);
      if(InpAlertOnNewSignals)Alert(notice);
      if(InpPushOnNewSignals)SendNotification(notice);
   }
   return true;
}

void EvaluatePOIEntries(const int shift,const datetime &times[],
                        const double &opens[],const double &highs[],
                        const double &lows[],const double &closes[],
                        const double atrValue)
{
   for(int i=0;i<ArraySize(g_zones);++i)
   {
      ArthaFVG z=g_zones[i];
      // Full-wick mitigation is allowed to trigger a reclaim on its final bar.
      if((z.retired && z.retirementOrdinal!=g_barOrdinal) || z.lastSignalOrdinal>=0 ||
         g_barOrdinal<=z.bornOrdinal || z.firstTouchOrdinal<=0 ||
         g_barOrdinal-z.firstTouchOrdinal>InpConfirmWindowBars ||
         (!z.primary && z.originKind=="FVG"))
         continue;
      string family="";
      if(!IdentifyFamily(z.direction,family))
         continue;
      bool directional=BullCandleConfirmed(z.direction,shift,opens,highs,lows,closes);
      bool boundary=z.direction==1?(closes[shift]>opens[shift] && closes[shift]>z.top):
                                    (closes[shift]<opens[shift] && closes[shift]<z.bottom);
      bool sweepClose=z.direction==1?(lows[shift]<z.bottom && closes[shift]>=z.bottom):
                                     (highs[shift]>z.top && closes[shift]<=z.top);
      bool withinOTE=false;
      if(InpEnableOTE && g_externalHigh.valid && g_externalLow.valid)
      {
         double impulse=g_externalHigh.price-g_externalLow.price;
         if(impulse>atrValue)
         {
            double oteTop=z.direction==1?g_externalHigh.price-InpOTELowRatio*impulse:
                                           g_externalLow.price+InpOTEHighRatio*impulse;
            double oteBottom=z.direction==1?g_externalHigh.price-InpOTEHighRatio*impulse:
                                              g_externalLow.price+InpOTELowRatio*impulse;
            withinOTE=(lows[shift]<=oteTop && highs[shift]>=oteBottom);
         }
      }
      string source="";
      if(InpEnableConfirmed && z.maxMitigationPct>=InpNormalMitigationPct && boundary)
         source="CONF";
      else if(InpEnableMISS && z.maxMitigationPct>=100.0 && sweepClose && directional)
         source="MISS";
      else if(InpEnableOTE && withinOTE && directional && z.maxMitigationPct>=InpEarlyMitigationPct)
         source="OTE";
      else if(InpEnableMIT && z.maxMitigationPct>=InpMitigationPct &&
              MitigationConfirmed(z,shift,opens,highs,lows,closes))
         source=InpMitigationPct==50?"MID":"MIT";
      else if(InpEnableEARLY && z.maxMitigationPct>=InpEarlyMitigationPct && directional)
         source="EARLY";
      if(source=="")
         continue;
      int quality=QualityOf(z,family,source);
      if(TryCreatePlan(z,family,source,quality,shift,times,highs,lows,closes,atrValue))
      {
         z.lastSignalOrdinal=g_barOrdinal;
         g_zones[i]=z;
      }
   }
}

void EvaluateIndependentOTE(const int shift,const datetime &times[],
                            const double &opens[],const double &highs[],
                            const double &lows[],const double &closes[],
                            const double atrValue)
{
   if(!InpEnableOTE || !g_externalHigh.valid || !g_externalLow.valid ||
      g_barOrdinal-g_lastOTEOrdinal<=InpOTERecentBars || atrValue<=0.0)
      return;
   int direction=g_externalTrend;
   if(direction==0)
      return;
   bool anchorsOrdered=direction==1?g_externalHigh.at>g_externalLow.at:
                                    g_externalLow.at>g_externalHigh.at;
   double impulse=g_externalHigh.price-g_externalLow.price;
   if(!anchorsOrdered || impulse<atrValue)
      return;
   double top=direction==1?g_externalHigh.price-InpOTELowRatio*impulse:
                            g_externalLow.price+InpOTEHighRatio*impulse;
   double bottom=direction==1?g_externalHigh.price-InpOTEHighRatio*impulse:
                               g_externalLow.price+InpOTELowRatio*impulse;
   if(lows[shift]>top || highs[shift]<bottom ||
      !BullCandleConfirmed(direction,shift,opens,highs,lows,closes))
      return;
   string family="";
   if(!IdentifyFamily(direction,family))
      return;
   ArthaFVG candidate;
   candidate.id=0;
   candidate.direction=direction;
   candidate.top=top;
   candidate.bottom=bottom;
   candidate.originKind="OTE";
   candidate.state=0;
   candidate.provenanceScore=g_episodeActive?g_activeEpisode.peakScore:75;
   candidate.structureLinked=true;
   candidate.maxMitigationPct=50.0;
   int quality=QualityOf(candidate,family,"OTE");
   if(TryCreatePlan(candidate,family,"OTE",quality,shift,times,highs,lows,closes,atrValue))
      g_lastOTEOrdinal=g_barOrdinal;
}

void ProcessClosedBar(const int shift, const int total,
                      const datetime &times[], const double &opens[],
                      const double &highs[], const double &lows[],
                      const double &closes[], const double &atr[])
{
   g_barOrdinal++;
   double tolerance=(atr[shift]>0.0 && atr[shift]!=EMPTY_VALUE)?
                     atr[shift]*InpLiquidityToleranceATR:_Point;
   const int ic=shift+InpInternalPivotStrength;
   const int xc=shift+InpExternalPivotStrength;
   if(IsPivotHigh(highs,ic,InpInternalPivotStrength,total))
   {
      NewSwing(g_internalHigh,highs[ic],times[ic]);
      if(InpUseInternalSwingLiq)
         RegisterLiquidity(+1,4,highs[ic],times[shift],tolerance);
   }
   if(IsPivotLow(lows,ic,InpInternalPivotStrength,total))
   {
      NewSwing(g_internalLow,lows[ic],times[ic]);
      if(InpUseInternalSwingLiq)
         RegisterLiquidity(-1,4,lows[ic],times[shift],tolerance);
   }
   if(IsPivotHigh(highs,xc,InpExternalPivotStrength,total))
   {
      NewSwing(g_externalHigh,highs[xc],times[xc]);
      if(InpUseExternalSwingLiq)
         RegisterLiquidity(+1,2,highs[xc],times[shift],tolerance);
   }
   if(IsPivotLow(lows,xc,InpExternalPivotStrength,total))
   {
      NewSwing(g_externalLow,lows[xc],times[xc]);
      if(InpUseExternalSwingLiq)
         RegisterLiquidity(-1,2,lows[xc],times[shift],tolerance);
   }

   if(InpUsePreviousDayHL)
      RefreshPeriodLiquidity(PERIOD_D1,times[shift],g_lastPDTime,1,tolerance);
   if(InpUsePreviousWeekHL)
      RefreshPeriodLiquidity(PERIOD_W1,times[shift],g_lastPWTime,1,tolerance);
   if(InpUsePreviousMonthHL)
      RefreshPeriodLiquidity(PERIOD_MN1,times[shift],g_lastPMTime,1,tolerance);
   UpdateLiquidity(shift,highs,lows,closes);

   int oldInternalTrend=g_internalTrend;
   int oldExternalTrend=g_externalTrend;
   bool iBull=CheckBreak(g_internalHigh,g_internalTrend,"I",+1,shift,times,closes,highs,lows);
   bool iBear=CheckBreak(g_internalLow,g_internalTrend,"I",-1,shift,times,closes,highs,lows);
   bool xBull=CheckBreak(g_externalHigh,g_externalTrend,"X",+1,shift,times,closes,highs,lows);
   bool xBear=CheckBreak(g_externalLow,g_externalTrend,"X",-1,shift,times,closes,highs,lows);
   if(iBull || xBull)
   {
      g_lastBullBreakOrdinal=g_barOrdinal;
      if((iBull && oldInternalTrend<0) || (xBull && oldExternalTrend<0))
         g_lastBullShiftOrdinal=g_barOrdinal;
   }
   if(iBear || xBear)
   {
      g_lastBearBreakOrdinal=g_barOrdinal;
      if((iBear && oldInternalTrend>0) || (xBear && oldExternalTrend>0))
         g_lastBearShiftOrdinal=g_barOrdinal;
   }

   bool qualifiedBull=false,qualifiedBear=false;
   int bullScore=EvaluateDisplacement(shift,total,true,opens,highs,lows,closes,atr,qualifiedBull);
   int bearScore=EvaluateDisplacement(shift,total,false,opens,highs,lows,closes,atr,qualifiedBear);
   int qualifiedDir=qualifiedBull?1:qualifiedBear?-1:0;
   int qualifiedScore=qualifiedBull?bullScore:qualifiedBear?bearScore:0;
   AdvanceEpisode(qualifiedDir,qualifiedScore,iBull||xBull,iBear||xBear);

   // Plans are updated before any new entries; never use the entry bar to
   // retrospectively award a TP or SL.
   UpdatePlans(shift,times,highs,lows);
   // Existing zones update before creation, so birth candles cannot touch their own FVG.
   UpdateZones(shift,times,highs,lows,closes);
   if(shift+2>=total || atr[shift]<=0.0 || atr[shift]==EMPTY_VALUE)
      return;

   int bullId=0,bullPeak=0,bullPeakOrdinal=0;
   int bearId=0,bearPeak=0,bearPeakOrdinal=0;
   bool bullStructural=false,bearStructural=false;
   FindEpisode(+1,g_barOrdinal,bullId,bullPeak,bullStructural,bullPeakOrdinal);
   FindEpisode(-1,g_barOrdinal,bearId,bearPeak,bearStructural,bearPeakOrdinal);
   bool bullAllowed=(InpFVGCreationMode==ARTHA_FVG_ALL ||
      (bullId>0 && (InpFVGCreationMode==ARTHA_FVG_DISPLACEMENT || bullStructural)));
   bool bearAllowed=(InpFVGCreationMode==ARTHA_FVG_ALL ||
      (bearId>0 && (InpFVGCreationMode==ARTHA_FVG_DISPLACEMENT || bearStructural)));

   // Same three-candle geometry as Pine; causal episode filter is now configurable.
   double bullGap=lows[shift]-highs[shift+2];
   double bearGap=lows[shift+2]-highs[shift];
   if(bullAllowed && bullGap>0.0 && bullGap>=InpMinFVGSizeATR*atr[shift])
      RegisterZone(+1,lows[shift],highs[shift+2],times[shift+2],times[shift],
                   bullId,bullPeak,bullStructural,bullPeakOrdinal,bullGap/atr[shift],"FVG");
   if(bearAllowed && bearGap>0.0 && bearGap>=InpMinFVGSizeATR*atr[shift])
      RegisterZone(-1,lows[shift+2],highs[shift],times[shift+2],times[shift],
                   bearId,bearPeak,bearStructural,bearPeakOrdinal,bearGap/atr[shift],"FVG");
   if((iBull || xBull) && bullId>0)
      MaybeRegisterOrderBlock(+1,bullId,bullPeak,bullStructural,bullPeakOrdinal,
                              shift,total,times,opens,highs,lows,closes,atr[shift]);
   if((iBear || xBear) && bearId>0)
      MaybeRegisterOrderBlock(-1,bearId,bearPeak,bearStructural,bearPeakOrdinal,
                              shift,total,times,opens,highs,lows,closes,atr[shift]);
   EvaluatePOIEntries(shift,times,opens,highs,lows,closes,atr[shift]);
   EvaluateIndependentOTE(shift,times,opens,highs,lows,closes,atr[shift]);
}

int OnInit()
{
   if(InpInternalPivotStrength<1 || InpInternalPivotStrength>20 ||
      InpExternalPivotStrength<2 || InpExternalPivotStrength>50 ||
      InpHistoryBars<50 || InpMaxZones<1 || InpMaxStructureObjects<1 ||
      InpMinFVGSizeATR<0.0 || StringLen(InpInstanceId)==0 ||
       InpRelativeLookback<5 || InpRelativeLookback>100 ||
       InpMinDisplacementScore<0 || InpMinDisplacementScore>100 ||
       InpEpisodeGapBars<0 || InpEpisodeGapBars>5 ||
       InpEpisodeMaxBars<1 || InpEpisodeMaxBars>30 ||
       InpMaxEpisodeArchive<1 || InpMaxEpisodeArchive>300 ||
       InpFVGProvenanceWindow<0 || InpFVGProvenanceWindow>5 ||
       InpMinDispBodyATR<0.0 || InpMinDispRangeATR<0.0 ||
       InpMinDispBodyPct<0.0 || InpMinDispBodyPct>1.0 ||
       InpMinDispCloseLocation<0.5 || InpMinDispCloseLocation>1.0 ||
       InpMinBodyVsAverage<=0.0 || InpMinRangeVsAverage<=0.0 ||
       InpMaxLiquidityRecords<1 || InpLiquidityToleranceATR<0.0 ||
       InpOBSearchBars<1 || InpOBSearchBars>40 ||
       InpMitigationPct<1 || InpMitigationPct>100 ||
       InpEarlyMitigationPct<1 || InpEarlyMitigationPct>100 ||
       InpNormalMitigationPct<1 || InpNormalMitigationPct>100 ||
       InpConfirmWindowBars<1 || InpConfirmWindowBars>100 ||
       InpMinREVScore<0 || InpMinREVScore>100 ||
       InpMinCONTScore<0 || InpMinCONTScore>100 ||
       InpMinEARLYScore<0 || InpMinEARLYScore>100 ||
       InpRecentBreakBars<1 || InpRecentSweepBars<1 ||
       InpOTERecentBars<1 || InpOTELowRatio<=0.0 ||
       InpOTEHighRatio>=1.0 || InpOTELowRatio>=InpOTEHighRatio ||
       InpStopBufferATR<0.0 || InpMaxStopATR<=0.0 ||
       InpTP1R<=0.0 || InpTP2R<=InpTP1R ||
       InpMaxPlans<1 || InpMaxSignalObjects<1)
   {
      Print("ARTHA MT5 P10: invalid input parameters");
      return INIT_PARAMETERS_INCORRECT;
   }
   g_prefix="ARTHA_MT5_P10_"+InpInstanceId+"_";
   SetIndexBuffer(0,g_hiddenBuffer,INDICATOR_DATA);
   ArraySetAsSeries(g_hiddenBuffer,true);
   g_atrHandle=iATR(_Symbol,_Period,14);
   if(g_atrHandle==INVALID_HANDLE)
      return INIT_FAILED;
   IndicatorSetString(INDICATOR_SHORTNAME,"ARTHA MT5 P10 (Integrated Beta)");
   ResetCore();
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(StringLen(g_prefix)>0)
      ObjectsDeleteAll(0,g_prefix);
   if(g_atrHandle!=INVALID_HANDLE)
      IndicatorRelease(g_atrHandle);
}

int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[],
                const double &high[], const double &low[],
                const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
{
   if(rates_total<50)
      return 0;
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);

   // Never calculate/confirm on index 0: it is the developing candle.
   if(prev_calculated>0 && g_lastClosedBar==time[1])
      return rates_total;

   double atr[];
   ArraySetAsSeries(atr,true);
   int copyCount=(int)MathMin(rates_total,InpHistoryBars+
                  2*MathMax(InpInternalPivotStrength,InpExternalPivotStrength)+5);
   if(CopyBuffer(g_atrHandle,0,0,copyCount,atr)!=copyCount)
      return prev_calculated;

   if(prev_calculated==0 || g_lastClosedBar==0)
   {
      ResetCore();
      int oldest=(int)MathMin(InpHistoryBars,rates_total-1-
                              2*MathMax(InpInternalPivotStrength,InpExternalPivotStrength));
      for(int shift=oldest; shift>=1; --shift)
         ProcessClosedBar(shift,rates_total,time,open,high,low,close,atr);
   }
   else
   {
      // Rebuild after missed bars (e.g. terminal suspension) for deterministic state.
      if(time[2]!=g_lastClosedBar)
      {
         ResetCore();
         int oldest=(int)MathMin(InpHistoryBars,rates_total-1-
                                 2*MathMax(InpInternalPivotStrength,InpExternalPivotStrength));
         for(int shift=oldest; shift>=1; --shift)
            ProcessClosedBar(shift,rates_total,time,open,high,low,close,atr);
      }
      else
      {
         // Emit alerts only for a genuinely new, just-closed bar.
         g_allowLiveAlerts=true;
         ProcessClosedBar(1,rates_total,time,open,high,low,close,atr);
         g_allowLiveAlerts=false;
      }
   }
   g_lastClosedBar=time[1];
   UpdateDashboard();
   return rates_total;
}

