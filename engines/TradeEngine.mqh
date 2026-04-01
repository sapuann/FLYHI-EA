#ifndef __TRADE_ENGINE_MQH__
#define __TRADE_ENGINE_MQH__

class TradeEngine
{
private:
   int  filling_mode_buy;
   int  filling_mode_sell;
   bool init_filling_mode;

   // Ambil filling mode yang broker tetapkan untuk symbol (paling selamat)
   int GetSymbolFillingMode(const string symbol)
   {
      int mode = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);

      // Safety fallback (jarang diperlukan)
      if(mode != ORDER_FILLING_FOK && mode != ORDER_FILLING_IOC && mode != ORDER_FILLING_RETURN)
         mode = ORDER_FILLING_RETURN;

      return mode;
   }

   void InitFillingModes(const string symbol)
   {
      if(init_filling_mode) return;

      int mode = GetSymbolFillingMode(symbol);
      filling_mode_buy  = mode;
      filling_mode_sell = mode;

      init_filling_mode = true;

      Print("TradeEngine init filling mode for ", symbol, ": ", GetFillingModeName(mode));
   }

public:
   TradeEngine()
   : filling_mode_buy(ORDER_FILLING_RETURN),
     filling_mode_sell(ORDER_FILLING_RETURN),
     init_filling_mode(false)
   {}

   // --- Long (BUY) entry ---
   bool LongEntry(const string symbol, double lots, double sl, double tp, int magic)
   {
      InitFillingModes(symbol);

      MqlTradeRequest request;
      MqlTradeResult  result;
      ZeroMemory(request);
      ZeroMemory(result);

      request.action       = TRADE_ACTION_DEAL;
      request.symbol       = symbol;
      request.volume       = lots;
      request.type         = ORDER_TYPE_BUY;
      request.price        = SymbolInfoDouble(symbol, SYMBOL_ASK);
      request.sl           = sl;
      request.tp           = tp;
      request.magic        = magic;
      request.deviation    = 20;
      request.type_filling = filling_mode_buy;

      if(!OrderSend(request, result))
      {
         Print("OrderSend(BUY) failed: retcode=", result.retcode,
               " filling=", GetFillingModeName(request.type_filling));
         return false;
      }

      if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
      {
         Print("Buy order placed, ticket: ", result.order);
         return true;
      }

      Print("OrderSend(BUY) rejected: retcode=", result.retcode,
            " filling=", GetFillingModeName(request.type_filling));
      return false;
   }

   // --- Short (SELL) entry ---
   bool ShortEntry(const string symbol, double lots, double sl, double tp, int magic)
   {
      InitFillingModes(symbol);

      MqlTradeRequest request;
      MqlTradeResult  result;
      ZeroMemory(request);
      ZeroMemory(result);

      request.action       = TRADE_ACTION_DEAL;
      request.symbol       = symbol;
      request.volume       = lots;
      request.type         = ORDER_TYPE_SELL;
      request.price        = SymbolInfoDouble(symbol, SYMBOL_BID);
      request.sl           = sl;
      request.tp           = tp;
      request.magic        = magic;
      request.deviation    = 20;
      request.type_filling = filling_mode_sell;

      if(!OrderSend(request, result))
      {
         Print("OrderSend(SELL) failed: retcode=", result.retcode,
               " filling=", GetFillingModeName(request.type_filling));
         return false;
      }

      if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
      {
         Print("Sell order placed, ticket: ", result.order);
         return true;
      }

      Print("OrderSend(SELL) rejected: retcode=", result.retcode,
            " filling=", GetFillingModeName(request.type_filling));
      return false;
   }

   // Utility: Untuk debug, balik nama filling mode
   string GetFillingModeName(int m)
   {
      switch(m)
      {
         case ORDER_FILLING_FOK:    return "ORDER_FILLING_FOK";
         case ORDER_FILLING_IOC:    return "ORDER_FILLING_IOC";
         case ORDER_FILLING_RETURN: return "ORDER_FILLING_RETURN";
         default:                   return "UNKNOWN";
      }
   }
};

#endif