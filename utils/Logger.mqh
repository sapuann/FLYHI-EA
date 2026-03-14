// FLYHI PROMPT: Logger
// Simple logging utility for FLYHI EA

#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

class Logger
{
public:
    static void Info(const string msg)
    {
        Print("[INFO] ", msg);
    }
    static void Warn(const string msg)
    {
        Print("[WARN] ", msg);
    }
    static void Error(const string msg)
    {
        Print("[ERROR] ", msg);
    }
};

#endif
