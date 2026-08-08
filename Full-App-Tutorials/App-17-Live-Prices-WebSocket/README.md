# App 17: Live Prices (WebSocket) — Complete Tutorial

> Realtime ticker UI — crypto/stocks style. Teaches sockets, reconnect, throttling.

**Time:** 12–18 hours · **Min level:** 08  
**Package:** `web_socket_channel`

## Features

- [ ] Connect to public WS (or mock stream)  
- [ ] Show price list updating live  
- [ ] Connection status chip (connected / reconnecting / offline)  
- [ ] Auto-reconnect with backoff  
- [ ] Throttle UI updates (e.g. max 10/sec)  
- [ ] Detail sparkline (optional list of last N prices)  

## Mock mode (always implement first)

```dart
Stream<double> mockPrices() async* {
  var p = 100.0;
  final r = Random();
  while (true) {
    await Future.delayed(const Duration(milliseconds: 200));
    p += r.nextDouble() - 0.5;
    yield p;
  }
}
```

## Real WS shape

```dart
final channel = WebSocketChannel.connect(Uri.parse(url));
channel.stream.listen(onData, onError: onError, onDone: scheduleReconnect);
channel.sink.add(subscribeMessage);
```

## Architecture

```
data/price_socket_client.dart
domain/price_tick.dart
providers/ticker_provider.dart
pages/ticker_page.dart
```

## Reconnect policy

1. On done/error → wait 1s, 2s, 4s… cap 30s  
2. Reset backoff on successful message  
3. Cancel subscription on dispose  

## Test script

1. Mock stream moves prices  
2. Toggle airplane → status offline → reconnect  
3. Dispose page → no more updates / no leaks  

## Portfolio blurb

> Live market-style ticker with WebSocket client, reconnect backoff, and throttled UI updates.
