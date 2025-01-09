remove the following line from BUILD.gn of webrtc/src/sdk/BUILD.gn after patches are applied.
`"../pc:peerconnection",`

in libmediasoupclient/src/ortc.cpp

change `cricket::CodecParameterMap` to `webrtc::CodecParameterMap`

(patches welcome)
 