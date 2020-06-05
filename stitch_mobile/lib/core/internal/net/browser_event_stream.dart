// import {
//   BaseEventStream,
//   Event,
//   StitchClientError,
//   StitchClientErrorCode, 
//   StitchEvent
// } from "mongodb-stitch-core-sdk";

import 'dart:convert';

import 'package:stitch_core/stitch_client_exception.dart';
import 'package:stitch_core/stitch_core.dart' show BaseEventStream, Event;

import 'package:http/http.dart' as http;

class BrowserEventStream extends BaseEventStream<BrowserEventStream> {
  http.StreamedResponse streamedResponse;
  // final Function(Error) onOpenError;
  // bool _openedOnce = true;

  BrowserEventStream(
    this.streamedResponse,
    // void Function(EventSourceEventStream stream) onOpen,
    // void Function(Error error) onOpenError,
    [Future<BrowserEventStream> Function() reconnecter]
  ) :
    // _streamedResponse = streamedResponse,
    // _onOpenError = onOpenError,
    super(reconnecter) {
      print('browser event stream.....');
    this.reset();
  }

  void open() {
    if (this.closed) {
      throw new StitchClientException(StitchClientExceptionCode.streamClosed);
    }
  }

  void afterClose() async {
    // TODO: close stream properly
    await this.streamedResponse.stream.drain();
  }

  onReconnect(BrowserEventStream next) {
    this.streamedResponse = next.streamedResponse;
    this.reset();
    next.events.addAll(this.events);
    this.events = next.events;
  }

  void reset() {
    print('reset');
    streamedResponse.stream.listen((List<int> data) {
      print('we got something...');
      print(utf8.decode(data));
      this.events.add(new Event(Event.MESSAGE_EVENT, utf8.decode(data)));
      this.poll();
    });

    // streamedResponse. = e => {
    //   if (e instanceof MessageEvent) {
    //     this.lastErr = e.data;
    //     this.events.push(new Event(StitchEvent.ERROR_EVENT_NAME, this.lastErr!));
    //     this.close();
    //     this.poll();
    //     return;
    //   }
    //   // if (!this.openedOnce) {
    //   //   this.close();
    //   //   this.onOpenError(new Error("event source failed to open and will not reconnect; check network log for more details"));
    //   //   return;
    //   // }
    //   // this.evtSrc.close();
    //   this.reconnect(e);
    // }
  }
}
