var TwitTo = {
  url: "",
  remain: 140,
  output: "",
  actions: [],
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
    var actions = this.actions;
    var actionHtml = [];
    for (var a in actions) {
        var action = actions[a][1];
        var isFav  = actions[a][2]; 
        if (isFav) {
            actionHtml.push("<option selected value='" + action + "'>" + action + "</option>");
        } else {
            actionHtml.push("<option value='" + action + "'>" + action + "</option>");
        }
    }
    $("#action").html("");
    $(actionHtml.join('')).appendTo("#action");
  },

  removeAction: function(id) {
    var remove_id = id
    var isNotRemove = function(action) {
       return (remove_id != action[0]);
    }
    this.actions = this.actions.filter(isNotRemove);
  },

  fave: function(fave_id) {
    var actions = this.actions;
    for (var a in actions) {
        var aid = actions[a][0];
        if (aid == fave_id) {
          actions[a][2] = true;
        } else {
          actions[a][2] = false;
        }
    }
  }
};
