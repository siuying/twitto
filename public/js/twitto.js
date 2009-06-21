var TwitTo = {
  url: "",
  remain: 140,
  output: "",

  init: function() {
    this.url = $("#url").val()
    TwitTo.remain = TwitTo.countRemain(this.url, $("#action").val(), $("#message").val())
    $("#remainCount").text(TwitTo.remain);
  },

  countRemain: function(url, action, message) {
    return 140 - url.length - action.length - message.length - 3;
  },

  onMessageUpdated: function(e) {
    var url = TwitTo.url
    var action = $("#action").val()
    var msg = $("#message").val()
    
    TwitTo.output = [action, msg, ' (', url, ')'].join('');
    TwitTo.remain = TwitTo.countRemain(url, action, msg);

    if (TwitTo.remain < 0) {
      var msg_short = msg.substring(0, msg.length + TwitTo.remain)
      TwitTo.output = [action, msg_short, ' (', url, ')'].join('')
    }

    $("#remainCount").text(TwitTo.remain)
    if (TwitTo.remain < 0) {
      $("#remainCount").css("color", "red")
    } else {
      $("#remainCount").css("color", "")
    }
  },

  buildActions: function() {
    var actionHtml = [];
    for (var a in actions) {
        var action = actions[a];
        actionHtml.push("<option value='" + action + "'>" + action + ": </option>");
    }
    $(actionHtml.join('')).appendTo("#action");
  }
};
