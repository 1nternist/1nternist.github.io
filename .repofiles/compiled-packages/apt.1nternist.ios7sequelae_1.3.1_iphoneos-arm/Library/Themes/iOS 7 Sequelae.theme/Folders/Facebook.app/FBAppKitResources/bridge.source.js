/**
 * JavaScript to be used with the simple JavaScript->native bridge
 * included in Wilde v1 for Mobile Canvas support.
 *
 * @provides wilde-mobile-canvas-bridge
 */

// The only thing this code actually exposes in the global namespace
// is window.__fbNative; scroll to the bottom to see the explicit
// export.
//
// WARNING: Wilde injects a local copy of this file! Don't expect your
// changes in the www tree to affect the app unless you've recompiled it!
(function() {
  if (window.__fbNative) {
    return;
  }

  var Bridge = {
    _iframe: null,

    // Method is an Objective-C selector name
    // and parameters must be an array of strings (all current methods
    // use strings, and technical details of Objective-C make it
    // easier to check argument types if we don't have to do with more
    // than one of strings, dictionaries, and arrays).
    callNative: function(method, parameters) {
      // Make a new iframe for this call.
      if (Bridge._iframe) {
        document.body.removeChild(Bridge._iframe);
      }
      var iframe = document.createElement('iframe');
      iframe.style.width = iframe.style.height = '1px';
      iframe.style.position = 'absolute';
      iframe.style.borderStyle = 'none';

      // Coerce undefined parameters to null.
      for (var ii = 0; ii < parameters.length; ++ii) {
        if (typeof parameters[ii] === 'undefined') {
          parameters[ii] = null;
        }
      }

      // Assemble the call URL.
      var call = {
        method: method,
        parameters: parameters || []
      };

      var href = 'fbrpc://call?payload=' +
        encodeURIComponent(JSON.stringify(call));

      // Insert the new iframe.
      iframe.src = href;
      document.body.appendChild(iframe);
      Bridge._iframe = iframe;
    }
  };

  var FB_RPC_PREFIX = 'FB_RPC:';

  var _dispatchMessageEventWithData = function(data) {
    var ev = document.createEvent('Event');
    ev.initEvent('message', true, false); // Bubbles, can't be cancelled.
    ev.data = FB_RPC_PREFIX + JSON.stringify(data);
    document.dispatchEvent(ev);
  };

  // Supported RPCs.
  var rpcs = {
    'dialog.open': function(params) {
      var wid = 'fbwid_' + ('' + Math.random()).substr(2);
      Bridge.callNative('openURL:windowID:', [params.url, wid]);
      return wid;
    },

    'dialog.close': function(params) {
      Bridge.callNative('closeWindowWithID:', [params.wid]);
      return null;
    },

    'dialog.postMessage': function(params) {
      Bridge.callNative('postMessage:targetOrigin:windowID:',
                        [params.message, params.targetOrigin, params.wid]);
      return null;
    },

    'toolbar.setCancelAction': function(params) {
      Bridge.callNative('setCancelAction:handleCancelEvent:',
                        [params.label, params.handleCancelEvent]);
      return null;
    }
  };

 var fbNative = {
    // Send a JSON-RPC message to the native application via the
    // native bridge transport layer.
    //
    // rpc_s is a JSON-encoded JSON-RPC object, prefixed with
    // FB_RPC_PREFIX. See http://jsonrpc.org/specification for
    // the format and semantics.
    //
    // Returns false if there was an error parsing or dispatching the
    // message itself, true otherwise.
    //
    // TODO(#1008855): support batching.
    invoke: function(rpc_s) {
      if (typeof rpc_s !== 'string' || rpc_s.indexOf(FB_RPC_PREFIX) !== 0) {
        return false;
      }

      var rpc = JSON.parse(rpc_s.substr(FB_RPC_PREFIX.length));

      if (rpc.jsonrpc !== '2.0') {
        return false;
      }

      var impl = rpcs[rpc.method];

      if (!impl) {
        return false;
      }

      var result = impl(rpc.params);

      // RPCs are synchronous for now, so fire the callback.
      if ('id' in rpc) {
        _dispatchMessageEventWithData({id: rpc.id,
                                       jsonrpc: '2.0',
                                       result: result,
                                       error: null});
      }
      return true;
    },

    getFeatures: function() {
      // Map feature name to version.
      return {dialog: 1};
    },

    // Pre-RPC compatibility functions.
    open: function(url) {
      var wid = rpcs['dialog.open']({url:url});
      var dialog = window.__fbNative.dialog = {
        close: function() {
          window.__fbNative.close(wid);
          this.closed = true;
        },
        closed: false,
        postMessage: function(message, targetOrigin) {
          window.__fbNative.postMessage(message, targetOrigin, wid);
        }
      };
      return dialog;
    },

    close: function(wid) {
      rpcs['dialog.close']({wid:wid});
    },

    postMessage: function(message, targetOrigin, wid) {
      rpcs['dialog.postMessage'](
        {
          message: message,
          targetOrigin: targetOrigin,
          wid: wid
        }
      );
    },

    setCancelAction: function(label, handleCancelEvent) {
      rpcs['toolbar.setCancelAction'](
        {
          label: label,
          handleCancelEvent: handleCancelEvent
        }
      );
    }
  };

  window.__fbNative = fbNative;
}());
