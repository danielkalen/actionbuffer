var ActionBuffer;

ActionBuffer = (function() {
  ActionBuffer.timeoutDefault = 1e3;

  ActionBuffer.buffers = [];

  function ActionBuffer(callback, timeout) {
    if (this.constructor !== ActionBuffer) {
      return new ActionBuffer(callback, timeout);
    }
    this.timeout = timeout || ActionBuffer.timeoutDefault;
    this._buffer = [];
    if (typeof callback === 'function') {
      this.callback = callback;
    } else {
      throw new Error("Invalid callback provided '" + (String(this.callback)) + "'");
    }
  }

  ActionBuffer.prototype.push = function(data) {
    if (!this.stopped) {
      this._buffer.push(data);
      if (this._buffer.length === 1) {
        return this.start();
      }
    }
  };

  ActionBuffer.prototype.run = function() {
    var buffer;
    if (this._buffer.length) {
      buffer = this._buffer.slice();
      this._buffer.length = 0;
      return this.callback(buffer);
    }
  };

  ActionBuffer.prototype.start = function() {
    if (!(this.timer || this.stopped)) {
      return this.timer = setTimeout((function(_this) {
        return function() {
          _this.run();
          return delete _this.timer;
        };
      })(this), this.timeout);
    }
  };

  ActionBuffer.prototype.stop = function() {
    if (!this.stopped) {
      this.stopped = true;
      this._buffer.length = 0;
      clearTimeout(this.timer);
      delete this.timer;
      delete this.callback;
      ActionBuffer.buffers.splice(ActionBuffer.buffers.indexOf(this), -1);
    }
  };

  return ActionBuffer;

})();

module.exports = ActionBuffer;
