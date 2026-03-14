// FLYHI PROMPT: VisualDebug
// Draw session, swings, FVG, entry/exit on chart for analysis

#ifndef __VISUAL_DEBUG_MQH__
#define __VISUAL_DEBUG_MQH__

class VisualDebug
{
public:
    // Draw session boxes (Asia, London, NY)
    static void DrawSession(const datetime start, const datetime end, const color clr)
    {
        // TODO: Drawing logic here Copilot
    }
    // Draw swing points (high/low)
    static void DrawSwing(const datetime ts, double price, const color clr)
    {
        // TODO: Drawing logic here Copilot
    }
    // Draw FVG zones
    static void DrawFVG(const datetime start, const datetime end, double top, double bottom, const color clr)
    {
        // TODO: Drawing logic here Copilot
    }
    // Draw entry/exit arrow
    static void DrawEntry(const datetime ts, double price, bool isLong)
    {
        // TODO: Drawing logic here Copilot
    }
};

#endif
