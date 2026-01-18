#!/bin/bash

# オーディオデバイス切替スクリプト
# 使用法: audio-switch.sh [sink|source]

type="${1:-sink}"

if [ "$type" = "sink" ]; then
    # 出力デバイス切替
    sinks=$(pactl list short sinks | awk '{print $1}')
    current=$(pactl get-default-sink)
    current_id=$(pactl list short sinks | grep "$current" | awk '{print $1}')

    # 次のデバイスを取得
    next=""
    found=0
    for sink in $sinks; do
        if [ $found -eq 1 ]; then
            next=$sink
            break
        fi
        if [ "$sink" = "$current_id" ]; then
            found=1
        fi
    done

    # 最後だったら最初に戻る
    if [ -z "$next" ]; then
        next=$(echo "$sinks" | head -n1)
    fi

    pactl set-default-sink "$next"

    # 通知
    name=$(pactl list sinks | grep -A1 "Sink #$next" | grep "Description:" | cut -d: -f2 | xargs)
    notify-send "出力デバイス" "$name" -i audio-speakers -t 2000

elif [ "$type" = "source" ]; then
    # 入力デバイス切替
    sources=$(pactl list short sources | grep -v monitor | awk '{print $1}')
    current=$(pactl get-default-source)
    current_id=$(pactl list short sources | grep "$current" | awk '{print $1}')

    # 次のデバイスを取得
    next=""
    found=0
    for source in $sources; do
        if [ $found -eq 1 ]; then
            next=$source
            break
        fi
        if [ "$source" = "$current_id" ]; then
            found=1
        fi
    done

    # 最後だったら最初に戻る
    if [ -z "$next" ]; then
        next=$(echo "$sources" | head -n1)
    fi

    pactl set-default-source "$next"

    # 通知
    name=$(pactl list sources | grep -A1 "Source #$next" | grep "Description:" | cut -d: -f2 | xargs)
    notify-send "入力デバイス" "$name" -i audio-input-microphone -t 2000
fi
