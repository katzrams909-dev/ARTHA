//+------------------------------------------------------------------+
//| ARTHA MT5 P02 - displacement-linked FVG provenance           |
//| Port reference: ARTHA TV P17.27.14.14 / 14.14N (2026-11-16)       |
//| IMPORTANT: P02 has no trades, entries, alerts or EA logic.|
//+------------------------------------------------------------------+
#property copyright "ARTHA"
#property version   "0.200"
#property strict
#property description "ARTHA MT5 P02: confirmed structure, displacement episodes and causal FVG provenance. No trades or entries."
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
input int    InpMaxZones                = 30;
input bool   InpRetireOnFullWickFill    = true;
input bool   InpShowFVG                 = true;
input bool   InpFillFVG                 = false;  // Outlines keep candles readable
input color  InpBullFVGColor            = clrDarkSlateGray;
input color  InpBearFVGColor            = clrMaroon;
input color  InpRetiredFVGColor         = clrDimGray;

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

ArthaSwing g_internalHigh, g_internalLow, g_externalHigh, g_externalLow;
ArthaFVG   g_zones[];
string     g_structureObjects[];
ArthaEpisode g_activeEpisode;
ArthaEpisode g_episodeArchive[];

string ZoneName(const int id)
{
   return g_prefix + "FVG_" + IntegerToString(id);
}

void ResetCore()
{
   if(StringLen(g_prefix)>0)
      ObjectsDeleteAll(0, g_prefix);
   ArrayResize(g_zones, 0);
   ArrayResize(g_structureObjects, 0);
   ArrayResize(g_episodeArchive,0);
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
   ObjectSetInteger(0,name,OBJPROP_COLOR,
                    z.direction==1?InpBullFVGColor:InpBearFVGColor);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,
                   StringFormat("ARTHA MT5 P02 FVG #%d (not an entry signal)",z.id));
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
   if(z.retired)
      ObjectSetInteger(0,name,OBJPROP_COLOR,InpRetiredFVGColor);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,
      StringFormat("ARTHA P02 %s FVG #%d | EP%d Q%d | %s / %s | Mitigation %.1f%% | %s | No trade",
                   z.direction==1?"Bull":"Bear",z.id,z.episodeId,z.provenanceScore,
                   z.episodeId==0?"ORDINARY":z.structureLinked?"STRUCTURAL":"DISPLACEMENT",
                   z.primary?"PRIMARY":"SECONDARY",z.maxMitigationPct,
                   z.retired?"Retired":"Active"));
}

void RegisterZone(const int direction,const double top,const double bottom,
                  const datetime leftTime,const datetime bornTime,
                  const int episodeId,const int peakScore,
                  const bool structureLinked,const int peakOrdinal,
                  const double gapATR)
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
   g_zones[n]=z;
   AssignPrimary(n,peakOrdinal);
   DrawNewZone(g_zones[n],leftTime,bornTime);
   SyncZone(n,bornTime);
}

void UpdateZones(const int shift, const datetime &times[],
                 const double &highs[], const double &lows[])
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
         z.maxMitigationPct=MathMax(z.maxMitigationPct,MathMin(100.0,depth));
         if(z.firstTouch==0)
            z.firstTouch=times[shift];
      }
      if(InpRetireOnFullWickFill &&
         (z.direction==1 ? lows[shift]<=z.bottom : highs[shift]>=z.top))
         z.retired=true;
      g_zones[i]=z;
      SyncZone(i,times[shift]);
   }
}

void ProcessClosedBar(const int shift, const int total,
                      const datetime &times[], const double &opens[],
                      const double &highs[], const double &lows[],
                      const double &closes[], const double &atr[])
{
   const int ic=shift+InpInternalPivotStrength;
   const int xc=shift+InpExternalPivotStrength;
   if(IsPivotHigh(highs,ic,InpInternalPivotStrength,total))
      NewSwing(g_internalHigh,highs[ic],times[ic]);
   if(IsPivotLow(lows,ic,InpInternalPivotStrength,total))
      NewSwing(g_internalLow,lows[ic],times[ic]);
   if(IsPivotHigh(highs,xc,InpExternalPivotStrength,total))
      NewSwing(g_externalHigh,highs[xc],times[xc]);
   if(IsPivotLow(lows,xc,InpExternalPivotStrength,total))
      NewSwing(g_externalLow,lows[xc],times[xc]);

   g_barOrdinal++;
   bool iBull=CheckBreak(g_internalHigh,g_internalTrend,"I",+1,shift,times,closes,highs,lows);
   bool iBear=CheckBreak(g_internalLow,g_internalTrend,"I",-1,shift,times,closes,highs,lows);
   bool xBull=CheckBreak(g_externalHigh,g_externalTrend,"X",+1,shift,times,closes,highs,lows);
   bool xBear=CheckBreak(g_externalLow,g_externalTrend,"X",-1,shift,times,closes,highs,lows);

   bool qualifiedBull=false,qualifiedBear=false;
   int bullScore=EvaluateDisplacement(shift,total,true,opens,highs,lows,closes,atr,qualifiedBull);
   int bearScore=EvaluateDisplacement(shift,total,false,opens,highs,lows,closes,atr,qualifiedBear);
   int qualifiedDir=qualifiedBull?1:qualifiedBear?-1:0;
   int qualifiedScore=qualifiedBull?bullScore:qualifiedBear?bearScore:0;
   AdvanceEpisode(qualifiedDir,qualifiedScore,iBull||xBull,iBear||xBear);

   // Existing zones update before creation, so birth candles cannot touch their own FVG.
   UpdateZones(shift,times,highs,lows);
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
                   bullId,bullPeak,bullStructural,bullPeakOrdinal,bullGap/atr[shift]);
   if(bearAllowed && bearGap>0.0 && bearGap>=InpMinFVGSizeATR*atr[shift])
      RegisterZone(-1,lows[shift+2],highs[shift],times[shift+2],times[shift],
                   bearId,bearPeak,bearStructural,bearPeakOrdinal,bearGap/atr[shift]);
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
       InpMinBodyVsAverage<=0.0 || InpMinRangeVsAverage<=0.0)
   {
      Print("ARTHA MT5 P02: invalid input parameters");
      return INIT_PARAMETERS_INCORRECT;
   }
   g_prefix="ARTHA_MT5_P02_"+InpInstanceId+"_";
   SetIndexBuffer(0,g_hiddenBuffer,INDICATOR_DATA);
   ArraySetAsSeries(g_hiddenBuffer,true);
   g_atrHandle=iATR(_Symbol,_Period,14);
   if(g_atrHandle==INVALID_HANDLE)
      return INIT_FAILED;
   IndicatorSetString(INDICATOR_SHORTNAME,"ARTHA MT5 P02 (Displacement FVG)");
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
         ProcessClosedBar(1,rates_total,time,open,high,low,close,atr);
   }
   g_lastClosedBar=time[1];
   return rates_total;
}
