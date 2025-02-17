#import <Foundation/Foundation.h>
#import <Consumer.hpp>
#import <WebRTC/RTCMediaStreamTrack.h>
#import <WebRTC/RTCRtpReceiver.h>
//#import <WebRTC/RTCPeerConnectionFactory.h>
#import "ConsumerWrapper.hpp"
#import "ConsumerListenerAdapter.hpp"
#import "ConsumerListenerAdapterDelegate.h"
#import "ConsumerWrapperDelegate.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface ConsumerWrapper () <ConsumerListenerAdapterDelegate> {
	mediasoupclient::Consumer *_consumer;
	ConsumerListenerAdapter *_listenerAdapter;
	RTCRtpReceiver *_rtpReceiver;
}
@property(nonatomic, nonnull, readwrite) RTCMediaStreamTrack *track;
@end


@implementation ConsumerWrapper

- (instancetype)initWithConsumer:(mediasoupclient::Consumer *)consumer
    mediaStreamTrack:(RTCMediaStreamTrack *)track
	rtpReceiver:(RTCRtpReceiver *)receiver
	listenerAdapter:(ConsumerListenerAdapter *)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_consumer = consumer;
		_track = track;
		_rtpReceiver = receiver;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;
	}

	return self;
}

- (void)dealloc {
	delete _consumer;
	delete _listenerAdapter;
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_consumer->GetId().c_str()];
}

- (NSString *_Nonnull)producerId {
	return [NSString stringWithUTF8String:_consumer->GetProducerId().c_str()];
}

- (NSString *_Nonnull)localId {
	return [NSString stringWithUTF8String:_consumer->GetLocalId().c_str()];
}

- (BOOL)closed {
	return _consumer->IsClosed() == true;
}

- (BOOL)paused {
	return _consumer->IsPaused() == true;
}

- (NSString *_Nonnull)kind {
	return [NSString stringWithUTF8String:_consumer->GetKind().c_str()];
}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_consumer->GetAppData().dump().c_str()];
}

- (NSString *_Nonnull)rtpParameters {
	return [NSString stringWithUTF8String:_consumer->GetRtpParameters().dump().c_str()];
}

- (NSString *_Nonnull)stats {
	return [NSString stringWithUTF8String:_consumer->GetStats().dump().c_str()];
}

- (void)pause {
	_consumer->Pause();
}

- (void)resume {
	_consumer->Resume();
}

- (void)close {
	_consumer->Close();
}

- (NSString *_Nullable)getStatsWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return nil;
}

- (RTCRtpReceiver *)rtpReceiver {
	return _rtpReceiver;
}

#pragma mark - ProducerListenerAdapterDelegate methods

- (void)onTransportClose:(ConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

@end
