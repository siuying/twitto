var TwitTo = {};

TwitTo.buildAction = function(actions) {
    var actionHtml = [];
    for (var a in actions) {
        var action = actions[a];
        console.log(action);
        actionHtml.push("<option value='" + action + ": '>" + action + ": </option>");
    }
    
    $(actionHtml.join('')).appendTo("#action");;
}


