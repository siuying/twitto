var TwitTo = {};

TwitTo.buildActions = function(actions) {
    var actionHtml = [];
    for (var a in actions) {
        var action = actions[a];
        actionHtml.push("<option value='" + action + ": '>" + action + ": </option>");
    }
    $(actionHtml.join('')).appendTo("#action");;
}
