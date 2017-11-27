INPUTS   := $(wildcard ./build/*.mov)
OUTPUTS  := $(patsubst ./build/%.mov,./dist/%.mov,$(INPUTS))
PREVIEWS := $(patsubst ./build/%.mov,./preview/%.mp4,$(INPUTS))

all: $(OUTPUTS)

./dist/%.mov : ./build/%.mov
	ffmpeg -i "$<" -c:v copy \
		-filter:a volume="$(shell ./scripts/gaincorrect.py $<)dB" \
		-c:a pcm_s16le \
		-map_metadata -1 \
		-video_track_timescale 25 \
		"$@"

./previews/%.mov : ./dist/%.mp4
	ffmpeg -i "$<" \
		-c:v libx264
		-b:v 4000k \
		-c:a libfdk_aac \
		-b:a 128k \
		-g 80 -x264opts keyint=80:min-keyint=80:no-scenecut \
		"$@"
