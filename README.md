# actionbuffer
[![Build Status](https://travis-ci.org/danielkalen/actionbuffer.svg?branch=master)](https://travis-ci.org/danielkalen/actionbuffer)
[![Coverage](.config/badges/coverage.png?raw=true)](https://github.com/danielkalen/actionbuffer)
[![Code Climate](https://codeclimate.com/github/danielkalen/actionbuffer/badges/gpa.svg)](https://codeclimate.com/github/danielkalen/actionbuffer)
[![NPM](https://img.shields.io/npm/v/actionbuffer.svg)](https://npmjs.com/package/actionbuffer)
[![NPM](https://img.shields.io/npm/dm/actionbuffer.svg)](https://npmjs.com/package/actionbuffer)

Push elements into a queue and invoke a callback with the queued elements after a timeout.

## Install
```
npm install --save actionbuffer
```

## Usage
```javascript
var ActionBuffer = require('actionbuffer');
var buffer = new ActionBuffer((items)=> {
    console.log(items.join('-'))
}, 100); // Set timeout to 100 (default: 1000)

buffer.push('abc');
buffer.push('123');
setTimeout(()=> {
    buffer.push('def');
}, 15)
setTimeout(()=> {
    buffer.push('456');
}, 35)


// After 100ms --------------------------
"abc-123-def-456" // <- console
```


## API
#### `ActionBuffer(callback[, timeout])`
Creates a new `ActionBuffer` instance. The provided callback will be invoked after a timeout with the queued elements passed as the 1st argument. Timeout argument is optional and defaults to `ActionBuffer.timeoutDefault`.

#### `ActionBuffer.timeoutDefault = 1000`
The default value that will be used as the timeout for `ActionBuffer` instances with no timeout specified. Defaults to 1000ms.

#### `actionBuffer.push(data)`
Push data elements into the buffer. The callback timer will begin counting down if the buffer was empty prior to adding the new data element.

#### `actionBuffer.run()`
Manually depelete the current buffer and invoke the provided callback with the buffer's elements. This method is the method that gets automatically invoked after the buffer's timeout ends. The buffer will now have 0 elements and will await new data elements before starting the timeout again.

#### `actionBuffer.stop()`
Halt the current timer (if any), empty out the buffer, and dismantle the instance entirely. After this call, the buffer deactivates and will not accept data elements anymore.




License
-------
MIT
