#ifndef VISION_WEBP_CODEC_H
#define VISION_WEBP_CODEC_H

#include <climits>
#include <cstring>
#include <memory>
#include <webp/decode.h>
#include <webp/encode.h>

inline int vision_webp_dimensions(const ::Array<unsigned char> &source) {
	WebPBitstreamFeatures features;
	if (WebPGetFeatures((const uint8_t *)source->GetBase(), source->length, &features) != VP8_STATUS_OK ||
		features.width < 1 || features.height < 1 || features.width > 16383 || features.height > 16383 ||
		(uint64_t)features.width * features.height > 32000000) return 0;
	return features.width | (features.height << 16);
}

inline bool vision_webp_decode(const ::Array<unsigned char> &source, const ::Array<unsigned char> &pixels, int stride) {
	return WebPDecodeARGBInto((const uint8_t *)source->GetBase(), source->length,
		(uint8_t *)pixels->GetBase(), pixels->length, stride) != nullptr;
}

inline ::Array<unsigned char> vision_webp_encode(const ::Array<unsigned char> &rgba, int width, int height, float quality) {
	uint8_t *encoded = nullptr;
	size_t length = WebPEncodeRGBA((const uint8_t *)rgba->GetBase(), width, height, width * 4, quality, &encoded);
	std::unique_ptr<uint8_t, decltype(&WebPFree)> buffer(encoded, &WebPFree);
	if (length == 0 || length > INT_MAX) return null();
	::Array<unsigned char> bytes = ::Array_obj<unsigned char>::__new((int)length, (int)length);
	std::memcpy(bytes->GetBase(), buffer.get(), length);
	return bytes;
}

#endif
