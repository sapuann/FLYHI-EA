// FLYHI PROMPT: TradeEngine
// Manage trade entry, exit, partial close, move SL/TP.

#ifndef __TRADE_ENGINE_MQH__
#define __TRADE_ENGINE_MQH__

class TradeEngine
{
public:
    // Basic long entry - real MT5 order send (SL/TP/Magic dinamik)
    bool LongEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        ZeroMemory(result);

        request.action   = TRADE_ACTION_DEAL;
        request.symbol   = symbol;
        request.volume   = lots;
        request.type     = ORDER_TYPE_BUY;
        request.price    = SymbolInfoDouble(symbol, SYMBOL_ASK);
        request.sl       = sl;
        request.tp       = tp;
        request.magic    = magic;
        request.deviation= 20;
        request.type_filling = ORDER_FILLING_FOK;

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

    // Basic short entry - akan tambah selepas ini (dummy dahulu)
    bool ShortEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        return false;
    }
};

#endif
