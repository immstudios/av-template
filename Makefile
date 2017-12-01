INPUTS   := $(wildcard ./build/*.mov)
OUTPUTS  := $(patsubst ./build/%.mov,./dist/%.mov,$(INPUTS))
PREVIEWS := $(patsubst ./build/%.mov,./preview/%.mp4,$(INPUTS))

GOP_SIZE := 80

.PHONY : test

all: $(OUTPUTS)

./dist/%.mov : ./build/%.mov
	ffmpeg -y -i "$<" -c:v copy \
		-filter:a volume="$(shell ./scripts/gaincorrect.py $<)dB" \
		-c:a pcm_s16le \
		-map_metadata -1 \
		-video_track_timescale 25 \
		"$@"

./previews/%.mov : ./dist/%.mp4
	ffmpeg -y -i "$<" \
		-c:v libx264
		-b:v 4000k \
		-c:a libfdk_aac \
		-b:a 128k \
		-g $(GOP_SIZE) -x264opts keyint=$(GOP_SIZE):min-keyint=$(GOP_SIZE):no-scenecut \
		"$@"

test :
	@for f in $(OUTPUTS); do \
		echo "$$f : $$(./scripts/gaincorrect.py $$f)"; \
	done;
