//+------------------------------------------------------------------+
//|                  FLYHI_EA                                        |
//| Modular MT5 EA for XAUUSD, multi-engine Copilot ready            |
//+------------------------------------------------------------------+

input double   RiskPerTrade = 1.0;     // Risk per trade (%)
input int      SL_Pips      = 30;      // Stop Loss in pips
input int      TP_Pips      = 60;      // Take Profit in pips
input int      MagicNumber  = 123456;  // EA trade ID

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

   // --- Logic: Entry Long jika Bullish BOS dikesan ---
   if(structure.BullishBOS(symbol, tf))
     {
      double lot = risk.CalculateLot(RiskPerTrade, SL_Pips, AccountInfoDouble(ACCOUNT_BALANCE));
      double sl  = SymbolInfoDouble(symbol, SYMBOL_BID) - SL_Pips * _Point;
      double tp  = SymbolInfoDouble(symbol, SYMBOL_BID) + TP_Pips * _Point;
      if(trade.LongEntry(symbol, lot, sl, tp, MagicNumber))
        {
         Logger::Info("Long entry placed!");
         Telemetry::Event("LONG ENTRY SIGNAL PLACED");
        }
      else
        {
         Logger::Error("Failed to place long entry.");
        }
     }

   // --- Logic: Entry Short jika Bearish BOS dikesan ---
   if(structure.BearishBOS(symbol, tf))
     {
      double lot = risk.CalculateLot(RiskPerTrade, SL_Pips, AccountInfoDouble(ACCOUNT_BALANCE));
      double sl  = SymbolInfoDouble(symbol, SYMBOL_BID) + SL_Pips * _Point;
      double tp  = SymbolInfoDouble(symbol, SYMBOL_BID) - TP_Pips * _Point;
      if(trade.ShortEntry(symbol, lot, sl, tp, MagicNumber))
        {
         Logger::Info("Short entry placed!");
         Telemetry::Event("SHORT ENTRY SIGNAL PLACED");
        }
      else
        {
         Logger::Error("Failed to place short entry.");
        }
     }

   // --- Trailing stop untuk semua order ---
   TrailAllOrders();
  }
//+------------------------------------------------------------------+
//| Trail all BUY & SELL orders for current symbol                   |
//+------------------------------------------------------------------+
void TrailAllOrders()
  {
   double trailPips = 20; // Tetapan trailing dalam pips, boleh ubah jika mahu
   double trail = trailPips * _Point;

   for(int i=0;i<PositionsTotal();i++)
     {
      if(PositionGetSymbol(i)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=MagicNumber) continue;

      ulong   ticket   = PositionGetTicket(i);
      double  openPrice= PositionGetDouble(POSITION_PRICE_OPEN);
      double  sl       = PositionGetDouble(POSITION_SL);
      double  tp       = PositionGetDouble(POSITION_TP);
      double  price    = 0.0;
      double  newSL    = 0.0;

      int type = PositionGetInteger(POSITION_TYPE);

      if(type==POSITION_TYPE_BUY)
        {
         price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         if(price - openPrice > trail)
           {
            newSL = price - trail;
            if(sl < newSL || sl == 0)
              {
               MqlTradeRequest req={0};
               MqlTradeResult res={0};
               req.action = TRADE_ACTION_SLTP;
               req.symbol = _Symbol;
               req.position = ticket;
               req.sl = NormalizeDouble(newSL, _Digits);
               req.tp = tp;
               req.magic = MagicNumber;
               OrderSend(req, res);
              }
           }
        }
      else if(type==POSITION_TYPE_SELL)
        {
         price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         if(openPrice - price > trail)
           {
            newSL = price + trail;
            if(sl > newSL || sl == 0)
              {
               MqlTradeRequest req={0};
               MqlTradeResult res={0};
               req.action = TRADE_ACTION_SLTP;
               req.symbol = _Symbol;
               req.position = ticket;
               req.sl = NormalizeDouble(newSL, _Digits);
               req.tp = tp;
               req.magic = MagicNumber;
               OrderSend(req, res);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
