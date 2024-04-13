# AI Hair Styler
 
Main project files in `/lib/`

`flutter build apk --release --split-debug-info --build-number --build-name="1.0.0"`

## Commiting / Workflows

The linter / formatter is there to make the code fit within guidelines for readability.

- Find linting issues `dart analyze --fatal-infos` or apply them automagically `dart fix --apply`
- Format files `dart format .`
- Make sure your build actually compiles before pushing!

## Classification

Help with classifing [STYLES] and [COLORS] in config.json. Images located in input/face

Follow the format of:
- `f/m`-`style`-`#`

Current styles (need to add more, somewhat broadly to reduce confusion)
- short
- tall
- bangs
- dreads
- parted
- curly
- frizzy
- bald
- unknown `or` - (if you do not understand the style)
- hidden (if the style/color is unclear)
- tails (pigtails/ponytails?) make more clear
- flat (or another name for better description)

