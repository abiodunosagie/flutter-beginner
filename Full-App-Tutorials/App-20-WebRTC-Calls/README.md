# App 20: WebRTC Voice/Video Calls — Complete Tutorial

> 1:1 calls. Senior-level signal. Hard but structured.

**Time:** 25–40 hours · **Min level:** 11 + Chat  
**Stack:** `flutter_webrtc` + signaling (Firebase/Supabase/socket server)

## Concepts

1. **Signaling** — exchange SDP offers/answers + ICE candidates (not media)  
2. **STUN/TURN** — NAT traversal (TURN needed on hard networks)  
3. **PeerConnection** — actual media path  

## Features (MVP voice)

- [ ] Call button from chat thread  
- [ ] Ringing / in-call / ended states  
- [ ] Mute  
- [ ] Signaling via Firestore docs `calls/{id}`  
- [ ] Cleanup on hang up  

## Signaling sketch

```
Caller creates call doc { offer, status: ringing }
Callee answers { answer }
Both write iceCandidates subcollection
On end: status ended, delete candidates
```

## Build order

1. Read flutter_webrtc example  
2. Signaling only with fake SDP logs  
3. Local mic preview  
4. Remote stream render  
5. Integrate with Chat user ids  

## Honesty

WebRTC breaks on bad networks; document TURN requirements.

## Portfolio blurb

> Experimental 1:1 WebRTC calling with Firestore signaling integrated into a chat model.

## Call state machine

```
idle → ringing_out → connecting → in_call → ended
idle → ringing_in → connecting → in_call → ended
any non-ended → ended (hangup / fail)
```

Encode with an enum and only allow legal transitions (same discipline as ride trips).

## Permissions

- iOS: `NSMicrophoneUsageDescription`, camera if video  
- Android: `RECORD_AUDIO`, `CAMERA`, Bluetooth for some devices  

## Minimal Firestore call doc

```json
{
  "callerId": "uidA",
  "calleeId": "uidB",
  "status": "ringing",
  "offer": { "sdp": "...", "type": "offer" },
  "answer": null,
  "createdAt": "..."
}
```

ICE candidates: `calls/{id}/candidates/{autoId}`.

## Failure modes to handle in UI

| Case | UX |
|------|-----|
| Callee offline | timeout → ended |
| Permission denied | settings CTA |
| ICE failed | "Connection failed" + hangup |
