---
layout:     post
title:      "WebAudio tutorial, explained with images"
author:     "eridem"
featured-image: img/featured/2015-08-12-webaudio-tutorial-explained-with-images.jpg
permalink:  webaudio-tutorial-explained-with-images
external: http://blog.loadimpact.com/blog/web-development/webaudio_explained/
---

*Note: please note that the examples on this post may not use the best JavaScript coding practices, such as save variables on the global context. It is done this way for easy understanding, and the writer recommends to encapsulate most of the examples using OO approach. Get the code of this tutorial [on here](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_01.png): [https://github.com/eridem/webaudio-tutorial-explained-with-images](https://github.com/eridem/webaudio-tutorial-explained-with-images)*

# Introduction

The ```WebAudio``` API is a high-level JavaScript API for processing and synthesizing audio in web applications. The actual processing will take place underlying implementation, such as Assembly, C, C++.

The API consists on a graph, which redirect single or multiple input ```Sources``` into a ```Destination```. The API will offer us different ```AudioNodes``` which can be concatenated and are used to apply filters or modify the outputs of the previous ones. The graph is represented by an interface called ```AudioContext```, which will help us to recreate the sources, the nodes and redirect the result to the ```Destination```.

Most of the nodes can be connected to a next one with few exceptions. Those nodes are dead ends, such as the ```Destination```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_01.png)

Code example for the image without sources.

```javascript
// Browser support
window.AudioContext = window.AudioContext || window.webkitAudioContext;

// Initialize audio context
var context = new AudioContext();

// Destination
var destination = context.destination;
```

# Sources

```Sources``` can be obtained in different ways, such as streaming, audio tag, oscillator, microphone, MIDI keyboards and so on. They are the entry points to the ```WebContext``` graph.

## Buffers and Streams

To inject data into out nodes, we could fill ```Buffers``` of data. The buffers speed up the processing of the audio when they are fetched from the server and they can be reused from different ```AudioNodes```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_02.png)

```Streams``` give us the possibility to have a constant flow of information. For instance, from an audio cast in a server or from the microphone in our computer.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_03.png)

# Fetching from XMLHttpRequest

We can fetch our sources from a server and save them to buffers. We will use an ```XMLHttpRequest``` object, setting up the ```responseType``` to ```arraybuffer``` and handling the ```onload``` event.

Using the ```decodeAudioData``` method helper from the ```WebContext``` will create a buffer from the response.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_04.png)

By code:

```javascript
// Browser support
window.AudioContext = window.AudioContext || window.webkitAudioContext;
// Initialize audio context
var context = new AudioContext();
// Sound Url
var soundUrl = "http://........";
// Buffer
var soundBuffer;

// Create request to load the song from address
var request = new XMLHttpRequest();
request.open("GET", soundUrl, true);
// Obtain as buffer array
request.responseType = "arraybuffer";

// Send request and save it
request.onload = function() {
    context.decodeAudioData(
        request.response,
        function(buffer) {
            soundBuffer = buffer;
        }
    );
};
request.send();
```

After fetching the buffer, we can create an ```AudioBufferSourceNode``` and attach the buffer to it. We can use the ```createBufferSource``` helper function on the ```WebContext``` for this propose.

The method ```connect``` from the ```AudioNode``` will help us to connect the nodes between each other and to the ```Destination```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_05.png)

Modifying the previous example:

```javascript
// Code from previous example ......

// Play sound
function play() {
    // Create AudioBufferSource and attach buffer
    var source = context.createBufferSource();
    source.buffer = soundBuffer;

    // Play the source
    source.start(0);
}

// Send request and save it
request.onload = function () {
    context.decodeAudioData(
        request.response,
        function (buffer) {
            soundBuffer = buffer;
            play();
        }
    );
};

// Code from previous example ......
```

# Using audio from ```<audio>tag</audio>```
```

We can use the tag ```<audio></audio> to fetch the sound we want to load. Using the ```createMediaElementSource``` helper function from the ```WebContext```, we can create a ```MediaElementAudioSourceNode``` to load the sound.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_06.png)

Firstly, we need to define the audio tag:

```html
<audio id="myAudioTag" controls>
  <source src="music.ogg" type='audio/ogg; codecs=vorbis'/>
</audio>
```

And then, obtain the tag from JavaScript and use it on the ```createMediaElementSource```:

```javascript
// Browser support
window.AudioContext = window.AudioContext || window.webkitAudioContext;
// Initialize audio context
var context = new AudioContext();

// Get the element from the DOM
var audioElement = document.getElementById('myAudioTag');

// Create a node based on the element
source = context.createMediaElementSource(audioElement);
source.connect(context.destination);
```

Because the audio is based on the ```<audio></audio>``` tag, we will be able to use the HTML controls to play, pause and stop the sound.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_07.png)

# Creating audio from oscillator

Previously, we were loading sounds from resources. Using the ```oscillator```, we can create different sounds based on a frequency.

The ```createOscillator``` helper function from the ```WebContext``` will return for us an ```OscillatorNode```. There are at least two important things we can modify from the ```OscillatorNode```:

*   ```Frequency``` in Hertz of the periodic waveform.

*   ```Type```, which is the shape of the periodic waveform.

To understand more about Oscillators, we recommended visiting [this page](http://middleearmedia.com/web-audio-api-oscillators/).

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_08.png)

Using code:

```javascript
// Browser support
window.AudioContext = window.AudioContext || window.webkitAudioContext;
// Initialize audio context
var context = new AudioContext();

// Create oscillator and set up attributes
var oscillator = context.createOscillator();
oscillator.frequency.value = 261.63;
oscillator.type = "square";

// Attach to destination
oscillator.connect(context.destination);

// Play oscillator
oscillator.start(0);
```

The interesting part of the oscillator is the combination of them to recreate sounds. In the following example, we create three oscillators with different frequencies.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_09.png)

The code will be very similar to the previous one — the difference being that we used 3 frequencies.

```javascript
// Browser support
window.AudioContext = window.AudioContext || window.webkitAudioContext;
// Initialize audio context
var context = new AudioContext();

var frequencies = [261.63, 329.63, 392];
for (var i in frequencies) {
    // Create oscillator and set up attributes
    var oscillator = context.createOscillator();
    oscillator.frequency.value = frequencies[i];
    oscillator.type = "square";

    // Attach to destination
    oscillator.connect(context.destination);

    // Play oscillator
    oscillator.start(0);
}
```

# Volume

When processing sounds, it’s very important to control the volume between different inputs. We could combine sounds with different volume, fade the volume in or out and other techniques.

The ```GainNode``` helps us have extra control to the sound of other nodes. As we saw before on the oscillator example, we could have different nodes pointing to the same ```Destination```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_10.png)

Creating ```GainNodes``` between the ```Sources``` and the ```Destination```, we can add extra control thought the volume. Use the ```createGain``` helper function from the ```WebContext```, we can create a new ```GainNode```.

We will connect the ```Sources``` to the ```GainNodes``` and the ```GainNodes``` to the ```Destination```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_11.png)

Supposing we have a node created from any of the examples previously created, using the ```gain.value``` attribute of this ```WebNode```, we can control the volume.

```javascript
// Using one of the nodes of the previous examples
var webNode = getNodeFromPreviousExample();

// Create new GainNode
var gainNode = context.createGain();

// Attach webNode -> gainNode -> destination
webNode.connect(gainNode);
gainNode.connect(context.destination);

// Control the volume
gainNode.gain.value = 0.4;
```

# Analyzer and visualization

One of the interesting parts on the ```WebAudio``` is the capability to obtain information in real time about a source. This could be very useful to create representations of the sound.

Using the ```createAnalyser``` helper function from the ```AudioContext``` we can create an ```AnalyserNode```. An ```AnalyserNode``` is a ```WebNode``` that helps us obtain real-time frequency and time-domain analysis information. Check out [this page](https://webaudio.github.io/web-audio-api/#the-analysernode-interface) to find some of the attributes we can modify for a custom analysis.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_12.png)

If we want to recollect the information from the analyser – which is a very common situation – we can use the ```createScriptProcessor``` helper function in order to create a ```ScriptProcessorNode```. This node will notify, passing as a function, when new information has been processed if we connect it to the ```AnaliserNode```.

![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_13.png)

Using these two ```AudioNodes```, we are able to process information. Then, we could use other APIs (like ```Canvas```) in order to create different animations. The following example will show how to obtain information and use a dummy function called ```showVisuals``` that the reader can personalize to create animations based on the audio.

```javascript
// Create your visual function on here
// to be called for each analysed data
function showVisuals(array) {
    // ... your imagination ...
}

// Using one of the nodes of the previous examples
var webNode = getNodeFromPreviousExample();

// Create script processor
var sourceJs = context.createScriptProcessor(2048, 1, 1);

// Create analyzer
var analyser = context.createAnalyser();
analyser.smoothingTimeConstant = 0.6;
analyser.fftSize = 512;

// Create chain [Source -> Analyzer -> SourceJS]
source.connect(analyser);
analyser.connect(sourceJs);

// Connect to output (music and script processor)
source.connect(context.destination);
sourceJs.connect(context.destination);
// Use script processor to obtain info related with the frequency
sourceJs.onaudioprocess = function(e) {
    var array = new Uint8Array(analyser.frequencyBinCount);
    analyser.getByteFrequencyData(array);
    showVisuals(array);
};
```

# Inspiration

Now that we know the basics of the ```WebAudio```, take a chance to read in-depth with the official documentation. Also, here are some examples of ```WebAudio``` on the Internet.

| [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_01.png)](https://chromium.googlecode.com/svn/trunk/samples/audio/shiny-drum-machine.html) | [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_02.png)](http://www.cappel-nord.de/webaudio/acid-defender/) |
| [WebAudio Drum Machine](https://chromium.googlecode.com/svn/trunk/samples/audio/shiny-drum-machine.html) | [Acid Defender](http://www.cappel-nord.de/webaudio/acid-defender/) |
| [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_03.png)](http://dinahmoelabs.com/plink) | [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_04.png)](http://aikelab.net/websynth/) |
| [Plink](http://dinahmoelabs.com/plink) | [Oscillator](http://aikelab.net/websynth/) |
| [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_05.png)](http://airtightinteractive.com/demos/js/reactive/) | [![Web Audio Tutorial Explained with images](/img/posts/2015-08-12-webaudio-tutorial-explained-with-images/WebAudioWithImages_eg_06.png)](http://triggerrally.com/drive?track=preview.json&car=car1.json) |
| [Loop Waveform Visualizer](http://airtightinteractive.com/demos/js/reactive/) | [Trigger Rally](http://triggerrally.com/drive?track=preview.json&car=car1.json) |
