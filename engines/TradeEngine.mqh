#ifndef __TRADE_ENGINE_MQH__
#define __TRADE_ENGINE_MQH__

class TradeEngine
{
private:
    // Cari filling mode yang disokong broker secara dinamik
    int GetSupportedFillingMode(const string symbol)
    {
        int try_modes[3] = {ORDER_FILLING_FOK, ORDER_FILLING_IOC, ORDER_FILLING_RETURN};

        for(int i=0; i<3; i++)
        {
            // Test if broker supports this mode
            if((SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE) & try_modes[i]) == try_modes[i])
                return try_modes[i];
        }
        // Fallback: try each mode directly
        MqlTradeRequest req={0};
        MqlTradeResult res={0};
        for(int i=0; i<3; i++)
        {
            ZeroMemory(req);
            ZeroMemory(res);
            req.action   = TRADE_ACTION_DEAL;
            req.symbol   = symbol;
            req.volume   = 0.01;
            req.type     = ORDER_TYPE_BUY;
            req.price    = SymbolInfoDouble(symbol, SYMBOL_ASK);
            req.type_filling = try_modes[i];
            req.deviation    = 20;

            if(OrderSend(req,res) && (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED))
                return try_modes[i];
        }
        // Jika semua gagal, fallback pakai IOC
        return ORDER_FILLING_IOC;
    }

    int filling_mode_buy;
    int filling_mode_sell;
    bool init_filling_mode;

    void InitFillingModes(const string symbol)
    {
        if(init_filling_mode) return;
        filling_mode_buy = GetSupportedFillingMode(symbol);
        filling_mode_sell = filling_mode_buy; // Seringnya sama untuk buy/sell
        init_filling_mode = true;
    }

public:
    TradeEngine() : filling_mode_buy(ORDER_FILLING_IOC), filling_mode_sell(ORDER_FILLING_IOC), init_filling_mode(false) {}

    // --- Long (BUY) entry function with robust filling mode ---
    bool LongEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        InitFillingModes(symbol);

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
        request.type_filling = filling_mode_buy;

        if(!OrderSend(request, result))
        {
            Print("OrderSend failed: ", result.retcode, " [", GetFillingModeName(request.type_filling), "]");
            return false;
        }

        if(result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Buy order placed, ticket: ", result.order);
            return true;
        }
        else
        {
            Print("Order failed, retcode: ", result.retcode, " [", GetFillingModeName(request.type_filling), "]");
            return false;
        }
    }

    // --- Short (SELL) entry function with robust filling mode ---
    bool ShortEntry(const string symbol, double lots, double sl, double tp, int magic)
    {
        InitFillingModes(symbol);

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
        request.type_filling = filling_mode_sell;

        if(!OrderSend(request, result))
        {
            Print("OrderSend failed: ", result.retcode, " [", GetFillingModeName(request.type_filling), "]");
            return false;
        }

        if(result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Sell order placed, ticket: ", result.order);
            return true;
        }
        else
        {
            Print("Order failed, retcode: ", result.retcode, " [", GetFillingModeName(request.type_filling), "]");
            return false;
        }
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
