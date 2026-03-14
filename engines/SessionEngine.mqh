// FLYHI PROMPT: SessionEngine
// Detect session: Asia, London, New York.

#ifndef __SESSION_ENGINE_MQH__
#define __SESSION_ENGINE_MQH__

enum MarketSession { SESSION_ASIA, SESSION_LONDON, SESSION_NY, SESSION_UNKNOWN };

class SessionEngine
{
public:
   MarketSession Detect(const datetime ts)
   {
      // TODO: Implement session detection based on time
      return SESSION_UNKNOWN;
   }
};

#endif
