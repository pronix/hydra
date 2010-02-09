$(function(){

function js_link_to_content(url,el) {
    var dialog = $(el).parents("div.ui-dialog-content");
    var _url = url.split('?')
        _url = [[_url[0],'js'].join('.'),_url[1]].join('?')
        $(dialog).load(_url);
    return false;


  };


function js_link(url,dialog){
    $(dialog).load(url+'.js', function(data) {

        var options = { resizable: false,    modal: true, zIndex: 3000,
                        close: function(event, ui) { $(dialog).remove(); },
                        width: $(window).width()-100,
                        height: $(window).height()-100    };

        if ($(data).find("form").length == 0) {
          options.buttons =  { "Refresh": function() {  js_link(url,dialog);   } };
        };

        $(dialog).dialog(options);
      });
    return false;


  };


   $(document).click(function(e){
      var el = $(e.target);

      if ($(el).is("a") && $(el).hasClass("js_link")){
         var dialog = $("<div></div>").insertAfter('.content');
         js_link($(el).attr('href'), dialog);
         return false;
      } else if ($(el).is("a") && $(el).hasClass("js_link_to_content") ) {
         js_link_to_content($(el).attr('href'),el);
         return false;
      } else {
         return true; };
   });

});

