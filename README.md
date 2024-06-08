# VIDNA

An IDNA string library for converting internationalized domain names written in V


## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install fleximus.vidna
v install --git https://github.com/fleximus/vidna
```

## Usage

To use `vidna` in order to convert domain names

```v
import fleximus.vidna

fn main() {
	input := 'café'
	conv  := idna.to_ascii(input)
	conv2 := idna.to_unicode(conv)

	println("$input converts to $conv and back again to $conv2"
}
```

## License

MIT
