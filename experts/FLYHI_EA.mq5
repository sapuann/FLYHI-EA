//+------------------------------------------------------------------+
//|                  FLYHI_EA                                        |
//| Modular MT5 EA for XAUUSD, multi-engine Copilot ready            |
//+------------------------------------------------------------------+
#include <engines/StructureEngine.mqh>
#include <engines/LiquidityEngine.mqh>
#include <engines/ImbalanceEngine.mqh>
#include <engines/PressureEngine.mqh>
#include <engines/MarketRegimeEngine.mqh>
#include <engines/SessionEngine.mqh>
#include <engines/TradeEngine.mqh>
#include <risk/RiskManager.mqh>
#include <utils/Logger.mqh>
#include <utils/Telemetry.mqh>
#include <utils/VisualDebug.mqh>

// Declare engine objects
StructureEngine    structure;
LiquidityEngine    liquidity;
ImbalanceEngine    imbalance;
PressureEngine     pressure;
MarketRegimeEngine regime;
SessionEngine      session;
TradeEngine        trade;
RiskManager        risk;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Logger::Info("FLYHI_EA initialized.");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Logger::Info("FLYHI_EA deinitialized.");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   string symbol = _Symbol;
   ENUM_TIMEFRAMES tf = PERIOD_M5;

   // --- Sample usage of engines (stub, not live logic yet) ---
   if(structure.BullishBOS(symbol, tf) &&
      liquidity.SweepLow(symbol, tf) &&
      imbalance.BullishFVG(symbol, tf) &&
      pressure.BullishPressure(symbol, tf) )
     {
      double lot = risk.CalculateLot(1,30,AccountInfoDouble(ACCOUNT_BALANCE));
      trade.LongEntry(symbol, lot, 100, 200);
      Telemetry::Event("LONG ENTRY SIGNAL");
      VisualDebug::DrawEntry(TimeCurrent(), SymbolInfoDouble(symbol,SYMBOL_BID), true);
     }
   // --- end stub ---
  }
//+------------------------------------------------------------------+
