/** 
 * JQuery autocomplete library.
 * Ref: http://www.devbridge.com/projects/autocomplete/jquery/
 */

var options, a;
jQuery(function(){
    options = { serviceUrl: '/autocomplete.json',
                minChars: 2,
                zIndex: 9999,
                deferRequestBy: 100,
                onSelect: function(value, data){
        document.location.href = data;
      }
    };
    a = $('#query').autocomplete(options);
  });
