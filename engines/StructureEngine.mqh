// FLYHI PROMPT: StructureEngine
// Detect swing highs/lows and break of structure (BOS).

#ifndef __STRUCTURE_ENGINE_MQH__
#define __STRUCTURE_ENGINE_MQH__

class StructureEngine
{
public:
   // Detect bullish break of structure (simple: previous swing high broken)
   bool BullishBOS(const string symbol, ENUM_TIMEFRAMES tf)
   {
      int bars = iBars(symbol, tf);
      if(bars < 5) return false;
      double prevHigh = iHigh(symbol, tf, 2);
      double lastHigh = iHigh(symbol, tf, 1);
      double currHigh = iHigh(symbol, tf, 0);
      return (lastHigh > prevHigh) && (currHigh > lastHigh);
   }
   // Detect bearish break of structure (simple: previous swing low broken)
   bool BearishBOS(const string symbol, ENUM_TIMEFRAMES tf)
   {
      int bars = iBars(symbol, tf);
      if(bars < 5) return false;
      double prevLow = iLow(symbol, tf, 2);
      double lastLow = iLow(symbol, tf, 1);
      double currLow = iLow(symbol, tf, 0);
      return (lastLow < prevLow) && (currLow < lastLow);
   }
};

#endif
