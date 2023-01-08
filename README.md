# bot-speak

Well, when you want to talk.

## `speak.sh`
```
It's nice to be able to talk, isn't it?


USAGE:

 ./speak.sh [voice #] ["Thing to say"] [output file (optional)]

 -b   Batch Mode
      ./speak.sh [voice #] [file name] [output file (optional)]


Mimic3 is used to speak, so that must be running! Set the MIMIC3_URL environment
variable to its' http(s) location.
```

This script uses the [Sox sound processing program](https://sox.sourceforge.net/) and the [Mimic 3 TTS engine](https://mycroft-ai.gitbook.io/docs/mycroft-technologies/mimic-tts/mimic-3) from Mycroft AI.

