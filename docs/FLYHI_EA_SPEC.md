# FLYHI EA System Flow & Specification

## System Flow

On every tick:

1. Detect market regime/session (Asia, London, NY)
2. Detect structure (HH HL LH LL, BOS)
3. Detect liquidity sweep
4. Detect imbalance (FVG / displacement)
5. Evaluate price pressure
6. If confluence present → execute trade

## Confluence Rules

- Entry requires pass from all active modules (can toggle via EA input)
- TradeEngine manages entry/exit/partial/SL-TP logic

## Target

- Pair: XAUUSD (gold)
- Main TF: M5

## Debug

- Telemetry, ReplayAnalyzer, VisualDebug fully integrated for audit/tracking
