# Subtitles-validator

## In a nutshell

This (very simple) script validates a few rules for a subtitle file:

* each subtitle should have its *start* marker set before the *end* marker.
* each subtitle should start *after* the end of the previous one.


## Supported subtitle file formats

* .srt

## Example of a .srt file

	1
	00:00:06,244 --> 00:00:09,004
	The public has a very romantic idea of what wine's about.   

	2
	00:00:09,984 --> 00:00:14,373
	They think it's some little guy, like me, working in the cellar,

	3
	00:00:14,373 --> 00:00:16,741
	working in the vineyard, bringing the grapes in. 
