//+------------------------------------------------------------------+
//| ARTHA MT5 P01 - closed-bar structure and FVG foundation           |
//| Port reference: ARTHA TV P17.27.14.14 / 14.14N (2026-11-16)       |
//| IMPORTANT: P01 is a non-trading foundation, NOT entry-engine parity.|
//+------------------------------------------------------------------+
#property copyright "ARTHA"
#property version   "0.10"
#property strict
#property description "ARTHA MT5 P01: confirmed swings, structure breaks and FVG/mitigation geometry. No trading or entry alerts."
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_label1  "ARTHA core"
#property indicator_type1   DRAW_NONE

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

input group "03  FVG / mitigation geometry"
input double InpMinFVGSizeATR           = 0.10;
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
};

ArthaSwing g_internalHigh, g_internalLow, g_externalHigh, g_externalLow;
ArthaFVG   g_zones[];
string     g_structureObjects[];

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

void CheckBreak(ArthaSwing &s, int &trend, const string scope,
                const int direction, const int shift,
                const datetime &times[], const double &closes[],
                const double &highs[], const double &lows[])
{
   if(!s.valid || s.broken)
      return;
   bool broke=(direction==1 ?
               (InpRequireCloseBreak ? closes[shift]>s.price : highs[shift]>s.price) :
               (InpRequireCloseBreak ? closes[shift]<s.price : lows[shift]<s.price));
   if(!broke)
      return;

   // A reversal is a CHoCH here; the Pine MSS/displacement distinction is pending.
   string kind=(trend!=0 && trend!=direction) ? "CHoCH" : "BOS";
   DrawStructureBreak(scope,direction,kind,s.at,times[shift],s.price);
   trend=direction;
   s.broken=true;
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
                   StringFormat("ARTHA MT5 P01 FVG #%d (not a trade signal)",z.id));
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
      StringFormat("ARTHA P01 %s FVG #%d | Max mitigation: %.1f%% | %s | Not an entry signal",
                   z.direction==1?"Bull":"Bear",z.id,z.maxMitigationPct,
                   z.retired?"Retired":"Active"));
}

void RegisterZone(const int direction, const double top, const double bottom,
                  const datetime leftTime, const datetime bornTime)
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
   g_zones[n]=z;
   DrawNewZone(z,leftTime,bornTime);
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

   CheckBreak(g_internalHigh,g_internalTrend,"I",+1,shift,times,closes,highs,lows);
   CheckBreak(g_internalLow,g_internalTrend,"I",-1,shift,times,closes,highs,lows);
   CheckBreak(g_externalHigh,g_externalTrend,"X",+1,shift,times,closes,highs,lows);
   CheckBreak(g_externalLow,g_externalTrend,"X",-1,shift,times,closes,highs,lows);

   UpdateZones(shift,times,highs,lows);
   if(shift+2>=total || atr[shift]<=0.0 || atr[shift]==EMPTY_VALUE)
      return;

   // Exactly the Pine three-candle gap geometry (without episode provenance yet).
   if(lows[shift]>highs[shift+2] &&
      (lows[shift]-highs[shift+2])>=InpMinFVGSizeATR*atr[shift])
      RegisterZone(+1,lows[shift],highs[shift+2],times[shift+2],times[shift]);
   if(highs[shift]<lows[shift+2] &&
      (lows[shift+2]-highs[shift])>=InpMinFVGSizeATR*atr[shift])
      RegisterZone(-1,lows[shift+2],highs[shift],times[shift+2],times[shift]);
}

int OnInit()
{
   if(InpInternalPivotStrength<1 || InpInternalPivotStrength>20 ||
      InpExternalPivotStrength<2 || InpExternalPivotStrength>50 ||
      InpHistoryBars<50 || InpMaxZones<1 || InpMaxStructureObjects<1 ||
      InpMinFVGSizeATR<0.0 || StringLen(InpInstanceId)==0)
   {
      Print("ARTHA MT5 P01: invalid input parameters");
      return INIT_PARAMETERS_INCORRECT;
   }
   g_prefix="ARTHA_MT5_P01_"+InpInstanceId+"_";
   SetIndexBuffer(0,g_hiddenBuffer,INDICATOR_DATA);
   ArraySetAsSeries(g_hiddenBuffer,true);
   g_atrHandle=iATR(_Symbol,_Period,14);
   if(g_atrHandle==INVALID_HANDLE)
      return INIT_FAILED;
   IndicatorSetString(INDICATOR_SHORTNAME,"ARTHA MT5 P01 (Core only)");
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
