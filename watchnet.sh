#!/bin/sh

# ネットワークインターフェース（有線: eth0, Wi-Fi: wlan0）
IFACE="eth0"

echo "通信量モニタ開始（Ctrl+C で終了）"
echo "================================="

# 初期値を取得
RX_START=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_START=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

RX_TOTAL=0
TX_TOTAL=0

RX_PREV=$RX_START
TX_PREV=$TX_START

while true; do
  sleep 1  # 1秒ごとに更新

  # 現在の送受信バイト数を取得
  RX_NOW=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
  TX_NOW=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

  # 1秒間の通信量を計算
  RX_DIFF=$((RX_NOW - RX_PREV))
  TX_DIFF=$((TX_NOW - TX_PREV))

  # 合計通信量を加算
  RX_TOTAL=$((RX_TOTAL + RX_DIFF))
  TX_TOTAL=$((TX_TOTAL + TX_DIFF))

  # 数値を見やすく変換（KBやMB）
  RX_HUMAN=$(numfmt --to=iec $RX_DIFF)B
  TX_HUMAN=$(numfmt --to=iec $TX_DIFF)B
  RX_TOTAL_HUMAN=$(numfmt --to=iec $RX_TOTAL)B
  TX_TOTAL_HUMAN=$(numfmt --to=iec $TX_TOTAL)B

  # 結果を表示
  echo "受信: $RX_HUMAN, 送信: $TX_HUMAN | 合計 受信: $RX_TOTAL_HUMAN, 送信: $TX_TOTAL_HUMAN"

  # 次の比較用に現在の値を保存
  RX_PREV=$RX_NOW
  TX_PREV=$TX_NOW
done
