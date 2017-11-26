INPUTS := $(wildcard ./_build/*.mov)
OUTPUTS := $(patsubst ./_build/%.mov,./_dist/%.mov,$(INPUTS))

all: $(OUTPUTS)

# Dist

./_dist/%.mov : ./_build/%.mov
	ffmpeg -i "$<" -c:v copy \
		-filter:a volume="$(shell ./scripts/gaincorrect.py $<)dB" \
		-c:a pcm_s16le \
		-map_metadata -1 \
		-video_track_timescale 25 \
		"$@"
