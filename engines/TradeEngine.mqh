//+------------------------------------------------------------------+
//|                  TradeEngine.mqh                                 |
//| Handle trade execution for FLYHI EA (auto filling mode support)  |
//+------------------------------------------------------------------+
#ifndef __TRADE_ENGINE_MQH__
#define __TRADE_ENGINE_MQH__

class TradeEngine
{
public:
    // --- Long (BUY) entry function with auto filling mode ---
    bool LongEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action     = TRADE_ACTION_DEAL;
        request.symbol     = symbol;
        request.volume     = lots;
        request.type       = ORDER_TYPE_BUY;
        request.price      = SymbolInfoDouble(symbol, SYMBOL_ASK);
        request.sl         = sl;
        request.tp         = tp;
        request.magic      = magic;
        request.deviation  = 20;

        // === [FILLING MODE AUTODETECT] ===
        int fillingMode = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
        if(fillingMode == ORDER_FILLING_FOK || fillingMode == ORDER_FILLING_IOC || fillingMode == ORDER_FILLING_RETURN)
            request.type_filling = fillingMode;
        else
            request.type_filling = ORDER_FILLING_IOC; // fallback universal

        if(!OrderSend(request, result))
        {
            Print("OrderSend failed: ", result.retcode);
            return false;
        }

        if(result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Buy order placed, ticket: ", result.order);
            return true;
        }
        else
        {
            Print("Order failed, retcode: ", result.retcode);
            return false;
        }
    }

    // --- Short (SELL) entry function with auto filling mode ---
    bool ShortEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action     = TRADE_ACTION_DEAL;
        request.symbol     = symbol;
        request.volume     = lots;
        request.type       = ORDER_TYPE_SELL;
        request.price      = SymbolInfoDouble(symbol, SYMBOL_BID);
        request.sl         = sl;
        request.tp         = tp;
        request.magic      = magic;
        request.deviation  = 20;

        // === [FILLING MODE AUTODETECT] ===
        int fillingMode = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
        if(fillingMode == ORDER_FILLING_FOK || fillingMode == ORDER_FILLING_IOC || fillingMode == ORDER_FILLING_RETURN)
            request.type_filling = fillingMode;
        else
            request.type_filling = ORDER_FILLING_IOC; // fallback universal

        if(!OrderSend(request, result))
        {
            Print("OrderSend failed: ", result.retcode);
            return false;
        }

        if(result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Sell order placed, ticket: ", result.order);
            return true;
        }
        else
        {
            Print("Order failed, retcode: ", result.retcode);
            return false;
        }
    }
};

#endif
