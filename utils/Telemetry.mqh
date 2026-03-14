// FLYHI PROMPT: Telemetry
// Event logging & audit trail for FLYHI EA

#ifndef __TELEMETRY_MQH__
#define __TELEMETRY_MQH__

class Telemetry
{
public:
    static void Event(const string msg)
    {
        Print("[TELEMETRY] ", msg);
    }
    static void Signal(const string label, double price)
    {
        Print("[SIGNAL] ", label, ": ", DoubleToString(price, 2));
    }
};

#endif
