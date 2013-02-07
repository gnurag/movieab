document.write("<style type='text/css'>.cbw{ padding: 1px; border: 1px solid #b6b6b6; margin: .6em 0 .6em 0 !important; clear: both;} .cbw a{ color: #3F87BB !important; border: 0 !important; text-decoration: none !important;} .cbw a:hover{ color: #165d91 !important; border: 0 !important; text-decoration: none !important;} .cbw_header{ font-size: .9em; font-weight: bold; position: relative;} .cbw_header_text{ background: #f4f4f4 !important; padding: 1em 1em 1em 1em !important;} .cbw_header_toggle{ display: block; position: absolute; top: 1em; right: 1em; _right: 3.5em; font-weight: bold; cursor: pointer;} .cbw_header_get{ display: block; position: absolute; top: 1em; right: 7em; _right: 9.5em; font-weight: bold; cursor: pointer;} .cbw_subheader{ padding: .7em .7em .5em .7em !important; border: 0 !important; margin: 0 !important; font-size: 1.2em !important; background: #f4f4f4 !important; font-weight: bold;} .cbw_subcontent{ font-size: 0.95em; line-height: 1.2em !important; margin: .15em 0 .15em 0 !important; padding: .7em !important; background: white !important; border-top: 2px solid #f4f4f4 !important; border-bottom: 2px solid #f9f9f9 !important; overflow: hidden; height: auto;} .cbw_subcontent p{ margin: .45em .15em .45em .15em !important; padding: 0 !important;} .cbw_subcontent_left{ float: right !important; margin: 0 0 .5em .5em !important;} .cbw img{ max-width: 150px !important; max-height: 150px !important; border: 0 !important; padding: 0 !important;} .cbw img:hover, .cbw_subcontent_left a:hover{ border: 0 !important;} .cbw_subcontent_right{ } .cbw_subcontent table{ width: auto !important;} .cbw_subcontent td{ padding: .15em !important; vertical-align: top !important;} .cbw_subcontent .td_left{ width: 40px !important; font-weight: bold !important;} .cbw_footer{ padding: .8em !important; font-size: .9em !important; text-align: right !important; background: #f9f9f9 !important;} .cbw_footer a{ font-weight: bold; }</style>")

function crunchbase_toggle(start)
{
  var date = new Date();
  date.setTime(date.getTime()+(30*24*60*60*1000));
  var expires = "; expires="+date.toGMTString();

  var content = getNextSibling(start.parentNode);
  var header_text = getNextSibling(start);

  if(start.innerHTML == 'maximize')
  {
    content.style.display = 'block';
    start.innerHTML = 'minimize';
		header_text.style.display = 'none';
    document.cookie = "crunchbase_widget=true"+expires+"; path=/";
  }
  else
  {
    content.style.display = 'none';
    start.innerHTML = 'maximize';
		header_text.style.display = 'block';
    document.cookie = "crunchbase_widget=false"+expires+"; path=/";
  }
}

function getNextSibling(n){	
  var x=n.nextSibling;
  while(x.nodeType!=1){
    x=x.nextSibling;
  }
  return x;
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) {
      return c.substring(nameEQ.length,c.length);
    }
  }
  return null;
}

var crunchbase_widget = readCookie('crunchbase_widget');
if(crunchbase_widget == 'false')
{
  document.write('<style type=\"text/css\"> .cbw_content { display: none; } </style>' + '<a class="cbw_header_toggle" onClick="crunchbase_toggle(this)">maximize</a>');
}
else
{
  document.write('<style type=\"text/css\"> .cbw_header_text { display: none; } </style>' + '<a href="http://www.movieab.com/info/widget" class="cbw_header_get">get widget</a><a class="cbw_header_toggle" onClick="crunchbase_toggle(this)">minimize</a>');
}