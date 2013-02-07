/**
 * @projectDescription Script for handling dvd stash related events.
 */

/**
 * Function to process response received from the server
 */
function process(data) {
    $("#watchlistmsg").html("Added to your stash");
}

/**
 * When the document is completely loaded, add listeners.
 */

$(document).ready(function() {
    $("#watchlist").change(function() {
	$.post("/users/0/stashes.json",
	    {title_id: $("#title_id").val(),
	    stash_id: $("#watchlist").val()},
	       function(data) {
		   process(data);
	       });
    });
});
