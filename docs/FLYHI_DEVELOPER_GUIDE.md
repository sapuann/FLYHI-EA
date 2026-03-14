   # FLYHI EA Developer Guide

   Ini adalah panduan developer untuk projek FLYHI EA (MetaTrader 5, XAUUSD).

   ## Struktur Projek

   ```
   docs/
      FLYHI_EA_SPEC.md
      FLYHI_DEVELOPER_GUIDE.md
   experts/
   engines/
   strategies/
   risk/
   utils/
   tests/
   ```

   ## Main Modules

   - **StructureEngine:** Kenalpasti swing high/low dan break of structure (BOS).
   - **LiquidityEngine:** Kesamaran likuiditi & sweep
   - **ImbalanceEngine:** FVG / fair value gap
   - **PressureEngine:** Tekanan/arus harga
   - **Session/Regime Engine:** Sesi Asia/London/NY & jenis market
   - **TradeEngine:** Pengurusan entry/exit order
   - **RiskManager:** Kalkulasi lot & pengurusan risiko
   - **Logger, Telemetry, ReplayAnalyzer, VisualDebug:** Debug, visual, audit

   ## Flow

   1. OnTick → Regime → Structure → Liquidity → Imbalance → Pressure
   2. Jika semua ‘OK’, EA buat entry
   3. RiskManager urus saiz & SL/TP
   4. Semua event/log/signal akan disalurkan ke Telemetry & VisualDebug untuk tracing

   ## Standard

   - Semua class/fail header pakai:
     ```cpp
     #ifndef __MODULE_MQH__
     #define __MODULE_MQH__
     ...
     #endif
     ```
   - Public method wajib ada komen fungsi
   - Logic modular & senang test

   ---

   **Lakar satu langkah dahulu sebelum teruskan, check setiap bahagian lepas satu.**
